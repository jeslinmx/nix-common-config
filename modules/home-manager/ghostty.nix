_: {
  config,
  lib,
  pkgs,
  ...
}: {
  programs.ghostty = {
    package = lib.mkIf pkgs.stdenv.isDarwin (lib.mkForce null);
    clearDefaultKeybinds = true;
    settings = {
      focus-follows-mouse = true;
      quick-terminal-position = "bottom";
      quick-terminal-autohide = false;
      keybind =
        {
          # Tabs
          "ctrl+tab" = "next_tab";
          "ctrl+shift+tab" = "previous_tab";

          "opt+one" = "goto_tab:1";
          "opt+two" = "goto_tab:2";
          "opt+three" = "goto_tab:3";
          "opt+four" = "goto_tab:4";
          "opt+five" = "goto_tab:5";
          "opt+six" = "goto_tab:6";
          "opt+seven" = "goto_tab:7";
          "opt+eight" = "goto_tab:8";
          "opt+nine" = "last_tab";

          # Splits
          "cmd+\\" = "new_split:right";
          "cmd+\"" = "new_split:down";

          "cmd+k" = "goto_split:up";
          "cmd+j" = "goto_split:down";
          "cmd+h" = "goto_split:left";
          "cmd+l" = "goto_split:right";

          "cmd+up" = "resize_split:up,10";
          "cmd+down" = "resize_split:down,10";
          "cmd+left" = "resize_split:left,10";
          "cmd+right" = "resize_split:right,10";
          "cmd+equal" = "equalize_splits";
          "cmd+enter" = "toggle_split_zoom";

          # Window
          "page_up" = "scroll_page_up";
          "page_down" = "scroll_page_down";
          "cmd+page_down" = "jump_to_prompt:1";
          "cmd+page_up" = "jump_to_prompt:-1";
          "cmd+home" = "scroll_to_top";
          "cmd+end" = "scroll_to_bottom";

          "ctrl+minus" = "decrease_font_size:1";
          "ctrl+equal" = "increase_font_size:1";
          "ctrl+zero" = "reset_font_size";

          "shift+up" = "adjust_selection:up";
          "shift+down" = "adjust_selection:down";
          "shift+left" = "adjust_selection:left";
          "shift+right" = "adjust_selection:right";

          # General
          "cmd+a" = "select_all";
          "cmd+c" = "copy_to_clipboard";
          "cmd+v" = "paste_from_clipboard";
          "cmd+e" = "copy_url_to_clipboard";
          "cmd+f" = "start_search";
          "cmd+p" = "toggle_command_palette";
          "cmd+n" = "new_window";
          "cmd+t" = "new_tab";
          "cmd+w" = "close_tab";
          "cmd+q" = "quit";
          "cmd+comma" = "reload_config";
          "cmd+s" = "write_screen_file:copy";
          "cmd+r" = "reset";
          "cmd+i" = "inspector:toggle";
        }
        |> lib.mapAttrsToList (
          trigger: action: let
            replaceMacModifiers =
              builtins.replaceStrings
              ["cmd" "opt"]
              ["ctrl+shift" "ctrl"];
          in "${
            if pkgs.stdenv.isDarwin
            then trigger
            else replaceMacModifiers trigger
          }=${action}"
        );
    };
  };

  xdg.terminal-exec = {
    enable = true;
    settings = {default = ["com.mitchellh.ghostty.desktop"];};
  };
  systemd.user.sessionVariables.TERMCMD = config.xdg.terminal-exec.package |> lib.getExe |> lib.mkDefault;
}
