{flake, ...}: {
  imports = builtins.attrValues {
    inherit (flake.inputs.dank-material-shell.nixosModules) dank-material-shell greeter;
  };
  programs.dank-material-shell = {
    enable = true;
    greeter = {
      enable = true;
      compositor.name = "hyprland";
    };
  };
  programs.kdeconnect.enable = true;
}
