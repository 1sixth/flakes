{ ... }:

{
  programs.fish = {
    enable = true;
    functions = {
      colmena.body = ''
        switch $argv[1]
            case apply build
                command colmena $argv --keep-result
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
      set -gx DIRENV_LOG_FORMAT ""
    '';
    shellAliases = {
      l = "ll --all";
      ll = "ls --group --long --time-style=long-iso";
      ls = "eza --group-directories-first --no-quotes";
      tree = "ls --tree";

      sys = "sudo systemctl";
      sysu = "systemctl --user";

      jou = "journalctl";
      jouu = "journalctl --user";

      bandwhich = "bandwhich --no-resolve";

      t = "trans en:zh-CN";
      ts = "t -speak";

      nixos-rebuild = "nixos-rebuild --use-remote-sudo --verbose";

      nwdrc = "nix why-depends /run/current-system";

      ncf = "nix copy --no-check-sigs --from";
    };
  };
}
