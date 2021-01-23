# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = इतिहास मेट्नको लागि सेटिङ्
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = तत्कालको इतिहास खाली गर्नुहोस्
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = सबै इतिहास मेटाउनुहोस्
    .style = width: 34em

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = खाली गर्ने समय सीमा:
    .accesskey = T

clear-time-duration-value-last-hour =
    .label = अन्तिम घन्टा

clear-time-duration-value-last-2-hours =
    .label = अन्तिम दुइ घन्टा

clear-time-duration-value-last-4-hours =
    .label = अन्तिम चार घन्टा

clear-time-duration-value-today =
    .label = आज

clear-time-duration-value-everything =
    .label = हरेक चिज

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = इतिहास

item-history-and-downloads =
    .label = ब्राउजिङ्ग र इतिहास डाउनलोड
    .accesskey = B

item-cookies =
    .label = कुकिज
    .accesskey = C

item-active-logins =
    .label = सक्रिय .लग-इनहरू
    .accesskey = L

item-cache =
    .label = क्यास
    .accesskey = a

item-form-search-history =
    .label = फारम र इतिहास खोजी खोज्नुहोस्
    .accesskey = F

data-section-label = डाटा

item-site-preferences =
    .label = साइट प्राथमिकताहरू
    .accesskey = S

item-offline-apps =
    .label = अफलाइन वेबसाइट डाटा
    .accesskey = O

sanitize-everything-undo-warning = यो क्रियाकलाप नहुन सक्दैन।

window-close =
    .key = w

sanitize-button-ok =
    .label = खाली गर्नुहोस्

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = मेटाउँदै

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = सबै इतिहास मेटाइनेछ।

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = सबै छानिएका वस्तुहरू मेटाइनेछ।
