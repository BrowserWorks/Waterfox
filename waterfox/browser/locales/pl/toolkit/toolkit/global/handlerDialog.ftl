# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## Permission Dialog
## Variables:
##  $host - the hostname that is initiating the request
##  $scheme - the type of link that's being opened.
##  $appName - Name of the application that will be opened.

permission-dialog-description = Czy zezwolić tej witrynie na otwarcie odnośnika typu { $scheme }?

permission-dialog-description-file = Czy zezwolić temu plikowi na otwarcie odnośnika typu { $scheme }?

permission-dialog-description-host = Czy zezwolić witrynie { $host } na otwarcie odnośnika typu { $scheme }?

permission-dialog-description-app = Czy zezwolić tej witrynie na otwarcie odnośnika typu { $scheme } za pomocą aplikacji { $appName }?

permission-dialog-description-host-app = Czy zezwolić witrynie { $host } na otwarcie odnośnika typu { $scheme } za pomocą aplikacji { $appName }?

permission-dialog-description-file-app = Czy zezwolić temu plikowi na otwarcie odnośnika typu { $scheme } za pomocą aplikacji { $appName }?

## Please keep the emphasis around the hostname and scheme (ie the
## `<strong>` HTML tags). Please also keep the hostname as close to the start
## of the sentence as your language's grammar allows.

permission-dialog-remember = Zawsze zezwalaj witrynie <strong>{ $host }</strong> na otwieranie odnośników typu <strong>{ $scheme }</strong>

permission-dialog-remember-file = Zawsze zezwalaj temu plikowi na otwieranie odnośników typu <strong>{ $scheme }</strong>

##

permission-dialog-btn-open-link =
    .label = Otwórz odnośnik
    .accessKey = O

permission-dialog-btn-choose-app =
    .label = Wybierz aplikację
    .accessKey = W

permission-dialog-unset-description = Musisz wybrać aplikację.

permission-dialog-set-change-app-link = Wybierz inną aplikację.

## Chooser dialog
## Variables:
##  $scheme - the type of link that's being opened.

chooser-window =
    .title = Wybór aplikacji
    .style = min-width: 26em; min-height: 26em;

chooser-dialog =
    .buttonlabelaccept = Otwórz odnośnik
    .buttonaccesskeyaccept = O

chooser-dialog-description = Wybierz aplikację, aby otworzyć odnośnik typu { $scheme }.

# Please keep the emphasis around the scheme (ie the `<strong>` HTML tags).
chooser-dialog-remember = Zawsze używaj tej aplikacji do otwierania odnośników typu <strong>{ $scheme }</strong>

chooser-dialog-remember-extra =
    { PLATFORM() ->
        [windows] Można to zmienić w opcjach programu { -brand-short-name }.
       *[other] Można to zmienić w preferencjach programu { -brand-short-name }.
    }

choose-other-app-description = Wybierz inną aplikację
choose-app-btn =
    .label = Wybierz…
    .accessKey = W
choose-other-app-window-title = Inna aplikacja…

# Displayed under the name of a protocol handler in the Launch Application dialog.
choose-dialog-privatebrowsing-disabled = Wyłączone w oknach prywatnych
