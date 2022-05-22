{ config, ... }:

{
  xdg = {
    configFile = {
      # https://github.com/VSCodium/vscodium/blob/master/DOCS.md#extensions-marketplace
      "VSCodium/product.json".text = ''
        {
          "extensionsGallery": {
            "serviceUrl": "https://marketplace.visualstudio.com/_apis/public/gallery",
            "cacheUrl": "https://vscode.blob.core.windows.net/gallery/index",
            "itemUrl": "https://marketplace.visualstudio.com/items",
            "controlUrl": "",
            "recommendationsUrl": ""
          }
        }
      '';
      "wofi/config".text = ''
        insensitive=true
        layer=overlay
        show=drun
      '';
      # Based on https://github.com/rydesun/dotfiles/tree/master/.config/fontconfig/conf.d.
      "fontconfig/conf.d/50-generic.conf".source = ./res/fontconfig/50-generic.conf;
      "fontconfig/conf.d/51-language-noto-cjk.conf".source = ./res/fontconfig/51-language-noto-cjk.conf;
      "fontconfig/conf.d/52-replace.conf".source = ./res/fontconfig/52-replace.conf;
      "wofi/style.css".source = ./res/wofi.css;
      "yt-dlp/channel-config".source = ./res/yt-dlp/channel-config;
      "yt-dlp/config".source = ./res/yt-dlp/config;
      "yt-dlp/playlist-config".source = ./res/yt-dlp/playlist-config;
    };
    enable = true;
    mimeApps = {
      defaultApplications = {
        "application/pdf" = [ "chromium.desktop" ];
        "image/jpeg" = [ "imv-folder.desktop" ];
        "image/gif" = [ "imv-folder.desktop" ];
        "image/png" = [ "imv-folder.desktop" ];
        "inode/directory" = [ "pcmanfm-qt.desktop" ];
        "text/html" = [ "chromium.desktop" ];
        "video/mp4" = [ "mpv.desktop" ];
        "video/webm" = [ "mpv.desktop" ];
        "video/x-matroska" = [ "mpv.desktop" ];
        "x-scheme-handler/http" = [ "chromium.desktop" ];
        "x-scheme-handler/https" = [ "chromium.desktop" ];
        "x-scheme-handler/mailto" = [ "chromium.desktop" ];
      };
      enable = true;
    };
    userDirs = {
      createDirectories = true;
      desktop = config.xdg.userDirs.download;
      documents = config.xdg.userDirs.download;
      download = "$HOME/Download";
      enable = true;
      music = config.xdg.userDirs.download;
      pictures = "${config.xdg.userDirs.download}/Picture";
      publicShare = config.xdg.userDirs.download;
      templates = config.xdg.userDirs.download;
      videos = "${config.xdg.userDirs.download}/Video";
    };
  };
}
