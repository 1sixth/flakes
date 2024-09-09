{ pkgs, self, ... }:

{
  imports = builtins.attrValues self.homeModules;

  home.packages = with pkgs; [
    # GUI
    mumble
    prismlauncher
  ];

  wayland.windowManager.hyprland.settings.device = [
    {
      accel_profile = "adaptive";
      middle_button_emulation = true;
      name = "uniw0001:00-093a:0255-touchpad";
      natural_scroll = true;
    }
  ];
}
