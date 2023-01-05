{ ... }:

{
  programs.chromium = {
    commandLineArgs = [
      "--ignore-gpu-blocklist"
      "--enable-gpu-rasterization"
      "--enable-zero-copy"
      "--proxy-server=socks5://127.0.0.1:1080"
    ];
    enable = true;
    extensions = [
      {
        id = "dmmjlmbkigbgpnjfiimhlnbnmppjhpea";
        updateUrl = "https://raw.githubusercontent.com/pt-plugins/PT-Plugin-Plus/master/update/index.xml";
      }
    ];
  };
}
