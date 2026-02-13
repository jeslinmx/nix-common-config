_: {
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkMerge [
    {
      server.caddy = {
        proxy.enable = false;
        backup.enable = false;
        sopsKeys = {
          cloudflareApiToken = lib.mkDefault "";
        };
      };
    }
    {
      services.caddy = {
        enable =
          config.server
          |> builtins.attrValues
          |> builtins.any (service: service.proxy.enable);
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
    }
    (lib.mkIf config.services.caddy.enable {
      # get cloudflare api token from sops
      systemd.services.caddy.serviceConfig.EnvironmentFile = config.sops.templates.caddyEnvFile.path;
      sops.templates.caddyEnvFile.content = "CF_API_TOKEN=${config.server.caddy.sopsPlaceholders.cloudflareApiToken}";
      # open firewall
      networking.firewall.allowedTCPPorts = [80 443];
      # increase socket buffer size for quic-go
      boot.kernel.sysctl = {
        "net.core.rmem_max" = 7500000;
        "net.core.wmem_max" = 7500000;
      };
    })
  ];
}
