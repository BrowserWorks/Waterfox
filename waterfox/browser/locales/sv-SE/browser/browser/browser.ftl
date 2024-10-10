# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The main browser window's title

# These are the default window titles everywhere except macOS.
# .data-title-default and .data-title-private are used when the web content
# opened has no title:
#
# default - "Waterfox"
# private - "Waterfox (Private Browsing)"
#
# .data-content-title-default and .data-content-title-private are for use when
# there *is* a content title.
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window-window-titles =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } Privat surfning
    .data-content-title-default = { $content-title } — { -brand-full-name }
    .data-content-title-private = { $content-title } — { -brand-full-name } Privat surfning
# These are the default window titles on macOS.
# .data-title-default and .data-title-private are used when the web content
# opened has no title:
#
#
# "default" - "Waterfox"
# "private" - "Waterfox — (Private Browsing)"
#
# .data-content-title-default and .data-content-title-private are for use when
# there *is* a content title.
# Do not use the brand name in these, as we do on non-macOS.
#
# Also note the other subtle difference here: we use a `-` to separate the
# brand name from `(Private Browsing)`, which does not happen on other OSes.
#
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window-mac-window-titles =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } — Privat surfning
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } — Privat surfning
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }
# The non-variable portion of this MUST match the translation of
# "PRIVATE_BROWSING_SHORTCUT_TITLE" in custom.properties
private-browsing-shortcut-text-2 = { -brand-shortcut-name } Privat surfning

##

urlbar-identity-button =
    .aria-label = Visa webbplatsinformation

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = Öppna meddelandepanel för installation
urlbar-web-notification-anchor =
    .tooltiptext = Ändra om du kan ta emot meddelanden från webbplatsen
urlbar-midi-notification-anchor =
    .tooltiptext = Öppna MIDI-panelen
urlbar-eme-notification-anchor =
    .tooltiptext = Hantera användningen av DRM-programvara
urlbar-web-authn-anchor =
    .tooltiptext = Öppna panel för webbautentisiering
urlbar-canvas-notification-anchor =
    .tooltiptext = Hantera rättigheter för canvas-extrahering
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = Hantera delning av din mikrofon med webbplatsen
urlbar-default-notification-anchor =
    .tooltiptext = Öppna meddelandepanel
urlbar-geolocation-notification-anchor =
    .tooltiptext = Öppna platsbegäranspanel
urlbar-xr-notification-anchor =
    .tooltiptext = Öppna behörighetspanelen för virtuell verklighet
urlbar-storage-access-anchor =
    .tooltiptext = Öppna behörighetspanelen för surfaktivitet
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Hantera delning av dina fönster eller skärm med webbplatsen
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Öppna meddelandepanel för lagring offline
urlbar-password-notification-anchor =
    .tooltiptext = Öppna meddelandepanel för sparade lösenord
urlbar-plugins-notification-anchor =
    .tooltiptext = Hantera insticksmoduler som används
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Hantera delning av din kamera och/eller mikrofon med webbplatsen
# "Speakers" is used in a general sense that might include headphones or
# another audio output connection.
urlbar-web-rtc-share-speaker-notification-anchor =
    .tooltiptext = Hantera delning av andra högtalare med webbplatsen
urlbar-autoplay-notification-anchor =
    .tooltiptext = Öppna panelen automatisk uppspelning
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Lagra data i beständig lagring
urlbar-addons-notification-anchor =
    .tooltiptext = Öppna meddelandepanel för tilläggsinstallation
urlbar-tip-help-icon =
    .title = Få hjälp
urlbar-search-tips-confirm = Ok, jag förstår
urlbar-search-tips-confirm-short = Jag förstår
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = Tips:
urlbar-result-menu-button =
    .title = Öppna meny
urlbar-result-menu-button-feedback = Feedback
    .title = Öppna meny
urlbar-result-menu-learn-more =
    .label = Läs mer
    .accesskey = L
urlbar-result-menu-remove-from-history =
    .label = Ta bort från historik
    .accesskey = T
urlbar-result-menu-tip-get-help =
    .label = Få hjälp
    .accesskey = h

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Skriv mindre, hitta mer: Sök med { $engineName } direkt från ditt adressfält.
urlbar-search-tips-redirect-2 = Starta din sökning i adressfältet för att se förslag från { $engineName } och din surfhistorik.
# Make sure to match the name of the Search panel in settings.
urlbar-search-tips-persist = Det har blivit enklare att söka. Försök att göra din sökning mer specifik här i adressfältet. För att visa webbadressen istället, besök Sök i inställningarna.
# Prompts users to use the Urlbar when they are typing in the domain of a
# search engine, e.g. google.com or amazon.com.
urlbar-tabtosearch-onboard = Välj den här genvägen för att hitta det du behöver snabbare.

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = Bokmärken
urlbar-search-mode-tabs = Flikar
urlbar-search-mode-history = Historik
urlbar-search-mode-actions = Åtgärder

