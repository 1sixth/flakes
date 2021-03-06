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
    package = pkgs.vimix-icon-theme;
    gtk.enable = true;
    name = "Vimix";
    size = 24;
    x11.enable = true;
  };

  xdg.configFile = {
    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=KvArc
    '';
    "qt5ct/qt5ct.conf".text = ''
      [Appearance]
      icon_theme=${config.gtk.iconTheme.name}
      style=kvantum

      [Fonts]
      fixed=@Variant(\0\0\0@\0\0\0\x12\0M\0o\0n\0o\0s\0p\0\x61\0\x63\0\x65@(\0\0\0\0\0\0\xff\xff\xff\xff\x5\x1\0\x32\x10)
      general=@Variant(\0\0\0@\0\0\0\x14\0S\0\x61\0n\0s\0 \0S\0\x65\0r\0i\0\x66@(\0\0\0\0\0\0\xff\xff\xff\xff\x5\x1\0\x32\x10)
    '';
  };

  # https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland.
  wayland.windowManager.sway.config.startup = [{
    always = true;
    command = (pkgs.writeShellScript "import_gsettings" ''
      ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface cursor-theme ${config.home.pointerCursor.name}
      ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface cursor-size ${builtins.toString config.home.pointerCursor.size}
      ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface font-name ${config.gtk.font.name}
      ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface gtk-theme ${config.gtk.theme.name}
      ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface icon-theme ${config.gtk.iconTheme.name}
    '').outPath;
  }];
}
