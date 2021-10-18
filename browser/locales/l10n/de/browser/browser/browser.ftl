# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The main browser window's title

# These are the default window titles everywhere except macOS. The first two
# attributes are used when the web content opened has no title:
#
# default - "Waterfox"
# private - "Waterfox (Private Browsing)"
#
# The last two are for use when there *is* a content title.
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } (Privater Modus)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (Privater Modus)
# These are the default window titles on macOS. The first two are for use when
# there is no content title:
#
# "default" - "Waterfox"
# "private" - "Waterfox — (Private Browsing)"
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
    .data-title-private = { -brand-full-name } - (Privater Modus)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (Privater Modus)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = Seiteninformationen anzeigen

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = Ansicht über eine Installation öffnen
urlbar-web-notification-anchor =
    .tooltiptext = Ändern, ob diese Website Benachrichtigungen senden darf
urlbar-midi-notification-anchor =
    .tooltiptext = MIDI-Ansicht öffnen
urlbar-eme-notification-anchor =
    .tooltiptext = Verwendung von DRM-geschützter Software verwalten
urlbar-web-authn-anchor =
    .tooltiptext = Ansicht für Web-Authentifizierung öffnen
urlbar-canvas-notification-anchor =
    .tooltiptext = Erlaubnis zur Abfrage von Canvas-Daten verwalten
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = Verwalten des Zugriffs auf Ihr Mikrofon durch diese Website
urlbar-default-notification-anchor =
    .tooltiptext = Ansicht mit Benachrichtigung öffnen
urlbar-geolocation-notification-anchor =
    .tooltiptext = Ansicht mit Standortanfrage öffnen
urlbar-xr-notification-anchor =
    .tooltiptext = Ansicht für VR-Zugriff (Virtuelle Realität) öffnen
urlbar-storage-access-anchor =
    .tooltiptext = Ansicht für während des Surfens berechtigte Aktivitäten öffnen
urlbar-translate-notification-anchor =
    .tooltiptext = Diese Seite übersetzen
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Verwalten des Zugriffs auf Ihre Fenster oder Bildschirme durch diese Website
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Ansicht über Offline-Speicher öffnen
urlbar-password-notification-anchor =
    .tooltiptext = Ansicht über gespeicherte Zugangsdaten öffnen
urlbar-translated-notification-anchor =
    .tooltiptext = Übersetzung von Seiten verwalten
urlbar-plugins-notification-anchor =
    .tooltiptext = Plugin-Verwendung verwalten
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Verwalten des Zugriffs auf Ihre Kamera und/oder Ihr Mikrofon durch diese Website
# "Speakers" is used in a general sense that might include headphones or
# another audio output connection.
urlbar-web-rtc-share-speaker-notification-anchor =
    .tooltiptext = Verwalten des Zugriffs auf andere Lautsprecher durch diese Website
urlbar-autoplay-notification-anchor =
    .tooltiptext = Ansicht für automatische Wiedergabe öffnen
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Daten im dauerhaften Speicher speichern
urlbar-addons-notification-anchor =
    .tooltiptext = Ansicht mit Anfrage zur Installation eines Add-ons öffnen
urlbar-tip-help-icon =
    .title = Hilfe erhalten
urlbar-search-tips-confirm = OK
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = Tipp:

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Weniger tippen, mehr finden: Direkt mit { $engineName } von der Adressleiste aus suchen.
urlbar-search-tips-redirect-2 = Starten Sie Ihre Suche in der Adressleiste, um Suchvorschläge von { $engineName } sowie Ihre Browser-Chronik angezeigt zu bekommen.
# Prompts users to use the Urlbar when they are typing in the domain of a
# search engine, e.g. google.com or amazon.com.
urlbar-tabtosearch-onboard = Wählen Sie diese Verknüpfung, um schneller Suchergebnisse zu erhalten.

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = Lesezeichen
urlbar-search-mode-tabs = Tabs
urlbar-search-mode-history = Chronik

