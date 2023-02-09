{
  # TODO: Declare that `v2ray.server` and `qbittorrent-nox`
  # depend on `server`.
  dnscrypt-proxy2 = {
    china = import ./dnscrypt-proxy2/china.nix;
    earth = import ./dnscrypt-proxy2/earth.nix;
  };
  hath = import ./hath.nix;
  qbittorrent-nox = import ./qbittorrent-nox.nix;
  server = import ./server;
  sing-box = {
    client = import ./sing-box/client.nix;
    server = import ./sing-box/server.nix;
  };
  stress-ng = import ./stress-ng.nix;
  v2ray = {
    server = import ./v2ray/server.nix;
    client = import ./v2ray/client.nix;
  };
}
