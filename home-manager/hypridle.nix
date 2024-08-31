{ ... }:

{
  services.hypridle = {
    enable = true;
    settings = {
      general.lock_cmd = "hyprlock";
      listener = [
        {
          on-timeout = "hyprlock";
          timeout = 300;
        }
        {
          on-resume = "hyprctl dispatch dpms on";
          on-timeout = "hyprctl dispatch dpms off";
          timeout = 305;
        }
      ];
    };
  };
}
