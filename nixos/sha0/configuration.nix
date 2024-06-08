{ ... }:

{
  imports = [ ./hardware.nix ];

  networking.hostName = "sha0";

  sops.defaultSopsFile = ./secrets.yaml;

  virtualisation.podman.enable = true;
}
