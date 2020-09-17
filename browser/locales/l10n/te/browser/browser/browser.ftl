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
    .data-title-private = { -brand-full-name } (అంతరంగిక విహారణ)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (అంతరంగిక విహారణ)
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
    .data-title-private = { -brand-full-name } - (అంతరంగిక విహారణ)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (అంతరంగిక విహారణ)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = సైటు సమాచారం చూడండి

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = స్థాపన సందేశపు ప్యానెలును తెరువు
urlbar-web-notification-anchor =
    .tooltiptext = మీరు సైటు నుండి నోటిఫికేషన్లు అందుకుంటారో లేదో మార్చండి
urlbar-midi-notification-anchor =
    .tooltiptext = MIDI ప్యానెల్ తెరువు
urlbar-eme-notification-anchor =
    .tooltiptext = DRM సాఫ్ట్‌వేరు వాడుకను నిర్వహించండి
urlbar-web-authn-anchor =
    .tooltiptext = జాల ధ్రువీకరణ ప్యానెలును తెరువు
urlbar-canvas-notification-anchor =
    .tooltiptext = కాన్వాస్ వెలికితీత అనుమతిని నిర్వహించండి
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = సైటుతో మీ మైక్రోఫోనుని పంచుకోవడాన్ని నిర్వహించండి
urlbar-default-notification-anchor =
    .tooltiptext = సందేశపు ప్యానెలును తెరువు
urlbar-geolocation-notification-anchor =
    .tooltiptext = స్థాన అభ్యర్థన ప్యానెలును తెరువు
urlbar-xr-notification-anchor =
    .tooltiptext = వర్చువల్ రియాలిటీ అనుమతి ప్యానెల్ తెరవండి
urlbar-storage-access-anchor =
    .tooltiptext = విహారణ కార్యకరాలపు అనుమతి ప్యానెలును తెరువు
urlbar-translate-notification-anchor =
    .tooltiptext = ఈ పేజీని అనువదించండి
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = ఈ సైటుతో మీ విండోలు లేదా తెరను పంచుకోడాన్ని నిర్వహించండి
urlbar-indexed-db-notification-anchor =
    .tooltiptext = ఆఫ్‌లైన్ నిల్వ సందేశ ప్యానెలును తెరువు
urlbar-password-notification-anchor =
    .tooltiptext = పాస్‌వర్డ్ భద్రపరచు సందేశపు ప్యానెలును తెరువు
urlbar-translated-notification-anchor =
    .tooltiptext = పేజీ అనువాదాన్ని నిర్వహించండి
urlbar-plugins-notification-anchor =
    .tooltiptext = ప్లగ్-ఇన్ వాడకాన్ని నిర్వహించండి
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = సైటుతో మీ కేమెరా మరియు/లేదా మైక్రోఫోన్ పంచుకోడాన్ని నిర్వహించండి
urlbar-autoplay-notification-anchor =
    .tooltiptext = ఆటోప్లే ప్యానెలును తెరవండి
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = నిరంతర నిల్వ డేటాని నిల్వ చేయండి
urlbar-addons-notification-anchor =
    .tooltiptext = యాడ్-ఆన్ స్థాపన సందేశపు ప్యానెలు తెరువు
urlbar-tip-help-icon =
    .title = సహాయం పొందండి
urlbar-search-tips-confirm = సరే, అర్థమైంది
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = చిట్కా:

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = తక్కువ టైపు చేసి, ఎక్కువ కనుగొనండి: నేరుగా మీ చిరునామా పట్టీ నుండే { $engineName }‌లో వెతకండి.

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = ఇష్టాంశాలు
urlbar-search-mode-tabs = ట్యాబులు
urlbar-search-mode-history = చరిత్ర

##

urlbar-geolocation-blocked =
    .tooltiptext = మీ స్థాన సమాచారాన్ని వాడకుండా ఈ వెబ్‌సైటుని నిరోధించారు.
urlbar-xr-blocked =
    .tooltiptext = మీరు ఈ వెబ్‌సైట్ కోసం వర్చువల్ రియాలిటీ పరికర ప్రాప్యతను నిరోధించారు.
urlbar-web-notifications-blocked =
    .tooltiptext = నోటిఫికేషన్లు చూపించకుండా ఈ వెబ్‌సైటుని నిరోధించారు.
urlbar-camera-blocked =
    .tooltiptext = మీ కెమెరాను వాడకుండా ఈ వెబ్‌సైటుని నిరోధించారు.
