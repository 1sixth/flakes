{ config, lib, pkgs, ... }:

let
  wallpaper = pkgs.fetchurl {
    url = "https://upload.wikimedia.org/wikipedia/commons/a/a3/Crimea%2C_Ai-Petri%2C_low_clouds.jpg";
    hash = "sha256-ZiRdkGZDAINRePRrE72GdM1C/AtQU+r3gK/Jt+fSrtA=";
  };
in

{
  wayland.windowManager.sway = {
    config = {
      assigns = {
        "2" = [{ app_id = "firefox"; }];
        "3" = [{ app_id = "imv"; } { app_id = "mpv"; } { class = "Chromium-browser"; }];
        "4" = [{ app_id = "thunderbird"; }];
      };
      bars = [ ];
      floating.criteria = [{
        # Telegram Media Viewer
        title = "Media viewer";
      }];
      gaps = {
        inner = 5;
        outer = 5;
        smartBorders = "on";
        smartGaps = true;
      };
      input."type:touchpad" = {
        middle_emulation = "enabled";
        natural_scroll = "enabled";
        tap = "enabled";
      };
      keybindings =
        let
          inherit (config.wayland.windowManager.sway.config) modifier;
        in
        lib.mkOptionDefault {
          "XF86AudioMute" = "exec ${pkgs.pamixer}/bin/pamixer --toggle-mute";
          "XF86AudioLowerVolume" = "exec ${pkgs.pamixer}/bin/pamixer --decrease 5";
          "XF86AudioRaiseVolume" = "exec ${pkgs.pamixer}/bin/pamixer --increase 5";

          "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
          "XF86AudioPause" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
          "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";
          "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";

          "XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%-";
          "XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set +5%";

          "${modifier}+F1" = "exec ${pkgs.pamixer}/bin/pamixer --toggle-mute";
          "${modifier}+F2" = "exec ${pkgs.pamixer}/bin/pamixer --decrease 5";
          "${modifier}+F3" = "exec ${pkgs.pamixer}/bin/pamixer --increase 5";

          "${modifier}+F5" = "exec ${pkgs.playerctl}/bin/playerctl previous";
          "${modifier}+F6" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
          "${modifier}+F7" = "exec ${pkgs.playerctl}/bin/playerctl next";

          "${modifier}+e" = "split toggle";
          "${modifier}+t" = "layout toggle split";

          "${modifier}+w" = "exec firefox";

          "${modifier}+x" = "exec ${pkgs.systemd}/bin/loginctl lock-session";

          "Print" = "exec ${pkgs.sway-contrib.grimshot}/bin/grimshot copy window";
        };
      menu = "${pkgs.wofi}/bin/wofi";
      modifier = "Mod4";
      output."*".bg = "${wallpaper} fill";
      terminal = "foot";
    };
    enable = true;
    package = null;
  };
}