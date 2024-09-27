{ pkgs, ... }:

{
  imports = [ ./hardware.nix ];

  deployment.tags = [ "china" ];

  environment.systemPackages = with pkgs; [ docker-compose ];

  networking.hostName = "sha0";

  nix.settings.substituters = [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" ];

  services.pykms.enable = true;

  sops.defaultSopsFile = ./secrets.yaml;

  virtualisation.docker = {
    autoPrune.enable = true;
    daemon.settings.log-driver = "journald";
    enable = true;
  };
}
