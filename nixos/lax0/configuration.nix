{ ... }:

{
  imports = [ ./hardware.nix ];

  deployment.tags = [ "earth" ];

  networking.hostName = "lax0";
}
