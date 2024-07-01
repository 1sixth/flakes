{ ... }:

{
  imports = [ ./hardware.nix ];

  networking.hostName = "lax0";

  sops.defaultSopsFile = ./secrets.yaml;
}
