# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = ಇತಿಹಾಸವನ್ನು ಅಳಿಸಿಹಾಕಲು ಅಗತ್ಯವಿರುವ ಸಿದ್ಧತೆಗಳು
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = ಇತ್ತೀಚಿನ ಇತಿಹಾಸವನ್ನು ಅಳಿಸಿ ಹಾಕು
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = ಎಲ್ಲಾ ಇತಿಹಾಸವನ್ನು ಅಳಿಸಿಹಾಕು
    .style = width: 34em

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = ಅಳಿಸಬೇಕಿರುವ ಸಮಯದ ವ್ಯಾಪ್ತಿ:{ " " }
    .accesskey = T

clear-time-duration-value-last-hour =
    .label = ಕೊನೆಯ ಗಂಟೆ

clear-time-duration-value-last-2-hours =
    .label = ಕೊನೆಯ ಎರಡು ಗಂಟೆಗಳು

clear-time-duration-value-last-4-hours =
    .label = ಕೊನೆಯ ನಾಲ್ಕು ಗಂಟೆಗಳು

clear-time-duration-value-today =
    .label = ಇಂದು

clear-time-duration-value-everything =
    .label = ಎಲ್ಲವೂ

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = ಇತಿಹಾಸ

item-history-and-downloads =
    .label = ಜಾಲವೀಕ್ಷಣೆ ಹಾಗು ಡೌನ್‌ಲೋಡ್ ಇತಿಹಾಸ
    .accesskey = B

item-cookies =
    .label = ಕುಕಿಗಳು
    .accesskey = C

item-active-logins =
    .label = ಸಕ್ರಿಯ ಲಾಗಿನ್‌ಗಳು
    .accesskey = L

item-cache =
    .label = ಕ್ಯಾಶೆ
    .accesskey = a

item-form-search-history =
    .label = ಫಾರ್ಮ್ ಹಾಗು ಹುಡುಕು ಇತಿಹಾಸ
    .accesskey = F

data-section-label = ಮಾಹಿತಿ

item-site-preferences =
    .label = ತಾಣದ ಆದ್ಯತೆಗಳು
    .accesskey = S

item-offline-apps =
    .label = ಆಫ್‌ಲೈನ್‌ನಲ್ಲಿ ಜಾಲತಾಣದ ಮಾಹಿತಿ
    .accesskey = O

sanitize-everything-undo-warning = ಈ ಕಾರ್ಯವನ್ನು ರದ್ದುಗೊಳಿಸಲು ಸಾಧ್ಯವಿರುವುದಿಲ್ಲ.

window-close =
    .key = w

sanitize-button-ok =
    .label = ಈಗಲೆ ಅಳಿಸು

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = ಸ್ವಚ್ಛಗೊಳಿಸಲಾಗುತ್ತಿದೆ

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = ಎಲ್ಲಾ ಇತಿಹಾಸವನ್ನು ಅಳಿಸಿಹಾಕಲಾಗುತ್ತದೆ.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = ಆಯ್ಕೆ ಮಾಡಲಾದ ಎಲ್ಲಾ ಇತಿಹಾಸವನ್ನು ಅಳಿಸಿಹಾಕಲಾಗುತ್ತದೆ.