urlbar-microphone-blocked =
    .tooltiptext = మీ మైక్రోఫోనును వాడకుండా ఈ వెబ్‌సైటుని నిరోధించారు.
urlbar-screen-blocked =
    .tooltiptext = మీ తెరను పంచుకోకుండా ఈ వెబ్‌సైటుని నిరోధించారు.
urlbar-persistent-storage-blocked =
    .tooltiptext = మీరు ఈ వెబ్సైట్ కోసం నిరంతర నిల్వ నిరోధించారు.
urlbar-popup-blocked =
    .tooltiptext = మీరు ఈ వెబ్‌సైటు యొక్క పాప్-అప్లను నిరోధించారు.
urlbar-autoplay-media-blocked =
    .tooltiptext = ఈ వెబ్‌సైటులో ధ్వనితో స్వయంచాలకంగా ఆడే మాధ్యమాలను నిరోధించారు.
urlbar-canvas-blocked =
    .tooltiptext = ఈ వెబ్‌సైటుని కాన్వాస్ డేటా వెలికితీయకుండా మీరు నిరోధించారు.
urlbar-midi-blocked =
    .tooltiptext = MIDI సౌలభ్యాన్ని పొందకుండా ఈ వెబ్‌సైటుని మీరు నిరోధించారు.
urlbar-install-blocked =
    .tooltiptext = ఈ వెబ్‌సైటు పొడగింతలను స్థాపించకుండా మీరు నిరోధించి ఉన్నారు.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = ఈ ఇష్టాంశమును సవరించు ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = ఈ పేజీను ఇష్టాంశముచేయుము ({ $shortcut })

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = చిరునామా పట్టీకి చేర్చండి
page-action-manage-extension =
    .label = పొడగింత నిర్వహణ…
page-action-remove-from-urlbar =
    .label = చిరునామా పట్టీ నుండి తొలగించండి
page-action-remove-extension =
    .label = పొడగింతను తొలగించు

## Auto-hide Context Menu

full-screen-autohide =
    .label = పనిముట్ల పట్టీలను దాచు
    .accesskey = H
full-screen-exit =
    .label = నిండు తెర రీతిని వదలివెళ్ళు
    .accesskey = F

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of one-click search engines in
# the Urlbar and searchbar.
search-one-offs-with-title = ఈ సారి దీనితో వెతుకు:
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = వెతుకుడు అమరికలు
search-one-offs-change-settings-compact-button =
    .tooltiptext = వెతుకుడు అమరికలను మార్చుకోండి
search-one-offs-context-open-new-tab =
    .label = కొత్త ట్యాబులో వెతుకు
    .accesskey = T
search-one-offs-context-set-as-default =
    .label = అప్రమేయ శోధన యంత్రంగా అమర్చండి
    .accesskey = D
search-one-offs-context-set-as-default-private =
    .label = అంతరంగిక కిటికీల కోసం అప్రమేయ శోధనయంత్రంగా అమర్చు
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
    .tooltiptext = ఇష్టాంశాలు ({ $restrict })
search-one-offs-tabs =
    .tooltiptext = ట్యాబులు ({ $restrict })
search-one-offs-history =
    .tooltiptext = చరిత్ర ({ $restrict })

## Bookmark Panel

bookmark-panel-show-editor-checkbox =
    .label = భద్రపరుస్తున్నప్పుడు ఎడిటర్‌ను చూపించు
    .accesskey = S
bookmark-panel-done-button =
    .label = పూర్తయింది
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 24em

## Identity Panel

identity-connection-not-secure = అనుసంధానం సురక్షితం కాదు
identity-connection-secure = సురక్షిత అనుసంధానం
identity-connection-internal = ఇది సురక్షిత { -brand-short-name } పేజీ.
identity-connection-file = ఈ పేజీ మీ కంప్యూటర్లో భద్రమైవుంది.
identity-extension-page = ఈ పేజీ ఒక పొడగింత నుండి తెరవబడింది.
identity-active-blocked = ఈ పేజీలో సురక్షితంకాని భాగాలను { -brand-short-name } నిరోధించింది.
identity-custom-root = మొజిల్లాచే గుర్తించబడని ధ్రువపత్ర జారీదారు అనుసంధానాన్ని నిర్ధారించారు.
identity-passive-loaded = ఈ పేజీలోని కొన్ని భాగాలు సురక్షితమైనవి కావు (బొమ్మల వంటివి).
identity-active-loaded = ఈ పేజీకి రక్షణను మీరు అచేతనం చేసారు.
identity-weak-encryption = ఈ పేజీ బలహీనమైన ఎన్‌క్రిప్షన్ వాడుతోంది.
identity-insecure-login-forms = ఈ పేజీలో మీరు ఇచ్చే లాగిన్లు రాజీపడవచ్చు.
identity-permissions =
    .value = అనుమతులు
