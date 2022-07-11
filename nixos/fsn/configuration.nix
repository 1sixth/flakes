{ config, pkgs, ... }:

{
  imports = [
    ./backup.nix
    ./hardware.nix
    ./hydra.nix
    ./libreddit.nix
    ./nitter.nix
    ./postgresql.nix
    ./vaultwarden.nix
  ];

  boot.kernelParams = [ "mitigations=off" ];

  environment.persistence."/persistent/impermanence" = {
    directories = [
      "/root"
      "/tmp"
      "/var/lib"
      "/var/log/journal"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
    ];
  };

  networking.hostName = "fsn";

  nix = {
    buildMachines = [
      {
        hostName = "localhost";
        supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
        systems = [
          "i686-linux"
          "x86_64-linux"
        ];
      }
      {
        hostName = "tyo0";
        supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" "gccarch-armv8-a" ];
        systems = [
          "aarch64-linux"
          "x86_64-linux"
        ];
      }
      {
        hostName = "tyo3";
        supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" "gccarch-armv8-a" ];
        systems = [
          "aarch64-linux"
          "x86_64-linux"
        ];
      }
    ];
    distributedBuilds = true;
    settings.builders-use-substitutes = true;
  };

  programs.ssh = {
    extraConfig = ''
      Host box
        HostName u307841.your-storagebox.de
        IdentityFile ${config.sops.secrets.ssh_private_key.path}
        Port 23
        User u307841
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
      "[u307841.your-storagebox.de]:23".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIICf9svRenC/PLKIL9nk6K/pxQgoiFC41wTNvoIncOxs";
      "tyo0.9875321.xyz".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFhubd/C2j9YKXj5s+PJECNXpKCOuYLBmPVi+C8d3LU2";
      "tyo3.9875321.xyz".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPlmwC1epFsDlD0LONVyOYi5OdY388CSJvYTI/8MogId";
    };
  };

  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = [ "/nix" ];
  };

  sops = {
    defaultSopsFile = ./secrets.yaml;
    secrets.ssh_private_key.owner = config.users.users.hydra-queue-runner.name;
  };

  systemd.network.networks.default = {
    address = [ "2a01:4f8:10b:472c::1/64" ];
    gateway = [ "fe80::1" ];
  };

  system.stateVersion = "22.05";
}
