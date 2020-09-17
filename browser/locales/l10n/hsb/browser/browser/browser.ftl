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
    .data-title-private = { -brand-full-name } (Priwatny modus)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (Priwatny modus)
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
    .data-title-private = { -brand-full-name } - (Priwatny modus)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (Priwatny modus)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = Sydłowe informacije wobhladać

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = Wobłuk instalaciskeje zdźělenki wočinić
urlbar-web-notification-anchor =
    .tooltiptext = Změńće, hač móžeće zdźělenki wot sydła přijeć
urlbar-midi-notification-anchor =
    .tooltiptext = MIDI-wobłuk wočinić
urlbar-eme-notification-anchor =
    .tooltiptext = Wužiwanje softwary DRM rjadować
urlbar-web-authn-anchor =
    .tooltiptext = Wobłuk webawtentifikacije wočinić
urlbar-canvas-notification-anchor =
    .tooltiptext = Prawo za ekstrahowanje canvas rjadować
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = Dźělenje wašeho mikrofona ze sydłom rjadować
urlbar-default-notification-anchor =
    .tooltiptext = Wobłuk powěsćow wočinić
urlbar-geolocation-notification-anchor =
    .tooltiptext = Wobłuk stejnišćoweho naprašowanja wočinić
urlbar-xr-notification-anchor =
    .tooltiptext = Dialog za prawa wirtualneje reality wočinić
urlbar-storage-access-anchor =
    .tooltiptext = Dialog za prawa přehladowanskeje aktiwity wočinić
urlbar-translate-notification-anchor =
    .tooltiptext = Tutu stronu přełožować
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Dźělenje wašich woknow abo wašeje wobrazowki ze sydłom rjadować
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Wobłuk zdźělenki składowanja offline wočinić
urlbar-password-notification-anchor =
    .tooltiptext = Wobłuk zdźělenki składowanja hesła wočinić
urlbar-translated-notification-anchor =
    .tooltiptext = Přełožowanje strony rjadować
urlbar-plugins-notification-anchor =
    .tooltiptext = Wužiwanje tykačow rjadować
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Dźělenje wašeje kamery a /abo wašeho mikrofona ze sydłom rjadować
urlbar-autoplay-notification-anchor =
    .tooltiptext = Wobłuk za awtomatiske wothraće wočinić
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Daty w trajnym składowaku składować
urlbar-addons-notification-anchor =
    .tooltiptext = Wobłuk zdźělenki přidatkoweje instalacije wočinić
urlbar-tip-help-icon =
    .title = Pomoc sej wobstarać
urlbar-search-tips-confirm = W porjadku, sym zrozumił
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = Pokiw:

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Pisajće mjenje, namakajće wjace: Pytajće z { $engineName } direktnje ze swojeho adresoweho pola.
urlbar-search-tips-redirect-2 = Započńće swoje pytanje w adresowym polu, zo byšće namjety wot { $engineName } a ze swojeje přehladowanskeje historije widźał.

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = Zapołožki
urlbar-search-mode-tabs = Rajtarki
urlbar-search-mode-history = Historija

##

urlbar-geolocation-blocked =
    .tooltiptext = Sće tutomu websydłu informacijie wo stejnišću zapowědźił.
urlbar-xr-blocked =
    .tooltiptext = Sće přistup ke gratej wirtuelneje reality za tute websydło zablokował.
urlbar-web-notifications-blocked =
    .tooltiptext = Sće zdźělenki za tute websydło zablokował.
urlbar-camera-blocked =
    .tooltiptext = Sće swoju kameru za tute websydło zablokował.
urlbar-microphone-blocked =
    .tooltiptext = Sće swój mikrofon za tute websydło zablokował.
urlbar-screen-blocked =
    .tooltiptext = Sće tutomu websydłu dźělenje swojeje wobrazowki zakazał.
urlbar-persistent-storage-blocked =
    .tooltiptext = Sće trajny składowak za tute websydło zablokował.
urlbar-popup-blocked =
    .tooltiptext = Sće wuskakowace wokna za tute websydło zablokował.
urlbar-autoplay-media-blocked =
    .tooltiptext = Sće awtomatiske wothraće medijow ze zynkom za tute websydło zablokował.
urlbar-canvas-blocked =
    .tooltiptext = Sće přistup ke canvasowym datam za tute websydło zablokował.
urlbar-midi-blocked =
    .tooltiptext = Sće přistup na MIDI za tute websydło zablokował.
urlbar-install-blocked =
    .tooltiptext = Sće instalowanje přidatkow za tute websydło zablokował.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = Tutu zapołožku ({ $shortcut }) wobdźěłać
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = Tutu stronu ({ $shortcut }) jako zapołožku składować

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = Adresowemu polu přidać
page-action-manage-extension =
    .label = Rozšěrjenje rjadować…
page-action-remove-from-urlbar =
    .label = Z adresoweho pola wotstronić
