{
  inputs,
  outPath,
  ...
}: {pkgs, ...}: {
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["root" "@wheel" "@admin"];
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
