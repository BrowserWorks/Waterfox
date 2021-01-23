# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-window =
    .title = Iɣewwaṛen n tuqqna
    .style =
        { PLATFORM() ->
            [macos] width: 44em
           *[other] width: 49em
        }

connection-close-key =
    .key = w

connection-disable-extension =
    .label = Sens aseɣzif

connection-proxy-configure = Swel anekcum Proxy γer internet

connection-proxy-option-no =
    .label = Ulac apṛuksi
    .accesskey = l
connection-proxy-option-system =
    .label = Seqdec iɣewwaṛen n upṛuksi n unagraw
    .accesskey = S
connection-proxy-option-auto =
    .label = Tifin tawurmant n iɣewwaṛen n upṛuksi n uẓeṭṭa-a
    .accesskey = T
connection-proxy-option-manual =
    .label = Tawila s ufus n upṛuksi
    .accesskey = k

connection-proxy-http = Apṛuksi HTTP
    .accesskey = q
connection-proxy-http-port = Tabburt
    .accesskey = P

connection-proxy-http-sharing =
    .label = Seqdec daɣen apṛuksi-a i FTP akked HTTPS
    .accesskey = s

connection-proxy-https = Apṛuksi HTTP
    .accesskey = P
connection-proxy-ssl-port = Tabburt
    .accesskey = o

connection-proxy-ftp = Apṛuksi FTP
    .accesskey = S
connection-proxy-ftp-port = Tabburt
    .accesskey = r

connection-proxy-socks = Asenneftaɣ SOCKS
    .accesskey = C
connection-proxy-socks-port = Tabburt
    .accesskey = t

connection-proxy-socks4 =
    .label = SOCKS L4
    .accesskey = K
connection-proxy-socks5 =
    .label = SOCKS L5
    .accesskey = L
connection-proxy-noproxy = Ulac apṛuksi i
    .accesskey = l

connection-proxy-noproxy-desc = Amedya: .mozilla.org, .net.nz, 192.168.1.0/24

# Do not translate localhost, 127.0.0.1 and ::1.
connection-proxy-noproxy-localhost-desc = Tuqqniwin ɣer localhost, 127.0.0.1 ou ::1 urǧin ad ɛeddint s upṛuksi.

connection-proxy-autotype =
    .label = Tansa n twila tawurmant n upṛuksi URL
    .accesskey = G

connection-proxy-reload =
    .label = Smiren
    .accesskey = S

connection-proxy-autologin =
    .label = Ur sutur ara asesteb ma yella awal uffir yettwakles
    .accesskey = k
    .tooltip = Aɣewwaṛ-a ad k-isesteb s wudem awurman deg iqeddacen n apruksi, anda awal uffir yekles. Ticki asesteb ur yeddi ara, ad k-d-nessuter awal uffir.

connection-proxy-socks-remote-dns =
    .label = Apṛuksi DNS ticki SOCKS v5 yettwaseqdec
    .accesskey = d

connection-dns-over-https =
    .label = Rmed DNS Deg HTTPS
    .accesskey = H

connection-dns-over-https-url-resolver = Seqdec asaǧǧaw
    .accesskey = S

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (s wudem amezwer)
    .tooltiptext = Seqdec tansa URL s wudem amezwer i tifrat n DNS s HTTPS

connection-dns-over-https-url-custom =
    .label = Sagen
    .accesskey = S
    .tooltiptext = Sekcem URL i tebɣiḍ i tifrat n DNS s HTTPS

connection-dns-over-https-custom-label = Udmawan
