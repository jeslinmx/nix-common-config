{inputs, ...}: _: {
  imports = builtins.attrValues {
    inherit (inputs.dank-material-shell.nixosModules) dank-material-shell greeter;
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
