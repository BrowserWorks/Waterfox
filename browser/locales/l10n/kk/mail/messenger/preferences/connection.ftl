# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-dns-over-https-url-resolver = Провайдерді қолдану
    .accesskey = й

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (Бастапқы)
    .tooltiptext = HTTPS арқылы DNS шешу кезінде бастапқы URL қолдану

connection-dns-over-https-url-custom =
    .label = Таңдауыңызша
    .accesskey = д
    .tooltiptext = HTTPS арқылы DNS шешу үшін өзіңіздің URL-ын енгізіңіз

connection-dns-over-https-custom-label = Таңдауыңызша

connection-dialog-window =
    .title = Байланыс баптаулары
    .style =
        { PLATFORM() ->
            [macos] width: 44em !important
           *[other] width: 49em !important
        }

connection-proxy-legend = Интернетпен байланысу үшін прокси-серверді баптау

proxy-type-no =
    .label = Прокси сервері жоқ
    .accesskey = ж

proxy-type-wpad =
    .label = Осы желі үшін прокси сервер баптауларын автоматты түрде анықтау
    .accesskey = л

proxy-type-system =
    .label = Жүйелік прокси сервер баптауларын қолдану
    .accesskey = й

proxy-type-manual =
    .label = Прокси серверді қолмен баптау:
    .accesskey = о

proxy-http-label =
    .value = HTTP прокси:
    .accesskey = H

http-port-label =
    .value = Порт:
    .accesskey = П

proxy-http-sharing =
    .label = HTTPS үшін де бұл проксиді қолдану
    .accesskey = к

proxy-https-label =
    .value = HTTP прокси:
    .accesskey = с

ssl-port-label =
    .value = Порт:
    .accesskey = о

proxy-socks-label =
    .value = SOCKS хосты:
    .accesskey = C

socks-port-label =
    .value = Порт:
    .accesskey = т

proxy-socks4-label =
    .label = SOCKS 4
    .accesskey = K

proxy-socks5-label =
    .label = SOCKS 5
    .accesskey = O

proxy-type-auto =
    .label = Прокси серверді автоматты түрде баптайтын URL:
    .accesskey = а

proxy-reload-label =
    .label = Қайтау жүктеу
    .accesskey = й

no-proxy-label =
    .value = Келесі үшін прокси қолданбау:
    .accesskey = л

no-proxy-example = Мысалы: .mozilla.org, .net.nz, 192.168.1.0/24

# Note: Do not translate localhost, 127.0.0.1 and ::1.
no-proxy-localhost-label = localhost, 127.0.0.1, және ::1 адрестеріне байланыстар проксиді қолданбайды.

proxy-password-prompt =
    .label = Пароль сақталып тұрса, аутентификацияны сұрамау
    .accesskey = и
    .tooltiptext = Бұл баптау тіркелгі ақпараты сақталған прокси серверлерде тыныш аутентификацияны жасайды. Аутентификация сәтсіз болса, тіркелгі ақпараты сізден сұралады.

proxy-remote-dns =
    .label = SOCKS v5 қолдану кезінде DNS сұранымдарын прокси арқылы жіберу
    .accesskey = д

proxy-enable-doh =
    .label = HTTPS арқылы DNS іске қосу
    .accesskey = е
