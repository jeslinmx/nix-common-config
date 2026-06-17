{inputs, ...}: _: {
  home.file = {
    ".hammerspoon/Spoons/ReloadConfiguration.spoon".source = "${inputs.hammerspoons.outPath}/Source/ReloadConfiguration.spoon";
    ".hammerspoon/Spoons/PaperWM.spoon".source = inputs.paperwmspoon.outPath;
    ".hammerspoon/init.lua".source = ./init.lua;
  };
}