##

urlbar-geolocation-blocked =
    .tooltiptext = Du har blockerat platsinformation för den här webbplatsen.
urlbar-xr-blocked =
    .tooltiptext = Du har blockerat enheter för virtuell verklighet att få åtkomst till den här webbplatsen.
urlbar-web-notifications-blocked =
    .tooltiptext = Du har blockerat aviseringar för denna webbsida.
urlbar-camera-blocked =
    .tooltiptext = Du har blockerat din kamera för denna webbsida.
urlbar-microphone-blocked =
    .tooltiptext = Du har blockerat din mikrofon för den här webbsidan.
urlbar-screen-blocked =
    .tooltiptext = Du har blockerat den här webbsidan från att få dela din skärm.
urlbar-persistent-storage-blocked =
    .tooltiptext = Du har blockerat beständig lagring för den här webbplatsen.
urlbar-popup-blocked =
    .tooltiptext = Du har blockerat popup-fönster för den här webbplatsen.
urlbar-autoplay-media-blocked =
    .tooltiptext = Du har blockerat automatisk uppspelning av media med ljud för den här webbplatsen.
urlbar-canvas-blocked =
    .tooltiptext = Du har blockerat canvas-extrahering för den här webbplatsen.
urlbar-midi-blocked =
    .tooltiptext = Du har blockerat MIDI-åtkomst för denna webbplats.
urlbar-install-blocked =
    .tooltiptext = Du har blockerat installation av tillägg från denna webbplats.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = Redigera detta bokmärke ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = Bokmärk denna sida ({ $shortcut })

## Page Action Context Menu

page-action-manage-extension2 =
    .label = Hantera tillägg…
    .accesskey = H
page-action-remove-extension2 =
    .label = Ta bort tillägg
    .accesskey = T

## Auto-hide Context Menu

full-screen-autohide =
    .label = Dölj verktygsfält
    .accesskey = D
full-screen-exit =
    .label = Avsluta helskärmsläget
    .accesskey = A

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of search shortcuts in
# the Urlbar and searchbar.
search-one-offs-with-title = Denna gång, sök med:
search-one-offs-change-settings-compact-button =
    .tooltiptext = Ändra sökinställningar
search-one-offs-context-open-new-tab =
    .label = Sök i ny flik
    .accesskey = f
search-one-offs-context-set-as-default =
    .label = Ange som standardsökmotor
    .accesskey = s
search-one-offs-context-set-as-default-private =
    .label = Ange som standardsökmotor för privata fönster
    .accesskey = A
# Search engine one-off buttons with an @alias shortcut/keyword.
# Variables:
#  $engineName (String): The name of the engine.
#  $alias (String): The @alias shortcut/keyword.
search-one-offs-engine-with-alias =
    .tooltiptext = { $engineName } ({ $alias })
# Shown when adding new engines from the address bar shortcut buttons or context
# menu, or from the search bar shortcut buttons.
# Variables:
#  $engineName (String): The name of the engine.
search-one-offs-add-engine =
    .label = Lägg till "{ $engineName }"
    .tooltiptext = Lägg till sökmotor "{ $engineName }"
    .aria-label = Lägg till sökmotor "{ $engineName }"
# When more than 5 engines are offered by a web page, they are grouped in a
# submenu using this as its label.
search-one-offs-add-engine-menu =
    .label = Lägg till söktjänst

## Local search mode one-off buttons
## Variables:
##  $restrict (String): The restriction token corresponding to the search mode.
##    Restriction tokens are special characters users can type in the urlbar to
##    restrict their searches to certain sources (e.g., "*" to search only
##    bookmarks).

search-one-offs-bookmarks =
    .tooltiptext = Bokmärken ({ $restrict })
search-one-offs-tabs =
    .tooltiptext = Flikar ({ $restrict })
search-one-offs-history =
    .tooltiptext = Historik ({ $restrict })
search-one-offs-actions =
    .tooltiptext = Åtgärder ({ $restrict })

## QuickActions are shown in the urlbar as the user types a matching string
## The -cmd- strings are comma separated list of keywords that will match
## the action.

