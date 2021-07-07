# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-dns-over-https-url-resolver = 使用供應商
    .accesskey = r
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
connection-dialog-window =
    .title = 連線設定
    .style =
        { PLATFORM() ->
            [macos] width: 44em !important
           *[other] width: 49em !important
        }
connection-disable-extension =
    .label = 停用擴充套件
disable-extension-button = 停用擴充套件
# Variables:
#   $name (String) - The extension that is controlling the proxy settings.
#
# The extension-icon is the extension's icon, or a fallback image. It should be
# purely decoration for the actual extension name, with alt="".
proxy-settings-controlled-by-extension = 擴充套件「<img data-l10n-name="extension-icon" alt="" />{ $name }」正在控制您的 { -brand-short-name } 連線至網際網路的方式。
connection-proxy-legend = 設定存取網際網路的代理伺服器 (Proxy)
proxy-type-no =
    .label = 不使用 Proxy
    .accesskey = y
proxy-type-wpad =
    .label = 自動偵測此網路的 Proxy 設定
    .accesskey = w
proxy-type-system =
    .label = 使用系統 Proxy 設定
    .accesskey = U
proxy-type-manual =
    .label = 手動設定 Proxy:
    .accesskey = M
proxy-http-label =
    .value = HTTP Proxy:
    .accesskey = h
http-port-label =
    .value = Port:
    .accesskey = p
proxy-http-sharing =
    .label = 也針對 HTTPS 連線使用此代理伺服器
    .accesskey = x
proxy-https-label =
    .value = HTTPS Proxy:
    .accesskey = S
ssl-port-label =
    .value = Port:
    .accesskey = o
proxy-socks-label =
    .value = SOCKS 主機:
    .accesskey = C
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
    .label = Proxy 自動設定網址:
    .accesskey = A
proxy-reload-label =
    .label = 重新載入
    .accesskey = l
no-proxy-label =
    .value = 直接連線:
    .accesskey = N
no-proxy-example = 範例: .mozilla.org, .net.tw, 192.168.1.0/24
# Do not translate "localhost", "127.0.0.1/8" and "::1". (You can translate "and".)
connection-proxy-noproxy-localhost-desc-2 = 與 localhost、127.0.0.1/8 與 ::1 的連線永遠不會經過代理伺服器。
proxy-password-prompt =
    .label = 若已儲存密碼則不要提示驗證
    .accesskey = i
    .tooltiptext = 勾選此選項後，若您已將密碼儲存起來，連線時就不會再詢問您密碼。驗證失敗後才會再向您詢問。
proxy-remote-dns =
    .label = 使用 SOCKS v5 時也代理 DNS 查詢
    .accesskey = d
proxy-enable-doh =
    .label = 開啟 DNS over HTTPS
    .accesskey = b
