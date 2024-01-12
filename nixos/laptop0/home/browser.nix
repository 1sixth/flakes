{ pkgs, ... }:

{
  programs = {
    chromium = {
      commandLineArgs = [
        "--enable-wayland-ime"
        "--ozone-platform-hint=auto"
        "--proxy-server=socks5://127.0.0.1:1080"
      ];
      enable = true;
      package = pkgs.ungoogled-chromium;
    };
    firefox = {
      enable = true;
      package = (pkgs.firefox-esr.override {
        nativeMessagingHosts = [ pkgs.ff2mpv ];
      });
      policies = {
        CaptivePortal = false;
        DisableFeedbackCommands = true;
        DisableFirefoxScreenshots = true;
        DisableFirefoxStudies = true;
        DisableForgetButton = true;
        DisableFormHistory = true;
        DisablePocket = true;
        DisableTelemetry = true;
        EnableTrackingProtection = {
          Value = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        ExtensionSettings."{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          installation_mode = "normal_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
        };
        FirefoxHome = {
          TopSites = false;
          SponsoredTopSites = false;
          Highlights = false;
          Pocket = false;
          SponsoredPocket = false;
          Snippets = false;
        };
        Homepage.StartPage = "previous-session";
        NetworkPrediction = false;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        PictureInPicture.Enabled = false;
        Preferences = {
          "browser.tabs.loadBookmarksInTabs" = true;
          "gfx.webrender.all" = true;
          "media.peerconnection.enabled" = false;
          "ui.key.menuAccessKeyFocuses" = false;
        };
        Proxy = {
          Mode = "manual";
          SOCKSProxy = "127.0.0.1:1080";
          SOCKSVersion = 5;
          UseProxyForDNS = true;
        };
        SearchEngines = {
          Add = [
            {
              Name = "Google Search";
              URLTemplate = "https://www.google.com/search?q={searchTerms}";
              IconURL = "https://www.google.com/favicon.ico";
              Alias = "gg";
            }
            {
              Name = "GitHub";
              URLTemplate = "https://github.com/search?q={searchTerms}&type=repositories";
              IconURL = "https://github.com/favicon.ico";
              Alias = "g";
            }
            {
              Name = "YouTube";
              URLTemplate = "https://www.youtube.com/results?search_query={searchTerms}";
              IconURL = "https://www.youtube.com/favicon.ico";
              Alias = "y";
            }
            {
              Name = "Google Translate";
              URLTemplate = "https://translate.google.com/?sl=auto&tl=auto&text={searchTerms}";
              IconURL = "https://translate.google.com/favicon.ico";
              Alias = "f";
            }
            {
              Name = "维基百科 (zh)";
              URLTemplate = "https://zh.wikipedia.org/w/index.php?title=Special:%E6%90%9C%E7%B4%A2&search={searchTerms}";
              IconURL = "https://zh.wikipedia.org/favicon.ico";
              Alias = "w";
            }
            {
              Name = "维基百科 (en)";
              URLTemplate = "https://en.wikipedia.org/w/index.php?title=Special:Search&search={searchTerms}";
              IconURL = "https://en.wikipedia.org/favicon.ico";
              Alias = "we";
            }
            {
              Name = "ArchWiki (en)";
              URLTemplate = "https://wiki.archlinux.org/index.php?title=Special:Search&search={searchTerms}";
              IconURL = "https://wiki.archlinux.org/favicon.ico";
              Alias = "arch";
            }
            {
              Name = "Arch manual pages";
              URLTemplate = "https://man.archlinux.org/search?q={searchTerms}&go=Go";
              IconURL = "https://man.archlinux.org/favicon.ico";
              Alias = "man";
            }
            {
              Name = "萌娘百科";
              URLTemplate = "https://zh.moegirl.org.cn/index.php?title=Special:%E6%90%9C%E7%B4%A2&search={searchTerms}";
              IconURL = "https://zh.moegirl.org.cn/favicon.ico";
              Alias = "moe";
            }
          ];
          Default = "Google Search";
          # Doesn't work for Amazon or eBay.
          Remove = [
            "Bing"
            "DuckDuckGo"
            "Google"
            "Wikipedia (en)"
          ];
        };
        SanitizeOnShutdown = {
          Cache = true;
          Downloads = true;
        };
        SearchSuggestEnabled = false;
        UserMessaging = {
          WhatsNew = false;
          ExtensionRecommendations = false;
          FeatureRecommendations = false;
          UrlbarInterventions = false;
          SkipOnboarding = true;
          MoreFromMozilla = false;
        };
      };
    };
  };
}
