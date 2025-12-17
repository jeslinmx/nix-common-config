_: {lib, ...}: {
  vim.utility.snacks-nvim = {
    enable = true;
    setupOpts = {
      explorer = {replace_netrw = true;};
      picker = {
        sources = {
          git_log = {layout = "bottom";};
          git_log_line = {layout = "bottom";};
          git_log_file = {layout = "bottom";};
          git_branches = {layout = "dropdown";};
          git_files = {
            layout = "sidebar";
            finder = "explorer";
          };
          diagnostics = {layout = "ivy_split";};
          diagnostics_buffer = {layout = "ivy_split";};
          lsp_definitions = {layout = "dropdown";};
          lsp_declarations = {layout = "dropdown";};
          lsp_implementations = {layout = "dropdown";};
          lsp_references = {layout = "dropdown";};
          lsp_symbols = {layout = "dropdown";};
          lsp_type_definitions = {layout = "dropdown";};
          commands = {layout = "vscode";};
          keymaps = {layout = {preview = false;};};
          undo = {
            layout = "dropdown";
            sort = {fields = ["idx"];};
          };
          explorer = {};
          filetypes = {
            name = "filetypes";
            format = "text";
            preview = "none";
            layout = {preset = "vscode";};
            confirm = lib.generators.mkLuaInline ''
              function(picker, item)
                picker:close()
                if item then
                  vim.schedule(function()
                    vim.cmd("setfiletype " .. item.text)
                  end)
                end
              end
            '';
            finder = lib.generators.mkLuaInline ''
              function()
                local items = {}
                local filetypes = vim.fn.getcompletion("", "filetype")
                for _, type in ipairs(filetypes) do
                  items[#items + 1] = {
                    text = type;
                  }
                end
                return items
              end
            '';
          };
        };
        layouts = {
          default = {
            layout = {
              backdrop = false;
              box = "horizontal";
              width = 0.8;
              min_width = 120;
              height = 0.8;
              "@1" = {
                box = "vertical";
                "@1" = {
                  win = "input";
                  title = "{title} {live} {flags}";
                  border = ["╭" "─" "┬" "│" "┤" "─" "├" "│"];
                  height = 1;
                };
                "@2" = {
                  win = "list";
                  border = ["" "" "" "╎" "┴" "─" "╰" "│"];
                };
              };
              "@2" = {
                win = "preview";
                title = "{preview}";
                border = ["" "─" "╮" "│" "╯" "─" "" ""];
                width = 0.5;
              };
            };
          };
          dropdown = {
            preset = "vertical";
            layout = {
              backdrop = false;
              row = 1;
              width = 0.4;
              min_width = 80;
              height = 0.8;
              box = "vertical";
              "@1" = {
                win = "input";
                height = 1;
                border = ["╭" "─" "╮" "│" "┤" "─" "├" "│"];
                title = "{title} {live} {flags}";
              };
              "@2" = {
                win = "list";
                border = ["" "" "" "│" "" "" "" "│"];
              };
              "@3" = {
                win = "preview";
                title = "{preview}";
                height = 0.4;
                border = ["├" "╌" "┤" "│" "╯" "─" "╰" "│"];
              };
            };
          };
          ivy = {
            layout = {
              box = "vertical";
              backdrop = false;
              row = -1;
              width = 0;
              height = 0.4;
              border = "top";
              title = " {title} {live} {flags}";
              title_pos = "left";
              "@1" = {
                win = "input";
                height = 1;
              };
              "@2" = {
                box = "horizontal";
                "@1" = {
                  win = "list";
                  border = ["" "─" "┬" "╎" "╎" "" "" ""];
                };
                "@2" = {
                  win = "preview";
                  title = "{preview}";
                  width = 0.6;
                  border = ["" "─" "" "" "" "" "" ""];
                };
              };
            };
          };
          select = {
            hidden = ["preview"];
            layout = {
              backdrop = false;
              width = 0.5;
              min_width = 80;
              max_width = 100;
              height = 0.4;
              min_height = 2;
              box = "vertical";
              "@1" = {
                win = "input";
                title = "{title}";
                height = 1;
                border = ["╭" "─" "╮" "│" "┤" "─" "├" "│"];
              };
              "@2" = {
                win = "list";
                border = ["" "" "" "│" "╯" "─" "╰" "│"];
              };
            };
          };
          vertical = {
            layout = {
              backdrop = false;
              width = 0.5;
              min_width = 80;
              height = 0.8;
              min_height = 30;
              box = "vertical";
              "@1" = {
                win = "input";
                height = 1;
                border = ["╭" "─" "╮" "│" "┤" "─" "├" "│"];
                title = "{title} {live} {flags}";
              };
              "@2" = {
                win = "list";
                border = ["" "" "" "│" "" "" "" "│"];
              };
              "@3" = {
                win = "preview";
                title = "{preview}";
                height = 0.4;
                border = ["├" "╌" "┤" "│" "╯" "─" "╰" "│"];
              };
            };
          };
          telescope = {reverse = false;};
          vscode = {
            layout = {
              backdrop = true;
              row = 1;
              width = 0.4;
              min_width = 80;
              height = 0.4;
              border = "none";
              box = "vertical";
              "@1" = {
                win = "input";
                height = 1;
                border = "solid";
                title = "{title} {live} {flags}";
              };
              "@2" = {
                win = "list";
                border = "hpad";
              };
              "@3" = {
                win = "preview";
                title = "{preview}";
                border = true;
              };
            };
          };
        };
      };
    };
  };
  vim.keymaps = let
    picker = key: command: desc: (lib.nvim.binds.mkKeymap ["n" "v"] "<leader>${key}" command {
      inherit desc;
      lua = true;
    });
    explorer_opts = ''
      focus = "input",
      auto_close = true,
      layout = { preview = "main" },
      win = {
        input = {
          keys = {
            ["<cr>"] = { { "pick_win", "jump" }, mode = { "n", "i" } },
            ["<s-cr>"] = { "confirm", mode = { "n", "i" } },
          },
        },
      }
    '';
  in [
    (picker "a" "Snacks.picker.autocmds" "autocmds")
    (picker "bb" "Snacks.picker.buffers" "picker")
    (picker "c" "Snacks.picker.colorschemes" "colorschemes")
    (picker "d" "Snacks.picker.diagnostics_buffer" "diagnostics (buffer)")
    (picker "D" "Snacks.picker.diagnostics" "diagnostics (project)")
    (picker "e" "Snacks.explorer.open" "Toggle explorer sidebar")
    (picker "f" ''function() Snacks.picker.explorer({${explorer_opts}}) end'' "files")
    (picker "F" ''function() Snacks.picker.explorer({${explorer_opts}, hidden = true, ignored = true}) end'' "all files")
    (picker "gb" "Snacks.picker.git_log_line" "blame line")
    (picker "gB" "Snacks.picker.git_branches" "branches")
    (picker "gf" "Snacks.picker.git_files" "files")
    (picker "g/" "Snacks.picker.git_grep" "grep")
    (picker "gl" "Snacks.picker.git_log_file" "log")
    (picker "gL" "Snacks.picker.git_log" "repo log")
    (picker "gs" "Snacks.picker.git_status" "status")
    (picker "gS" "Snacks.picker.git_stash" "stash")
    (picker "gp" "Snacks.picker.gh_pr" " pull requests")
    (picker "gi" "Snacks.picker.gh_issue" " issues")
    (picker "h" "Snacks.picker.highlights" "highlights")
    (picker "i" "Snacks.picker.icons" "icons")
    (picker "j" "Snacks.picker.jumps" "jumps")
    (picker "k" "Snacks.picker.keymaps" "keymaps")
    (picker "lc" "Snacks.picker.lsp_config" "config")
    (picker "ld" "Snacks.picker.lsp_definitions" "definitions")
    (picker "lD" "Snacks.picker.lsp_declarations" "declarations")
    (picker "li" "Snacks.picker.lsp_implementations" "implementations")
    (picker "lr" "Snacks.picker.lsp_references" "references")
    (picker "ls" "Snacks.picker.lsp_symbols" "symbols")
    (picker "lt" "Snacks.picker.lsp_type_definitions" "type definitions")
    (picker "m" "Snacks.picker.man" "man")
    (picker "n" ''function() require("noice").cmd("snacks") end'' "notifications")
    (picker "o" "Snacks.picker.resume" "open last picker")
    (picker "p" "Snacks.picker.projects" "projects")
    (picker "Pa" "Snacks.picker.picker_actions" "picker actions")
    (picker "Pf" "Snacks.picker.picker_format" "picker format")
    (picker "Pl" "Snacks.picker.picker_layouts" "picker layouts")
    (picker "Pp" "Snacks.picker.pickers" "pickers")
    # q
    (picker "r" "Snacks.picker.recent" "recent")
    (picker "s" "Snacks.picker.spelling" "spelling")
    (picker "t" "Snacks.picker.filetypes" "filetypes")
    (picker "T" "Snacks.picker.treesitter" "treesitter")
    (picker "u" "Snacks.picker.undo" "undo")
    (picker "v" "Snacks.picker.cliphist" "cliphist")
    # w
    # x
    # y
    (picker "z" "Snacks.picker.zoxide" "zoxide")
    (picker "\"" "Snacks.picker.registers" "registers")
    (picker "'" "Snacks.picker.marks" "marks")
    (picker "." "Snacks.picker.qflist" "quickfixes")
    (picker "/" "Snacks.picker.grep" "grep")
    (picker "?" "Snacks.picker.help" "help")
    (picker "-" "Snacks.picker.explorer" "explorer")
    (picker ":" "Snacks.picker.command_history" "command history")
  ];
}
