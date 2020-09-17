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
    .data-title-private = { -brand-full-name } (Tunigin Tusligt)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (Tunigin Tusligt)
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
    .data-title-private = { -brand-full-name } - (Tunigin Tusligt)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (Tunigin Tusligt)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = Sken talɣut n usmel

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = Ldi agalis n yizen n usebded
urlbar-web-notification-anchor =
    .tooltiptext = Beddel ma yella tebɣiḍ ad d-tremseḍ ilɣa seg usmel
urlbar-midi-notification-anchor =
    .tooltiptext = Ldi agalis MIDI
urlbar-eme-notification-anchor =
    .tooltiptext = Sefrek aseqdec n useɣẓan DRM
urlbar-web-authn-anchor =
    .tooltiptext = Ldi afeggag n usentem Web
urlbar-canvas-notification-anchor =
    .tooltiptext = Sefrek tasiregt n usuffeɣ n tneɣruft
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = Sefrek beṭṭu n usawaḍ-ik d usmel
urlbar-default-notification-anchor =
    .tooltiptext = Ldi agalis n yizen
urlbar-geolocation-notification-anchor =
    .tooltiptext = Ldi agalis n usuter n wadeg
urlbar-xr-notification-anchor =
    .tooltiptext = Ldi agalis n tsirag i tilawt tuhlist
urlbar-storage-access-anchor =
    .tooltiptext = Ldi agalis n tsirag n tunigin
urlbar-translate-notification-anchor =
    .tooltiptext = Suqel asebter-a
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Sefrek beṭṭu n yisfuyla neɣ igdilen d usmel
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Ldi agalis n yizen n usekles aruqqin
urlbar-password-notification-anchor =
    .tooltiptext = Ldi agalis n yizen n wawal uffir yettwakelsen
urlbar-translated-notification-anchor =
    .tooltiptext = Sefrek tasuqilt n usebter
urlbar-plugins-notification-anchor =
    .tooltiptext = Sefrek aseqdec n yizegrar
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Sefrek beṭṭu n tkamirat-ik d/neɣ asawaḍ-ik d usmel
urlbar-autoplay-notification-anchor =
    .tooltiptext = Ldi agalis n urar awurman
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Err-d isefka deg uselkim
urlbar-addons-notification-anchor =
    .tooltiptext = Ldi agalis n yizen i usebded n uzegrir
urlbar-tip-help-icon =
    .title = Awi tallelt
urlbar-search-tips-confirm = Ih, awi-t-id
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = Taxbalut:

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Aru cwiṭ, af-d ugar : nadi s { $engineName } srid seg ufeggag n tensa.
urlbar-search-tips-redirect-2 = Bdu anadi-ik deg ufeggag n tansiwin i wakken ad tsekneḍ isumar seg { $engineName } daɣen seg umuzruy-ik n tunigin.

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = Ticraḍ n yisebtar
urlbar-search-mode-tabs = Accaren
urlbar-search-mode-history = Amazray

##

urlbar-geolocation-blocked =
    .tooltiptext = Tesweḥleḍ talɣut ɣef wadeg i usmelweb-a.
urlbar-xr-blocked =
    .tooltiptext = Tesweḥleḍ anekcum i yibenkan n tilawt tuhlist i usmel-a.
urlbar-web-notifications-blocked =
    .tooltiptext = Tesweḥleḍ ilɣa i usmelweb-a.
urlbar-camera-blocked =
    .tooltiptext = Tesweḥleḍ asawaḍ-ik i usmelweb-a.
urlbar-microphone-blocked =
    .tooltiptext = Tesweḥleḍ asawaḍ-inek i usmelweb-a.
urlbar-screen-blocked =
    .tooltiptext = Tesweḥleḍ asmelweb-a seg beṭṭu n ugdil-inek.
urlbar-persistent-storage-blocked =
    .tooltiptext = Tesweḥleḍ asekles n yisefka i usmelweb-a.
urlbar-popup-blocked =
    .tooltiptext = Tesweḥleḍ asfaylu udhim i usmel-agi.
urlbar-autoplay-media-blocked =
    .tooltiptext = Teswaḥleḍ urar awurman n teywalt s umeslaw i usmel-agi web.
urlbar-canvas-blocked =
    .tooltiptext = Tesweḥleḍ tussfa n yisefka n ubeckil i usmelweb-a.
urlbar-midi-blocked =
    .tooltiptext = Tesweḥleḍ anekcum i MIDI γer usmel-agi.
urlbar-install-blocked =
    .tooltiptext = Tesweḥleḍ asbeddi n yizegrar i usmel-a.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = Ẓreg tacreḍṭ-a n usebter ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = Creḍ asebter-a ({ $shortcut })

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = Rnu ɣeṛ yimedlis n tansa
page-action-manage-extension =
    .label = Sefrek aseɣzef…
page-action-remove-from-urlbar =
    .label = Kkes seg ufeggag n tansa
page-action-remove-extension =
    .label = Kkes asiɣzef

## Auto-hide Context Menu

