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
    .data-title-private = { -brand-full-name } (පෞද්ගලික ගවේෂණය)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (පෞද්ගලික ගවේෂණය)
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
    .data-title-private = { -brand-full-name } - (පෞද්ගලික ගවේෂණය)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (පෞද්ගලික ගවේෂණය)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = අඩවි තොරතුරු පෙන්වන්න

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = ස්ථාපන පණිවිඩ පුවරුව විවෘත කරන්න
urlbar-web-notification-anchor =
    .tooltiptext = ඔබට අඩවියෙන් දැන්වීම් ලැබිය හැකිද යන්න වෙනස් කරන්න
urlbar-midi-notification-anchor =
    .tooltiptext = MIDI පැනලය විවෘත කරන්න
urlbar-eme-notification-anchor =
    .tooltiptext = DRM මෘදුකාංග භාවිතය කළමණාකරනය කරන්න
urlbar-canvas-notification-anchor =
    .tooltiptext = canvas උපුටාගැනීම් බලතල පාලනය කරන්න
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = ඔබේ මයික්‍රෆෝනය අඩවිය සමඟ බෙදාගැනීම කළමණාකරනය කරන්න
urlbar-default-notification-anchor =
    .tooltiptext = පණිවිඩ පුවරුව විවෘත කරන්න
urlbar-geolocation-notification-anchor =
    .tooltiptext = ස්ථානය ඉල්ලීමේ පුවරුව විවෘත කරන්න
urlbar-translate-notification-anchor =
    .tooltiptext = මෙම පිටුව පරිවර්තනය කරන්න
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = ඔබේ කවුළුව හෝ තිරය අඩවිය සමඟ බෙදාගැනීම කළමණාකරනය කරන්න
urlbar-indexed-db-notification-anchor =
    .tooltiptext = මාර්ගගත නොවන ගබඩා පණිවුඩ පැනලය විවෘත කරන්න
urlbar-password-notification-anchor =
    .tooltiptext = සුරැකි මුරපද පණිවිඩ පුවරුව විවෘත කරන්න
urlbar-translated-notification-anchor =
    .tooltiptext = පිටු පරිවර්තනය කළමණාකරනය කරන්න
urlbar-plugins-notification-anchor =
    .tooltiptext = ප්ලගින භාවිතය පාලනය කරන්න
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = ඔබේ කැමරාව හා/හෝ මයික්‍රෆෝනය අඩවිය සමඟ බෙදාගැනීම කළමණාකරනය කරන්න
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = අනවරත ගබඩාවේ දත්ත ගබඩා කරන්න
urlbar-addons-notification-anchor =
    .tooltiptext = ඇඩෝන ස්ථාපනය කිරීමේ පණිවිඩ පුවරුව විවෘත කරන්න

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".


## Local search mode indicator labels in the urlbar


##

urlbar-geolocation-blocked =
    .tooltiptext = ඔබ මෙම අඩවිය සඳහා ස්ථානීය තොරතුරු අවහිර කර ඇත.
urlbar-web-notifications-blocked =
    .tooltiptext = ඔබ මෙම අඩවිය සඳහා දැනුම්දීම් අවහිර කර ඇත.
urlbar-camera-blocked =
    .tooltiptext = ඔබ මෙම අඩවියට ඔබගේ කැමරාව අවහිර කර ඇත.
urlbar-microphone-blocked =
    .tooltiptext = ඔබ මෙම අඩවියට ඔබගේ මයික්‍රෆෝනය අවහිර කර ඇත.
urlbar-screen-blocked =
    .tooltiptext = ඔබ මෙම අඩවිය ඔබගේ තිරය හවුල්කිරීම අවහිර කර ඇත.
urlbar-persistent-storage-blocked =
    .tooltiptext = ඔබ මෙම අඩවිය සඳහා අනවරත ගබඩාව අවහිර කර ඇත.
urlbar-popup-blocked =
    .tooltiptext = ඔබ මෙම අඩවිය සඳහා පොප්-අප් වළක්වා ඇත.
