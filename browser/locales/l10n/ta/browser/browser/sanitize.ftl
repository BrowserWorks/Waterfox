# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = வரலாற்றை அழிப்பதற்கான அமைப்புகள்
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = சமீபத்திய வரலாற்றைத் துடை
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = அனைத்து வரலாற்றையும் துடை
    .style = width: 34em

clear-data-settings-label = நான் { -brand-short-name }, மூடும் போது தானாக அனைத்தையும் துடைக்க வேண்டும்

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = துடைக்க வேண்டிய நேர வரம்பு:{ " " }
    .accesskey = T

clear-time-duration-value-last-hour =
    .label = கடைசி மணி

clear-time-duration-value-last-2-hours =
    .label = கடைசி இரண்டு மணிகள்

clear-time-duration-value-last-4-hours =
    .label = கடைசி நான்கு மணிகள்

clear-time-duration-value-today =
    .label = இன்று

clear-time-duration-value-everything =
    .label = எல்லாம்

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = வரலாறு

item-history-and-downloads =
    .label = உலாவல் & பதிவிறக்க வரலாறு
    .accesskey = உ

item-cookies =
    .label = நினைவிகள்
    .accesskey = C

item-active-logins =
    .label = செயலிலுள்ள புகுபதிவுகள்
    .accesskey = L

item-cache =
    .label = இடையகம்
    .accesskey = a

item-form-search-history =
    .label = படிவம் & தேடல் வரலாறு
    .accesskey = ப

data-section-label = தரவு

item-site-preferences =
    .label = இணைய தள முன்னுரிமைகள்
    .accesskey = S

item-offline-apps =
    .label = இணைப்பில்லாத இணையதள தரவு
    .accesskey = O

sanitize-everything-undo-warning = இந்த செயல் மறைக்க முடியாது.

window-close =
    .key = w

sanitize-button-ok =
    .label = இப்போது துடை

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = அழிக்கிறது

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = அனைத்து வரலாறும் துடைக்கப்படும்.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = அனைத்து தேர்ந்தெடுக்கப்பட்ட உருப்படிகளும் துடைக்கப்படும்.
