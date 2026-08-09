{
  flake,
  pkgs,
  ...
}: {
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes" "pipe-operators"];
      trusted-users = ["root" "@wheel" "@admin"];
    };
    optimise.automatic = true;
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
    nixPath = builtins.attrValues (builtins.mapAttrs (name: path: "${name}=${path}") (flake.inputs // {nix-common-config = flake.outPath;}));
  };
  environment.systemPackages = [pkgs.git]; # required for flakes
}
