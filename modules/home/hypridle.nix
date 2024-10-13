{ pkgs, ... }:

{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        before_sleep_cmd = "loginctl lock-session";
        lock_cmd = "${pkgs.hyprlock}/bin/hyprlock";
      };
      listener = [
        {
          on-timeout = "loginctl lock-session";
          timeout = 120;
        }
        {
          on-resume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
          on-timeout = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
          timeout = 300;
        }
      ];
    };
  };
}
