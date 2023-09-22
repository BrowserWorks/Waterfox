# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Error page titles

neterror-page-title = ページ読み込みエラー
certerror-page-title = 警告: 潜在的なセキュリティリスクあり
certerror-sts-page-title = 接続中止: 潜在的なセキュリティ問題
neterror-blocked-by-policy-page-title = ブロックしたページ
neterror-captive-portal-page-title = ネットワークにログイン
neterror-dns-not-found-title = サーバーが見つかりませんでした
neterror-malformed-uri-page-title = 不正な URL

## Error page actions

neterror-advanced-button = 詳細へ進む...
neterror-copy-to-clipboard-button = テキストをクリップボードにコピー
neterror-learn-more-link = エラーの説明...
neterror-open-portal-login-page-button = ネットワークのログインページを開く
neterror-override-exception-button = 危険性を承知で続行
neterror-pref-reset-button = 既定値に戻す
neterror-return-to-previous-page-button = 戻る
neterror-return-to-previous-page-recommended-button = 戻る (推奨)
neterror-try-again-button = 再試行
neterror-add-exception-button = このサイトは常に続行する
neterror-settings-button = DNS 設定を変更
neterror-view-certificate-link = 証明書を確認
neterror-trr-continue-this-time = 今回は続行する
neterror-disable-native-feedback-warning = 常に続行する

##

neterror-pref-reset = ネットワークセキュリティの設定がこの問題の原因になっている可能性があります。既定値に戻しますか？
neterror-error-reporting-automatic = エラーを報告すると、{ -vendor-short-name } が悪意のあるサイトを特定してブロックするのに役立てられます

## Specific error messages

neterror-generic-error = 何らかの理由により { -brand-short-name } はこのページを正常に読み込めませんでした。
neterror-load-error-try-again = このサイトが一時的に利用できなくなっていたり、サーバーの負荷が高すぎて接続できなくなっている可能性があります。しばらくしてから再度試してください。
neterror-load-error-connection = 他のサイトも表示できない場合、コンピューターのネットワーク接続を確認してください。
neterror-load-error-firewall = ファイアウォールやプロキシーでネットワークが保護されている場合、{ -brand-short-name } によるウェブアクセスが許可されているか確認してください。
neterror-captive-portal = インターネットへ接続するには、このネットワークにログインする必要があります。
# Variables:
# $hostAndPath (String) - a suggested site (e.g. "www.example.com") that the user may have meant instead.
neterror-dns-not-found-with-suggestion = もしかして訪問先は <a data-l10n-name="website">{ $hostAndPath }</a> ですか？
neterror-dns-not-found-hint-header = <strong>アドレスが正しい場合は、以下のことを試してください:</strong>
neterror-dns-not-found-hint-try-again = 後でもう一度試してください。
neterror-dns-not-found-hint-check-network = ネットワーク接続を確認してください。
neterror-dns-not-found-hint-firewall = ファイアウォール越しに接続している場合は、{ -brand-short-name } がウェブへの接続を許可されているか確認してください。

## TRR-only specific messages
## Variables:
##   $hostname (String) - Hostname of the website to which the user was trying to connect.
##   $trrDomain (String) - Hostname of the DNS over HTTPS server that is currently in use.

neterror-dns-not-found-trr-only-reason = 次の理由により、{ -brand-short-name } は信頼された DNS リゾルバーを通じてこのサイトのアドレスに対する要求を保護することができません:
neterror-dns-not-found-trr-third-party-warning2 = 既定の DNS リゾルバーの利用を続けることができますが、第三者にあなたの訪れたウェブサイトを知られる可能性があります。
neterror-dns-not-found-trr-only-could-not-connect = { -brand-short-name } が { $trrDomain } と接続できませんでした。
neterror-dns-not-found-trr-only-timeout = { $trrDomain } への接続に時間がかかっています。
neterror-dns-not-found-trr-offline = インターネットに接続されていません。
neterror-dns-not-found-trr-unknown-host2 = { $trrDomain } でこのウェブサイトが見つかりませんでした。
neterror-dns-not-found-trr-server-problem = { $trrDomain } のサーバーに問題があります。
neterror-dns-not-found-bad-trr-url = URL が正しくありません。
neterror-dns-not-found-trr-unknown-problem = 予期しない問題が発生しました。

