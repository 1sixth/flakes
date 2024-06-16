{ pkgs, ... }:

{
  imports = [ ./hardware.nix ];

  environment.systemPackages = with pkgs; [ podman-compose ];

  networking.hostName = "sha0";

  services.pykms.enable = true;

  sops.defaultSopsFile = ./secrets.yaml;

  virtualisation.podman.enable = true;
}
