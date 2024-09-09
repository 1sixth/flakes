{ pkgs, ... }:

{
  networking.proxy.default = "http://127.0.0.1:1080";

  sops.secrets."sing-box.json" = {
    path = "/etc/sing-box/config.json";
    restartUnits = [ "sing-box.service" ];
  };

  systemd = {
    packages = [ pkgs.sing-box ];
    services.sing-box = {
      preStart = ''
        ln -sf ${pkgs.sing-geoip}/share/sing-box/geoip.db /var/lib/sing-box/geoip.db
        ln -sf ${pkgs.sing-geosite}/share/sing-box/geosite.db /var/lib/sing-box/geosite.db
      '';
      serviceConfig = {
        DynamicUser = "yes";
        StateDirectory = "sing-box";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