##

urlbar-geolocation-blocked =
    .tooltiptext = Sie haben den Zugriff auf Ihren Standort durch diese Website blockiert.
urlbar-xr-blocked =
    .tooltiptext = Sie haben den Zugriff auf VR-Geräte durch diese Website blockiert.
urlbar-web-notifications-blocked =
    .tooltiptext = Sie haben das Anzeigen von Benachrichtungen durch diese Website blockiert.
urlbar-camera-blocked =
    .tooltiptext = Sie haben den Zugriff auf Ihre Kamera durch diese Website blockiert.
urlbar-microphone-blocked =
    .tooltiptext = Sie haben den Zugriff auf Ihr Mikrofon durch diese Website blockiert.
urlbar-screen-blocked =
    .tooltiptext = Sie haben den Zugriff auf Ihren Bildschirm durch diese Website blockiert.
urlbar-persistent-storage-blocked =
    .tooltiptext = Sie haben die Verwendung von dauerhaftem Speicher für diese Website blockiert.
urlbar-popup-blocked =
    .tooltiptext = Sie haben das Anzeigen von Pop-ups für diese Website blockiert.
urlbar-autoplay-media-blocked =
    .tooltiptext = Sie haben die automatische Wiedergabe von Medien mit Ton für diese Website blockiert.
urlbar-canvas-blocked =
    .tooltiptext = Sie haben das Abfragen von Canvas-Daten durch diese Website blockiert.
urlbar-midi-blocked =
    .tooltiptext = Sie haben den Zugriff auf MIDI durch diese Website blockiert.
urlbar-install-blocked =
    .tooltiptext = Sie haben die Installation von Erweiterungen von dieser Website blockiert.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = Dieses Lesezeichen bearbeiten ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = Lesezeichen für diese Seite setzen ({ $shortcut })

## Page Action Context Menu

page-action-manage-extension =
    .label = Erweiterung verwalten…
page-action-remove-extension =
    .label = Erweiterung entfernen

## Auto-hide Context Menu

full-screen-autohide =
    .label = Symbolleisten ausblenden
    .accesskey = a
full-screen-exit =
    .label = Vollbild beenden
    .accesskey = V

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of search shortcuts in
# the Urlbar and searchbar.
search-one-offs-with-title = Einmalig suchen mit:
search-one-offs-change-settings-compact-button =
    .tooltiptext = Sucheinstellungen ändern
search-one-offs-context-open-new-tab =
    .label = In neuem Tab suchen
    .accesskey = T
search-one-offs-context-set-as-default =
    .label = Als Standardsuchmaschine festlegen
    .accesskey = S
search-one-offs-context-set-as-default-private =
    .label = Als Standardsuchmaschine für private Fenster festlegen
    .accesskey = p
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
    .label = "{ $engineName }" hinzufügen
    .tooltiptext = Suchmaschine "{ $engineName }" hinzufügen
    .aria-label = Suchmaschine "{ $engineName }" hinzufügen
# When more than 5 engines are offered by a web page, they are grouped in a
# submenu using this as its label.
search-one-offs-add-engine-menu =
    .label = Suchmaschine hinzufügen

## Local search mode one-off buttons
## Variables:
##  $restrict (String): The restriction token corresponding to the search mode.
##    Restriction tokens are special characters users can type in the urlbar to
##    restrict their searches to certain sources (e.g., "*" to search only
##    bookmarks).

search-one-offs-bookmarks =
    .tooltiptext = Lesezeichen ({ $restrict })
search-one-offs-tabs =
    .tooltiptext = Tabs ({ $restrict })
search-one-offs-history =
    .tooltiptext = Chronik ({ $restrict })

## Bookmark Panel

bookmarks-add-bookmark = Lesezeichen hinzufügen
bookmarks-edit-bookmark = Lesezeichen bearbeiten
bookmark-panel-cancel =
    .label = Abbrechen
    .accesskey = b
