# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## Permission Dialog
## Variables:
##  $host - the hostname that is initiating the request
##  $scheme - the type of link that's being opened.
##  $appName - Name of the application that will be opened.

permission-dialog-description =
  Consentire a questo sito di aprire un link di tipo { $scheme }?

permission-dialog-description-file =
  Consentire a questo file di aprire un link di tipo { $scheme }?

permission-dialog-description-host =
  Consentire a { $host } di aprire un link di tipo { $scheme }?

permission-dialog-description-app =
  Consentire a questo sito di aprire un link di tipo { $scheme } con { $appName }?

permission-dialog-description-file-app =
  Consentire a questo file di aprire un link di tipo { $scheme } con { $appName }?

permission-dialog-description-host-app =
  Consentire a { $host } di aprire un link di tipo { $scheme } con { $appName }?

permission-dialog-remember =
  Consenti sempre a <strong>{ $host }</strong> di aprire link di tipo <strong>{ $scheme }</strong>

permission-dialog-remember-file =
  Consenti sempre a questo file di aprire link di tipo <strong>{ $scheme }</strong>

permission-dialog-btn-open-link =
      .label = Apri link
      .accessKey = A

permission-dialog-btn-choose-app =
      .label = Scegli applicazione
      .accessKey = S

permission-dialog-unset-description = È necessario scegliere un’applicazione.

permission-dialog-set-change-app-link = Scegli un’altra applicazione


## Chooser dialog
## Variables:
##  $scheme - the type of link that's being opened.

chooser-window =
      .title = Scelta applicazione
      .style = min-width: 26em; min-height: 26em;

chooser-dialog =
      .buttonlabelaccept = Apri link
      .buttonaccesskeyaccept = A

chooser-dialog-description = Scegliere un’applicazione per aprire i link di tipo { $scheme }.

# Please keep the emphasis around the scheme (ie the `<strong>` HTML tags).
chooser-dialog-remember =
  Utilizza sempre questa applicazione per aprire i link di tipo <strong>{ $scheme }</strong>

chooser-dialog-remember-extra = {
  PLATFORM() ->
      [windows] È possibile modificare questa impostazione nelle opzioni di { -brand-short-name }.
     *[other] È possibile modificare questa impostazione nelle preferenze di { -brand-short-name }.
  }

choose-other-app-description = Utilizza un’altra applicazione
choose-app-btn =
    .label = Scegli…
    .accessKey = S
choose-other-app-window-title = Altra applicazione…

# Displayed under the name of a protocol handler in the Launch Application dialog.
choose-dialog-privatebrowsing-disabled = Disattiva in finestre anonime
