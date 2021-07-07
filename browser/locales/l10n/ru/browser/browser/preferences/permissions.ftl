# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

permissions-window =
    .title = Исключения
    .style = width: 55em
permissions-close-key =
    .key = w
permissions-address = Адрес веб-сайта
    .accesskey = е
permissions-block =
    .label = Блокировать
    .accesskey = л
permissions-session =
    .label = Разрешить на сессию
    .accesskey = с
permissions-allow =
    .label = Разрешить
    .accesskey = з
permissions-button-off =
    .label = Отключить
    .accesskey = ю
permissions-button-off-temporarily =
    .label = Временно отключить
    .accesskey = е
permissions-site-name =
    .label = Веб-сайт
permissions-status =
    .label = Статус
permissions-remove =
    .label = Удалить веб-сайт
    .accesskey = д
permissions-remove-all =
    .label = Удалить все веб-сайты
    .accesskey = в
permissions-button-cancel =
    .label = Отмена
    .accesskey = м
permissions-button-ok =
    .label = Сохранить изменения
    .accesskey = х
permission-dialog =
    .buttonlabelaccept = Сохранить изменения
    .buttonaccesskeyaccept = х
permissions-autoplay-menu = По умолчанию для всех веб-сайтов:
permissions-searchbox =
    .placeholder = Поиск по веб-сайту
permissions-capabilities-autoplay-allow =
    .label = Разрешить аудио и видео
permissions-capabilities-autoplay-block =
    .label = Блокировать аудио
permissions-capabilities-autoplay-blockall =
    .label = Блокировать аудио и видео
permissions-capabilities-allow =
    .label = Разрешить
permissions-capabilities-block =
    .label = Блокировать
permissions-capabilities-prompt =
    .label = Всегда спрашивать
permissions-capabilities-listitem-allow =
    .value = Разрешить
permissions-capabilities-listitem-block =
    .value = Блокировать
permissions-capabilities-listitem-allow-session =
    .value = Разрешить на сессию
permissions-capabilities-listitem-off =
    .value = Отключить
permissions-capabilities-listitem-off-temporarily =
    .value = Временно отключить

## Invalid Hostname Dialog

permissions-invalid-uri-title = Введено некорректное сетевое имя сервера
permissions-invalid-uri-label = Введите корректное сетевое имя сервера.

## Exceptions - Tracking Protection

permissions-exceptions-etp-window =
    .title = Исключения для улучшенной защиты от отслеживания
    .style = { permissions-window.style }
permissions-exceptions-etp-desc = Вы отключили защиту на следующих веб-сайтах.

## Exceptions - Cookies

permissions-exceptions-cookie-window =
    .title = Исключения — Куки и данные сайтов
    .style = { permissions-window.style }
permissions-exceptions-cookie-desc = Вы можете указать, каким веб-сайтам разрешено всегда или никогда использовать куки и данные сайтов.  Введите точный адрес сайта и нажмите кнопку «Блокировать», «Разрешить на сессию» или «Разрешить».

## Exceptions - HTTPS-Only Mode

permissions-exceptions-https-only-window =
    .title = Исключения — Режим «Только HTTPS»
    .style = { permissions-window.style }
permissions-exceptions-https-only-desc = Вы можете отключить Режим «Только HTTPS» для определённых веб-сайтов. { -brand-short-name } не будет пытаться переключать соединение на защищённый HTTPS для этих сайтов. Исключения не распространяются на приватные окна.

## Exceptions - Pop-ups

permissions-exceptions-popup-window =
    .title = Разрешённые веб-сайты — Всплывающие окна
    .style = { permissions-window.style }
permissions-exceptions-popup-desc = Вы можете указать, каким веб-сайтам разрешено открывать всплывающие окна. Введите точный адрес для каждого сайта и нажмите кнопку «Разрешить».

## Exceptions - Saved Logins

permissions-exceptions-saved-logins-window =
    .title = Исключения — Сохранённые логины
    .style = { permissions-window.style }
permissions-exceptions-saved-logins-desc = Логины для следующих веб-сайтов не будут сохранены

## Exceptions - Add-ons

permissions-exceptions-addons-window =
    .title = Разрешённые веб-сайты — Установка дополнений
    .style = { permissions-window.style }
permissions-exceptions-addons-desc = Вы можете указать, каким веб-сайтам разрешено устанавливать дополнения. Введите точный адрес каждого сайта и нажмите кнопку «Разрешить».

