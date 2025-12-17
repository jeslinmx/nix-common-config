_: {
  config,
  lib,
  ...
}: {
  vim.mini.tabline = {
    enable = true;
    setupOpts = {
      tabpage_section = "right";
      format = lib.generators.mkLuaInline ''
        function(buf_id, label)
          local levels = { vim.diagnostic.severity.WARN, vim.diagnostic.severity.ERROR }
          local icons = { [vim.diagnostic.severity.WARN] = "", [vim.diagnostic.severity.ERROR] = "" }
          local diag = vim.diagnostic.count(buf_id, { severity = levels })
          local t = {
            MiniTabline.default_format(buf_id, label)
          }
          for level, icon in ipairs(icons) do
            local n = diag[level] or 0
            if n > 0 then
              table.insert(t, icon)
              table.insert(t, n)
            end
          end
          return " " .. table.concat(t, " ") .. " "
        end
      '';
    };
  };
  vim.highlight = let
    inherit (config.vim.theme.base16-colors) base00 base01 base02 base03 base04 base05 base0D;
  in rec {
    MiniTablineHidden = {
      fg = base04;
      bg = base01;
      sp = base0D;
    };
    MiniTablineVisible = MiniTablineHidden // {fg = base05;};
    MiniTablineCurrent = MiniTablineVisible // {underline = true;};
    MiniTablineModifiedHidden =
      MiniTablineHidden
      // {
        bg = base02;
        bold = true;
      };
    MiniTablineModifiedVisible =
      MiniTablineVisible
      // {
        bg = base02;
        bold = true;
      };
    MiniTablineModifiedCurrent =
      MiniTablineCurrent
      // {
        bg = base02;
        bold = true;
      };
    MiniTablineFill = MiniTablineHidden;
  };
}
