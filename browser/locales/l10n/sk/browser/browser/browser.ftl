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
    .data-title-private = { -brand-full-name } (Súkromné prehliadanie)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (Súkromné prehliadanie)
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
    .data-title-private = { -brand-full-name } - (Súkromné prehliadanie)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (Súkromné prehliadanie)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = Zobraziť informácie o stránke

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = Otvoriť inštalačný panel správ
urlbar-web-notification-anchor =
    .tooltiptext = Zmení, či môžete zo stránky prijímať upozornenia
urlbar-midi-notification-anchor =
    .tooltiptext = Otvoriť MIDI panel
urlbar-eme-notification-anchor =
    .tooltiptext = Spravovať používanie softvéru DRM
urlbar-web-authn-anchor =
    .tooltiptext = Otvorí kartu webovej autentifikácie
urlbar-canvas-notification-anchor =
    .tooltiptext = Správa povolení prístupu k informáciám canvasu
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = Spravovať zdieľanie mikrofónu so stránkou
urlbar-default-notification-anchor =
    .tooltiptext = Otvorí panel správ
urlbar-geolocation-notification-anchor =
    .tooltiptext = Otvorí panel so žiadosťou o polohu
urlbar-xr-notification-anchor =
    .tooltiptext = Otvorí panel povolení pre virtuálnu realitu
urlbar-storage-access-anchor =
    .tooltiptext = Otvorí nastavenia prístupu k informáciám o vašom prehliadaní
urlbar-translate-notification-anchor =
    .tooltiptext = Preloží túto stránku
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Spravovať zdieľanie vašich okien alebo obrazovky so stránkou
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Otvorí panel správ offline úložiska
urlbar-password-notification-anchor =
    .tooltiptext = Otvorí panel správ uloženia hesla
urlbar-translated-notification-anchor =
    .tooltiptext = Spravovať preklad stránky
urlbar-plugins-notification-anchor =
    .tooltiptext = Správa používania zásuvných modulov
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Spravovať zdieľanie webkamery a/alebo mikrofónu so stránkou
urlbar-autoplay-notification-anchor =
    .tooltiptext = Otvorí panel automatického prehrávania
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Uloží údaje do trvalého úložiska
urlbar-addons-notification-anchor =
    .tooltiptext = Otvorí panel správ inštalácie doplnkov
urlbar-tip-help-icon =
    .title = Získať pomoc
urlbar-search-tips-confirm = Ok, rozumiem
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = Tip:

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Menej písania, viac výsledkov. Používajte { $engineName } priamo z vášho panela s adresou.
urlbar-search-tips-redirect-2 = Zadajte sem výraz vyhľadávania a uvidíte návrhy z vyhľadávacieho modulu { $engineName } a z vašej histórie prehliadania.

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = Záložky

##

urlbar-geolocation-blocked =
    .tooltiptext = Tejto stránke ste zakázali zisťovať vašu polohu.
urlbar-xr-blocked =
    .tooltiptext = Tejto stránke ste zakázali prístup k zariadeniam pre virtuálnu realitu.
urlbar-web-notifications-blocked =
    .tooltiptext = Tejto stránke ste zakázali zobrazovať upozornenia.
urlbar-camera-blocked =
    .tooltiptext = Tejto stránke ste zakázali prístup k vašej kamere.
urlbar-microphone-blocked =
    .tooltiptext = Tejto stránke ste zakázali prístup v vášmu mikrofónu.
urlbar-screen-blocked =
    .tooltiptext = Tejto stránke ste zakázali zdieľanie vašej obrazovky.
urlbar-persistent-storage-blocked =
    .tooltiptext = Tejto stránke ste zakázali ukladanie údajov do trvalého úložiska.
urlbar-popup-blocked =
    .tooltiptext = Tejto stránke ste zablokovali zobrazovanie vyskakovacích okien.
urlbar-autoplay-media-blocked =
    .tooltiptext = Tejto stránke ste zablokovali automatické prehrávania médií so zvukom.
urlbar-canvas-blocked =
    .tooltiptext = Tejto stránke ste zakázali prístup k údajom canvasu.
urlbar-midi-blocked =
    .tooltiptext = Tejto stránke ste zakázali prístup k MIDI.
