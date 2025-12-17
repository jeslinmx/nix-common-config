_: {lib, ...}: {
  vim.utility.snacks-nvim = {
    enable = true;
    setupOpts = {
      dashboard = {
        pane_gap = 2;
        sections = let
          in_git = lib.generators.mkLuaInline ''
            function()
              return require("snacks").git.get_root() ~= nil
            end
          '';

          git_section_cfg = {
            pane = 2;
            section = "terminal";
            enabled = in_git;
            padding = 1;
            ttl = 5 * 60;
            indent = 3;
          };
        in [
          {
            text = {
              hl = "NonText";
              "@" = ''
                ▄                 ▄
                █▀▀▄ ▄▀▀█ █▀▀▄ █▀▀█
                █  █ █░░█ █  █ █░░█
                ▀  ▀ ▀▀▀▀ ▀  ▀ ▀▀▀▀
              '';
            };
            align = "right";
            padding = 2;
          }
          {
            text = {
              hl = "Folded";
              "@" = ''
                             ▄
                █▀▀▀ █▀▀█ █▀▀█ █▀▀█
                █░░░ █░░█ █░░█ █▀▀▀
                ▀▀▀▀ ▀▀▀▀ ▀▀▀▀ ▀▀▀▀
              '';
            };
            align = "left";
            pane = 2;
            padding = 2;
          }
          {
            section = "keys";
            gap = 1;
            padding = 1;
          }
          {
            icon = " ";
            title = "Recent Files";
            section = "recent_files";
            indent = 2;
            padding = 1;
            limit = 10;
            cwd = true;
          }
          {
            icon = " ";
            title = "Projects";
            section = "projects";
            indent = 2;
            padding = 1;
          }
          {
            pane = 2;
            icon = " ";
            desc = "Browse Repo";
            padding = 1;
            enabled = in_git;
            key = "b";
            action = lib.generators.mkLuaInline ''
              function()
                require("snacks").gitbrowse()
              end
            '';
          }
          (git_section_cfg
            // {
              icon = " ";
              title = "Git Status";
              cmd = "git status --short --branch --renames";
              height = 5;
            })
          (git_section_cfg
            // {
              icon = " ";
              title = "Open PRs";
              cmd = "PAGER= gh pr list -L 3";
              key = "p";
              action = lib.generators.mkLuaInline ''
                function()
                  vim.fn.jobstart("gh pr list --web", { detach = true })
                end
              '';
              height = 3;
            })
          (git_section_cfg
            // {
              title = "Open Issues";
              cmd = "PAGER= gh issue list -L 3";
              key = "i";
              action = lib.generators.mkLuaInline ''
                function()
                  vim.fn.jobstart("gh issue list --web", { detach = true })
                end
              '';
              icon = " ";
              height = 3;
            })
          (git_section_cfg
            // {
              title = "Github Notifications";
              cmd = "gh notify -s -a -n 5";
              action = lib.generators.mkLuaInline ''
                function()
                  vim.ui.open "https://github.com/notifications"
                end
              '';
              key = "n";
              icon = " ";
              height = 5;
              enabled = true;
            })
        ];
        preset = {
          keys = [
            {
              icon = " ";
              key = "e";
              desc = "Empty buffer";
              action = ":ene";
            }
            {
              icon = " ";
              key = "s";
              desc = "Restore session";
              section = "session";
            }

            {
              icon = " ";
              key = "c";
              desc = "CodeCompanion";
              action = ":CodeCompanionActions";
            }
            {
              icon = "󰐻 ";
              key = "M";
              desc = "MCP Hub";
              action = ":MCPHub";
            }
          ];
        };
      };
    };
  };
  vim.keymaps = let
    inherit (lib.nvim.binds) mkKeymap;
  in [
    (mkKeymap ["n" "v"] "<leader><leader>" "Snacks.dashboard.open" {
      desc = "Open dashboard";
      lua = true;
    })
  ];
}
