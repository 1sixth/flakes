{ ... }:

{
  programs.fish = {
    enable = true;
    functions = {
      colmena.body = ''
        switch $argv[1]
            case apply build
                command colmena $argv --evaluator streaming --keep-result
            case "*"
                command colmena $argv
        end
      '';
      nl.body = "nix-locate --whole-name bin/$argv";
      u.body = ''
        set -e all_proxy
        set -e ftp_proxy
        set -e http_proxy
        set -e https_proxy
        set -e no_proxy
        set -e rsync_proxy
      '';
      which.body = "realpath (command which $argv)";
    };
    interactiveShellInit = ''
      [ (tty) = /dev/tty1 ] && exec Hyprland

      set -g fish_greeting
    '';
    shellAliases = {
      sys = "sudo systemctl";
      sysu = "systemctl --user";

      jou = "journalctl";
      jouu = "journalctl --user";

      t = "trans en:zh-CN";
      ts = "t -speak";

      nixos-rebuild = "nixos-rebuild --use-remote-sudo --verbose";

      nwdrc = "nix why-depends /run/current-system";

      ncf = "nix copy --no-check-sigs --from";
    };
  };
}
