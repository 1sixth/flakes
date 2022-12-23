{ ... }:

{
  networking.resolvconf.useLocalResolver = true;

  services = {
    dnscrypt-proxy2 = {
      enable = true;
      settings = {
        bootstrap_resolvers = [ "223.5.5.5:53" "119.29.29.29:53" ];
        server_names = [ "alidns-doh" "dnspod-doh" ];
        # A manual update of stamps may be necessary in the furure,
        # see https://github.com/DNSCrypt/dnscrypt-resolvers/pull/602.
        static = {
          alidns-doh.stamp = "sdns://AgAAAAAAAAAACTIyMy41LjUuNSAUZf-XFWhwvjDwNPWQzx8E3VDwpSDoT4pSfpwaLofrgA5kbnMuYWxpZG5zLmNvbQovZG5zLXF1ZXJ5";
          dnspod-doh.stamp = "sdns://AgAAAAAAAAAAACDBlAfoWsQD52fP2oOBh_Ag-lY6yBaIr1EMIqd559RaVgdkb2gucHViCi9kbnMtcXVlcnk";
        };
      };
      upstreamDefaults = false;
    };
    resolved.enable = false;
  };
}
