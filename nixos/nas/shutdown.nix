{ pkgs, ... }:

{
  systemd = {
    services.shutdown = {
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.systemd}/bin/shutdown now";
      };
    };
    timers.shutdown = {
      # I really hope I can write `Sun..Thu 23:25`.
      timerConfig.OnCalendar = "Sun,Mon..Thu 23:25";
      wantedBy = [ "timers.target" ];
    };
  };
}
