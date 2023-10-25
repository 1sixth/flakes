{
  base = import ./base.nix;
  hath = import ./hath.nix;
  proxy = {
    server = import ./proxy/server.nix;
    client = import ./proxy/client.nix;
  };
  qbittorrent-nox = import ./qbittorrent-nox.nix;
  resolved = {
    china = import ./resolved/china.nix;
    earth = import ./resolved/earth.nix;
  };
  server = import ./server;
  stress-ng = import ./stress-ng.nix;
}
