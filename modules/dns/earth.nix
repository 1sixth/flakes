{ ... }:

let
  Bootstrap = map (x: x + " -bootstrap-dns") [
    # Cloudflare DNS
    "2606:4700:4700::1111"
    "2606:4700:4700::1001"
    "1.1.1.1"
    "1.0.0.1"

    # Google DNS
    "2001:4860:4860::8888"
    "2001:4860:4860::8844"
    "8.8.8.8"
    "8.8.4.4"
  ];

  DoH = [
    "https://cloudflare-dns.com/dns-query"
    "https://dns.google/dns-query"
  ];
in

{

  environment.etc."resolv.conf".text = ''
    nameserver 127.0.0.1
    options edns0 trust-ad
    search .
  '';

  services = {
    resolved.enable = false;
    smartdns = {
      enable = true;
      settings = {
        bind = "127.0.0.1:53";
        cache-persist = false;
        log-syslog = true;
        prefetch-domain = true;
        server = Bootstrap;
        server-https = DoH;
        speed-check-mode = "ping";
      };
    };
  };
}
