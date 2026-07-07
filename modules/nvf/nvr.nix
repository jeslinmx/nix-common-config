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
      vim.env.MANPAGER = "${nvr} -cc 'new' --remote +'Man! | setlocal nobuflisted winfixbuf' -"
    '';
    extraPackages = [pkgs.neovim-remote];
  };
}
