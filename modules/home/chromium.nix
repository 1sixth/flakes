{ ... }:

{
  programs.chromium = {
    commandLineArgs = [
      "--proxy-server=socks5://127.0.0.1:1080"
    ];
    enable = true;
  };
}
