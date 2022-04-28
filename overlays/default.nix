{ inputs }:

{
  fcitx5 = final: prev: {
    inherit (inputs.nixos-cn.legacyPackages.${prev.system}.re-export) fcitx5-material-color;
    inherit (inputs.nixos-cn.legacyPackages.${prev.system}.re-export) fcitx5-pinyin-moegirl;
    inherit (inputs.nixos-cn.legacyPackages.${prev.system}.re-export) fcitx5-pinyin-zhwiki-nickcao;
  };
  hydra = final: prev: {
    inherit (inputs.nickpkgs.legacyPackages.${prev.system}) hydra-unstable;
  };
  qbittorrent-nox = final: prev: {
    # https://github.com/qbittorrent/qBittorrent/issues/15235
    qbittorrent-nox = inputs.nixpkgs-qbittorrent-nox.legacyPackages.${prev.system}.qbittorrent-nox.override {
      inherit (inputs.nixpkgs-libtorrent-rasterbar.legacyPackages.${prev.system}) libtorrent-rasterbar;
    };
  };
  qliveplayer = final: prev: {
    inherit (inputs.nixos-cn.legacyPackages.${prev.system}.re-export) qliveplayer;
  };
  # https://github.com/swaywm/sway/pull/5890
  # https://github.com/NickCao/nixpkgs/commit/003a3678bbbb5363ef297120ba70d85623b24c71
  sway = final: prev: {
    inherit (inputs.nickpkgs.legacyPackages.${prev.system}) sway;
  };
}