urlbar-install-blocked =
    .tooltiptext = Tejto stránke ste zakázali inštaláciu doplnkov.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = Umožní upraviť túto záložku ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = Pridá stránku medzi záložky ({ $shortcut })

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = Pridať do panela s adresou
page-action-manage-extension =
    .label = Správa rozšírenia…
page-action-remove-from-urlbar =
    .label = Odstrániť z panela s adresou
page-action-remove-extension =
    .label = Odstrániť rozšírenie

## Auto-hide Context Menu

full-screen-autohide =
    .label = Skryť panely s nástrojmi
    .accesskey = k
full-screen-exit =
    .label = Ukončiť režim celej obrazovky
    .accesskey = U

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of one-click search engines in
# the Urlbar and searchbar.
search-one-offs-with-title = Vyhľadať pomocou:
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = Zmeniť nastavenia vyhľadávania
search-one-offs-change-settings-compact-button =
    .tooltiptext = Zmeniť nastavenia vyhľadávania
search-one-offs-context-open-new-tab =
    .label = Vyhľadať na novej karte
    .accesskey = h
search-one-offs-context-set-as-default =
    .label = Nastaviť ako predvolený vyhľadávací modul
    .accesskey = N
search-one-offs-context-set-as-default-private =
    .label = Nastaviť ako predvolený vyhľadávací modul pre súkromné prehliadanie
    .accesskey = o
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


## Bookmark Panel

bookmark-panel-show-editor-checkbox =
    .label = Pri ukladaní zobrazovať editor
    .accesskey = u
bookmark-panel-done-button =
    .label = Hotovo
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

identity-connection-not-secure = Pripojenie nie je zabezpečené
identity-connection-secure = Pripojenie je zabezpečené
identity-connection-internal = Toto je bezpečná stránka prehliadača { -brand-short-name }
identity-connection-file = Táto stránka je uložená vo vašom počítači.
identity-extension-page = Táto stránka je načítaná z doplnku.
identity-active-blocked = { -brand-short-name } zablokoval nezabezpečené časti tejto stránky.
identity-custom-root = Pripojenie je overené vydavateľom certifikátov, ktorého Mozilla nepozná.
identity-passive-loaded = Časti tejto stránky nie sú zabezpečené (napr. obrázky).
identity-active-loaded = Na tejto stránke ste vypli Ochranu pred sledovaním.
identity-weak-encryption = Táto stránka používa slabé šifrovanie.
identity-insecure-login-forms = Prihlasovacie údaje zadané na tejto stránke by mohli byť ohrozené.
identity-permissions =
    .value = Povolenia
identity-permissions-reload-hint = Pre vykonanie zmien budete možno musieť stránku obnoviť.
identity-permissions-empty = Tejto stránke ste neurčili žiadne špeciálne povolenia.
identity-clear-site-data =
    .label = Vymazať cookies a údaje stránok…
identity-connection-not-secure-security-view = Pripojenie k tejto stránke nie je zabezpečené.
identity-connection-verified = Pripojenie k tejto stránke je zabezpečené.
identity-ev-owner-label = Certifikát bol vydaný pre:
identity-description-custom-root = Mozilla tohto vydavateľa certifikátov nepozná. Mohol byť pridaný operačným systémom alebo správcom vášho počítača. <label data-l10n-name="link">Ďalšie informácie</label>
identity-remove-cert-exception =
    .label = Odstrániť výnimku
    .accesskey = d
identity-description-insecure = Pripojenie k tejto stránke nie je súkromné. Zadané informácie (ako heslá, správy, informácie o platobných kartách, atď.) môžu byť viditeľné pre iných ľudí.
identity-description-insecure-login-forms = Prihlasovacie údaje zadané na tejto stránke nie sú chránené a môžu byť zneužité.
identity-description-weak-cipher-intro = Pripojenie k tejto webovej stránke používa slabé zabezpečenie a nie je súkromné.
identity-description-weak-cipher-risk = Iní ľudia môžu zobraziť vaše údaje alebo zmeniť správanie stránky.
identity-description-active-blocked = { -brand-short-name } zablokoval nezabezpečené časti tejto stránky. <label data-l10n-name="link">Ďalšie informácie</label>
identity-description-passive-loaded = Vaše pripojenie nie je súkromné a informácie, ktoré zadáte na stránke, môžu byť viditeľné pre iných ľudí.
identity-description-passive-loaded-insecure = Táto stránka obsahuje súčasti, ktoré nie sú bezpečné (ako napr. obrázky). <label data-l10n-name="link">Ďalšie informácie</label>
identity-description-passive-loaded-mixed = Hoci { -brand-short-name } zablokoval niektoré súčasti, stále je na stránke dostupný obsah, ktorý nie je bezpečný (ako napr. obrázky). <label data-l10n-name="link">Ďalšie informácie</label>
identity-description-active-loaded = Táto stránka obsahuje súčasti, ktoré nie sú bezpečné (ako napr. skripty) a vaše pripojenie k nej nie je súkromné.
identity-description-active-loaded-insecure = Informácie zadané na tejto stránke (ako heslá, správy, informácie o platobných kartách, atď.) môžu byť viditeľné pre iných ľudí.
identity-learn-more =
    .value = Ďalšie informácie
