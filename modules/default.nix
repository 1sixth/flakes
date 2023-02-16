{
  base = import ./base.nix;
  dnscrypt-proxy2 = {
    china = import ./dnscrypt-proxy2/china.nix;
    earth = import ./dnscrypt-proxy2/earth.nix;
  };
  hath = import ./hath.nix;
  qbittorrent-nox = import ./qbittorrent-nox.nix;
  server = import ./server;
  stress-ng = import ./stress-ng.nix;
  v2ray = {
    server = import ./v2ray/server.nix;
    client = import ./v2ray/client.nix;
  };
}
