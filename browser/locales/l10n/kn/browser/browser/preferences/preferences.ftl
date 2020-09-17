# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

do-not-track-description = ನೀವು ಟ್ರ್ಯಾಕ್ ಮಾಡಲು ಬಯಸದ ಜಾಲತಾಣಗಳಿಗೆ "ಡು ನಾಟ್ ಟ್ರ್ಯಾಕ್" ಸಿಗ್ನಲ್ ಅನ್ನು ಕಳುಹಿಸಿ
do-not-track-learn-more = ಇನ್ನಷ್ಟು ತಿಳಿಯಿರಿ
do-not-track-option-always =
    .label = ಯಾವಾಗಲೂ

pref-page-title =
    { PLATFORM() ->
        [windows] ಆಯ್ಕೆಗಳು
       *[other] ಆದ್ಯತೆಗಳು
    }

# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-input-box =
    .style = width: 15.4em
    .placeholder =
        { PLATFORM() ->
            [windows] ಆಯ್ಕೆಗಳಲ್ಲಿ ಹುಡುಕು
           *[other] ಆದ್ಯತೆಗಳಲ್ಲಿ ಹುಡುಕು
        }

pane-general-title = ಸಾಮಾನ್ಯ
category-general =
    .tooltiptext = { pane-general-title }

pane-home-title = ಮನೆ
category-home =
    .tooltiptext = { pane-home-title }

pane-search-title = ಹುಡುಕು
category-search =
    .tooltiptext = { pane-search-title }

pane-privacy-title = ಗೋಪ್ಯತೆ & ಸುರಕ್ಷತೆ
category-privacy =
    .tooltiptext = { pane-privacy-title }

help-button-label = { -brand-short-name } ಸಹಾಯ

focus-search =
    .key = f

close-button =
    .aria-label = ಮುಚ್ಚು

## Browser Restart Dialog

feature-enable-requires-restart = ಈ ಸೌಲಭ್ಯವನ್ನು ಸಕ್ರಿಯಗೊಳಿಸಲು { -brand-short-name } ಅನ್ನು ಮರಳಿ ಆರಂಭಿಸಬೇಕು.
feature-disable-requires-restart = ಈ ಸೌಲಭ್ಯವನ್ನು ನಿಷ್ಕ್ರಿಯಗೊಳಿಸಲು { -brand-short-name } ಅನ್ನು ಮರಳಿ ಆರಂಭಿಸಬೇಕು.
should-restart-title = { -brand-short-name } ಅನ್ನು ಮರು ಆರಂಭಿಸು
should-restart-ok = ಈಗ { -brand-short-name } ಮರಳಿ ಆರಂಭಿಸು
cancel-no-restart-button = ರದ್ದು ಮಾಡು
restart-later = ಆಮೇಲೆ ಮರು ಆರಂಭಿಸು

## Extension Control Notifications
##
## These strings are used to inform the user
## about changes made by extensions to browser settings.
##
## <img data-l10n-name="icon"/> is going to be replaced by the extension icon.
##
## Variables:
##   $name (String): name of the extension


## Preferences UI Search Results

search-results-header = ಹುಡುಕು ಫಲಿತಾಂಶಗಳು

search-results-help-link = ಸಹಾಯ ಬೇಕೆ? ಭೇಟಿ ಮಾಡಿ <a data-l10n-name="url">{ -brand-short-name } ಬೆಂಬಲ</a>

## General Section

startup-header = ಆರಂಭಿಕ

# { -brand-short-name } will be 'Firefox Developer Edition',
# since this setting is only exposed in Firefox Developer Edition
separate-profile-mode =
    .label = { -brand-short-name } ಅನ್ನು ಮತ್ತು Firefox ಅನ್ನು ಏಕಕಾಲಕ್ಕೆ ಚಲಾಯಿತಗೊಳ್ಳಲು ಅನುಮತಿಸಿ
use-firefox-sync = ಸೂಚನೆ: ಇದು ಪ್ರತ್ಯೇಕ ಪ್ರೊಫೈಲ್‌ಗಳನ್ನು ಬಳಸುತ್ತದೆ. ಅವುಗಳ ನಡುವೆ ದತ್ತಾಂಶವನ್ನು ಹಂಚಿಕೊಳ್ಳಲು { -sync-brand-short-name } ಬಳಸಿ.
get-started-not-logged-in = { -sync-brand-short-name }ಗೆ ಸೈನ್-ಇನ್ ಆಗು…
get-started-configured = { -sync-brand-short-name } ಆದ್ಯತೆಗಳನ್ನು ತೆರೆ

always-check-default =
    .label = ಯಾವಾಗಲೂ { -brand-short-name } ನಿಮ್ಮ ಪೂರ್ವನಿಯೋಜಿತ ವೀಕ್ಷಕವಾಗಿದೆಯೆ ಎಂದು ಪರೀಕ್ಷಿಸಿ
    .accesskey = y

