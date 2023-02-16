{ config, ... }:

{
  imports = [ ./hardware.nix ];

  environment.persistence."/persistent/impermanence" = {
    directories = [
      "/root"
    ];
    files = [
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
    ];
  };

  networking.hostName = "nrt5";

  sops.defaultSopsFile = ./secrets.yaml;
}
