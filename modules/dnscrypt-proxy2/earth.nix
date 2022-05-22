{ ... }:

{
  networking.resolvconf.useLocalResolver = true;

  services = {
    dnscrypt-proxy2 = {
      enable = true;
      settings = {
        bootstrap_resolvers = [
          "1.1.1.1:53"
          "[2606:4700:4700::1111]:53"
          "8.8.8.8:53"
          "[2001:4860:4860::8888]:53"
        ];
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
