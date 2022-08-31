# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-window =
    .title = 連線設定
    .style =
        { PLATFORM() ->
            [macos] width: 44em
           *[other] width: 49em
        }

connection-close-key =
    .key = w

connection-disable-extension =
    .label = 停用擴充套件

connection-proxy-configure = 設定存取網際網路的代理伺服器

connection-proxy-option-no =
    .label = 不使用 Proxy
    .accesskey = y
connection-proxy-option-system =
    .label = 使用系統 Proxy 設定
    .accesskey = U
connection-proxy-option-auto =
    .label = 自動偵測此網路的 Proxy 設定
    .accesskey = w
connection-proxy-option-manual =
    .label = 手動設定 Proxy
    .accesskey = m

connection-proxy-http = HTTP Proxy
    .accesskey = x
connection-proxy-http-port = 埠
    .accesskey = P

connection-proxy-https-sharing =
    .label = 也針對 HTTPS 連線使用此代理伺服器
    .accesskey = s

connection-proxy-https = HTTPS Proxy
    .accesskey = H
connection-proxy-ssl-port = 埠
    .accesskey = o

connection-proxy-socks = SOCKS 主機
    .accesskey = C
connection-proxy-socks-port = 埠
    .accesskey = t

connection-proxy-socks4 =
    .label = SOCKS v4
    .accesskey = K
connection-proxy-socks5 =
    .label = SOCKS v5
    .accesskey = v
connection-proxy-noproxy = 直接連線
    .accesskey = n

connection-proxy-noproxy-desc = 範例: .mozilla.org, .net.tw, 192.168.1.0/24

# Do not translate "localhost", "127.0.0.1/8" and "::1". (You can translate "and".)
connection-proxy-noproxy-localhost-desc-2 = 與 localhost、127.0.0.1/8 與 ::1 的連線永遠不會經過代理伺服器。

connection-proxy-autotype =
    .label = Proxy 自動設定網址
    .accesskey = A

connection-proxy-reload =
    .label = 重新載入
    .accesskey = e

connection-proxy-autologin =
    .label = 若已儲存密碼則不要提示驗證
    .accesskey = i
    .tooltip = 勾選此選項後，若您已將密碼儲存起來，連線時就不會再詢問您密碼。驗證失敗後才會再向您詢問。

connection-proxy-socks-remote-dns =
    .label = 使用 SOCKS v5 時也代理 DNS 查詢
    .accesskey = d

connection-dns-over-https =
    .label = 開啟 DNS over HTTPS
    .accesskey = H

connection-dns-over-https-url-resolver = 使用供應商
    .accesskey = P

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name }（預設）
    .tooltiptext = 使用預設網址來解析 DNS over HTTPS

connection-dns-over-https-url-custom =
    .label = 自訂
    .accesskey = C
    .tooltiptext = 輸入您想要用來解析 DNS over HTTPS 的網址

connection-dns-over-https-custom-label = 自訂
