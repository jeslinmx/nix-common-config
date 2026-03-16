_: {...}: {
  programs.fish = {
    shellAbbrs = {
      g = "git";
      vc = "nvim leetcode";
      S = "sudo -v; sudo -E";
      sshe = "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null";
      t = "tmux new-session -A -s 0";
      "/" = "grep";
      lg = "lazygit";
      dc = "docker compose";
      ws = "wormhole-rs send";
      wr = "wormhole-rs receive";
      last_history = {
        regex = ''^!!+$'';
        position = "anywhere";
        function = "last_history";
      };
      dots = {
        position = "anywhere";
        regex = ''^\.\.+$'';
        function = "multicd";
      };
    };
    functions = {
      multicd = "echo (string repeat -n (math (string length -- $argv[1]) - 1) ../)";
      last_history = "echo $history[(math (string length -- $argv[1]) - 1)]";
    };
    interactiveShellInit = ''
      if [ $SHLVL -eq 1 ]
          function fish_greeting
          end
      else
          set fish_greeting ""
      end
      fish_add_path -p ~/.local/bin
      fish_default_key_bindings -M insert
      fish_vi_key_bindings --no-erase insert
      set fish_cursor_visual block
      set fish_cursor_insert line
      set fish_cursor_replace_one underscore
    '';
  };
}
