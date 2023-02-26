{ config, pkgs, ... }:

{
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

  # https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland.
  wayland.windowManager.sway.config.startup = [{
    always = true;
    command = (pkgs.writeShellScript "import-gsettings" ''
      ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface cursor-theme ${config.home.pointerCursor.name}
      ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface cursor-size ${builtins.toString config.home.pointerCursor.size}
      ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface font-name ${config.gtk.font.name}
      ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface gtk-theme ${config.gtk.theme.name}
      ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface icon-theme ${config.gtk.iconTheme.name}
    '').outPath;
  }];
}
