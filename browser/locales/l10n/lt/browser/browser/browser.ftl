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
    .data-title-private = { -brand-full-name } (privatusis naršymas)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (privatusis naršymas)
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
    .data-title-private = { -brand-full-name } - (privatusis naršymas)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (privatusis naršymas)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = Peržiūrėti svetainės informaciją

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = Atverti diegimo pranešimo skydelį
urlbar-web-notification-anchor =
    .tooltiptext = Pasirinkite, ar norite gauti pranešimus iš šios svetainės
urlbar-midi-notification-anchor =
    .tooltiptext = Atverti MIDI polangį
urlbar-eme-notification-anchor =
    .tooltiptext = Tvarkyti DRM programinės įrangos naudojimą
urlbar-web-authn-anchor =
    .tooltiptext = Atverti „Web Authentication“ polangį
urlbar-canvas-notification-anchor =
    .tooltiptext = Valdyti drobės išgavimo leidimą
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = Tvarkyti mikrofono naudojimą svetainėje
urlbar-default-notification-anchor =
    .tooltiptext = Atverti pranešimo skydelį
urlbar-geolocation-notification-anchor =
    .tooltiptext = Atverti buvimo vietos nustatymo skydelį
urlbar-xr-notification-anchor =
    .tooltiptext = Atverti virtualios realybės leidimų polangį
urlbar-storage-access-anchor =
    .tooltiptext = Atverti naršymo veiklos leidimų polangį
urlbar-translate-notification-anchor =
    .tooltiptext = Išversti šį tinklalapį
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Tvarkyti langų ar viso ekrano bendrinimą su svetaine
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Atverti duomenų darbui neprisijungus pranešimo skydelį
urlbar-password-notification-anchor =
    .tooltiptext = Atverti slaptažodžio įrašymo pranešimo skydelį
urlbar-translated-notification-anchor =
    .tooltiptext = Tvarkyti tinklalapio vertimą
urlbar-plugins-notification-anchor =
    .tooltiptext = Valdyti papildinių naudojimą
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Tvarkyti kameros ir mikrofono naudojimą svetainėje
urlbar-autoplay-notification-anchor =
    .tooltiptext = Atverti automatinio grojimo polangį
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Saugoti duomenis išliekančioje atmintyje
urlbar-addons-notification-anchor =
    .tooltiptext = Atverti priedo diegimo pranešimo skydelį
urlbar-tip-help-icon =
    .title = Žinynas ir pagalba
urlbar-search-tips-confirm = Gerai, supratau
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = Patarimas:

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Rašykite mažiau, raskite daugiau: ieškokite per „{ $engineName }“ tiesiai iš savo adreso lauko.
urlbar-search-tips-redirect-2 = Pradėkite savo paiešką adreso lauke, norėdami matyti žodžių siūlymus iš „{ $engineName }“ bei jūsų naršymo istorijos.

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = Adresynas
urlbar-search-mode-tabs = Kortelės
urlbar-search-mode-history = Žurnalas

##

urlbar-geolocation-blocked =
    .tooltiptext = Šioje svetainėje esate užblokavę buvimo vietos informaciją.
urlbar-xr-blocked =
    .tooltiptext = Šioje svetainėje esate užblokavę virtualios realybes įrenginių naudojimą.
urlbar-web-notifications-blocked =
    .tooltiptext = Šioje svetainėje esate užblokavę pranešimus.
urlbar-camera-blocked =
    .tooltiptext = Šioje svetainėje esate užblokavę savo kamerą.
urlbar-microphone-blocked =
    .tooltiptext = Šioje svetainėje esate užblokavę savo mikrofoną.
urlbar-screen-blocked =
    .tooltiptext = Šiai svetainei neleidžiate dalintis ekrano vaizdu.
urlbar-persistent-storage-blocked =
    .tooltiptext = Šioje svetainėje esate užblokavę išliekančių duomenų saugojimą.
urlbar-popup-blocked =
    .tooltiptext = Šioje svetainėje esate užblokavę iškylančiuosius langus.
urlbar-autoplay-media-blocked =
    .tooltiptext = Šioje svetainėje esate užblokavę automatinį medijos grojimą.
urlbar-canvas-blocked =
    .tooltiptext = Šioje svetainėje esate užblokavę drobės duomenų išgavimą.
urlbar-midi-blocked =
    .tooltiptext = Šioje svetainėje esate užblokavę MIDI naudojimą.
urlbar-install-blocked =
    .tooltiptext = Šioje svetainėje esate užblokavę priedų diegimą.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = Taisyti šį adresyno įrašą ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = Įtraukti šį tinklalapį į adresyną ({ $shortcut })

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = Pridėti į adreso lauką
page-action-manage-extension =
    .label = Tvarkyti priedą…
page-action-remove-from-urlbar =
    .label = Pašalinti iš adreso lauko
page-action-remove-extension =
    .label = Pašalinti priedą

