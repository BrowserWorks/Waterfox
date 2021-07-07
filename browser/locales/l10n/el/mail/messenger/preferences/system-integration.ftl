# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = Ενσωμάτωση συστήματος
system-integration-dialog =
    .buttonlabelaccept = Ορισμός ως προεπιλογή
    .buttonlabelcancel = Παράλειψη ενσωμάτωσης
    .buttonlabelcancel2 = Ακύρωση
default-client-intro = Ορισμός του { -brand-short-name } ως προεπιλογής για:
unset-default-tooltip = Δεν είναι δυνατή η ακύρωση ορισμού του { -brand-short-name } ως προκαθορισμένου προγράμματος μέσα από το { -brand-short-name }. Για να ορίσετε άλλη εφαρμογή ως προεπιλογή πρέπει να χρησιμοποιήσετε το διάλογο της «Ορισμός ως προεπιλογή».
checkbox-email-label =
    .label = Email
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = Ομάδες συζήτησης
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = Ροές
    .tooltiptext = { unset-default-tooltip }
checkbox-calendar-label =
    .label = Ημερολόγιο
    .tooltiptext = { unset-default-tooltip }
# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
system-search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Αναζήτηση των Windows
       *[other] { "" }
    }
system-search-integration-label =
    .label = Να επιτρέπεται στην { system-search-engine-name } η αναζήτηση μηνυμάτων
    .accesskey = ε
check-on-startup-label =
    .label = Πάντα έλεγχος κατά την εκκίνηση του { -brand-short-name }
    .accesskey = Π
