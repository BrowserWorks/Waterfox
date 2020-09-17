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
    .data-title-private = { -brand-full-name } (ಖಾಸಗಿ ವೀಕ್ಷಣೆ)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (ಖಾಸಗಿ ವೀಕ್ಷಣೆ)
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
    .data-title-private = { -brand-full-name } - (ಖಾಸಗಿ ವೀಕ್ಷಣೆ)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (ಖಾಸಗಿ ವೀಕ್ಷಣೆ)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = ತಾಣದ ಮಾಹಿತಿಯನ್ನು ನೋಡಿ

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = ಸ್ಥಾಪನಾ ಸಂದೇಶ ಹಲಗೆಯನ್ನು ತೆರೆಯಿರಿ
urlbar-web-notification-anchor =
    .tooltiptext = ತಾಣದಿಂದ ನೀವು ಸೂಚನೆಗಳನ್ನು ಪಡೆಯಬೇಕೆ ಅಥವ ಬೇಡವೆ ಎನ್ನುವುದನ್ನು ಬದಲಾಯಿಸಿ
urlbar-eme-notification-anchor =
    .tooltiptext = DRM ತಂತ್ರಾಂಶವನ್ನು ನಿರ್ವಹಿಸಿ
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = ಈ ತಾಣದೊಂದಿಗೆ ನಿಮ್ಮ ಮೈಕ್ರೊಫೋನ್‌ ಅನ್ನು ಹಂಚಿಕೊಳ್ಳುವುದನ್ನು ನಿರ್ವಹಿಸಿ
urlbar-default-notification-anchor =
    .tooltiptext = ಸಂದೇಶಗಳ ಪಟ್ಟಿ ತೆರೆ
urlbar-geolocation-notification-anchor =
    .tooltiptext = ಸ್ಥಳವನ್ನು ಕೋರುವ ಹಲಗೆಯನ್ನು ತೆರೆಯಿರಿ
urlbar-translate-notification-anchor =
    .tooltiptext = ಈ ಪುಟವನ್ನು ಅನುವಾದಿಸು
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = ನಿಮ್ಮ ಕಿಟಿಗಳನ್ನು ಅಥವ ತೆರೆಯನ್ನು ತಾಣದೊಂದಿಗೆ ಹಂಚಿಕೊಳ್ಳುವುದನ್ನು ನಿರ್ವಹಿಸಿ
urlbar-indexed-db-notification-anchor =
    .tooltiptext = ಆಫ್‌ಲೈನ್ ಶೇಖರಣಾ ಸಂದೇಶ ಹಲಗೆಯನ್ನು ತೆರೆಯಿರಿ
urlbar-password-notification-anchor =
    .tooltiptext = ಗುಪ್ತಪದ ಉಳಿಸುವ ಸಂದೇಶ ಹಲಗೆಯನ್ನು ತೆರೆಯಿರಿ
urlbar-translated-notification-anchor =
    .tooltiptext = ಪುಟದ ಅನುವಾದವನ್ನು ನಿರ್ವಹಿಸಿ
urlbar-plugins-notification-anchor =
    .tooltiptext = ಪ್ಲಗ್‌ಇನ್‌ಗಳ ಬಳಕೆಯನ್ನು ನಿರ್ವಹಿಸಿ
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = ನಿಮ್ಮ ಕ್ಯಾಮೆರಾ ಮತ್ತು ಮೈಕ್ರೊಫೋನ್ ಅನ್ನು ನೀವು ಪ್ರಸಕ್ತ ಹಂಚಿಕೊಂಡಿರುವ ತಾಣಗಳನ್ನು ತೋರಿಸು
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = ಪರ್ಸಿಸ್‌ಟೆಂಟ್ ಶೇಖರಣೆಯಲ್ಲಿ ದತ್ತಾಂಶವನ್ನು ಶೇಖರಿಸಿ
urlbar-addons-notification-anchor =
    .tooltiptext = ಆಡ್-ಆನ್ ಸ್ಥಾಪನಾ ಸಂದೇಶ ಹಲಗೆಯನ್ನು ತೆರೆಯಿರಿ

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".


