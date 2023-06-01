{ pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    settings = [{
      battery = {
        format = "{capacity}% {icon}";
        format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
        interval = 1;
        states = {
          critical = 15;
          warning = 30;
        };
      };
      clock.format = "{:%F %A %R}";
      cpu = {
        format = "CPU: {usage}%";
        interval = 1;
      };
      idle_inhibitor = {
        format = "{icon}";
        format-icons = {
          activated = "󰈈";
          deactivated = "󰈉";
        };
      };
      layer = "top";
      memory = {
        format = "Memory: {percentage}%";
        interval = 1;
      };
      modules-center = [
        "clock"
      ];
      modules-left = [
        "wlr/workspaces"
        "temperature"
        "cpu"
        "memory"
        "idle_inhibitor"
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
      "wlr/workspaces" = {
        format = "{name} {icon}";
        format-icons = {
          active = "";
          default = "";
          urgent = "";
        };
        on-click = "activate";
        on-scroll-down = "hyprctl dispatch workspace e+1";
        on-scroll-up = "hyprctl dispatch workspace e-1";
      };
      temperature = {
        critical-threshold = 80;
        format = "{temperatureC}℃";
        interval = 1;
      };
      tray.spacing = 10;
    }];
    style = ./res/waybar.css;
    systemd.enable = true;
  };
}
