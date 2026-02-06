_: {
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [./ssh.nix ./theme.nix];
  services.gitea = {
    enable = true;
    appName = "Gitea";
    settings = rec {
      server = {
        DOMAIN = config.services.caddy.proxyUris.gitea;
        ROOT_URL = "https://${server.DOMAIN}";
        HTTP_ADDR = "localhost";
        HTTP_PORT = 3001;
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
      service.DISABLE_REGISTRATION = true;
      session.COOKIE_SECURE = true;
    };
    database = {
      type = "sqlite3";
      createDatabase = true;
    };
  };

  services.caddy.proxyUpstreams.gitea = "${config.services.gitea.settings.server.HTTP_ADDR}:${toString config.services.gitea.settings.server.HTTP_PORT}";

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
