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
handler-dialog-host = <strong>{ $host }</strong> pretende abrir uma ligação <strong>{ $scheme }</strong>.

## Permission Dialog
## Variables:
##  $host - the hostname that is initiating the request
##  $scheme - the type of link that's being opened.
##  $appName - Name of the application that will be opened.

permission-dialog-description = Permitir que este site possa abrir a ligação { $scheme }?
permission-dialog-description-file = Permitir que este ficheiro possa abrir a ligação { $scheme }?
permission-dialog-description-host = Permitir que { $host } possa abrir a ligação { $scheme }?
permission-dialog-description-app = Permitir que este site possa abrir a ligação { $scheme } com { $appName }?
permission-dialog-description-host-app = Permitir que { $host } possa abrir a ligação { $scheme } com { $appName }?
permission-dialog-description-file-app = Permitir que este ficheiro possa abrir a ligação { $scheme } com { $appName }?

## Please keep the emphasis around the hostname and scheme (ie the
## `<strong>` HTML tags). Please also keep the hostname as close to the start
## of the sentence as your language's grammar allows.

permission-dialog-remember = Permitir sempre que <strong>{ $host }</strong> possa abrir ligações <strong>{ $scheme }</strong>.
permission-dialog-remember-file = Permitir sempre que este ficheiro possa abrir ligações <strong>{ $scheme }</strong>.

##

permission-dialog-btn-open-link =
    .label = Abrir ligação
    .accessKey = o
permission-dialog-btn-choose-app =
    .label = Escolher aplicação
    .accessKey = l
permission-dialog-unset-description = Terá de escolher uma aplicação.
permission-dialog-set-change-app-link = Escolha uma aplicação diferente.

## Chooser dialog
## Variables:
##  $scheme - the type of link that's being opened.

chooser-window =
    .title = Escolher aplicação
    .style = min-width: 26em; min-height: 26em;
chooser-dialog =
    .buttonlabelaccept = Abrir ligação
    .buttonaccesskeyaccept = o
chooser-dialog-description = Escolha uma aplicação para abrir a ligação { $scheme }.
# Please keep the emphasis around the scheme (ie the `<strong>` HTML tags).
chooser-dialog-remember = Permitir sempre que esta aplicação possa abrir ligações <strong>{ $scheme }</strong>.
chooser-dialog-remember-extra =
    { PLATFORM() ->
        [windows] Isto pode ser alterado nas opções do { -brand-short-name }.
       *[other] Isto pode ser alterado nas preferências do { -brand-short-name }.
    }
choose-other-app-description = Escolha outra aplicação
choose-app-btn =
    .label = Escolher…
    .accessKey = c
choose-other-app-window-title = Outra aplicação…
# Displayed under the name of a protocol handler in the Launch Application dialog.
choose-dialog-privatebrowsing-disabled = Desativado em janelas privadas
