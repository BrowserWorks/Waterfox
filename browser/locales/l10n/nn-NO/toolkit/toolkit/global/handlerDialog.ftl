# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Permission Dialog
## Variables:
##  $host - the hostname that is initiating the request
##  $scheme - the type of link that's being opened.
##  $appName - Name of the application that will be opened.

permission-dialog-description = Tillate at denne nettstaden opnar lenka { $scheme }?

permission-dialog-description-file = Tillate denne fila å opne lenka { $scheme }?

permission-dialog-description-host = Tillate { $host } å opne lenka { $scheme }?

permission-dialog-description-app = Tillate denne nettsaden å opne { $scheme } med { $appName }?

permission-dialog-description-host-app = Tillate { $host } å opne lenka { $scheme } med { $appName }?

permission-dialog-description-file-app = Tillate denne fila å opne lenka { $scheme } med { $appName }?

## Please keep the emphasis around the hostname and scheme (ie the
## `<strong>` HTML tags). Please also keep the hostname as close to the start
## of the sentence as your language's grammar allows.

permission-dialog-remember = Tillat alltid <strong>{ $host }</strong> å opne <strong>{ $scheme }</strong>-lenker

permission-dialog-remember-file = Tillat alltid denne fila å opne <strong>{ $scheme }</strong>-lenker

##

permission-dialog-btn-open-link =
    .label = Opne lenke
    .accessKey = p

permission-dialog-btn-choose-app =
    .label = Vel program
    .accessKey = V

permission-dialog-unset-description = Du må velje eit program.

permission-dialog-set-change-app-link = Vel eit anna program.

## Chooser dialog
## Variables:
##  $scheme - the type of link that's being opened.

chooser-window =
    .title = Vel program
    .style = min-width: 26em; min-height: 26em;

chooser-dialog =
    .buttonlabelaccept = Opne lenke
    .buttonaccesskeyaccept = O

chooser-dialog-description = Vel eit program for å opne { $scheme }-lenka.

# Please keep the emphasis around the scheme (ie the `<strong>` HTML tags).
chooser-dialog-remember = Bruk alltid dette programmet for å opne <strong>{ $scheme }</strong>-lenker

chooser-dialog-remember-extra =
    { PLATFORM() ->
        [windows] Dette kan endrast i innstillingane for { -brand-short-name }.
       *[other] Dette kan endres i innstillingane for { -brand-short-name }.
    }

choose-other-app-description = Vel eit anna program
choose-app-btn =
    .label = Vel…
    .accessKey = V
choose-other-app-window-title = Anna program…

# Displayed under the name of a protocol handler in the Launch Application dialog.
choose-dialog-privatebrowsing-disabled = Deaktivert i private vindauge
