_: {lib, ...}: let
  inherit (lib.generators) mkLuaInline;
in {
  vim.mini = {
    extra.enable = true;
    ai = {
      enable = true;
      setupOpts.custom_textobjects = mkLuaInline ''
        (function()
          local spec = require("mini.extra").gen_ai_spec
          return {
            B = spec.buffer(),
            D = spec.diagnostic(),
            I = spec.indent(),
            L = spec.line(),
            N = spec.number(),
          }
        end)()
      '';
    };
    cursorword.enable = true;
    hipatterns = {
      enable = true;
      setupOpts = {
        hex_color = mkLuaInline ''require("mini.hipatterns").gen_highlighter.hex_color()'';
        fixme = {
          pattern = "%f[%w]()FIXME()%f[%W]";
          group = "MiniHipatternsFixme";
        };
        hack = {
          pattern = "%f[%w]()HACK()%f[%W]";
          group = "MiniHipatternsHack";
        };
        todo = {
          pattern = "%f[%w]()TODO()%f[%W]";
          group = "MiniHipatternsTodo";
        };
        note = {
          pattern = "%f[%w]()NOTE()%f[%W]";
          group = "MiniHipatternsNote";
        };
      };
    };
    operators = {
      enable = true;
      setupOpts = {sort.prefix = "gS";};
    };
    surround = {
      enable = true;
      setupOpts = {
        mappings = {
          add = "ys";
          delete = "ds";
          find = "";
          find_left = "";
          highlight = "";
          replace = "cs";
          update_n_lines = "";
          suffix_last = "";
          suffix_next = "";
        };
        search_method = "cover_or_next";
      };
    };
    trailspace.enable = true;
  };
  vim.highlight = {
    # use bold instead of underline for cursorword
    MiniCursorword.bold = true;
    MiniCursorwordCurrent.link = "MiniCursorword";
  };
}
