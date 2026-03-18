{
  inputs,
  outPath,
  ...
}: {pkgs, ...}: {
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes" "pipe-operators"];
      trusted-users = ["root" "@wheel" "@admin"];
      trusted-substituters = [
        "https://nvf.cachix.org/"
        "https://colmena.cachix.org"
      ];
      trusted-public-keys = [
        "nvf.cachix.org-1:GMQWiUhZ6ux9D5CvFFMwnc2nFrUHTeGaXRlVBXo+naI="
        "colmena.cachix.org-1:7BzpDnjjH8ki2CT3f6GdOk7QAzPOl+1t3LvTLXqYcSg="
      ];
    };
    optimise.automatic = true;
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
    nixPath = builtins.attrValues (builtins.mapAttrs (name: path: "${name}=${path}") (inputs // {nix-common-config = outPath;}));
  };
  environment.systemPackages = [pkgs.git]; # required for flakes
}
