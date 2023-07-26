{ ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      colors = {
        # https://github.com/alacritty/alacritty-theme/blob/master/themes/papercolor_light.yaml
        primary = {
          background = "#eeeeee";
          foreground = "#444444";
        };
        cursor = {
          text = "#eeeeee";
          cursor = "#444444";
        };
        normal = {
          black = "#eeeeee";
          red = "#af0000";
          green = "#008700";
          yellow = "#5f8700";
          blue = "#0087af";
          magenta = "#878787";
          cyan = "#005f87";
          white = "#444444";
        };
        bright = {
          black = "#bcbcbc";
          red = "#d70000";
          green = "#d70087";
          yellow = "#8700af";
          blue = "#d75f00";
          magenta = "#d75f00";
          cyan = "#005faf";
          white = "#005f87";
        };
      };
      font.size = 17;
      selection.save_to_clipboard = true;
      window = {
        dimensions = {
          columns = 80;
          lines = 30;
        };
        padding = {
          x = 5;
          y = 5;
        };
      };
    };
  };
}
