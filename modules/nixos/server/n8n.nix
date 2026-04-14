_: {config, ...}: {
  server.n8n = {
    proxy.upstream = "${config.services.n8n.environment.N8N_HOST}:${config.services.n8n.environment.N8N_PORT}";
    backup.paths = [config.services.n8n.environment.N8N_USER_FOLDER];
  };

  services.n8n = {
    enable = true;
    environment = {
      # https://docs.n8n.io/hosting/configuration/environment-variables/
      N8N_HOST = "localhost";
      N8N_PORT = 5678;
      N8N_VERSION_NOTIFICATIONS_ENABLED = true;
      N8N_METRICS = true;
    };
  };
}
