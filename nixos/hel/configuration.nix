{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ./hydra.nix
    ./share.nix
    ./vaultwarden.nix
  ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  networking.hostName = "hel";

  programs.ssh = {
    knownHosts."tyo0.9875321.xyz".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICDgtb4zRBJ5xKMeEwJkhY7H68eUBNvSuBiRuuF0U02j";
    extraConfig = ''
      Host tyo0
        HostName tyo0.9875321.xyz
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
