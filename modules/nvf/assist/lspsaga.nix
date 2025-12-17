_: {lib, ...}: {
  vim.lsp.enable = true;
  vim.lsp.lspsaga = {
    enable = true;
    setupOpts = {
      symbol_in_winbar = {
        show_file = false;
      };
      finder = {
        default = "ref+imp+def+typ";
        methods = {typ = "textDocument/typeDefinition";};
        keys = {
          shuttle = "<tab>";
          toggle_or_open = "<cr>";
          edit = "e";
          vsplit = "v";
          split = "s";
          quit = ["<esc>" "q"];
          close = "<C-w>q";
        };
      };
      callhierarchy = {
        keys = {
          shuttle = "<tab>";
          toggle_or_req = "<cr>";
          edit = "e";
          vsplit = "v";
          split = "s";
          quit = ["<esc>" "q"];
          close = "<C-w>q";
        };
      };
      code_action = {
        keys = {
          quit = ["<esc>" "q"];
          exec = "<cr>";
        };
      };
      definition = {
        keys = {
          edit = "<C-c>e";
          vsplit = "<C-c>v";
          split = "<C-c>s";
          quit = ["<esc>" "q"];
          close = "<C-w>q";
        };
      };
      diagnostic = {
        keys = {
          exec_action = "<cr>";
          toggle_or_jump = "e";
          quit = ["<esc>" "q"];
          close = "<C-w>q";
        };
      };
      rename = {
        keys = {
          exec = "<cr>";
          select = "<tab>";
          quit = "<esc>";
          close = "<C-w>q";
        };
      };
      lightbulb = {
        enable = false;
      };
      ui = {
        border = "none";
        code_action = "";
      };
    };
  };
  vim.lazy.plugins.lspsaga-nvim.keys = let
    inherit (lib.nvim.binds) mkKeymap;
  in [
    (mkKeymap "n" "<cr>" "<cmd>Lspsaga finder<cr>" {desc = "󰈞 find (LSP)";})
    (mkKeymap "n" "]c" "<cmd>Lspsaga outgoing_calls<cr>" {desc = "󰏻 outgoing calls (LSP)";})
    (mkKeymap "n" "[c" "<cmd>Lspsaga incoming_calls<cr>" {desc = "󰏷 incoming calls (LSP)";})
    (mkKeymap "n" "]d" "<cmd>Lspsaga diagnostic_jump_next<cr>" {desc = "󰃤 next diagnostic (LSP)";})
    (mkKeymap "n" "[d" "<cmd>Lspsaga diagnostic_jump_prev<cr>" {desc = "󰨰 previous diagnostic (LSP)";})
    (mkKeymap "n" "gO" "<cmd>Lspsaga outline<cr>" {desc = " toggle outline (LSP)";})
    (mkKeymap "n" "g." "<cmd>Lspsaga code_action<cr>" {desc = " view code actions (LSP)";})
    (mkKeymap "n" "gd" "<cmd>Lspsaga peek_definition<cr>" {desc = " peek definition (LSP)";})
    (mkKeymap "n" "gl" "<cmd>Lspsaga rename<cr>" {desc = "󰑕 rename symbol (LSP)";})
  ];
}
