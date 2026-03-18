{nixosModules, ...}: {config, ...}: {
  imports = builtins.attrValues {
    inherit (nixosModules) server-gitea-ssh server-gitea-theme;
  };
  server.gitea = {
    proxy.upstream = "${config.services.gitea.settings.server.HTTP_ADDR}:${toString config.services.gitea.settings.server.HTTP_PORT}";
    backup.paths = [config.services.gitea.stateDir];
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
        LANDING_PAGE = "login";
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
      service = {
        DISABLE_REGISTRATION = true;
        ENABLE_OPENID_SIGNUP = true;
        ENABLE_BASIC_AUTHENTICATION = false;
        ENABLE_PASSWORD_SIGNIN_FORM = false;
        ENABLE_PASSKEY_AUTHENTICATION = false;
        REQUIRE_SIGNIN_VIEW = true;
      };
      session.COOKIE_SECURE = true;
    };
    database = {
      type = "sqlite3";
      createDatabase = true;
    };
  };
}
