_: {pkgs, ...}: {
  fonts.packages = builtins.attrValues {
    inherit
      (pkgs)
      corefonts
      vista-fonts
      vista-fonts-chs
      ;
  };
}
