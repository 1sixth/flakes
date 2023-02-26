{ config, lib, pkgs, ... }:

{
  wayland.windowManager.sway = {
    config = {
      assigns = {
        "2" = [{ app_id = "firefox"; }];
        "3" = [{ app_id = "imv"; } { app_id = "mpv"; }];
        "4" = [{ app_id = "thunderbird"; }];
      };
      bars = [ ];
      gaps = {
        inner = 5;
        outer = 5;
        smartBorders = "on";
        smartGaps = true;
      };
      input = {
        "type:touchpad" = {
          middle_emulation = "enabled";
          natural_scroll = "enabled";
          tap = "enabled";
        };
      };
      keybindings =
        let inherit (config.wayland.windowManager.sway.config) modifier; in
        lib.mkOptionDefault {
          "XF86AudioMute" = "exec ${pkgs.pamixer}/bin/pamixer -t";
          "XF86AudioLowerVolume" = "exec ${pkgs.pamixer}/bin/pamixer -d 5";
          "XF86AudioRaiseVolume" = "exec ${pkgs.pamixer}/bin/pamixer -i 5";

          "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
          "XF86AudioPause" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
          "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";
          "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";

          "XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%-";
          "XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set +5%";

          "${modifier}+F1" = "exec ${pkgs.pamixer}/bin/pamixer -t";
          "${modifier}+F2" = "exec ${pkgs.pamixer}/bin/pamixer -d 5";
          "${modifier}+F3" = "exec ${pkgs.pamixer}/bin/pamixer -i 5";

          "${modifier}+F5" = "exec ${pkgs.playerctl}/bin/playerctl previous";
          "${modifier}+F6" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
          "${modifier}+F7" = "exec ${pkgs.playerctl}/bin/playerctl next";

          "${modifier}+e" = "split toggle";
          "${modifier}+t" = "layout toggle split";
          "${modifier}+x" = "exec ${pkgs.systemd}/bin/loginctl lock-session";

          "${modifier}+w" = "exec firefox";

          "Print" = "exec ${pkgs.sway-contrib.grimshot}/bin/grimshot copy window";
        };
      menu = "${pkgs.wofi}/bin/wofi";
      modifier = "Mod4";
      output.eDP-1.scale = "1.5";
      terminal = "foot";
    };
    enable = true;
    extraConfig = ''
      bindswitch --locked --reload lid:on output eDP-1 disable
      bindswitch --locked --reload lid:off output eDP-1 enable
    '';
    package = null;
  };
}