# Variables:
#  $count (number): number of bookmarks that will be removed
bookmark-panel-remove =
    .label =
        { $count ->
            [one] Lesezeichen entfernen
           *[other] { $count } Lesezeichen entfernen
        }
    .accesskey = e
bookmark-panel-show-editor-checkbox =
    .label = Eigenschaften beim Speichern bearbeiten
    .accesskey = g
bookmark-panel-save-button =
    .label = Speichern
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

# Variables
#  $host (String): the hostname of the site that is being displayed.
identity-site-information = Website-Informationen für { $host }
# Variables
#  $host (String): the hostname of the site that is being displayed.
identity-header-security-with-host =
    .title = Verbindungssicherheit für { $host }
identity-connection-not-secure = Verbindung nicht sicher
identity-connection-secure = Verbindung sicher
identity-connection-failure = Verbindungsfehler
identity-connection-internal = Dies ist eine sichere { -brand-short-name }-Seite.
identity-connection-file = Diese Seite ist auf Ihrem Computer gespeichert.
identity-extension-page = Diese Seite wurde durch eine Erweiterung bereitgestellt.
identity-active-blocked = { -brand-short-name } hat nicht sichere Inhalte dieser Seite blockiert.
identity-custom-root = Die Verbindung wurde durch eine Zertifizierungsstelle bestätigt, welche standardmäßig nicht von Waterfox anerkannt wird.
identity-passive-loaded = Teile dieser Seite sind nicht sicher (wie z.B. Grafiken).
identity-active-loaded = Sie haben den Schutz für diese Seite deaktiviert.
identity-weak-encryption = Diese Seite verwendet eine schwache Verschlüsselung.
identity-insecure-login-forms = Ihre Zugangsdaten könnten auf dieser Seite in falsche Hände geraten.
identity-https-only-connection-upgraded = (zu HTTPS geändert)
identity-https-only-label = Nur-HTTPS-Modus
identity-https-only-dropdown-on =
    .label = Ein
identity-https-only-dropdown-off =
    .label = Aus
identity-https-only-dropdown-off-temporarily =
    .label = Temporär aus
identity-https-only-info-turn-on2 = Aktivieren Sie den Nur-HTTPS-Modus für diese Website, wenn { -brand-short-name } nach Möglichkeit über HTTPS verbinden soll.
identity-https-only-info-turn-off2 = Wenn die Seite beschädigt erscheint, können Sie den Nur-HTTPS-Modus für diese Website deaktivieren, um mit nicht verschlüsseltem HTTP neu zu laden.
identity-https-only-info-no-upgrade = Verbindung konnte nicht von HTTP geändert werden.
identity-permissions-storage-access-header = Seitenübergreifende Cookies
identity-permissions-storage-access-hint = Diese Beteiligten können Cookies und Website-Daten verwenden, während Sie sich auf dieser Website befinden.
identity-permissions-storage-access-learn-more = Weitere Informationen
identity-permissions-reload-hint = Eventuell muss die Seite neu geladen werden, um die Änderungen zu übernehmen.
identity-clear-site-data =
    .label = Cookies und Website-Daten löschen…
identity-connection-not-secure-security-view = Sie kommunizieren mit dieser Seite über eine ungesicherte Verbindung.
identity-connection-verified = Sie sind derzeit über eine gesicherte Verbindung mit dieser Website verbunden.
identity-ev-owner-label = Zertifikat ausgestellt für:
identity-description-custom-root = Waterfox erkennt diese Zertifizierungsstelle standardmäßig nicht an. Sie wurde eventuell vom Betriebssystem oder durch einen Administrator importiert. <label data-l10n-name="link">Weitere Informationen</label>
identity-remove-cert-exception =
    .label = Ausnahme entfernen
    .accesskey = A
