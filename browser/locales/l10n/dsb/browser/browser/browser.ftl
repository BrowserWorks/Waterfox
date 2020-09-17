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
    .aria-label = Sedłowe informacije se woglědaś

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = Wobceŕk instalaciskeje powěźeńki wócyniś
urlbar-web-notification-anchor =
    .tooltiptext = Změńśo, lěc móžośo powěźeńki wót sedła dostaś
urlbar-midi-notification-anchor =
    .tooltiptext = MIDI-wobceŕk wócyniś
urlbar-eme-notification-anchor =
    .tooltiptext = Wužywanje softwary DRM zastojaś
urlbar-web-authn-anchor =
    .tooltiptext = Wobceŕk webawtentifikacije wócyniś
urlbar-canvas-notification-anchor =
    .tooltiptext = Pšawo za ekstrahěrowanje canvas zastojaś
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = Źělenje wašogo mikrofona ze sedłom zastojaś
urlbar-default-notification-anchor =
    .tooltiptext = Wobceŕk powěsćow wócyniś
urlbar-geolocation-notification-anchor =
    .tooltiptext = Wobceŕk městnowego napšašowanja wócyniś
urlbar-xr-notification-anchor =
    .tooltiptext = Dialog za pšawa wirtuelneje reality wócyniś
urlbar-storage-access-anchor =
    .tooltiptext = Dialog za pšawa pśeglědowańskeje aktiwity wócyniś
urlbar-translate-notification-anchor =
    .tooltiptext = Toś ten bok pśełožowaś
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Źělenje wašych woknow abo wašeje wobrazowki ze sedłom zastojaś
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Wobceŕk powěźeńki składowanja offline wócyniś
urlbar-password-notification-anchor =
    .tooltiptext = Wobceŕk powěźeńki składowanja gronidła wócyniś
urlbar-translated-notification-anchor =
    .tooltiptext = Pśełožowanje boka zastojaś
urlbar-plugins-notification-anchor =
    .tooltiptext = Wužywanje tykacow zastojaś
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Źělenje wašeje kamery a/abo wašogo mikrofona ze sedłom zastojaś
urlbar-autoplay-notification-anchor =
    .tooltiptext = Wobceŕk za awtomatiske wótgraśe wócyniś
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Daty w trajnem składowaku składowaś
urlbar-addons-notification-anchor =
    .tooltiptext = Wobceŕk powěźeńki dodankoweje instalacije wócyniś
urlbar-tip-help-icon =
    .title = Pomoc se wobstaraś
urlbar-search-tips-confirm = W pórěźe, som zrozměł
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = Tip:

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Pišćo mjenjej, namakajśo wěcej: Pytajśo z { $engineName } direktnje ze swójogo adresowego póla.
urlbar-search-tips-redirect-2 = Zachopśo swójo pytanje w adresowem pólu, aby naraźenja wót { $engineName } a ze swójeje pśeglědowańskeje historije wiźeł.

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = Cytańske znamjenja
urlbar-search-mode-tabs = Rejtariki
urlbar-search-mode-history = Historija

##

urlbar-geolocation-blocked =
    .tooltiptext = Sćo toś tomu websedłoju informacijie wó městnje zawoborał.
urlbar-xr-blocked =
    .tooltiptext = Sćo zablokěrował pśistup k rědoju wirtuelneje reality za toś to websedło.
urlbar-web-notifications-blocked =
    .tooltiptext = Sćo powěźeńki za toś to websedło zablokěrował.
urlbar-camera-blocked =
    .tooltiptext = Sćo swóju kameru za toś to websedło zablokěrował.
urlbar-microphone-blocked =
    .tooltiptext = Sćo swój mikrofon za toś to websedło zablokěrował.
urlbar-screen-blocked =
    .tooltiptext = Sćo toś tomu websedłoju źělenje swójeje wobrazowki zakazał.
urlbar-persistent-storage-blocked =
    .tooltiptext = Sćo trajny składowak za toś to websedło blokěrował.
urlbar-popup-blocked =
    .tooltiptext = Sćo wuskokujuce wokna za toś to websedło blokěrował.
urlbar-autoplay-media-blocked =
    .tooltiptext = Sćo zablokěrował awtomatiske wótgraśe medijow ze zukom za toś to websedło.
urlbar-canvas-blocked =
    .tooltiptext = Sćo blokěrował pśistup ku canvasowym datam za toś to websedło.
urlbar-midi-blocked =
    .tooltiptext = Sćo blokěrował pśistup k MIDI za toś to websedło.
urlbar-install-blocked =
    .tooltiptext = Sćo blokěrował instalěrowanje dodankow za toś to websedło.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = Toś to cytańske znamje ({ $shortcut }) wobźěłaś
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = Toś ten bok ({ $shortcut }) ako cytańske znamje składowaś

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = Adresowemu póloju pśidaś
page-action-manage-extension =
    .label = Rozšyrjenje zastojaś…
page-action-remove-from-urlbar =
    .label = Z adresowego póla wótwónoźeś