page-action-remove-extension =
    .label = Rozšěrjenje wotstronić

## Auto-hide Context Menu

full-screen-autohide =
    .label = Symbolowe lajsty schować
    .accesskey = b
full-screen-exit =
    .label = Modus połneje wobrazowki wopušćić
    .accesskey = M

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of one-click search engines in
# the Urlbar and searchbar.
search-one-offs-with-title = Nětko pytać z:
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = Pytanske nastajenja
search-one-offs-change-settings-compact-button =
    .tooltiptext = Pytanske nastajenja změnić
search-one-offs-context-open-new-tab =
    .label = W nowym rajtarku pytać
    .accesskey = r
search-one-offs-context-set-as-default =
    .label = Jako standardnu pytawu nastajić
    .accesskey = d
search-one-offs-context-set-as-default-private =
    .label = Jako standardnu pytawu za priwatne wokna nastajić
    .accesskey = J
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
    .tooltiptext = Zapołožki ({ $restrict })
search-one-offs-tabs =
    .tooltiptext = Rajtarki ({ $restrict })
search-one-offs-history =
    .tooltiptext = Historija ({ $restrict })

## Bookmark Panel

bookmark-panel-show-editor-checkbox =
    .label = Editor při składowanju pokazać
    .accesskey = E
bookmark-panel-done-button =
    .label = Dokónčeny
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

identity-connection-not-secure = Zwisk njewěsty
identity-connection-secure = Zwisk wěsty
identity-connection-internal = To je wěsta strona { -brand-short-name }.
identity-connection-file = Tuta strona je so na wašim ličaku składowała.
identity-extension-page = Tuta strona je so z rozšěrjenja začitała.
identity-active-blocked = { -brand-short-name } je dźěle tuteje strony zablokował, kotrež wěste njejsu.
identity-custom-root = Zwisk je so přez certifikatoweho wudawarja přepruwował, kotryž wot Mozilla připóznaty njeje.
identity-passive-loaded = Dźěle tuteje strony wěste njejsu (na přikład wobrazy).
identity-active-loaded = Sće škit na tutej stronje znjemóžnił.
identity-weak-encryption = Tuta strona słabe zaklučowanje wužiwa.
identity-insecure-login-forms = Přizjewjenja, kotrež so na tutej stronje zapodawaja, móhli wohrožene być.
identity-permissions =
    .value = Prawa
identity-permissions-reload-hint = Dyrbiće snano stronu znowa začitać, zo bychu so změny wuskutkowali.
identity-permissions-empty = Njejsće tutomu sydłu wosebite prawa přizwolił.
identity-clear-site-data =
    .label = Placki a sydłowe daty zhašeć…
identity-connection-not-secure-security-view = Njejsće wěsće z tutym sydłom zwjazany.
identity-connection-verified = Sće wěsće z tutym sydłom zwjazany.
identity-ev-owner-label = Certifikat wupisany na:
identity-description-custom-root = Mozilla tutoho certifikatoweho wudawarja njepřipóznawa. Je so snano přez waš dźěłowy system abo wot administratora přidał. <label data-l10n-name="link">Dalše informacije</label>
identity-remove-cert-exception =
    .label = Wuwzaće wotstronić
    .accesskey = W
identity-description-insecure = Waš zwisk z tutym sydłom priwatny njeje. Druzy ludźo móhli Informacije widźeć, kotrež sćeleće (na přikład hesła, powěsće, kreditne karty atd.).
identity-description-insecure-login-forms = Přizjewjenske informacije, kotrež na tutej stronje zapodawać, njejsu wěste a móhli so wothrozyć.
identity-description-weak-cipher-intro = Waš zwisk z websydłom słabe zaklučowanje wužiwa a njeje priwatny.
identity-description-weak-cipher-risk = Druzy ludźo móža sej waše informacije wobhladać abo zadźerženje websydła změnić.
identity-description-active-blocked = { -brand-short-name } je dźěle tuteje strony zablokował, kotrež wěste njejsu. <label data-l10n-name="link">Dalše informacije</label>
identity-description-passive-loaded = Waš zwisk priwatny njeje a druzy móhli informacije widźeć, kotrež ze sydłom dźěliće.
identity-description-passive-loaded-insecure = Websydło wobsahuje wobsah, kotryž wěsty njeje (kaž na přikład wobrazy). <label data-l10n-name="link">Dalše informacije</label>
identity-description-passive-loaded-mixed = Hačrunjež { -brand-short-name } je wobsah zablokował, je hišće wobsah na stronje, kotryž wěsty njeje (na přikład wobrazy). <label data-l10n-name="link">Dalše informacije</label>
identity-description-active-loaded = Tute websydło wobsahuje wobsah, kotryž wěsty njeje (na přikład skripty) a waš zwisk z nim priwatny njeje.
identity-description-active-loaded-insecure = Druzy ludźo móža informacije widźeć, kotrež z tutym sydłom dźěliće (na přikład hesła, powěsće, kreditne karty atd.).
identity-learn-more =
    .value = Dalše informacije
