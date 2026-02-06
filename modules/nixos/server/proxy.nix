_: {
  config,
  lib,
  pkgs,
  ...
}: {
  config = {
    services.caddy = {
      enable = true;
      package = pkgs.caddy.withPlugins {
        plugins = ["github.com/caddy-dns/cloudflare@v0.2.2"];
        hash = "sha256-dnhEjopeA0UiI+XVYHYpsjcEI6Y1Hacbi28hVKYQURg=";
      };
      # for testing
      # acmeCA = "https://acme-staging-v02.api.letsencrypt.org/directory";
      enableReload = false; # since admin API is disabled
      globalConfig = ''
        admin off
        grace_period 10s
        acme_dns cloudflare {env.CF_API_TOKEN}
        servers {
          metrics
        }
      '';
    };
    # trigger caddy restart on re-config
    systemd.services.caddy.restartTriggers = [config.services.caddy.configFile];
    # get cloudflare api token from sops
    systemd.services.caddy.serviceConfig.EnvironmentFile = config.sops.templates.caddy-envFile.path;
    # open firewall
    networking.firewall.allowedTCPPorts = [80 443];
    # increase socket buffer size for quic-go
    boot.kernel.sysctl = {
      "net.core.rmem_max" = 7500000;
      "net.core.wmem_max" = 7500000;
    };
  };
}
