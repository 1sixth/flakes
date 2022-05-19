{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ./hydra.nix
    ./jackett.nix
    ./postgresql.nix
    ./share.nix
    ./vaultwarden.nix
  ];

  networking.hostName = "fsn";

  programs.ssh = {
    extraConfig = ''
      Host fsn
        HostName fsn.9875321.xyz
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
    knownHosts = {
      "fsn.9875321.xyz".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICOuYx5RVcTXVRDVJp3vBQzVEWwP59QIlJwzhu/k1kPV";
      "tyo0.9875321.xyz".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIILj2hY2QVnysE20yMSWzMyORXPs+LjbMi2GIzQXQuJO";
      "tyo3.9875321.xyz".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBQzz4TIaV597J0WfLYnmq9z4HcbddX/bBRXQctZVbhK";
    };
  };

  security.acme.certs."shinta.ro".extraDomainNames = [ "*.shinta.ro" ];

  sops = {
    defaultSopsFile = ./secrets.yaml;
    secrets.ssh_private_key = {
      mode = "0440";
      owner = config.users.users.hydra.name;
      inherit (config.users.users.hydra) group;
    };
  };

  systemd.network.networks.default = {
    address = [ "2a01:4f8:150:24cc::1/64" ];
    gateway = [ "fe80::1" ];
  };

  system.stateVersion = "22.05";
}
