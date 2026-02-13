_: {
  config,
  lib,
  ...
}: {
  options.backups.restic = with lib.types; let
    inherit (lib) mkOption;
  in {
    repositories = mkOption {
      description = "Configs of repositories to backup each service to";
      type = attrsOf (attrsOf anything);
      default = {};
    };
    services = mkOption {
      description = "Configs of services to backup to each repository";
      type = attrsOf (attrsOf anything);
      default = {};
    };
    common = mkOption {
      description = "Config to apply to all backup jobs";
      type = attrsOf anything;
      default = {};
    };
    obfuscateServiceNames = mkOption {
      description = "Hash all service names in the repository paths";
      type = boolByOr;
      default = false;
    };
  };

  config.services.restic.backups = let
    inherit (lib) attrsToList cartesianProduct mkMerge mkOverride;
    cfg = config.backups.restic;
  in
    {
      r = attrsToList cfg.repositories;
      s = attrsToList cfg.services;
    }
    |> cartesianProduct
    |> map (
      {
        r,
        s,
      }: {
        name = "${r.name}-${s.name}";
        value =
          cfg.common
          // r.value
          // s.value
          // {
            repository = "${r.value.repository}/${
              if cfg.obfuscateServiceNames
              then s.name |> builtins.hashString "sha256"
              else s.name
            }";
          };
      }
    )
    |> builtins.listToAttrs;
}
