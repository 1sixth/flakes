{
  base = import ./base.nix;
  dnscrypt-proxy2 = {
    china = import ./dnscrypt-proxy2/china.nix;
    earth = import ./dnscrypt-proxy2/earth.nix;
  };
  hath = import ./hath.nix;
  proxy = {
    server = import ./proxy/server.nix;
    client = import ./proxy/client.nix;
  };
  qbittorrent-nox = import ./qbittorrent-nox.nix;
  server = import ./server;
  stress-ng = import ./stress-ng.nix;
}
