{ ... }:

{
  services = {
    samba = {
      enable = true;
      extraConfig = ''
        map to guest = bad user
        use sendfile = yes
      '';
      shares = {
        "16T" = {
          path = "/persistent/16T";
          "read only" = true;
          "guest ok" = true;
        };
        "8T" = {
          path = "/persistent/8T";
          "read only" = true;
          "guest ok" = true;
        };
      };
    };
    samba-wsdd = {
      discovery = true;
      enable = true;
    };
  };
}
