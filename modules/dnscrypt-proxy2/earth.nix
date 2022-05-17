{ ... }:

{
  networking.resolvconf.useLocalResolver = true;

  services = {
    dnscrypt-proxy2 = {
      enable = true;
      settings = {
        ipv6_servers = true;
        server_names = [
          "cloudflare"
          "cloudflare-ipv6"
          "google"
          "google-ipv6"
        ];
      };
    };
    resolved.enable = false;
  };
}
