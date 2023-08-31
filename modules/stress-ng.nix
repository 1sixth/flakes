{ pkgs, ... }:

let
  stress-ng = pkgs.stress-ng.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      (pkgs.fetchpatch {
        url = "https://github.com/ColinIanKing/stress-ng/commit/39d337dbae343dcd198e26c2d83894a7f15ec4b8.patch";
        hash = "sha256-y8HvqR1ja3KvyezjZTfTeBGxvFoPs/w47qRLm0DnU08=";
        revert = true;
      })
    ];
  });
in

{
  systemd.services.stress-ng = {
    description = "Keep 15% Memory Usage";
    serviceConfig = {
      DynamicUser = true;
      ExecStart = "${stress-ng}/bin/stress-ng --timeout 0 --vm 1 --vm-bytes 15% --vm-hang 0 --vm-locked";
      LimitMEMLOCK = "infinity";
      StateDirectory = "stress-ng";
      Type = "exec";
      WorkingDirectory = "/var/lib/stress-ng";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
