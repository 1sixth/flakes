{ config, ... }:

{
  imports = [ ./hardware.nix ];

  environment.persistence."/persistent/impermanence" = {
    directories = [
      "/root"
      "/tmp"
    ];
    files = [
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
    ];
  };

  networking.hostName = "nrt0";

  sops.defaultSopsFile = ./secrets.yaml;
}
