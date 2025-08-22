{
  inputs,
  homeModules,
  ...
}: {pkgs, ...}: {
  imports = builtins.attrValues {
    inherit (homeModules) firefox kitty ghostty;
  };

  programs = {
    firefox.enable = true;
    kitty.enable = true;
    ghostty.enable = true;
    mangohud = {
      enable = true;
    };
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
  home.packages =
    builtins.attrValues {
      inherit
        (pkgs)
        wl-clipboard
        # virt-manager
        clapper
        loupe
        zathura
        ;
      inherit (pkgs.pantheon) elementary-files;
    }
    ++ [
      pkgs.pavucontrol
      (pkgs.pantheon.switchboard-with-plugs.override {
        plugs = builtins.attrValues {
          inherit
            (pkgs.pantheon)
            switchboard-plug-about
            # broken due to missing org.gnome.settings-daemon.plugins.media-keys schema
            # switchboard-plug-sound
            switchboard-plug-network
            switchboard-plug-printers
            # pulls in wingpanel indicator and thus all of gnome
            # switchboard-plug-bluetooth
            switchboard-plug-applications
            ;
        };
        useDefaultPlugs = false;
      })
    ];
}
