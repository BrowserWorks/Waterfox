# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-window =
    .title = Savienojuma iestatījumi
    .style =
        { PLATFORM() ->
            [macos] width: 44em
           *[other] width: 49em
        }

connection-close-key =
    .key = w

connection-disable-extension =
    .label = Deaktivēt paplašinājumu

connection-proxy-configure = Konfigurēt starpniekserverus un piekļuvi internetam

connection-proxy-option-no =
    .label = Bez proxy
    .accesskey = y
connection-proxy-option-system =
    .label = Izmantot sistēmas proxy iestatījumus
    .accesskey = u
connection-proxy-option-auto =
    .label = Automātiski noteikt starpniekservera iestatījumus šim tīklam
    .accesskey = n
connection-proxy-option-manual =
    .label = Pielāgota starpniekserveru konfigurācija
    .accesskey = m

connection-proxy-http = HTTP starpniekserveris
    .accesskey = x
connection-proxy-http-port = Ports
    .accesskey = P

connection-proxy-ssl-port = Ports
    .accesskey = o

connection-proxy-ftp = FTP starpniekserveris
    .accesskey = F
connection-proxy-ftp-port = Ports
    .accesskey = r

connection-proxy-socks = SOCKS resursdators
    .accesskey = C
connection-proxy-socks-port = Ports
    .accesskey = t

connection-proxy-socks4 =
    .label = SOCKS v4
    .accesskey = K
connection-proxy-socks5 =
    .label = SOCKS v5
    .accesskey = v
connection-proxy-noproxy = Bez starpnieka
    .accesskey = n

connection-proxy-noproxy-desc = Piemērs: .mozilla.org, .net.nz, 192.168.1.0/24

connection-proxy-autotype =
    .label = Automātiskās starpniekservera konfigurācijas adrese
    .accesskey = A

connection-proxy-reload =
    .label = Pārlādēt
    .accesskey = r

connection-proxy-autologin =
    .label = Nejautāt autentifikāciju, ja ir saglabāta parole
    .accesskey = i
    .tooltip = Šī iespēja nemanot autentificēs jūs starpniekserveros, kuriem jums ir saglabāta parole. Ja autentifikācija neizdosies, jums tiks parādīts autentifikācijas logs.

connection-proxy-socks-remote-dns =
    .label = Starpniekservera DNS izmantojot SOCKS v5
    .accesskey = D

connection-dns-over-https =
    .label = Aktivēt DNS pa HTTPS
    .accesskey = D

connection-dns-over-https-url-custom =
    .label = Pielāgots
    .accesskey = P
    .tooltiptext = Ievadiet savu adresi, ko izmantot, lai strādātu ar DNS pa HTTPS