## Auto-hide Context Menu

full-screen-autohide =
    .label = Slėpti priemonių juostas
    .accesskey = S
full-screen-exit =
    .label = Grįžti iš viso ekrano veiksenos
    .accesskey = v

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of one-click search engines in
# the Urlbar and searchbar.
search-one-offs-with-title = Šįkart ieškokite su:
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = Keisti paieškos nuostatas
search-one-offs-change-settings-compact-button =
    .tooltiptext = Keisti paieškos nuostatas
search-one-offs-context-open-new-tab =
    .label = Ieškoti naujoje kortelėje
    .accesskey = k
search-one-offs-context-set-as-default =
    .label = Laikyti numatytąja ieškykle
    .accesskey = m
search-one-offs-context-set-as-default-private =
    .label = Skirti numatytąja ieškykle privačiojo naršymo langams
    .accesskey = p
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
    .tooltiptext = Adresynas ({ $restrict })
search-one-offs-tabs =
    .tooltiptext = Kortelės ({ $restrict })
search-one-offs-history =
    .tooltiptext = Žurnalas ({ $restrict })

## Bookmark Panel

bookmark-panel-show-editor-checkbox =
    .label = Rodyti redagavimo formą įrašant
    .accesskey = R
bookmark-panel-done-button =
    .label = Atlikta
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

identity-connection-not-secure = Ryšys nesaugus
identity-connection-secure = Ryšys saugus
identity-connection-internal = Tai yra saugus „{ -brand-short-name }“ tinklalapis.
identity-connection-file = Šis tinklalapis yra įrašytas jūsų kompiuteryje.
identity-extension-page = Šis tinklalapis yra įkeltas iš priedo.
identity-active-blocked = „{ -brand-short-name }“ užblokavo nesaugias šio tinklalapio dalis.
identity-custom-root = Ryšį patvirtino liudijimo išdavėjas, kurio „Mozilla“ neatpažino.
identity-passive-loaded = Kai kurios šio tinklalapio dalys nėra saugios (pvz., paveikslai).
identity-active-loaded = Šiame tinklalapyje esate išjungę apsaugą.
identity-weak-encryption = Šis tinklalapis naudoja silpną šifravimą.
identity-insecure-login-forms = Šiame tinklalapyje įvesti prisijungimo duomenys gali būti perimti.
identity-permissions =
    .value = Leidimai
identity-permissions-reload-hint = Kad būtų pritaikyti pakeitimai, tinklalapį galimai reikia atsiųsti iš naujo.
identity-permissions-empty = Šiai svetainei nesate suteikę jokių ypatingų leidimų.
identity-clear-site-data =
    .label = Valyti slapukus ir svetainių duomenis…
identity-connection-not-secure-security-view = Nesate saugiai prisijungę prie šios svetainės.
identity-connection-verified = Esate saugiai prisijungę prie šios svetainės.
identity-ev-owner-label = Kam išduotas liudijimas:
identity-description-custom-root = „Mozilla“ neatpažįsta šio liudijimo išdavėjo. Jis galėjo būti pridėtas iš jūsų operacinės sistemos, arba administratoriaus. <label data-l10n-name="link">Sužinoti daugiau</label>
identity-remove-cert-exception =
    .label = Panaikinti išimtį
    .accesskey = n
identity-description-insecure = Jūsų ryšys su šia svetaine nėra privatus. Jūsų pateikta informacija gali būti peržiūrėta kitų (pvz., slaptažodžiai, žinutės, banko kortelės, kita).
identity-description-insecure-login-forms = Šiame tinklalapyje jūsų įvesti prisijungimo duomenys nebus saugūs ir gali būti perimti.
identity-description-weak-cipher-intro = Jūsų ryšys su šia svetaine naudoja silpną šifravimą ir nėra privatus.
identity-description-weak-cipher-risk = Pašaliniai asmenys gali matyti jūsų duomenis ar keisti svetainės elgseną.
identity-description-active-blocked = „{ -brand-short-name }“ užblokavo nesaugias šio tinklalapio dalis. <label data-l10n-name="link">Sužinoti daugiau</label>
identity-description-passive-loaded = Jūsų ryšys nėra privatus, tad šiai svetainei pateikta informacija gali būti peržiūrėta kitų.
identity-description-passive-loaded-insecure = Šioje svetainėje yra nesaugaus turinio (pvz., paveikslų). <label data-l10n-name="link">Sužinoti daugiau</label>
identity-description-passive-loaded-mixed = Nors „{ -brand-short-name }“ užblokavo dalį turinio, šiame tinklalapyje vis dar yra nesaugaus turinio (pvz., paveikslų). <label data-l10n-name="link">Sužinoti daugiau</label>
identity-description-active-loaded = Šioje svetainėje yra nesaugaus turinio (pvz., scenarijų), be to, jūsų ryšys su ja nėra privatus.
identity-description-active-loaded-insecure = Šiai svetainei pateikta informacija gali būti peržiūrėta kitų (pvz., slaptažodžiai, žinutės, banko kortelės, kita).
identity-learn-more =
    .value = Sužinoti daugiau
