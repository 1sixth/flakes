{ pkgs, self, ... }:

{
  imports = [
    self.homeModules.base
    self.homeModules.firefox
    self.homeModules.foot
    self.homeModules.hypridle
    self.homeModules.hyprland
    self.homeModules.hyprlock
    self.homeModules.hyprpaper
    self.homeModules.mpv
    self.homeModules.neovim
    self.homeModules.shell
    self.homeModules.theme
    self.homeModules.vscodium
    self.homeModules.waybar
    self.homeModules.xdg
  ];

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
