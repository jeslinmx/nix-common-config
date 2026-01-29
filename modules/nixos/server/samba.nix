_: {...}: {
  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "%h - Samba %v";
        "min protocol" = "SMB3";
        "security" = "user";
        "use sendfile" = "yes";
        "guest account" = "nobody";
        "map to guest" = "bad user";
        "browseable" = "yes";
        "guest ok" = "no";
        "read only" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
      };
      "tm_share" = {
        "path" = "/mnt/tm_share";
        "valid users" = "jeslinmx";
        "fruit:aapl" = "yes";
        "fruit:time machine" = "yes";
        "vfs objects" = "catia fruit streams_xattr";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };
}