urlbar-midi-blocked =
    .tooltiptext = ඔබ මෙම වෙබ්අඩවියට MIDI පිවිසුම අවහිර කර ඇත.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = මෙම පිටු සලකුණ සකසන්න ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = පිටු සලකුණු කරන්න ({ $shortcut })

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = ලිපින තීරුවට එක් කරන්න
page-action-manage-extension =
    .label = දිගුව පාලනය කරන්න…
page-action-remove-from-urlbar =
    .label = ලිපින තීරුවෙන් ඉවත් කරන්න

## Auto-hide Context Menu

full-screen-autohide =
    .label = මෙවලම් තීරු සඟවන්න
    .accesskey = H
full-screen-exit =
    .label = පූර්ණතිර ආකාරයෙන් ඉවත් වන්න
    .accesskey = F

## Search Engine selection buttons (one-offs)

# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = සෙවුම් සැකසුම් වෙනස් කරන්න
search-one-offs-change-settings-compact-button =
    .tooltiptext = සෙවුම් සිටුවම් වෙනස් කරන්න
search-one-offs-context-open-new-tab =
    .label = නව ටැබයක සොයන්න
    .accesskey = T
search-one-offs-context-set-as-default =
    .label = පෙරනිමි සෙවුම් එළවුම ලෙස තබන්න
    .accesskey = D

## Local search mode one-off buttons
## Variables:
##  $restrict (String): The restriction token corresponding to the search mode.
##    Restriction tokens are special characters users can type in the urlbar to
##    restrict their searches to certain sources (e.g., "*" to search only
##    bookmarks).


## Bookmark Panel

bookmark-panel-done-button =
    .label = කළා

## Identity Panel

identity-connection-internal = මෙය ආරක්ෂිත { -brand-short-name } පිටුවකි.
identity-connection-file = මෙම පිටුව ඔබේ පරිගණකයේ ගබඩා කර ඇත.
identity-extension-page = මෙම පිටුව දිගුවක් මගින් පූරණය වේ.
identity-active-blocked = ආරක්ෂිත නොවන නිසා මෙම පිටුවේ කොටස් { -brand-short-name } අවහිර කර ඇත.
identity-passive-loaded = මෙම පිටුවේ (පිංතූර වැනි) කොටස් ආරක්ෂිත නැත.
identity-active-loaded = මෙම පිටුව සඳහා ආරක්ෂාව ඔබ විසින් බල රහිත කර ඇත.
identity-weak-encryption = මෙම පිටුව දුර්වල සංකේතනයක් භාවිතා කරයි.
identity-insecure-login-forms = මෙම පිටුවට යොදන ප්‍රවේශ තොරතුරු නිසා ව්‍යකූලවීම් සිදුවිය හැකිය.
identity-permissions-reload-hint = වෙනස්කම් යෙදවීම සඳහා ඔබට පිටුව යළි පූරණය කිරීමට සිදුවිය හැක.
identity-permissions-empty = ඔබ මෙම අඩවියට විශෙෂිත අවසර ලබා දී නැත.
identity-clear-site-data =
    .label = කුකී සහ අඩවි දත්ත හිස් කරන්න...
identity-remove-cert-exception =
    .label = හැර දැමීම ඉවත් කරන්න
    .accesskey = R
