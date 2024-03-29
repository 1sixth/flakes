{ ... }:

{
  imports = [
    ./backup.nix
    ./hardware.nix
    ./libreddit.nix
    ./miniflux.nix
    ./postgresql.nix
    ./vaultwarden.nix
  ];

  networking.hostName = "fsn0";

  sops.defaultSopsFile = ./secrets.yaml;

  systemd.network.networks.default = {
    address = [ "2a01:4f8:c012:ebef::1/64" ];
    gateway = [ "fe80::1" ];
  };
}
