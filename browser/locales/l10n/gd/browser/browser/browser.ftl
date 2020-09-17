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
    .data-title-private = { -brand-full-name } (Brabhsadh prìobhaideach)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (Brabhsadh prìobhaideach)
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
    .data-title-private = { -brand-full-name } - (Brabhsadh prìobhaideach)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (Brabhsadh prìobhaideach)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = Seall fiosrachadh na làraich-lìn

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = Fosgail panail teachdaireachdan an stàlaidh
urlbar-web-notification-anchor =
    .tooltiptext = Cuir romhad am faigh thu brathan on làrach seo gus nach fhaigh
urlbar-midi-notification-anchor =
    .tooltiptext = Fosgail a’ phanail MIDI
urlbar-eme-notification-anchor =
    .tooltiptext = Stiùirich cleachdadh de bhathar-bog fo DRM
urlbar-web-authn-anchor =
    .tooltiptext = Fosgail panail an dearbhaidh-lìn
urlbar-canvas-notification-anchor =
    .tooltiptext = Stiùirich cead às-tharraing a’ chanabhais
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = Stiùirich co-roinneadh a’ mhicreofoin agad leis an làrach
urlbar-default-notification-anchor =
    .tooltiptext = Fosgail panail nan teachdaireachdan
urlbar-geolocation-notification-anchor =
    .tooltiptext = Fosgail panail iarrtasan an ionaid
urlbar-xr-notification-anchor =
    .tooltiptext = Cleachd panail ceadan na fìorachd bhiortail
urlbar-storage-access-anchor =
    .tooltiptext = Fosgail panail ceadan na gnìomhachd brabhsaidh
urlbar-translate-notification-anchor =
    .tooltiptext = Eadar-theangaich an duilleag seo
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Stiùirich co-roinneadh nan uinneagan no na sgrìn agad leis an làrach
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Fosgail panail teachdaireachdan an stòrais far loidhne
urlbar-password-notification-anchor =
    .tooltiptext = Fosgail panail teachdaireachdan sàbhaladh fhaclan-faire
urlbar-translated-notification-anchor =
    .tooltiptext = Stiùirich eadar-theangachadh na duilleige
urlbar-plugins-notification-anchor =
    .tooltiptext = Stiùirich cleachdadh a’ phlugain
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Stiùirich co-roinneadh a’ chamara ’s/no a’ mhicreofoin agad leis an làrach
urlbar-autoplay-notification-anchor =
    .tooltiptext = Fosgail panail na fèin-chluich
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Stòr dàta san stòras bhuan
urlbar-addons-notification-anchor =
    .tooltiptext = Fosgail panail teachdaireachdan stàladh thuilleadan
urlbar-tip-help-icon =
    .title = Faigh cobhair
urlbar-search-tips-confirm = Ceart, tha mi agaibh
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = Gliocas:

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Nas lugha de sgrìobhadh: Dèan lorg le { $engineName } o bhàr an t-seòlaidh fhèin.
urlbar-search-tips-redirect-2 = Dèan lorg ann am bàr an t-seòlaidh ’s chì thu molaidhean o { $engineName } agus on eachdraidh bhrabhsaidh agad.

## Local search mode indicator labels in the urlbar


##

urlbar-geolocation-blocked =
    .tooltiptext = Bhac thu fiosrachadh mun ionad agad air an làrach-lìn seo.
urlbar-xr-blocked =
    .tooltiptext = Bhac thu inntrigeadh do dh’uidheaman na fìorachd bhiortail air an làrach-lìn seo.
urlbar-web-notifications-blocked =
    .tooltiptext = Bhac thu brathan air an làrach-lìn seo.
urlbar-camera-blocked =
    .tooltiptext = Bhac thu an camara agad air an làrach-lìn seo.
urlbar-microphone-blocked =
    .tooltiptext = Bhac thu am micreofon agad air an làrach-lìn seo.
urlbar-screen-blocked =
    .tooltiptext = Bhac thu an làrach-lìn seo o bhith a’ co-roinneadh na sgrìn agad.
urlbar-persistent-storage-blocked =
    .tooltiptext = Bhac thu stòras dàta buan mu choinneamh na làraich-lìn seo.
urlbar-popup-blocked =
    .tooltiptext = Bhac thu priob-uinneagan air an làrach-lìn seo.
