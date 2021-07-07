# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-window =
    .title = 连接设置
    .style =
        { PLATFORM() ->
            [macos] width: 44em
           *[other] width: 49em
        }

connection-close-key =
    .key = w

connection-disable-extension =
    .label = 禁用扩展

connection-proxy-configure = 配置访问互联网的代理服务器

connection-proxy-option-no =
    .label = 不使用代理服务器
    .accesskey = y
connection-proxy-option-system =
    .label = 使用系统代理设置
    .accesskey = U
connection-proxy-option-auto =
    .label = 自动检测此网络的代理设置
    .accesskey = w
connection-proxy-option-manual =
    .label = 手动配置代理
    .accesskey = m

connection-proxy-http = HTTP 代理
    .accesskey = x
connection-proxy-http-port = 端口
    .accesskey = P

connection-proxy-https-sharing =
    .label = 也将此代理用于 HTTPS
    .accesskey = S

connection-proxy-https = HTTPS Proxy
    .accesskey = H
connection-proxy-ssl-port = 端口
    .accesskey = o

connection-proxy-socks = SOCKS 主机
    .accesskey = C
connection-proxy-socks-port = 端口
    .accesskey = t

connection-proxy-socks4 =
    .label = SOCKS v4
    .accesskey = K
connection-proxy-socks5 =
    .label = SOCKS v5
    .accesskey = v
connection-proxy-noproxy = 不使用代理
    .accesskey = n

connection-proxy-noproxy-desc = 例如：.mozilla.org, .net.nz, 192.168.1.0/24

# Do not translate "localhost", "127.0.0.1/8" and "::1". (You can translate "and".)
connection-proxy-noproxy-localhost-desc-2 = 与 localhost、127.0.0.1/8 和 ::1 的连接永不经过代理。

connection-proxy-autotype =
    .label = 自动代理配置的 URL（PAC）
    .accesskey = A

connection-proxy-reload =
    .label = 重新载入
    .accesskey = e

connection-proxy-autologin =
    .label = 如果密码已保存，不提示身份验证
    .accesskey = i
    .tooltip = 此选项将允许在您已保存凭据的情况下自动向代理进行身份验证，如果验证失败再提示您输入信息。

connection-proxy-socks-remote-dns =
    .label = 使用 SOCKS v5 时代理 DNS 查询
    .accesskey = D

connection-dns-over-https =
    .label = 启用基于 HTTPS 的 DNS
    .accesskey = H

connection-dns-over-https-url-resolver = 选用提供商
    .accesskey = P

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
