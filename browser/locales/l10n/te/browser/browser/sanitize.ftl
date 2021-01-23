# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = చరిత్ర తొలగింపుకు అమరికలు
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = ఇటీవలి చరిత్రను తొలగించు
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = చరిత్ర అంతటినీ చెరిపివేయండి
    .style = width: 34em

clear-data-settings-label = మూసివేసినప్పుడు, { -brand-short-name } ఆటోమెటిగ్గా వీటిని చెరిపివేస్తుంది

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = తొలగించవలసిన సమయ వ్యవధి:{ " " }
    .accesskey = T

clear-time-duration-value-last-hour =
    .label = క్రిందటి గంట

clear-time-duration-value-last-2-hours =
    .label = క్రిందటి రెండు గంటలు

clear-time-duration-value-last-4-hours =
    .label = క్రిందటి నాలుగు గంటలు

clear-time-duration-value-today =
    .label = ఈ రోజు

clear-time-duration-value-everything =
    .label = అన్నీ

clear-time-duration-suffix =
    .value = అన్నీ

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = చరిత్ర

item-history-and-downloads =
    .label = విహారణ & దింపుకోలు చరిత్ర
    .accesskey = B

item-cookies =
    .label = కుకీలు
    .accesskey = C

item-active-logins =
    .label = చేతన లాగ్ ఇన్లు
    .accesskey = L

item-cache =
    .label = క్యాషె
    .accesskey = a

item-form-search-history =
    .label = ఫారాలు & వెతుకుడు చరిత్ర
    .accesskey = F

data-section-label = దత్తాంశము

item-site-preferences =
    .label = సైటు అభిరుచులు
    .accesskey = S

item-offline-apps =
    .label = ఆఫ్‌లైన్ వెబ్‌సైటు డాటా
    .accesskey = O

sanitize-everything-undo-warning = ఈ చర్యని పూర్వస్థితికి తెప్పించలేము.

window-close =
    .key = w

sanitize-button-ok =
    .label = ఇప్పుడు చెరిపివేయండి

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = తుడిచివేయుచున్నది

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = చరిత్ర మొత్తము చెరిపివేయబడుతుంది.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = ఎంచుకోబడిన అన్ని విషయలు చెరిపివేయబడుతుంది.