identity-disable-mixed-content-blocking =
    .label = Zakázať ochranu
    .accesskey = Z
identity-enable-mixed-content-blocking =
    .label = Povoliť ochranu
    .accesskey = P
identity-more-info-link-text =
    .label = Ďalšie informácie

## Window controls

browser-window-minimize-button =
    .tooltiptext = Minimalizovať okno
browser-window-maximize-button =
    .tooltiptext = Maximalizovať
browser-window-close-button =
    .tooltiptext = Zavrieť

## WebRTC Pop-up notifications

popup-select-camera =
    .value = Zdieľať kameru:
    .accesskey = k
popup-select-microphone =
    .value = Zdieľať mikrofón:
    .accesskey = m
popup-all-windows-shared = Všetky okná viditeľné na vašej obrazovke budú zdieľané.
popup-screen-sharing-not-now =
    .label = Teraz nie
    .accesskey = n
popup-screen-sharing-never =
    .label = Nikdy nepovoliť
    .accesskey = i
popup-silence-notifications-checkbox = Nezobrazovať upozornenia z { -brand-short-name(case: "gen") } počas zdieľania
popup-silence-notifications-checkbox-warning = { -brand-short-name } nebude počas zdieľania zobrazovať upozornenia.

## WebRTC window or screen share tab switch warning

sharing-warning-window = Zdieľate { -brand-short-name }. Ostatní ľudia uvidia obsah každej karty, ktorú otvoríte.
sharing-warning-screen = Zdieľate celú svoju obrazovku. Ostatní ľudia uvidia obsah každej karty, ktorú otvoríte.
sharing-warning-proceed-to-tab =
    .label = Prejsť na kartu
sharing-warning-disable-for-session =
    .label = Vypnúť ochranu zdieľania pre túto reláciu

## DevTools F12 popup

enable-devtools-popup-description = Ak chcete použiť skratku F12, najprv otvorte DevTools prostredníctvom ponuky Webový vývojár.

## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = Zadajte adresu alebo výraz vyhľadávania
# This placeholder is used when not in search mode and the user's default search
# engine is unknown.
urlbar-placeholder =
    .placeholder = Zadajte adresu alebo výraz vyhľadávania
# Variables
#  $name (String): the name of the user's default search engine
urlbar-placeholder-with-name =
    .placeholder = Vyhľadajte cez { $name } alebo zadajte webovú adresu
urlbar-remote-control-notification-anchor =
    .tooltiptext = Prehliadač je ovládaný na diaľku
urlbar-permissions-granted =
    .tooltiptext = Tejto stránke ste udelili dodatočné povolenia.
urlbar-switch-to-tab =
    .value = Prejsť na kartu:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Rozšírenie:
urlbar-go-button =
    .tooltiptext = Prejsť na adresu zadanú v paneli s adresou
urlbar-page-action-button =
    .tooltiptext = Akcie stránky
urlbar-pocket-button =
    .tooltiptext = Uložiť do { -pocket-brand-name }u

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> je teraz v režime celej obrazovky
fullscreen-warning-no-domain = Tento dokument je teraz v režime celej obrazovky
fullscreen-exit-button = Ukončiť režim celej obrazovky (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = Ukončiť režim celej obrazovky (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> má kontrolu nad vaším kurzorom. Ovládanie kurzora prevezmete stlačením klávesu Esc.
pointerlock-warning-no-domain = Tento dokument má kontrolu nad vaším kurzorom. Ovládanie kurzora prevezmete stlačením klávesu Esc.
