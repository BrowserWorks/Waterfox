# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = Taq ajowab'äl richin nijosq'ïx ri natab'äl
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = Tiyuj K'ak'a' Natab'äl
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = Tiyuj Ronojel Natab'äl
    .style = width: 34em

clear-data-settings-label = Toq xtitz'apïx, { -brand-short-name } k'o ta chi ruyonil nuyüj ronojel

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = Retal q'ijul richin niyuj:
    .accesskey = q

clear-time-duration-value-last-hour =
    .label = Ruk'isib'äl Ramaj

clear-time-duration-value-last-2-hours =
    .label = Ruk'isib'al Ka'i' Ramaj

clear-time-duration-value-last-4-hours =
    .label = Ruk'isib'äl Kaji' Ramaj

clear-time-duration-value-today =
    .label = Wakami

clear-time-duration-value-everything =
    .label = Ronojel

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Natab'äl

item-history-and-downloads =
    .label = Kinatab'al ri okem pa k'amaya'l chuqa' taq qasanïk
    .accesskey = o

item-cookies =
    .label = Taq kaxlanwey
    .accesskey = k

item-active-logins =
    .label = Tzijïl taq molojri'ïl
    .accesskey = m

item-cache =
    .label = Kache'
    .accesskey = a

item-form-search-history =
    .label = Kinatab'al Taq nojwuj chuqa' taq kanob'äl
    .accesskey = n

data-section-label = Taq tzij

item-site-preferences =
    .label = Taq rajowaxïk ruxaq k'amaya'l
    .accesskey = k

item-offline-apps =
    .label = Taq rutzij ruxaq k'amaya'l majun nok pa k'amaya'l
    .accesskey = r

sanitize-everything-undo-warning = Man tikirel ta nitzolïx re b'anïk.

window-close =
    .key = w

sanitize-button-ok =
    .label = Tijosq'ïx Wakami

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = Tajin yeyuj

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = Xkeyuj el ronojel ri natab'äl.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Xkeyüj el konojel ri taq retal echa'on.