is-default = { -brand-short-name } ಎನ್ನುವುದು ಪ್ರಸ್ತುತ ನಿಮ್ಮ ಪೂರ್ವನಿಯೋಜಿತ ಜಾಲವೀಕ್ಷಕವಾಗಿದೆ
is-not-default = { -brand-short-name } ಪ್ರಸ್ತುತ ನಿಮ್ಮ ಪೂರ್ವನಿಯೋಜಿತ ವೀಕ್ಷಕವಾಗಿಲ್ಲ

set-as-my-default-browser =
    .label = ಪೂರ್ವನಿಯೋಜಿತವನ್ನಾಗಿ ಮಾಡು…
    .accesskey = D

startup-restore-previous-session =
    .label = ಹಿಂದಿನ ಅಧಿವೇಶನವನ್ನು ಮರಳಿ ಸ್ಥಾಪಿಸು
    .accesskey = s

disable-extension =
    .label = ಎಕ್ಸ್‌ಟೆನ್ಶನ್ ನಿಷ್ಕ್ರಿಯಗೊಳಿಸು

tabs-group-header = ಟ್ಯಾಬ್‌ಗಳು

ctrl-tab-recently-used-order =
    .label = Ctrl+Tab ಇತ್ತೀಚೆಗೆ ಬಳಸಿದ ಟ್ಯಾಬ್‍ಗಳನ್ನು ತಿರುಗಿಕೊಡುತ್ತದೆ
    .accesskey = T

open-new-link-as-tabs =
    .label = ಕೊಂಡಿಗಳನ್ನು ಹೊಸ ಕಿಟಕಿಯಲ್ಲಿ ತೆರೆಯುವ ಬದಲು ಹಾಳಯಗಳಲ್ಲಿ ತೆರೆಯಿರಿ
    .accesskey = w

warn-on-close-multiple-tabs =
    .label = ಅನೇಕ ಟ್ಯಾಬ್‌ಗಳನ್ನು ಮುಚ್ಚುವಾಗ ನನ್ನನ್ನು ಎಚ್ಚರಿಸು‍
    .accesskey = m

warn-on-open-many-tabs =
    .label = ಅನೇಕ ಹಾಳೆಗಳನ್ನು ತೆರೆಯುವುದಾಗ { -brand-short-name }ವನ್ನು ನಿಧಾನಗೊಂಡರೆ ನನ್ನನ್ನು ಎಚ್ಚರಿಸು
    .accesskey = d

switch-links-to-new-tabs =
    .label = ಹೊಸ ಹಾಳೆಯಲ್ಲಿ ನಾನು ಒಂದು ಕೊಂಡಿಯನ್ನು ತೆರೆದಾಗ, ತಕ್ಷಣ ಅದಕ್ಕೆ ಬದಲಾಯಿಸು
    .accesskey = h

show-tabs-in-taskbar =
    .label = ಹಾಳೆಗಳ ಮುನ್ನೋಟವನ್ನು ವಿಂಡೋಸ್ ಕಾರ್ಯಪಟ್ಟಿಕೆಯಲ್ಲಿ ತೋರಿಸು
    .accesskey = k

browser-containers-enabled =
    .label = ಕಂಟೈನರ್ ಟ್ಯಾಬ್ಸ್ ಸಕ್ರಿಯಗೊಳಿಸಿ
    .accesskey = n

browser-containers-learn-more = ಇನ್ನಷ್ಟು ತಿಳಿಯಿರಿ

browser-containers-settings =
    .label = ಸಿದ್ಧತೆಗಳು…‍
    .accesskey = i

containers-disable-alert-cancel-button = ಸಕ್ರಿಯವಾಗಿಯೇ ಇರಿಸಿ

containers-remove-alert-title = ಈ ಕಂಟೇನರ್ ತೆಗೆದುಹಾಕುವುದೇ?

containers-remove-ok-button = ಈ ಕಂಟೇನರ್ ತೆಗೆದುಹಾಕು
containers-remove-cancel-button = ಈ ಕಂಟೇನರ್ ತೆಗೆದುಹಾಕಬೇಡ


## General Section - Language & Appearance

language-and-appearance-header = ಭಾಷೆ ಮತ್ತು ನೋಟ

fonts-and-colors-header = ಅಕ್ಷರಶೈಲಿಗಳು ಮತ್ತು ಬಣ್ಣಗಳು

default-font = ಪೂರ್ವನಿಯೋಜಿತ ಅಕ್ಷರಶೈಲಿ
    .accesskey = D
default-font-size = ಗಾತ್ರ
    .accesskey = S

advanced-fonts =
    .label = ಮುಂದುವರೆದ...
    .accesskey = A

colors-settings =
    .label = ಬಣ್ಣಗಳು...
    .accesskey = C

language-header = ಭಾಷೆ

choose-language-description = ಪುಟಗಳನ್ನು ತೋರಿಸಲು ನಿಮ್ಮ ಬಯಕೆಯ ಭಾಷೆಯನ್ನು ಆರಿಸಿ

choose-button =
    .label = ಆರಿಸಿ…
    .accesskey = o