identity-permissions-reload-hint = మార్పులు ప్రతిఫలించడానికి మీరు ఈ పేజీని మళ్ళీ లోడు చెయ్యాల్సిరావచ్చు.
identity-permissions-empty = ఈ సైటుకి మీరు ఎటువంటి ప్రత్యేక అనుమతులు ఇవ్వలేదు.
identity-clear-site-data =
    .label = కుకీలను, సైటు డేటాను తుడిచివేయి…
identity-connection-not-secure-security-view = ఈ సైటుకి మీరు సురక్షితంగా అనుసంధానం కాలేదు.
identity-connection-verified = ఈ సైటుకు మీరు సురక్షితంగా అనుసంధానమయ్యారు.
identity-ev-owner-label = ధ్రువపత్రం వీరికి జారీ అయ్యింది:
identity-description-custom-root = ఈ ధ్రువపత్రపు జారీదారు మొజిల్లాకు తెలియనివారు. ఇది మీ నిర్వాహక వ్యవస్థ నుండి లేదా నిర్వాహకుడిచే చేర్చబడి ఉండవచ్చు. <label data-l10n-name="link">ఇంకా తెలుసుకోండి</label>
identity-remove-cert-exception =
    .label = మినహాయింపును తొలగించు
    .accesskey = R
identity-description-insecure = ఈ సైటుకు మీరు గుట్టుగా అనుసంధానం కావడంలేదు. మీరు సమర్పించిన సమాచారం ఇతరులు చూడవచ్చు (సంకేతపదాలు, సందేశాలు, క్రెడిట్ కార్డులు, మొదలైనవి).
identity-description-insecure-login-forms = ఈ పేజీలో మీరు ఇచ్చిన లాగిన్ సమాచారం సురక్షితమైనది కాదు మరియు రాజీపడవచ్చు.
identity-description-weak-cipher-intro = ఈ వెబ్‌సైటుతో మీ అనుసంధానం బలహీనమైన ఎన్‌క్రిప్షన్‌తో ఉన్నది మరియు గుట్టుగా లేదు.
identity-description-weak-cipher-risk = ఇతరులు మీ సమాచారం చూడగలరు లేదా వెబ్‌సైట్ పనితీరుని మార్చగలరు.
identity-description-active-blocked = ఈ పేజీలో సురక్షితంకాని భాగాలను { -brand-short-name } నిరోధించింది. <label data-l10n-name="link">ఇంకా తెలుసుకోండి</label>
identity-description-passive-loaded = ఈ సైటుకు మీ అనుసంధానం గుట్టుగా లేదు మరియు ఈ సైటుతో మీరు పంచుకునే సమాచారం ఇతరులు చూడవచ్చు.
identity-description-passive-loaded-insecure = ఈ వెబ్‌సైట్ సురక్షితం కాని కాంటెంట్ కలిగివుంది (బొమ్మల వంటివి). <label data-l10n-name="link">ఇంకా తెలుసుకోండి</label>
identity-description-passive-loaded-mixed = { -brand-short-name } కొంత కాంటెంట్‌ను నిరోధించినప్పటికీ, ఇంకా ఈ పేజీలో సురక్షితం కాని కాంటెంట్ ఉంది (బొమ్మల వంటివి). <label data-l10n-name="link">ఇంకా తెలుసుకోండి</label>
identity-description-active-loaded = ఈ వెబ్‌సైట్ సురక్షితం కాని కాంటెంట్‌ను కలిగివుంది (స్క్రిప్టుల వంటివి) మరియు దానికి మీరు గుట్టుగా అనుసంధానంకాలేదు.
identity-description-active-loaded-insecure = ఈ సైటుతో మీరు పంచుకునే సమాచారాన్ని ఇతరులు చూడవచ్చు (సంకేతపదాలు, సందేశాలు, క్రెడిట్ కార్డులు, మొదలైనవి).
identity-learn-more =
    .value = ఇంకా తెలుసుకోండి
identity-disable-mixed-content-blocking =
    .label = ఇప్పటికి రక్షణను అచేతనించు
    .accesskey = D
