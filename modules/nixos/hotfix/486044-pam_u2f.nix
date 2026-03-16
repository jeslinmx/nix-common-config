_: {...}: {
  systemd.services."polkit-agent-helper@".serviceConfig = {
    PrivateDevices = false;
    DeviceAllow = [
      "/dev/urandom r"
      "char-hidraw rw"
    ];
    ProtectHome = "read-only";
    StandardError = "journal";
  };
}
