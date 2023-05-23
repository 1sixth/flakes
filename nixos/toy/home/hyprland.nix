{ pkgs, ... }:

let
  wallpaper = pkgs.fetchurl {
    url = "https://upload.wikimedia.org/wikipedia/commons/a/a3/Crimea%2C_Ai-Petri%2C_low_clouds.jpg";
    hash = "sha256-ZiRdkGZDAINRePRrE72GdM1C/AtQU+r3gK/Jt+fSrtA=";
  };
in

{
  wayland.windowManager.hyprland = {
    enable = true;
    systemdIntegration = true;
    extraConfig = ''
      monitor=eDP-1,preferred,auto,1.5

      animations {
          enabled = false
      }

      dwindle {
          no_gaps_when_only = true
      }

      general {
          border_size = 2
          col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
          col.inactive_border = rgba(595959aa)
      }

      input {
          touchpad {
              middle_button_emulation = true
              natural_scroll = true
          }
      }

      misc {
          key_press_enables_dpms = true
          mouse_move_enables_dpms = true
          vrr = 1
      }

      windowrulev2 = workspace 2 silent, class: firefox
      windowrulev2 = workspace 3 silent, class: chromium-browser
      windowrulev2 = workspace 3 silent, class: imv
      windowrulev2 = workspace 3 silent, class: mpv
      windowrulev2 = workspace 4 silent, class: thunderbird

      $Mod = SUPER

      bind = $Mod, 1, workspace, 1
      bind = $Mod, 2, workspace, 2
      bind = $Mod, 3, workspace, 3
      bind = $Mod, 4, workspace, 4
      bind = $Mod, 5, workspace, 5
      bind = $Mod, 6, workspace, 6
      bind = $Mod, 7, workspace, 7
      bind = $Mod, 8, workspace, 8
      bind = $Mod, 9, workspace, 9

      bind = $Mod SHIFT, 1, movetoworkspacesilent, 1
      bind = $Mod SHIFT, 2, movetoworkspacesilent, 2
      bind = $Mod SHIFT, 3, movetoworkspacesilent, 3
      bind = $Mod SHIFT, 4, movetoworkspacesilent, 4
      bind = $Mod SHIFT, 5, movetoworkspacesilent, 5
      bind = $Mod SHIFT, 6, movetoworkspacesilent, 6
      bind = $Mod SHIFT, 7, movetoworkspacesilent, 7
      bind = $Mod SHIFT, 8, movetoworkspacesilent, 8
      bind = $Mod SHIFT, 9, movetoworkspacesilent, 9

      bind = $Mod, h, movefocus, l
      bind = $Mod, j, movefocus, d
      bind = $Mod, k, movefocus, u
      bind = $Mod, l, movefocus, r

      bind = $Mod SHIFT, h, movewindow, l
      bind = $Mod SHIFT, j, movewindow, d
      bind = $Mod SHIFT, k, movewindow, u
      bind = $Mod SHIFT, l, movewindow, r

      bind = $Mod SHIFT, Q, killactive
      bind = $Mod SHIFT, SPACE, togglefloating
      bind = $Mod, f, fullscreen, 0

      bindm = $Mod, mouse:272, movewindow
      bindm = $Mod, mouse:273, resizewindow

      bind = , XF86AudioMute, exec, ${pkgs.pamixer}/bin/pamixer --toggle-mute
      bind = , XF86AudioLowerVolume, exec, ${pkgs.pamixer}/bin/pamixer --decrease 5
      bind = , XF86AudioRaiseVolume, exec, ${pkgs.pamixer}/bin/pamixer --increase 5

      bind = , XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause
      bind = , XF86AudioPause, exec, ${pkgs.playerctl}/bin/playerctl play-pause
      bind = , XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous
      bind = , XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next

      bind = , XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%-
      bind = , XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%+

      bind = $Mod, F1, exec, ${pkgs.pamixer}/bin/pamixer --toggle-mute
      bind = $Mod, F2, exec, ${pkgs.pamixer}/bin/pamixer --decrease 5
      bind = $Mod, F3, exec, ${pkgs.pamixer}/bin/pamixer --increase 5

      bind = $Mod, F5, exec, ${pkgs.playerctl}/bin/playerctl previous
      bind = $Mod, F6, exec, ${pkgs.playerctl}/bin/playerctl play-pause
      bind = $Mod, F7, exec, ${pkgs.playerctl}/bin/playerctl next

      bind = $Mod, d, exec, wofi
      bind = $Mod, w, exec, firefox
      bind = $Mod, x, exec, ${pkgs.systemd}/bin/loginctl lock-session

      bind = $Mod, RETURN, exec, foot

      bind = , PRINT, exec, ${pkgs.grimblast}/bin/grimblast copy area

      exec-once = ${pkgs.swaybg}/bin/swaybg --mode fill --image ${wallpaper}
    '';
  };
}
