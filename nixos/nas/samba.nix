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
          public = true;
        };
        "8T" = {
          path = "/persistent/8T";
          public = true;
        };
      };
    };
    samba-wsdd = {
      discovery = true;
      enable = true;
    };
  };
}
