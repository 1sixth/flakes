{ config, pkgs, lib, ... }:

{
  imports = [
    ./campus_login.nix
    ./hardware.nix
    ./sftp.nix
  ];

  networking.hostName = "nas";

  services.fstrim.enable = true;

  sops.defaultSopsFile = ./secrets.yaml;

  system.stateVersion = "22.05";
}
