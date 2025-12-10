{homeModules, ...}: {pkgs, ...}: {
  imports = builtins.attrValues {
    inherit
      (homeModules)
      asciinema
      atuin
      comma
      fish
      fzf
      git
      lazygit
      neovim
      ssh
      starship
      # termshark
      tmux
      yazi
      ;
  };

  programs = {
    home-manager.enable = true;
    carapace.enable = true;
    pandoc.enable = true;
    pay-respects.enable = true;
    bat.enable = true;
    btop.enable = true;
    zoxide.enable = true;
    eza = {
      enable = true;
      git = true;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    tealdeer = {
      enable = true;
      settings.updates.auto_update = true;
    };
    ripgrep = {
      enable = true;
      arguments = [
        "--smart-case"
        "--follow" # symlinks
        "--glob=!.git/*"
      ];
    };
    gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
      };
      extensions = builtins.attrValues {
        inherit (pkgs) gh-notify gh-dash;
      };
    };
    # configured in dedicated modules
    atuin.enable = true;
    fish.enable = true;
    fzf.enable = true;
    git.enable = true;
    helix.enable = true;
    lazygit.enable = true;
    neovim.enable = true;
    ssh.enable = true;
    starship.enable = true;
    tmux.enable = true;
    yazi.enable = true;
  };

  home = {
    # unnixed stuff
    packages = with pkgs; [
      kjv
      fd
      dig
      lazydocker
      ouch
      visidata
      httpie
      dust
      hyperfine
      tokei
      wiki-tui
      mask
      jq
      gojq
      yq
      fx
      magic-wormhole-rs
      (writeShellApplication {
        name = "l";
        text = ''
          for ARG in "$@"; do
            if [ -d "$ARG" ]; then eza -l "$ARG";
            else $PAGER "$ARG"; fi
          done
        '';
      })
      (writeShellApplication {
        name = "fzfkjv";
        text = ''
          fzf --query "$*" \
            --disabled --no-sort --multi --no-header --no-keep-right --layout=reverse-list --prompt "kjv " \
            --bind "start:reload(kjv {q}),change:reload(kjv {q})" \
            --preview "awk -F '  ' '{print \$2}' {+f}" --preview-window "down,wrap"
        '';
      })
      (writeShellApplication {
        name = "fzftar";
        text = ''
          tar -tf "$@" \
          | grep -e '[^/]$' \
          | fzf --multi --prompt=' ' --print0 \
            --preview="tar -xf \"$*\" --to-stdout {} | bat --file-name \"{}\" --color=always --style=numbers,rule,snip" \
          | xargs --null --no-run-if-empty tar -xOf "$@"
        '';
      })
    ];
    sessionVariables = {PAGER = "bat";};
    file = {
      ".config/lazydocker/config.yml".source = pkgs.writers.writeYAML "config.yml" {
        commandTemplates = {
          dockerCompose = "podman compose";
        };
      };
    };
  };
}
