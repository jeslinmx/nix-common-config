{nixosModules, ...}: {
  config,
  lib,
  ...
}: {
  imports = [nixosModules.server-common];

  server.pocket-id = {
    proxy.upstream = "unix/${config.services.pocket-id.settings.UNIX_SOCKET}";
    backup.paths = [config.services.pocket-id.dataDir];
    sopsKeys = {
      encryptionKey = lib.mkDefault "";
      maxmindLicenseKey = lib.mkDefault "";
    };
  };

  services.pocket-id = {
    settings = {
      # https://pocket-id.org/docs/configuration/environment-variables
      APP_URL = "https://${config.server.pocket-id.proxy.address}";
      TRUST_PROXY = true;
      UNIX_SOCKET = "${config.services.pocket-id.dataDir}/pocket-id.sock";
      METRICS_ENABLED = true;
      OTEL_METRICS_EXPORTER = "prometheus";
      OTEL_EXPORTER_PROMETHEUS_HOST = "localhost";
      OTEL_EXPORTER_PROMETHEUS_PORT = "9464";
    };
    credentials = {
      ENCRYPTION_KEY = config.server.pocket-id.secrets.encryptionKey.path;
      MAXMIND_LICENSE_KEY = config.server.pocket-id.secrets.maxmindLicenseKey.path;
    };
  };
  # allow caddy to connect to socket
  users.users.${config.services.caddy.user}.extraGroups = [config.services.pocket-id.group];
  systemd.services.caddy.serviceConfig.ReadWritePaths = [config.services.pocket-id.settings.UNIX_SOCKET];
  services.pocket-id.settings.UNIX_SOCKET_MODE = "770";
}
