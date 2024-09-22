{ pkgs, ... }:

let
  wallpaper = pkgs.fetchurl {
    url = "https://pixiv.cat/122675302.jpg";
    hash = "sha256-qt9Lw5XQrjMq17lFoWXugxRidn100lIpoHPeHWuTSJk=";
  };
in

{
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ "${wallpaper}" ];
      wallpaper = [
        ", ${wallpaper}"
      ];
    };
  };
}
