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
    (prismlauncher.override {
      jdks = with pkgs; [
        jdk17
        jdk21
      ];
      withWaylandGLFW = true;
    })
    mumble
  ];

  programs.thunderbird = {
    enable = true;
    package = pkgs.thunderbird.override {
      extraPolicies = {
        Proxy = {
          Mode = "manual";
          SOCKSProxy = "127.0.0.1:1080";
          SOCKSVersion = 5;
          UseProxyForDNS = true;
        };
      };
    };
    profiles.default.isDefault = true;
  };
}