manage-browser-languages-button =
    .label = ಪರ್ಯಾಯಗಳನ್ನು ಹೊಂದಿಸಿ...
    .accesskey = l

translate-web-pages =
    .label = ಜಾಲದಲ್ಲಿನ ಕಂಟೆಂಟ್ ಅನ್ನು ಅನುವಾದಿಸು
    .accesskey = T

# The <img> element is replaced by the logo of the provider
# used to provide machine translations for web pages.
translate-attribution = ಅನುವಾದಿಸಿದವರು <img data-l10n-name="logo"/>

translate-exceptions =
    .label = ಹೊರತಾದವುಗಳು...
    .accesskey = x

## General Section - Files and Applications

files-and-applications-title = ಕಡತಗಳು ಮತ್ತು ಅನ್ವಯಕಗಳು

download-header = ಡೌನ್‍ಲೋಡ್‍ಗಳು

download-save-to =
    .label = ಕಡತಗಳನ್ನು ಇಲ್ಲಿ ಉಳಿಸು
    .accesskey = v

download-choose-folder =
    .label =
        { PLATFORM() ->
            [macos] ಆರಿಸು...
           *[other] ನೋಡು...
        }
    .accesskey =
        { PLATFORM() ->
            [macos] e
           *[other] o
        }

download-always-ask-where =
    .label = ಎಲ್ಲಿ ಉಳಿಸಬೇಕೆಂದು ಪ್ರತಿ ಬಾರಿಯೂ ನನ್ನನ್ನು ಕೇಳು
    .accesskey = A

applications-header = ಅನ್ವಯಗಳು

applications-filter =
    .placeholder = ಕಡತ ಬಗೆ ಅಥವಾ ಅನ್ವಯಗಳನ್ನು ಹುಡುಕು

applications-type-column =
    .label = ವಿಷಯದ ಬಗೆ
    .accesskey = T

applications-action-column =
    .label = ಕಾರ್ಯ
    .accesskey = A

# Variables:
#   $extension (String) - file extension (e.g .TXT)
applications-file-ending = { $extension } ಕಡತ
applications-action-save =
    .label = ಕಡತವನ್ನು ಉಳಿಸು

# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app =
    .label = { $app-name } ಅನ್ನು ಬಳಸು

# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app-default =
    .label = { $app-name } ಅನ್ನು ಬಳಸು (ಡೀಫಾಲ್ಟ್‍)

applications-use-other =
    .label = ಇನ್ನೊಂದನ್ನು ಬಳಸು…
applications-select-helper = ಸಹಾಯಕ ಅನ್ವಯವನ್ನು ಆರಿಸಿ

applications-manage-app =
    .label = ಅನ್ವಯ ವಿವರಗಳು…
applications-always-ask =
    .label = ಪ್ರತಿ ಬಾರಿಯೂ ಕೇಳು
applications-type-pdf = ಪೋರ್ಟೆಬಲ್ ಡಾಕ್ಯುಮೆಂಟ್ ಫಾರ್ಮ್ಯಾಟ್ (PDF)

# Variables:
#   $type (String) - the MIME type (e.g application/binary)
applications-type-pdf-with-type = { applications-type-pdf } ({ $type })

# Variables:
#   $type-description (String) - Description of the type (e.g "Portable Document Format")
#   $type (String) - the MIME type (e.g application/binary)
applications-type-description-with-type = { $type-description } ({ $type })

# Variables:
#   $plugin-name (String) - Name of a plugin (e.g Adobe Flash)
applications-use-plugin-in =
    .label = { $plugin-name } ಅನ್ನು ಬಳಸು ({ -brand-short-name } ನಲ್ಲಿ)

## The strings in this group are used to populate
## selected label element based on the string from
## the selected menu item.

applications-use-plugin-in-label =
    .value = { applications-use-plugin-in.label }

applications-action-save-label =
    .value = { applications-action-save.label }

applications-use-app-label =
    .value = { applications-use-app.label }

applications-always-ask-label =
    .value = { applications-always-ask.label }

applications-use-app-default-label =
    .value = { applications-use-app-default.label }

applications-use-other-label =
    .value = { applications-use-other.label }

##

play-drm-content-learn-more = ಇನ್ನಷ್ಟು ತಿಳಿಯಿರಿ

update-application-title = { -brand-short-name } ನವೀಕರಣಗಳು

update-application-version = ಆವೃತ್ತಿ{ $version } <a data-l10n-name="learn-more">ಹೊಸತೇನಿದೆ</a>

update-history =
    .label = ಅಪ್ಡೇಟ್ ಇತಿಹಾಸವನ್ನು ತೋರಿಸು…
    .accesskey = p

update-application-allow-description = { -brand-short-name } ಅನುಮತಿಸು