identity-description-insecure = Ihre Verbindung zu dieser Website ist nicht vertraulich. Von Ihnen übermittelte Informationen (wie Passwörter, Nachrichten, Kreditkartendaten, usw.) können von Anderen eingesehen werden.
identity-description-insecure-login-forms = Wenn Sie Ihre Zugangsdaten auf dieser Website eingeben, werden diese unverschlüsselt übertragen und können in falsche Hände geraten.
identity-description-weak-cipher-intro = Ihre Verbindung zu dieser Website verwendet eine schwache Verschlüsselung.
identity-description-weak-cipher-risk = Andere Personen können Ihre Informationen mitlesen oder das Verhalten der Website ändern.
identity-description-active-blocked = { -brand-short-name } hat nicht sichere Inhalte dieser Seite blockiert. <label data-l10n-name="link">Weitere Informationen</label>
identity-description-passive-loaded = Ihre Verbindung ist nicht sicher und mit dieser Website geteilte Informationen können von Anderen eingesehen werden.
identity-description-passive-loaded-insecure = Diese Website enthält nicht sichere Inhalte (wie z.B. Grafiken). <label data-l10n-name="link">Weitere Informationen</label>
identity-description-passive-loaded-mixed = Obwohl { -brand-short-name } Inhalte blockiert hat, enthält die Seite noch nicht sichere Inhalte (wie z.B. Grafiken). <label data-l10n-name="link">Weitere Informationen</label>
identity-description-active-loaded = Diese Website enthält nicht sichere Inhalte (wie z.B. Skripte) und Ihre Verbindung ist nicht vertraulich.
identity-description-active-loaded-insecure = Mit dieser Seite geteilte Informationen (wie Passwörter, Nachrichten, Kreditkartendaten, usw.) können von Anderen eingesehen werden.
identity-learn-more =
    .value = Weitere Informationen
identity-disable-mixed-content-blocking =
    .label = Schutz momentan deaktivieren
    .accesskey = d
identity-enable-mixed-content-blocking =
    .label = Schutz aktivieren
    .accesskey = a
identity-more-info-link-text =
    .label = Weitere Informationen

## Window controls

browser-window-minimize-button =
    .tooltiptext = Minimieren
browser-window-maximize-button =
    .tooltiptext = Maximieren
browser-window-restore-down-button =
    .tooltiptext = Verkleinern
browser-window-close-button =
    .tooltiptext = Schließen

## Tab actions

# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-playing2 = WIEDERGABE
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-muted2 = STUMMGESCHALTET
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-blocked = BLOCKIERUNG DER WIEDERGABE
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-pip = BILD-IM-BILD

## These labels should be written in all capital letters if your locale supports them.
## Variables:
##  $count (number): number of affected tabs

browser-tab-mute =
    { $count ->
        [1] TAB STUMMSCHALTEN
       *[other] { $count } TABS STUMMSCHALTEN
    }
browser-tab-unmute =
    { $count ->
        [1] STUMMSCHALTUNG FÜR TAB AUFHEBEN
       *[other] STUMMSCHALTUNG FÜR { $count } TABS AUFHEBEN
    }
browser-tab-unblock =
    { $count ->
        [1] TAB WIEDERGEBEN
       *[other] { $count } TABS WIEDERGEBEN
    }

## Bookmarks toolbar items

browser-import-button2 =
    .label = Lesezeichen importieren…
    .tooltiptext = Lesezeichen aus einem anderen Browser zu { -brand-short-name } importieren.
bookmarks-toolbar-empty-message = Legen Sie Ihre Lesezeichen hier in der Lesezeichen-Symbolleiste ab, um schnell darauf zuzugreifen. <a data-l10n-name="manage-bookmarks">Lesezeichen verwalten…</a>

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
    .tooltiptext = Audiowiedergabegeräte
popup-all-windows-shared = Alle sichtbaren Fenster auf dem Bildschirm werden weitergegeben.
popup-screen-sharing-block =
    .label = Blockieren
    .accesskey = B
