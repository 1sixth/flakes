{ config, pkgs, ... }:

{
  dconf.settings."org/gnome/desktop/interface" = {
    cursor-theme = config.home.pointerCursor.name;
    cursor-size = config.home.pointerCursor.size;
    font-name = config.gtk.font.name + " " + builtins.toString config.gtk.font.size;
    gtk-theme = config.gtk.theme.name;
    icon-theme = config.gtk.iconTheme.name;
  };

  gtk = {
    enable = true;
    font = {
      name = "sans-serif";
      size = 18;
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
    name = "phinger-cursors";
    package = pkgs.phinger-cursors;
    size = 24;
  };
}
