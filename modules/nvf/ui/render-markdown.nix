_: {lib, ...}: {
  vim.languages.markdown.extensions.render-markdown-nvim = {
    enable = true;
    setupOpts = {
      file_types = ["markdown" "latex" "html" "codecompanion"];
      render_modes = ["n" "c" "t" "i"];
      heading = {
        icons = {};
        signs = ["󰲡 " "󰲣 " "󰲥 " "󰲧 " "󰲩 " "󰲫 "];
        width = "block";
        left_margin = 1;
        left_pad = 2;
        right_pad = 2;
        border = true;
      };
      code = {
        position = "right";
        width = "block";
        min_width = 50;
        left_margin = 1;
        left_pad = 2;
        right_pad = 2;
        inline_pad = 1;
        border = "thick";
      };
      bullet = {
        # disable normalizing of ordered list numbering
        ordered_icons = lib.generators.mkLuaInline ''
          function(ctx) return ctx.value end
        '';
      };
      pipe_table = {
        preset = "round";
      };
    };
  };
}
