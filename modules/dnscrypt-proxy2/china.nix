{ ... }:

{
  environment.etc."resolv.conf".text = ''
    nameserver 127.0.0.1
    options edns0
  '';

  services = {
    dnscrypt-proxy2 = {
      enable = true;
      settings = {
        bootstrap_resolvers = [
          "[2400:3200::1]:53"
          "[2400:3200:baba::1]:53"
          "[2402:4e00::]:53"
          "223.5.5.5:53"
          "223.6.6.6:53"
          "119.29.29.29:53"
        ];
        ipv6_servers = true;
        server_names = [
          "alidns-doh"
          "dnspod-doh"
        ];
        # https://dnscrypt.info/stamps/
        static = {
          alidns-doh.stamp = "sdns://AgAAAAAAAAAAAAAOZG5zLmFsaWRucy5jb20KL2Rucy1xdWVyeQ";
          dnspod-doh.stamp = "sdns://AgAAAAAAAAAAAAAHZG9oLnB1YgovZG5zLXF1ZXJ5";
        };
      };
      upstreamDefaults = false;
    };
    resolved.enable = false;
  };
}
