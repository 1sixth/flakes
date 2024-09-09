{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    nativeMessagingHosts = [ pkgs.ff2mpv ];
    package = pkgs.firefox-esr;
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
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "ui.key.menuAccessKeyFocuses" = false;
      };
      Proxy = {
        Mode = "manual";
        SOCKSProxy = "127.0.0.1:1080";
        SOCKSVersion = 5;
        # https://minikube.sigs.k8s.io/docs/handbook/vpn_and_proxy/
        Passthrough = builtins.concatStringsSep "," [
          "127.0.0.1"
          "localhost"
          "192.168.59.0/24"
          "192.168.39.0/24"
          "192.168.49.0/24"
          "10.96.0.0/12"
        ];
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
    # https://github.com/stonecrusher/simpleMenuWizard
    profiles.default.userChrome = ''
      #context-openlinkinusercontext-menu,    /* Open Link in New Container Tab   */
      #context-openlink,                      /* Open Link in New Window          */
      #context-openlinkprivate,               /* Open Link in New Private Window  */
      #context-sep-open,                      /************ Separator *************/
      #context-bookmarklink,                  /* Bookmark Link                    */
      #context-savelink,                      /* Save Link As…                    */
      #context-sep-sendlinktodevice,          /************ Separator *************/
      #frame-sep                              /************ Separator *************/
          { display:none !important; }
    '';
  };
}
