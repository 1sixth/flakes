{ config, pkgs, ... }:

{
  networking.proxy.default = "http://127.0.0.1:1080";

  sops.secrets."sing-box.json".restartUnits = [ "sing-box.service" ];

  systemd = {
    packages = [ pkgs.sing-box ];
    services.sing-box = {
      preStart = "ln -fsT ${pkgs.metacubexd} $STATE_DIRECTORY/dashboard";
      serviceConfig = {
        DynamicUser = "yes";
        ExecStart = [
          ""
          "${pkgs.sing-box}/bin/sing-box -C $CREDENTIALS_DIRECTORY run"
        ];
        LoadCredential = [ "config.json:${config.sops.secrets."sing-box.json".path}" ];
        StateDirectory = "sing-box";
        WorkingDirectory = "/var/lib/sing-box";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