urlbar-autoplay-media-blocked =
    .tooltiptext = Bhac thu fèin-chluich de mheadhanan aig a bheil fuaim air an làrach-lìn seo.
urlbar-canvas-blocked =
    .tooltiptext = Bhac thu às-tharraing dàta canabhais air an làrach-lìn seo.
urlbar-midi-blocked =
    .tooltiptext = Bhac thu inntrigeadh MIDI air an làrach-lìn seo.
urlbar-install-blocked =
    .tooltiptext = Bhac thu stàladh de thuilleadain air an làrach-lìn seo.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = Deasaich an comharra-lìn seo ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = Cruthaich comharra-lìn dhan duilleag seo ({ $shortcut })

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = Cuir ri bàr an t-seòlaidh
page-action-manage-extension =
    .label = Stiùirich an leudachan...
page-action-remove-from-urlbar =
    .label = Thoir air falbh o bhàr an t-seòlaidh

## Auto-hide Context Menu

full-screen-autohide =
    .label = Cuir bàraichean-inneal am falach
    .accesskey = h
full-screen-exit =
    .label = Fàg modh na làn-sgrìn
    .accesskey = l

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of one-click search engines in
# the Urlbar and searchbar.
search-one-offs-with-title = Dèan lorg leis na leanas an turas seo:
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = Roghainnean luirg
search-one-offs-change-settings-compact-button =
    .tooltiptext = Atharraich na roghainnean luirg
search-one-offs-context-open-new-tab =
    .label = Lorg ann an taba ùr
    .accesskey = t
search-one-offs-context-set-as-default =
    .label = Cleachd seo mar an t-einnsean-luirg bunaiteach
    .accesskey = d
search-one-offs-context-set-as-default-private =
    .label = Suidhich mar an t-einnsean-luirg bunaiteachd ann an uinneagan prìobhaideach
    .accesskey = S

## Local search mode one-off buttons
## Variables:
##  $restrict (String): The restriction token corresponding to the search mode.
##    Restriction tokens are special characters users can type in the urlbar to
##    restrict their searches to certain sources (e.g., "*" to search only
##    bookmarks).


## Bookmark Panel

bookmark-panel-show-editor-checkbox =
    .label = Seall an deasaiche nuair a nithear sàbhaladh
    .accesskey = S
bookmark-panel-done-button =
    .label = Dèanta
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

identity-connection-not-secure = Chan eil an ceangal tèarainte
identity-connection-secure = Tha an ceangal tèarainte
identity-connection-internal = Seo duilleag { -brand-short-name } tèarainte.
identity-connection-file = Tha an duilleag seo ’ga stòradh air a’ choimpiutair agad.
identity-extension-page = Chaidh an duilleag seo ’ga luchdadh o leudachan.
identity-active-blocked = Bhac { -brand-short-name } na pìosan dhen duilleag seo nach eil tèarainte.
identity-custom-root = Chaidh an ceangal a dhearbhadh le teisteanas nach aithnich Mozilla.
identity-passive-loaded = Chan eil pìosan dhen duilleag seo tèarainte (mar dhealbhan).
identity-active-loaded = Chuir thu an dìon à comas air an duilleag seo.
identity-weak-encryption = Tha an duilleag seo a’ cleachdadh crioptachadh lag.
identity-insecure-login-forms = Dh’fhaoidte gu bheil cothrom air daoine air fiosrachadh clàraidh air an duilleag seo.
identity-permissions =
    .value = Ceadan
identity-permissions-reload-hint = Dh’fhaoidte gum bi agad ris an duilleag ath-luchdadh mus bi na h-atharraichean an sàs.
identity-permissions-empty = Cha dug thu cead sònraichte sam bith dhan làrach seo.
identity-clear-site-data =
    .label = Falamhaich na briosgaidean is dàta nan làrach...
identity-connection-not-secure-security-view = Chan eil ceangal tèarainte agad ris an làrach seo.
identity-connection-verified = Tha ceangal tèarainte agad ris an làrach seo.
identity-ev-owner-label = Chaidh an teisteanas fhoillseachadh dha:
identity-description-custom-root = Chan aithnich Mozilla foillsichear an teisteanais seo. Dh’fhaoidte gun do chuir an siostam-obrachaidh agad ris e no ’s dòcha rianaire. <label data-l10n-name="link">Barrachd fiosrachaidh</label>
identity-remove-cert-exception =
    .label = Thoir an eisgeachd  air falbh
    .accesskey = r
