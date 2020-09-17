# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The main browser window's title

# These are the default window titles everywhere except macOS. The first two
# attributes are used when the web content opened has no title:
#
# default - "Mozilla Firefox"
# private - "Mozilla Firefox (Private Browsing)"
#
# The last two are for use when there *is* a content title.
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } (Privat surfning)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (Privat surfning)
# These are the default window titles on macOS. The first two are for use when
# there is no content title:
#
# "default" - "Mozilla Firefox"
# "private" - "Mozilla Firefox - (Private Browsing)"
#
# The last two are for use when there *is* a content title.
# Do not use the brand name in the last two attributes, as we do on non-macOS.
#
# Also note the other subtle difference here: we use a `-` to separate the
# brand name from `(Private Browsing)`, which does not happen on other OSes.
#
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window-mac =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } - (Privat surfning)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (Privat surfning)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

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
urlbar-translate-notification-anchor =
    .tooltiptext = Översätt denna sida
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Hantera delning av dina fönster eller skärm med webbplatsen
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Öppna meddelandepanel för lagring offline
urlbar-password-notification-anchor =
    .tooltiptext = Öppna meddelandepanel för sparade lösenord
urlbar-translated-notification-anchor =
    .tooltiptext = Hantera sidöversättning
urlbar-plugins-notification-anchor =
    .tooltiptext = Hantera plugins som används
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Hantera delning av din kamera och/eller mikrofon med webbplatsen
urlbar-autoplay-notification-anchor =
    .tooltiptext = Öppna autoplay-panelen
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Lagra data i beständig lagring
urlbar-addons-notification-anchor =
    .tooltiptext = Öppna meddelandepanel för tilläggsinstallation
urlbar-tip-help-icon =
    .title = Få hjälp
urlbar-search-tips-confirm = Ok, jag förstår
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = Tips:

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Skriv mindre, hitta mer: Sök med { $engineName } direkt från ditt adressfält.
urlbar-search-tips-redirect-2 = Starta din sökning i adressfältet för att se förslag från { $engineName } och din surfhistorik.

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = Bokmärken
urlbar-search-mode-tabs = Flikar
urlbar-search-mode-history = Historik

##

urlbar-geolocation-blocked =
    .tooltiptext = Du har blockerat platsinformation för denna webbplats.
urlbar-xr-blocked =
    .tooltiptext = Du har blockerat enheter för virtuell verklighet att få åtkomst till den här webbplatsen.
urlbar-web-notifications-blocked =
    .tooltiptext = Du har blockerat notifieringar för denna webbsida.
urlbar-camera-blocked =
    .tooltiptext = Du har blockerat din kamera för denna webbsida.
urlbar-microphone-blocked =
    .tooltiptext = Du har blockerat din mikrofon för denna webbsida.
urlbar-screen-blocked =
    .tooltiptext = Du har blockerat denna webbsida från att få dela din skärm
urlbar-persistent-storage-blocked =
    .tooltiptext = Du har blockerat beständig lagring för denna webbplats.
urlbar-popup-blocked =
    .tooltiptext = Du har blockerat popup-fönster för den här webbplatsen.
urlbar-autoplay-media-blocked =
    .tooltiptext = Du har blockerat automatisk uppspelning av media med ljud för den här webbplatsen.
urlbar-canvas-blocked =
    .tooltiptext = Du har blockerat canvas-extrahering för denna webbplats.
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

page-action-add-to-urlbar =
    .label = Lägg till i adressfältet
page-action-manage-extension =
    .label = Hantera tillägg…
page-action-remove-from-urlbar =
    .label = Ta bort från adressfältet
page-action-remove-extension =
    .label = Ta bort tillägg

## Auto-hide Context Menu

full-screen-autohide =
    .label = Dölj verktygsfält
    .accesskey = D
full-screen-exit =
    .label = Avsluta helskärmsläget
    .accesskey = A

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of one-click search engines in
# the Urlbar and searchbar.
search-one-offs-with-title = Denna gång, sök med:
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = Ändra sökinställningar
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

## Bookmark Panel

bookmark-panel-show-editor-checkbox =
    .label = Visa redigeraren när du sparar
    .accesskey = V
bookmark-panel-done-button =
    .label = Klar
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

identity-connection-not-secure = Anslutningen är inte säker
identity-connection-secure = Anslutningen är säker
identity-connection-internal = Detta är en säker { -brand-short-name } sida.
identity-connection-file = Den här sidan är lagrad på din dator.
identity-extension-page = Den här sidan laddas från ett tillägg.
identity-active-blocked = { -brand-short-name } har blockerat några osäkra komponenter på sidan.
identity-custom-root = Anslutning verifierad av en certifikatutgivare som inte känns igen av Mozilla.
identity-passive-loaded = Vissa komponenter av den här sidan är inte säkra (t.ex. bilder).
identity-active-loaded = Du har stängt av skyddet på den här sidan.
identity-weak-encryption = Den här sidan använder en svag kryptering.
identity-insecure-login-forms = Inloggningar som anges på den här sidan kan äventyras.
identity-permissions =
    .value = Behörigheter
