{ config, ... }:

{
  xdg = {
    configFile = {
      # https://github.com/rydesun/dotfiles/tree/ef1f12bac03ce724f3c90380140dc96abf604478/.config/fontconfig/conf.d
      "fontconfig/conf.d/50-generic.conf".source = ./res/fontconfig/50-generic.conf;
      "fontconfig/conf.d/51-language-noto-cjk.conf".source = ./res/fontconfig/51-language-noto-cjk.conf;
      "fontconfig/conf.d/52-replace.conf".source = ./res/fontconfig/52-replace.conf;
      "go/env".text = ''
        GOBIN=${config.home.homeDirectory}/.local/bin
        GOPATH=${config.xdg.cacheHome}/go
        GOPROXY=https://goproxy.cn,direct
      '';
    };
    enable = true;
    mimeApps = {
      defaultApplications = {
        "audio/flac" = [ "mpv.desktop" ];
        "application/pdf" = [ "okularApplication_pdf.desktop" ];
        "image/jpeg" = [ "imv-dir.desktop" ];
        "image/gif" = [ "imv-dir.desktop" ];
        "image/png" = [ "imv-dir.desktop" ];
        "image/webp" = [ "imv-dir.desktop" ];
        "inode/directory" = [ "yazi.desktop" ];
        "text/html" = [ "firefox-esr.desktop" ];
        "video/mp4" = [ "mpv.desktop" ];
        "video/quicktime" = [ "mpv.desktop" ];
        "video/webm" = [ "mpv.desktop" ];
        "video/x-matroska" = [ "mpv.desktop" ];
        "x-scheme-handler/http" = [ "firefox-esr.desktop" ];
        "x-scheme-handler/https" = [ "firefox-esr.desktop" ];
        "x-scheme-handler/mailto" = [ "thunderbird.desktop" ];
        "x-scheme-handler/tg" = [ "org.telegram.desktop.desktop" ];
      };
      enable = true;
    };
    userDirs = {
      desktop = config.xdg.userDirs.download;
      documents = config.xdg.userDirs.download;
      download = "${config.home.homeDirectory}/Download";
      enable = true;
    };
  };
}
