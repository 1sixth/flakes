{ config, pkgs, ... }:

let
  wallpaper = pkgs.fetchurl {
    url = "https://upload.wikimedia.org/wikipedia/commons/a/a3/Crimea%2C_Ai-Petri%2C_low_clouds.jpg";
    hash = "sha256-ZiRdkGZDAINRePRrE72GdM1C/AtQU+r3gK/Jt+fSrtA=";
  };
in

{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$Mod" = "SUPER";
      animations.enabled = false;
      bind = [
        "$Mod, 1, workspace, 1"
        "$Mod, 2, workspace, 2"
        "$Mod, 1, workspace, 1"
        "$Mod, 2, workspace, 2"
        "$Mod, 3, workspace, 3"
        "$Mod, 4, workspace, 4"
        "$Mod, 5, workspace, 5"
        "$Mod, 6, workspace, 6"
        "$Mod, 7, workspace, 7"
        "$Mod, 8, workspace, 8"
        "$Mod, 9, workspace, 9"

        "$Mod SHIFT, 1, movetoworkspacesilent, 1"
        "$Mod SHIFT, 2, movetoworkspacesilent, 2"
        "$Mod SHIFT, 3, movetoworkspacesilent, 3"
        "$Mod SHIFT, 4, movetoworkspacesilent, 4"
        "$Mod SHIFT, 5, movetoworkspacesilent, 5"
        "$Mod SHIFT, 6, movetoworkspacesilent, 6"
        "$Mod SHIFT, 7, movetoworkspacesilent, 7"
        "$Mod SHIFT, 8, movetoworkspacesilent, 8"
        "$Mod SHIFT, 9, movetoworkspacesilent, 9"

        "$Mod, h, movefocus, l"
        "$Mod, j, movefocus, d"
        "$Mod, k, movefocus, u"
        "$Mod, l, movefocus, r"

        "$Mod SHIFT, h, movewindow, l"
        "$Mod SHIFT, j, movewindow, d"
        "$Mod SHIFT, k, movewindow, u"
        "$Mod SHIFT, l, movewindow, r"

        "$Mod SHIFT, Q, killactive"
        "$Mod SHIFT, SPACE, togglefloating"
        "$Mod, f, fullscreen, 0"
        "$Mod, t, layoutmsg, togglesplit"

        ", XF86AudioMute, exec, ${pkgs.pamixer}/bin/pamixer --toggle-mute"

        ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
        ", XF86AudioPause, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
        ", XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"
        ", XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"

        "$Mod, F1, exec, ${pkgs.pamixer}/bin/pamixer --toggle-mute"

        "$Mod, d, exec, ${config.programs.fuzzel.package}/bin/fuzzel --log-level=warning"
        "$Mod, w, exec, ${config.programs.firefox.package}/bin/firefox"
        "$Mod, x, exec, ${pkgs.systemd}/bin/loginctl lock-session"
        "$Mod, RETURN, exec, ${config.programs.foot.package}/bin/foot"

        '', PRINT, exec, ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.wl-clipboard}/bin/wl-copy''
      ];
      binde = [
        ", XF86AudioLowerVolume, exec, ${pkgs.pamixer}/bin/pamixer --decrease 5"
        ", XF86AudioRaiseVolume, exec, ${pkgs.pamixer}/bin/pamixer --increase 5"

        ", XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%-"
        ", XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%+"

        "$Mod, F2, exec, ${pkgs.pamixer}/bin/pamixer --decrease 5"
        "$Mod, F3, exec, ${pkgs.pamixer}/bin/pamixer --increase 5"
      ];
      bindm = [
        "$Mod, mouse:272, movewindow"
        "$Mod, mouse:273, resizewindow"
      ];
      "device:pnp0c50:00-093a:0255-touchpad" = {
        accel_profile = "adaptive";
        middle_button_emulation = true;
        natural_scroll = true;
      };
      dwindle = {
        force_split = 2;
        no_gaps_when_only = true;
        preserve_split = true;
      };
      exec-once = [
        "${pkgs.swaybg}/bin/swaybg --mode fill --image ${wallpaper}"
      ];
      general = {
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
      };
      input.accel_profile = "flat";
      misc.vrr = 1;
      monitor = "eDP-1,preferred,auto,1.5";
      windowrulev2 = [
        "workspace 2 silent, class: firefox"
        "workspace 3 silent, class: imv"
        "workspace 3 silent, class: mpv"
        "workspace 4 silent, class: thunderbird"
      ];
    };
  };
}
