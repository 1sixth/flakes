{ config, pkgs, ... }:

{
  networking.proxy.default = "http://127.0.0.1:1080";

  sops.secrets."sing-box.json".restartUnits = [ "sing-box.service" ];

  # https://github.com/SagerNet/sing-box/blob/66d8d563eba3914280b5b4283603c20f3c5d0889/release/local/sing-box.service
  systemd.services.sing-box = {
    description = "sing-box service";
    documentation = [ "https://sing-box.sagernet.org" ];
    after = [ "network.target" "nss-lookup.target" ];
    serviceConfig = {
      WorkingDirectory = "/var/lib/sing-box/";
      CapabilityBoundingSet = [ "CAP_NET_ADMIN" "CAP_NET_BIND_SERVICE" ];
      AmbientCapabilities = [ "CAP_NET_ADMIN" "CAP_NET_BIND_SERVICE" ];
      ExecStart = "${pkgs.sing-box}/bin/sing-box run -c /run/credentials/sing-box.service/sing-box.json";
      Restart = "on-failure";
      RestartSec = "10s";
      LimitNOFILE = "infinity";
      DynamicUser = true;
      StateDirectory = "sing-box";
      LoadCredential = "sing-box.json:${config.sops.secrets."sing-box.json".path}";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
