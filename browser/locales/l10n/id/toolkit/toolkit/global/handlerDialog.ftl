# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Permission Dialog
## Variables:
##  $host - the hostname that is initiating the request
##  $scheme - the type of link that's being opened.
##  $appName - Name of the application that will be opened.

permission-dialog-description = Izinkan situs ini untuk membuka tautan { $scheme }?
permission-dialog-description-file = Izinkan berkas ini untuk membuka tautan { $scheme }?
permission-dialog-description-host = Izinkan { $host } untuk membuka tautan { $scheme }?
permission-dialog-description-app = Izinkan situs ini untuk membuka tautan { $scheme } dengan { $appName }?
permission-dialog-description-host-app = Izinkan { $host } untuk membuka tautan { $scheme } dengan { $appName }?
permission-dialog-description-file-app = Izinkan berkas ini untuk membuka tautan { $scheme } dengan { $appName }?

## Please keep the emphasis around the hostname and scheme (ie the
## `<strong>` HTML tags). Please also keep the hostname as close to the start
## of the sentence as your language's grammar allows.

permission-dialog-remember = Selalu izinkan <strong>{ $host }</strong> untuk membuka tautan <strong>{ $scheme }</strong>
permission-dialog-remember-file = Selalu izinkan berkas ini untuk membuka tautan <strong>{ $scheme }</strong>

##

permission-dialog-btn-open-link =
    .label = Buka Tautan
    .accessKey = T
permission-dialog-btn-choose-app =
    .label = Pilih Aplikasi
    .accessKey = A
permission-dialog-unset-description = Anda harus memilih aplikasi.
permission-dialog-set-change-app-link = Pilih aplikasi lain.

## Chooser dialog
## Variables:
##  $scheme - the type of link that's being opened.

chooser-window =
    .title = Pilih Aplikasi
    .style = min-width: 26em; min-height: 26em;
chooser-dialog =
    .buttonlabelaccept = Buka Tautan
    .buttonaccesskeyaccept = T
chooser-dialog-description = Pilih aplikasi untuk membuka tautan { $scheme }.
# Please keep the emphasis around the scheme (ie the `<strong>` HTML tags).
chooser-dialog-remember = Selalu gunakan aplikasi ini untuk membuka tautan <strong>{ $scheme }</strong>
chooser-dialog-remember-extra =
    { PLATFORM() ->
        [windows] Ini dapat diubah dalam pengaturan { -brand-short-name }.
       *[other] Ini dapat diubah dalam pengaturan { -brand-short-name }.
    }
choose-other-app-description = Pilih Aplikasi lain
choose-app-btn =
    .label = Pilih…
    .accessKey = P
choose-other-app-window-title = Aplikasi Lain…
# Displayed under the name of a protocol handler in the Launch Application dialog.
choose-dialog-privatebrowsing-disabled = Dinonaktifkan di Jendela Pribadi
