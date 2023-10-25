{ ... }:

let DNS = builtins.concatStringsSep " " [
  "2606:4700:4700::1111#one.one.one.one"
  "2606:4700:4700::1001#one.one.one.one"
  "1.1.1.1#one.one.one.one"
  "1.0.0.1#one.one.one.one"
  "2001:4860:4860::8888#dns.google"
  "2001:4860:4860::8844#dns.google"
  "8.8.8.8#dns.google"
  "8.8.4.4#dns.google"
]; in

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
