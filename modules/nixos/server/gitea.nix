_: {
  config,
  lib,
  pkgs,
  ...
}: {
  services.gitea = {
    enable = true;
    appName = "Gitea";
    settings = rec {
      server = {
        DOMAIN = "gt.app.jesl.in";
        ROOT_URL = "https://${server.DOMAIN}";
        HTTP_ADDR = "127.0.0.1";
        HTTP_PORT = 3001;
        SSH_CREATE_AUTHORIZED_KEYS_FILE = true;
      };
      repository = {
        ACCESS_CONTROL_ALLOW_ORIGIN = server.ROOT_URL;
        ENABLE_PUSH_CREATE_USER = true;
        ENABLE_PUSH_CREATE_ORG = true;
        DEFAULT_PUSH_CREATE_PRIVATE = true;
      };
      cors = {
        ALLOW_DOMAIN = server.ROOT_URL;
      };
      ui = {
        DEFAULT_THEME = "catppuccin-green-auto";
        THEMES = lib.pipe ["rosewater" "flamingo" "pink" "mauve" "red" "maroon" "peach" "yellow" "green" "teal" "sky" "sapphire" "blue" "lavender"] [
          (map (x: "catppuccin-${x}-auto"))
          (builtins.concatStringsSep ",")
        ];
      };
      service.DISABLE_REGISTRATION = true;
      session.COOKIE_SECURE = true;
    };
    database = {
      type = "sqlite3";
      createDatabase = true;
    };
  };
  services.caddy.proxiedServices.${config.services.gitea.settings.server.ROOT_URL} = "${config.services.gitea.settings.server.HTTP_ADDR}:${toString config.services.gitea.settings.server.HTTP_PORT}";
  services.openssh.authorizedKeysFiles = ["${config.services.gitea.stateDir}/.ssh/authorized_keys"]; # allow git operations over ssh

  systemd.services.gitea.serviceConfig.BindReadOnlyPaths = let
    catppuccin = pkgs.fetchzip {
      url = "https://github.com/catppuccin/gitea/releases/download/v1.0.2/catppuccin-gitea.tar.gz";
      stripRoot = false;
      hash = "sha256-rZHLORwLUfIFcB6K9yhrzr+UwdPNQVSadsw6rg8Q7gs=";
    };
  in ["${catppuccin}:${config.services.gitea.customDir}/public/assets/css"];

  backups.restic.services.gitea = let
    giteaCfg = config.services.gitea;
    dumpDir = giteaCfg.dump.backupDir;
  in {
    paths = [dumpDir];
    backupPrepareCommand = let
      sudo = lib.getExe pkgs.sudo;
      gitea = lib.getExe giteaCfg.package;
      inherit (giteaCfg) user customDir;
    in ''
      ${sudo} -u ${user} mkdir -p ${dumpDir}
      ${sudo} -u ${user} ${gitea} dump -c ${customDir}/conf/app.ini --type tar --file ${dumpDir}/gitea-dump.tar
    '';
    backupCleanupCommand = ''
      rm -rf ${dumpDir}
    '';
  };
}