popup-screen-sharing-always-block =
    .label = Immer blockieren
    .accesskey = m
popup-mute-notifications-checkbox = Website-Benachrichtigungen stummschalten, während ein Bildschirm oder ein Fenster geteilt wird

## WebRTC window or screen share tab switch warning

sharing-warning-window = Sie teilen { -brand-short-name }. Andere Personen können sehen, wenn Sie zu einem neuen Tab wechseln.
sharing-warning-screen = Sie teilen Ihren gesamten Bildschirm. Andere Personen können sehen, wenn Sie zu einem neuen Tab wechseln.
sharing-warning-proceed-to-tab =
    .label = Weiter zum Tab
sharing-warning-disable-for-session =
    .label = Freigabeschutz für diese Sitzung deaktivieren

## DevTools F12 popup

enable-devtools-popup-description = Um die F12-Tastenkkombination einzusetzen, müssen die Entwicklerwerkzeuge einmalig über das Menü "Web-Entwickler" geöffnet werden.

## URL Bar

# This placeholder is used when not in search mode and the user's default search
# engine is unknown.
urlbar-placeholder =
    .placeholder = Suche oder Adresse eingeben
# This placeholder is used in search mode with search engines that search the
# entire web.
# Variables
#  $name (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-placeholder-search-mode-web-2 =
    .placeholder = Das Web durchsuchen
    .aria-label = Mit { $name } suchen
# This placeholder is used in search mode with search engines that search a
# specific site (e.g., Amazon).
# Variables
#  $name (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-placeholder-search-mode-other-engine =
    .placeholder = Suchbegriffe eingeben
    .aria-label = { $name } durchsuchen
# This placeholder is used when searching bookmarks.
urlbar-placeholder-search-mode-other-bookmarks =
    .placeholder = Suchbegriffe eingeben
    .aria-label = Lesezeichen durchsuchen
# This placeholder is used when searching history.
urlbar-placeholder-search-mode-other-history =
    .placeholder = Suchbegriffe eingeben
    .aria-label = Verlauf durchsuchen
# This placeholder is used when searching open tabs.
urlbar-placeholder-search-mode-other-tabs =
    .placeholder = Suchbegriffe eingeben
    .aria-label = Tabs durchsuchen
# Variables
#  $name (String): the name of the user's default search engine
urlbar-placeholder-with-name =
    .placeholder = Mit { $name } suchen oder Adresse eingeben
# Variables
#  $component (String): the name of the component which forces remote control.
#    Example: "DevTools", "Marionette", "RemoteAgent".
urlbar-remote-control-notification-anchor2 =
    .tooltiptext = Browser wird ferngesteuert (Grund: { $component })
urlbar-permissions-granted =
    .tooltiptext = Sie haben dieser Website zusätzliche Berechtigungen erteilt.
urlbar-switch-to-tab =
    .value = Wechseln zum Tab:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Erweiterung:
urlbar-go-button =
    .tooltiptext = In der Adressleiste eingegebene Adresse laden
urlbar-page-action-button =
    .tooltiptext = Aktionen für Seite

## Action text shown in urlbar results, usually appended after the search
## string or the url, like "result value - action text".

