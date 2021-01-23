# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-window =
    .title = Agordoj de konektado
    .style =
        { PLATFORM() ->
            [macos] width: 44em
           *[other] width: 49em
        }

connection-close-key =
    .key = w

connection-disable-extension =
    .label = Malaktivigi etendaĵon

connection-proxy-configure = Agordi la aliron de la retperanto al la reto

connection-proxy-option-no =
    .label = Sen retperanto
    .accesskey = r
connection-proxy-option-system =
    .label = Uzi la sistemajn agordojn de retperantoj
    .accesskey = u
connection-proxy-option-auto =
    .label = Aŭtomate eltrovi la agordojn de retperantoj por tiu ĉi reto
    .accesskey = e
connection-proxy-option-manual =
    .label = Neaŭtomata agordo de retperanto
    .accesskey = n

connection-proxy-http = Peranto por HTTP
    .accesskey = H
connection-proxy-http-port = Pordo
    .accesskey = P

connection-proxy-http-sharing =
    .label = Uzi tiun ĉi retperanton ankaŭ por FTP kaj HTTPS.
    .accesskey = U

connection-proxy-https = Retperanto HTTPS
    .accesskey = H
connection-proxy-ssl-port = Pordo
    .accesskey = o

connection-proxy-ftp = Peranto por FTP
    .accesskey = F
connection-proxy-ftp-port = Pordo
    .accesskey = r

connection-proxy-socks = Servilo SOCKS
    .accesskey = S
connection-proxy-socks-port = Pordo
    .accesskey = d

connection-proxy-socks4 =
    .label = SOCKS v4
    .accesskey = K
connection-proxy-socks5 =
    .label = SOCKS v5
    .accesskey = v
connection-proxy-noproxy = Sen retperanto por
    .accesskey = s

connection-proxy-noproxy-desc = Ekzemplo: .mozilla.org, .net.nz, 192.168.1.0/24

# Do not translate localhost, 127.0.0.1 and ::1.
connection-proxy-noproxy-localhost-desc = Konektoj kun localhost, 127.0.0.1, kaj ::1 neniam iras tra retperanto.

connection-proxy-autotype =
    .label = Adreso de aŭtomata agordo de retperanto
    .accesskey = A

connection-proxy-reload =
    .label = Reŝargi
    .accesskey = e

connection-proxy-autologin =
    .label = Ne pridemandi aŭtentikigon se la pasvorto estas konservita
    .accesskey = a
    .tooltip = Tiu ĉi elekteblo silente legitimas vin ĉe retperantoj se vi konservis la legitimaĵojn por ili. Vi estos pridemandita se la legitimo estas malsukcesa.

connection-proxy-socks-remote-dns =
    .label = Peranta DNS dum uzo de SOCKS v5
    .accesskey = d

connection-dns-over-https =
    .label = Aktivigi DNS sur HTTPS
    .accesskey = A

connection-dns-over-https-url-resolver = Uzi provizanton
    .accesskey = U

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (Norma)
    .tooltiptext = Uzi la norman retadreson por DNS per HTTPS

connection-dns-over-https-url-custom =
    .label = Personecigita
    .accesskey = P
    .tooltiptext = Entajpu retadreson de preferata servilo por DNS per HTTPS

connection-dns-over-https-custom-label = Personecigita
