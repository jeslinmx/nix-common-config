{inputs, ...}: {
  config,
  lib,
  pkgs,
  ...
}: {
  programs.firefox = {
    profiles = {
      default = {
        settings = {
          # UI
          "browser.newtabpage.activity-stream.feeds.section.highlights" = true;
          "browser.newtabpage.activity-stream.showSearch" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.toolbars.bookmarks.visibility" = "never";
          "browser.tabs.tabmanager.enabled" = false; # hide dropdown tab menu
          "browser.tabs.tabClipWidth" = 999; # clip tab close button on inactive tabs
          "browser.compactmode.show" = true; # compact UI density
          "browser.uidensity" = 1; # enable compact UI
          "browser.uiCustomization.state" = builtins.toJSON {
            "placements" = {
              "nav-bar" = [
                "sidebar-button"
                "customizableui-special-spring1"
                "back-button"
                "stop-reload-button"
                "forward-button"
                "urlbar-container"
                "downloads-button"
                "unified-extensions-button"
                "customizableui-special-spring3"
              ];
              "toolbar-menubar" = ["menubar-items"];
            };
            "dirtyAreaCache" = [
              "unified-extensions-area"
              "nav-bar"
              "toolbar-menubar"
            ];
            "currentVersion" = 20;
          };
          "extensions.pocket.enabled" = false;
          "apz.overscroll.enabled" = true;
          "sidebar.verticalTabs" = true;

          # fonts
          "font.size.variable.x-western" = 14;

          # Privacy and security
          "app.shield.optoutstudies.enabled" = false; # Disallow Firefox to install and run studies
          "browser.contentblocking.category" = "standard"; # Enhanced Tracking Protection
          "browser.crashReports.unsubmittedCheck.autoSubmit2" = true; # Allow Firefox to send backlogged crash reports
          "browser.xul.error_pages.expert_bad_cert" = true; # display advanced information on Insecure Connection warning pages
          "dom.security.https_only_mode" = true;
          "network.auth.subresource-http-auth-allow" = 1; # limit (or disable) HTTP authentication credentials dialogs triggered by sub-resources. Hardens against potential credentials phishing
          "security.cert_pinning.enforcement_level" = 2; # 2=strict. Public key pinning prevents man-in-the-middle attacks due to rogue CAs [certificate authorities] not on the site's list
          "security.dialog_enable_delay" = 700; # enforce a security delay on some confirmation dialogs such as install, open/save
          "security.insecure_field_warning.contextual.enabled" = true; # Show in-content login form warning UI for insecure login fields
          "security.insecure_password.ui.enabled" = true; # show a warning that a login form is delivered via HTTP (a security risk)
          "security.mixed_content.block_active_content" = true; # disable insecure active content on https pages (mixed content) (might not be needed with HTTPS-Only Mode enabled)
          "security.mixed_content.block_display_content" = true; # disable insecure passive content (such as images) on https pages, "Parts of this page are not secure (such as images)"
          "security.mixed_content.upgrade_display_content" = true; # Try to load HTTP content as HTTPS (in mixed content pages)
          "security.pki.crlite_mode" = 2; # switching from OCSP to CRLite for checking sites certificates which has compression, is faster, and more private. 2="CRLite will enforce revocations in the CRLite filter, but still use OCSP if the CRLite filter does not indicate a revocation" (https://www.reddit.com/r/firefox/comments/wesya4/danger_of_disabling_query_ocsp_option_in_firefox/, https://blog.mozilla.org/security/2020/01/09/crlite-part-2-end-to-end-design/)
          "security.ssl.require_safe_negotiation" = true; # Blocks connections to servers that don't support RFC 5746 as they're potentially vulnerable to a MiTM attack

          # Behavior
          "intl.regional_prefs.use_os_locales" = true; # Use your OS settings to format dates, times, etc.
          "browser.download.always_ask_before_handling_new_types" = true;
          "extensions.pictureinpicture.enable_picture_in_picture_overrides" = true;
          "general.autoScroll" = true;
          "signon.rememberSignons" = false; # Ask to save passwords
          "browser.startup.page" = 3; # Resume previous browser session
          "browser.search.suggest.enabled" = true;
          "browser.urlbar.suggest.searches" = true;
          "media.block-autoplay-until-in-foreground" = true;
          "media.block-play-until-document-interaction" = true;
          "media.block-play-until-visible" = true;
          "media.videocontrols.picture-in-picture.enable-when-switching-tabs.enabled" = true;
        };
        search = {
          force = true;
          default = "ddg";
          engines = {
            "MyNixOS" = {
              urls = [{template = "https://mynixos.com/search?q={searchTerms}";}];
              definedAliases = ["mn"];
            };
            "NixHub" = {
              urls = [{template = "https://www.nixhub.io/packages/{searchTerms}";}];
              definedAliases = ["nh"];
            };
            "Minecraft Wiki" = {
              urls = [{template = "https://minecraft.wiki/?search={searchTerms}&title=Special%3ASearch&wprov=acrw1_-1";}];
              definedAliases = ["mc"];
            };
            "GitHub" = {
              urls = [{template = "https://github.com/{searchTerms}";}];
              definedAliases = ["gh"];
            };
            "Lenovo PSREF" = {
              urls = [{template = "https://psref.lenovo.com/Search?kw={searchTerms}";}];
              definedAliases = ["psref"];
            };
            "Literal Word" = {
              urls = [{template = "https://nasb.literalword.com/?q={searchTerms}";}];
              definedAliases = ["word"];
            };
            "google".metaData.hidden = true;
            "amazondotcom-us".metaData.hidden = true;
            "bing".metaData.hidden = true;
            "wikipedia".metaData.hidden = true;
          };
        };
      };
    };
    policies = {
      ExtensionSettings = let
        extensions = installation_mode:
          builtins.mapAttrs (
            _: slug: {
              inherit installation_mode;
              install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${slug}/latest.xpi";
            }
          );
      in
        extensions "blocked" {
          "amazondotcom@search.mozilla.org" = "";
          "bing@search.mozilla.org" = "";
          "google@search.mozilla.org" = "";
          "wikipedia@search.mozilla.org" = "";
        };
      Containers = {
        Default = [
          {
            name = "Microsoft Jail";
            color = "blue";
            icon = "briefcase";
          }
          {
            name = "Google Jail";
            color = "red";
            icon = "pet";
          }
          {
            name = "Facebook Jail";
            color = "toolbar";
            icon = "chill";
          }
        ];
      };
    };
  };
  stylix.targets.firefox.profileNames = ["default"];
}
