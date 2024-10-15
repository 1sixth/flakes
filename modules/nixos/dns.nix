{ config, ... }:

let

  China_Bootstrap = builtins.map (x: x + " -bootstrap-dns") [
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

  Earth_Bootstrap = builtins.map (x: x + " -bootstrap-dns") [
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

  China_DoH = [
    "https://dns.alidns.com/dns-query"
    "https://doh.pub/dns-query"
  ];

  Earth_DoH = [
    "https://cloudflare-dns.com/dns-query"
    "https://dns.google/dns-query"
  ];

  MagicDNS = builtins.map (x: x + " -group magicdns -exclude-default-group") [
    "fd7a:115c:a1e0::53"
    "100.100.100.100"
  ];

  Bootstrap =
    if (builtins.elem "china" config.deployment.tags) then China_Bootstrap else Earth_Bootstrap;
  DoH = if (builtins.elem "china" config.deployment.tags) then China_DoH else Earth_DoH;
in

{

  environment.etc."resolv.conf".text = ''
    nameserver 127.0.0.1
    options edns0 trust-ad
    search tail5e6002.ts.net
  '';

  services = {
    resolved.enable = false;
    smartdns = {
      enable = true;
      settings = {
        bind = "127.0.0.1:53";
        bind-tcp = "127.0.0.1:53";
        cache-persist = false;
        cname = [ "/nas.9875321.xyz/nas.tail5e6002.ts.net" ];
        log-syslog = true;
        nameserver = [ "/tail5e6002.ts.net/magicdns" ];
        no-daemon = true;
        no-pidfile = true;
        prefetch-domain = true;
        response-mode = "fastest-ip";
        server = Bootstrap ++ MagicDNS;
        server-https = DoH;
      };
    };
  };

  systemd.services.smartdns = {
    serviceConfig = {
      AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
      DynamicUser = true;
      Type = "simple";
    };
  };
}
