{ config, pkgs, ... }:

{
  gtk = {
    enable = true;
    font = {
      name = "sans-serif";
      size = 12;
    };
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus";
    };
    theme = {
      package = pkgs.arc-theme;
      name = "Arc-Lighter";
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    name = "phinger-cursors-dark";
    package = pkgs.phinger-cursors;
    size = 24;
  };
}
