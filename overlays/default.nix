{ inputs }:

{
  qbittorrent-nox = final: prev: {
    # https://github.com/qbittorrent/qBittorrent/issues/15235
    qbittorrent-nox = inputs.nixpkgs-qbittorrent-nox.legacyPackages.${prev.system}.qbittorrent-nox.override {
      inherit (inputs.nixpkgs-libtorrent-rasterbar.legacyPackages.${prev.system}) libtorrent-rasterbar;
      trackerSearch = false;
    };
  };
  # https://github.com/swaywm/sway/pull/5890
  # https://github.com/NickCao/nixpkgs/commit/003a3678bbbb5363ef297120ba70d85623b24c71
  sway = final: prev: {
    inherit (inputs.nickpkgs.legacyPackages.${prev.system}) sway;
  };
}
