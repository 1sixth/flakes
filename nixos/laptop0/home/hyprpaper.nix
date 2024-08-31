{ pkgs, ... }:

let
  wallpaper = pkgs.fetchurl {
    url = "https://pixiv.cat/65204496.png";
    hash = "sha256-AenfCFlD0afOvfoIqCrUelwbgLQ8l0POwsVykLI3Ksc=";
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
