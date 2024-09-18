{ ... }:

{
  imports = [ ./hardware.nix ];

  networking.hostName = "sjc0";

  sops.defaultSopsFile = ./secrets.yaml;
}
