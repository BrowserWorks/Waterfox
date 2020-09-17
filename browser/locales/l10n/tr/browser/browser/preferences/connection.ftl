# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-window =
    .title = Bağlantı Ayarları
    .style =
        { PLATFORM() ->
            [macos] width: 44em
           *[other] width: 49em
        }

connection-close-key =
    .key = w

connection-disable-extension =
    .label = Eklentiyi etkisizleştir

connection-proxy-configure = İnternete erişmek için vekil sunucuyu yapılandır

connection-proxy-option-no =
    .label = Vekil sunucu yok
    .accesskey = e
connection-proxy-option-system =
    .label = Sistem vekil sunucu ayarlarını kullan
    .accesskey = S
connection-proxy-option-auto =
    .label = Bu ağın vekil sunucu ayarlarını kendiliğinden tanı
    .accesskey = v
connection-proxy-option-manual =
    .label = Vekil sunucuyu elle ayarla
    .accesskey = k

connection-proxy-http = HTTP vekil sunucusu
    .accesskey = p
connection-proxy-http-port = Port
    .accesskey = P

connection-proxy-http-sharing =
    .label = FTP ve HTTPS için de bu vekil sunucusunu kullan
    .accesskey = F

connection-proxy-https = HTTPS vekil sunucusu
    .accesskey = H
connection-proxy-ssl-port = Port
    .accesskey = o

connection-proxy-ftp = FTP vekil sunucusu
    .accesskey = F
connection-proxy-ftp-port = Port
    .accesskey = r

connection-proxy-socks = SOCKS sunucusu
    .accesskey = C
connection-proxy-socks-port = Port
    .accesskey = t

connection-proxy-socks4 =
    .label = SOCKS v4
    .accesskey = K
connection-proxy-socks5 =
    .label = SOCKS v5
    .accesskey = v
connection-proxy-noproxy = Aşağıdakiler için vekil sunucu kullanılmasın
    .accesskey = A

connection-proxy-noproxy-desc = Örnek: .mozilla.org, .com.tr, 192.168.1.0/24

# Do not translate localhost, 127.0.0.1 and ::1.
connection-proxy-noproxy-localhost-desc = Localhost, 127.0.0.1 ve ::1 ile olan bağlantılar asla vekil sunucudan geçmez.

connection-proxy-autotype =
    .label = Otomatik vekil sunucu yapılandırma URL’si
    .accesskey = O

connection-proxy-reload =
    .label = Yenile
    .accesskey = l

connection-proxy-autologin =
    .label = Parola kayıtlıysa kimlik doğrulama isteme
    .accesskey = i
    .tooltip = Bu seçenek, hesap bilgilerini kaydettiğiniz vekil sunucularda kimliğinizi sessizce doğrular. Kimlik doğrulama başarısız olursa bilgileriniz sorulur.

connection-proxy-socks-remote-dns =
    .label = SOCKS v5 kullanırken vekil sunucu DNS’i
    .accesskey = d

connection-dns-over-https =
    .label = HTTPS üzerinden DNS’i etkinleştir
    .accesskey = H

connection-dns-over-https-url-resolver = Sağlayıcı
    .accesskey = S

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (Varsayılan)
    .tooltiptext = DNS'i HTTPS üzerinden çözümlemek için varsayılan URL'yi kullan

connection-dns-over-https-url-custom =
    .label = Özel
    .accesskey = Ö
    .tooltiptext = HTTPS üzerinden DNS’i çözümlemek için tercih ettiğiniz adresi girin

connection-dns-over-https-custom-label = Özel
