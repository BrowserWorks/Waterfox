# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-dns-over-https-url-resolver = Sağlayıcı
    .accesskey = c

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (Varsayılan)
    .tooltiptext = HTTPS üzerinden DNS'i çözümlerken varsayılan URL'i kullan

connection-dns-over-https-url-custom =
    .label = Özel
    .accesskey = Ö
    .tooltiptext = HTTPS üzerinden DNS'i çözümlemek için tercih ettiğiniz URL'i girin

connection-dns-over-https-custom-label = Özel

connection-dialog-window =
    .title = Bağlantı Ayarları
    .style =
        { PLATFORM() ->
            [macos] width: 44em !important
           *[other] width: 49em !important
        }

connection-proxy-legend = İnternete Erişmek İçin Vekil Sunucuları Yapılandırın

proxy-type-no =
    .label = Vekil sunucu kullanma
    .accesskey = n

proxy-type-wpad =
    .label = Bu ağın vekil sunucu ayarlarını otomatik tespit et
    .accesskey = s

proxy-type-system =
    .label = Sistemin vekil sunucu ayarlarını kullan
    .accesskey = n

proxy-type-manual =
    .label = Vekil sunucuyu elle yapılandır:
    .accesskey = i

proxy-http-label =
    .value = HTTP Vekil Sunucusu:
    .accesskey = H

http-port-label =
    .value = Port:
    .accesskey = P

proxy-http-sharing =
    .label = HTTPS için de bu vekil sunucusunu kullan
    .accesskey = v

proxy-https-label =
    .value = HTTPS vekil sunucusu:
    .accesskey = S

ssl-port-label =
    .value = Port:
    .accesskey = o

proxy-socks-label =
    .value = SOCKS Sunucusu:
    .accesskey = C

socks-port-label =
    .value = Port:
    .accesskey = t

proxy-socks4-label =
    .label = SOCKS v4
    .accesskey = K

proxy-socks5-label =
    .label = SOCKS v5
    .accesskey = v

proxy-type-auto =
    .label = Otomatik vekil sunucu yapılandırma adresi:
    .accesskey = a

proxy-reload-label =
    .label = Tekrar Yükle
    .accesskey = T

no-proxy-label =
    .value = Vekil Sunucu Kullanma:
    .accesskey = n

no-proxy-example = Örnek: .mozilla.org, .net.tr, 192.168.1.0/24

# Note: Do not translate localhost, 127.0.0.1 and ::1.
no-proxy-localhost-label = Localhost, 127.0.0.1 ve ::1 ile olan bağlantılar asla vekil sunucudan geçmez.

proxy-password-prompt =
    .label = Parola kayıtlıysa kimlik doğrulama isteme
    .accesskey = i
    .tooltiptext = Bu seçenek, hesap bilgilerini kaydettiğiniz vekil sunucularda kimliğinizi sessizce doğrular. Kimlik doğrulama başarısız olursa bilgileriniz sorulur.

proxy-remote-dns =
    .label = SOCKS v5 kullanırken vekil sunucu DNS’i
    .accesskey = d

proxy-enable-doh =
    .label = HTTP üzerinden DNS’i etkinleştir
    .accesskey = D