page-action-remove-extension =
    .label = Rozšyrjenje wótwónoźeś

## Auto-hide Context Menu

full-screen-autohide =
    .label = Symbolowe rědki schowaś
    .accesskey = b
full-screen-exit =
    .label = Modus połneje wobrazowki spušćiś
    .accesskey = M

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of one-click search engines in
# the Urlbar and searchbar.
search-one-offs-with-title = Něnto pytaś z:
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = Pytańske nastajenja
search-one-offs-change-settings-compact-button =
    .tooltiptext = Pytańske nastajenja změniś
search-one-offs-context-open-new-tab =
    .label = W nowem rejtariku pytaś
    .accesskey = r
search-one-offs-context-set-as-default =
    .label = Ako standardnu pytnicu nastajiś
    .accesskey = d
search-one-offs-context-set-as-default-private =
    .label = Ako standardnu pytnicu za priwatne wokna nastajiś
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
    .tooltiptext = Cytańske znamjenja ({ $restrict })
search-one-offs-tabs =
    .tooltiptext = Rejariki ({ $restrict })
search-one-offs-history =
    .tooltiptext = Historija ({ $restrict })

## Bookmark Panel

bookmark-panel-show-editor-checkbox =
    .label = Editor pśi składowanju pokazaś
    .accesskey = E
bookmark-panel-done-button =
    .label = Dokóńcony
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

identity-connection-not-secure = Zwisk njejo wěsty
identity-connection-secure = Zwisk jo wěsty
identity-connection-internal = To jo wěsty bok { -brand-short-name }.
identity-connection-file = Toś ten bok jo se na wašom licadle składł.
identity-extension-page = Toś ten bok jo se z rozšyrjenja zacytał.
identity-active-blocked = { -brand-short-name } jo źěle toś togo boka blokěrował, kótarež njejsu wěste.
identity-custom-root = Zwisk jo se pśeglědował pśez certifikatowego wudawarja, kótaryž njejo pśipóznaty wót Mozilla.
identity-passive-loaded = Źěle toś togo boka njejsu wěste (na pśikład wobraze).
identity-active-loaded = Sćo šćit na toś tom boku znjemóžnił.
identity-weak-encryption = Toś ten bok wužywa słabe koděrowanje.
identity-insecure-login-forms = Pśizjawjenja, kótarež zapódawaju se na toś tom boku, by mógli wobgrozone byś.
identity-permissions =
    .value = Pšawa
identity-permissions-reload-hint = Musyśo snaź bok znowego zacytaś, aby se změny wustatkowali.
identity-permissions-empty = Njejsćo toś tomu sedłoju wósebne pšawa pśizwólił.
identity-clear-site-data =
    .label = Cookieje a sedłowe daty wulašowaś…
identity-connection-not-secure-security-view = Njejsćo wěsće zwězany z toś tym sedłom.
identity-connection-verified = Sćo wěsće zwězany z toś tym sedłom.
identity-ev-owner-label = Certifikat wudany na:
identity-description-custom-root = Mozilla toś togo certifikatowego wudawarja njepśipóznawa. Jo se snaź pśidał pśez waš źěłowy system abo wót administratora. <label data-l10n-name="link">Dalšne informacije</label>
identity-remove-cert-exception =
    .label = Wuwześe wótpóraś
    .accesskey = W
identity-description-insecure = Waš zwisk z toś tym sedłom njejo priwatny. Druge luźe by mógli Informacije wiźeś, kótarež sćelośo (na pśikład gronidła, powěsći, kreditne kórty atd.).
identity-description-insecure-login-forms = Pśizjawjeńske informacije, kótarež zapódawaśo na toś tom boku, njejsu wěste a by mógli se wobgrozyś.
identity-description-weak-cipher-intro = Waš zwisk z websedłom wužywa słabe koděrowanje a njejo priwatny.
identity-description-weak-cipher-risk = Druge luźe mógu se waše informacije woglědaś abo zaźaržanje websedła změniś.
identity-description-active-blocked = { -brand-short-name } jo źěle toś togo boka blokěrował, kótarež njejsu wěste. <label data-l10n-name="link">Dalšne informacije</label>
identity-description-passive-loaded = Waš zwisk njejo priwatny a druge mógli informacije wiźeś, kótarež źěliśo ze sedłom.
identity-description-passive-loaded-insecure = Websedło wopśimujo wopśimjeśe, kótarež njejo wěste (ako na pśikład wobraze). <label data-l10n-name="link">Dalšne informacije</label>
identity-description-passive-loaded-mixed = Lěcrownož { -brand-short-name } jo wopśimjeśe blokěrował, jo hyšći wopśimjeśe na boku, kótarež njejo wěste (na pśikład wobraze). <label data-l10n-name="link">Dalšne informacije</label>
identity-description-active-loaded = Toś to websedło wopśimujo wopśimjeśe, kótarež njejo wěste (na pśikład skripty) a waš zwisk z nim njejo priwatny.
identity-description-active-loaded-insecure = Druge luźe mógu informacije wiźeś, kótarež źěliśo z toś tym sedłom (na pśikład gronidła, powěsći, kreditne kórty atd.).
identity-learn-more =
    .value = Dalšne informacije
