{ ... }:

{
  networking.resolvconf.useLocalResolver = true;

  services = {
    dnscrypt-proxy2 = {
      enable = true;
      settings.server_names = [
        "cloudflare"
        "cloudflare-ipv6"
        "google"
        "google-ipv6"
        "quad9-doh-ip4-port443-filter-pri"
        "quad9-doh-ip6-port443-filter-pri"
      ];
    };
    resolved.enable = false;
  };
}
