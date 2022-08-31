# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## Permission Dialog
## Variables:
##  $host - the hostname that is initiating the request
##  $scheme - the type of link that's being opened.
##  $appName - Name of the application that will be opened.

permission-dialog-description = Dieser Website erlauben, den { $scheme }-Link zu öffnen?

permission-dialog-description-file = Dieser Datei erlauben, den { $scheme }-Link zu öffnen?

permission-dialog-description-host = { $host } erlauben, den { $scheme }-Link zu öffnen?

permission-dialog-description-app = Dieser Website erlauben, den { $scheme }-Link mit { $appName } zu öffnen?

permission-dialog-description-host-app = { $host } erlauben, den { $scheme }-Link mit { $appName } zu öffnen?

permission-dialog-description-file-app = Dieser Datei erlauben, den { $scheme }-Link mit { $appName } zu öffnen?

## Please keep the emphasis around the hostname and scheme (ie the
## `<strong>` HTML tags). Please also keep the hostname as close to the start
## of the sentence as your language's grammar allows.

permission-dialog-remember = <strong>{ $host }</strong> immer erlauben, <strong>{ $scheme }</strong>-Links zu öffnen

permission-dialog-remember-file = Dieser Datei immer erlauben, <strong>{ $scheme }</strong>-Links zu öffnen

##

permission-dialog-btn-open-link =
    .label = Link öffnen
    .accessKey = ö

permission-dialog-btn-choose-app =
    .label = Anwendung wählen
    .accessKey = A

permission-dialog-unset-description = Sie müssen eine Anwendung auswählen.

permission-dialog-set-change-app-link = Wählen Sie eine andere Anwendung.

## Chooser dialog
## Variables:
##  $scheme - the type of link that's being opened.

chooser-window =
    .title = Anwendung auswählen
    .style = min-width: 26em; min-height: 26em;

chooser-dialog =
    .buttonlabelaccept = Link öffnen
    .buttonaccesskeyaccept = ö

chooser-dialog-description = Wählen Sie eine Anwendung, um den { $scheme }-Link zu öffnen.

# Please keep the emphasis around the scheme (ie the `<strong>` HTML tags).
chooser-dialog-remember = Diese Anwendung immer verwenden, um <strong>{ $scheme }</strong>-Links zu öffnen

chooser-dialog-remember-extra =
    { PLATFORM() ->
        [windows] Dies kann in den { -brand-short-name }-Einstellungen geändert werden.
       *[other] Dies kann in den { -brand-short-name }-Einstellungen geändert werden.
    }

choose-other-app-description = Andere Anwendung auswählen
choose-app-btn =
    .label = Durchsuchen…
    .accessKey = D
choose-other-app-window-title = Andere Anwendung…

# Displayed under the name of a protocol handler in the Launch Application dialog.
choose-dialog-privatebrowsing-disabled = In privaten Fenstern deaktiviert
