_: {
  config,
  lib,
  ...
}: {
  vim.statusline.lualine = rec {
    enable = true;
    sectionSeparator = {
      left = "";
      right = "";
    };
    activeSection = {
      a = [
        ''{"mode"}'' # icons and colors, bold
      ];
      b = [
        ''{"branch"}''
        ''{"diff"}'' # live update without writing to disk
      ];
      c = [
        ''{"filetype", icon_only = true, padding = {left = 2}}''
        ''{"filename", newfile_status = true, path = 1, symbols = { modified = "󰏫", readonly = "󰌾", unnamed = "", newfile = "󰎜" }}''
        ''{"fileformat", symbols = { unix = "" }}''
        ''{"vim.bo.fileencoding == 'utf-8' and \"\" or vim.bo.fileencoding", type = "lua_expr"}''
        ''{"filesize"}''
      ];
      x = [];
      y = [
        # mcp
        ''{"lsp_status"}''
        ''{"diagnostics"}''
      ];
      z = lib.mkForce [
        ''{"%l %v", type = "stl"}'' # show total
      ];
    };
    inactiveSection =
      activeSection
      // {
        a = [];
        b = [''{"diff"}''];
        y = activeSection.z;
        z = [];
      };
    setupOpts.options.theme = let
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
  };
}
