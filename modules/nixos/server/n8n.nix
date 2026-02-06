_: {
  config,
  lib,
  ...
}: {
  options.server.n8n = {
    uri = lib.mkOption {type = lib.types.str;};
  };
  config = {
    services.n8n = {
      enable = true;
      environment = {
        # https://docs.n8n.io/hosting/configuration/environment-variables/
        N8N_PORT = 5678;
        N8N_VERSION_NOTIFICATIONS_ENABLED = true;
      };
    };

    services.caddy.proxyUpstreams.${config.server.n8n.uri} = "localhost:${config.services.n8n.environment.N8N_PORT}";
    backups.restic.services.n8n = {
      paths = [config.services.n8n.environment.N8N_USER_FOLDER];
      backupPrepareCommand = "systemctl stop n8n.service";
      backupCleanupCommand = "systemctl start n8n.service";
    };
  };
}
