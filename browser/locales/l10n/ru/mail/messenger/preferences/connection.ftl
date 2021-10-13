# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-dns-over-https-url-resolver = Используемый провайдер
    .accesskey = п

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (По умолчанию)
    .tooltiptext = Использовать URL по умолчанию для разрешения DNS через HTTPS

connection-dns-over-https-url-custom =
    .label = Другой URL
    .accesskey = о
    .tooltiptext = Введите свой URL для разрешения DNS через HTTPS

connection-dns-over-https-custom-label = Другой URL

connection-dialog-window =
    .title = Параметры соединения
    .style =
        { PLATFORM() ->
            [macos] width: 44em !important
           *[other] width: 49em !important
        }

connection-disable-extension =
    .label = Отключить расширение

connection-proxy-legend = Настройка прокси для доступа в Интернет

proxy-type-no =
    .label = Без прокси
    .accesskey = е

proxy-type-wpad =
    .label = Автоматически определять настройки прокси для этой сети
    .accesskey = в

proxy-type-system =
    .label = Использовать системные настройки прокси
    .accesskey = с

proxy-type-manual =
    .label = Ручная настройка сервиса прокси:
    .accesskey = в

proxy-http-label =
    .value = HTTP прокси:
    .accesskey = T

http-port-label =
    .value = Порт:
    .accesskey = о

proxy-http-sharing =
    .label = Также использовать этот прокси для HTTPS
    .accesskey = е

proxy-https-label =
    .value = HTTPS прокси:
    .accesskey = и

ssl-port-label =
    .value = Порт:
    .accesskey = р

proxy-socks-label =
    .value = Узел SOCKS:
    .accesskey = O

socks-port-label =
    .value = Порт:
    .accesskey = т

proxy-socks4-label =
    .label = SOCKS 4
    .accesskey = 4

proxy-socks5-label =
    .label = SOCKS 5
    .accesskey = 5

proxy-type-auto =
    .label = URL автоматической настройки сервиса прокси:
    .accesskey = а

proxy-reload-label =
    .label = Обновить
    .accesskey = б

no-proxy-label =
    .value = Не использовать прокси для:
    .accesskey = д

no-proxy-example = Пример: .mozilla-russia.org, .net.nz, 192.168.1.0/24

# Do not translate "localhost", "127.0.0.1/8" and "::1". (You can translate "and".)
connection-proxy-noproxy-localhost-desc-2 = Соединения с localhost, 127.0.0.1/8 и ::1 никогда не проксируются.

proxy-password-prompt =
    .label = Не запрашивать аутентификацию (если был сохранён пароль)
    .accesskey = ш
    .tooltiptext = Эта настройка аутентифицирует вас на прокси, не выполняя запросов, если вы сохранили свои учётные данные. Если аутентификация не удастся, вам будет выдан запрос.

proxy-remote-dns =
    .label = Отправлять DNS-запросы через прокси, используя SOCKS 5
    .accesskey = я

proxy-enable-doh =
    .label = Включить DNS через HTTPS
    .accesskey = л