identity-disable-mixed-content-blocking =
    .label = Laikinai išjungti apsaugą
    .accesskey = L
identity-enable-mixed-content-blocking =
    .label = Įjungti apsaugą
    .accesskey = Į
identity-more-info-link-text =
    .label = Daugiau informacijos

## Window controls

browser-window-minimize-button =
    .tooltiptext = Suskleisti
browser-window-maximize-button =
    .tooltiptext = Išdidinti
browser-window-restore-down-button =
    .tooltiptext = Sumažinti
browser-window-close-button =
    .tooltiptext = Užverti

## WebRTC Pop-up notifications

popup-select-camera =
    .value = Kamera, kurią leisite pasiekti:
    .accesskey = K
popup-select-microphone =
    .value = Mikrofonas, kurį leisite pasiekti:
    .accesskey = M
popup-all-windows-shared = Bus leidžiama matyti visus jūsų ekrane matomus langus.
popup-screen-sharing-not-now =
    .label = Ne dabar
    .accesskey = b
popup-screen-sharing-never =
    .label = Niekada neleisti
    .accesskey = N
popup-silence-notifications-checkbox = Išjungti „{ -brand-short-name }“ pranešimus dalinantis
popup-silence-notifications-checkbox-warning = „{ -brand-short-name }“ nerodys pranešimų, kai jūs dalinatės.

## WebRTC window or screen share tab switch warning

sharing-warning-window = Jūs dalinatės „{ -brand-short-name }“ vaizdu. Kiti žmonės gali matyti, kai pereisite į kitą kortelę.
sharing-warning-screen = Jūs dalinatės viso ekrano vaizdu. Kiti žmonės gali matyti, kai pereisite į kitą kortelę.
sharing-warning-proceed-to-tab =
    .label = Atverti kortelę
sharing-warning-disable-for-session =
    .label = Išjungti dalinimosi apsaugą šiam seansui

## DevTools F12 popup

enable-devtools-popup-description = Norėdami naudoti spartųjį klavišą „F12“, pirma atverkite saityno kūrėjų priemones iš meniu „Saityno kūrėjams“.

## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = Įveskite adresą arba paieškos žodžius
# This placeholder is used when not in search mode and the user's default search
# engine is unknown.
urlbar-placeholder =
    .placeholder = Įveskite adresą arba paieškos žodžius
# This placeholder is used in search mode with search engines that search the
# entire web.
# Variables
#  $name (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-placeholder-search-mode-web-2 =
    .placeholder = Ieškokite saityne
    .aria-label = Ieškoti per „{ $name }“
# This placeholder is used in search mode with search engines that search a
# specific site (e.g., Amazon).
# Variables
#  $name (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-placeholder-search-mode-other-engine =
    .placeholder = Įveskite ieškomą tekstą
    .aria-label = Ieškoti per „{ $name }“
# This placeholder is used when searching bookmarks.
urlbar-placeholder-search-mode-other-bookmarks =
    .placeholder = Įveskite ieškomą tekstą
    .aria-label = Ieškoti adresyne
# This placeholder is used when searching history.
urlbar-placeholder-search-mode-other-history =
    .placeholder = Įveskite ieškomą tekstą
    .aria-label = Ieškoti žurnale
# This placeholder is used when searching open tabs.
urlbar-placeholder-search-mode-other-tabs =
    .placeholder = Įveskite ieškomą tekstą
    .aria-label = Ieškote kortelėse
# Variables
#  $name (String): the name of the user's default search engine
urlbar-placeholder-with-name =
    .placeholder = Ieškokite per „{ $name }“ arba įveskite adresą
urlbar-remote-control-notification-anchor =
    .tooltiptext = Naršyklė valdoma per nuotolį
urlbar-permissions-granted =
    .tooltiptext = Šiai svetainei esate suteikę papildomų leidimų.
urlbar-switch-to-tab =
    .value = Pereiti į kortelę:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Priedas:
urlbar-go-button =
    .tooltiptext = Eiti į adreso lauke surinktą adresą
urlbar-page-action-button =
    .tooltiptext = Tinklalapio veiksmai
urlbar-pocket-button =
    .tooltiptext = Įrašyti į „{ -pocket-brand-name }“

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> dabar yra visame ekrane
fullscreen-warning-no-domain = Šis dokumentas dabar yra visame ekrane
fullscreen-exit-button = Grįžti iš viso ekrano (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = Grįžti iš viso ekrano (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> valdo jūsų žymeklį. Spustelėkite Esc, norėdami atgauti valdymą.
pointerlock-warning-no-domain = Šis dokumentas valdo jūsų žymeklį. Spustelėkite Esc, norėdami atgauti valdymą.
