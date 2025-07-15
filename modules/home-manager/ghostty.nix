{...}: {...}: {
  programs.ghostty = {
    clearDefaultKeybinds = true;
    settings = {
      focus-follows-mouse = true;
      quick-terminal-position = "bottom";
      quick-terminal-autohide = false;
      keybind = [
        # Tabs
        "ctrl+tab=next_tab"
        "ctrl+shift+tab=previous_tab"

        "alt+one=goto_tab:1"
        "alt+two=goto_tab:2"
        "alt+three=goto_tab:3"
        "alt+four=goto_tab:4"
        "alt+five=goto_tab:5"
        "alt+six=goto_tab:6"
        "alt+seven=goto_tab:7"
        "alt+eight=goto_tab:8"
        "alt+nine=last_tab"

        # Splits
        "ctrl+shift+x=new_split:right"
        "ctrl+shift+s=new_split:down"

        "ctrl+shift+k=goto_split:up"
        "ctrl+shift+j=goto_split:down"
        "ctrl+shift+h=goto_split:left"
        "ctrl+shift+l=goto_split:right"

        "ctrl+shift+up=resize_split:up,10"
        "ctrl+shift+down=resize_split:down,10"
        "ctrl+shift+left=resize_split:left,10"
        "ctrl+shift+right=resize_split:right,10"
        "ctrl+shift+plus=equalize_splits"
        "ctrl+shift+enter=toggle_split_zoom"

        # Window
        "page_up=scroll_page_up"
        "page_down=scroll_page_down"
        "shift+page_down=jump_to_prompt:1"
        "shift+page_up=jump_to_prompt:-1"
        "ctrl+home=scroll_to_top"
        "ctrl+end=scroll_to_bottom"

        "ctrl+minus=decrease_font_size:1"
        "ctrl+equal=increase_font_size:1"
        "ctrl+zero=reset_font_size"

        "shift+up=adjust_selection:up"
        "shift+down=adjust_selection:down"
        "shift+left=adjust_selection:left"
        "shift+right=adjust_selection:right"

        "ctrl+shift+a=select_all"
        "ctrl+shift+c=copy_to_clipboard"
        "ctrl+shift+v=paste_from_clipboard"
        "ctrl+shift+e=copy_url_to_clipboard"

        "ctrl+alt+shift+j=write_screen_file:open"
        "ctrl+shift+j=write_screen_file:paste"

        # General
        "ctrl+shift+n=new_window"
        "ctrl+shift+t=new_tab"
        "ctrl+shift+w=close_tab"
        "ctrl+shift+comma=reload_config"
        "ctrl+shift+r=reset"
        "ctrl+shift+i=inspector:toggle"

        "global:cmd+grave_accent=toggle_quick_terminal"
      ];
    };
  };
}
