_: {
  lib,
  pkgs,
  ...
}: {
  vim = {
    luaConfigRC.nvr = let
      nvr = lib.getExe' pkgs.neovim-remote "nvr";
    in ''
      vim.env.EDITOR = "${nvr} -l --remote-wait"
      vim.env.MANPAGER = "${nvr} -c Man!"
    '';
    extraPackages = [pkgs.neovim-remote];
  };
}
