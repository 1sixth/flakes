{ ... }:

{
  imports = [
    ./hardware.nix
    ./libreddit.nix
    ./nitter.nix
  ];

  environment.persistence."/persistent/impermanence".directories = [
    "/tmp"
  ];

  networking.hostName = "nrt1";

  sops.defaultSopsFile = ./secrets.yaml;
}
