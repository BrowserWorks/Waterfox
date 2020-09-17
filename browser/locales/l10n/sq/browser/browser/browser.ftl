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
    .data-title-private = { -brand-full-name } (Shfletim Privat)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (Shfletim Privat)
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
    .data-title-private = { -brand-full-name } - (Shfletim Privat)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (Shfletim Privat)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = Shihni të dhëna sajti

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = Hapni panelin e mesazheve të instalimit
urlbar-web-notification-anchor =
    .tooltiptext = Ndryshoni zgjedhjen për nëse mund të merrni njoftime nga sajti apo jo
urlbar-midi-notification-anchor =
    .tooltiptext = Hapni panel MIDI
urlbar-eme-notification-anchor =
    .tooltiptext = Administroni përdorim software-i DRM
urlbar-web-authn-anchor =
    .tooltiptext = Hap panel Mirëfilltësimesh Web
urlbar-canvas-notification-anchor =
    .tooltiptext = Administroni leje përftimesh nga kanavaca
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = Administroni ndarjen me sajtin të mikrofonit tuaj
urlbar-default-notification-anchor =
    .tooltiptext = Hapni panelin e mesazheve
urlbar-geolocation-notification-anchor =
    .tooltiptext = Hapni panel kërkesash vendndodhjesh
urlbar-xr-notification-anchor =
    .tooltiptext = Hapni panel lejesh për realitet virtual
urlbar-storage-access-anchor =
    .tooltiptext = Hapni panelin e lejeve mbi veprimtari shfletimi
urlbar-translate-notification-anchor =
    .tooltiptext = Përkthejeni këtë faqe
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Administroni ndarjen me sajtin të dritares ose ekranit tuaj
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Hapni panelin për depozitim jashtë linje
urlbar-password-notification-anchor =
    .tooltiptext = Hapni panel mesazhi ruajtje fjalëkalimi
urlbar-translated-notification-anchor =
    .tooltiptext = Administroni përkthim faqeje
urlbar-plugins-notification-anchor =
    .tooltiptext = Administroni përdorim shtojcash
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Administroni ndarjen me sajtin të kamerës dhe/ose mikrofonit tuaj
urlbar-autoplay-notification-anchor =
    .tooltiptext = Hap panel vetëluajtje
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Depozitoni të dhëna në Depozitë të Qëndrueshme
urlbar-addons-notification-anchor =
    .tooltiptext = Hapni kuadratin e mesazhit të instalimit të shtesës
urlbar-tip-help-icon =
    .title = Merrni ndihmë
urlbar-search-tips-confirm = OK, E mora vesh
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = Ndihmëz:

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Shtypni më pak, gjeni më shumë: Kërkoni me { $engineName } drejt e nga shtylla juaj e adresave.
urlbar-search-tips-redirect-2 = Filloni kërkimin tuaj te shtylla e adresave që të shihni sugjerime nga { $engineName } dhe nga historiku juaj i shfletimit.

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = Faqerojtës
urlbar-search-mode-tabs = Skeda
urlbar-search-mode-history = Historik

##

urlbar-geolocation-blocked =
    .tooltiptext = Ia keni bllokuar këtij sajti të dhënat mbi vendndodhjen tuaj.
urlbar-xr-blocked =
    .tooltiptext = E keni bllokuar hyrjen në pajisje realiteti virtual për këtë sajt.
urlbar-web-notifications-blocked =
    .tooltiptext = Ia keni bllokuar këtij sajti njoftimet.
urlbar-camera-blocked =
    .tooltiptext = E keni bllokuar kamerën tuaj për këtë sajt.
urlbar-microphone-blocked =
    .tooltiptext = E keni bllokuar kamerën tuaj për këtë sajt.
urlbar-screen-blocked =
    .tooltiptext = Ia keni bllokuar këtij sajti përdorimin e ekranit tuaj.
urlbar-persistent-storage-blocked =
    .tooltiptext = E keni bllokuar depozitimin e qëndrueshëm për këtë sajt.
urlbar-popup-blocked =
    .tooltiptext = I keni bllokuar flluskat për këtë sajt.
urlbar-autoplay-media-blocked =
    .tooltiptext = E keni bllokuar vetëluajtje mediash me tinguj tuaj për këtë sajt.
urlbar-canvas-blocked =
    .tooltiptext = Për këtë sajt e keni bllokuar përftimin e të dhënave të kanavacës.
urlbar-midi-blocked =
    .tooltiptext = E keni bllokuar hyrjen MIDI për këtë sajt.
urlbar-install-blocked =
    .tooltiptext = Ia keni bllokuar këtij sajti instalimin e shtesave.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = Përpunoni këtë faqerojtës ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = Faqeruani këtë faqe ({ $shortcut })

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = Shtoje te Shtyllë Adresash
page-action-manage-extension =
    .label = Administroni Zgjerime…
page-action-remove-from-urlbar =
    .label = Hiqe nga Shtyllë Adresash
page-action-remove-extension =
    .label = Hiqe Zgjerimin

