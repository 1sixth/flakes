{ self, ... }:

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

  home.file.".ssh/config".text = ''
    Host *.9875321.xyz
      Port 2222
  '';

  wayland.windowManager.hyprland.settings.device = [
    {
      accel_profile = "adaptive";
      middle_button_emulation = true;
      name = "pnp0c50:00-093a:0255-touchpad";
      natural_scroll = true;
    }
  ];
}
