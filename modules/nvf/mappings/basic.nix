_: {lib, ...}: {
  vim.mini.bufremove.enable = true;
  vim.keymaps = let
    inherit (lib.nvim.binds) mkKeymap;
  in [
    (mkKeymap ["c" "i"] "<C-a>" "<Home>" {desc = "move to beginning of line";})
    (mkKeymap ["c" "i"] "<C-e>" "<End>" {desc = "move to end of line";})

    (mkKeymap ["n" "i"] "<C-c>" "<cmd>%y+<cr>" {desc = "copy whole file";})

    (mkKeymap ["i"] "jj" "<Esc>" {desc = "escape insert mode";})
    (mkKeymap ["t"] "jj" "<C-\\><C-n>" {desc = "escape insert mode";})
    (mkKeymap ["n"] "<Esc>" "<cmd>noh<cr>" {desc = "clear highlights";})

    (mkKeymap ["n" "v"] "<tab>" "<cmd>bnext<cr>" {desc = "buffer goto next";})
    (mkKeymap ["n" "v"] "<S-tab>" "<cmd>bprev<cr>" {desc = "buffer goto prev";})
    (mkKeymap ["n" "v"] "<leader>bn" "<cmd>enew<cr>" {desc = "new buffer";})
    (mkKeymap ["n" "v"] "<leader>bq" ''require("mini.bufremove").delete'' {
      desc = "close";
      lua = true;
    })

    (mkKeymap ["n" "v"] ''\w'' "<Cmd>set wrap!<CR>" {desc = "toggle wrap";})
    (mkKeymap ["n" "v"] ''\d'' ''<Cmd>exe &diff ? "diffoff" : "diffthis"<CR>'' {desc = "toggle diff";})

    # stolen from mini.basics
    (mkKeymap ["n" "x"] "j" ''v:count == 0 ? "gj" : "j"'' {expr = true;})
    (mkKeymap ["n" "x"] "k" ''v:count == 0 ? "gk" : "k"'' {expr = true;})
    (mkKeymap ["n" "x"] "gy" "\"+y" {desc = "Copy to system clipboard";})
    (mkKeymap ["n"] "gp" "\"+p" {desc = "Paste from system clipboard";})
    (mkKeymap ["n"] "gV" ''"`[" . strpart(getregtype(), 0, 1) . "`]"'' {
      expr = true;
      desc = "Visually select most recently changed text";
    })
    (mkKeymap ["x"] "g/" "<esc>/\\%V" {
      silent = false;
      desc = "Search inside visual selection";
    })
    (mkKeymap ["n"] "<C-S>" "<Cmd>silent! update | redraw<CR>" {desc = "Save";})
    (mkKeymap ["i" "x"] "<C-S>" "<Esc><Cmd>silent! update | redraw<CR>" {desc = "Save and go to Normal mode";})
    (mkKeymap ["n"] "<C-H>" "<C-w>h" {desc = "Focus on left window";})
    (mkKeymap ["n"] "<C-J>" "<C-w>j" {desc = "Focus on below window";})
    (mkKeymap ["n"] "<C-K>" "<C-w>k" {desc = "Focus on above window";})
    (mkKeymap ["n"] "<C-L>" "<C-w>l" {desc = "Focus on right window";})
    (mkKeymap ["n"] "<C-Left>" ''<Cmd>exe "vertical resize -" . v:count1<CR>'' {desc = "Decrease window width";})
    (mkKeymap ["n"] "<C-Down>" ''<Cmd>exe "resize -" . v:count1<CR>'' {desc = "Decrease window height";})
    (mkKeymap ["n"] "<C-Up>" ''<Cmd>exe "resize +" . v:count1<CR>'' {desc = "Increase window height";})
    (mkKeymap ["n"] "<C-Right>" ''<Cmd>exe "vertical resize +" . v:count1<CR>"'' {desc = "Increase window width";})

    # inspired by unimpaired
    (mkKeymap ["n"] "=P" ''<Cmd>exe "put! " . v:register<cr>==^'' {desc = "paste above and re-indent";})
    (mkKeymap ["n"] "=p" ''<Cmd>exe "put "  . v:register<cr>==^'' {desc = "paste below and re-indent";})
    (mkKeymap ["n"] "=gP" ''<Cmd>exe "put! +"<cr>==^'' {desc = "paste above from system clipboard and re-indent";})
    (mkKeymap ["n"] "=gp" ''<Cmd>exe "put  +"<cr>==^'' {desc = "paste below from system clipboard and re-indent";})
  ];
}
