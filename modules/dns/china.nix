{ ... }:

let
  Bootstrap = map (x: x + " -bootstrap-dns") [
    # 阿里 DNS
    "2400:3200::1"
    "2400:3200:baba::1"
    "223.5.5.5"
    "223.6.6.6"

    # 腾讯 DNS
    "2402:4e00::"
    "2402:4e00:1::"
    "119.29.29.29"
    "119.28.28.28"

    # 114 DNS
    "114.114.114.114"
    "114.114.115.115"
  ];

  DoH = [
    "https://dns.alidns.com/dns-query"
    "https://doh.pub/dns-query"
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
        log-syslog = true;
        prefetch-domain = true;
        server = Bootstrap;
        server-https = DoH;
        speed-check-mode = "ping";
      };
    };
  };
}