## Auto-hide Context Menu

full-screen-autohide =
    .label = Fshihi Panelet
    .accesskey = F
full-screen-exit =
    .label = Dilni nga Sa Krejt Ekrani
    .accesskey = D

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of one-click search engines in
# the Urlbar and searchbar.
search-one-offs-with-title = Këtë herë kërko me:
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = Ndryshoni Rregullime Kërkimi
search-one-offs-change-settings-compact-button =
    .tooltiptext = Ndryshoni rregullime kërkimi
search-one-offs-context-open-new-tab =
    .label = Kërkoni në Skedë të Re
    .accesskey = S
search-one-offs-context-set-as-default =
    .label = Caktojeni Si Motor Parazgjedhje Kërkimesh
    .accesskey = P
search-one-offs-context-set-as-default-private =
    .label = Vëre si Motor Kërkimi Parazgjedhje për Dritare Private
    .accesskey = V
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
    .tooltiptext = Faqerojtës ({ $restrict })
search-one-offs-tabs =
    .tooltiptext = Skeda ({ $restrict })
search-one-offs-history =
    .tooltiptext = Historik ({ $restrict })

## Bookmark Panel

bookmark-panel-show-editor-checkbox =
    .label = Shfaqe përpunuesin kur bëhen ruajtje
    .accesskey = S
bookmark-panel-done-button =
    .label = U bë
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

identity-connection-not-secure = Lidhje jo e sigurt
identity-connection-secure = Lidhje e sigurt
identity-connection-internal = Kjo është një faqe { -brand-short-name } e sigurt.
identity-connection-file = Kjo është faqe e depozituar në kompjuterin tuaj.
identity-extension-page = Kjo faqe është ngarkuar nga një zgjerim.
identity-active-blocked = { -brand-short-name }-i ka bllokuar pjesë të kësaj faqeje që s'janë të sigurta.
identity-custom-root = Lidhje e verifikuar nga një lëshues dëshmish që s’njihet nga Mozilla.
identity-passive-loaded = Pjesë të kësaj faqeje (fjala vjen, figura) s'janë të sigurta.
identity-active-loaded = E keni çaktivizuar mbrojtjen për këtë faqe.
identity-weak-encryption = Kjo faqe përdor fshehtëzim të dobët.
identity-insecure-login-forms = Kredencialet e hyrjeve të dhëna në këtë faqe mund të komprometohen.
identity-permissions =
    .value = Leje
identity-permissions-reload-hint = Mund t'ju duhet të ringarkoni faqen që të hyjnë në fuqi ndryshimet.
identity-permissions-empty = S'i keni dhënë këtij sajti ndonjë leje speciale.
identity-clear-site-data =
    .label = Spastroni Cookie-t dhe të Dhëna Sajti…
identity-connection-not-secure-security-view = S'jeni lidhur në mënyrë të siguruar me këtë sajt.
identity-connection-verified = Jeni lidhur në mënyrë të siguruar me këtë sajt.
identity-ev-owner-label = Dëshmi lëshuar për:
identity-description-custom-root = Mozilla nuk e njeh këtë lëshues dëshmish. Mund të jetë shtuar nga sistemi juaj operativ ose nga një përgjegjës. <label data-l10n-name="link">Mësoni Më Tepër</label>
identity-remove-cert-exception =
    .label = Hiqeni Përjashtimin
    .accesskey = H
identity-description-insecure = Lidhja juaj te ky sajt, s'është private. Të dhënat që parashtroni mund të shihen nga të tjerë (fjalëkalime, mesazhe, karta krediti, etj.).
identity-description-insecure-login-forms = Të dhënat e hyrjes që dhatë në këtë faqe s'janë të sigurta dhe mund të komprometohen.
identity-description-weak-cipher-intro = Lidhja juaj te ky sajt përdor fshehtëzim të dobët dhe s'është private.
identity-description-weak-cipher-risk = Të tjerët mund të shohin të dhënat tuaja ose të ndryshojnë sjelljen e sajtit.
identity-description-active-blocked = { -brand-short-name }-i ka bllokuar pjesë të kësaj faqeje që s'janë të sigurta. <label data-l10n-name="link">Mësoni Më Tepër</label>
identity-description-passive-loaded = Lidhja juaj s'është private dhe të dhënat që ndani me të tjerët në këtë saj mund të shihen nga të tjerë.
identity-description-passive-loaded-insecure = Ky sajt përmban lëndë që s'është e sigurt (fjala vjen, figura). <label data-l10n-name="link">Mësoni Më Tepër</label>
identity-description-passive-loaded-mixed = Edhe pse { -brand-short-name }-i ka bllokuar një pjesë të lëndës, në këtë faqe prapë ka lëndë që s'është e sigurt (fjala vjen, figura). <label data-l10n-name="link">Mësoni Më Tepër</label>
identity-description-active-loaded = Ky sajt përmban lëndë që s'është e sigurt (fjala vjen, programthe) dhe lidhja juaj me të s'është private.
identity-description-active-loaded-insecure = Të dhënat që ndani me këtë sajt mund të shihen nga të tjerë (fjala vjen, fjalëkalime, mesazhe, karta krediti, etj.).
identity-learn-more =
    .value = Mësoni Më Tepër
