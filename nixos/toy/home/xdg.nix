{ config, pkgs, ... }:

{
  xdg = {
    configFile = {
      "baloofilerc".text = ''
        [Basic Settings]
        Indexing-Enabled=false
      '';
      # https://github.com/VSCodium/vscodium/blob/f73d7b632b48851bd4c0ae27794fc4e84b6f3d1d/DOCS.md#how-to-use-a-different-extension-gallery
      "VSCodium/product.json".text = ''
        {
          "extensionsGallery": {
            "serviceUrl": "https://marketplace.visualstudio.com/_apis/public/gallery",
            "itemUrl": "https://marketplace.visualstudio.com/items",
            "cacheUrl": "https://vscode.blob.core.windows.net/gallery/index",
            "controlUrl": "",
          }
        }
      '';
      # https://github.com/rydesun/dotfiles/tree/ef1f12bac03ce724f3c90380140dc96abf604478/.config/fontconfig/conf.d
      "fontconfig/conf.d/50-generic.conf".source = ./res/fontconfig/50-generic.conf;
      "fontconfig/conf.d/51-language-noto-cjk.conf".source = ./res/fontconfig/51-language-noto-cjk.conf;
      "fontconfig/conf.d/52-replace.conf".source = ./res/fontconfig/52-replace.conf;
    };
    enable = true;
    mimeApps = {
      defaultApplications = {
        "audio/flac" = [ "org.kde.elisa.desktop" ];
        "application/pdf" = [ "org.kde.okular.desktop" ];
        "image/jpeg" = [ "org.kde.gwenview.desktop" ];
        "image/gif" = [ "org.kde.gwenview.desktop" ];
        "image/png" = [ "org.kde.gwenview.desktop" ];
        "image/webp" = [ "org.kde.gwenview.desktop" ];
        "inode/directory" = [ "org.kde.dolphin.desktop" ];
        "text/html" = [ "firefox.desktop" ];
        "text/plain" = [ "codium.desktop" ];
        "video/mp4" = [ "mpv.desktop" ];
        "video/quicktime" = [ "mpv.desktop" ];
        "video/webm" = [ "mpv.desktop" ];
        "video/x-matroska" = [ "mpv.desktop" ];
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
        "x-scheme-handler/mailto" = [ "thunderbird.desktop" ];
        "x-scheme-handler/tg" = [ "org.telegram.desktop.desktop" ];
      };
      enable = true;
    };
    userDirs = {
      createDirectories = true;
      desktop = config.xdg.userDirs.download;
      documents = config.xdg.userDirs.download;
      download = "${config.home.homeDirectory}/Download";
      enable = true;
      music = config.xdg.userDirs.download;
      pictures = "${config.xdg.userDirs.download}/Picture";
      publicShare = config.xdg.userDirs.download;
      templates = config.xdg.userDirs.download;
      videos = "${config.xdg.userDirs.download}/Video";
    };
  };
}
