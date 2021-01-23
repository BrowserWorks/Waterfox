# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-window =
    .title = Поставки за врската
    .style =
        { PLATFORM() ->
            [macos] width: 44em
           *[other] width: 49em
        }

connection-close-key =
    .key = w

connection-proxy-option-no =
    .label = Без посредник
    .accesskey = Б
connection-proxy-option-system =
    .label = Користи ги системските поставки за посредник
    .accesskey = и
connection-proxy-option-auto =
    .label = Авто-откривање на поставки за посредник за оваа мрежа
    .accesskey = о

connection-proxy-http-port = Порта
    .accesskey = П

connection-proxy-ssl-port = Порта
    .accesskey = о

connection-proxy-ftp-port = Порта
    .accesskey = р

connection-proxy-socks-port = Порта
    .accesskey = т

connection-proxy-socks4 =
    .label = SOCKS v4
    .accesskey = K
connection-proxy-socks5 =
    .label = SOCKS v5
    .accesskey = v

connection-proxy-noproxy-desc = Пример: .mozilla.org, .net.nz, 192.168.1.0/24

connection-proxy-reload =
    .label = Превчитај
    .accesskey = е

