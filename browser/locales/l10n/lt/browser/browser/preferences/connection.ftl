# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-window =
    .title = Ryšio nuostatos
    .style =
        { PLATFORM() ->
            [macos] width: 44em
           *[other] width: 49em
        }
connection-close-key =
    .key = w
connection-disable-extension =
    .label = Išjungti priedą
connection-proxy-configure = Įgaliotųjų serverių sąranka
connection-proxy-option-no =
    .label = Nenaudoti įgaliotojo serverio
    .accesskey = N
connection-proxy-option-system =
    .label = Taikyti šios sistemos įgaliotojo serverio nuostatas
    .accesskey = T
connection-proxy-option-auto =
    .label = Savarankiškai aptikti šio tinklo įgaliotuosius serverius
    .accesskey = S
connection-proxy-option-manual =
    .label = Rankinė įgaliotųjų serverių sąranka
    .accesskey = r
connection-proxy-http = HTTP įgaliotasis serveris
    .accesskey = g
connection-proxy-http-port = Prievadas
    .accesskey = P
connection-proxy-http-sharing =
    .label = Taip pat naudoti šį serverį jungiantis per FTP ir HTTPS
    .accesskey = s
connection-proxy-https-sharing =
    .label = Taip pat naudoti šį serverį jungiantis per HTTPS
    .accesskey = s
connection-proxy-https = HTTPS įgaliotasis serveris
    .accesskey = H
connection-proxy-ssl-port = Prievadas
    .accesskey = i
connection-proxy-ftp = FTP įgaliotasis serveris
    .accesskey = F
connection-proxy-ftp-port = Prievadas
    .accesskey = e
connection-proxy-socks = SOCKS kompiuteris
    .accesskey = C
connection-proxy-socks-port = Prievadas
    .accesskey = d
connection-proxy-socks4 =
    .label = SOCKS v4
    .accesskey = 4
connection-proxy-socks5 =
    .label = SOCKS v5
    .accesskey = 5
connection-proxy-noproxy = Tiesiogiai jungtis prie
    .accesskey = t
connection-proxy-noproxy-desc = Pavyzdys: .mozilla.org, .lrs.lt, 192.168.1.0/24
# Do not translate localhost, 127.0.0.1 and ::1.
connection-proxy-noproxy-localhost-desc = Prisijungimai prie localhost, 127.0.0.1, ir ::1 niekada neina per įgaliotąjį serverį.
# Do not translate "localhost", "127.0.0.1/8" and "::1". (You can translate "and".)
connection-proxy-noproxy-localhost-desc-2 = Prisijungimai prie localhost, 127.0.0.1/8, ir ::1 niekada neina per įgaliotąjį serverį.
connection-proxy-autotype =
    .label = Automatinė įgaliotųjų serverių sąranka iš URL
    .accesskey = A
connection-proxy-reload =
    .label = Atsiųsti iš naujo
    .accesskey = u
connection-proxy-autologin =
    .label = Neprašyti tapatybės patvirtinimo, jeigu slaptažodis įrašytas
    .accesskey = b
    .tooltip = Pažymėjus šią parinktį, bus bandoma automatiškai patvirtinti tapatybę tuose įgaliotuosiuose serveriuose, kurių slaptažodžius naršyklė turi įsiminusi. Jei šis procesas nepavyktų, jūsų bus prašoma įvesti patikslintus duomenis.
connection-proxy-socks-remote-dns =
    .label = Įgaliotojo serverio DNS, kai naudojamas SOCKS v5
    .accesskey = d
connection-dns-over-https =
    .label = Įjungti DNS per HTTPS
    .accesskey = j
connection-dns-over-https-url-resolver = Naudoti teikėją
    .accesskey = t
# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (numatytasis)
    .tooltiptext = DNS išrišimui per HTTPS naudoti numatytąjį URL
connection-dns-over-https-url-custom =
    .label = Pasirinktinis
    .accesskey = P
    .tooltiptext = Įveskite norimą URL, skirtą DNS per HTTPS išrišimui
connection-dns-over-https-custom-label = Kitas
