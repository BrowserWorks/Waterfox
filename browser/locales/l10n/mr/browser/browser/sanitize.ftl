# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = इतिहास पूसण्याकरीता संयोजना
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = अलिकडील इतिहास नष्ट करा
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = सर्व इतिहास पूसा
    .style = width: 34em

clear-data-settings-label = बंद असताना, { -brand-short-name } सर्व आपोआप नष्ट करेल

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = नष्ट करण्यासाठी वेळ क्षेत्र:{ " " }
    .accesskey = T

clear-time-duration-value-last-hour =
    .label = शेवटचा तास

clear-time-duration-value-last-2-hours =
    .label = शेवटचे दोन तास

clear-time-duration-value-last-4-hours =
    .label = शेवटचे चार तास

clear-time-duration-value-today =
    .label = आज

clear-time-duration-value-everything =
    .label = सगळं काही

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = इतिहास

item-history-and-downloads =
    .label = ब्राऊज आणि डाऊनलोड इतिहास
    .accesskey = B

item-cookies =
    .label = कुकीज
    .accesskey = C

item-active-logins =
    .label = सक्रिय प्रवेश
    .accesskey = L

item-cache =
    .label = कॅशे
    .accesskey = a

item-form-search-history =
    .label = फॉर्म आणि शोध इतिहास
    .accesskey = F

data-section-label = माहिती

item-site-preferences =
    .label = साईट प्राधान्यक्रम
    .accesskey = S

item-offline-apps =
    .label = ऑफलाइन संकेतस्थळ माहिती
    .accesskey = O

sanitize-everything-undo-warning = ही कृती रद्द करणे अशक्य.

window-close =
    .key = w

sanitize-button-ok =
    .label = आता पूसा

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = नष्ट करत आहे

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = सर्व इतिहास नष्ट केला जाईल.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = सर्व नीवडलेले घटके नष्ट केले जातील.
