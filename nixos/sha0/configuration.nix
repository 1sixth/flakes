{ ... }:

{
  imports = [ ./hardware.nix ];

  networking.hostName = "sha0";

  services.pykms.enable = true;

  sops.defaultSopsFile = ./secrets.yaml;

  virtualisation.podman.enable = true;
}
