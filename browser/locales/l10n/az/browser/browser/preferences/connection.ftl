# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-window =
    .title = Bağlantı seçimləri
    .style =
        { PLATFORM() ->
            [macos] width: 44em
           *[other] width: 49em
        }

connection-close-key =
    .key = w

connection-disable-extension =
    .label = Uzantını söndür

connection-proxy-configure = İnternetə Proxy Girişini nizamla

connection-proxy-option-no =
    .label = Proksisiz
    .accesskey = s
connection-proxy-option-system =
    .label = Sistem proxy-serverlərindən istifadə et
    .accesskey = S
connection-proxy-option-auto =
    .label = Bu şəbəkənin proxy-server nizamlarını avtomaik təyin et
    .accesskey = v
connection-proxy-option-manual =
    .label = Əl ilə proksi tənzimləmə
    .accesskey = m

connection-proxy-http = HTTP Proksi
    .accesskey = k
connection-proxy-http-port = Port
    .accesskey = P

connection-proxy-ssl-port = Port
    .accesskey = o

connection-proxy-ftp = FTP Proksi
    .accesskey = F
connection-proxy-ftp-port = Port
    .accesskey = r

connection-proxy-socks = SOCKS Serveri
    .accesskey = C
connection-proxy-socks-port = Port
    .accesskey = t

connection-proxy-socks4 =
    .label = SOCKS v4
    .accesskey = K
connection-proxy-socks5 =
    .label = SOCKS v5
    .accesskey = S
connection-proxy-noproxy = Proksi işlədilməsin:
    .accesskey = n

connection-proxy-noproxy-desc = Məsələn: .mozilla.org, .net.nz, 192.168.1.0/24

connection-proxy-autotype =
    .label = Avtomatik proksi tənzimləmə URL-i
    .accesskey = A

connection-proxy-reload =
    .label = Yenilə
    .accesskey = l

connection-proxy-autologin =
    .label = Parol yadda saxlanıbsa, autentifikasiya istəmə
    .accesskey = i
    .tooltip = Bu seçim sizi etimadnamələri olan proksilərdə səssizcə təsdiqləyir. Əgər təsdiqləmədə xəta olsa sizə xəbər ediləcək.

connection-proxy-socks-remote-dns =
    .label = SOCKS v5 işlədərkən Proksi DNS
    .accesskey = d

connection-dns-over-https =
    .label = HTTPS üzərindən DNS-i aktivləşdir
    .accesskey = H

connection-dns-over-https-url-custom =
    .label = Fərdi
    .accesskey = F
    .tooltiptext = HTTPS üzərindən DNS almaq üçün fərdi ünvanınızı daxil edin

connection-dns-over-https-custom-label = Fərdi
