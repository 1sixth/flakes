{ pkgs, ... }:

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

  systemd.package = pkgs.systemd.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      (pkgs.fetchpatch {
        url = "https://github.com/systemd/systemd/commit/1d2b93ff89f28b18c222321c8c7bc48be2185375.patch";
        hash = "sha256-4hxgKra3Mvszkxxhwc7XgucGDjI0VhfLno1w++tlHYo=";
      })
    ];
  });
}
