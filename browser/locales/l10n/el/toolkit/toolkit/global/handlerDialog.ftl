# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Please keep the emphasis around the hostname and scheme (ie the
# `<strong>` HTML tags). Please also keep the hostname as close to the start
# of the sentence as your language's grammar allows.
#
# Variables:
#  $host - the hostname that is initiating the request
#  $scheme - the type of link that's being opened.
handler-dialog-host = Το <strong>{ $host }</strong> θέλει να ανοίξει ένα σύνδεσμο <strong>{ $scheme }</strong>.

## Permission Dialog
## Variables:
##  $host - the hostname that is initiating the request
##  $scheme - the type of link that's being opened.
##  $appName - Name of the application that will be opened.

permission-dialog-description = Να επιτραπεί σε αυτή την ιστοσελίδα το άνοιγμα του συνδέσμου { $scheme };
permission-dialog-description-file = Να επιτραπεί σε αυτό το αρχείο το άνοιγμα του συνδέσμου { $scheme };
permission-dialog-description-host = Να επιτραπεί στο { $host } το άνοιγμα του συνδέσμου { $scheme };
permission-dialog-description-app = Να επιτραπεί σε αυτή την ιστοσελίδα το άνοιγμα του συνδέσμου { $scheme } με το { $appName };
permission-dialog-description-host-app = Να επιτραπεί στο { $host } το άνοιγμα του συνδέσμου { $scheme } με το { $appName };
permission-dialog-description-file-app = Να επιτραπεί σε αυτό το αρχείο το άνοιγμα του συνδέσμου { $scheme } με το { $appName };

## Please keep the emphasis around the hostname and scheme (ie the
## `<strong>` HTML tags). Please also keep the hostname as close to the start
## of the sentence as your language's grammar allows.

permission-dialog-remember = Να επιτρέπεται πάντα στο <strong>{ $host }</strong> το άνοιγμα συνδέσμων <strong>{ $scheme }</strong>
permission-dialog-remember-file = Να χρησιμοποιείται πάντα αυτό το αρχείο για άνοιγμα συνδέσμων <strong>{ $scheme }</strong>

##

permission-dialog-btn-open-link =
    .label = Άνοιγμα συνδέσμου
    .accessKey = Ά
permission-dialog-btn-choose-app =
    .label = Επιλογή εφαρμογής
    .accessKey = ε
permission-dialog-unset-description = Θα πρέπει να επιλέξετε μια εφαρμογή.
permission-dialog-set-change-app-link = Επιλέξτε μια διαφορετική εφαρμογή.

## Chooser dialog
## Variables:
##  $scheme - the type of link that's being opened.

chooser-window =
    .title = Επιλογή εφαρμογής
    .style = min-width: 26em; min-height: 26em;
chooser-dialog =
    .buttonlabelaccept = Άνοιγμα συνδέσμου
    .buttonaccesskeyaccept = Ά
chooser-dialog-description = Επιλέξτε μια εφαρμογή για άνοιγμα του συνδέσμου { $scheme }.
# Please keep the emphasis around the scheme (ie the `<strong>` HTML tags).
chooser-dialog-remember = Να χρησιμοποιείται πάντα αυτή η εφαρμογή για άνοιγμα συνδέσμων <strong>{ $scheme }</strong>
chooser-dialog-remember-extra =
    { PLATFORM() ->
        [windows] Αυτό μπορεί να αλλάξει στις επιλογές του { -brand-short-name }.
       *[other] Αυτό μπορεί να αλλάξει στις προτιμήσεις του { -brand-short-name }.
    }
choose-other-app-description = Επιλέξτε άλλη εφαρμογή
choose-app-btn =
    .label = Επιλογή…
    .accessKey = Ε
choose-other-app-window-title = Άλλη εφαρμογή…
# Displayed under the name of a protocol handler in the Launch Application dialog.
choose-dialog-privatebrowsing-disabled = Ανενεργό σε ιδιωτικά παράθυρα
