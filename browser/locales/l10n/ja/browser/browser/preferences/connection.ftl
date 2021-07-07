# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-window =
    .title = インターネット接続
    .style =
        { PLATFORM() ->
            [macos] width: 46em
           *[other] width: 54em
        }

connection-close-key =
    .key = w

connection-disable-extension =
    .label = 拡張機能を無効化

connection-proxy-configure = インターネット接続に使用するプロキシーの設定

connection-proxy-option-no =
    .label = プロキシーを使用しない
    .accesskey = y
connection-proxy-option-system =
    .label = システムのプロキシー設定を利用する
    .accesskey = U
connection-proxy-option-auto =
    .label = このネットワークのプロキシー設定を自動検出する
    .accesskey = w
connection-proxy-option-manual =
    .label = 手動でプロキシーを設定する
    .accesskey = M

connection-proxy-http = HTTP プロキシー
    .accesskey = x
connection-proxy-http-port = ポート
    .accesskey = P
connection-proxy-http-sharing =
    .label = このプロキシーを FTP と HTTPS でも使用する
    .accesskey = s

connection-proxy-https-sharing =
    .label = このプロキシーを HTTPS でも使用する
    .accesskey = s

connection-proxy-https = HTTPS プロキシー
    .accesskey = H
connection-proxy-ssl-port = ポート
    .accesskey = o

connection-proxy-ftp = FTP プロキシー
    .accesskey = F
connection-proxy-ftp-port = ポート
    .accesskey = r

connection-proxy-socks = SOCKS ホスト
    .accesskey = C
connection-proxy-socks-port = ポート
    .accesskey = t

connection-proxy-socks4 =
    .label = SOCKS v4
    .accesskey = K
connection-proxy-socks5 =
    .label = SOCKS v5
    .accesskey = v
connection-proxy-noproxy = プロキシーなしで接続
    .accesskey = N

connection-proxy-noproxy-desc = 例: .mozilla.org, .net.nz, 192.168.1.0/24

# Do not translate localhost, 127.0.0.1 and ::1.
connection-proxy-noproxy-localhost-desc = localhost, 127.0.0.1, ::1 へは常にプロキシーなしで接続します。

# Do not translate "localhost", "127.0.0.1/8" and "::1". (You can translate "and".)
connection-proxy-noproxy-localhost-desc-2 = localhost, 127.0.0.1/8, ::1 へは常にプロキシーなしで接続します。

connection-proxy-autotype =
    .label = 自動プロキシー設定スクリプト URL
    .accesskey = A

connection-proxy-reload =
    .label = 再読み込み
    .accesskey = e

connection-proxy-autologin =
    .label = パスワードを保存してある場合は認証を確認しない
    .accesskey = i
    .tooltip = このオプションは、プロキシーへのパスワードが保存してある場合、確認することなく認証を行います。認証に失敗した場合は確認を行います。

connection-proxy-socks-remote-dns =
    .label = SOCKS v5 を使用するときは DNS もプロキシーを使用する
    .accesskey = D

connection-dns-over-https =
    .label = DNS over HTTPS を有効にする
    .accesskey = b

connection-dns-over-https-url-resolver = プロバイダーを使用
    .accesskey = P

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