# Opens the about:addons page in the home / recommendations section
quickactions-addons = Visa tillägg
quickactions-cmd-addons2 = tillägg
# Opens the bookmarks library window
quickactions-bookmarks2 = Hantera bokmärken
quickactions-cmd-bookmarks = bokmärken
# Opens a SUMO article explaining how to clear history
quickactions-clearhistory = Rensa historik
quickactions-cmd-clearhistory = rensa historik
# Opens about:downloads page
quickactions-downloads2 = Visa nedladdningar
quickactions-cmd-downloads = hämtningar
# Opens about:addons page in the extensions section
quickactions-extensions = Hantera tillägg
quickactions-cmd-extensions = tillägg
# Opens the devtools web inspector
quickactions-inspector2 = Öppna utvecklarverktyg
quickactions-cmd-inspector = inspektör, utvecklarverktyg
# Opens about:logins
quickactions-logins2 = Hantera lösenord
quickactions-cmd-logins = inloggningar, lösenord
# Opens about:addons page in the plugins section
quickactions-plugins = Hantera insticksmoduler
quickactions-cmd-plugins = insticksmoduler
# Opens the print dialog
quickactions-print2 = Skriv ut sida
quickactions-cmd-print = skriva ut
# Opens a new private browsing window
quickactions-private2 = Öppna privat fönster
quickactions-cmd-private = privat surfning
# Opens a SUMO article explaining how to refresh
quickactions-refresh = Återställ { -brand-short-name }
quickactions-cmd-refresh = uppdatera
# Restarts the browser
quickactions-restart = Starta om { -brand-short-name }
quickactions-cmd-restart = omstart
# Opens the screenshot tool
quickactions-screenshot3 = Ta en skärmdump
quickactions-cmd-screenshot = skärmbild
# Opens about:preferences
quickactions-settings2 = Hantera inställningar
quickactions-cmd-settings = inställningar, alternativ
# Opens about:addons page in the themes section
quickactions-themes = Hantera teman
quickactions-cmd-themes = teman
# Opens a SUMO article explaining how to update the browser
quickactions-update = Uppdatera { -brand-short-name }
quickactions-cmd-update = uppdatera
# Opens the view-source UI with current pages source
quickactions-viewsource2 = Visa källkod
quickactions-cmd-viewsource = visa källa, källa
# Tooltip text for the help button shown in the result.
quickactions-learn-more =
    .title = Läs mer om snabbåtgärder

## Bookmark Panel

bookmarks-add-bookmark = Lägg till bokmärke
bookmarks-edit-bookmark = Redigera bokmärke
bookmark-panel-cancel =
    .label = Avbryt
    .accesskey = A
# Variables:
#  $count (number): number of bookmarks that will be removed
bookmark-panel-remove =
    .label =
        { $count ->
            [one] Ta bort bokmärke
           *[other] Ta bort { $count } bokmärken
        }
    .accesskey = T
bookmark-panel-show-editor-checkbox =
    .label = Visa redigeraren när du sparar
    .accesskey = V
bookmark-panel-save-button =
    .label = Spara
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

# Variables
#  $host (String): the hostname of the site that is being displayed.
identity-site-information = Webbplatsinformation för { $host }
# Variables
#  $host (String): the hostname of the site that is being displayed.
identity-header-security-with-host =
    .title = Anslutningssäkerhet för { $host }
identity-connection-not-secure = Anslutningen är inte säker
identity-connection-secure = Anslutningen är säker
identity-connection-failure = Anslutningsfel
identity-connection-internal = Detta är en säker { -brand-short-name } sida.
identity-connection-file = Den här sidan är lagrad på din dator.
identity-extension-page = Den här sidan laddas från ett tillägg.
identity-active-blocked = { -brand-short-name } har blockerat några osäkra komponenter på sidan.
identity-custom-root = Anslutning verifierad av en certifikatutgivare som inte känns igen av BrowserWorks.
identity-passive-loaded = Vissa komponenter av den här sidan är inte säkra (t.ex. bilder).
identity-active-loaded = Du har stängt av skyddet på den här sidan.
identity-weak-encryption = Den här sidan använder en svag kryptering.
identity-insecure-login-forms = Inloggningar som anges på den här sidan kan äventyras.
identity-https-only-connection-upgraded = (uppgraderad till HTTPS)
identity-https-only-label = Endast HTTPS-läge
identity-https-only-label2 = Uppgradera denna webbplats automatiskt till en säker anslutning
identity-https-only-dropdown-on =
    .label = På
identity-https-only-dropdown-off =
    .label = Av
identity-https-only-dropdown-off-temporarily =
    .label = Tillfälligt av
