{ config, ... }:

{
  imports = [
    ./backup.nix
    ./hardware.nix
    ./miniflux.nix
    ./postgresql.nix
    ./redlib.nix
    ./vaultwarden.nix
  ];

  deployment.tags = [ "earth" ];

  networking.hostName = "nrt0";

  security.acme.certs."shinta.ro".domain = "*.shinta.ro";

  services.traefik.dynamicConfigOptions.tls.certificates = [
    {
      certFile = "/run/credentials/traefik.service/shinta.ro.crt";
      keyFile = "/run/credentials/traefik.service/shinta.ro.key";
    }
  ];

  systemd.services.traefik.serviceConfig.LoadCredential = [
    "shinta.ro.crt:${config.security.acme.certs."shinta.ro".directory}/cert.pem"
    "shinta.ro.key:${config.security.acme.certs."shinta.ro".directory}/key.pem"
  ];

  sops.defaultSopsFile = ./secrets.yaml;
}
