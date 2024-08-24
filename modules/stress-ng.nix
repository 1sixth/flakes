{ pkgs, ... }:

{
  systemd.services.stress-ng = {
    description = "Keep 20% CPU Usage";
    serviceConfig = {
      DynamicUser = true;
      ExecStart = "${pkgs.stress-ng}/bin/stress-ng  --cpu 0 --cpu-load 20 --timeout 0";
      Nice = 19;
      StateDirectory = "stress-ng";
      WorkingDirectory = "/var/lib/stress-ng";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
