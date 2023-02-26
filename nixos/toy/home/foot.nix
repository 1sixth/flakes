{ ... }:

{
  programs.foot = {
    enable = true;
    settings = {
      colors = {
        background = "eeeeee";
        foreground = "444444";

        regular0 = "eeeeee";
        regular1 = "af0000";
        regular2 = "008700";
        regular3 = "5f8700";
        regular4 = "0087af";
        regular5 = "878787";
        regular6 = "005f87";
        regular7 = "764e37";

        bright0 = "bcbcbc";
        bright1 = "d70000";
        bright2 = "d70087";
        bright3 = "8700af";
        bright4 = "d75f00";
        bright5 = "d75f00";
        bright6 = "4c7a5d";
        bright7 = "005f87";
      };
      cursor.color = "eeeeee 444444";
      main = {
        dpi-aware = "no";
        font = "monospace:size=26";
        pad = "6x6";
        selection-target = "clipboard";
        underline-offset = "20px";
      };
    };
  };
}
