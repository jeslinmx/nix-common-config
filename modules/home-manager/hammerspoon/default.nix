{inputs, ...}: _: {
  home.file = {
    ".hammerspoon/Spoons/PaperWM.spoon".source = inputs.paperwmspoon.outPath;
    ".hammerspoon/init.lua".source = ./init.lua;
  };
}