update-application-check-choose =
    .label = ಅಪ್‌ಡೇಟ್‌ಗಳಿಗಾಗಿ ಹುಡುಕುತ್ತದೆ, ಆದರೆ ಅವುಗಳನ್ನು ಅನುಸ್ಥಾಪಿಸುವ ಆಯ್ಕೆಯನ್ನು ನಿಮಗೆ ಬಿಡುತ್ತದೆ
    .accesskey = C

update-application-use-service =
    .label = ಅಪ್‌ಡೇಟ್‌ಗಳನ್ನು ಅನುಸ್ಥಾಪಿಸಲು ಹಿನ್ನಲೆ ಸೇವೆಯನ್ನು ಬಳಸು
    .accesskey = b

## General Section - Performance

performance-title = ಕಾರ್ಯಕ್ಷಮತೆ

performance-settings-learn-more = ಇನ್ನಷ್ಟು ತಿಳಿಯಿರಿ

performance-allow-hw-accel =
    .label = ಲಭ್ಯವಿದ್ದಾಗ ಯಂತ್ರಾಂಶ ವೇಗವರ್ಧನೆಯನ್ನು ಬಳಸು
    .accesskey = r

performance-limit-content-process-option = ಪರಿವಿಡಿ ಪ್ರಕ್ರೀಯೆ ಮಟ್ಟ
    .accesskey = L

# Variables:
#   $num - default value of the `dom.ipc.processCount` pref.
performance-default-content-process-count =
    .label = { $num } (ಪೂರ್ವನಿಯೋಜಿತ)

## General Section - Browsing

browsing-title = ವೀಕ್ಷಣೆ

browsing-use-autoscroll =
    .label = ಸ್ವಯಂಚಲನೆಯನ್ನು(ಆಟೋ ಸ್ಕ್ರಾಲಿಂಗ್) ಬಳಸು
    .accesskey = a

browsing-use-smooth-scrolling =
    .label = ಮೃದು ಚಲನೆಯನ್ನು ಬಳಸು
    .accesskey = m

browsing-use-onscreen-keyboard =
    .label = ಅಗತ್ಯಬಿದ್ದಾಗ ಒಂದು ಟಚ್ ಕೀಲಮಣೆಯನ್ನು ತೋರಿಸು
    .accesskey = k

browsing-use-cursor-navigation =
    .label = ಪುಟದಲ್ಲಿ ಸಂಚರಿಸಲು ಎಲ್ಲಾ ಸಮಯದಲ್ಲೂ ತೆರೆಸೂಚಕ ಕೀಲಿಗಳನ್ನು ಬಳಸು
    .accesskey = c

browsing-cfr-recommendations-learn-more = ಇನ್ನಷ್ಟು ತಿಳಿಯಿರಿ

## General Section - Proxy

network-settings-title = ನೆಟ್ವರ್ಕ್ ಸಿದ್ಧತೆಗಳು

network-proxy-connection-learn-more = ಇನ್ನಷ್ಟು ತಿಳಿಯಿರಿ

network-proxy-connection-settings =
    .label = ಸಿದ್ಧತೆಗಳು...
    .accesskey = e

## Home Section


## Home Section - Home Page Customization

home-newtabs-mode-label = ಹೊಸ ಟ್ಯಾಬ್ ಗಳು

home-mode-choice-blank =
    .label = ಖಾಲಿ ಪುಟ

home-homepage-custom-url =
    .placeholder = ವಿಳಾಸವನ್ನು ಅಂಟಿಸು...

# This string has a special case for '1' and [other] (default). If necessary for
# your language, you can add {$tabCount} to your translations and use the
# standard CLDR forms, or only use the form for [other] if both strings should
# be identical.
use-current-pages =
    .label =
        { $tabCount ->
            [1] ಈಗಿನ ಪುಟವನ್ನು ಬಳಸು
           *[other] ಈಗಿನ ಪುಟಗಳನ್ನು ಬಳಸು
        }
    .accesskey = C

choose-bookmark =
    .label = ಪುಟಗುರುತನ್ನು ಬಳಸು…
    .accesskey = B

## Home Section - Firefox Home Content Customization

home-prefs-content-header = ಫೈರ್ಫಾಕ್ಸ್ ಮುಖಪುಟದ ವಿಷಯ

home-prefs-search-header =
    .label = ಜಾಲದ ಹುಡುಕಾಟ
home-prefs-topsites-header =
    .label = ಪ್ರಮುಖ ತಾಣಗಳು

## Variables:
##  $provider (String): Name of the corresponding content provider, e.g "Pocket".

# Variables:
#  $provider (String): Name of the corresponding content provider, e.g "Pocket".
home-prefs-recommended-by-header =
    .label = { $provider } ರಿಂದ ಶಿಫಾರಸುಮಾಡುಲಾಗಿದೆ
##


home-prefs-recommended-by-learn-more = ಇದು ಹೇಗೆ ಕೆಲಸ ಮಾಡುತ್ತದೆ

home-prefs-highlights-header =
    .label = ಮುಖ್ಯಾಂಶಗಳು
home-prefs-highlights-option-visited-pages =
    .label = ಭೇಟಿಕೊಟ್ಟ ಪುಟಗಳು
