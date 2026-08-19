{
  flake,
  pkgs,
  ...
}: {
  # # for bootstrapping rosetta-builder
  # nix.linux-builder = {
  #   enable = true;
  #   ephemeral = true;
  # };

  imports = [flake.inputs.nix-rosetta-builder.darwinModules.default];
  nix-rosetta-builder = {
    enable = pkgs.stdenv.hostPlatform.isAarch;
    onDemand = true;
    onDemandLingerMinutes = 60;
  };
}