identity-enable-mixed-content-blocking =
    .label = రక్షణను చేతనించు
    .accesskey = E
identity-more-info-link-text =
    .label = మరింత సమాచారం

## Window controls

browser-window-minimize-button =
    .tooltiptext = చిన్నదిచేయు
browser-window-maximize-button =
    .tooltiptext = పెద్దగించు
browser-window-close-button =
    .tooltiptext = మూసివేయి

## WebRTC Pop-up notifications

popup-select-camera =
    .value = పంచుకోవాల్సిన కేమెరా:
    .accesskey = C
popup-select-microphone =
    .value = పంచుకోవాల్సిన మైక్రోఫోన్:
    .accesskey = M
popup-all-windows-shared = మీ తెర మీద కనిపించే అన్ని విండోలు పంచుకోబడతాయి.
popup-screen-sharing-not-now =
    .label = ఇప్పుడు కాదు
    .accesskey = w
popup-screen-sharing-never =
    .label = ఎప్పటికీ అనుమతించవద్దు
    .accesskey = N

## WebRTC window or screen share tab switch warning

sharing-warning-disable-for-session =
    .label = ఈ సెషనుకి పంచుకోలు రక్షణను అచేతనంచేయి

## DevTools F12 popup


## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = వెతకండి లేదా చిరునామాను ఇవ్వండి
# This placeholder is used when not in search mode and the user's default search
# engine is unknown.
urlbar-placeholder =
    .placeholder = వెతకండి లేదా చిరునామాను ఇవ్వండి
# This placeholder is used in search mode with search engines that search the
# entire web.
# Variables
#  $name (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-placeholder-search-mode-web-2 =
    .placeholder = జాలంలో వెతకండి
    .aria-label = { $name }తో జాలంలో వెతకండి
# This placeholder is used in search mode with search engines that search a
# specific site (e.g., Amazon).
# Variables
#  $name (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-placeholder-search-mode-other-engine =
    .placeholder = వెతుకుడు పదాలను ఇవ్వండి
    .aria-label = { $name }‌లో వెతకండి
# This placeholder is used when searching bookmarks.
urlbar-placeholder-search-mode-other-bookmarks =
    .placeholder = వెతుకుడు పదాలను ఇవ్వండి
    .aria-label = ఇష్టాంశాలలో వెతకండి
# This placeholder is used when searching history.
urlbar-placeholder-search-mode-other-history =
    .placeholder = వెతుకుడు పదాలను ఇవ్వండి
    .aria-label = చరిత్రలో వెతకండి
# This placeholder is used when searching open tabs.
urlbar-placeholder-search-mode-other-tabs =
    .placeholder = వెతుకుడు పదాలను ఇవ్వండి
    .aria-label = ట్యాబులలో వెతకండి
# Variables
#  $name (String): the name of the user's default search engine
urlbar-placeholder-with-name =
    .placeholder = { $name }‌తో వెతకండి లేదా చిరునామాను ఇవ్వండి
urlbar-remote-control-notification-anchor =
    .tooltiptext = విహరణి వ్యవహిత నియంత్రణ కింద ఉంది
urlbar-permissions-granted =
    .tooltiptext = ఈ వెబ్‌సైటుకి మీరు అదనపు అనుమతులు ఇచ్చివున్నారు.
urlbar-switch-to-tab =
    .value = ట్యాబుకు మారు:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = పొడిగింత:
urlbar-go-button =
    .tooltiptext = ప్రాంతపు పట్టీలో ఉన్న చిరునామాకి వెళ్ళండి
urlbar-page-action-button =
    .tooltiptext = పేజీ చర్యలు
urlbar-pocket-button =
    .tooltiptext = { -pocket-brand-name }‌కి భద్రపరుచు

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> ఇప్పుడు నిండు తెరలో ఉంది
fullscreen-warning-no-domain = ఈ పత్రం ఇప్పుడు నిండు తెరలో ఉంది
fullscreen-exit-button = నిండు తెరను వదలివెళ్ళు (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = నిండు తెరను వదలివెళ్ళు (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = మీ పాయింటర్ <span data-l10n-name="domain">{ $domain }</span> నియంత్రణలో ఉంది. తిరిగి మీ ఆధీనం లోనికి తెచ్చుకోడానికి Esc నొక్కండి.
pointerlock-warning-no-domain = మీ పాయింటర్ ఈ పత్రపు నియంత్రణలో ఉంది. తిరిగి మీ ఆధీనం లోనికి తెచ్చుకోడానికి Esc నొక్కండి.
