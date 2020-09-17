# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-window =
    .title = Nagi'io' conexión
    .style =
        { PLATFORM() ->
            [macos] width: 44em
           *[other] width: 49em
        }

connection-close-key =
    .key = w

connection-disable-extension =
    .label = Duyichin' Extension

connection-proxy-configure = Gi'iaj yuhuî' proxy da' garasun' Internet

connection-proxy-option-no =
    .label = Se proxy
    .accesskey = y
connection-proxy-option-system =
    .label = Garasun' proxy daj run' huaj 'naj
    .accesskey = G
connection-proxy-option-auto =
    .label = Nana'ui' ma'ān ma daj ga proxy garasunj guenda red na.
    .accesskey = N
connection-proxy-option-manual =
    .label = Nagi'iaj mu'un' proxy
    .accesskey = N

connection-proxy-http = HTTP Proxy
    .accesskey = x
connection-proxy-http-port = Puerto
    .accesskey = P

connection-proxy-ssl-port = Puerto
    .accesskey = o

connection-proxy-ftp = FTP Proxy
    .accesskey = F
connection-proxy-ftp-port = Puerto
    .accesskey = r

connection-proxy-socks = Servidor SOCKS
    .accesskey = C
connection-proxy-socks-port = Puerto
    .accesskey = t

connection-proxy-socks4 =
    .label = SOCKS v4
    .accesskey = K
connection-proxy-socks5 =
    .label = SOCKS v5
    .accesskey = v
connection-proxy-noproxy = Nitaj proxy guenda
    .accesskey = N

connection-proxy-noproxy-desc = Example: .mozilla.org, .net.nz, 192.168.1.0/24

# Do not translate localhost, 127.0.0.1 and ::1.
connection-proxy-noproxy-localhost-desc = Nej si koñeksiûn localhost, 127.0.0.1, ni ::1 nitaj aman a'uej man gi'iaj sun man.

connection-proxy-autotype =
    .label = URL nagi'iaj ma'an proxy
    .accesskey = U

connection-proxy-reload =
    .label = Nagi'iaj nakà
    .accesskey = e

connection-proxy-autologin =
    .label = Si nachin' na'anj ma ahui si huin si 'ngà nun kontareseña
    .accesskey = S
    .tooltip = Nachin' na'anj ma sisi nanín sat da'ngà huìi. 'Ngà na'ue gi'iaj sun hue'é ma.

connection-proxy-socks-remote-dns =
    .label = Proxy DNS 'ngà garasunt SOCKS v5
    .accesskey = P

connection-dns-over-https =
    .label = Dugi'iaj sun DNS riña HTTPS
    .accesskey = H

connection-dns-over-https-url-resolver = Sa du'uej sa 'iaj sunt
    .accesskey = P

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (Sa ngà hua niñaa)
    .tooltiptext = Garasun URL ngà hua niñaada' nagi'iát DNS ngà HTTPS

connection-dns-over-https-url-custom =
    .label = Nagui'iaj mu'ûn'
    .accesskey = C
    .tooltiptext = Gachrun URL nihià' ruhuât da' nagi'iát DNS riña HTTPS

connection-dns-over-https-custom-label = Nagui'iaj mu'ûn'
