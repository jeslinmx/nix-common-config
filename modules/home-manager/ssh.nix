_: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      addKeysToAgent = "yes";
      controlMaster = "auto";
      controlPersist = "3s";
      controlPath = "~/.ssh/control/%C";
    };
    extraConfig = ''
      IgnoreUnknown UseKeychain
      UseKeychain yes
      SetEnv TERM=xterm-256color
    '';
    includes = ["~/.ssh/config.d/*.conf"];
  };
}
