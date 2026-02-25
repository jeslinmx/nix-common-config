_: {
  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";
  };
  environment.systemPath = ["/opt/homebrew/bin"];
}
