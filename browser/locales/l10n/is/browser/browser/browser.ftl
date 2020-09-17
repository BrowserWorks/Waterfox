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
    .data-title-private = { -brand-full-name } (Huliðsstilling)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (Huliðsstilling)
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
    .data-title-private = { -brand-full-name } - (Huliðsstilling)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (Huliðsstilling)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = Skoða upplýsingar um vefsvæði

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = Opna skilaboðaflipa uppsetninga
urlbar-web-notification-anchor =
    .tooltiptext = Breyta hvort vefsvæði getur sent þér tilkynningar
urlbar-midi-notification-anchor =
    .tooltiptext = Opna MIDI flipa
urlbar-eme-notification-anchor =
    .tooltiptext = Sýsla með notkun á DRM hugbúnaði
urlbar-web-authn-anchor =
    .tooltiptext = Opna auðkenningarspjald vefs
urlbar-canvas-notification-anchor =
    .tooltiptext = Sýsla með öryggi fyrir canvas upplýsingar
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = Sýsla með að deila hljóðnema á vefsvæðinu
urlbar-default-notification-anchor =
    .tooltiptext = Opna skilaboðaflipa
urlbar-geolocation-notification-anchor =
    .tooltiptext = Opna staðsetningarbeiðnaflipa
urlbar-storage-access-anchor =
    .tooltiptext = Opna heimildaspjald vafravirkni
urlbar-translate-notification-anchor =
    .tooltiptext = Þýða þessa síðu
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Sýsla með að deila gluggum eða skjá á vefsvæðinu
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Opna skilaboðaflipa fyrir aftengda geymslu
urlbar-password-notification-anchor =
    .tooltiptext = Opna skilaboðaflipa fyrir vistuð lykilorð
urlbar-translated-notification-anchor =
    .tooltiptext = Sýsla með þýðingar á síðu
urlbar-plugins-notification-anchor =
    .tooltiptext = Sýsla með notkun tengiforrita
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Sýsla með deilingu á myndavél og/eða hljóðnema fyrir þetta vefsvæði
urlbar-autoplay-notification-anchor =
    .tooltiptext = Opna spjald sjálfkrafa afspilunar
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Geyma gögn í varanlegri gagnageymslu
urlbar-addons-notification-anchor =
    .tooltiptext = Opna skilaboðaflipa fyrir viðbótauppsetningu

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Minni innsláttur, finna meira: Leitaðu með { $engineName } beint frá leitarslá.

## Local search mode indicator labels in the urlbar


##

urlbar-geolocation-blocked =
    .tooltiptext = Þú hefur lokað fyrir staðsetningarupplýsingar á þessu vefsvæði.
urlbar-web-notifications-blocked =
    .tooltiptext = Þú hefur lokað fyrir tilkynningar á þessu vefsvæði.
urlbar-camera-blocked =
    .tooltiptext = Þú hefur lokað fyrir myndavélina á þessu vefsvæði.
urlbar-microphone-blocked =
    .tooltiptext = Þú hefur lokað fyrir hljóðnema á þessu vefsvæði.
urlbar-screen-blocked =
    .tooltiptext = Þú hefur lokað fyrir að deila skjáum á þessu vefsvæði.
urlbar-persistent-storage-blocked =
    .tooltiptext = Þú hefur lokað fyrir gagna geymslu á þessu vefsvæði.
urlbar-popup-blocked =
    .tooltiptext = Þú hefur lokað á sprettiglugga fyrir þetta vefsvæði.
urlbar-autoplay-media-blocked =
    .tooltiptext = Þú hefur lokað fyrir sjálfkrafa afspilun á þessari vefsíðu.
urlbar-canvas-blocked =
    .tooltiptext = Þú hefur lokað á að nálgast gluggagögn fyrir þetta vefsvæði.
urlbar-midi-blocked =
    .tooltiptext = Þú hefur lokað fyrir MIDI aðgang á þessu vefsvæði.
urlbar-install-blocked =
    .tooltiptext = Þú hefur lokað fyrir staðsetningarupplýsingar á þessu vefsvæði.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = Breyta bókamerki ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = Setja síðu í bókamerki ({ $shortcut })

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = Bæta við í staðfestingarslá
page-action-manage-extension =
    .label = Sýsla með viðbót…
page-action-remove-from-urlbar =
    .label = Fjarlægja úr staðsetningarslá

## Auto-hide Context Menu

full-screen-autohide =
    .label = Fela tækjaslár
    .accesskey = F
full-screen-exit =
    .label = Ekki fylla skjá
    .accesskey = f

## Search Engine selection buttons (one-offs)

# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = Breyta leitarstillingum
search-one-offs-change-settings-compact-button =
    .tooltiptext = Breyta leitarstillingum
search-one-offs-context-open-new-tab =
    .label = Leita og birta í nýjum flipa
    .accesskey = f
search-one-offs-context-set-as-default =
    .label = Setja sem sjálfgefna leitarvél
    .accesskey = l

## Local search mode one-off buttons
## Variables:
##  $restrict (String): The restriction token corresponding to the search mode.
##    Restriction tokens are special characters users can type in the urlbar to
##    restrict their searches to certain sources (e.g., "*" to search only
##    bookmarks).


