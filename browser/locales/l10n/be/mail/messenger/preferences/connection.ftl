# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-dialog-window =
    .title = Наладжванні злучэння
    .style =
        { PLATFORM() ->
            [macos] width: 44em !important
           *[other] width: 45em !important
        }

connection-proxy-legend = Наладка пасярэднікаў дзеля доступу ў Інтэрнэт

proxy-type-no =
    .label = Без пасярэдніка
    .accesskey = е

proxy-type-wpad =
    .label = Самавызначэнне наладжванняў пасярэднікаў для гэтай сеткі
    .accesskey = с

proxy-type-system =
    .label = Ужываць сістэмныя наладжванні пасярэднікаў
    .accesskey = У

proxy-type-manual =
    .label = Ручная наладка пасярэднікаў:
    .accesskey = Р

proxy-http-label =
    .value = Пасярэднік HTTP:
    .accesskey = h

http-port-label =
    .value = Порт:
    .accesskey = п

ssl-port-label =
    .value = Порт:
    .accesskey = о

proxy-socks-label =
    .value = Трымальнік SOCKS:
    .accesskey = c

socks-port-label =
    .value = Порт:
    .accesskey = т

proxy-socks4-label =
    .label = SOCKS в4
    .accesskey = 4

proxy-socks5-label =
    .label = SOCKS в5
    .accesskey = 5

proxy-type-auto =
    .label = URL самастойнай наладкі пасярэднікаў:
    .accesskey = с

proxy-reload-label =
    .label = Абнавіць
    .accesskey = А

no-proxy-label =
    .value = Без пасярэдніка:
    .accesskey = Б

no-proxy-example = Прыклад: .mozilla.org, .net.nz, 192.168.1.0/24

proxy-password-prompt =
    .label = Не запытваць апазнаванне, калі ёсць захаваны пароль
    .accesskey = е
    .tooltiptext = Гэтая налада без запытаў выконвае апазнаванне вас на проксі, калі вы маеце захаваныя для іх уліковыя запісы. Запыт адбудзецца толькі падчас няўдачы апазнавання.

proxy-remote-dns =
    .label = Праксіраваць DNS-запыты пры выкарыстанні SOCKS v5
    .accesskey = d

