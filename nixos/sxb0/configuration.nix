{ ... }:

{
  imports = [ ./hardware.nix ];

  deployment.tags = [ "earth" ];

  networking.hostName = "sxb0";
}
