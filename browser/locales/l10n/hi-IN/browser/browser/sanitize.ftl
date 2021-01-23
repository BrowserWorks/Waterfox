# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = इतिहास साफ करने के लिए सेटिंग
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = हालिया इतिहास साफ करें
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = सभी इतिहास साफ करें
    .style = width: 34em

clear-data-settings-label = जब बंद हो, { -brand-short-name } को सभी चीजें मिटा देनी चाहिए

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = साफ करने लिए समय दायरा:{ " " }
    .accesskey = T

clear-time-duration-value-last-hour =
    .label = पिछला एक घंटा

clear-time-duration-value-last-2-hours =
    .label = अंतिम दो घंटे

clear-time-duration-value-last-4-hours =
    .label = अंतिम चार घंटे

clear-time-duration-value-today =
    .label = आज

clear-time-duration-value-everything =
    .label = सबकुछ

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = इतिहास

item-history-and-downloads =
    .label = ब्राउज़िंग और डाउनलोड इतिहास
    .accesskey = B

item-cookies =
    .label = कुकीज़
    .accesskey = C

item-active-logins =
    .label = सक्रिय लॉगिन
    .accesskey = L

item-cache =
    .label = कैश
    .accesskey = a

item-form-search-history =
    .label = खोज इतिहास से
    .accesskey = F

data-section-label = आँकड़ा

item-site-preferences =
    .label = साइट वरीयताएँ
    .accesskey = S

item-offline-apps =
    .label = ऑफ़ाइल वेबसाइट आँकड़ा
    .accesskey = O

sanitize-everything-undo-warning = इस क्रिया को पहले जैसा नहीं किया जा सकता है.

window-close =
    .key = w

sanitize-button-ok =
    .label = अब साफ करें

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = साफ किया जा रहा है

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = सभी इतिहास साफ किए जाएँगे.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = सभी चुने गए मद साफ किए जाएँगे.
