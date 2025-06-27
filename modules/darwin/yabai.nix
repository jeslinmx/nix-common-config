{...}: {...}: {
  system.defaults = {
    spaces = {
      spans-displays = false;
    };
  };

  services = {
    yabai = {
      enable = true;
      config = {
        layout = "bsp";
        top_padding = 8;
        bottom_padding = 8;
        left_padding = 8;
        right_padding = 8;
        window_gap = 8;
        auto_balance = "on";
        focus_follows_mouse = "autofocus";
        mouse_follows_focus = "on";
      };
    };
    skhd = {
      enable = true;
      skhdConfig = ''
        fn - h : yabai -m window --focus west
        fn - j : yabai -m window --focus south
        fn - k : yabai -m window --focus north
        fn - l : yabai -m window --focus east
        fn + shift - h : yabai -m window --warp west
        fn + shift - j : yabai -m window --warp south
        fn + shift - k : yabai -m window --warp north
        fn + shift - l : yabai -m window --warp east
        fn + alt - h : yabai -m window --swap west
        fn + alt - j : yabai -m window --swap south
        fn + alt - k : yabai -m window --swap north
        fn + alt - l : yabai -m window --swap east
        fn - 0x18 : yabai -m space --balance
        fn - g : yabai -m space --toggle gap && yabai -m space --toggle padding
        fn - z : yabai -m window --toggle zoom-parent
        fn - 0x32 : yabai -m window --toggle float
        fn - tab : yabai -m window --toggle split
        fn - 1 : yabai -m window --space 1
        fn - 2 : yabai -m window --space 2
        fn - 3 : yabai -m window --space 3
        fn - 4 : yabai -m window --space 4
        fn - 5 : yabai -m window --space 5
        fn - 6 : yabai -m window --space 6
        fn - 7 : yabai -m window --space 7
        fn - 8 : yabai -m window --space 8
        fn - 9 : yabai -m window --space 9
        fn - 0 : yabai -m window --space 10
        fn + ctrl - 1 : yabai -m window --space 1 --focus
        fn + ctrl - 2 : yabai -m window --space 2 --focus
        fn + ctrl - 3 : yabai -m window --space 3 --focus
        fn + ctrl - 4 : yabai -m window --space 4 --focus
        fn + ctrl - 5 : yabai -m window --space 5 --focus
        fn + ctrl - 6 : yabai -m window --space 6 --focus
        fn + ctrl - 7 : yabai -m window --space 7 --focus
        fn + ctrl - 8 : yabai -m window --space 8 --focus
        fn + ctrl - 9 : yabai -m window --space 9 --focus
        fn + ctrl - 0 : yabai -m window --space 10 --focus
      '';
    };
  };
}
