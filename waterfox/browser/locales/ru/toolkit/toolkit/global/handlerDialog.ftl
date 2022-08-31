# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Permission Dialog
## Variables:
##  $host - the hostname that is initiating the request
##  $scheme - the type of link that's being opened.
##  $appName - Name of the application that will be opened.

permission-dialog-description = Разрешить этому сайту открыть ссылку { $scheme }?

permission-dialog-description-file = Разрешить этому файлу открыть ссылку { $scheme }?

permission-dialog-description-host = Разрешить { $host } открыть ссылку { $scheme }?

permission-dialog-description-app = Разрешить этому сайту открыть ссылку { $scheme } используя { $appName }?

permission-dialog-description-host-app = Разрешить { $host } открыть ссылку { $scheme } используя { $appName }?

permission-dialog-description-file-app = Разрешить этому файлу открыть ссылку { $scheme } используя { $appName }?

## Please keep the emphasis around the hostname and scheme (ie the
## `<strong>` HTML tags). Please also keep the hostname as close to the start
## of the sentence as your language's grammar allows.

permission-dialog-remember = Всегда разрешать <strong>{ $host }</strong> открывать ссылки <strong>{ $scheme }</strong>

permission-dialog-remember-file = Всегда разрешать этому файлу открывать ссылки <strong>{ $scheme }</strong>

##

permission-dialog-btn-open-link =
    .label = Открыть ссылку
    .accessKey = ы

permission-dialog-btn-choose-app =
    .label = Выбрать приложение
    .accessKey = ж

permission-dialog-unset-description = Вам нужно выбрать приложение.

permission-dialog-set-change-app-link = Выбрать другое приложение.

## Chooser dialog
## Variables:
##  $scheme - the type of link that's being opened.

chooser-window =
    .title = Выбрать приложение
    .style = min-width: 26em; min-height: 26em;

chooser-dialog =
    .buttonlabelaccept = Открыть ссылку
    .buttonaccesskeyaccept = ы

chooser-dialog-description = Выберите приложение для открытия ссылок { $scheme }.

# Please keep the emphasis around the scheme (ie the `<strong>` HTML tags).
chooser-dialog-remember = Всегда использовать это приложение для открытия ссылок <strong>{ $scheme }</strong>

chooser-dialog-remember-extra =
    { PLATFORM() ->
        [windows] Вы сможете изменить это в настройках { -brand-short-name }.
       *[other] Вы сможете изменить это в настройках { -brand-short-name }.
    }

choose-other-app-description = Другое приложение
choose-app-btn =
    .label = Выбрать…
    .accessKey = ы
choose-other-app-window-title = Другое приложение…

# Displayed under the name of a protocol handler in the Launch Application dialog.
choose-dialog-privatebrowsing-disabled = Отключено в приватных окнах
