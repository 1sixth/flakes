{ config, inputs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      inherit (inputs.berberman.packages.${prev.system}) fcitx5-pinyin-moegirl fcitx5-pinyin-zhwiki;
      inherit (inputs.nix-index-database.packages.${prev.system}) nix-index-with-db;
      inherit
        (inputs.nix-vscode-extensions.extensions.${prev.system}.forVSCodeVersion
          config.home-manager.users.one6th.programs.vscode.package.version
        )
        vscode-marketplace
        ;

      dmlive = prev.dmlive.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [
          (prev.writeText "dmlive.patch" ''
            diff --git a/src/streamfinder/bilibili.rs b/src/streamfinder/bilibili.rs
            index fede547..eb8e1a1 100644
            --- a/src/streamfinder/bilibili.rs
            +++ b/src/streamfinder/bilibili.rs
            @@ -268,6 +268,9 @@ impl Bilibili {
                         param1.push(("cid", cid.as_str()));
                         param1.push(("bvid", bvid.as_str()));
                         param1.push(("fnval", "3024"));
            +            if cookies.is_empty() {
            +                param1.push(("try_look", "1"));
            +            }
                         let client = reqwest::Client::builder()
                             .user_agent(crate::utils::gen_ua_safari())
                             .connect_timeout(tokio::time::Duration::from_secs(10))
          '')
        ];
      });

      ff2mpv = prev.ff2mpv.overrideAttrs (old: {
        buildInputs = old.buildInputs ++ [ final.dmlive ];
        patches = (old.patches or [ ]) ++ [
          (prev.writeText "ff2mpv.patch" ''
            diff --git a/ff2mpv.py b/ff2mpv.py
            index 01a0353..ff1a7ab 100755
            --- a/ff2mpv.py
            +++ b/ff2mpv.py
            @@ -13,7 +13,10 @@ def main():
                 url = message.get("url")
                 options = message.get("options") or []

            -    args = ["mpv", "--no-terminal", *options, "--", url]
            +    if "www.bilibili.com" in url:
            +        args = ["dmlive", "--url", url]
            +    else:
            +        args = ["mpv", "--no-terminal", *options, "--", url]

                 kwargs = {}
                 # https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/Native_messaging#Closing_the_native_app
          '')
        ];
      });

      telegram-desktop = prev.telegram-desktop.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [
          (prev.fetchpatch {
            url = "https://raw.githubusercontent.com/Layerex/telegram-desktop-patches/e9bc651c55cb32c741f5e147a781d5c2e77fb77b/0001-Disable-sponsored-messages.patch";
            hash = "sha256-HeDH6tkkGx2XYTtzfo+gRee4BYxRiPKXQuftycl8Kvo=";
          })
          (prev.fetchpatch {
            url = "https://raw.githubusercontent.com/Layerex/telegram-desktop-patches/e9bc651c55cb32c741f5e147a781d5c2e77fb77b/0002-Disable-saving-restrictions.patch";
            hash = "sha256-sQsyXlvhXSvouPgzYSiRB8ieICo3GDXWH5MaZtBjtqw=";
          })
          (prev.fetchpatch {
            url = "https://raw.githubusercontent.com/Layerex/telegram-desktop-patches/e9bc651c55cb32c741f5e147a781d5c2e77fb77b/0003-Disable-invite-peeking-restrictions.patch";
            hash = "sha256-8mJD6LOjz11yfAdY4QPK/AUz9o5W3XdupXxy7kRrbC8=";
          })
          (prev.fetchpatch {
            url = "https://raw.githubusercontent.com/Layerex/telegram-desktop-patches/e9bc651c55cb32c741f5e147a781d5c2e77fb77b/0004-Disable-accounts-limit.patch";
            hash = "sha256-PZWCFdGE/TTJ1auG1JXNpnTUko2rCWla6dYKaQNzreg=";
          })
          (prev.fetchpatch {
            url = "https://raw.githubusercontent.com/Layerex/telegram-desktop-patches/e9bc651c55cb32c741f5e147a781d5c2e77fb77b/0005-Option-to-disable-stories.patch";
            hash = "sha256-aSAjyFiOg8JLgYA3voijVvkGIgK93kNMx40vqHsvW8Y=";
          })
        ];
      });
    })
  ];
}
