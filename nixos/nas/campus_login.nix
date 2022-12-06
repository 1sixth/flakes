{ config, pkgs, ... }:

{
  sops.secrets.campus_login = { };

  systemd = {
    services.campus_login = {
      after = [ "network-online.target" ];
      serviceConfig = {
        Type = "oneshot";
        EnvironmentFile = config.sops.secrets.campus_login.path;
        ExecStart = pkgs.writeShellScript "campus_login.sh"
          ''
            TYPE=Internet

            TEST_URL="http://1.0.0.1/"
            AUTH_URL="http://172.19.1.9:8080/eportal/InterFace.do?method=login"

            QUERYSTRING=$(${pkgs.curl}/bin/curl --noproxy "*" -s $TEST_URL | ${pkgs.gnugrep}/bin/grep -oP "(?<=\?).*(?=\')")

            ${pkgs.curl}/bin/curl --noproxy "*" -s $AUTH_URL \
                --data-urlencode userId=$USERNAME \
                --data-urlencode password="$PASSWORD" \
                --data-urlencode service="$TYPE" \
                --data-urlencode queryString="$QUERYSTRING"
          '';
      };
      wants = [ "network-online.target" ];
    };
    timers.campus_login = {
      timerConfig.OnCalendar = "*:0/5";
      wantedBy = [ "timers.target" ];
    };
  };
}
