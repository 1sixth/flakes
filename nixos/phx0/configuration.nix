{ ... }:

{
  imports = [ ./hardware.nix ];

  networking.hostName = "phx0";

  sops.defaultSopsFile = ./secrets.yaml;
}
