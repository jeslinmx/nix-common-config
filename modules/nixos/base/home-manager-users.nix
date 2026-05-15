{inputs, ...}: {
  config,
  lib,
  options,
  ...
}: {
  imports = [inputs.home-manager.nixosModules.home-manager];

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
          initialHashedPassword = lib.mkDefault "";
          isNormalUser = lib.mkDefault true;
          group = lib.mkIf config.users.users.${name}.isNormalUser (lib.mkOverride 900 name);
        };
      }));
      default = {};
    };
  };

  config = let
    cfg = config.hmUsers;
  in {
    users = {
      mutableUsers = true;
      users = builtins.mapAttrs (_: userCfg: removeAttrs userCfg ["hmConfig" "hmModules"]) cfg;
      groups = builtins.mapAttrs (name: _:
        lib.mkIf config.users.users.${name}.isNormalUser {})
      cfg;
    };
    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
      backupFileExtension = "hmbak";
      users =
        builtins.mapAttrs (
          _: {
            hmConfig,
            hmModules,
            ...
          }: {
            imports = hmModules ++ [hmConfig];
            home.stateVersion = lib.mkDefault (config.system.stateVersion or "24.05");
          }
        )
        cfg;
    };
  };
}
