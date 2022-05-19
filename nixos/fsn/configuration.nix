{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ./hydra.nix
    ./jackett.nix
    ./postgresql.nix
    ./share.nix
    ./vaultwarden.nix
  ];

  networking.hostName = "fsn";

  security.acme.certs."shinta.ro".extraDomainNames = [ "*.shinta.ro" ];

  sops.defaultSopsFile = ./secrets.yaml;

  systemd.network.networks.default = {
    address = [ "2a01:4f8:150:24cc::1/64" ];
    gateway = [ "fe80::1" ];
  };

  system.stateVersion = "22.05";
}
