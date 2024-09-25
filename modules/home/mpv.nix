{ config, pkgs, ... }:

{
  programs.mpv = {
    # https://github.com/mpv-player/mpv/blob/9cddd73f67f11dba2f2921124e2c39c77af01651/etc/input.conf
    bindings = {
      MBTN_LEFT_DBL = "cycle fullscreen"; # toggle fullscreen
      MBTN_RIGHT = "cycle pause"; # toggle pause/playback mode

      RIGHT = "seek 5"; # seek 5 seconds forward
      LEFT = "seek -5"; # seek 5 seconds backward
      UP = "seek 60"; # seek 1 minute forward
      DOWN = "seek -60"; # seek 1 minute backward

      "Shift+RIGHT" = "no-osd seek 1 exact"; # seek exactly 1 second forward
      "Shift+LEFT" = "no-osd seek -1 exact"; # seek exactly 1 second backward

      "Ctrl+RIGHT" = "add chapter 1"; # seek to the next chapter
      "Ctrl+LEFT" = "add chapter -1"; # seek to the previous chapter

      "Ctrl+Shift+RIGHT" = "playlist-next"; # skip to the next file
      "Ctrl+Shift+LEFT" = "playlist-prev"; # skip to the previous file

      "[" = "add speed -0.1"; # decrease the playback speed
      "]" = "add speed 0.1"; # increase the playback speed

      q = "quit";
      Q = "quit-watch-later"; # exit and remember the playback position

      ESC = "set fullscreen no"; # leave fullscreen

      SPACE = "cycle pause"; # toggle pause/playback mode

      i = "script-binding stats/display-stats-toggle"; # toggle displaying information and statistics

      "`" = "script-binding console/enable"; # open the console

      z = "add sub-delay 0.1"; # shift subtitles 100 ms earlier
      Z = "add sub-delay -0.1"; # delay subtitles by 100 ms

      "9" = "add volume -5";
      "0" = "add volume 5";

      m = "cycle mute"; # toggle mute

      v = "cycle sub-visibility"; # hide or show the subtitles

      h = "cycle audio"; # switch audio track
      H = "cycle audio down"; # switch audio track backwards

      j = "cycle sub"; # switch subtitle track
      J = "cycle sub down"; # switch subtitle track backwards

      f = "cycle fullscreen"; # toggle fullscreen

      l = ''cycle-values loop-file "inf" "no"''; # toggle infinite looping

      "1" = "set speed 1";
      "2" = "set speed 2";
      "3" = "set speed 3";

      POWER = "quit";
      PLAY = "cycle pause"; # toggle pause/playback mode
      PAUSE = "cycle pause"; # toggle pause/playback mode
      PLAYPAUSE = "cycle pause"; # toggle pause/playback mode
      PLAYONLY = "set pause no"; # unpause
      PAUSEONLY = "set pause yes"; # pause
      STOP = "quit";
      FORWARD = "seek 60"; # seek 1 minute forward
      REWIND = "seek -60"; # seek 1 minute backward
      NEXT = "playlist-next"; # skip to the next file
      PREV = "playlist-prev"; # skip to the previous file
      VOLUME_UP = "add volume 5";
      VOLUME_DOWN = "add volume -5";
      MUTE = "cycle mute"; # toggle mute
      CLOSE_WIN = "quit";

      "Ctrl+h" = "cycle-values hwdec auto-safe no"; # toggle hardware decoding

      F8 = "show-text \${playlist}"; # show the playlist
      F9 = "show-text \${track-list}"; # show the list of video, audio and sub tracks
    };
    config = {
      cscale = "ewa_lanczos";
      dscale = "ewa_lanczos";
      demuxer-max-bytes = "1GiB";
      drm-vrr-enabled = "auto";
      fullscreen = "";
      gpu-api = "vulkan";
      hwdec = "auto-safe";
      keep-open = "yes";
      no-input-default-bindings = "";
      profile = "gpu-hq";
      scale = "ewa_lanczos";
      scale-blur = "0.981251";
      script-opts-append = [
        "sponsorblock-categories=sponsor"
        "sponsorblock-report_views=no"
      ];
      slang = "en,ai-zh";
      sub-auto = "fuzzy";
      vo = "gpu-next";
      volume-max = "100";
      # The yt-dlp invoked by mpv doesn't really use all the settings defined
      # in ~/.config/yt-dlp/config, so a bit of duplication is necessary here.
      ytdl-raw-options-append = [
        "sub-langs=${config.programs.yt-dlp.settings.sub-langs}"
      ];
    };
    enable = true;
    scripts = with pkgs.mpvScripts; [
      autoload
      mpris
      sponsorblock
    ];
  };
}
