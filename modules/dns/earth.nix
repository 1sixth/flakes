{ config, ... }:

let
  DNS = builtins.concatStringsSep " " [
    "2a07:a8c0::#${config.networking.hostName}-81e651.dns.nextdns.io"
    "2a07:a8c1::#${config.networking.hostName}-81e651.dns.nextdns.io"
    "45.90.28.0${config.networking.hostName}-#81e651.dns.nextdns.io"
    "45.90.30.0${config.networking.hostName}-#81e651.dns.nextdns.io"
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