## Local search mode indicator labels in the urlbar


##

urlbar-geolocation-blocked =
    .tooltiptext = ನಿಮ್ಮ ಸ್ಥಳದ ಮಾಹಿತಿಯನ್ನು ಈ ಜಾಲತಾಣದಲ್ಲಿ ನಿರ್ಬಂಧಿಸಿದ್ದೀರಿ.
urlbar-web-notifications-blocked =
    .tooltiptext = ನೀವು ಅಧಿಸೂಚನೆಗಳನ್ನು ಈ ಜಾಲತಾಣಕ್ಕೆ ನಿರ್ಬಂಧಿಸಿದ್ದೀರಿ.
urlbar-camera-blocked =
    .tooltiptext = ನಿಮ್ಮ ಕ್ಯಾಮರವನ್ನು ಈ ಜಾಲತಾಣದಲ್ಲಿ ನಿರ್ಬಂಧಿಸಿದ್ದೀರಿ.
urlbar-microphone-blocked =
    .tooltiptext = ನಿಮ್ಮ ಮೈಕ್ರೋಫೋನ್ಅನ್ನು ಈ ಜಾಲತಾಣದಲ್ಲಿ ನಿರ್ಬಂಧಿಸಿದ್ದೀರಿ.
urlbar-screen-blocked =
    .tooltiptext = ನಿಮ್ಮ ಪರದೆಯನ್ನು ಈ ಜಾಲತಾಣದಲ್ಲಿ ಹಂಚಿಕೊಳ್ಳದಂತೆ ನಿರ್ಬಂಧಿಸಿದ್ದೀರಿ.
urlbar-persistent-storage-blocked =
    .tooltiptext = ಪರ್‌ಸಿಸ್‌ಟೆಂಟ್ ಶೇಖರಣೆಯನ್ನು ನೀವು ಈ ಜಾಲತಾಣಕ್ಕೆ ನಿರ್ಬಂಧಿಸಿದ್ದೀರಿ.
urlbar-popup-blocked =
    .tooltiptext = ನೀವು ಪಾಪ್-ಅಪ್ ಗಳನ್ನು ಈ ಜಾಲತಾಣದಲ್ಲಿ ನಿರ್ಬಂಧಿಸಿದ್ದೀರಿ.
urlbar-canvas-blocked =
    .tooltiptext = ಕ್ಯಾನ್ವಸ್ ದತ್ತಾಂಶ ಶೇಖರಿಸುವುದನ್ನು ಈ ಜಾಲತಾಣಕ್ಕೆ ನೀವು ನಿರ್ಬಂಧಿಸಿದ್ದೀರಿ.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = ಈ ಬುಕ್‌ಮಾರ್ಕನ್ನು ತಿದ್ದು ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = ಈ ಪುಟವನ್ನು ಬುಕ್‌ಮಾರ್ಕ್ ಮಾಡು ({ $shortcut })

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = ವಿಳಾಸದ ಪಟ್ಟಿಗೆ ಸೇರಿಸಿ
page-action-manage-extension =
    .label = ವಿಸ್ತರಣೆಯನ್ನು ನಿರ್ವಹಿಸಿ…
page-action-remove-from-urlbar =
    .label = ವಿಳಾಸದ ಪಟ್ಟಿಯಿಂದ ತೆಗೆಯಿರಿ

## Auto-hide Context Menu

full-screen-autohide =
    .label = ಉಪಕರಣಪಟ್ಟಿಗಳನ್ನು ಅಡಗಿಸು
    .accesskey = H
full-screen-exit =
    .label = ಪೂರ್ಣತೆರೆಯ ವಿಧಾನದಿಂದ ಹೊರನಡೆ
    .accesskey = F

## Search Engine selection buttons (one-offs)

# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = ಹುಡುಕು ಸಿದ್ಧತೆಗಳನ್ನು ಬದಲಾಯಿಸು
search-one-offs-change-settings-compact-button =
    .tooltiptext = ‍ಹುಡುಕು ಸಿದ್ಧತೆಗಳನ್ನು ಬದಲಾಯಿಸು