identity-https-only-info-turn-on2 = Aktivera endast HTTPS-läge för den här webbplatsen om du vill att { -brand-short-name } ska uppgradera anslutningen när det är möjligt.
identity-https-only-info-turn-off2 = Om sidan verkar trasig kanske du vill stänga av endast HTTPS-läge för att den här webbplatsen ska laddas om med osäker HTTP.
identity-https-only-info-turn-on3 = Aktivera HTTPS-uppgraderingar för den här webbplatsen om du vill att { -brand-short-name } ska uppgradera anslutningen när det är möjligt.
identity-https-only-info-turn-off3 = Om sidan verkar trasig kanske du vill stänga av HTTPS-uppgraderingar för att den här webbplatsen ska laddas om med osäker HTTP.
identity-https-only-info-no-upgrade = Det gick inte att uppgradera anslutningen från HTTP.
identity-permissions-storage-access-header = Globala kakor
identity-permissions-storage-access-hint = Dessa parter kan använda global kakor och webbplatsinformation medan du är på denna webbplats.
identity-permissions-storage-access-learn-more = Läs mer
identity-permissions-reload-hint = Du kan behöva ladda om sidan för att ändringarna ska verkställas.
identity-clear-site-data =
    .label = Rensa kakor och webbplatsdata…
identity-connection-not-secure-security-view = Du är inte säkert ansluten till den här webbplatsen.
identity-connection-verified = Du är säkert ansluten till den här webbplatsen.
identity-ev-owner-label = Certifikat utfärdat till:
identity-description-custom-root2 = BrowserWorks känner inte igen denna certifikatutgivare. Den kan ha lagts till från ditt operativsystem eller av en administratör.
identity-remove-cert-exception =
    .label = Ta bort undantag
    .accesskey = R
identity-description-insecure = Din anslutning till den här sidan är inte privat. Information som du skickar kan ses av andra personer (som t.ex. lösenord, meddelanden, bankkort, osv.).
identity-description-insecure-login-forms = Inloggningsinformation du anger på denna sida är inte säker och kan äventyras.
identity-description-weak-cipher-intro = Din anslutning till den här webbsidan använder en svag kryptering och är inte privat.
identity-description-weak-cipher-risk = Andra personer kan se din information eller ändra webbplatsens beteende.
identity-description-active-blocked2 = { -brand-short-name } har blockerat några osäkra komponenter på sidan.
identity-description-passive-loaded = Anslutningen till denna webbplats är inte privat och andra personer kan se din information.
identity-description-passive-loaded-insecure2 = Den här webbplatsen har innehåll som inte är säkert (t.ex. bilder).
identity-description-passive-loaded-mixed2 = { -brand-short-name } har blockerat några osäkra komponenter på sidan, men det finns fortfarande osäkra komponenter (såsom bilder).
identity-description-active-loaded = Den här webbplatsen innehåller material som inte är säkra (såsom skript) och din anslutning till det är inte privat.
identity-description-active-loaded-insecure = Information du delar med den här webbplatsen kan ses av andra (som lösenord, meddelanden, kreditkort, etc.).
identity-disable-mixed-content-blocking =
    .label = Inaktivera skydd tillfälligt
    .accesskey = D
identity-enable-mixed-content-blocking =
    .label = Aktivera skydd
    .accesskey = E
identity-more-info-link-text =
    .label = Mer information

## Window controls

browser-window-minimize-button =
    .tooltiptext = Minimera
browser-window-maximize-button =
    .tooltiptext = Maximera
browser-window-restore-down-button =
    .tooltiptext = Återställ nedåt
browser-window-close-button =
    .tooltiptext = Stäng

## Tab actions

# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-playing2 = SPELAR
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-muted2 = TYST
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-blocked = AUTOMATISK UPPSPELNING BLOCKERAD
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-pip = BILD-I-BILD

## These labels should be written in all capital letters if your locale supports them.
## Variables:
##  $count (number): number of affected tabs

browser-tab-mute =
    { $count ->
        [1] STÄNG AV LJUD
       *[other] STÄNG AV LJUD ({ $count } FLIKAR)
    }
browser-tab-unmute =
    { $count ->
        [1] SLÅ PÅ LJUD
       *[other] SLÅ PÅ LJUD ({ $count } FLIKAR)
    }
browser-tab-unblock =
    { $count ->
        [1] STARTA UPPSPELNING
       *[other] STARTA UPPSPELNING ({ $count } FLIKAR)
    }

## Bookmarks toolbar items

browser-import-button2 =
    .label = Importera bokmärken…
    .tooltiptext = Importera bokmärken från en annan webbläsare till { -brand-short-name }
bookmarks-toolbar-empty-message = För snabb åtkomst placerar du dina bokmärken i bokmärkesfältet. <a data-l10n-name="manage-bookmarks">Hantera bokmärken…</a>

## WebRTC Pop-up notifications

popup-select-camera-device =
    .value = Kamera:
    .accesskey = K