identity-disable-mixed-content-blocking =
    .label = Çaktivizoje mbrojtjen për tani
    .accesskey = Ç
identity-enable-mixed-content-blocking =
    .label = Aktivizo mbrojtjen
    .accesskey = A
identity-more-info-link-text =
    .label = Më Tepër të Dhëna

## Window controls

browser-window-minimize-button =
    .tooltiptext = Minimizojeni
browser-window-maximize-button =
    .tooltiptext = Maksimizoje
browser-window-restore-down-button =
    .tooltiptext = Riktheje Poshtë
browser-window-close-button =
    .tooltiptext = Mbylleni

## WebRTC Pop-up notifications

popup-select-camera =
    .value = Kamerë për ndarje me të tjerët:
    .accesskey = K
popup-select-microphone =
    .value = Mikrofon për ndarje me të tjerët:
    .accesskey = M
popup-all-windows-shared = Do të ndahen me të tjerët krejt dritaret e dukshme në ekranin tuaj.
popup-screen-sharing-not-now =
    .label = Jo Tani
    .accesskey = J
popup-screen-sharing-never =
    .label = Mos e Lejo Kurrë
    .accesskey = K
popup-silence-notifications-checkbox = Çaktivizo njoftime nga { -brand-short-name }-i, ndërkohë që bëhet ndarje me të tjerë
popup-silence-notifications-checkbox-warning = { -brand-short-name }-i s’do të shfaqë njoftime, kur jeni duke ndarë gjëra me të tjerë.

## WebRTC window or screen share tab switch warning

sharing-warning-window = Jeni duke ndarë { -brand-short-name }-in me të tjerë. Persona të tjerë mund ta shohin, kur kaloni te një skedë e re.
sharing-warning-screen = Po ndani me të tjerë krejt ekranin. Persona të tjerë mund ta shohin, kur kaloni te një skedë e re.
sharing-warning-proceed-to-tab =
    .label = Kalo te Skeda
sharing-warning-disable-for-session =
    .label = Çaktivizo mbrojtje ndarjeje për këtë sesion

## DevTools F12 popup

enable-devtools-popup-description = Që të përdorni shkurtoren F12, së pari hapni DevTools që nga menuja Zhvillues Web.

## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = Bëni kërkim ose jepni adresë
# This placeholder is used when not in search mode and the user's default search
# engine is unknown.
urlbar-placeholder =
    .placeholder = Bëni kërkim ose jepni adresë
# This placeholder is used in search mode with search engines that search the
# entire web.
# Variables
#  $name (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-placeholder-search-mode-web-2 =
    .placeholder = Kërkoni në Web
    .aria-label = Kërkoni me { $name }
# This placeholder is used in search mode with search engines that search a
# specific site (e.g., Amazon).
# Variables
#  $name (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-placeholder-search-mode-other-engine =
    .placeholder = Jepni terma kërkimi
    .aria-label = Kërkoni me { $name }
# This placeholder is used when searching bookmarks.
urlbar-placeholder-search-mode-other-bookmarks =
    .placeholder = Jepni terma kërkimi
    .aria-label = Kërko te faqerojtësit
# This placeholder is used when searching history.
urlbar-placeholder-search-mode-other-history =
    .placeholder = Jepni terma kërkimi
    .aria-label = Kërko në historik
# This placeholder is used when searching open tabs.
urlbar-placeholder-search-mode-other-tabs =
    .placeholder = Jepni terma kërkimi
    .aria-label = Kërko në skeda
# Variables
#  $name (String): the name of the user's default search engine
urlbar-placeholder-with-name =
    .placeholder = Kërkoni me { $name } ose jepni adresë
urlbar-remote-control-notification-anchor =
    .tooltiptext = Fshiheni Anështyllën e Faqerojtësve
urlbar-permissions-granted =
    .tooltiptext = I keni akorduar leje shtesë këtij sajti.
urlbar-switch-to-tab =
    .value = Kalo te skeda:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Zgjerim:
urlbar-go-button =
    .tooltiptext = Shkoni te adresa e dhënë te Shtylla e Vendndodhjeve
urlbar-page-action-button =
    .tooltiptext = Veprime faqeje
urlbar-pocket-button =
    .tooltiptext = Ruajeni te { -pocket-brand-name }

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> tani është sa krejt ekrani
fullscreen-warning-no-domain = Ky dokument tani shfaqet sa krejt ekrani
fullscreen-exit-button = Dilni nga Sa Krejt Ekrani (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = Dilni Nga Sa Krejt Ekrani (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> është në kontroll të kursorit tuaj. Shtypni Esc që të rimerrni kontrollin.
pointerlock-warning-no-domain = Kursori është nën kontrollin e kursorit tuaj. Shtypni Esc që të rimerrni kontrollin.
