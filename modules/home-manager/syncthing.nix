{...}: {lib, ...}: {
  services.syncthing = {
    enable = true;
    tray.enable = lib.mkDefault true;
  };
}