popup-select-camera-icon =
    .tooltiptext = Kamera
popup-select-microphone-device =
    .value = Mikrofon:
    .accesskey = M
popup-select-microphone-icon =
    .tooltiptext = Mikrofon
popup-select-speaker-icon =
    .tooltiptext = Ljudenhet
popup-select-window-or-screen =
    .label = Fönster eller skärm:
    .accesskey = F
popup-all-windows-shared = Alla synliga fönster på din skärm kommer att delas.

## WebRTC window or screen share tab switch warning

sharing-warning-window = Du delar { -brand-short-name }. Andra kan se när du byter till en ny flik.
sharing-warning-screen = Du delar hela skärmen. Andra kan se när du byter till en ny flik.
sharing-warning-proceed-to-tab =
    .label = Fortsätt till flik
sharing-warning-disable-for-session =
    .label = Inaktivera delningsskydd för den här sessionen

## DevTools F12 popup

enable-devtools-popup-description2 = För att använda F12-genvägen, öppna först DevTools via menyn Webbläsarverktyg.

## URL Bar

# This placeholder is used when not in search mode and the user's default search
# engine is unknown.
urlbar-placeholder =
    .placeholder = Sök eller ange adress
# This placeholder is used in search mode with search engines that search the
# entire web.
# Variables
#  $name (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-placeholder-search-mode-web-2 =
    .placeholder = Sök på webben
    .aria-label = Sök med { $name }
# This placeholder is used in search mode with search engines that search a
# specific site (e.g., Amazon).
# Variables
#  $name (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-placeholder-search-mode-other-engine =
    .placeholder = Ange söktermer
    .aria-label = Sök i { $name }
# This placeholder is used when searching bookmarks.
urlbar-placeholder-search-mode-other-bookmarks =
    .placeholder = Ange söktermer
    .aria-label = Sök i bokmärken
# This placeholder is used when searching history.
urlbar-placeholder-search-mode-other-history =
    .placeholder = Ange söktermer
    .aria-label = Sök i historik
# This placeholder is used when searching open tabs.
urlbar-placeholder-search-mode-other-tabs =
    .placeholder = Ange söktermer
    .aria-label = Sök i flikar
# This placeholder is used when searching quick actions.
urlbar-placeholder-search-mode-other-actions =
    .placeholder = Ange söktermer
    .aria-label = Sök åtgärder
# Variables
#  $name (String): the name of the user's default search engine
urlbar-placeholder-with-name =
    .placeholder = Sök med { $name } eller ange adress
# Variables
#  $component (String): the name of the component which forces remote control.
#    Example: "DevTools", "Marionette", "RemoteAgent".
urlbar-remote-control-notification-anchor2 =
    .tooltiptext = Webbläsaren är fjärrstyrd (orsak: { $component })
urlbar-permissions-granted =
    .tooltiptext = Du har beviljat den här webbplatsen ytterligare behörigheter.
urlbar-switch-to-tab =
    .value = Växla till flik:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Tillägg:
urlbar-go-button =
    .tooltiptext = Gå till adressen i adressfältet
urlbar-page-action-button =
    .tooltiptext = Åtgärder för sida

## Action text shown in urlbar results, usually appended after the search
## string or the url, like "result value - action text".

# Used when the private browsing engine differs from the default engine.
# The "with" format was chosen because the search engine name can end with
# "Search", and we would like to avoid strings like "Search MSN Search".
# Variables
#  $engine (String): the name of a search engine
urlbar-result-action-search-in-private-w-engine = Sök med { $engine } i ett privat fönster
# Used when the private browsing engine is the same as the default engine.
urlbar-result-action-search-in-private = Sök i ett privat fönster
# The "with" format was chosen because the search engine name can end with
# "Search", and we would like to avoid strings like "Search MSN Search".
# Variables
#  $engine (String): the name of a search engine
urlbar-result-action-search-w-engine = Sök med { $engine }
urlbar-result-action-sponsored = Sponsrad
urlbar-result-action-switch-tab = Växla till flik
urlbar-result-action-visit = Besök
# Allows the user to visit a URL that was previously copied to the clipboard.
urlbar-result-action-visit-from-your-clipboard = Besök från ditt urklipp
# Directs a user to press the Tab key to perform a search with the specified
# engine.
# Variables
#  $engine (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-result-action-before-tabtosearch-web = Tryck på Tab för att söka med { $engine }
# Directs a user to press the Tab key to perform a search with the specified
# engine.
# Variables
#  $engine (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-result-action-before-tabtosearch-other = Tryck på Tab för att söka i { $engine }
# Variables
#  $engine (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-result-action-tabtosearch-web = Sök med { $engine } direkt från adressfältet
# Variables
#  $engine (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-result-action-tabtosearch-other-engine = Sök i { $engine } direkt från adressfältet
# Action text for copying to clipboard.
urlbar-result-action-copy-to-clipboard = Kopiera
# Shows the result of a formula expression being calculated, the last = sign will be shown
# as part of the result (e.g. "= 2").
# Variables
#  $result (String): the string representation for a formula result
urlbar-result-action-calculator-result = = { $result }

