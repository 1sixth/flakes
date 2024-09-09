{ ... }:

{
  programs.hyprlock = {
    enable = true;
    settings = {
      background = [
        {
          blur_passes = 3;
          blur_size = 8;
          path = "screenshot";
        }
      ];
      general = {
        grace = 3;
        hide_cursor = true;
      };
      input-field = [
        {
          position = "0, -100";
        }
      ];
      label = [
        {
          color = "rgb(00afaf)";
          font_size = 100;
          halign = "center";
          position = "0, 100";
          text = "$TIME";
          valign = "center";
        }
      ];
    };
  };
}
