_: {lib, ...}: {
  vim.statusline.lualine = {
    enable = true;
    theme = "base16";
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
    inactiveSection = {
    };
  };
}
