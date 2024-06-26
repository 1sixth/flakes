{ config, ... }:

{
  imports = [
    ./backup.nix
    ./hardware.nix
    ./libreddit.nix
    ./miniflux.nix
    ./postgresql.nix
    ./vaultwarden.nix
  ];

  networking.hostName = "fsn0";

  security.acme.certs."shinta.ro".domain = "*.shinta.ro";

  services.traefik.dynamicConfigOptions.tls.certificates = [
    {
      certFile = "/run/credentials/traefik.service/shinta.ro.crt";
      keyFile = "/run/credentials/traefik.service/shinta.ro.key";
    }
  ];

  sops.defaultSopsFile = ./secrets.yaml;

  systemd = {
    network.networks.default = {
      address = [ "2a01:4f8:c012:ebef::1/64" ];
      gateway = [ "fe80::1" ];
    };
    services.traefik.serviceConfig.LoadCredential = [
      "shinta.ro.crt:${config.security.acme.certs."shinta.ro".directory}/cert.pem"
      "shinta.ro.key:${config.security.acme.certs."shinta.ro".directory}/key.pem"
    ];
  };
}
