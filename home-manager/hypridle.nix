{ ... }:

{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        before_sleep_cmd = "loginctl lock-session";
        lock_cmd = "hyprlock";
      };
      # This is probably a bug, see hypridle/issues/86 for more details.
      listener = [
        # lock the screen after 5 minute
        {
          on-timeout = "loginctl lock-session";
          timeout = 300;
        }
        # then turn the screen off after 5 minutes and 5 seconds
        {
          on-resume = "hyprctl dispatch dpms on";
          on-timeout = "hyprctl dispatch dpms off";
          timeout = 305;
        }
      ];
    };
  };
}
