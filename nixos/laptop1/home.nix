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
      kubectl
      kubernetes-helm
      maven
      minikube

      jetbrains.idea-community
    ];
    sessionVariables.JAVA_HOME = "${pkgs.jdk8}/lib/openjdk";
  };

  programs = {
    # https://minikube.sigs.k8s.io/docs/handbook/vpn_and_proxy/
    firefox.policies.Proxy.Passthrough = builtins.concatStringsSep "," [
      "127.0.0.1"
      "localhost"
      "192.168.59.0/24"
      "192.168.39.0/24"
      "192.168.49.0/24"
      "10.96.0.0/12"
    ];
    vscode = {
      extensions = with pkgs.vscode-marketplace; [
        redhat.java
        vmware.vscode-spring-boot
        vscjava.vscode-java-debug
        vscjava.vscode-java-dependency
        vscjava.vscode-java-test
        vscjava.vscode-maven
        vscjava.vscode-spring-boot-dashboard
        vscjava.vscode-spring-initializr
      ];
      userSettings = {
        "java.compile.nullAnalysis.mode" = "automatic";
        "java.jdt.ls.java.home" = "${pkgs.jdk17}/lib/openjdk";
        "maven.view" = "hierarchical";
      };
    };
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
