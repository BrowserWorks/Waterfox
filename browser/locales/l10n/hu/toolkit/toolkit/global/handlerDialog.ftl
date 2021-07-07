# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## Permission Dialog
## Variables:
##  $host - the hostname that is initiating the request
##  $scheme - the type of link that's being opened.
##  $appName - Name of the application that will be opened.

permission-dialog-description = Engedélyezi az oldal számára, hogy megnyissa a(z) { $scheme } hivatkozást?

permission-dialog-description-file = Engedélyezi a fájl számára, hogy megnyissa a(z) { $scheme } hivatkozást?

permission-dialog-description-host = Engedélyezi a(z) { $host } számára, hogy megnyissa a(z) { $scheme } hivatkozást?

permission-dialog-description-app = Engedélyezi az oldal számára, hogy megnyissa a(z) { $scheme } hivatkozást a(z) { $appName } alkalmazással?

permission-dialog-description-host-app = Engedélyezi a(z) { $host } számára, hogy megnyissa a(z) { $scheme } hivatkozást a(z) { $appName } alkalmazással?

permission-dialog-description-file-app = Engedélyezi a fájl számára, hogy megnyissa a(z) { $scheme } hivatkozást a(z) { $appName } alkalmazással?

## Please keep the emphasis around the hostname and scheme (ie the
## `<strong>` HTML tags). Please also keep the hostname as close to the start
## of the sentence as your language's grammar allows.

permission-dialog-remember = Mindig engedélyezze, hogy a(z) <strong>{ $host }</strong> <strong>{ $scheme }</strong> hivatkozásokat nyisson meg

permission-dialog-remember-file = Mindig engedélyezzen ennek a fájlnak, hogy megnyissa a(z) <strong>{ $scheme }</strong> hivatkozásokat

##

permission-dialog-btn-open-link =
    .label = Hivatkozás megnyitása
    .accessKey = H

permission-dialog-btn-choose-app =
    .label = Alkalmazás kiválasztása
    .accessKey = A

permission-dialog-unset-description = Választania kell egy alkalmazást.

permission-dialog-set-change-app-link = Másik alkalmazás választása.

## Chooser dialog
## Variables:
##  $scheme - the type of link that's being opened.

chooser-window =
    .title = Alkalmazás választása
    .style = min-width: 26em; min-height: 26em;

chooser-dialog =
    .buttonlabelaccept = Hivatkozás megnyitása
    .buttonaccesskeyaccept = m

chooser-dialog-description = Válasszon egy alkalmazást a(z) { $scheme } hivatkozás megnyitásához.

# Please keep the emphasis around the scheme (ie the `<strong>` HTML tags).
chooser-dialog-remember = Mindig ezt az alkalmazást használja a(z) <strong>{ $scheme }</strong> hivatkozások megnyitásához

chooser-dialog-remember-extra =
    { PLATFORM() ->
        [windows] Ez a { -brand-short-name } beállításaiban megváltoztatható.
       *[other] Ez a { -brand-short-name } beállításaiban megváltoztatható.
    }

choose-other-app-description = Másik alkalmazás választása
choose-app-btn =
    .label = Tallózás…
    .accessKey = a
choose-other-app-window-title = Másik alkalmazás…

# Displayed under the name of a protocol handler in the Launch Application dialog.
choose-dialog-privatebrowsing-disabled = Privát ablakokban letiltva