identity-permissions-reload-hint = Du kan behöva ladda om sidan för att ändringarna ska verkställas.
identity-permissions-empty = Du har inte beviljat denna webbplats några särskilda rättigheter.
identity-clear-site-data =
    .label = Rensa kakor och webbplatsdata…
identity-connection-not-secure-security-view = Du är inte säkert ansluten till den här webbplatsen.
identity-connection-verified = Du är säkert ansluten till den här webbplatsen.
identity-ev-owner-label = Certifikat utfärdat till:
identity-description-custom-root = Mozilla känner inte igen denna certifikatutgivare. Den kan ha lagts till från ditt operativsystem eller av en administratör. <label data-l10n-name="link">Lär dig mer</label>
identity-remove-cert-exception =
    .label = Ta bort undantag
    .accesskey = R
identity-description-insecure = Din anslutning till den här sidan är inte privat. Information som du skickar kan ses av andra personer (som t.ex. lösenord, meddelanden, bankkort, osv.).
identity-description-insecure-login-forms = Inloggningsinformation du anger på denna sida är inte säker och kan äventyras.
identity-description-weak-cipher-intro = Din anslutning till den här webbsidan använder en svag kryptering och är inte privat.
identity-description-weak-cipher-risk = Andra personer kan se din information eller ändra webbplatsens beteende.
identity-description-active-blocked = { -brand-short-name } har blockerat några osäkra komponenter på sidan. <label data-l10n-name="link">Lär dig mer</label>
identity-description-passive-loaded = Anslutningen till denna webbplats är inte privat och andra personer kan se din information.
identity-description-passive-loaded-insecure = Den här webbplatsen har innehåll som inte är säkert (t.ex. bilder). <label data-l10n-name="link">Lär dig mer</label>
identity-description-passive-loaded-mixed = { -brand-short-name } har blockerat några osäkra komponenter på sidan, men det finns fortfarande osäkra komponenter (såsom bilder). <label data-l10n-name="link">Lär dig mer</label>
identity-description-active-loaded = Den här webbplatsen innehåller material som inte är säkra (såsom skript) och din anslutning till det är inte privat.
identity-description-active-loaded-insecure = Information du delar med denna webbplats kan ses av andra (som lösenord, meddelanden, kreditkort, etc.).
identity-learn-more =
    .value = Lär dig mer
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

## WebRTC Pop-up notifications

popup-select-camera =
    .value = Kamera att dela:
    .accesskey = K
popup-select-microphone =
    .value = Mikrofon att dela:
    .accesskey = M
popup-all-windows-shared = Alla synliga fönster på din skärm kommer att delas.
popup-screen-sharing-not-now =
    .label = Inte nu
    .accesskey = w
popup-screen-sharing-never =
    .label = Tillåt aldrig
    .accesskey = N
popup-silence-notifications-checkbox = Inaktivera aviseringar från { -brand-short-name } när du delar
popup-silence-notifications-checkbox-warning = { -brand-short-name } kommer inte att visa aviseringar medan du delar.

## WebRTC window or screen share tab switch warning

sharing-warning-window = Du delar { -brand-short-name }. Andra kan se när du byter till en ny flik.
sharing-warning-screen = Du delar hela skärmen. Andra kan se när du byter till en ny flik.
sharing-warning-proceed-to-tab =
    .label = Fortsätt till flik
sharing-warning-disable-for-session =
    .label = Inaktivera delningsskydd för den här sessionen

## DevTools F12 popup

enable-devtools-popup-description = För att använda tangentbordskommandot F12, öppnar du först DevTools i Webbutvecklare-menyn.

## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = Sök eller ange adress
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
# Variables
#  $name (String): the name of the user's default search engine
urlbar-placeholder-with-name =
    .placeholder = Sök med { $name } eller ange adress
urlbar-remote-control-notification-anchor =
    .tooltiptext = Webbläsaren är fjärrstyrd
urlbar-permissions-granted =
    .tooltiptext = Du har beviljat denna webbplats ytterligare behörigheter.
urlbar-switch-to-tab =
    .value = Växla till flik:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Tillägg:
urlbar-go-button =
    .tooltiptext = Gå till adressen i adressfältet
urlbar-page-action-button =
    .tooltiptext = Åtgärder för sida
urlbar-pocket-button =
    .tooltiptext = Spara till { -pocket-brand-name }

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
