{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ./hydra.nix
    ./share.nix
    ./vaultwarden.nix
  ];

  networking.hostName = "hel";

  programs.ssh = {
    knownHosts = {
      "hel.9875321.xyz".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFw4vNI0hzUv4OHw2PTBLRqn5C1aSMt8aGi3v0DPTo7D";
      "tyo0.9875321.xyz".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIILj2hY2QVnysE20yMSWzMyORXPs+LjbMi2GIzQXQuJO";
      "tyo3.9875321.xyz".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBQzz4TIaV597J0WfLYnmq9z4HcbddX/bBRXQctZVbhK";
      "u290909.your-storagebox.de".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIICf9svRenC/PLKIL9nk6K/pxQgoiFC41wTNvoIncOxs";
    };
    extraConfig = ''
      Host box
        HostName u290909.your-storagebox.de
        IdentityFile ${config.sops.secrets.ssh_private_key.path}
        Port 23
        User u290909
      Host hel
        HostName hel.9875321.xyz
        IdentityFile ${config.sops.secrets.ssh_private_key.path}
        User root
      Host tyo0
        HostName tyo0.9875321.xyz
        IdentityFile ${config.sops.secrets.ssh_private_key.path}
        User root
      Host tyo3
        HostName tyo3.9875321.xyz
        IdentityFile ${config.sops.secrets.ssh_private_key.path}
        User root
    '';
  };

  security.acme.certs."shinta.ro".extraDomainNames = [ "*.shinta.ro" ];

  services.fstrim.enable = true;

  sops = {
    defaultSopsFile = ./secrets.yaml;
    secrets.ssh_private_key = {
      mode = "0440";
      owner = config.users.users.hydra.name;
      inherit (config.users.users.hydra) group;
    };
  };

  systemd.network.networks.default = {
    address = [ "2a01:4f9:6b:339c::1/64" ];
    gateway = [ "fe80::1" ];
  };

  system.stateVersion = "22.05";
}