identity-disable-mixed-content-blocking =
    .label = Škit nachwilu znjemóžnić
    .accesskey = z
identity-enable-mixed-content-blocking =
    .label = Škit zmóžnić
    .accesskey = z
identity-more-info-link-text =
    .label = Dalše informacije

## Window controls

browser-window-minimize-button =
    .tooltiptext = Miniměrować
browser-window-maximize-button =
    .tooltiptext = Maksiměrować
browser-window-restore-down-button =
    .tooltiptext = Pomjeńšić
browser-window-close-button =
    .tooltiptext = Začinić

## WebRTC Pop-up notifications

popup-select-camera =
    .value = Kamera, kotraž ma so hromadźe wužiwać:
    .accesskey = K
popup-select-microphone =
    .value = Mikrofon, kotryž ma so hromadźe wužiwać:
    .accesskey = M
popup-all-windows-shared = Wšě widźomne wokna na wašej wobrazowce budu so dźělić.
popup-screen-sharing-not-now =
    .label = Nic nětko
    .accesskey = c
popup-screen-sharing-never =
    .label = Ženje njedowolić
    .accesskey = e
popup-silence-notifications-checkbox = Zdźělenja w { -brand-short-name } znjemóžnić, mjeztym zo dźěliće
popup-silence-notifications-checkbox-warning = { -brand-short-name } njebudźe zdźělenja pokazować, mjeztym zo dźěliće.

## WebRTC window or screen share tab switch warning

sharing-warning-window = Dźěliće { -brand-short-name }. Druhe wosoby móža widźeć, hdyž k nowemu rajtarkej přeńdźeće.
sharing-warning-screen = Dźěliće swoju cyłu wobrazowku. Druhe wosoby móža widźeć, hdyž k nowemu rajtarkej přeńdźeće.
sharing-warning-proceed-to-tab =
    .label = K rajtarkej postupować
sharing-warning-disable-for-session =
    .label = Dźělenski škit za tute posedźenje znjemóžnić

## DevTools F12 popup

enable-devtools-popup-description = Zo byšće tastu F12 wužiwał, wočińće najprjedy DevTools přez meni Webwuwiwar.

## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = Pytać abo adresu zapodać
# This placeholder is used when not in search mode and the user's default search
# engine is unknown.
urlbar-placeholder =
    .placeholder = Pytać abo adresu zapodać
# This placeholder is used in search mode with search engines that search the
# entire web.
# Variables
#  $name (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-placeholder-search-mode-web-2 =
    .placeholder = Web přepytać
    .aria-label = Z { $name } pytać
# This placeholder is used in search mode with search engines that search a
# specific site (e.g., Amazon).
# Variables
#  $name (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-placeholder-search-mode-other-engine =
    .placeholder = Pytanske wurazy zapodać
    .aria-label = Z { $name } pytać
# This placeholder is used when searching bookmarks.
urlbar-placeholder-search-mode-other-bookmarks =
    .placeholder = Pytanske wurazy zapodać
    .aria-label = Zapołožki přepytać
# This placeholder is used when searching history.
urlbar-placeholder-search-mode-other-history =
    .placeholder = Pytanske wurazy zapodać
    .aria-label = Historiju přepytać
# This placeholder is used when searching open tabs.
urlbar-placeholder-search-mode-other-tabs =
    .placeholder = Pytanske wurazy zapodać
    .aria-label = Rajtarki přepytać
# Variables
#  $name (String): the name of the user's default search engine
urlbar-placeholder-with-name =
    .placeholder = Pytajće z { $name } abo zapodajće adresu
urlbar-remote-control-notification-anchor =
    .tooltiptext = Wobhladowak so zdaloka wodźi
urlbar-permissions-granted =
    .tooltiptext = Sće tutomu websydłu přidatne prawa dał.
urlbar-switch-to-tab =
    .value = K rajtarkej přeńć:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Rozšěrjenje:
urlbar-go-button =
    .tooltiptext = K adresy w adresowym polu
urlbar-page-action-button =
    .tooltiptext = Akcije strony
urlbar-pocket-button =
    .tooltiptext = Pola { -pocket-brand-name } składować

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> je nětko połna wobrazowka
fullscreen-warning-no-domain = Tutón dokument je nětko połna wobrazowka
fullscreen-exit-button = Połnu wobrazowku skónčić (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = Połnu wobrazowku (esc) skónčić
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> ma kontrolu nad wašim pokazowakom. Tłóčće Esc, zo byšće kontrolu wróćo dóstał.
pointerlock-warning-no-domain = Tutón dokument ma kontrolu nad wašim pokazowakom. Tłóčće Esc, zo byšće kontrolu wróćo dóstał.
