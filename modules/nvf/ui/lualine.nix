{
  config,
  lib,
  ...
}: {
  vim.statusline.lualine = rec {
    enable = true;
    setupOpts = {
      sections = {
        lualine_a = ["mode"];
        lualine_b = ["branch" "diff"];
        lualine_c = [
          {
            "@1" = "filetype";
            icon_only = true;
            padding = {left = 2;};
          }
          {
            "@1" = "filename";
            newfile_status = true;
            path = 1;
            symbols = {
              modified = "󰏫";
              readonly = "󰌾";
              unnamed = "";
              newfile = "󰎜";
            };
          }
          {
            "@1" = "fileformat";
            symbols = {unix = "";};
          }
          {
            "@1" = "vim.bo.fileencoding == 'utf-8' and \"\" or vim.bo.fileencoding";
            type = "lua_expr";
          }
          "filesize"
        ];
        lualine_x = [];
        lualine_y = ["lsp_status" "diagnostics"];
        lualine_z = lib.mkForce [
          {
            "@1" = "%l/%L:%c";
            type = "stl";
          }
        ];
      };
      inactive_sections =
        setupOpts.sections
        // {
          lualine_a = [];
          lualine_b = ["diff"];
          lualine_y = setupOpts.sections.lualine_z;
          lualine_z = [];
        };
      options.theme = let
        inherit (config.vim.theme.base16-colors) base00 base01 base02 base04 base05 base09 base0A base0C base0D base0E;
      in rec {
        normal = {
          a = {
            fg = base00;
            bg = base05;
            gui = "bold";
          };
          b = {
            fg = base05;
            bg = base02;
          };
          c = {
            fg = base04;
            bg = base01;
          };
        };
        insert.a = normal.a // {bg = base0D;};
        visual.a = normal.a // {bg = base0C;};
        replace.a = normal.a // {bg = base0E;};
        command.a = normal.a // {bg = base09;};
        terminal.a = normal.a // {bg = base0A;};
        inactive.a = normal.b;
      };
      options.section_separators = {
        left = "";
        right = "";
      };
    };
  };
}
