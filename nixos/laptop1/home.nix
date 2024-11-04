{ pkgs, self, ... }:

{
  imports = builtins.attrValues self.homeModules;

  home = {
    file = {
      ".jdks/jdk8".source = "${pkgs.jdk8}/lib/openjdk";
      ".jdks/jdk11".source = "${pkgs.jdk11}/lib/openjdk";
      ".jdks/jdk17".source = "${pkgs.jdk17}/lib/openjdk";
      ".jdks/jdk21".source = "${pkgs.jdk21}/lib/openjdk";
    };
    packages = with pkgs; [
      maven

      jetbrains.idea-community
    ];
  };

  wayland.windowManager.hyprland.settings.device = [
    {
      accel_profile = "adaptive";
      middle_button_emulation = true;
      name = "pnp0c50:00-093a:0255-touchpad";
      natural_scroll = true;
    }
  ];

  xdg.desktopEntries.idea-community = {
    exec = builtins.toString (
      pkgs.writeShellScript "idea-community" ''
        idea-community -Dawt.toolkit.name=WLToolkit
      ''
    );
    icon = "idea-community";
    name = "IntelliJ IDEA CE";
  };
}
