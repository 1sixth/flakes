{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox.override {
      extraPolicies = {
        DisableAppUpdate = true;
        DisableFirefoxStudies = true;
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
        HardwareAcceleration = true;
        Homepage.StartPage = "previous-session";
        NetworkPrediction = false;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        Preferences = {
          "gfx.webrender.all" = true;
          "browser.tabs.loadBookmarksInTabs" = true;
          "media.ffmpeg.vaapi.enabled" = true;
          "media.peerconnection.enabled" = false;
          "ui.key.menuAccessKeyFocuses" = false;
        };
        Proxy = {
          Mode = "manual";
          SOCKSProxy = "127.0.0.1:1080";
          SOCKSVersion = 5;
          UseProxyForDNS = true;
        };
        SanitizeOnShutdown = {
          Cache = true;
          Downloads = true;
          OfflineApps = true;
        };
        SearchBar = "unified";
        SearchSuggestEnabled = false;
        ShowHomeButton = false;
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