identity-description-insecure = Chan eil an ceangal agad ris an làrach seo prìobhaideach. Dh’fhaoidte gum faic daoine eile dàta a chuireas tu a-null (mar fhaclan-faire, teachdaireachdan, cairtean-creideis is msaa.).
identity-description-insecure-login-forms = Chan eil am fiosrachadh a chuir thu a-steach air an duilleag seo tèarainte agus dh’fhaoidte gum bris cuideigin a-steach air a’ chlàradh agad.
identity-description-weak-cipher-intro = Tha an ceangal agad ris an làrach-lìn seo a’ cleachdadh crioptachadh lag agus chan eil e prìobhaideach.
identity-description-weak-cipher-risk = Chì daoine eile am fiosrachadh agad agus is urrainn dhaibh giùlan a’ bhrabhsair agad atharrachadh.
identity-description-active-blocked = Bhac { -brand-short-name } na pìosan dhen duilleag seo nach eil tèarainte. <label data-l10n-name="link">Barrachd fiosrachaidh</label>
identity-description-passive-loaded = Chan eil an ceangal agad prìobhaideach agus dh’fhaoidte gum faic daoine eile dàta a chuireas tu gun làrach.
identity-description-passive-loaded-insecure = Tha susbaint air an làrach-lìn seo nach eil tèarainte (mar dhealbhan). <label data-l10n-name="link">Barrachd fiosrachaidh</label>
identity-description-passive-loaded-mixed = Ged a bhac { -brand-short-name } cuid dhen t-susbaint, tha susbaint air an duilleag seo fhathast nach eil tèarainte (mar dhealbhan). <label data-l10n-name="link">Barrachd fiosrachaidh</label>
identity-description-active-loaded = Tha susbaint air an làrach-lìn seo nach eil tèarainte (mar sgriobtan) agus chan eil an ceangal agad ris prìobhaideach.
identity-description-active-loaded-insecure = Dh’fhaoidte gum faic daoine eile dàta a chuireas tu gun làrach seo (mar fhaclan-faire, teachdaireachdan, cairtean-creideis is msaa.).
identity-learn-more =
    .value = Barrachd fiosrachaidh
identity-disable-mixed-content-blocking =
    .label = Cuir an dìon à comas an-dràsta fhèin
    .accesskey = d
identity-enable-mixed-content-blocking =
    .label = Cuir an comas an dìon
    .accesskey = u
identity-more-info-link-text =
    .label = Barrachd fiosrachaidh

## Window controls

browser-window-minimize-button =
    .tooltiptext = Lughdaich
browser-window-close-button =
    .tooltiptext = Dùin

## WebRTC Pop-up notifications

popup-select-camera =
    .value = An camara a thèid a cho-roinneadh:
    .accesskey = c
popup-select-microphone =
    .value = Am micreofon a thèid a cho-roinneadh:
    .accesskey = m
popup-all-windows-shared = Thèid gach uinneag a tha ri fhaicinn air an sgrìn agad a cho-roinneadh.

## WebRTC window or screen share tab switch warning


## DevTools F12 popup


## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = Cuir ann lorg no seòladh
urlbar-placeholder =
    .placeholder = Cuir ann lorg no seòladh
urlbar-remote-control-notification-anchor =
    .tooltiptext = Tha am brabhsair fo smachd cèin
urlbar-switch-to-tab =
    .value = Gearr leum gun taba:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Leudachan:
urlbar-go-button =
    .tooltiptext = Rach dhan t-seòladh a tha ann am bàr an t-seòlaidh
urlbar-page-action-button =
    .tooltiptext = Gnìomhan na duilleige
urlbar-pocket-button =
    .tooltiptext = Sàbhail ann am { -pocket-brand-name }

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> ’na làn-sgrìn a-nis
fullscreen-warning-no-domain = Tha an sgrìobhainn seo ’na làn-sgrìn a-nis
fullscreen-exit-button = Fàg an làn-sgrìn (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = Fàg an làn-sgrìn (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = Tha smachd aig <span data-l10n-name="domain">{ $domain }</span> air an tomhaire agad. Brùth Esc airson an smachd a thilleadh dhut fhèin.
pointerlock-warning-no-domain = Tha smachd aig an sgrìobhainn seo air an tomhaire agad. Brùth Esc airson an smachd a thilleadh dhut fhèin.