full-screen-autohide =
    .label = Ffer afeggag n yifecka
    .accesskey = F
full-screen-exit =
    .label = Ffeɣ seg uskar n ugdil ačaran
    .accesskey = F

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of one-click search engines in
# the Urlbar and searchbar.
search-one-offs-with-title = Tikkelt-agi, nadi s:
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = Iɣewwaren n unadi
search-one-offs-change-settings-compact-button =
    .tooltiptext = Beddel iɣewwaren n unadi
search-one-offs-context-open-new-tab =
    .label = Nadi deg yiccer amaynut
    .accesskey = c
search-one-offs-context-set-as-default =
    .label = Sers-it d amsedday n unadi amezwer
    .accesskey = D
search-one-offs-context-set-as-default-private =
    .label = Sbadu-t amsedday n unadi amezwer i Windows Private
    .accesskey = P
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
    .tooltiptext = Ticraḍ n yisebtar ({ $restrict })
search-one-offs-tabs =
    .tooltiptext = Accaren ({ $restrict })
search-one-offs-history =
    .tooltiptext = Amazray ({ $restrict })

## Bookmark Panel

bookmark-panel-show-editor-checkbox =
    .label = Sken amaẓrag deg usekles
    .accesskey = k
bookmark-panel-done-button =
    .label = Immed
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

identity-connection-not-secure = Tuqqna taraɣelsant
identity-connection-secure = Taɣellist n tuqqna
identity-connection-internal = Wa d asebter { -brand-short-name } aɣelsan.
identity-connection-file = Asebter-a yettwakles deg uselkim-inek.
identity-extension-page = Asebter-a yuli-d seg usiɣzef.
identity-active-blocked = { -brand-short-name } issewḥel kra n tazunin ur nelli ara d iɣelsanen deg usebter-a.
identity-custom-root = Tuqqna tettwasentem sɣur amazan n uselkin ur yessin ara Mozilla.
identity-passive-loaded = Kra n yiḥricen deg usebter-a mačči d iɣelsanen (am tugniwin).
identity-active-loaded = Tessenseḍ ammesten deg usebter-a.
identity-weak-encryption = Asebter-a isseqdac awgelhen fessusen.
identity-insecure-login-forms = Isem n useqdac d wawal uffir i tesqedceḍ deg usmel-a zemren ad ttwakren.
identity-permissions =
    .value = Tisirag
identity-permissions-reload-hint = Ahat tesriḍ ad d-tessaliḍ tikelt-nniḍen asebter akken ad yemmed wayen i tbeddleḍ.
identity-permissions-empty = Ur tefkiḍ ara kra n tsiregt i usmel-a.
identity-clear-site-data =
    .label = Sfeḍ inagan n tuqqna akked isefka n usme…
identity-connection-not-secure-security-view = Aqli-k ur teqqineḍ ara s wudem aɣelsan ɣeṛ usmel-a.
identity-connection-verified = Aqli-k teqqneḍ s wudem aɣelsan ɣeṛ usmel-a.
identity-ev-owner-label = Aselkin yeffeɣ-d i:
identity-description-custom-root = Mozilla ur teɛqil ara amazan-a n uselkin. Ahat yezmer yettwarn seg unagraw-ik n wammud neɣ anedbal. <label data-l10n-name="link">Issin ugar</label>
identity-remove-cert-exception =
    .label = Kkes tasureft
    .accesskey = K
identity-description-insecure = Tuqqna-inek ɣer usmel-a mačči d tusligt. Zemren wiyaḍ ad walin talɣut ara tazneḍ (am wawalen uffiren, iznan, atg.).
identity-description-insecure-login-forms = Talɣut n yisem n useqdac i d-tefkiḍ deg usebter-a mačči d taɣelsant u yezmer ad tettwaker.
identity-description-weak-cipher-intro = Tuqqna-inek ɣeṛ usmel-a tesseqdac awgelhen fessusen u mačči d tusligt.
identity-description-weak-cipher-risk = Zemren imdanen-nniḍen ad walin talɣut-ik neɣ ad beddlen tikli n usmel web.
identity-description-active-blocked = { -brand-short-name } issewḥel kra n yiḥricen n usebter-a ur nelli ara d iɣelsanen. <label data-l10n-name="link">Issin ugar</label>
identity-description-passive-loaded = Zemren wiyaḍ ad walin talɣut ara tebḍuḍ d usmel-a acku tuqqna-k mačči d tusligt.
identity-description-passive-loaded-insecure = Asmel-a isεa agbur araɣelsan (am tugniwin). <label data-l10n-name="link">Issin ugar</label>
identity-description-passive-loaded-mixed = Ɣas akken { -brand-short-name } issewḥel kra n ugbur, mazal yella kra n ugbur ur nelli d aɣelsan deg usebter (am tugniwin). <label data-l10n-name="link">Issin ugar</label>
identity-description-active-loaded = Asmel-a isεa agbur araɣelsan (am iskripten) u tuqqna-inek ɣur-s mačči d tusligt.
identity-description-active-loaded-insecure = Zemren wiyaḍ ad walin talɣut ara tebḍuḍ d usmel-a (am wawalen uffiren, iznan, atg.).
identity-learn-more =
    .value = Issin ugar
