{homeModules, ...}: {
  lib,
  pkgs,
  ...
}: {
  imports = builtins.attrValues {
    inherit (homeModules) firefox ghostty;
  };

  programs = lib.mkDefault {
    firefox.enable = true;
    ghostty.enable = true;
  };

  services.flatpak = {
    update = {
      auto = {
        enable = true;
        onCalendar = "weekly";
      };
    };
    overrides.global = {
      Context = {
        sockets = ["wayland" "session-bus"];
        filesystems = [
          "~/.icons:ro"
        ];
      };
      Environment = {
        # Fix un-themed cursor in some Wayland apps
        XCURSOR_PATH = "/run/host/user-share/icons:/run/host/share/icons";
      };
    };
  };

  # unnixed stuff
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      wl-clipboard
      # virt-manager
      clapper
      loupe
      zathura
      ;
    inherit (pkgs.pantheon) elementary-files;
  };
}
