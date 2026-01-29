_: {
  config,
  pkgs,
  ...
}: {
  services.netdata = {
    enable = true;
    package = pkgs.netdataCloud;
    enableAnalyticsReporting = false;
    config = {
      web = {
        "allow connections from" = "localhost fcc5:ae24:cb*";
        "allow dashboard from" = "localhost";
        "allow management from" = "localhost";
        "allow netdata.conf" = "localhost";
        "default port" = 19999;
      };
    };
    configDir = {
      "stream.conf" = config.sops.templates.netdata_stream_conf.path;
    };
  };

  services.caddy.proxiedServices."nd.app.jesl.in" = "localhost:19999";
  networking.firewall.allowedTCPPorts = [19999]; # for streaming

  sops = {
    secrets = {
      "netdata/jam-pve" = {};
    };
    templates.netdata_stream_conf = {
      inherit (config.services.netdata) group;
      mode = "0440";
      restartUnits = ["netdata.service"];
      content = let
        inherit (config.sops) placeholder;
        mkChildCfg = apiKey: ''
          [${apiKey}]
            type = api
            enabled = yes
            allow from = fcc5:ae24:cb*
        '';
      in
        builtins.concatStringsSep "\n" (
          [
            ''
              [stream]
                enabled = no
                enable compression = yes
            ''
          ]
          ++ (map mkChildCfg [placeholder."netdata/jam-pve"])
        );
    };
  };
}
