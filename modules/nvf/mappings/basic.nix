_: {lib, ...}: {
  vim.mini.bufremove.enable = true;
  vim.keymaps = let
    inherit (lib.nvim.binds) mkKeymap;
  in [
    (mkKeymap ["c" "i"] "<C-a>" "<Home>" {desc = "move to beginning of line";})
    (mkKeymap ["c" "i"] "<C-e>" "<End>" {desc = "move to end of line";})

    (mkKeymap ["n" "i" "v"] "<C-s>" "<cmd>w<cr>" {desc = "general save file";})
    (mkKeymap ["n" "i"] "<C-c>" "<cmd>%y+<cr>" {desc = "copy whole file";})

    (mkKeymap ["i"] "jj" "<Esc>" {desc = "escape insert mode";})
    (mkKeymap ["n"] "<Esc>" "<cmd>noh<cr>" {desc = "clear highlights";})

    (mkKeymap ["n" "v"] "<tab>" "<cmd>bnext<cr>" {desc = "buffer goto next";})
    (mkKeymap ["n" "v"] "<S-tab>" "<cmd>bprev<cr>" {desc = "buffer goto prev";})
    (mkKeymap ["n" "v"] "<leader>bn" "<cmd>enew<cr>" {desc = "new buffer";})
    (mkKeymap ["n" "v"] "<leader>bq" ''require("mini.bufremove").delete'' {
      desc = "close";
      lua = true;
    })
  ];
}
