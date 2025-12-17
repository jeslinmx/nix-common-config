_: {lib, ...}: {
  # nvf module does not allow modifying the root level mappings
  vim.lazy.plugins.leap-nvim = {
    package = "leap-nvim";
    setupOpts = {equivalence_classes = [" \t\r\n"];};
    keys = let
      inherit (lib.nvim.binds) mkKeymap;
    in [
      (mkKeymap "n" "s" "<Plug>(leap)" {desc = "leap";})
      (mkKeymap "n" "S" "<Plug>(leap-from-window)" {desc = "leap across windows";})
      (mkKeymap ["x" "o"] "s" "<Plug>(leap-forward)" {desc = "leap forward";})
      (mkKeymap ["x" "o"] "S" "<Plug>(leap-backward)" {desc = "leap backward";})
    ];
  };
}
