# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-window =
    .title = Байланыс баптаулары
    .style =
        { PLATFORM() ->
            [macos] width: 44em
           *[other] width: 49em
        }

connection-close-key =
    .key = w

connection-disable-extension =
    .label = Кеңейтуді сөндіру

connection-proxy-configure = Интернетпен байланысу үшін прокси-серверді баптау

connection-proxy-option-no =
    .label = Прокси сервері жоқ
    .accesskey = ж
connection-proxy-option-system =
    .label = Жүйелік прокси сервер баптауларын қолдану
    .accesskey = й
connection-proxy-option-auto =
    .label = Осы желі үшін прокси сервер баптауларын автоматты түрде анықтау
    .accesskey = л
connection-proxy-option-manual =
    .label = Прокси серверді қолмен баптау
    .accesskey = о

connection-proxy-http = HTTP прокси
    .accesskey = H
connection-proxy-http-port = Порт
    .accesskey = П

connection-proxy-http-sharing =
    .label = FTP және HTTPS үшін де бұл проксиді қолдану
    .accesskey = с

connection-proxy-https = HTTPS проксиі
    .accesskey = п
connection-proxy-ssl-port = Порт
    .accesskey = о

connection-proxy-ftp = FTP прокси
    .accesskey = F
connection-proxy-ftp-port = Порт
    .accesskey = р

connection-proxy-socks = SOCKS прокси
    .accesskey = C
connection-proxy-socks-port = Порт
    .accesskey = т

connection-proxy-socks4 =
    .label = SOCKS 4
    .accesskey = K
connection-proxy-socks5 =
    .label = SOCKS 5
    .accesskey = O
connection-proxy-noproxy = Келесі үшін прокси қолданбау
    .accesskey = л

connection-proxy-noproxy-desc = Мысалы: .mozilla-russia.org, .net.nz, 192.168.1.0/24

# Do not translate localhost, 127.0.0.1 and ::1.
connection-proxy-noproxy-localhost-desc = localhost, 127.0.0.1, және ::1 адрестеріне байланыстар проксиді қолданбайды.

connection-proxy-autotype =
    .label = Прокси серверді автоматты түрде баптайтын URL
    .accesskey = а

connection-proxy-reload =
    .label = Жаңарту
    .accesskey = р

connection-proxy-autologin =
    .label = Пароль сақталып тұрса, аутентификацияны сұрамау
    .accesskey = и
    .tooltip = Бұл баптау тіркелгі ақпараты сақталған прокси серверлерде тыныш аутентификацияны жасайды. Аутентификация сәтсіз болса, тіркелгі ақпараты сізден сұралады.

connection-proxy-socks-remote-dns =
    .label = SOCKS v5 қолдану кезінде DNS сұранымдарын прокси арқылы жіберу
    .accesskey = д

connection-dns-over-https =
    .label = HTTPS арқылы DNS іске қосу
    .accesskey = ы

connection-dns-over-https-url-resolver = Провайдерді қолдану
    .accesskey = п

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (Бастапқы)
    .tooltiptext = HTTPS арқылы DNS шешу үшін бастапқы URL қолдану

connection-dns-over-https-url-custom =
    .label = Таңдауыңызша
    .accesskey = т
    .tooltiptext = HTTPS арқылы DNS шешу үшін таңдауыңызша URL енгізіңіз

connection-dns-over-https-custom-label = Таңдауыңызша
