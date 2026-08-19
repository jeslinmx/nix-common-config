{
  flake,
  pkgs,
  ...
}: {
  imports = ["${flake.inputs.omniwm}/modules/home/omniwm.nix"];

  programs.omniwm = {
    enable = true;
    package = pkgs.callPackage "${flake.inputs.omniwm}/pkgs/omniwm.nix" {};
    settings = {};
  };
}