# Used when the private browsing engine differs from the default engine.
# The "with" format was chosen because the search engine name can end with
# "Search", and we would like to avoid strings like "Search MSN Search".
# Variables
#  $engine (String): the name of a search engine
urlbar-result-action-search-in-private-w-engine = Mit "{ $engine }" in privatem Fenster suchen
# Used when the private browsing engine is the same as the default engine.
urlbar-result-action-search-in-private = In privatem Fenster suchen
# The "with" format was chosen because the search engine name can end with
# "Search", and we would like to avoid strings like "Search MSN Search".
# Variables
#  $engine (String): the name of a search engine
urlbar-result-action-search-w-engine = Mit "{ $engine }" suchen
urlbar-result-action-sponsored = Gesponsert
urlbar-result-action-switch-tab = Zum Tab wechseln
urlbar-result-action-visit = Aufrufen
# Directs a user to press the Tab key to perform a search with the specified
# engine.
# Variables
#  $engine (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-result-action-before-tabtosearch-web = Tab drücken, um mit { $engine } zu suchen
# Directs a user to press the Tab key to perform a search with the specified
# engine.
# Variables
#  $engine (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-result-action-before-tabtosearch-other = Tab drücken, um { $engine } zu durchsuchen
# Variables
#  $engine (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-result-action-tabtosearch-web = Mit { $engine } direkt aus der Adressleiste suchen
# Variables
#  $engine (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-result-action-tabtosearch-other-engine = { $engine } direkt aus der Adressleiste durchsuchen
# Action text for copying to clipboard.
urlbar-result-action-copy-to-clipboard = Kopieren
# Shows the result of a formula expression being calculated, the last = sign will be shown
# as part of the result (e.g. "= 2").
# Variables
#  $result (String): the string representation for a formula result
urlbar-result-action-calculator-result = = { $result }

## Action text shown in urlbar results, usually appended after the search
## string or the url, like "result value - action text".
## In these actions "Search" is a verb, followed by where the search is performed.

urlbar-result-action-search-bookmarks = Lesezeichen durchsuchen
urlbar-result-action-search-history = Chronik durchsuchen
urlbar-result-action-search-tabs = Tabs durchsuchen

## Labels shown above groups of urlbar results

# A label shown above the "Waterfox Suggest" (bookmarks/history) group in the
# urlbar results.
urlbar-group-firefox-suggest =
    .label = { -firefox-suggest-brand-name }
