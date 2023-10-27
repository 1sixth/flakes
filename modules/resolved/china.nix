{ ... }:

let
  DNS = builtins.concatStringsSep " " [
    "2400:3200::1#dns.alidns.com"
    "2400:3200:baba::1#dns.alidns.com"
    "223.5.5.5#dns.alidns.com"
    "223.6.6.6#dns.alidns.com"
    "1.12.12.12#dot.pub"
    "120.53.53.53#dot.pub"
  ];
in

{
  services.resolved = {
    extraConfig = ''
      DNS=${DNS}
      FallbackDNS=
      Domains=~.
      LLMNR=false
      MulticastDNS=false
      DNSOverTLS=true
      DNSStubListenerExtra=127.0.0.1
    '';
  };
}