search-one-offs-context-open-new-tab =
    .label = ಹೊಸ ಹಾಳೆಯಲ್ಲಿ ಹುಡುಕು
    .accesskey = T
search-one-offs-context-set-as-default =
    .label = ಪೂರ್ವನಿಯೋಜಿತ ಹುಡುಕು ಎಂಜಿನ್‌ ಆಗಿ ಹೊಂದಿಸು
    .accesskey = D

## Local search mode one-off buttons
## Variables:
##  $restrict (String): The restriction token corresponding to the search mode.
##    Restriction tokens are special characters users can type in the urlbar to
##    restrict their searches to certain sources (e.g., "*" to search only
##    bookmarks).


## Bookmark Panel

bookmark-panel-done-button =
    .label = ಆಯಿತು

## Identity Panel

identity-connection-internal = ಇದು ಸುರಕ್ಷಿತ { -brand-short-name } ಪುಟ
identity-connection-file = ನಿಮ್ಮ ಗಣಕದಲ್ಲಿ ಈ ಪುಟವನ್ನು ಶೇಖರಿಸಿಡಲಾಗಿದೆ.
identity-active-blocked = ಈ ಪುಟದ ಸುರಕ್ಷಿತವಲ್ಲದ ಕೆಲ ಭಾಗಗಳನ್ನು { -brand-short-name } ವು ನಿರ್ಬಂಧಿಸಿದೆ.
identity-passive-loaded = ಪುಟದ ಕೆಲ ಭಾಗಗಳು ಸುರಕ್ಷಿತವಾಗಿಲ್ಲ(ಉದಾ. ಚಿತ್ರಗಳು).
identity-active-loaded = ಈ ಪುಟದಲ್ಲಿ ಸುರಕ್ಷತೆಯನ್ನು ನೀವು ನಿಷ್ಕ್ರಿಯಗೊಳಿಸಿದ್ದೀರಿ.
identity-weak-encryption = ಈ ಪುಟವು ದುರ್ಬಲ ಎನ್‌ಕ್ರಿಪ್ಷನ್‌ ಅನ್ನು ಬಳಸುತ್ತದೆ.
identity-insecure-login-forms = ಈ ಪುಟದಲ್ಲಿ ನಮೂದಿಸಲಾದ ಲಾಗಿನ್‌ ವಿವರಗಳು ದುರ್ಬಳಕೆಯಾಗುವ ಸಾಧ್ಯತೆ ಇದೆ.
identity-permissions-reload-hint = ನಿಮ್ಮ ಬದಲಾವಣೆಗಳು ಕಾಣಿಸಿಕೊಳ್ಳಲು ನೀವು ಪುಟವನ್ನು ಪುನಃ ಲೋಡಮಾಡಬೇಕಾಗುತ್ತದೆ.
identity-permissions-empty = ನೀವು ಈ ತಾಣಕ್ಕೆ ಯಾವುದೆ ಅನುಮತಿಗಳನ್ನು ನೀಡಿಲ್ಲ.
identity-remove-cert-exception =
    .label = ಆಕ್ಷೇಪಣೆಯನ್ನು ತೆಗೆದುಹಾಕು
    .accesskey = R