identity-disable-mixed-content-blocking =
    .label = Šćit nachylnje znjemóžniś
    .accesskey = z
identity-enable-mixed-content-blocking =
    .label = Šćit zmóžniś
    .accesskey = z
identity-more-info-link-text =
    .label = Dalšne informacije

## Window controls

browser-window-minimize-button =
    .tooltiptext = Miniměrowaś
browser-window-maximize-button =
    .tooltiptext = Maksiměrowaś
browser-window-restore-down-button =
    .tooltiptext = Wótnowiś
browser-window-close-button =
    .tooltiptext = Zacyniś

## WebRTC Pop-up notifications

popup-select-camera =
    .value = Kamera, kotaraž ma se gromaźe wužywaś:
    .accesskey = K
popup-select-microphone =
    .value = Mikrofon, kótaryž ma se gromaźe wužywaś:
    .accesskey = M
popup-all-windows-shared = Wšykne widobne wokna na wašej wobrazowce budu se źěliś.
popup-screen-sharing-not-now =
    .label = Nic něnto
    .accesskey = c
popup-screen-sharing-never =
    .label = Nigda njedowóliś
    .accesskey = N
popup-silence-notifications-checkbox = Powěźeńki w { -brand-short-name } znjemóžniś, mjaztym až źěliśo
popup-silence-notifications-checkbox-warning = { -brand-short-name } njebuźo zdźělenja pokazowaś, mjaztym až źěliśo.

## WebRTC window or screen share tab switch warning

sharing-warning-window = Źěliśo { -brand-short-name }. Druge wósoby mógu wiźeś, gaž k nowemu rejtarikoju pśejźośo.
sharing-warning-screen = Źěliśo swóju cełu wobrazowku. Druge wósoby mógu wiźeś, gaž k nowemu rejtarikoju pśejźośo.
sharing-warning-proceed-to-tab =
    .label = K rejtarikoju póstupowaś
sharing-warning-disable-for-session =
    .label = Źěleński šćit za toś to pósejźenje znjemóžniś

## DevTools F12 popup

enable-devtools-popup-description = Aby tastu F12 wužywał, wócyńśo nejpjerwjej DevTools pśez meni Webwuwijaŕ.

## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = Pytaś abo adresu zapódaś
# This placeholder is used when not in search mode and the user's default search
# engine is unknown.
urlbar-placeholder =
    .placeholder = Pytaś abo adresu zapódaś
# This placeholder is used in search mode with search engines that search the
# entire web.
# Variables
#  $name (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-placeholder-search-mode-web-2 =
    .placeholder = Web pśepytaś
    .aria-label = Z { $name } pytaś
# This placeholder is used in search mode with search engines that search a
# specific site (e.g., Amazon).
# Variables
#  $name (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-placeholder-search-mode-other-engine =
    .placeholder = Pytańske wuraze zapódaś
    .aria-label = Z { $name } pytaś
# This placeholder is used when searching bookmarks.
urlbar-placeholder-search-mode-other-bookmarks =
    .placeholder = Pytańske wuraze zapódaś
    .aria-label = Cytańske znamjenja pśepytaś
# This placeholder is used when searching history.
urlbar-placeholder-search-mode-other-history =
    .placeholder = Pytańske wuraze zapódaś
    .aria-label = Historiju pśepytaś
# This placeholder is used when searching open tabs.
urlbar-placeholder-search-mode-other-tabs =
    .placeholder = Pytańske wuraze zapódaś
    .aria-label = Rejtariki pśepytaś
# Variables
#  $name (String): the name of the user's default search engine
urlbar-placeholder-with-name =
    .placeholder = Pytajśo z { $name } abo zapódajśo adresu
urlbar-remote-control-notification-anchor =
    .tooltiptext = Wobglědowak se zdaloka wóźi
urlbar-permissions-granted =
    .tooltiptext = Sćo pśizwólił toś tomu websedłoju pśidatne pšawa.
urlbar-switch-to-tab =
    .value = K rejtarikoju pśejś:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Rozšyrjenje:
urlbar-go-button =
    .tooltiptext = K adresy w adresowem pólu
urlbar-page-action-button =
    .tooltiptext = Akcije boka
urlbar-pocket-button =
    .tooltiptext = Pla { -pocket-brand-name } składowaś

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> jo něnto połna wobrazowka
fullscreen-warning-no-domain = Toś ten dokument jo něnto połna wobrazowka
fullscreen-exit-button = Połnu wobrazowku skóńcyś (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = Połnu wobrazowku (esc) skóńcyś
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> ma kontrolu nad wašeju špěrku. Tłocćo Esc, aby kontrolu slědk dostał.
pointerlock-warning-no-domain = Toś ten dokument ma kontrolu nad wašeju špěrku. Tłocćo Esc, aby kontrolu slědk dostał.
