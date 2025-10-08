_: {
  lib,
  pkgs,
  ...
}: let
  PAGER = "bat";
  EDITOR = "nvr -sl"; # TODO: override nvr default behaviour of placing $NVIM at /tmp/nvimsocket, so running nvim outside of nvim always starts a new instance; nvr -sl --servername $NVIM works within nvim but fails if $NVIM is not set (instead of falling back to default neovim behavior of generating something under /run)
  MANPAGER = "${EDITOR} -c 'Man!' --remote";
in {
  home = {
    packages = with pkgs; [neovim-remote bat kjv];
    sessionVariables = {
      inherit PAGER MANPAGER;
      EDITOR = lib.mkForce EDITOR;
      VISUAL = EDITOR;
    };
  };
  programs.fish = {
    shellAbbrs = {
      g = "git";
      v = EDITOR;
      vi = EDITOR;
      vc = "nvim leetcode";
      S = "sudo -v; sudo -E";
      sshe = "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null";
      t = "tmux new-session -A -s 0";
      "/" = "grep";
      lg = "lazygit";
      dc = "docker compose";
    };
    functions = {
      l = "for arg in $argv; ${PAGER} $arg || ll $arg; end";
      y = ''
        set tmp (mktemp -t "yazi-cwd.XXXXX")
        yazi --cwd-file="$tmp" $argv
        if set cwd (cat -- "$tmp") && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]
            cd -- "$cwd"
        end
        rm -f -- "$tmp"
      '';
      fzfkjv = ''
        fzf --query "$argv" \
          --disabled --no-sort --multi --no-header --no-keep-right --layout=reverse-list --prompt "kjv " \
          --bind "start:reload(kjv {q}),change:reload(kjv {q})" \
          --preview "awk -F '  ' '{print \$2}' {+f}" --preview-window "down,wrap"
      '';
      fzftar = ''
        tar -tf "$argv" \
        | grep -e '[^/]$' \
        | fzf --multi --prompt=' ' --print0 \
          --preview="tar -xf \"$argv\" --to-stdout {} | bat --file-name \"{}\" --color=always --style=numbers,rule,snip" \
        | xargs --null --no-run-if-empty tar -xOf $argv
      '';
      multicd = "echo (string repeat -n (math (string length -- $argv[1]) - 1) ../)";
      last_history = "echo $history[1]";
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

      abbr -a .. --position anywhere -r '^\.\.+$' -f multicd
      abbr -a !! --position anywhere -f last_history
    '';
  };
}
