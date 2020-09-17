# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-window =
    .title = ਕੁਨੈਕਸ਼ਨ ਸੈਟਿੰਗ
    .style =
        { PLATFORM() ->
            [macos] width: 44em
           *[other] width: 49em
        }

connection-close-key =
    .key = w

connection-disable-extension =
    .label = ਇਕਸਟੈਨਸ਼ਨ ਨੂੰ ਅਸਮਰੱਥ ਕਰੋ

connection-proxy-configure = ਇੰਟਰਨੈੱਟ ਲਈ ਪਰਕਾਸੀ ਪਹੁੰਚ ਦੀ ਸੰਰਚਨਾ ਕਰੋ

connection-proxy-option-no =
    .label = ਪਰਾਕਸੀ ਨਹੀਂ
    .accesskey = x
connection-proxy-option-system =
    .label = ਸਿਸਟਮ ਪਰਾਕਸੀ ਸੈਟਿੰਗ ਵਰਤੋਂ
    .accesskey = y
connection-proxy-option-auto =
    .label = ਇਸ ਨੈੱਟਵਰਕ ਲਈ ਪਰਾਕਸੀ ਦੀ ਖੋਜ ਖੁਦ ਕਰੋ
    .accesskey = w
connection-proxy-option-manual =
    .label = ਖੁਦ ਦੀ ਪਰਾਕਸੀ ਸੰਰਚਨਾ
    .accesskey = m

connection-proxy-http = HTTP ਪਰਾਕਸੀ
    .accesskey = x
connection-proxy-http-port = ਪੋਰਟ
    .accesskey = p

connection-proxy-http-sharing =
    .label = ਇਹੀ ਪਰਾਕਸੀ FTP ਅਤੇ HTTPS ਲਈ ਵੀ ਵਰਤੋ
    .accesskey = s

connection-proxy-https = HTTPS ਪਰਾਕਸੀ
    .accesskey = H
connection-proxy-ssl-port = ਪੋਰਟ
    .accesskey = o

connection-proxy-ftp = FTP ਪਰਾਕਸੀ
    .accesskey = F
connection-proxy-ftp-port = ਪੋਰਟ
    .accesskey = r

connection-proxy-socks = SOCKS ਹੋਸਟ
    .accesskey = C
connection-proxy-socks-port = ਪੋਰਟ
    .accesskey = t

connection-proxy-socks4 =
    .label = SOCKS v4
    .accesskey = k
connection-proxy-socks5 =
    .label = SOCKS v5
    .accesskey = v
connection-proxy-noproxy = ਇਸ ਲਈ ਕੋਈ ਪਰਾਕਸੀ ਨਹੀਂ
    .accesskey = n

connection-proxy-noproxy-desc = ਜਿਵੇਂ: .mozilla.org, .net.nz, 192.168.1.0/24

# Do not translate localhost, 127.0.0.1 and ::1.
connection-proxy-noproxy-localhost-desc = ਲੋਕਲਹੋਸਟ, 127.0.0.1, ਅਤੇ :: 1 ਨਾਲ ਕਨੈਕਸ਼ਨ ਕਦੇ ਵੀ ਪਰਾਕਸੀ ਨਹੀਂ ਹੁੰਦੇ।

connection-proxy-autotype =
    .label = ਆਟੋਮੈਟਿਕ ਪਰਾਕਸੀ ਸੰਰਚਨਾ URL
    .accesskey = A

connection-proxy-reload =
    .label = ਮੁੜ ਲੋਡ
    .accesskey = l

connection-proxy-autologin =
    .label = ਜੇ ਪਛਾਣ-ਸ਼ਬਦ ਸੰਭਾਲਿਆ ਹੈ ਤਾਂ ਪਰਮਾਣਿਤ ਕਰਨ ਲਈ ਨਾ ਪੁੱਛੋ
    .accesskey = i
    .tooltip = ਇਹ ਚੋਣ ਚੁੱਪਚਾਪ ਢੰਗ ਨਾਲ ਤੁਹਾਨੂੰ ਪਰਾਕਸੀਆਂ ਲਈ ਪਰਮਾਣਿਤ ਕਰਦੀ ਹੈ, ਜਦੋਂ ਤੁਸੀਂ ਉਹਨਾਂ ਲਈ ਪਰਮਾਣਕਿਤਾ ਸੰਭਾਲਦੇ ਹੋ। ਤੁਹਾਨੂੰ ਪੁੱਛਿਆ ਜਾਵੇਗਾ, ਜੇ ਪ੍ਰਮਾਣਕਿਤਾ ਫੇਲ੍ਹ ਹੋਈ।

connection-proxy-socks-remote-dns =
    .label = ਪਰਾਕਸੀ DNS, ਜਦੋਂ SOCKS v5 ਦੀ ਵਰਤੋਂ ਹੋਵੇ
    .accesskey = d

connection-dns-over-https =
    .label = HTTPS ‘ਤੇ DNS ਸਮਰੱਥ ਕਰੋ
    .accesskey = b

connection-dns-over-https-url-resolver = ਪੂਰਕ ਵਰਤੋ
    .accesskey = P

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (ਮੂਲ)
    .tooltiptext = HTTPS ਉੱਤੇ DNS ਹੱਲ਼ ਕਰਨ ਲਈ ਮੂਲ URL ਵਰਤੋ

connection-dns-over-https-url-custom =
    .label = ਕਸਟਮ
    .accesskey = C
    .tooltiptext = HTTS ਉੱਤੇ DNS ਹੱਲ਼ ਕਰਨ ਲਈ ਆਪਣਾ ਤਰਜੀਹੀ URL ਦਿਓ

connection-dns-over-https-custom-label = ਪਸੰਦੀਦਾ
