# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-dns-over-https-url-resolver = 选用提供商
    .accesskey = r
# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name }（默认值）
    .tooltiptext = 使用默认 URL 完成基于 HTTPS 的 DNS 解析
connection-dns-over-https-url-custom =
    .label = 自定义
    .accesskey = C
    .tooltiptext = 输入您偏好的 URL，用来完成基于 HTTPS 的 DNS 解析
connection-dns-over-https-custom-label = 自定义
connection-dialog-window =
    .title = 连接设置
    .style =
        { PLATFORM() ->
            [macos] width: 44em !important
           *[other] width: 49em !important
        }
connection-disable-extension =
    .label = 禁用扩展
disable-extension-button = 禁用扩展
# Variables:
#   $name (String) - The extension that is controlling the proxy settings.
#
# The extension-icon is the extension's icon, or a fallback image. It should be
# purely decoration for the actual extension name, with alt="".
proxy-settings-controlled-by-extension = 扩展 <img data-l10n-name="extension-icon" alt="" /> { $name } 正在控制 { -brand-short-name } 如何连接互联网。
connection-proxy-legend = 配置访问互联网的代理
proxy-type-no =
    .label = 不使用代理
    .accesskey = y
proxy-type-wpad =
    .label = 自动检测此网络的代理设置
    .accesskey = w
proxy-type-system =
    .label = 使用系统代理设置
    .accesskey = U
proxy-type-manual =
    .label = 手动配置代理:
    .accesskey = M
proxy-http-label =
    .value = HTTP 代理:
    .accesskey = H
http-port-label =
    .value = 端口:
    .accesskey = P
proxy-http-sharing =
    .label = 也将此代理用于 HTTPS
    .accesskey = x
proxy-https-label =
    .value = HTTPS Proxy:
    .accesskey = S
ssl-port-label =
    .value = 端口:
    .accesskey = o
proxy-socks-label =
    .value = SOCKS 主机:
    .accesskey = C
socks-port-label =
    .value = 端口:
    .accesskey = t
proxy-socks4-label =
    .label = SOCKS v4
    .accesskey = K
proxy-socks5-label =
    .label = SOCKS v5
    .accesskey = v
proxy-type-auto =
    .label = 自动代理配置 URL:
    .accesskey = A
proxy-reload-label =
    .label = 重新载入
    .accesskey = l
no-proxy-label =
    .value = 不使用代理:
    .accesskey = N
no-proxy-example = 例如： .mozilla.org.cn, .net.nz, 192.168.1.0/24
# Do not translate "localhost", "127.0.0.1/8" and "::1". (You can translate "and".)
connection-proxy-noproxy-localhost-desc-2 = 与 localhost、127.0.0.1/8 和 ::1 的连接永不经过代理。
proxy-password-prompt =
    .label = 如果密码已保存，不提示身份验证
    .accesskey = i
    .tooltiptext = 如果选中此选项，当您已保存身份凭据时，将会自动验证身份。如果身份验证失败，仍将向您询问身份凭据。
proxy-remote-dns =
    .label = 使用 SOCKS v5 时 DNS 经过代理
    .accesskey = d
proxy-enable-doh =
    .label = 启用基于 HTTPS 的 DNS
    .accesskey = b
