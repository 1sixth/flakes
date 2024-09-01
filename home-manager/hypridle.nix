{ ... }:

{
  services.hypridle = {
    enable = true;
    settings = {
      general.lock_cmd = "hyprlock";
      # This is probably a bug, see hypridle/issues/86 for more details.
      listener = [
        # lock the screen after 1 minute
        {
          on-timeout = "loginctl lock-session";
          timeout = 60;
        }
        # then turn the screen off after 2 minutes
        {
          on-resume = "hyprctl dispatch dpms on";
          on-timeout = "hyprctl dispatch dpms off";
          timeout = 120;
        }
      ];
    };
  };
}
