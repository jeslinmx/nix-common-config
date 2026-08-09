{flake, ...}: {
  home.file = {
    ".hammerspoon/Spoons/ReloadConfiguration.spoon".source = "${flake.inputs.hammerspoons.outPath}/Source/ReloadConfiguration.spoon";
    ".hammerspoon/Spoons/PaperWM.spoon".source = flake.inputs.paperwmspoon.outPath;
    ".hammerspoon/init.lua".source = ./init.lua;
  };
}
