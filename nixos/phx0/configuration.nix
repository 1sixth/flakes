{ ... }:

{
  imports = [
    ./backup.nix
    ./hardware.nix
    ./libreddit.nix
    ./miniflux.nix
    ./nitter.nix
    ./postgresql.nix
    ./vaultwarden.nix
  ];

  networking.hostName = "phx0";

  sops.defaultSopsFile = ./secrets.yaml;
}