## Bookmark Panel

bookmark-panel-show-editor-checkbox =
    .label = Sýna ritil þegar vistað er
    .accesskey = S
bookmark-panel-done-button =
    .label = Ljúka
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

identity-connection-internal = Þetta er örugg { -brand-short-name } síða.
identity-connection-file = Þessi síða er vistuð á tölvunni þinni.
identity-extension-page = Þessi síða er hlaðinn inn af viðbót.
identity-active-blocked = { -brand-short-name } hefur lokað á suma hluta á þessari síðu sem eru ekki öruggir.
identity-custom-root = Tenging staðfest af útgefanda vottorðs sem ekki er viðurkennt af Mozilla.
identity-passive-loaded = Sumir hlutir á þessari síðu eru ekki öruggir (eins og myndir).
identity-active-loaded = Þú hefur slökkt á vernd fyrir þessa síðu.
identity-weak-encryption = Þessi síða notar lélega dulkóðun.
identity-insecure-login-forms = Hugsanlega gæti þriðji aðili komist yfir allar þær skráningar sem þú setur inn á þessa síðu.
identity-permissions-reload-hint = Þú gætir þurft að endurhlaða síðuna til að virkja breytingar.
identity-permissions-empty = Þú hefur ekki gefið þessu vefsvæði nein sérstök réttindi.
identity-clear-site-data =
    .label = Hreinsa vefkökur og síðugögn…
identity-remove-cert-exception =
    .label = Fjarlægja undantekningu
    .accesskey = r
identity-description-insecure = Tengingin við þetta vefsvæði er ekki læst. Þær upplýsingar sem þú sendir gætu aðrir skoðað (til dæmis lykilorð, skilaboð, greiðslukort, og fleira).
identity-description-insecure-login-forms = Upplýsingarnar sem þú setur inn á þessa síðu eru ekki öruggar og hugsanlega gæti þriðji aðili komist yfir þær.
identity-description-weak-cipher-intro = Tengingin við þetta vefsvæði notar lélega dulkóðun og er ekki lokuð.
identity-description-weak-cipher-risk = Aðrir geta skoðað þessar upplýsingar eða breytt virkni vefsvæðisins.
identity-description-active-blocked = { -brand-short-name } hefur lokað á suma hluta á þessari síðu sem eru ekki öruggir. <label data-l10n-name="link">Fræðast meira</label>
identity-description-passive-loaded = Tengingin við þetta vefsvæði er ekki lokuð og upplýsingar sem þú sendir gætu aðrir skoðað.
identity-description-passive-loaded-insecure = Þetta vefsvæði inniheldur gögn sem eru ekki örugg (eins og myndir). <label data-l10n-name="link">Fræðast meira</label>
identity-description-passive-loaded-mixed = Þótt { -brand-short-name } hafi lokað á suma hluta, er ennþá innihald á síðunni sem er ekki öruggt (eins og myndir). <label data-l10n-name="link">Fræðast meira</label>
identity-description-active-loaded = Þetta vefsvæði inniheldur gögn sem eru ekki örugg (eins og skriftur) og tengingin er ekki lokuð.
identity-description-active-loaded-insecure = Þær upplýsingar sem þú gefur upp á þessu vefsvæði gætu aðrir skoðað (til dæmis lykilorð, skilaboð, greiðslukort, og fleira).
identity-learn-more =
    .value = Fræðast meira
identity-disable-mixed-content-blocking =
    .label = Hætta við vörn í bili
    .accesskey = H
identity-enable-mixed-content-blocking =
    .label = Virkja vernd
    .accesskey = e
identity-more-info-link-text =
    .label = Nánari upplýsingar

## Window controls

browser-window-minimize-button =
    .tooltiptext = Minnka
browser-window-close-button =
    .tooltiptext = Loka

## WebRTC Pop-up notifications

popup-select-camera =
    .value = Myndavél til að deila:
    .accesskey = y
popup-select-microphone =
    .value = Hljóðnemi til að deila:
    .accesskey = m
popup-all-windows-shared = Öllum sýnilegum gluggum á skjánum verður deilt.

## WebRTC window or screen share tab switch warning


## DevTools F12 popup


## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = Leita eða sláðu inn veffang
urlbar-placeholder =
    .placeholder = Leita eða sláðu inn veffang
urlbar-remote-control-notification-anchor =
    .tooltiptext = Vafri er á fjarstýringu
urlbar-switch-to-tab =
    .value = Fara á flipa:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Skráarending:
urlbar-go-button =
    .tooltiptext = Hoppa á tengilinn sem er í staðsetningarslánni
urlbar-page-action-button =
    .tooltiptext = Síðu aðgerðir
urlbar-pocket-button =
    .tooltiptext = Vista í { -pocket-brand-name }

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> er með fylltan skjá
fullscreen-warning-no-domain = Þetta skjal er nú á fylltum skjá
fullscreen-exit-button = Hætta í fullum skjá (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = Hætta í fullum skjá (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> hefur stjórn á bendi. Ýttu á Esc til að taka aftur yfir stjórn.
pointerlock-warning-no-domain = Þetta skjal hefur nú stjórnina á bendi. Ýttu á Esc til að taka aftur yfir stjórn.
