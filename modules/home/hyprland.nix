{ config, pkgs, ... }:

{
  # app-org.fcitx.Fcitx5@autostart.service
  systemd.user.targets.hyprland-session.Unit.Wants = [ "xdg-desktop-autostart.target" ];

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

        "$Mod SHIFT, q, killactive"
        "$Mod SHIFT, space, togglefloating"
        "$Mod, f, fullscreen, 0"
        "$Mod, t, layoutmsg, togglesplit"

        ", XF86AudioMute, exec, ${config.services.avizo.package}/bin/volumectl toggle-mute"

        ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
        ", XF86AudioPause, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
        ", XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"
        ", XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"

        "$Mod, F1, exec, ${config.services.avizo.package}/bin/volumectl toggle-mute"

        "$Mod, d, exec, ${config.programs.fuzzel.package}/bin/fuzzel --log-level=warning"
        "$Mod, x, exec, ${pkgs.systemd}/bin/loginctl lock-session"
        "$Mod, RETURN, exec, ${config.programs.foot.package}/bin/foot"

        "$Mod, c, exec, ${config.programs.foot.package}/bin/foot -e bluetuith"
        "$Mod, w, exec, ${config.programs.foot.package}/bin/foot -e impala"

        '', PRINT, exec, ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.wl-clipboard}/bin/wl-copy''
        ''$Mod, s, exec, sh -c "hyprctl monitors | grep eDP-1 && hyprctl keyword monitor eDP-1,disable || hyprctl keyword monitor eDP-1,preferred,auto,auto"''
      ];
      binde = [
        ", XF86AudioLowerVolume, exec, ${config.services.avizo.package}/bin/volumectl down"
        ", XF86AudioRaiseVolume, exec, ${config.services.avizo.package}/bin/volumectl up"

        ", XF86MonBrightnessDown, exec, ${config.services.avizo.package}/bin/lightctl down"
        ", XF86MonBrightnessUp, exec, ${config.services.avizo.package}/bin/lightctl up"

        "$Mod, F2, exec, ${config.services.avizo.package}/bin/volumectl down"
        "$Mod, F3, exec, ${config.services.avizo.package}/bin/volumectl up"
      ];
      bindl = [
        ", switch:off:Lid Switch, exec, ${config.wayland.windowManager.hyprland.package}/bin/hyprctl dispatch dpms on eDP-1"
        ", switch:on:Lid Switch, exec, ${config.wayland.windowManager.hyprland.package}/bin/hyprctl dispatch dpms off eDP-1"
      ];
      bindm = [
        "$Mod, mouse:272, movewindow"
        "$Mod, mouse:273, resizewindow"
      ];
      cursor.no_hardware_cursors = true;
      dwindle = {
        force_split = 2;
        preserve_split = true;
      };
      exec-once = [
        "${config.programs.foot.package}/bin/foot"
        "${config.programs.firefox.finalPackage}/bin/firefox-esr"
      ];
      general = {
        border_size = 2;
        "col.active_border" = "rgb(00afaf)";
        "col.inactive_border" = "rgb(585858)";
      };
      input = {
        accel_profile = "flat";
        numlock_by_default = true;
      };
      misc.vrr = 2;
      monitor = [
        "eDP-1,preferred,auto,auto"
        # TODO: replace with kanshi or shikane
        "desc:HP Inc. HP Z24f G3 CN44040321,preferred,auto-left,auto"
        "desc:Shenzhen KTC Technology Group H27T22S 0x00000001,2560x1440@144,auto-left,1.6"
      ];
      windowrulev2 = [
        "focusonactivate, class:mpv"
        "workspace 1 silent, class:codium-url-handler"
        "workspace 2 silent, class:firefox"
        "workspace 3 silent, class:imv"
        "workspace 3 silent, class:mpv"
        "workspace 3 silent, class:org.kde.okular"
        "workspace 4 silent, class:thunderbird"
      ];
      workspace = [
        "w[t1], gapsout:0, border:0"
      ];
      xwayland.force_zero_scaling = true;
    };
  };
}
