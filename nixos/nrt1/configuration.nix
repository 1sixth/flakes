{ ... }:

{
  imports = [
    ./hardware.nix
    ./libreddit.nix
    ./nitter.nix
  ];

  networking.hostName = "nrt1";

  sops.defaultSopsFile = ./secrets.yaml;
}
