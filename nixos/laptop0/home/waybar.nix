{ pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    settings = [{
      battery = {
        format = "{capacity}% {icon}";
        format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
        interval = 1;
      };
      bluetooth = {
        format = "";
        format-connected-battery = "{device_battery_percentage}% 󰥉";
        format-device-preference = [ "WF-1000XM4" ];
      };
      clock.format = "{:%F %A %R}";
      cpu = {
        format = "{usage}% ";
        interval = 1;
      };
      "hyprland/workspaces" = {
        format = "{name} {icon}";
        format-icons = {
          active = "";
          default = "";
        };
      };
      idle_inhibitor = {
        format = "{icon}";
        format-icons = {
          activated = "󰈈";
          deactivated = "󰈉";
        };
      };
      keyboard-state = {
        capslock = true;
        format.capslock = "{icon}";
        format-icons = {
          locked = "󰪛";
          unlocked = "";
        };
      };
      memory = {
        format = "{percentage}% ";
        interval = 1;
      };
      modules-center = [
        "clock"
      ];
      modules-left = [
        "hyprland/workspaces"
        "bluetooth"
        "cpu"
        "memory"
        "idle_inhibitor"
        "keyboard-state"
      ];
      modules-right = [
        "network"
        "tray"
        "battery"
        "pulseaudio"
      ];
      network = {
        format-disconnected = "Disconnected ";
        format-ethernet = "{bandwidthDownBytes}  {bandwidthUpBytes}  ";
        format-wifi = "{bandwidthDownBytes}  {bandwidthUpBytes}  {essid} ({signalStrength}%) ";
        interval = 1;
      };
      position = "bottom";
      pulseaudio = {
        format = "{volume}% {icon}";
        format-bluetooth = "{volume}% 󰂰";
        format-icons.default = [ "󰕿" "󰖀" "󰕾" ];
        format-muted = "󰸈";
        ignored-sinks = [ "Easy Effects Sink" ];
        on-click = "${pkgs.pamixer}/bin/pamixer -t";
        scroll-step = 5;
      };
      spacing = 10;
      tray.spacing = 10;
    }];
    style = ./res/waybar.css;
    systemd.enable = true;
  };
}