home-prefs-highlights-options-bookmarks =
    .label = ಪುಟಗುರುತುಗಳು
home-prefs-highlights-option-most-recent-download =
    .label = ತೀರಾ ಇತ್ತೀಚಿನ ಡೌನ್ಲೋಡ್
home-prefs-highlights-option-saved-to-pocket =
    .label = { -pocket-brand-name } ನಲ್ಲಿ ಉಳಿಸಲಾದ ಪುಟಗಳು

# For the "Snippets" feature traditionally on about:home.
# Alternative translation options: "Small Note" or something that
# expresses the idea of "a small message, shortened from something else,
# and non-essential but also not entirely trivial and useless.
home-prefs-snippets-header =
    .label = ಉಲ್ಲೇಖಗಳು

## Search Section

search-bar-header = ಹುಡುಕು  ಪಟ್ಟಿ
search-bar-shown =
    .label = ಹುಡುಕು ಪಟ್ಟಿಯನ್ನು ಉಪಕರಣಪಟ್ಟಿಗೆ ಸೇರಿಸು

search-engine-default-header = ಪೂರ್ವನಿಯೋಜಿತ ಹುಡುಕು ಎಂಜಿನ್

search-suggestions-option =
    .label = search ಸಲಹೆಗಳನ್ನು ತೋರಿಸು
    .accesskey = s

search-suggestions-cant-show = ಎಂದಿಗೂ ಸಹ ಇತಿಹಾಸವನ್ನು ನೆನಪಿಟ್ಟುಕೊಳ್ಳಬೇಡ ಎಂದು ನೀವು { -brand-short-name } ಅನ್ನು ಸಂರಚಿಸಿರುವುದರಿಂದ ಹುಡುಕುವಾಗ ಸ್ಥಳದ ಪಟ್ಟಿಯ ಫಲಿತಾಂಶಗಳಲ್ಲಿ ಯಾವುದೆ ಸಲಹೆಗಳನ್ನು ತೋರಿಸಲಾಗುವುದಿಲ್ಲ.

search-one-click-header = ಏಕ-ಕ್ಲಿಕ್ ಹುಡುಕು ಎಂಜಿನ್‌ಗಳು

search-choose-engine-column =
    .label = ಹುಡುಕು ಎಂಜಿನ್‌
search-choose-keyword-column =
    .label = ಸೂಚಕ ಪದ

search-restore-default =
    .label = Default ಹುಡುಕು ಎಂಜಿನ್‌ಗಳನ್ನು ಮರುಹೊಂದಿಸು
    .accesskey = D

search-remove-engine =
    .label = Remove
    .accesskey = R

search-find-more-link = ಇನ್ನಷ್ಟು ಹುಡುಕು ಎಂಜಿನ್‌ಗಳನ್ನು ಹುಡುಕು

# This warning is displayed when the chosen keyword is already in use
# ('Duplicate' is an adjective)
search-keyword-warning-title = ಬಳಸಲ್ಪಟ್ಟ ಕೀಲಿಪದ
# Variables:
#   $name (String) - Name of a search engine.
search-keyword-warning-engine = "{ $name }" ನಿಂದ ಈಗಾಗಲೆ ಬಳಸಲ್ಪಡುತ್ತಿರುವ ಒಂದು ಕೀಲಿಪದವನ್ನು ಆಯ್ಕೆ ಮಾಡಿದ್ದೀರಿ. ದಯವಿಟ್ಟು ಬೇರೆಯದನ್ನು ಆಯ್ಕೆ ಮಾಡಿ.
search-keyword-warning-bookmark = ಒಂದು ಬುಕ್‌ಮಾರ್ಕಿನಿಂದ ಈಗಾಗಲೆ ಬಳಸಲ್ಪಡುತ್ತಿರುವ ಒಂದು ಕೀಲಿಪದವನ್ನು ಆಯ್ಕೆ ಮಾಡಿದ್ದೀರಿ. ದಯವಿಟ್ಟು ಬೇರೆಯದನ್ನು ಆಯ್ಕೆ ಮಾಡಿ.

## Containers Section

containers-header = ಕಂಟೈನರ್ ಟ್ಯಾಬ್‍‍ಗಳು‍
containers-add-button =
    .label = ಹೊಸ ಕಂಟೈನರ್ ಸೇರಿಸಿ
    .accesskey = A

containers-preferences-button =
    .label = ಆದ್ಯತೆಗಳು
containers-remove-button =
    .label = ತೆಗೆದುಹಾಕು

## Sync Section - Signed out


## Firefox Account - Signed out. Note that "Sync" and "Firefox Account" are now
## more discrete ("signed in" no longer means "and sync is connected").

