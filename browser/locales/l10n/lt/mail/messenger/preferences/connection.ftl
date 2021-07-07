# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-dns-over-https-url-resolver = Naudoti teikėją
    .accesskey = N
# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (numatytasis)
    .tooltiptext = Numatytoji URI serverių paieškai (DNS) HTTPS protokolu
connection-dns-over-https-url-custom =
    .label = Kita
    .accesskey = k
    .tooltiptext = Nurodykite norimą URI serverių paieškai (DNS) HTTPS protokolu
connection-dns-over-https-custom-label = Kita
connection-dialog-window =
    .title = Ryšio nuostatos
    .style =
        { PLATFORM() ->
            [macos] width: 44em !important
           *[other] width: 49em !important
        }
connection-proxy-legend = Įgaliotųjų serverių sąranka
proxy-type-no =
    .label = Nenaudoti įgaliotojo serverio
    .accesskey = N
proxy-type-wpad =
    .label = Savarankiškai aptikti šio tinklo įgaliotuosius serverius
    .accesskey = S
proxy-type-system =
    .label = Taikyti šios sistemos įgaliotojo serverio nuostatas
    .accesskey = T
proxy-type-manual =
    .label = Rankinė įgaliotųjų serverių sąranka
    .accesskey = R
proxy-http-label =
    .value = HTTP įgaliotasis serveris:
    .accesskey = H
http-port-label =
    .value = Prievadas:
    .accesskey = P
proxy-http-sharing =
    .label = Taip pat naudoti šį serverį jungiantis per HTTPS
    .accesskey = x
proxy-https-label =
    .value = HTTP įgaliotasis serveris:
    .accesskey = S
ssl-port-label =
    .value = Prievadas:
    .accesskey = i
proxy-socks-label =
    .value = SOCKS kompiuteris:
    .accesskey = O
socks-port-label =
    .value = Prievadas:
    .accesskey = e
proxy-socks4-label =
    .label = SOCKS v4
    .accesskey = 4
proxy-socks5-label =
    .label = SOCKS v5
    .accesskey = 5
proxy-type-auto =
    .label = Automatinė įgaliotųjų serverių sąranka. Failą imti iš URL:
    .accesskey = A
proxy-reload-label =
    .label = Atsiųsti iš naujo
    .accesskey = u
no-proxy-label =
    .value = Tiesiogiai jungtis prie šių sričių:
    .accesskey = š
no-proxy-example = Pavyzdys: .mozilla.org, .lrs.lt, 192.168.1.0/24
# Note: Do not translate localhost, 127.0.0.1 and ::1.
no-proxy-localhost-label = Prisijungimai prie „localhost“, 127.0.0.1, ir ::1 niekada neina per įgaliotąjį serverį.
# Do not translate "localhost", "127.0.0.1/8" and "::1". (You can translate "and".)
connection-proxy-noproxy-localhost-desc-2 = Prisijungimai prie „localhost“, 127.0.0.1, ir ::1 niekada neina per įgaliotąjį serverį.
proxy-password-prompt =
    .label = Neprašyti tapatybės patvirtinimo, jeigu slaptažodis įrašytas
    .accesskey = i
    .tooltiptext = Pažymėjus šią parinktį, bus bandoma automatiškai patvirtinti tapatybę tuose įgaliotuosiuose serveriuose, kurių slaptažodžius naršyklė turi įsiminusi. Jei šis procesas nepavyktų, jūsų bus prašoma įvesti patikslintus duomenis.
proxy-remote-dns =
    .label = Įgaliotojo serverio DNS, kai naudojamas SOCKS v5
    .accesskey = d
proxy-enable-doh =
    .label = Įjungti DNS per HTTPS
    .accesskey = b