identity-description-insecure = ಈ ತಾಣಕ್ಕೆ ನಿಮ್ಮ ಸಂಪರ್ಕವು ಗೌಪ್ಯವಾಗಿಲ್ಲ. ನೀವು ಇಲ್ಲಿ ಸಲ್ಲಿಸುವ ಮಾಹಿತಿಯನ್ನು ಇತರರು ನೋಡಬಹುದು (ಗುಪ್ತಪದಗಳು, ಸಂದೇಶಗಳು ಕ್ರೆಡಿಟ್ ಕಾರ್ಡ್‌ಗಳು, ಇತರೆ.)
identity-description-insecure-login-forms = ನೀವು ಇಲ್ಲಿ ದಾಖಲಿಸಿದ ಮಾಹಿತಿಯು ಸುರಕ್ಷಿತವಾಗಿರುವುದಿಲ್ಲ ಮತ್ತು ಅದನ್ನು ಇತರರು ನೋಡಬಹುದಾಗಿರುತ್ತದೆ.
identity-description-weak-cipher-intro = ಈ ಜಾಲತಾಣಕ್ಕೆ ನಿಮ್ಮ ಸಂಪರ್ಕವು ದುರ್ಬಲ ಎನ್‌ಕ್ರಿಪ್ಷನ್ ಅನ್ನು ಬಳಸುತ್ತದೆ ಮತ್ತು ಖಾಸಗಿಯಾಗಿಲ್ಲ.
identity-description-weak-cipher-risk = ಇತರೆ ವ್ಯಕ್ತಿಗಳು ನಿಮ್ಮ ಮಾಹಿತಿಯನ್ನು ನೋಡಬಹುದು ಅಥವಾ ಜಾಲತಾಣದ ವರ್ತನೆಯನ್ನು ಬದಲಾಯಿಸಬಹುದು.
identity-description-active-blocked = ಈ ಪುಟದ ಸುರಕ್ಷಿತವಲ್ಲದ ಕೆಲ ಭಾಗಗಳನ್ನು { -brand-short-name } ವು ನಿರ್ಬಂಧಿಸಿದೆ. <label data-l10n-name="link">ಇನ್ನಷ್ಟು ತಿಳಿಯಿರಿ</label>
identity-description-passive-loaded = ನಿಮ್ಮ ಸಂಪರ್ಕ ಖಾಸಗಿಯಾಗಿಲ್ಲ ಮತ್ತು ನೀವು ತಾಣದ ಜೊತೆ ಹಂಚಿಕೊಳ್ಳುವ ಮಾಹಿತಿಯನ್ನು ಇತರರು ನೋಡಬಹುದು.
identity-description-passive-loaded-insecure = ಈ ತಾಣವು ಸುರಕ್ಷಿತವಾಗಿಲ್ಲದ ಕೆಲವು ವಿಷಯಗಳನ್ನು ಒಳಗೊಂಡಿದೆ (ಉದಾ. ಚಿತ್ರಗಳು). <label data-l10n-name="link">ಇನ್ನಷ್ಟು ತಿಳಿಯಿರಿ</label>
identity-description-passive-loaded-mixed = { -brand-short-name } ವು ಸುರಕ್ಷಿತವಲ್ಲದ ವಿಷಯವನ್ನು ನಿರ್ಬಂಧಿಸಿದ್ದರೂ ಸಹ, ಪುಟವು ಸುರಕ್ಷಿತವಾಗಿಲ್ಲದ ವಿಷಯಗಳನ್ನು ಒಳಗೊಂಡಿದೆ (ಉದಾ. ಚಿತ್ರಗಳು). <label data-l10n-name="link">ಇನ್ನಷ್ಟು ತಿಳಿಯಿರಿ</label>
identity-description-active-loaded = ಈ ತಾಣವು ಸುರಕ್ಷಿತವಾಗಿಲ್ಲದ ಕೆಲವು ವಿಷಯಗಳನ್ನು ಒಳಗೊಂಡಿದೆ (ಉದಾ. ಸ್ಕ್ರಿಪ್ಟ್‌) ಮತ್ತು ನಿಮ್ಮ ಸಂಪರ್ಕ ಖಾಸಗಿಯಾದುದಲ್ಲ.
identity-description-active-loaded-insecure = ನೀವು ಈ ತಾಣದ ಜೊತೆ ಹಂಚಿಕೊಳ್ಳುವ ಮಾಹಿತಿಯನ್ನು ಇತರರು ನೋಡಬಹುದು (ಗುಪ್ತಪದಗಳು, ಸಂದೇಶಗಳು ಕ್ರೆಡಿಟ್ ಕಾರ್ಡ್‌ಗಳು, ಇತರೆ.
identity-learn-more =
    .value = ಇನ್ನಷ್ಟು ತಿಳಿಯಿರಿ
identity-disable-mixed-content-blocking =
    .label = ಸಂರಕ್ಷಣೆಯನ್ನು ಸಧ್ಯಕ್ಕೆ ನಿಷ್ಕ್ರಿಯಗೊಳಿಸು (D)
    .accesskey = D
identity-enable-mixed-content-blocking =
    .label = ಸಂರಕ್ಷಣೆಯನ್ನು ಸಕ್ರಿಯಗೊಳಿಸು
    .accesskey = E
identity-more-info-link-text =
    .label = ಹೆಚ್ಚಿನ ಮಾಹಿತಿ

## Window controls

browser-window-minimize-button =
    .tooltiptext = ಕುಗ್ಗಿಸು
browser-window-close-button =
    .tooltiptext = ಮುಚ್ಚು

## WebRTC Pop-up notifications

popup-select-camera =
    .value = ಹಂಚಬೇಕಿರುವ ಕ್ಯಾಮೆರಾ:
    .accesskey = C
popup-select-microphone =
    .value = ಹಂಚಲು ಮೈಕ್ರೊಫೋನ್:
    .accesskey = M
popup-all-windows-shared = ನಿಮ್ಮ ತೆರೆಯಲ್ಲಿರುವ ಎಲ್ಲಾ ಗೋಚರಿಸುವ ಕಿಟಕಿಗಳನ್ನು ಹಂಚಿಕೊಳ್ಳಲಾಗುತ್ತದೆ.

## WebRTC window or screen share tab switch warning


## DevTools F12 popup


## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = ವಿಳಾಸವನ್ನು ಹುಡುಕು ಅಥವಾ ನಮೂದಿಸು
urlbar-placeholder =
    .placeholder = ವಿಳಾಸವನ್ನು ಹುಡುಕು ಅಥವಾ ನಮೂದಿಸು
urlbar-remote-control-notification-anchor =
    .tooltiptext = ದೂರದಿಂದ ವೀಕ್ಷಕವು ನಿಮ್ಮ ಹಿಡಿತದಲ್ಲಿದೆ
urlbar-switch-to-tab =
    .value = ಟ್ಯಾಬ್‌ಗೆ ಬದಲಾಯಿಸು:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = ವಿಸ್ತರಣೆ:‍
urlbar-go-button =
    .tooltiptext = ಸ್ಥಿತಿ ಪಟ್ಟಿಯಲ್ಲಿನ ವಿಳಾಸಕ್ಕೆ ತೆರಳು
urlbar-page-action-button =
    .tooltiptext = ಪುಟದ ಕಾರ್ಯಗಳು

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> ಈಗ ಪೂರ್ಣ ತೆರೆಯಲ್ಲಿದೆ
fullscreen-warning-no-domain = ಈ ದಸ್ತಾವೇಜು ಈಗ ಪೂರ್ಣ ತೆರೆಯಲ್ಲಿದೆ
fullscreen-exit-button = ಪೂರ್ಣತೆರೆಯಿಂದ ನಿರ್ಗಮಿಸು (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = ಪೂರ್ಣತೆರೆಯಿಂದ ನಿರ್ಗಮಿಸು (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> ಯು ನಿಮ್ಮ ಪಾಯಿಂಟರ್‍‍ನ ನಿಯಂತ್ರಣ ಹೊಂದಿದೆ. ನಿಯಂತ್ರಣ ಹಿಂಪಡೆಯಲು ಎಸ್ಕೇಪ್ ಪ್ರೆಸ್ ಮಾಡಿ.
pointerlock-warning-no-domain = ಈ ದಸ್ತಾವೇಜು ನಿಮ್ಮ ಪಾಯಿಂಟರ್‍‍ನ ನಿಯಂತ್ರಣ ಹೊಂದಿದೆ. ನಿಯಂತ್ರಣ ಹಿಂಪಡೆಯಲು ಎಸ್ಕೇಪ್ ಪ್ರೆಸ್ ಮಾಡಿ.
