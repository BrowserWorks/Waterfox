# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = Iɣewwaṛen i usfaḍ n umazray
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = Sfeḍ azray n melmi kan
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = Sfeḍ akk azray
    .style = width: 34em

clear-data-settings-label = Ticki yemdel, { -brand-short-name } ad yekkes s wudem awurman iferdisen-agi meṛṛa

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = Azilal ara tsefḍeḍ:{ " " }
    .accesskey = A

clear-time-duration-value-last-hour =
    .label = Asrag aneggaru

clear-time-duration-value-last-2-hours =
    .label = Sin isragen ineggura

clear-time-duration-value-last-4-hours =
    .label = Kuz isragen ineggura

clear-time-duration-value-today =
    .label = Assa

clear-time-duration-value-everything =
    .label = Merra

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Azray

item-history-and-downloads =
    .label = Azray n tunigin d yisadaren
    .accesskey = A

item-cookies =
    .label = Inagan n tuqqna
    .accesskey = I

item-active-logins =
    .label = Tuqqniwin turmidin
    .accesskey = q

item-cache =
    .label = Tuffirt
    .accesskey = u

item-form-search-history =
    .label = Azray n tferkit d unadi
    .accesskey = m

data-section-label = Isefka

item-site-preferences =
    .label = Ismenyifen n usmel web
    .accesskey = I

item-offline-apps =
    .label = Isefka war tuqqna n usmel web
    .accesskey = q

sanitize-everything-undo-warning = Ulac tuɣalin ɣer deffir.

window-close =
    .key = w

sanitize-button-ok =
    .label = Sfeḍ Tura

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = Asfaḍ

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = Azray ad yettwasfeḍ akk.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Akk iferdisen ittwafernen ad ttwasefḍen.