## Native fallback specific messages
## Variables:
##   $trrDomain (String) - Hostname of the DNS over HTTPS server that is currently in use.

neterror-dns-not-found-native-fallback-reason = { -brand-short-name } は信頼された DNS リゾルバーを通じてこのサイトのアドレスに対する要求を保護することができません。理由:
neterror-dns-not-found-native-fallback-heuristic = ご利用のネットワークでは DNS over HTTPS が無効化されています。
neterror-dns-not-found-native-fallback-not-confirmed2 = { -brand-short-name } が { $trrDomain } に接続できませんでした。

##

neterror-file-not-found-filename = アドレスに大文字/小文字の違い、その他の間違いがないか確認してください。
neterror-file-not-found-moved = ファイルの名前が変更、削除、または移動している可能性があります。
neterror-access-denied = ファイルが削除または移動されているかファイルの許可属性によりアクセスが拒否された可能性があります。
neterror-unknown-protocol = このプロトコルを使用するアドレスを開くには、別のソフトウェアをインストールする必要があるかもしれません。
neterror-redirect-loop = Cookie を無効化したり拒否していることにより、この問題が発生している可能性もあります。
neterror-unknown-socket-type-psm-installed = コンピューターにパーソナルセキュリティマネージャーがインストールされているか確認してください。
neterror-unknown-socket-type-server-config = サーバーの設定が間違っていることにより、この問題が発生している可能性もあります。
neterror-not-cached-intro = リクエストされた { -brand-short-name } のキャッシュ内のドキュメントは、利用できません。
neterror-not-cached-sensitive = 安全対策のため、{ -brand-short-name } は注意を要するドキュメントを自動的に再リクエストしません。
neterror-not-cached-try-again = "再試行" ボタンをクリックしてドキュメントをウェブサイトから読み込んでください。
neterror-net-offline = "再試行” ボタンを押してブラウザーをオンラインモードに切り替え、ページを再読み込みしてください。
neterror-proxy-resolve-failure-settings = プロキシー設定が正しいか確認してください。
neterror-proxy-resolve-failure-connection = コンピューターが有効なネットワークに接続されているか確認してください。
neterror-proxy-resolve-failure-firewall = ファイアウォールやプロキシーでネットワークが保護されている場合、{ -brand-short-name } によるウェブアクセスが許可されているか確認してください。
neterror-proxy-connect-failure-settings = プロキシー設定が正しいか確認してください。
neterror-proxy-connect-failure-contact-admin = プロキシーサーバーが正常に動作しているかネットワーク管理者に問い合わせてください。
neterror-content-encoding-error = この問題をウェブサイトの管理者に報告してください。
neterror-unsafe-content-type = この問題をウェブサイトの管理者に報告してください。
neterror-nss-failure-not-verified = 受信したデータの真正性を検証できなかったため、このページは表示できませんでした。
neterror-nss-failure-contact-website = この問題をウェブサイトの管理者に連絡してください。
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-intro = { -brand-short-name } はセキュリティ上の潜在的な脅威を検知したため、<b>{ $hostname }</b> への接続を中止しました。このサイトに訪問すると、攻撃者がパスワードやメールアドレス、クレジットカードの詳細な情報を盗み取ろうとする恐れがあります。
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-sts-intro = { -brand-short-name } はセキュリティ上の潜在的な脅威を検知したため、<b>{ $hostname }</b> への接続を中止しました。このウェブサイトには安全な接続が必要なためです。
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-expired-cert-intro = { -brand-short-name } は問題を検知したため、<b>{ $hostname }</b> への接続を中止しました。このウェブサイトの設定が不適切、またはあなたのコンピューターの時刻設定に誤りがあります。
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm = <b>{ $hostname }</b> は安全なサイトだと思われますが、安全な接続を確立できませんでした。この問題はあなたのコンピューターかネットワークにある <b>{ $mitm }</b> が原因です。
neterror-corrupted-content-intro = このページは、データの伝送中にエラーが検出されたため表示できません。
neterror-corrupted-content-contact-website = ウェブサイトの所有者に連絡を取り、この問題を報告してください。
# Do not translate "SSL_ERROR_UNSUPPORTED_VERSION".
neterror-sslv3-used = 高度な情報: SSL_ERROR_UNSUPPORTED_VERSION
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
neterror-inadequate-security-intro = <b>{ $hostname }</b> は攻撃に対して脆弱な古いセキュリティ技術を使用しています。攻撃者は保護された情報を簡単に暴露できます。サイトを安全に訪れるには、このウェブサイトの管理者にサーバーの問題を修正してもらう必要があります。
# Do not translate "NS_ERROR_NET_INADEQUATE_SECURITY".
neterror-inadequate-security-code = エラーコード: NS_ERROR_NET_INADEQUATE_SECURITY
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $now (Date) - The current datetime, to be formatted as a date
neterror-clock-skew-error = あなたのコンピューターは現在の日時を { DATETIME($now, dateStyle: "medium") } だと誤解しており、{ -brand-short-name } の安全な接続を妨げる原因になります。<b>{ $hostname }</b> にアクセスして、コンピュータの現在の日付と時刻、タイムゾーンを正しいものに更新して、<b>{ $hostname }</b> を再読み込みしてください。
neterror-network-protocol-error-intro = 表示しようとしているページは、ネットワークプロトコルにエラーが検出されたため表示できません。
neterror-network-protocol-error-contact-website = ウェブサイトの所有者に連絡を取り、この問題を報告してください。
certerror-expired-cert-second-para = ウェブサイトの証明書が有効期限切れの可能性があるため、{ -brand-short-name } の安全な接続が妨げられています。このサイトを訪問すると、パスワードやメールアドレス、クレジットカードの詳細情報を攻撃者に盗み取られる恐れがあります。
certerror-expired-cert-sts-second-para = ウェブサイトの証明書が有効期限切れの可能性があるため、{ -brand-short-name } の安全な接続が妨げられています。
certerror-what-can-you-do-about-it-title = どうすればいいですか？
certerror-unknown-issuer-what-can-you-do-about-it-website = この問題はウェブサイトに原因があり、あなたにできることはありません。
certerror-unknown-issuer-what-can-you-do-about-it-contact-admin = 組織内のネットワークからアクセスしている、またはウイルス対策ソフトウェアを利用している場合は、あなたの所属組織のネットワーク管理者に連絡してください。ウェブサイトの管理者に問題を報告するのもよいでしょう。
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $now (Date) - The current datetime, to be formatted as a date
certerror-expired-cert-what-can-you-do-about-it-clock = あなたのコンピューターの時刻は { DATETIME($now, dateStyle: "medium") } に設定されています。正しい日付と時刻、タイムゾーンをコンピューターに設定して、<b>{ $hostname }</b> を再読み込みしてください。
certerror-expired-cert-what-can-you-do-about-it-contact-website = すでに正しい時刻が設定されている場合は、ウェブサイトに問題があるため、あなたにできることはありません。ウェブサイトの管理者に問題を報告するのもよいでしょう。
certerror-bad-cert-domain-what-can-you-do-about-it = この問題はウェブサイトに原因があり、あなたにできることはありません。ウェブサイトの管理者に問題を報告するのもよいでしょう。
certerror-mitm-what-can-you-do-about-it-antivirus = ウイルス対策ソフトウェアに暗号化された接続をスキャンする機能 (“ウェブスキャン” または “HTTPS スキャン” という機能名) が含まれている場合は、その機能を無効にしてください。無効にしても解決できない場合は、ウイルス対策ソフトウェアを削除して再インストールしてください。
certerror-mitm-what-can-you-do-about-it-corporate = 組織内のネットワークからアクセスしている場合は、ネットワーク管理者に連絡してください。
# Variables:
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm-what-can-you-do-about-it-attack = <b>{ $mitm }</b> に心当たりがない場合は攻撃されている可能性があるため、以後このサイトには接続しないでください。
# Variables:
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm-what-can-you-do-about-it-attack-sts = <b>{ $mitm }</b> に心当たりがない場合は攻撃されている可能性があるため、このサイトにアクセスする方法はありません。
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-what-should-i-do-bad-sts-cert-explanation = <b>{ $hostname }</b> は HTTP Strict Transport Security (HSTS) と呼ばれるセキュリティポリシーが設定されており、{ -brand-short-name } は安全な接続でしか通信できません。そのため、このサイトを例外に追加することはできません。
