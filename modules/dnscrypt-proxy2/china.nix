{ ... }:

{
  networking.resolvconf.useLocalResolver = true;

  services = {
    dnscrypt-proxy2 = {
      enable = true;
      settings = {
        bootstrap_resolvers = [ "101.6.6.6:5353" ];
        server_names = [ "alidns-doh" "dnspod-doh" "tuna-doh-ipv4" ];
        static.tuna-doh-ipv4.stamp = "sdns://AgEAAAAAAAAACTEwMS42LjYuNiBZPi1Jp0AjVVUmrvm3QisZ5bixZzkbbe5e0pKxyiOnTA4xMDEuNi42LjY6ODQ0MwovZG5zLXF1ZXJ5";
      };
      upstreamDefaults = false;
    };
    resolved.enable = false;
  };
}
