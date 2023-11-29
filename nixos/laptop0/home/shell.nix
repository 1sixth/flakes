{ pkgs, ... }:

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
      mpv.body = ''
        if string match --quiet --regex "^https:\/\/.*\.bilibili\.com" -- $argv
            command mpv --ytdl-raw-options=cookies-from-browser=firefox $argv
        else
            command mpv $argv
        end
      '';
      nl.body = "nix-locate --whole-name bin/$argv";
      podman.body = ''
        switch $argv[1]
            case build create run
                command podman $argv[1] --http-proxy=false $argv[2..]
            case "*"
                command podman $argv
        end
      '';
      which.body = "realpath (command which $argv)";
      yt-dlp.body = ''
        if string match --quiet --regex "^https:\/\/.*\.bilibili\.com" -- $argv
            command yt-dlp --cookies-from-browser=firefox $argv
        else
            command yt-dlp $argv
        end
      '';
    };
    interactiveShellInit = ''
      [ (tty) = /dev/tty1 ] && exec Hyprland

      set -g fish_greeting
      set -gx DIRENV_LOG_FORMAT ""
    '';
    plugins = [
      {
        name = "autopair";
        src = pkgs.fetchFromGitHub
          {
            owner = "jorgebucaran";
            repo = "autopair.fish";
            rev = "1.0.4";
            sha256 = "sha256-s1o188TlwpUQEN3X5MxUlD/2CFCpEkWu83U9O+wg3VU=";
          };
      }
      {
        name = "puffer";
        src = pkgs.fetchFromGitHub {
          owner = "nickeb96";
          repo = "puffer-fish";
          rev = "fd0a9c95da59512beffddb3df95e64221f894631";
          hash = "sha256-aij48yQHeAKCoAD43rGhqW8X/qmEGGkg8B4jSeqjVU0=";
        };
      }
    ];
    shellAliases = {
      l = "ll --all";
      ll = "ls --group --long --time-style=long-iso";
      ls = "eza --group-directories-first --no-quotes";
      tree = "ls --tree";

      sys = "sudo systemctl";
      sysu = "systemctl --user";

      jou = "journalctl";
      jouu = "journalctl --user";

      t = "trans en:zh-CN";
      ts = "t -speak";

      nixos-rebuild = "nixos-rebuild --use-remote-sudo --verbose";

      nwdrc = "nix why-depends /run/current-system";

      ncf = "nix copy --no-check-sigs --from";

      mpvn = "mpv --ytdl-raw-options=no-write-auto-subs=";

      vol = "pamixer --set-volume";
    };
  };
}
