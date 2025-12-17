{nvfModules, ...}: {lib, ...}: {
  imports = [nvfModules.kitchensink-image];
  vim.utility.leetcode-nvim = {
    enable = true;
    setupOpts = {
      arg = "leetcode";
      lang = "python3";
      image_support = true;
      picker.provider = "snacks";
    };
  };
  vim.keymaps = let
    inherit (lib.nvim.binds) mkKeymap;
  in [
    (mkKeymap ["n" "v"] "<leader>1t" "<cmd>Leet tabs<cr>" {desc = "tabs";})
    (mkKeymap ["n" "v"] "<leader>1i" "<cmd>Leet info<cr>" {desc = "info";})
    (mkKeymap ["n" "v"] "<leader>1x" "<cmd>Leet reset<cr>" {desc = "reset";})
    (mkKeymap ["n" "v"] "<leader>1l" "<cmd>Leet last_submit<cr>" {desc = "last submission";})
    (mkKeymap ["n" "v"] "<leader>1L" "<cmd>Leet lang<cr>" {desc = "language";})
    (mkKeymap ["n" "v"] "<leader>1c" "<cmd>Leet console<cr>" {desc = "console";})
    (mkKeymap ["n" "v"] "<leader>1f" "<cmd>Leet fold<cr>" {desc = "fold";})
    (mkKeymap ["n" "v"] "<leader>1m" "<cmd>Leet menu<cr>" {desc = "menu";})
    (mkKeymap ["n" "v"] "<leader>1R" "<cmd>Leet submit<cr>" {desc = "submit";})
    (mkKeymap ["n" "v"] "<leader>1d" "<cmd>Leet desc<cr>" {desc = "description";})
    (mkKeymap ["n" "v"] "<leader>1r" "<cmd>Leet run<cr>" {desc = "run";})
    (mkKeymap ["n" "v"] "<leader>1h" "<cmd>Leet hints<cr>" {desc = "hints";})
    (mkKeymap ["n" "v"] "<leader>1y" "<cmd>Leet yank<cr>" {desc = "yank";})
    (mkKeymap ["n" "v"] "<leader>1b" "<cmd>Leet open<cr>" {desc = "open in browser";})
    (mkKeymap ["n" "v"] "<leader>1pp" "<cmd>Leet list<cr>" {desc = "list";})
    (mkKeymap ["n" "v"] "<leader>1pd" "<cmd>Leet daily<cr>" {desc = "daily";})
    (mkKeymap ["n" "v"] "<leader>1pr" "<cmd>Leet random<cr>" {desc = "random";})
  ];
  vim.luaConfigRC.leetcode-group = lib.nvim.dag.entryAfter ["pluginConfigs"] ''
    require("which-key").add({"<leader>1", group = "leetcode"})
  '';
}
