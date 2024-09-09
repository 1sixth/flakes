{ self, ... }:

{
  imports = builtins.attrValues self.homeModules;

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
