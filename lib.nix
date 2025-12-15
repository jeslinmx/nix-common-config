{
  nixpkgs,
  nix-darwin,
  ...
}: let
  lib = nixpkgs.lib;
in rec {
  dirToAttrs = path:
    lib.pipe path [
      builtins.readDir
      (builtins.mapAttrs (
        name: type: let
          fullPath = /${path}/${name};
        in
          if type == "directory"
          then dirToAttrs fullPath
          else fullPath
      ))
    ];

  filterNonNix = lib.filterAttrsRecursive (_: v: !(builtins.isPath v) || lib.hasSuffix ".nix" "${v}");

  filterEmptySubdirs = lib.filterAttrsRecursive (_: v: builtins.isPath v || builtins.length (builtins.attrNames v) != 0);

  flattenAttrs = let
    recurse = sep: prefix:
      lib.foldlAttrs (
        acc: n: v: let
          fullPath = builtins.concatStringsSep sep (prefix ++ [n]);
        in
          acc
          // (
            if builtins.isPath v
            then {${fullPath} = v;}
            else recurse sep [fullPath] v
          )
      ) {};
  in
    sep: recurse sep [];
  truncateSuffix = lib.mapAttrs' (n: v: lib.nameValuePair (lib.pipe n [(lib.removeSuffix ".nix") (lib.removeSuffix "-default")]) v);

  gatherModules = flake:
    lib.flip lib.pipe [
      dirToAttrs
      filterNonNix
      filterEmptySubdirs
      (flattenAttrs "-")
      truncateSuffix
      (builtins.mapAttrs (_: import))
      (builtins.mapAttrs (_: v: v flake))
    ];

  mkDarwinConfigurations = outerFlake:
    builtins.mapAttrs (name: v:
      nix-darwin.lib.darwinSystem {
        modules = [
          {
            networking.hostName = name;
            nix.nixPath = ["nix-config=${outerFlake.outPath}"];
          }
          ((import v) outerFlake)
        ];
      });

  mkNixosConfigurations = outerFlake:
    builtins.mapAttrs (name: v:
      lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          {
            networking.hostName = name;
            nix.nixPath = ["nix-config=${outerFlake.outPath}"];
          }
          ((import v) outerFlake)
        ];
      });
}
