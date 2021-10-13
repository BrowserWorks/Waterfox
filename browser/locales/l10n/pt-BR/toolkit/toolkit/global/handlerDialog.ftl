# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Permission Dialog
## Variables:
##  $host - the hostname that is initiating the request
##  $scheme - the type of link that's being opened.
##  $appName - Name of the application that will be opened.

permission-dialog-description = Permitir que este site abra o link do tipo { $scheme }?

permission-dialog-description-file = Permitir que este arquivo abra o link do tipo { $scheme }?

permission-dialog-description-host = Permitir que { $host } abra o link do tipo { $scheme }?

permission-dialog-description-app = Permitir que este site abra o link do tipo { $scheme } com { $appName }?

permission-dialog-description-host-app = Permitir que { $host } abra o link { $scheme } com { $appName }?

permission-dialog-description-file-app = Permitir que este arquivo abra o link do tipo { $scheme } com { $appName }?

## Please keep the emphasis around the hostname and scheme (ie the
## `<strong>` HTML tags). Please also keep the hostname as close to the start
## of the sentence as your language's grammar allows.

permission-dialog-remember = Sempre permitir que <strong>{ $host }</strong> abra links do tipo <strong>{ $scheme }</strong>

permission-dialog-remember-file = Sempre permitir que este arquivo abra links do tipo <strong>{ $scheme }</strong>

##

permission-dialog-btn-open-link =
    .label = Abrir link
    .accessKey = A

permission-dialog-btn-choose-app =
    .label = Escolher aplicativo
    .accessKey = E

permission-dialog-unset-description = Precisa escolher um aplicativo.

permission-dialog-set-change-app-link = Escolher outro aplicativo

## Chooser dialog
## Variables:
##  $scheme - the type of link that's being opened.

chooser-window =
    .title = Escolher aplicativo
    .style = min-width: 26em; min-height: 26em;

chooser-dialog =
    .buttonlabelaccept = Abrir link
    .buttonaccesskeyaccept = A

chooser-dialog-description = Escolha um aplicativo para abrir o link do tipo { $scheme }.

# Please keep the emphasis around the scheme (ie the `<strong>` HTML tags).
chooser-dialog-remember = Sempre usar este aplicativo para abrir links do tipo <strong>{ $scheme }</strong>

chooser-dialog-remember-extra =
    { PLATFORM() ->
        [windows] Pode ser alterado nas opções do { -brand-short-name }.
       *[other] Pode ser alterado nas preferências do { -brand-short-name }.
    }

choose-other-app-description = Escolher outro aplicativo
choose-app-btn =
    .label = Procurar…
    .accessKey = P
choose-other-app-window-title = Outro aplicativo…

# Displayed under the name of a protocol handler in the Launch Application dialog.
choose-dialog-privatebrowsing-disabled = Desativado em janelas privativas
