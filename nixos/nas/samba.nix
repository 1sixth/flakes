{ ... }:

{
  services = {
    samba = {
      enable = true;
      settings = {
        global = {
          "map to guest" = "Bad User";
          "use sendfile" = true;
        };
        "16T" = {
          "guest ok" = true;
          path = "/persistent/16T";
        };
        "8T" = {
          "guest ok" = true;
          path = "/persistent/8T";
        };
      };
    };
    samba-wsdd = {
      discovery = true;
      enable = true;
    };
  };
}
