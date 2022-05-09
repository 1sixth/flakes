_:

{
  programs.foot = {
    enable = true;
    settings = {
      colors = {
        background = "eeeeee";
        foreground = "878787";

        regular0 = "eeeeee";
        regular1 = "af0000";
        regular2 = "008700";
        regular3 = "5f8700";
        regular4 = "0087af";
        regular5 = "878787";
        regular6 = "005f87";
        regular7 = "444444";

        bright0 = "bcbcbc";
        bright1 = "d70000";
        bright2 = "d70087";
        bright3 = "8700af";
        bright4 = "d75f00";
        bright5 = "d75f00";
        bright6 = "005faf";
        bright7 = "005f87";
      };
      cursor.color = "eeeeee 878787";
      main = {
        font = "monospace:size=17";
        dpi-aware = "no";
        pad = "6x6";
        selection-target = "clipboard";
        underline-offset = "20px";
      };
    };
  };
}
