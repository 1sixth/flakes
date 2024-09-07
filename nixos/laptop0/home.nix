{ pkgs, ... }:

{
  imports = [
    ../../home-manager/common.nix
    ../../home-manager/firefox.nix
    ../../home-manager/foot.nix
    ../../home-manager/hypridle.nix
    ../../home-manager/hyprland.nix
    ../../home-manager/hyprlock.nix
    ../../home-manager/hyprpaper.nix
    ../../home-manager/mpv.nix
    ../../home-manager/neovim.nix
    ../../home-manager/shell.nix
    ../../home-manager/theme.nix
    ../../home-manager/vscodium.nix
    ../../home-manager/waybar.nix
    ../../home-manager/xdg.nix
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