sync-signedout-caption = ಜಾಲವನ್ನು ನಿಮ್ಮೊಂದಿಗೆ ಒಯ್ಯಿರಿ
sync-signedout-description = ನಿಮ್ಮ ಎಲ್ಲಾ ಸಾಧನಗಳ ಜೊತೆ ನಿಮ್ಮ ಪುಟಗುರುತುಗಳು, ಇತಿಹಾಸ, ಹಾಳೆ, ಪ್ರವೇಶ ಪದ, ಆಡ್-ಆನ್‌ಗಳು, ಮತ್ತು ಆದ್ಯತೆಗಳನ್ನು ಸಿಂಕ್ ಮಾಡಿ

# This message contains two links and two icon images.
#   `<img data-l10n-name="android-icon"/>` - Android logo icon
#   `<a data-l10n-name="android-link">` - Link to Android Download
#   `<img data-l10n-name="ios-icon">` - iOS logo icon
#   `<a data-l10n-name="ios-link">` - Link to iOS Download
#
# They can be moved within the sentence as needed to adapt
# to your language, but should not be changed or translated.
sync-mobile-promo = Firefox ಡೌನ್‌ಲೋಡ್ ಮಾಡಿ<img data-l10n-name="android-icon"/> <a data-l10n-name="android-link">Android</a> ಅಥವ <img data-l10n-name="ios-icon"/> <a data-l10n-name="ios-link">iOS</a> ನಿಮ್ಮ ಮೊಬೈಲ್ ಸಾಧನದ ಜೊತೆ ಸಿಂಕ್ ಮಾಡಲು.

## Sync Section - Signed in


## Firefox Account - Signed in

sync-profile-picture =
    .tooltiptext = ಪ್ರೊಫೈಲ್ ಚಿತ್ರವನ್ನು ಬದಲಾಯಿಸು

sync-manage-account = ಖಾತೆಯನ್ನು ನಿರ್ವಹಿಸು
    .accesskey = o

sync-signedin-unverified = { $email } ಪರಿಶೀಲಿಸಲಾಗಿಲ್ಲ.
sync-signedin-login-failure = ಮರಳಿ ಸಂಪರ್ಕಿತಗೊಳ್ಳಲು ದಯವಿಟ್ಟು ಸೈನ್‌ ಇನ್ ಆಗಿ { $email }

sync-remove-account =
    .label = ಖಾತೆಯನ್ನು ತೆಗೆದುಹಾಕು
    .accesskey = R

sync-sign-in =
    .label = ಒಳಗೆ ಪ್ರವೇಶಿಸು‍
    .accesskey = g

## Sync section - enabling or disabling sync.


## The list of things currently syncing.


## The "Choose what to sync" dialog.

sync-engine-bookmarks =
    .label = ಪುಟಗುರುತುಗಳು
    .accesskey = m

sync-engine-history =
    .label = ಇತಿಹಾಸ
    .accesskey = r

sync-engine-tabs =
    .label = ತೆರೆದ ಟ್ಯಾಬ್‌ಗಳು
    .tooltiptext = ಸಿಂಕ್ ಮಾಡಲಾದ ಸಾಧನಗಳಲ್ಲಿ ಏನನ್ನು ತೆರೆಯಲಾಗಿದೆಯೋ ಅವುಗಳ ಪಟ್ಟಿ
    .accesskey = t

## The device name controls.

sync-device-name-header = ಸಾಧನದ ಹೆಸರು

sync-device-name-change =
    .label = ಸಾಧನದ ಹೆಸರನ್ನು ಬದಲಿಸಿ…
    .accesskey = h

sync-device-name-cancel =
    .label = ರದ್ದು ಮಾಡು‍
    .accesskey = n

sync-device-name-save =
    .label = ಉಳಿಸು‍
    .accesskey = v

## Privacy Section

privacy-header = ವೀಕ್ಷಕದ ಗೌಪ್ಯತೆ

## Privacy Section - Forms


## Privacy Section - Logins and Passwords

forms-exceptions =
    .label = ವಿನಾಯಿತಿಗಳು...
    .accesskey = x

forms-saved-logins =
    .label = ಉಳಿಸಿದ ಲಾಗಿನ್‌ಗಳು...
    .accesskey = L
forms-master-pw-use =
    .label = ಒಂದು ಮಾಸ್ಟರ್ ಗುಪ್ತಪದವನ್ನು ಬಳಸು
    .accesskey = U
forms-master-pw-change =
    .label = ಮಾಸ್ಟರ್ ಗುಪ್ತಪದವನ್ನು ಬದಲಾಯಿಸು...
    .accesskey = M

forms-master-pw-fips-title = ನೀವು ಸದ್ಯಕ್ಕೆ FIPS ವಿಧಾನದಲ್ಲಿದ್ದೀರಿ. FIPS ಗೆ ಒಂದು ಖಾಲಿ ಇರದ ಮಾಸ್ಟರ್ ಗುಪ್ತಪದದ ಅಗತ್ಯವಿದೆ.

forms-master-pw-fips-desc = ಗುಪ್ತಪದವನ್ನು ಬದಲಾಯಿಸುವಲ್ಲಿ ವಿಫಲಗೊಂಡಿದೆ

## OS Authentication dialog

## Privacy Section - History

history-header = ಇತಿಹಾಸ

