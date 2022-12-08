{ inputs }:

{
  qbittorrent-nox = final: prev: {
    # https://github.com/qbittorrent/qBittorrent/issues/15235
    qbittorrent-nox = inputs.nixpkgs-qbittorrent-nox.legacyPackages.${prev.system}.qbittorrent-nox.override {
      inherit (inputs.nixpkgs-libtorrent-rasterbar.legacyPackages.${prev.system}) libtorrent-rasterbar;
      trackerSearch = false;
    };
  };
}
