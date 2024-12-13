{ config, ... }:

let
  AliDNS = builtins.concatStringsSep " " (
    builtins.map (x: "tls://" + x) [
      "2400:3200::1"
      "2400:3200:baba::1"
      "223.5.5.5"
      "223.6.6.6"
    ]
  );

  CloudflareDNS = builtins.concatStringsSep " " (
    builtins.map (x: "tls://" + x) [
      "2606:4700:4700::1111"
      "2606:4700:4700::1001"
      "1.1.1.1"
      "1.0.0.1"
    ]
  );

  MagicDNS = builtins.concatStringsSep " " [
    "fd7a:115c:a1e0::53"
    "100.100.100.100"
  ];

  DNS = if (builtins.elem "china" config.deployment.tags) then AliDNS else CloudflareDNS;
  ServerName =
    if (builtins.elem "china" config.deployment.tags) then "dns.alidns.com" else "one.one.one.one";
in

{
  networking.resolvconf.useLocalResolver = true;

  services = {
    coredns = {
      config = ''
        . {
            bind lo

            hosts {
                fallthrough
            }

            rewrite name nas.9875321.xyz nas.tail5e6002.ts.net

            forward tail5e6002.ts.net ${MagicDNS}

            forward . ${DNS} {
                health_check 1m
                tls_servername ${ServerName}
            }

            cache
            log
            errors
        }
      '';
      enable = true;
    };
    resolved.enable = false;
  };
}
