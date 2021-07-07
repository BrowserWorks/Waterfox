# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-dns-over-https-url-resolver = Use Provider
    .accesskey = r
# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (Default)
    .tooltiptext = Use the default URL for resolving DNS over HTTPS
connection-dns-over-https-url-custom =
    .label = Custom
    .accesskey = C
    .tooltiptext = Enter your preferred URL for resolving DNS over HTTPS
connection-dns-over-https-custom-label = Custom
connection-dialog-window =
    .title = Connection Settings
    .style =
        { PLATFORM() ->
            [macos] width: 44em !important
           *[other] width: 49em !important
        }
connection-disable-extension =
    .label = Disable Extension
connection-proxy-legend = Configure Proxies to Access the Internet
proxy-type-no =
    .label = No proxy
    .accesskey = y
proxy-type-wpad =
    .label = Auto-detect proxy settings for this network
    .accesskey = w
proxy-type-system =
    .label = Use system proxy settings
    .accesskey = u
proxy-type-manual =
    .label = Manual proxy configuration:
    .accesskey = m
proxy-http-label =
    .value = HTTP Proxy:
    .accesskey = h
http-port-label =
    .value = Port:
    .accesskey = p
proxy-http-sharing =
    .label = Also use this proxy for HTTPS
    .accesskey = x
proxy-https-label =
    .value = HTTPS Proxy:
    .accesskey = S
ssl-port-label =
    .value = Port:
    .accesskey = o
proxy-socks-label =
    .value = SOCKS Host:
    .accesskey = c
socks-port-label =
    .value = Port:
    .accesskey = t
proxy-socks4-label =
    .label = SOCKS v4
    .accesskey = k
proxy-socks5-label =
    .label = SOCKS v5
    .accesskey = v
proxy-type-auto =
    .label = Automatic proxy configuration URL:
    .accesskey = A
proxy-reload-label =
    .label = Reload
    .accesskey = l
no-proxy-label =
    .value = No Proxy for:
    .accesskey = n
no-proxy-example = Example: .mozilla.org, .net.nz, 192.168.1.0/24
# Note: Do not translate localhost, 127.0.0.1 and ::1.
no-proxy-localhost-label = Connections to localhost, 127.0.0.1, and ::1 are never proxied.
# Do not translate "localhost", "127.0.0.1/8" and "::1". (You can translate "and".)
connection-proxy-noproxy-localhost-desc-2 = Connections to localhost, 127.0.0.1/8, and ::1 are never proxied.
proxy-password-prompt =
    .label = Do not prompt for authentication if password is saved
    .accesskey = i
    .tooltiptext = This option silently authenticates you to proxies when you have saved credentials for them. You will be prompted if authentication fails.
proxy-remote-dns =
    .label = Proxy DNS when using SOCKS v5
    .accesskey = D
proxy-enable-doh =
    .label = Enable DNS over HTTPS
    .accesskey = b