# A label shown above the search suggestions group in the urlbar results. It
# should use title case.
# Variables
#  $engine (String): the name of the search engine providing the suggestions
urlbar-group-search-suggestions =
    .label = { $engine }-Vorschläge

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> befindet sich jetzt im Vollbildmodus.
fullscreen-warning-no-domain = Dieses Dokument befindet sich jetzt im Vollbildmodus.
fullscreen-exit-button = Vollbild beenden (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = Vollbild beenden (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> kontrolliert den Mauszeiger. Drücken Sie die Esc-Taste, wenn Sie wieder die Kontrolle übernehmen wollen.
pointerlock-warning-no-domain = Dieses Dokument kontrolliert den Mauszeiger. Drücken Sie die Esc-Taste, wenn Sie wieder die Kontrolle übernehmen wollen.

## Subframe crash notification

crashed-subframe-message = <strong>Ein Teil der Seite ist abgestürzt.</strong> Übermitteln Sie bitte einen Bericht, um { -brand-product-name } über dieses Problem zu informieren und beim Beheben des Fehlers zu helfen.
# The string for crashed-subframe-title.title should match crashed-subframe-message,
# but without any markup.
crashed-subframe-title =
    .title = Ein Teil der Seite ist abgestürzt. Übermitteln Sie bitte einen Bericht, um { -brand-product-name } über dieses Problem zu informieren und beim Beheben des Fehlers zu helfen.
crashed-subframe-learnmore-link =
    .value = Weitere Informationen
crashed-subframe-submit =
    .label = Bericht senden
    .accesskey = B

## Bookmarks panels, menus and toolbar

bookmarks-manage-bookmarks =
    .label = Lesezeichen verwalten
bookmarks-recent-bookmarks-panel-subheader = Neueste Lesezeichen
bookmarks-toolbar-chevron =
    .tooltiptext = Weitere Lesezeichen anzeigen
bookmarks-sidebar-content =
    .aria-label = Lesezeichen
bookmarks-menu-button =
    .label = Lesezeichen-Menü
bookmarks-other-bookmarks-menu =
    .label = Weitere Lesezeichen
bookmarks-mobile-bookmarks-menu =
    .label = Mobile Lesezeichen
bookmarks-tools-sidebar-visibility =
    .label =
        { $isVisible ->
            [true] Lesezeichen-Sidebar schließen
           *[other] Lesezeichen-Sidebar anzeigen
        }
bookmarks-tools-toolbar-visibility-menuitem =
    .label =
        { $isVisible ->
            [true] Lesezeichen-Symbolleiste ausblenden
           *[other] Lesezeichen-Symbolleiste anzeigen
        }
bookmarks-tools-toolbar-visibility-panel =
    .label =
        { $isVisible ->
            [true] Lesezeichen-Symbolleiste ausblenden
           *[other] Lesezeichen-Symbolleiste anzeigen
        }
bookmarks-tools-menu-button-visibility =
    .label =
        { $isVisible ->
            [true] Lesezeichen-Menü aus Symbolleiste entfernen
           *[other] Lesezeichen-Menü zur Symbolleiste hinzufügen
        }
bookmarks-search =
    .label = Lesezeichen durchsuchen
bookmarks-tools =
    .label = Lesezeichen-Werkzeuge
bookmarks-bookmark-edit-panel =
    .label = Lesezeichen bearbeiten
# The aria-label is a spoken label that should not include the word "toolbar" or
# such, because screen readers already know that this container is a toolbar.
# This avoids double-speaking.
bookmarks-toolbar =
    .toolbarname = Lesezeichen-Symbolleiste
    .accesskey = L
    .aria-label = Lesezeichen
bookmarks-toolbar-menu =
    .label = Lesezeichen-Symbolleiste
bookmarks-toolbar-placeholder =
    .title = Lesezeichen-Symbole
bookmarks-toolbar-placeholder-button =
    .label = Lesezeichen-Symbole
# "Bookmark" is a verb, as in "Add current tab to bookmarks".
bookmarks-current-tab =
    .label = Aktuellen Tab als Lesezeichen hinzufügen

## Library Panel items

library-bookmarks-menu =
    .label = Lesezeichen
library-recent-activity-title =
    .value = Neueste Aktivität

## Pocket toolbar button

save-to-pocket-button =
    .label = In { -pocket-brand-name } speichern
    .tooltiptext = In { -pocket-brand-name } speichern

## Repair text encoding toolbar button

repair-text-encoding-button =
    .label = Textkodierung reparieren
    .tooltiptext = Richtige Textkodierung basierend auf dem Seiteninhalt erraten

## Customize Toolbar Buttons

# Variables:
#  $shortcut (String): keyboard shortcut to open the add-ons manager
toolbar-addons-themes-button =
    .label = Add-ons und Themes
    .tooltiptext = Add-ons und Themes verwalten ({ $shortcut })
# Variables:
#  $shortcut (String): keyboard shortcut to open settings (only on macOS)
toolbar-settings-button =
    .label = Einstellungen
    .tooltiptext =
        { PLATFORM() ->
            [macos] Einstellungen öffnen ({ $shortcut })
           *[other] Einstellungen öffnen
        }

## More items

more-menu-go-offline =
    .label = Offline arbeiten
    .accesskey = O
toolbar-overflow-customize-button =
    .label = Symbolleisten anpassen…
    .accesskey = S
toolbar-button-email-link =
    .label = ­Link senden
    .tooltiptext = Link zu dieser Seite per E-Mail senden
# Variables:
#  $shortcut (String): keyboard shortcut to save a copy of the page
toolbar-button-save-page =
    .label = ­Seite speichern
    .tooltiptext = Seite speichern unter ({ $shortcut })
# Variables:
#  $shortcut (String): keyboard shortcut to open a local file
toolbar-button-open-file =
    .label = ­Datei öffnen
    .tooltiptext = Datei öffnen ({ $shortcut })
toolbar-button-synced-tabs =
    .label = Synchronisierte Tabs
    .tooltiptext = Tabs von anderen Geräten anzeigen
# Variables
# $shortcut (string) - Keyboard shortcut to open a new private browsing window
toolbar-button-new-private-window =
    .label = Neues privates Fenster
    .tooltiptext = Ein neues privates Fenster öffnen ({ $shortcut })

## EME notification panel

eme-notifications-drm-content-playing = Einige Audio- oder Videodateien auf dieser Seite nutzen DRM-Kopierschutz, der einschränkt, was Sie in { -brand-short-name } damit tun können.
eme-notifications-drm-content-playing-manage = Einstellungen verwalten
eme-notifications-drm-content-playing-manage-accesskey = v
eme-notifications-drm-content-playing-dismiss = Schließen
eme-notifications-drm-content-playing-dismiss-accesskey = c

## Password save/update panel

panel-save-update-username = Benutzername
panel-save-update-password = Passwort

## Add-on removal warning

# Variables:
#  $name (String): The name of the addon that will be removed.
addon-removal-title = { $name } entfernen?
addon-removal-abuse-report-checkbox = Erweiterung melden an { -vendor-short-name }

## Remote / Synced tabs

remote-tabs-manage-account =
    .label = Konto verwalten
remote-tabs-sync-now = Jetzt synchronisieren

##

# "More" item in macOS share menu
menu-share-more =
    .label = Mehr…
ui-tour-info-panel-close =
    .tooltiptext = Schließen

## Variables:
##  $uriHost (String): URI host for which the popup was allowed or blocked.

popups-infobar-allow =
    .label = Pop-ups erlauben für { $uriHost }
    .accesskey = P
popups-infobar-block =
    .label = Pop-ups von { $uriHost } blockieren
    .accesskey = P

##

popups-infobar-dont-show-message =
    .label = Diese Nachricht nicht mehr einblenden, wenn Pop-ups blockiert wurden
    .accesskey = n
edit-popup-settings =
    .label = Pop-up-Einstellungen verwalten…
    .accesskey = v
picture-in-picture-hide-toggle =
    .label = Schalter für Bild-im-Bild (PiP) ausblenden
    .accesskey = B

# Navigator Toolbox

# This string is a spoken label that should not include
# the word "toolbar" or such, because screen readers already know that
# this container is a toolbar. This avoids double-speaking.
navbar-accessible =
    .aria-label = Navigation
navbar-downloads =
    .label = Downloads
navbar-overflow =
    .tooltiptext = Mehr Werkzeuge…
# Variables:
#   $shortcut (String): keyboard shortcut to print the page
navbar-print =
    .label = Drucken
    .tooltiptext = Diese Seite drucken… ({ $shortcut })
navbar-print-tab-modal-disabled =
    .label = Drucken
    .tooltiptext = Diese Seite drucken
navbar-home =
    .label = Startseite
    .tooltiptext = { -brand-short-name }-Startseite
navbar-library =
    .label = Bibliothek
    .tooltiptext = Öffnen von Chronik, Lesezeichen und mehr
navbar-search =
    .title = Suchen
navbar-accessibility-indicator =
    .tooltiptext = Funktionen für Barrierefreiheit aktiviert
# Name for the tabs toolbar as spoken by screen readers. The word
# "toolbar" is appended automatically and should not be included in
# in the string
tabs-toolbar =
    .aria-label = Browser-Tabs
tabs-toolbar-new-tab =
    .label = Neuer Tab
tabs-toolbar-list-all-tabs =
    .label = Alle Tabs auflisten
    .tooltiptext = Alle Tabs auflisten

## Infobar shown at startup to suggest session-restore

# <img data-l10n-name="icon"/> will be replaced by the application menu icon
restore-session-startup-suggestion-message = <strong>Vorherige Tabs öffnen?</strong> Sie können Ihre vorherige Sitzung über das { -brand-short-name }-Anwendungsmenü <img data-l10n-name="icon"/> unter Chronik wiederherstellen.
restore-session-startup-suggestion-button = Wie es funktioniert
