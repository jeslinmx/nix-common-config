{nixosModules, ...}: {config, ...}: {
  imports = builtins.attrValues {
    inherit (nixosModules) server-gitea-ssh server-gitea-theme;
  };
  server.gitea = {
    proxy.upstream = "${config.services.gitea.settings.server.HTTP_ADDR}:${toString config.services.gitea.settings.server.HTTP_PORT}";
    backup = {
      paths = [config.services.gitea.dump.backupDir];
      prepareCommand = "systemctl start gitea-dump.service";
      cleanupCommand = "rm ${config.services.gitea.dump.backupDir}/*";
    };
  };

  services.gitea = {
    enable = true;
    appName = "Gitea";
    settings = {
      server = {
        DOMAIN = config.server.gitea.proxy.address;
        ROOT_URL = "https://${config.server.gitea.proxy.address}";
        HTTP_ADDR = "localhost";
        HTTP_PORT = 3001;
      };
      repository = {
        ACCESS_CONTROL_ALLOW_ORIGIN = config.server.gitea.proxy.address;
        ENABLE_PUSH_CREATE_USER = true;
        ENABLE_PUSH_CREATE_ORG = true;
        DEFAULT_PUSH_CREATE_PRIVATE = true;
      };
      cors = {
        ALLOW_DOMAIN = config.server.gitea.proxy.address;
      };
      service.DISABLE_REGISTRATION = true;
      session.COOKIE_SECURE = true;
    };
    database = {
      type = "sqlite3";
      createDatabase = true;
    };
    dump = {
      enable = true;
      type = "tar.lz4";
    };
  };
  systemd.timers.gitea-dump.enable = false;
}
