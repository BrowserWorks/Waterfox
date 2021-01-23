# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-window =
    .title = Mba’epytyvõrã jeikekatu rehegua
    .style =
        { PLATFORM() ->
            [macos] width: 44em
           *[other] width: 49em
        }

connection-close-key =
    .key = w

connection-disable-extension =
    .label = Moĩmbaha Monge

connection-proxy-configure = Emboheko proxy jeike Ñandutípe

connection-proxy-option-no =
    .label = Proxy ỹre
    .accesskey = y
connection-proxy-option-system =
    .label = Eipuru mboheko proxy apopyvusu
    .accesskey = U
connection-proxy-option-auto =
    .label = Ehechakuaa proxy mboheko ko ñandutípe g̃uarã
    .accesskey = w
connection-proxy-option-manual =
    .label = Proxy mbohekorã popeguáva
    .accesskey = M

connection-proxy-http = HTTP Proxy
    .accesskey = x
connection-proxy-http-port = Mbojuajuhaite
    .accesskey = P
connection-proxy-http-sharing =
    .label = Eipuru avei ko proxy FTP ha HTTPS peg̃uarã
    .accesskey = s

connection-proxy-https = HTTP Proxy
    .accesskey = H
connection-proxy-ssl-port = Mbojuajuhaite
    .accesskey = o

connection-proxy-ftp = FTP Proxy
    .accesskey = F
connection-proxy-ftp-port = Mbojuajuhaite
    .accesskey = r

connection-proxy-socks = SOCKS mohendahavusu
    .accesskey = C
connection-proxy-socks-port = Mbojuajuhaite
    .accesskey = t

connection-proxy-socks4 =
    .label = SOCKS v4
    .accesskey = K
connection-proxy-socks5 =
    .label = SOCKS v5
    .accesskey = v
connection-proxy-noproxy = Ani eipuru proxy ejapo hag̃ua
    .accesskey = N

connection-proxy-noproxy-desc = Techapyrã: .mozilla.org, .net.nz, 192.168.1.0/24

# Do not translate localhost, 127.0.0.1 and ::1.
connection-proxy-noproxy-localhost-desc = Umi jeike localhost-gua, 127.0.0.1 ha ::1 ndohasái proxy rupi.

connection-proxy-autotype =
    .label = URL mbohekorã ijeheguíva proxy mba’évape g̃uarã
    .accesskey = A

connection-proxy-reload =
    .label = Myenyhẽjey
    .accesskey = e

connection-proxy-autologin =
    .label = Ani eporandu ñemoañetete rehe eñongatúramo ñe’ẽñemi
    .accesskey = i
    .tooltip = Ko poravopyrã kirirĩguáva oñemoañetetéva proxies-pe oñongatu rire terachaukaha chupekuéra g̃uarã. Ojejeruréta chupe pe ñemoañetetéva ndoikóiramo.

connection-proxy-socks-remote-dns =
    .label = Proxy DNS eipurúva SOCKS v5
    .accesskey = d

connection-dns-over-https =
    .label = Embojuruja DNS pe HTTPS ári
    .accesskey = b

connection-dns-over-https-url-resolver = Eipuru Me’ẽha
    .accesskey = P

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (ijypykue)
    .tooltiptext = Eipuru URL ijypykuéva eike hag̃ua DNS-pe HTTPS rãngue

connection-dns-over-https-url-custom =
    .label = Momba’epyre
    .accesskey = C
    .tooltiptext = Emoinge nde URL erohoryvéva emoĩpora hag̃ua DNS HTTPS rehegua

connection-dns-over-https-custom-label = Ñemomba’epyre
