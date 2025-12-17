_: {lib, ...}: {
  vim = let
    augroup = "numbertoggle";
  in {
    augroups = [{name = augroup;}];
    autocmds = [
      {
        desc = "Relative line numbers outside of insert mode";
        event = ["BufEnter" "FocusGained" "InsertLeave" "CmdlineLeave" "WinEnter"];
        pattern = ["*"];
        group = augroup;
        callback = lib.generators.mkLuaInline ''
           function()
            if vim.o.nu and vim.api.nvim_get_mode().mode ~= "i" then
              vim.opt.relativenumber = true
            end
          end
        '';
      }
      {
        desc = "Absolute line numbers in insert mode";
        event = ["BufLeave" "FocusLost" "InsertEnter" "CmdlineEnter" "WinLeave"];
        pattern = ["*"];
        group = augroup;
        callback = lib.generators.mkLuaInline ''
           function()
            if vim.o.nu then
              vim.opt.relativenumber = false
              vim.cmd "redraw"
            end
          end
        '';
      }
    ];
  };
}
