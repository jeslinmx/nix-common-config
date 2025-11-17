_: {
  config,
  pkgs,
  ...
}: {
  programs.neovim = {
    viAlias = true;
    vimAlias = true;
    extraLuaConfig =
      (
        if builtins.hasAttr "stylix" config
        then
          (with config.lib.stylix.colors.withHashtag; ''
            _G.palette = {
              base00 = '${base00}', base01 = '${base01}', base02 = '${base02}', base03 = '${base03}',
              base04 = '${base04}', base05 = '${base05}', base06 = '${base06}', base07 = '${base07}',
              base08 = '${base08}', base09 = '${base09}', base0A = '${base0A}', base0B = '${base0B}',
              base0C = '${base0C}', base0D = '${base0D}', base0E = '${base0E}', base0F = '${base0F}'
            }
            _G.config_is_hm = true
          '')
        else ""
      )
      + builtins.readFile ./init.lua;
    extraPackages = builtins.attrValues {
      inherit
        (pkgs)
        bc # for coq_3p
        postgresql # for dadbod
        python311 # also for pylsp obviously
        # bashls
        bash-language-server
        # gopls
        gopls
        # luals
        lua-language-server
        stylua
        # nixd
        nixd
        alejandra
        # jsonls
        vscode-langservers-extracted
        # yamlls
        yaml-language-server
        # js(x)/ts(x)
        typescript-language-server
        prettierd
        tailwindcss-language-server
        emmet-language-server
        superhtml
        ;
      inherit (pkgs.python312Packages) python-lsp-server;
    };
  };
  home = {
    packages = with pkgs; [
      (writeShellApplication {
        name = "v";
        runtimeInputs = [neovim-remote config.programs.neovim.finalPackage];
        text = "if [ -v NVIM ]; then nvr -l \"$@\"; else \${NVR_CMD:-nvim} \"$@\"; fi";
      })
    ];
    sessionVariables = rec {
      EDITOR = "v --remote-wait";
      VISUAL = EDITOR;
      MANPAGER = "v -c 'Man!'";
    };
  };
  xdg.configFile = {
    "nvim/lua".source = ./lua;
    "nvim/after".source = ./after;
    "nvim-testing".source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/nix-config/nix-common-config/modules/home-manager/neovim";
  };
}