## Site Permissions - Autoplay

permissions-site-autoplay-window =
    .title = Параметры — Автовоспроизведение
    .style = { permissions-window.style }
permissions-site-autoplay-desc = Вы можете указать, какие сайты не будут следовать вашим настройкам автовоспроизведения по умолчанию.

## Site Permissions - Notifications

permissions-site-notification-window =
    .title = Параметры — Разрешения на отправку уведомлений
    .style = { permissions-window.style }
permissions-site-notification-desc = Следующие веб-сайты запросили разрешение отправлять вам уведомления. Вы можете указать каким веб-сайтам разрешено отправлять вам уведомления. Вы также можете блокировать новые запросы с просьбами разрешить отправлять вам уведомления.
permissions-site-notification-disable-label =
    .label = Блокировать новые запросы на отправку вам уведомлений
permissions-site-notification-disable-desc = Это не позволит веб-сайтам, кроме перечисленных выше, запрашивать разрешение на отправку уведомлений. Блокировка уведомлений может нарушить некоторые функции веб-сайта.

## Site Permissions - Location

permissions-site-location-window =
    .title = Параметры — Разрешения на доступ к местоположению
    .style = { permissions-window.style }
permissions-site-location-desc = Следующие веб-сайты запросили разрешение на доступ к вашему местоположению. Вы можете указать каким веб-сайтам разрешено получать доступ к вашему местоположению. Вы также можете блокировать новые запросы с просьбами разрешить доступ к вашему местоположению.
permissions-site-location-disable-label =
    .label = Блокировать новые запросы на доступ к вашему местоположению
permissions-site-location-disable-desc = Это не позволит веб-сайтам, кроме перечисленных выше, запрашивать разрешение на доступ к вашему местоположению. Блокировка доступа к вашему местоположению может нарушить некоторые функции веб-сайта.

## Site Permissions - Virtual Reality

permissions-site-xr-window =
    .title = Настройки - Разрешения виртуальной реальности
    .style = { permissions-window.style }
permissions-site-xr-desc = Следующие веб-сайты запросили разрешение на доступ к вашим устройствам виртуальной реальности. Вы можете указать каким веб-сайтам разрешено получать доступ к вашим устройствам виртуальной реальности. Вы также можете блокировать новые запросы с просьбами разрешить доступ к вашим устройствам виртуальной реальности.
permissions-site-xr-disable-label =
    .label = Блокировать новые запросы на доступ к вашим устройствам виртуальной реальности
permissions-site-xr-disable-desc = Это не позволит веб-сайтам, кроме перечисленных выше, запрашивать разрешение на доступ к устройствам виртуальной реальности. Блокировка доступа к вашим устройствам виртуальной реальности может нарушить некоторые функции веб-сайта.

## Site Permissions - Camera

permissions-site-camera-window =
    .title = Параметры — Разрешения на доступ к камере
    .style = { permissions-window.style }
permissions-site-camera-desc = Следующие веб-сайты запросили разрешение на доступ к вашей камере. Вы можете указать каким веб-сайтам разрешено получать доступ к вашей камере. Вы также можете блокировать новые запросы с просьбами разрешить доступ к вашей камере.
permissions-site-camera-disable-label =
    .label = Блокировать новые запросы на доступ к вашей камере
permissions-site-camera-disable-desc = Это не позволит веб-сайтам, кроме перечисленных выше, запрашивать разрешение на доступ к вашей камере. Блокировка доступа к вашей камере может нарушить некоторые функции веб-сайта.

## Site Permissions - Microphone

permissions-site-microphone-window =
    .title = Параметры — Разрешения на доступ к микрофону
    .style = { permissions-window.style }
permissions-site-microphone-desc = Следующие веб-сайты запросили разрешение на доступ к вашему микрофону. Вы можете указать каким веб-сайтам разрешено получать доступ к вашему микрофону. Вы также можете блокировать новые запросы с просьбами разрешить доступ к вашему микрофону.
permissions-site-microphone-disable-label =
    .label = Блокировать новые запросы на доступ к вашему микрофону
permissions-site-microphone-disable-desc = Это не позволит веб-сайтам, кроме перечисленных выше, запрашивать разрешение на доступ к вашему микрофону. Блокировка доступа к вашему микрофону может нарушить некоторые функции веб-сайта.
