{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ./hydra.nix
    ./postgresql.nix
    ./share.nix
    ./vaultwarden.nix
  ];

  environment.persistence."/persistent/impermanence" = {
    directories = [
      "/var/lib"
      "/var/log/journal"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
    ];
  };

  networking.hostName = "fsn";

  security.acme.certs."shinta.ro".extraDomainNames = [ "*.shinta.ro" ];

  sops.defaultSopsFile = ./secrets.yaml;

  systemd.network.networks.default = {
    address = [ "2a01:4f8:172:3c52::1/64" ];
    gateway = [ "fe80::1" ];
  };

  system.stateVersion = "22.05";
}
