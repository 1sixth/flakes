{ inputs }:

{
  deploy-rs = final: prev: {
    deploy-rs = inputs.deploy-rs.packages.${prev.system}.deploy-rs;
  };
  fcitx5 = final: prev: {
    fcitx5-material-color = inputs.berberman.packages.${prev.system}.fcitx5-material-color;
    fcitx5-pinyin-moegirl = inputs.berberman.packages.${prev.system}.fcitx5-pinyin-moegirl;
    fcitx5-pinyin-zhwiki = inputs.berberman.packages.${prev.system}.fcitx5-pinyin-zhwiki;
  };
  qbittorrent = final: prev: {
    # https://github.com/qbittorrent/qBittorrent/issues/15235
    qbittorrent-nox = inputs.nixpkgs-qbittorrent-nox.legacyPackages.${prev.system}.qbittorrent-nox.override {
      libtorrent-rasterbar = inputs.nixpkgs-libtorrent-rasterbar.legacyPackages.${prev.system}.libtorrent-rasterbar;
    };
  };
  qliveplayer = final: prev: {
    qliveplayer = inputs.berberman.packages.${prev.system}.qliveplayer;
  };
  # https://github.com/swaywm/sway/pull/5890
  # https://github.com/NickCao/nixpkgs/commit/003a3678bbbb5363ef297120ba70d85623b24c71
  sway = final: prev: {
    sway = inputs.nixpkgs-sway.legacyPackages.${prev.system}.sway;
  };
}