identity-description-insecure = මෙම පිටුවට වූ ඔබේ සම්බන්ධතාවය පෞද්ගලික නොවේ. ඔබ ලබාදෙන තොරතුරු වෙනත් අයෙකු බැලීමට ඉඩ ඇත (රහස්පද, පණිවුඩ, ණය කාඩ්පත් ආදී..).
identity-description-insecure-login-forms = මෙම පිටුවට යොදන ප්‍රවේශ තොරතුරු ආරක්ෂිත නොවන නිසා ව්‍යකූලවීම් සිදුවිය හැකිය.
identity-description-weak-cipher-intro = මෙම පිටුවට වන ඔබේ සම්බන්ධතාවය දුර්වල සංකේතනයක් භාවිතා කරයි එසේම එය පෞද්ගලික නොවේ.
identity-description-weak-cipher-risk = වෙනත් අයෙකු ඔබගේ තොරතුරු බැලීම හෝ වෙබ් අඩවියේ තොරතුරු වෙනස් කිරීම විය හැකිය.
identity-description-active-blocked = ආරක්ෂිත නොවන නිසා මෙම පිටුවේ කොටස් { -brand-short-name } අවහිර කර ඇත <label data-l10n-name="link">තවත් දැනගන්න</label>
identity-description-passive-loaded = ඔබගේ සම්බන්ධතාවය පෞද්ගලික නොවන නිසා ඔබ ඇතුළත් කරන් තොරතුරු වෙනත් අය බැලීමට ඉඩ ඇත.
identity-description-passive-loaded-insecure = මෙම පිටුවේ ආරක්ෂිත නොවන (පිංතූර වැනි) කොටස් අඩංගුය. <label data-l10n-name="link">තවත් දැනගන්න</label>
identity-description-passive-loaded-mixed = { -brand-short-name } සමහර කොටස් අවහිර කළද තවමත් ආරක්ෂිත නොවන (පිංතූර වැනි) කොටස් අඩංගු විය හැකිය. <label data-l10n-name="link">තවත් දැනගන්න</label>
identity-description-active-loaded = මෙම පිටුවේ ආරක්ෂිත නොවන (scripts වැනි) කොටස් අඩංගුය එසේම ඔබගේ සම්බන්ධතාවය පෞද්ගලික නොවේ.
identity-description-active-loaded-insecure = මෙම අඩවියට ඔබ ලබාදෙන තොරතුරු වෙනත් අයෙකු බැලීමට ඉඩ ඇත (රහස්පද, පණිවුඩ, ණය කාඩ්පත් ආදී..).
identity-learn-more =
    .value = තවත් දැනගන්න
identity-disable-mixed-content-blocking =
    .label = දැනට ආරක්සහාව අකරිය කරන්න
    .accesskey = D
identity-enable-mixed-content-blocking =
    .label = ආරක්ෂණය සක්‍රීය කරන්න
    .accesskey = E
identity-more-info-link-text =
    .label = බොහෝ තොරතුරු

## Window controls

browser-window-minimize-button =
    .tooltiptext = හකුළන්න
browser-window-close-button =
    .tooltiptext = වසන්න

## WebRTC Pop-up notifications

popup-select-camera =
    .value = බෙදාගන්නා කැමරාව:
    .accesskey = C
popup-select-microphone =
    .value = බෙදාගන්නා මයික්‍රෆෝනය
    .accesskey = M
popup-all-windows-shared = ඔබේ තිරයේ දිස්වෙන සියළු කවුළු බෙදාගැනෙනු ඇත.

## WebRTC window or screen share tab switch warning


## DevTools F12 popup


## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = ලිපිනය සොයන්න හෝ ඇතුලත් කරන්න
urlbar-placeholder =
    .placeholder = ලිපිනය සොයන්න හෝ ඇතුලත් කරන්න
urlbar-remote-control-notification-anchor =
    .tooltiptext = ගවේශකය දුරස්ථ පාලනයේ පවතී
urlbar-switch-to-tab =
    .value = ටැබයට මාරුවෙන්න:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = දිගුව:
urlbar-go-button =
    .tooltiptext = පිහිටුම් තීරුවේ තුළ ඇති ලිපිනට යන්න
urlbar-page-action-button =
    .tooltiptext = පිටු ක්‍රියාවන්

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> දැන් පූර්ණ තිරයේ
fullscreen-warning-no-domain = මෙම ලේඛනය දැන් පූර්ණ තිරයේ
fullscreen-exit-button = පූර්ණ තිරයෙන් පිටවන්න (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = පූර්ණ තිරයෙන් පිටවන්න (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> හට ඔබගේ දක්වනයේ පාලනය පවතී. පාලනය නැවත ලැබීමට Esc ඔබන්න.
pointerlock-warning-no-domain = මෙම ලේඛනය හට ඔබගේ දක්වනයේ පාලනය පවතී. පාලනය නැවත ලැබීමට Esc ඔබන්න.
