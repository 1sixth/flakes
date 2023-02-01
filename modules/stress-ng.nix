{ pkgs, ... }:

{
  systemd.services.stress-ng = {
    description = "Keep 10% CPU Usage";
    serviceConfig = {
      DynamicUser = true;
      ExecStart = "${pkgs.stress-ng}/bin/stress-ng --cpu 0 --cpu-load 10 --timeout 0";
      Nice = 19;
      StateDirectory = "stress-ng";
      WorkingDirectory = "/var/lib/stress-ng/";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
