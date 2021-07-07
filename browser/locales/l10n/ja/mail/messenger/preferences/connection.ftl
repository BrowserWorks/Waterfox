# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-dns-over-https-url-resolver = プロバイダーを使用
    .accesskey = r
# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (既定)
    .tooltiptext = DNS over HTTPS の解決に既定の URL を使用します
connection-dns-over-https-url-custom =
    .label = URL を指定:
    .accesskey = C
    .tooltiptext = DNS over HTTPS の解決に使用する URL を入力します
connection-dns-over-https-custom-label = URL を指定
connection-dialog-window =
    .title = インターネット接続
    .style =
        { PLATFORM() ->
            [macos] width: 46em !important
           *[other] width: 54em !important
        }
connection-disable-extension =
    .label = 拡張機能を無効化
connection-proxy-legend = インターネット接続に使用するプロキシーの設定
proxy-type-no =
    .label = プロキシーを使用しない
    .accesskey = y
proxy-type-wpad =
    .label = このネットワークのプロキシー設定を自動検出する
    .accesskey = w
proxy-type-system =
    .label = システムのプロキシー設定を使用する
    .accesskey = u
proxy-type-manual =
    .label = 手動でプロキシーを設定する:
    .accesskey = m
proxy-http-label =
    .value = HTTP プロキシー:
    .accesskey = h
http-port-label =
    .value = ポート:
    .accesskey = p
proxy-http-sharing =
    .label = このプロキシーを HTTPS でも使用する
    .accesskey = x
proxy-https-label =
    .value = HTTPS プロキシー:
    .accesskey = S
ssl-port-label =
    .value = ポート:
    .accesskey = o
proxy-socks-label =
    .value = SOCKS ホスト:
    .accesskey = c
socks-port-label =
    .value = ポート:
    .accesskey = t
proxy-socks4-label =
    .label = SOCKS v4
    .accesskey = k
proxy-socks5-label =
    .label = SOCKS v5
    .accesskey = v
proxy-type-auto =
    .label = 自動プロキシー設定スクリプト URL:
    .accesskey = A
proxy-reload-label =
    .label = 再読み込み
    .accesskey = l
no-proxy-label =
    .value = プロキシーなしで接続:
    .accesskey = n
no-proxy-example = 例: .mozilla.org, .net.nz, 192.168.1.0/24
# Do not translate "localhost", "127.0.0.1/8" and "::1". (You can translate "and".)
connection-proxy-noproxy-localhost-desc-2 = localhost、127.0.0.1/8 および ::1 への接続はプロキシーが使用されません。
proxy-password-prompt =
    .label = パスワードを保存してある場合は認証を確認しない
    .accesskey = i
    .tooltiptext = このオプションは、プロキシーへのパスワードが保存してある場合、確認することなく認証を行います。認証に失敗した場合は確認を行います。
proxy-remote-dns =
    .label = SOCKS v5 を使用するときは DNS もプロキシーを使用する
    .accesskey = d
proxy-enable-doh =
    .label = DNS over HTTPS を有効にする
    .accesskey = b
