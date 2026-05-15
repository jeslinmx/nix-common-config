{inputs, ...}: {
  config,
  lib,
  options,
  ...
}: {
  imports = [inputs.home-manager.darwinModules.home-manager];

  options = let
    inherit (lib) types mkOption;
  in {
    hmUsers = mkOption {
      type = types.attrsOf (types.submodule ({name, ...}: {
        imports = options.users.users.type.getSubModules;
        options = {
          hmConfig = mkOption {
            type = types.deferredModule;
            default = {};
          };
          hmModules = mkOption {
            type = types.listOf types.deferredModule;
            default = [];
          };
        };
        config = {
          home = lib.mkDefault "/Users/${name}";
        };
      }));
      default = {};
    };
  };

  config = let
    cfg = config.hmUsers;
  in {
    users = {
      knownUsers = builtins.attrNames cfg;
      users = builtins.mapAttrs (_: userCfg: removeAttrs userCfg ["hmConfig" "hmModules"]) cfg;
    };
    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
      backupFileExtension = "hmbak";
      users =
        builtins.mapAttrs (
          name: {
            hmConfig,
            hmModules,
            ...
          }: {
            imports = hmModules ++ [hmConfig];
            home = {
              stateVersion = lib.mkDefault (config.system.stateVersion or "24.05");
              homeDirectory = lib.mkDefault "/Users/${name}";
            };
          }
        )
        cfg;
    };
  };
}
