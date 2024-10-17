{ pkgs, ... }:

{
  # https://docs.oracle.com/en-us/iaas/Content/FreeTier/freetier_topic-Always_Free_Resources.htm
  systemd.services.stress-ng = {
    description = "Keep 25% Memory Usage";
    serviceConfig = {
      DynamicUser = true;
      ExecStart = "${pkgs.stress-ng}/bin/stress-ng  --timeout 0 --vm 1 --vm-bytes 25% --vm-hang 0 --vm-locked";
      LimitMEMLOCK = "infinity";
      StateDirectory = "stress-ng";
      WorkingDirectory = "/var/lib/stress-ng";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
