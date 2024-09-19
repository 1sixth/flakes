{ lib, ... }:

{
  imports = [ ./hardware.nix ];

  networking.hostName = "sjc0";

  sops.secrets."sing-box.json".sopsFile = lib.mkForce ./secrets.yaml;
}
