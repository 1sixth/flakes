_:

{
  networking.resolvconf.useLocalResolver = true;

  services = {
    dnscrypt-proxy2 = {
      enable = true;
      settings = {
        bootstrap_resolvers = [ "[2606:4700:4700::1111]:53" "[2606:4700:4700::1001]:53" "1.1.1.1:53" "1.0.0.1:53" ];
        dnscrypt_servers = false;
        ipv6_servers = true;
        require_dnssec = true;
      };
    };
    resolved.enable = false;
  };
}
