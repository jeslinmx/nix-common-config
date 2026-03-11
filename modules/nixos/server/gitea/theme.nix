_: {
  config,
  lib,
  pkgs,
  ...
}: {
  services.gitea.settings.ui = {
    DEFAULT_THEME = "catppuccin-green-auto";
    THEMES = lib.pipe ["rosewater" "flamingo" "pink" "mauve" "red" "maroon" "peach" "yellow" "green" "teal" "sky" "sapphire" "blue" "lavender"] [
      (map (x: "catppuccin-${x}-auto"))
      (builtins.concatStringsSep ",")
    ];
  };
  systemd.services.gitea.serviceConfig.BindReadOnlyPaths = let
    catppuccin = pkgs.fetchzip {
      url = "https://github.com/catppuccin/gitea/releases/download/v1.0.2/catppuccin-gitea.tar.gz";
      stripRoot = false;
      hash = "sha256-rZHLORwLUfIFcB6K9yhrzr+UwdPNQVSadsw6rg8Q7gs=";
    };
  in ["${catppuccin}:${config.services.gitea.customDir}/public/assets/css"];
}
