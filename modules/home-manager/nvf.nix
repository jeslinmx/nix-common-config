{
  inputs,
  nvfModules,
  ...
}: {...}: {
  imports = [inputs.nvf.homeManagerModules.default];
  programs.nvf = {
    enable = true;
    enableManpages = true;
    defaultEditor = true;
    settings = nvfModules.default;
  };
  home = {
    sessionVariables = {
      EDITOR = "nvim";
      MANPAGER = "nvim +Man!";
    };
  };
  xdg.configFile = {
    "mcphub/servers.json".text = builtins.toJSON (import ./mcp_servers.nix);
  };
}
