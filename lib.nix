lib: rec {
  dirToAttrs = let
    recurse = path:
      path
      |> lib.readDir
      |> lib.mapAttrs (
        name: type: let
          fullPath = "${path}/${name}";
        in
          if type == "directory"
          then recurse fullPath
          else fullPath
      );
  in
    recurse;

  filterNonNix = lib.filterAttrsRecursive (_: v: lib.isAttrs v || lib.hasSuffix ".nix" "${v}");

  filterEmptySubdirs = lib.filterAttrsRecursive (_: v: !(lib.isAttrs v) || lib.length (lib.attrNames v) != 0);

  flattenAttrs = let
    recurse = sep: prefix:
      lib.foldlAttrs (
        acc: n: v: let
          fullPath = lib.concatStringsSep sep (prefix ++ [n]);
        in
          acc
          // (
            if lib.isAttrs v
            then recurse sep [fullPath] v
            else {${fullPath} = v;}
          )
      ) {};
  in
    sep: recurse sep [];

  truncateSuffix = lib.mapAttrs' (rawName: value: {
    name =
      rawName
      |> lib.removeSuffix ".nix"
      |> lib.removeSuffix "-default";
    inherit value;
  });

  injectExtraArgs = extraArgs:
    lib.mapAttrs (_: path: let
      mod = import path;
    in
      if lib.isFunction mod
      then let
        modArgs = lib.functionArgs mod;
        subArgs = lib.filterAttrs (name: _: lib.hasAttr name modArgs) extraArgs;
        left = lib.removeAttrs modArgs (lib.attrNames subArgs);
        func = args: mod (args // subArgs);
      in
        lib.setDefaultModuleLocation path (lib.setFunctionArgs func left)
      else path);

  gatherModules = extraArgs: path:
    path
    |> dirToAttrs
    |> filterNonNix
    |> filterEmptySubdirs
    |> flattenAttrs "-"
    |> truncateSuffix
    |> injectExtraArgs extraArgs;
}
