_: {
  config,
  pkgs,
  ...
}: {
  stylix.icons = {
    dark = "Colloid-Dark";
    light = "Colloid-Light";
    package = pkgs.colloid-icon-theme;
  };
  stylix.targets.neovim.enable = false;
  gtk.iconTheme = {
    name = config.stylix.icons.${config.stylix.polarity};
    inherit (config.stylix.icons) package;
  };
  fonts.fontconfig = {
    enable = true;
    defaultFonts = let
      inherit (config.stylix.fonts) sansSerif serif monospace;
    in {
      sansSerif = [sansSerif.name];
      serif = [serif.name];
      monospace = [monospace.name "Symbols Nerd Font Mono"];
      emoji = ["Blobmoji"];
    };
  };
}