## Action text shown in urlbar results, usually appended after the search
## string or the url, like "result value - action text".
## In these actions "Search" is a verb, followed by where the search is performed.

urlbar-result-action-search-bookmarks = Sök i bokmärken
urlbar-result-action-search-history = Sök i historik
urlbar-result-action-search-tabs = Sök i flikar
urlbar-result-action-search-actions = Sökåtgärder

## Labels shown above groups of urlbar results

# A label shown above the "Waterfox Suggest" (bookmarks/history) group in the
# urlbar results.
urlbar-group-firefox-suggest =
    .label = { -firefox-suggest-brand-name }
# A label shown above the search suggestions group in the urlbar results. It
# should use sentence case.
# Variables
#  $engine (String): the name of the search engine providing the suggestions
urlbar-group-search-suggestions =
    .label = { $engine }-förslag
# A label shown above Quick Actions in the urlbar results.
urlbar-group-quickactions =
    .label = Snabbåtgärder

## Reader View toolbar buttons

# This should match menu-view-enter-readerview in menubar.ftl
reader-view-enter-button =
    .aria-label = Öppna läsarvy
# This should match menu-view-close-readerview in menubar.ftl
reader-view-close-button =
    .aria-label = Stäng läsarvy

## Picture-in-Picture urlbar button
## Variables:
##   $shortcut (String) - Keyboard shortcut to execute the command.

picture-in-picture-urlbar-button-open =
    .tooltiptext = Öppna bild-i-bild ({ $shortcut })
picture-in-picture-urlbar-button-close =
    .tooltiptext = Stäng bild-i-bild ({ $shortcut })
