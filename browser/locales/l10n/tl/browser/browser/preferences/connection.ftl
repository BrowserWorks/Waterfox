# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-window =
    .title = Mga Setting ng Koneksyon
    .style =
        { PLATFORM() ->
            [macos] width: 44em
           *[other] width: 49em
        }

connection-close-key =
    .key = w

connection-disable-extension =
    .label = Huwag Paganahin and Extensyon

connection-proxy-configure = I-configure ang Proxy upang Ma-access ang Internet

connection-proxy-option-no =
    .label = Walang proxy
    .accesskey = y
connection-proxy-option-system =
    .label = Gamitin ang mga proxy setting ng sistema
    .accesskey = u
connection-proxy-option-auto =
    .label = Kusang mag-detect ng mga proxy setting para sa network na ito
    .accesskey = w
connection-proxy-option-manual =
    .label = Manu-manong configuration ng proxy
    .accesskey = m

connection-proxy-http = Proxy pang-HTTP
    .accesskey = x
connection-proxy-http-port = Port
    .accesskey = P

connection-proxy-http-sharing =
    .label = Gamitin din ang proxy na ito para sa FTP at HTTPS
    .accesskey = s

connection-proxy-https = HTTPS Proxy
    .accesskey = H
connection-proxy-ssl-port = Port
    .accesskey = o

connection-proxy-ftp = Proxy pang-FTP
    .accesskey = F
connection-proxy-ftp-port = Port
    .accesskey = r

connection-proxy-socks = SOCKS Host
    .accesskey = C
connection-proxy-socks-port = Port
    .accesskey = t

connection-proxy-socks4 =
    .label = SOCKS v4
    .accesskey = K
connection-proxy-socks5 =
    .label = SOCKS v5
    .accesskey = v
connection-proxy-noproxy = Walang Proxy para sa
    .accesskey = n

connection-proxy-noproxy-desc = Halimbawa: .mozilla.org, .net.nz, 192.168.1.0/24

# Do not translate localhost, 127.0.0.1 and ::1.
connection-proxy-noproxy-localhost-desc = Hindi napo-proxy ang mga connection sa localhost, 127.0.0.1, at ::1.

connection-proxy-autotype =
    .label = Automatic proxy configuration URL
    .accesskey = A

connection-proxy-reload =
    .label = I-reload
    .accesskey = e

connection-proxy-autologin =
    .label = Huwag nang humingi ng authentication kung naka-save ang password
    .accesskey = i
    .tooltip = Ang pagpipiliang ito ay tahimik na nag-o-authenticate sa iyo sa mga proxy kapag may naka-save kang mga credential. Aabisuhan ka naman kung nabigo ang authentication.

connection-proxy-socks-remote-dns =
    .label = Proxy DNS kapag gumagamit ng SOCKS v5
    .accesskey = d

connection-dns-over-https =
    .label = Paganahin ang DNS over HTTPS
    .accesskey = b

connection-dns-over-https-url-resolver = Gamitin ang Provider
    .accesskey = P

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (Default)
    .tooltiptext = Gamitin ang default na URL sa pagresolba ng DNS over HTTPS

connection-dns-over-https-url-custom =
    .label = Custom
    .accesskey = C
    .tooltiptext = Maglagay ng URL na gusto mong gamitin para sa pag-resolba ng DNS nang naka-HTTPS

connection-dns-over-https-custom-label = Custom
