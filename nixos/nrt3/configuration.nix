{ config, ... }:

{
  imports = [
    ./hardware.nix
    ./libreddit.nix
    ./nitter.nix
  ];

  environment.persistence."/persistent/impermanence".directories = [
    "/tmp"
  ];

  networking.hostName = "nrt3";

  sops.defaultSopsFile = ./secrets.yaml;
}
