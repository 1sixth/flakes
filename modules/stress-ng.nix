{ pkgs, ... }:

{
  systemd.services.stress-ng = {
    description = "Keep 15% Memory Usage";
    serviceConfig = {
      DynamicUser = true;
      ExecStart = "${pkgs.stress-ng}/bin/stress-ng --timeout 0 --vm 1 --vm-bytes 15% --vm-hang 0 --vm-locked";
      LimitMEMLOCK = "infinity";
      StateDirectory = "stress-ng";
      Type = "exec";
      WorkingDirectory = "/var/lib/stress-ng/";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
