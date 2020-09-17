# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (стандартно)
    .tooltiptext = Използва стандартния адрес за запитвания на DNS през HTTPS

connection-dns-over-https-url-custom =
    .label = По избор
    .accesskey = п
    .tooltiptext = Въведете предпочитания от вас адрес за запитвания на DNS през HTTPS

connection-dialog-window =
    .title = Настройки на свързване
    .style =
        { PLATFORM() ->
            [macos] width: 44em !important
           *[other] width: 49em !important
        }

connection-proxy-legend = Настройване на мрежов посредник за достъп до интернет

proxy-type-no =
    .label = Без мрежов посредник
    .accesskey = к

proxy-type-wpad =
    .label = Автоматично откриване
    .accesskey = м

proxy-type-system =
    .label = Използване на системните настройки
    .accesskey = з

proxy-type-manual =
    .label = Ръчно конфигуриране:
    .accesskey = Р

proxy-http-label =
    .value = HTTP прокси:
    .accesskey = H

http-port-label =
    .value = Порт:
    .accesskey = П

ssl-port-label =
    .value = Порт:
    .accesskey = о

proxy-socks-label =
    .value = SOCKS хост:
    .accesskey = C

socks-port-label =
    .value = Порт:
    .accesskey = р

proxy-socks4-label =
    .label = SOCKS v4
    .accesskey = K

proxy-socks5-label =
    .label = SOCKS v5
    .accesskey = v

proxy-type-auto =
    .label = URL за автоматична прокси конфигурация:
    .accesskey = а

proxy-reload-label =
    .label = Презареждане
    .accesskey = з

no-proxy-label =
    .value = Без прокси за:
    .accesskey = Б

no-proxy-example = Например: .mozilla.org, .net.nz, 192.168.1.0/24

proxy-password-prompt =
    .label = Да не се пита за удостоверяване, ако паролата е запазена
    .accesskey = у
    .tooltiptext = Тази настройка ще ви удостоверява без да потвърждение пред мрежови посредници, когато имате запазени данни за вход. Ще бъдете питани, ако удостоверяването се провали.

proxy-remote-dns =
    .label = Посредник за DNS при използване на SOCKS v5
    .accesskey = D

proxy-enable-doh =
    .label = Разрешаване на DNS през HTTPS
    .accesskey = р
