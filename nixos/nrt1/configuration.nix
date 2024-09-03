{ ... }:

{
  imports = [ ./hardware.nix ];

  networking.hostName = "nrt1";

  services.k3s.enable = true;

  sops.defaultSopsFile = ./secrets.yaml;
}