identity-disable-mixed-content-blocking =
    .label = Kkes ammesten i tura
    .accesskey = K
identity-enable-mixed-content-blocking =
    .label = Sermed ammesten
    .accesskey = R
identity-more-info-link-text =
    .label = Ugar n telɣut

## Window controls

browser-window-minimize-button =
    .tooltiptext = Semẓi
browser-window-maximize-button =
    .tooltiptext = Semɣeṛ
browser-window-restore-down-button =
    .tooltiptext = Err-d
browser-window-close-button =
    .tooltiptext = Mdel

## WebRTC Pop-up notifications

popup-select-camera =
    .value = Takamiṛat i beṭṭu:
    .accesskey = K
popup-select-microphone =
    .value = Asawaḍ i beṭṭu:
    .accesskey = S
popup-all-windows-shared = Akk isfuyla ibanen deg ugdil-ik ad ttwabḍun.
popup-screen-sharing-not-now =
    .label = Mačči tura
    .accesskey = w
popup-screen-sharing-never =
    .label = Ur sirig ara
    .accesskey = N
popup-silence-notifications-checkbox = Kkes ilɣa n { -brand-short-name } di lawan n beṭṭu
popup-silence-notifications-checkbox-warning = { -brand-short-name } ur yeskanay ara ilɣa mi ara tbeṭṭuḍ.

## WebRTC window or screen share tab switch warning

sharing-warning-window = Tbeṭṭuḍ { -brand-short-name }. Imdanen-nniḍen zemren ad walin mi ara tedduḍ ɣer yiccer amaynut.
sharing-warning-screen = Tbeṭṭuḍ akk agdil-inek . Imdanen-nniḍen zemren ad walin mi ara tedduḍ ɣer yiccer amaynut.
sharing-warning-proceed-to-tab =
    .label = Ɛeddi ɣeryiccer
sharing-warning-disable-for-session =
    .label = Kkes beṭṭu n urmad n ummesten n tɣimit-a

## DevTools F12 popup

enable-devtools-popup-description = Akken ad tesqedceḍ anegzum F12, ldi qbel DevTools s wumuɣ web n uneflay.

## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = Nadi neɣ sekcem tansa
# This placeholder is used when not in search mode and the user's default search
# engine is unknown.
urlbar-placeholder =
    .placeholder = Nadi neɣ sekcem tansa
# This placeholder is used in search mode with search engines that search the
# entire web.
# Variables
#  $name (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-placeholder-search-mode-web-2 =
    .placeholder = Nadi deg uẓeṭṭa web
    .aria-label = Nadi s { $name }
# This placeholder is used in search mode with search engines that search a
# specific site (e.g., Amazon).
# Variables
#  $name (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-placeholder-search-mode-other-engine =
    .placeholder = Sekcem awalen n unadi
    .aria-label = Nadi s { $name }
# This placeholder is used when searching bookmarks.
urlbar-placeholder-search-mode-other-bookmarks =
    .placeholder = Sekcem awalen n unadi
    .aria-label = Nadi s tecraḍ
# This placeholder is used when searching history.
urlbar-placeholder-search-mode-other-history =
    .placeholder = Sekcem awalen n unadi
    .aria-label = Amazray n unadi
# This placeholder is used when searching open tabs.
urlbar-placeholder-search-mode-other-tabs =
    .placeholder = Sekcem awalen n unadi
    .aria-label = Iccaren n unadi
# Variables
#  $name (String): the name of the user's default search engine
urlbar-placeholder-with-name =
    .placeholder = Nadi s { $name } neɣ sekcem tansa
urlbar-remote-control-notification-anchor =
    .tooltiptext = Iminig yettwaṭṭef s wudem anmeggag
urlbar-permissions-granted =
    .tooltiptext = Ɣur-k tisirag-nniḍen akken ad tkecmeḍ ɣeṛ usmel-a web.
urlbar-switch-to-tab =
    .value = Ddu ɣer yiccer:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Asiɣzef:
urlbar-go-button =
    .tooltiptext = Ddu ɣer usebter n ufeggag n tansa
urlbar-page-action-button =
    .tooltiptext = Asebter n tigawin
urlbar-pocket-button =
    .tooltiptext = Sekles ɣer { -pocket-brand-name }

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> atan tura deg ugdil ačaran
fullscreen-warning-no-domain = Isemli-a, atan tura deg ugdil ačuṛan
fullscreen-exit-button = Ffeɣ seg ugdil ačuṛan (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = Ffeɣ seg ugdil ačuṛan (Esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> Ɣur-s asenqed n usewwaṛ-inek. Sit ɣef tqeffalt n usenser akken ad teṭṭfeḍ asewwaṛ.
pointerlock-warning-no-domain = Isemli-a yeṭṭef asewwaṛ-ik. Sit ɣef Esc akken ad teṭṭfeḍ asewwaṛ.