# This label is followed, on the same line, by a dropdown list of options
# (Remember history, etc.).
# In English it visually creates a full sentence, e.g.
# "Firefox will" + "Remember history".
#
# If this doesn't work for your language, you can translate this message:
#   - Simply as "Firefox", moving the verb into each option.
#     This will result in "Firefox" + "Will remember history", etc.
#   - As a stand-alone message, for example "Firefox history settings:".
history-remember-label = { -brand-short-name } ವು
    .accesskey = w

history-remember-option-all =
    .label = ಇತಿಹಾಸವನ್ನು ನೆನಪಿಟ್ಟುಕೊಳ್ಳುತ್ತದೆ
history-remember-option-never =
    .label = ಎಂದಿಗೂ ಇತಿಹಾಸವನ್ನು ನೆನಪಿಟ್ಟುಕೊಳ್ಳಬೇಡ
history-remember-option-custom =
    .label = ಇತಿಹಾಸಕ್ಕಾಗಿ ನಿಮ್ಮ ಇಚ್ಛೆಯ ಸಿದ್ಧತೆಗಳನ್ನು ಬಳಸಿ

history-dontremember-description = { -brand-short-name } ಖಾಸಗಿ ಜಾಲ ವೀಕ್ಷಣದ ರೀತಿಯದ್ದೆ ಆದ ಸಿದ್ಧತೆಗಳನ್ನು ಬಳಸುತ್ತದೆ, ಹಾಗು ನೀವು ಜಾಲವನ್ನು ವೀಕ್ಷಿಸುವಾಗ ಯಾವುದೆ ಇತಿಹಾಸವನ್ನು ನೆನಪಿಟ್ಟುಕೊಳ್ಳುವುದಿಲ್ಲ.

history-private-browsing-permanent =
    .label = ಯಾವಾಗಲೂ ಖಾಸಗಿ ವೀಕ್ಷಣೆ ಕ್ರಮವನ್ನು ಬಳಸು
    .accesskey = p

history-remember-search-option =
    .label = ಹುಡುಕು ಹಾಗು ಫಾರ್ಮ್ ಇತಿಹಾಸವನ್ನು ನೆನಪಿಟ್ಟುಕೊ
    .accesskey = f

history-clear-on-close-option =
    .label = { -brand-short-name } ಅನ್ನು ಮುಚ್ಚಿದಾಗ ಇತಿಹಾಸವನ್ನು ಅಳಿಸಿಹಾಕು
    .accesskey = r

history-clear-on-close-settings =
    .label = ಸಿದ್ಧತೆಗಳು…
    .accesskey = t

## Privacy Section - Site Data

sitedata-header = ಕುಕ್ಕಿಗಳು ಮತ್ತು ತಾಣ ದತ್ತಾಂಶ

sitedata-learn-more = ಇನ್ನಷ್ಟು ತಿಳಿಯಿರಿ

sitedata-clear =
    .label = ದತ್ತಾಂಶ ಬರಿದುಮಾಡು…
    .accesskey = l

sitedata-settings =
    .label = ದತ್ತಾಂಶವನ್ನು ನಿರ್ವಹಿಸು…
    .accesskey = M

## Privacy Section - Address Bar

addressbar-header = ವಿಳಾಸ ಪಟ್ಟಿ

addressbar-suggest = ವಿಳಾಸ ಪಟ್ಟಿಯನ್ನು ಬಳಸುವಾಗ, ಇದನ್ನು ಸಲಹೆ ಮಾಡು

addressbar-locbar-history-option =
    .label = ವೀಕ್ಷಣೆಯ ಇತಿಹಾಸ
    .accesskey = H
addressbar-locbar-bookmarks-option =
    .label = Bookmarks
    .accesskey = k
addressbar-locbar-openpage-option =
    .label = Open ಹಾಳೆಗಳು
    .accesskey = O

addressbar-suggestions-settings = ಹುಡುಕು ಯಂತ್ರಗಳ ಸಲಹೆಗಳ ಇಚ್ಛೆಗಳನ್ನು ಬದಲಾಯಿಸಿ

## Privacy Section - Content Blocking

content-blocking-learn-more = ಇನ್ನಷ್ಟು ತಿಳಿಯಿರಿ

## These strings are used to define the different levels of
## Enhanced Tracking Protection.


##

## Privacy Section - Tracking


## Privacy Section - Permissions

permissions-header = ಅನುಮತಿಗಳು

permissions-location = ಸ್ಥಳ
permissions-location-settings =
    .label = ಸಿದ್ಧತೆಗಳು…
    .accesskey = t

permissions-camera = ಕ್ಯಾಮೆರಾ
permissions-camera-settings =
    .label = ಸಿದ್ಧತೆಗಳು…
    .accesskey = t

permissions-microphone = ಮೈಕ್ರೊಫೋನ್
permissions-microphone-settings =
    .label = ಸಿದ್ಧತೆಗಳು…
    .accesskey = t