picture-in-picture-panel-header = Bild-i-bild
picture-in-picture-panel-headline = Denna webbplats rekommenderar inte bild-i-bild
picture-in-picture-panel-body = Videor kanske inte visas som utvecklaren tänkt när bild-i-bild är aktiverat.
picture-in-picture-enable-toggle =
    .label = Aktivera ändå

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> är nu i helskärm
fullscreen-warning-no-domain = Detta dokument är nu i helskärm
fullscreen-exit-button = Avsluta helskärm (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = Avsluta helskärm (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> har kontroll över pekaren. Tryck på Esc för att ta tillbaka kontrollen.
pointerlock-warning-no-domain = Detta dokument har kontroll över pekaren. Tryck på Esc för att ta tillbaka kontrollen.

## Bookmarks panels, menus and toolbar

bookmarks-manage-bookmarks =
    .label = Hantera bokmärken
bookmarks-recent-bookmarks-panel-subheader = Senaste bokmärken
bookmarks-toolbar-chevron =
    .tooltiptext = Visa fler bokmärken
bookmarks-sidebar-content =
    .aria-label = Bokmärken
bookmarks-menu-button =
    .label = Bokmärkesmeny
bookmarks-other-bookmarks-menu =
    .label = Andra bokmärken
bookmarks-mobile-bookmarks-menu =
    .label = Mobila bokmärken

## Variables:
##   $isVisible (boolean): if the specific element (e.g. bookmarks sidebar,
##                         bookmarks toolbar, etc.) is visible or not.

bookmarks-tools-sidebar-visibility =
    .label =
        { $isVisible ->
            [true] Dölj sidofältet Bokmärken
           *[other] Visa sidofältet Bokmärken
        }
bookmarks-tools-toolbar-visibility-menuitem =
    .label =
        { $isVisible ->
            [true] Dölj bokmärkesfältet
           *[other] Visa bokmärkesfältet
        }
bookmarks-tools-toolbar-visibility-panel =
    .label =
        { $isVisible ->
            [true] Dölj bokmärkesfältet
           *[other] Visa bokmärkesfältet
        }
bookmarks-tools-menu-button-visibility =
    .label =
        { $isVisible ->
            [true] Ta bort bokmärkesmeny från verktygsfältet
           *[other] Lägg till bokmärkesmeny till verktygsfältet
        }

##

bookmarks-search =
    .label = Sök bokmärken
bookmarks-tools =
    .label = Verktyg för bokmärken
bookmarks-subview-edit-bookmark =
    .label = Redigera detta bokmärke…
# The aria-label is a spoken label that should not include the word "toolbar" or
# such, because screen readers already know that this container is a toolbar.
# This avoids double-speaking.
bookmarks-toolbar =
    .toolbarname = Bokmärkesfältet
    .accesskey = B
    .aria-label = Bokmärken
bookmarks-toolbar-menu =
    .label = Bokmärkesfältet
bookmarks-toolbar-placeholder =
    .title = Bokmärkesfältsposter
bookmarks-toolbar-placeholder-button =
    .label = Bokmärkesfältsposter
# "Bookmark" is a verb, as in "Add current tab to bookmarks".
bookmarks-subview-bookmark-tab =
    .label = Bokmärk aktuell flik…

## Library Panel items

library-bookmarks-menu =
    .label = Bokmärken
library-recent-activity-title =
    .value = Senaste aktivitet

## Pocket toolbar button

save-to-pocket-button =
    .label = Spara till { -pocket-brand-name }
    .tooltiptext = Spara till { -pocket-brand-name }

## Repair text encoding toolbar button

repair-text-encoding-button =
    .label = Reparera textkodning
    .tooltiptext = Gissa korrekt textkodning från sidinnehåll

## Customize Toolbar Buttons

# Variables:
#  $shortcut (String): keyboard shortcut to open settings (only on macOS)
toolbar-settings-button =
    .label = Inställningar
    .tooltiptext =
        { PLATFORM() ->
            [macos] Öppna inställningar ({ $shortcut })
           *[other] Öppna inställningar
        }
toolbar-overflow-customize-button =
    .label = Anpassa verktygsfält…
    .accesskey = n
toolbar-button-email-link =
    .label = E-posta länk
    .tooltiptext = Mejla en länk till denna sidan
toolbar-button-logins =
    .label = Lösenord
    .tooltiptext = Visa och hantera dina sparade lösenord
# Variables:
#  $shortcut (String): keyboard shortcut to save a copy of the page
toolbar-button-save-page =
    .label = Spara sida
    .tooltiptext = Spara denna sida ({ $shortcut })
# Variables:
#  $shortcut (String): keyboard shortcut to open a local file
toolbar-button-open-file =
    .label = Öppna fil
    .tooltiptext = Öppna en fil ({ $shortcut })
toolbar-button-synced-tabs =
    .label = Synkade flikar
    .tooltiptext = Visa flikar från andra enheter
# Variables
# $shortcut (string) - Keyboard shortcut to open a new private browsing window
toolbar-button-new-private-window =
    .label = Nytt privat fönster
    .tooltiptext = Öppna ett nytt privat fönster ({ $shortcut })

## EME notification panel

eme-notifications-drm-content-playing = En del ljud eller video på den här hemsidan använder DRM mjukvara, vilket kan begränsa vad { -brand-short-name } tillåter dig att använda den till.
eme-notifications-drm-content-playing-manage = Hantera inställningar
eme-notifications-drm-content-playing-manage-accesskey = H
eme-notifications-drm-content-playing-dismiss = Ignorera
eme-notifications-drm-content-playing-dismiss-accesskey = g

## Password save/update panel

panel-save-update-username = Användarnamn
panel-save-update-password = Lösenord

##

# "More" item in macOS share menu
menu-share-more =
    .label = Mer…
ui-tour-info-panel-close =
    .tooltiptext = Stäng

## Variables:
##  $uriHost (String): URI host for which the popup was allowed or blocked.

popups-infobar-allow =
    .label = Tillåt popup-fönster för { $uriHost }
    .accesskey = p
popups-infobar-block =
    .label = Blockera popup-fönster för { $uriHost }
    .accesskey = p

##

popups-infobar-dont-show-message =
    .label = Visa inte det här meddelandet när popup-fönster blockeras
    .accesskey = D
edit-popup-settings =
    .label = Hantera popup-inställningar...
    .accesskey = p
picture-in-picture-hide-toggle =
    .label = Dölj bild-i-bild växling
    .accesskey = D

## Since the default position for PiP controls does not change for RTL layout,
## right-to-left languages should use "Left" and "Right" as in the English strings,

picture-in-picture-move-toggle-right =
    .label = Flytta växel av bild-i-bild till höger sida
    .accesskey = h
picture-in-picture-move-toggle-left =
    .label = Flytta växel av bild-i-bild till vänster sida
    .accesskey = v

##


# Navigator Toolbox

# This string is a spoken label that should not include
# the word "toolbar" or such, because screen readers already know that
# this container is a toolbar. This avoids double-speaking.
navbar-accessible =
    .aria-label = Navigering
navbar-downloads =
    .label = Filhämtaren
navbar-overflow =
    .tooltiptext = Fler verktyg…
# Variables:
#   $shortcut (String): keyboard shortcut to print the page
navbar-print =
    .label = Skriv ut
    .tooltiptext = Skriv ut denna sida… ({ $shortcut })
navbar-home =
    .label = Startsida
    .tooltiptext = { -brand-short-name } Hemsida
navbar-library =
    .label = Bibliotek
    .tooltiptext = Visa historik, sparade bokmärken och mer
navbar-search =
    .title = Sök
# Name for the tabs toolbar as spoken by screen readers. The word
# "toolbar" is appended automatically and should not be included in
# in the string
tabs-toolbar =
    .aria-label = Webbläsarflikar
tabs-toolbar-new-tab =
    .label = Ny flik
tabs-toolbar-list-all-tabs =
    .label = Lista alla flikar
    .tooltiptext = Lista alla flikar

## Infobar shown at startup to suggest session-restore

# <img data-l10n-name="icon"/> will be replaced by the application menu icon
restore-session-startup-suggestion-message = <strong>Öppna tidigare flikar?</strong>Du kan återställa din tidigare session från programmenyn i { -brand-short-name } <img data-l10n-name="icon"/>, under Historik.
restore-session-startup-suggestion-button = Visa mig hur

## BrowserWorks data reporting notification (Telemetry, Waterfox Health Report, etc)

data-reporting-notification-message = { -brand-short-name } skickar automatiskt viss data till { -vendor-short-name } så att vi kan göra förbättringar.
data-reporting-notification-button =
    .label = Välj vad som ska delas
    .accesskey = V
# Label for the indicator shown in the private browsing window titlebar.
private-browsing-indicator-label = Privat surfning

## Unified extensions (toolbar) button

unified-extensions-button =
    .label = Tillägg
    .tooltiptext = Tillägg

## Unified extensions button when permission(s) are needed.
## Note that the new line is intentionally part of the tooltip.

unified-extensions-button-permissions-needed =
    .label = Tillägg
    .tooltiptext =
        Tillägg
        Behörigheter behövs

## Unified extensions button when some extensions are quarantined.
## Note that the new line is intentionally part of the tooltip.

unified-extensions-button-quarantined =
    .label = Tillägg
    .tooltiptext =
        Tillägg
        Vissa tillägg är inte tillåtna

## Autorefresh blocker

refresh-blocked-refresh-label = { -brand-short-name } har förhindrat att den här sidan uppdateras automatiskt.
refresh-blocked-redirect-label = { -brand-short-name } har förhindrat att den här sidan automatiskt styr om till en annan sida.
refresh-blocked-allow =
    .label = Tillåt
    .accesskey = T

## Waterfox Relay integration

firefox-relay-offer-why-to-use-relay = Våra säkra, lättanvända alias skyddar din identitet och förhindrar skräppost genom att dölja din e-postadress.
# Variables:
#  $useremail (String): user email that will receive messages
firefox-relay-offer-what-relay-provides = Alla e-postmeddelanden som skickas till dina e-postalias kommer att vidarebefordras till <strong>{ $useremail }</strong> (om du inte bestämmer dig för att blockera dem).
firefox-relay-offer-legal-notice = Genom att klicka på "Använd e-postalias" godkänner du <label data-l10n-name="tos-url">användarvillkoren</label> och <label data-l10n-name="privacy-url">sekretessmeddelandet</label>.

## Add-on Pop-up Notifications

popup-notification-addon-install-unsigned =
    .value = (Overifierad)
popup-notification-xpinstall-prompt-learn-more = Läs mer om hur du installerar tillägg säkert

## Pop-up warning

# Variables:
#   $popupCount (Number): the number of pop-ups blocked.
popup-warning-message =
    { $popupCount ->
        [one] { -brand-short-name } hindrade att denna webbplats öppnar ett popup-fönster.
       *[other] { -brand-short-name } hindrade att denna webbplats öppnar { $popupCount } popup-fönster.
    }
# The singular form is left out for English, since the number of blocked pop-ups is always greater than 1.
# Variables:
#   $popupCount (Number): the number of pop-ups blocked.
popup-warning-exceeded-message = { -brand-short-name } hindrade den här webbplatsen från att öppna fler än { $popupCount } popup-fönster.
popup-warning-button =
    .label =
        { PLATFORM() ->
            [windows] Inställningar
           *[other] Inställningar
        }
    .accesskey =
        { PLATFORM() ->
            [windows] I
           *[other] I
        }
# Variables:
#   $popupURI (String): the URI for the pop-up window
popup-show-popup-menuitem =
    .label = Visa “{ $popupURI }”
