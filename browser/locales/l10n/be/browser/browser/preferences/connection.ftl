# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-window =
    .title = Параметры злучэння
    .style =
        { PLATFORM() ->
            [macos] width: 44em
           *[other] width: 49em
        }

connection-close-key =
    .key = w

connection-disable-extension =
    .label = Адключыць пашырэнне

connection-proxy-configure = Наладзіць доступ да Інтэрнэту праз проксі

connection-proxy-option-no =
    .label = Без проксі
    .accesskey = з
connection-proxy-option-system =
    .label = Ужываць сістэмныя налады проксі
    .accesskey = У
connection-proxy-option-auto =
    .label = Аўтаматычна вызначаць налады проксі для гэтай сеткі
    .accesskey = ц
connection-proxy-option-manual =
    .label = Ручная наладка проксі
    .accesskey = р

connection-proxy-http = HTTP проксі
    .accesskey = п
connection-proxy-http-port = Порт
    .accesskey = п

connection-proxy-http-sharing =
    .label = Таксама выкарыстоўваць гэты проксі для FTP і HTTPS
    .accesskey = п

connection-proxy-https = HTTPS-проксі
    .accesskey = H
connection-proxy-ssl-port = Порт
    .accesskey = о

connection-proxy-ftp = FTP проксі
    .accesskey = F
connection-proxy-ftp-port = Порт
    .accesskey = р

connection-proxy-socks = Трымальнік SOCKS
    .accesskey = C
connection-proxy-socks-port = Порт
    .accesskey = т

connection-proxy-socks4 =
    .label = SOCKS в4
    .accesskey = 4
connection-proxy-socks5 =
    .label = SOCKS в5
    .accesskey = 5
connection-proxy-noproxy = Без проксі для
    .accesskey = е

connection-proxy-noproxy-desc = Прыклад: .mozilla.org, .net.nz, 192.168.1.0/24

# Do not translate localhost, 127.0.0.1 and ::1.
connection-proxy-noproxy-localhost-desc = Злучэнне з localhost, 127.0.0.1 і :: 1 заўжды ідзе без без проксі.

connection-proxy-autotype =
    .label = URL аўтаматычнай наладкі проксі
    .accesskey = а

connection-proxy-reload =
    .label = Абнавіць
    .accesskey = А

connection-proxy-autologin =
    .label = Не запытваць апазнаванне, калі ёсць захаваны пароль
    .accesskey = Н
    .tooltip = Гэтая налада без запытаў выконвае апазнаванне вас на проксі, калі вы маеце захаваныя для іх уліковыя запісы. Запыт адбудзецца толькі падчас няўдачы апазнавання.

connection-proxy-socks-remote-dns =
    .label = Праксіраваць DNS-запыты пры выкарыстанні SOCKS v5
    .accesskey = з

connection-dns-over-https =
    .label = Уключыць DNS праз HTTPS
    .accesskey = р

connection-dns-over-https-url-resolver = Выкарыстоўваць правайдар
    .accesskey = п

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (прадвызначаны)
    .tooltiptext = Выкарыстоўваць прадвызначаны URL для працы DNS паверх HTTPS

connection-dns-over-https-url-custom =
    .label = Адмысловы
    .accesskey = с
    .tooltiptext = Увядзіце ўласны URL-адрас для развязвання DNS праз HTTPS

connection-dns-over-https-custom-label = Адмысловы
