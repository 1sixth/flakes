{ pkgs, ... }:

{
  imports = [ ./hardware.nix ];

  deployment.tags = [ "china" ];

  networking.hostName = "sha0";

  sops.defaultSopsFile = ./secrets.yaml;

  virtualisation.docker = {
    autoPrune.enable = true;
    daemon.settings.log-driver = "journald";
    enable = true;
  };
}