permissions-notification = ಸೂಚನೆಗಳು
permissions-notification-settings =
    .label = ಸಿದ್ಧತೆಗಳು…
    .accesskey = t
permissions-notification-link = ಇನ್ನಷ್ಟು ತಿಳಿಯಿರಿ

permissions-block-popups =
    .label = ಪುಟಿಕೆ (ಪಾಪ್-ಅಪ್) ಕಿಟಕಿಗಳನ್ನು ತಡೆ ಹಿಡಿ
    .accesskey = B

permissions-block-popups-exceptions =
    .label = ಹೊರತಾದವುಗಳು...
    .accesskey = E

permissions-addon-exceptions =
    .label = ವಿನಾಯಿತಿಗಳು...
    .accesskey = E

permissions-a11y-privacy-link = ಇನ್ನಷ್ಟು ತಿಳಿಯಿರಿ

## Privacy Section - Data Collection

collection-header = { -brand-short-name } ದತ್ತಾಂಶ ಸಂಗ್ರಹಣೆ ಮತ್ತು ಬಳಕೆ

collection-privacy-notice = ಗೌಪ್ಯತಾ ಸೂಚನೆ

collection-health-report-link = ಇನ್ನಷ್ಟು ತಿಳಿಯಿರಿ

collection-backlogged-crash-reports-link = ಇನ್ನಷ್ಟು ತಿಳಿಯಿರಿ

## Privacy Section - Security
##
## It is important that wording follows the guidelines outlined on this page:
## https://developers.google.com/safe-browsing/developers_guide_v2#AcceptableUsage

security-header = ಸುರಕ್ಷತೆ

security-enable-safe-browsing =
    .label = ಅಪಾಯಕಾರಿ ಮತ್ತು ವಂಚಕ ವಿಷಯಗಳನ್ನು ನಿರ್ಬಂಧಿಸಿ
    .accesskey = B
security-enable-safe-browsing-link = ಇನ್ನಷ್ಟು ತಿಳಿಯಿರಿ

security-block-downloads =
    .label = ಅಪಾಯಕಾರಿ ಡೌನ್‌ಲೋಡ್‌ಗಳನ್ನು ನಿರ್ಬಂಧಿಸಿ
    .accesskey = d

security-block-uncommon-software =
    .label = ಬೇಡವಾದ ಮತ್ತು ಸಾಮಾನ್ಯವಲ್ಲದ ತಂತ್ರಾಂಶಗಳ ಬಗ್ಗೆ ಎಚ್ಚರಿಸು‍‍‍‍
    .accesskey = ಸ

## Privacy Section - Certificates

certs-header = ಪ್ರಮಾಣಪತ್ರಗಳು

certs-personal-label = ಒಂದು ಪರಿಚಾರಕವು ನನ್ನ ಖಾಸಗಿ ಪ್ರಮಾಣಪತ್ರವನ್ನು ಅಪೇಕ್ಷಿಸಿದಾಗ

certs-select-auto-option =
    .label = ಸ್ವಯಂಚಾಲಿತವಾಗಿ ಒಂದನ್ನು ಆರಿಸು
    .accesskey = S‍

certs-select-ask-option =
    .label = ಪ್ರತಿ ಬಾರಿಯೂ ನನ್ನನ್ನು ಕೇಳು
    .accesskey = A‍

certs-enable-ocsp =
    .label = ಪ್ರಮಾಣಪತ್ರಗಳ ಪ್ರಸಕ್ತ ಮಾನ್ಯತೆಯನ್ನು ಖಚಿತಪಡಿಸಿಕೊಳ್ಳಲು OCSP ರೆಸ್ಪಾಂಡರ್ ಪೂರೈಕೆಗಣಕಗಳಿಗೆ ಮನವಿ ಮಾಡಿ
    .accesskey = Q

certs-view =
    .label = ಪ್ರಮಾಣಪತ್ರಗಳನ್ನು ನೋಡು…
    .accesskey = C

certs-devices =
    .label = ಸುರಕ್ಷತಾ ಸಾಧನಗಳು…
    .accesskey = D

space-alert-learn-more-button =
    .label = ಇನ್ನಷ್ಟು ತಿಳಿಯಿರಿ
    .accesskey = L

space-alert-over-5gb-pref-button =
    .label =
        { PLATFORM() ->
            [windows] ಆಯ್ಕೆಗಳನ್ನು ತೆರೆ
           *[other] ಆದ್ಯತೆಗಳನ್ನು ತೆರೆ
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] O
        }

space-alert-under-5gb-ok-button =
    .label = OK ಸರಿ, ಗೊತ್ತಾಯಿತು
    .accesskey = K

## Privacy Section - HTTPS-Only

## The following strings are used in the Download section of settings

desktop-folder-name = ಗಣಕತೆರೆ
downloads-folder-name = ಡೌನ್‌ಲೋಡ್‌ಗಳು
choose-download-folder-title = ಡೌನ್‌ಲೋಡ್‌ ಕಡತಕೋಶವನ್ನು ಆರಿಸು:

