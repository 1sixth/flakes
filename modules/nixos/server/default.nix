{
  config,
  lib,
  pkgs,
  ...
}:

{
  deployment = {
    buildOnTarget = lib.mkIf (config.nixpkgs.system != "x86_64-linux") true;
    tags = [ "server" ];
  };

  documentation = {
    doc.enable = false;
    enable = false;
    man.enable = false;
    nixos.enable = false;
  };

  environment = {
    persistence."/persistent/impermanence".files = [
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
    ];
    # print the URL instead
    sessionVariables.BROWSER = "echo";
    stub-ld.enable = false;
    systemPackages = with pkgs; [
      screen
    ];
  };

  fonts.fontconfig.enable = false;

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 14d";
  };

  programs = {
    fish.shellAliases = {
      sys = "systemctl";

      jou = "journalctl";
    };
    git.enable = true;
    neovim = {
      configure.customRC = "set mouse=";
      defaultEditor = true;
      enable = true;
      viAlias = true;
      vimAlias = true;
      withRuby = false;
    };
  };

  security.sudo.enable = false;

  services.openssh = {
    enable = true;
    hostKeys = [
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
    ports = [
      22
      2222
    ];
    settings = {
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
    };
  };

  sops = {
    secrets.password_root = {
      neededForUsers = true;
      sopsFile = ./secrets.yaml;
    };
  };

  systemd.network.networks.default.matchConfig.Type = "ether";

  users.users.root = {
    hashedPasswordFile = config.sops.secrets.password_root.path;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAHOSqODpw3my6PkhWrAD/sulDNCiNjKqLjNOtFPMFwr" # Normal ssh-ed25519 Key
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIFo0aSRnBTZxloY4B3UBOtuRJVEKjs5qgjKerAB2sSr7AAAABHNzaDo=" # ed25519-sk Resident Key
    ];
  };

  xdg = {
    autostart.enable = false;
    icons.enable = false;
    menus.enable = false;
    mime.enable = false;
  };
}
