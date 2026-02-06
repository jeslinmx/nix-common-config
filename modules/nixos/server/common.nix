{
  inputs,
  nixosModules,
  ...
}: {
  config,
  options,
  lib,
  ...
}: {
  imports = [nixosModules.server-restic-helper inputs.sops-nix.nixosModules.sops];

  options.server = with lib.types; let
    inherit (lib) mkOption mkEnableOption;
  in
    mkOption {
      type = attrsOf (submodule ({name, ...}: {
        options = {
          proxy = {
            enable = mkEnableOption "proxying through caddy" // {default = true;};
            address = mkOption {type = str;};
            upstream = mkOption {type = str;};
            extraConfig = mkOption {
              type = separatedString "\n";
              default = "";
            };
          };
          backup = {
            enable = mkEnableOption "backups through restic" // {default = true;};
            paths = mkOption {
              type = listOf externalPath;
              default = [];
            };
            systemdServiceName = mkOption {
              type = str;
              default = name;
            };
            prepareCommand = mkOption {
              type = nullOr str;
              default = null;
            };
            cleanupCommand = mkOption {
              type = nullOr str;
              default = null;
            };
          };
          sopsKeys = mkOption {type = attrsOf str;};
          secrets = mkOption {
            inherit (options.sops.secrets) type;
            readOnly = true;
            default = builtins.mapAttrs (_: key: config.sops.secrets.${key}) config.server.${name}.sopsKeys;
          };
        };
      }));
      default = {};
    };

  config = let
    cfg = config.server;
  in {
    # proxy config
    services =
      (lib.mapAttrs (_: _: {enable = true;}) cfg)
      // {
        caddy.virtualHosts = lib.mapAttrs (_: {proxy, ...}:
          lib.mkIf proxy.enable {
            hostName = proxy.address;
            extraConfig = ''
              reverse_proxy ${proxy.upstream} {
                ${proxy.extraConfig}
              }
              encode zstd gzip
            '';
          })
        cfg;
      };

    # backup config
    backups.restic.services = lib.mapAttrs (_: {backup, ...}:
      with backup;
        lib.mkIf backup.enable {
          inherit paths;
          backupPrepareCommand =
            if prepareCommand != null
            then prepareCommand
            else "systemctl stop ${systemdServiceName}.service";
          backupCleanupCommand =
            if cleanupCommand != null
            then cleanupCommand
            else "systemctl start ${systemdServiceName}.service";
        })
    config.server;

    # secrets config
    sops.secrets = (cfg |> lib.mapAttrsToList (_: {sopsKeys, ...}: builtins.attrValues sopsKeys) |> lib.flatten |> lib.genAttrs) (_: {});
  };
}
