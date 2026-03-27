{inputs, ...}: {pkgs, ...}: {
  imports = [inputs.nix-rosetta-builder.darwinModules.default];

  # # for bootstrapping rosetta-builder
  # nix.linux-builder = {
  #   enable = true;
  #   ephemeral = true;
  # };

  nix-rosetta-builder = {
    enable = pkgs.stdenv.hostPlatform.system == "aarch64-darwin";
    onDemand = true;
    onDemandLingerMinutes = 60;
  };
}
