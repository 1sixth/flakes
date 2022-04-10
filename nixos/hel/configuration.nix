{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ./share.nix
    ./vaultwarden.nix
  ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  networking.hostName = "hel";

  security.acme.certs."shinta.ro".extraDomainNames = [ "*.shinta.ro" ];

  services.fstrim.enable = true;

  sops.defaultSopsFile = ./secrets.yaml;

  systemd.network.networks.default = {
    address = [ "2a01:4f9:6b:339c::1/64" ];
    gateway = [ "fe80::1" ];
  };

  system.stateVersion = "22.05";
}
