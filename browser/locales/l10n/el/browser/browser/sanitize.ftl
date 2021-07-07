# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = Ρυθμίσεις απαλοιφής ιστορικού
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = Απαλοιφή πρόσφατου ιστορικού
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = Απαλοιφή όλου του ιστορικού
    .style = width: 34em

clear-data-settings-label = Όταν κλείνει, το { -brand-short-name } να κάνει αυτόματη απαλοιφή των παρακάτω

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = Χρονικό διάστημα εκκαθάρισης:{ " " }
    .accesskey = τ

clear-time-duration-value-last-hour =
    .label = Τελευταία ώρα

clear-time-duration-value-last-2-hours =
    .label = Τελευταίες δύο ώρες

clear-time-duration-value-last-4-hours =
    .label = Τελευταίες τέσσερις ώρες

clear-time-duration-value-today =
    .label = Σήμερα

clear-time-duration-value-everything =
    .label = Όλα

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Ιστορικό

item-history-and-downloads =
    .label = Ιστορικό περιήγησης & λήψεων
    .accesskey = π

item-cookies =
    .label = Cookies
    .accesskey = C

item-active-logins =
    .label = Ενεργές συνδέσεις
    .accesskey = υ

item-cache =
    .label = Προσωρινή μνήμη
    .accesskey = ρ

item-form-search-history =
    .label = Ιστορικό αναζήτησης & φορμών
    .accesskey = φ

data-section-label = Δεδομένα

item-site-preferences =
    .label = Προτιμήσεις σελίδων
    .accesskey = Π

item-site-settings =
    .label = Ρυθμίσεις ιστοτόπου
    .accesskey = Ρ

item-offline-apps =
    .label = Δεδομένα ιστοτόπων εκτός σύνδεσης
    .accesskey = Δ

sanitize-everything-undo-warning = Δεν είναι δυνατή η αναίρεση αυτής της ενέργειας.

window-close =
    .key = w

sanitize-button-ok =
    .label = Εκκαθάριση τώρα

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = Εκκαθάριση

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = Θα διαγραφεί όλο το ιστορικό.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Θα διαγραφούν όλα τα επιλεγμένα στοιχεία.
