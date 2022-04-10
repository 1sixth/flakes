{ config, pkgs, lib, ... }:

{
  imports = [
    ./campus_login.nix
    ./hardware.nix
    ./sftp.nix
    ./shutdown.nix
  ];

  networking.hostName = "nas";

  security.acme.certs."9875321.xyz".extraDomainNames = lib.mkForce [ ];

  services = {
    fstrim.enable = true;
    nginx.virtualHosts."${config.networking.hostName}.9875321.xyz".serverAliases = lib.mkForce [ ];
  };

  sops.defaultSopsFile = ./secrets.yaml;

  system.stateVersion = "22.05";
}
