# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = { $hostname } は不正なセキュリティ証明書を使用しています。
cert-error-mitm-intro = ウェブサイトは証明書で同一性を証明します。この証明書は証明書認証局により発行されます。
cert-error-mitm-mozilla = { -brand-short-name } は完全にオープンな証明書認証局 (CA) ストアを運営している非営利組織の Mozilla により後援されています。CA ストアは、証明書認証局がユーザーセキュリティのためのベストプラクティスに確実に従うことを助けます。
cert-error-mitm-connection = { -brand-short-name } はユーザーのオペレーティングシステムにより提供されている証明書ではなく、Mozilla CA ストアを使用して接続の安全性を検証します。そのため、ウイルス対策ソフトウェアやネットワークから Mozilla CA ストア以外の CA により発行されたセキュリティ証明書で接続に割り込まれた場合、その接続は危険とみなされます。
cert-error-trust-unknown-issuer-intro = 誰かがこのサイトに偽装しようとしている可能性があります。続行しないでください。
# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-trust-unknown-issuer = ウェブサイトは証明書で同一性を証明します。証明書の発行者が不明、証明書が自己署名、またはサーバーが正しい中間証明書を送信していないため、{ -brand-short-name } は { $hostname } を信頼しません。
cert-error-trust-cert-invalid = 不正な認証局の証明書で発行されているためこの証明書は信頼されません。
cert-error-trust-untrusted-issuer = 発行者の証明書が信頼されていないためこの証明書は信頼されません。
cert-error-trust-signature-algorithm-disabled = 安全ではない署名アルゴリズムによって署名されているためこの証明書は信頼されません。
cert-error-trust-expired-issuer = 発行者の証明書が有効期限切れになっているためこの証明書は信頼されません。
cert-error-trust-self-signed = 自己署名をしているためこの証明書は信頼されません。
cert-error-trust-symantec = GeoTrust および RapidSSL、Symantec、Thawte、VeriSign により発行された証明書はもはや安全とはみなされません。これらの証明書認証局は過去にセキュリティ規則に従いませんでした。
cert-error-untrusted-default = この証明書は信頼されている提供元から得られたものではありません。
# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-domain-mismatch = ウェブサイトは証明書で同一性を証明します。{ $hostname } は無効な証明書を使用しているため、{ -brand-short-name } はこのサイトを信頼しません。
# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single = ウェブサイトは証明書で同一性を証明します。{ $hostname } は無効な証明書を使用しているため、{ -brand-short-name } はこのサイトを信頼しません。 この証明書は <a data-l10n-name="domain-mismatch-link">{ $alt-name }</a> にだけ有効なものです。
# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single-nolink = ウェブサイトは証明書で同一性を証明します。{ $hostname } は無効な証明書を使用しているため、{ -brand-short-name } はこのサイトを信頼しません。 この証明書は { $alt-name } にだけ有効なものです。
# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = ウェブサイトは証明書で同一性を証明します。{ $hostname } は無効な証明書を使用しているため、{ -brand-short-name } はこのサイトを信頼しません。この証明書は次のドメイン名にのみ有効です: { $subject-alt-names }
# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = ウェブサイトは一定期間有効な証明書で同一性を証明します。{ $hostname } の証明書は { $not-after-local-time } に期限が切れました。
# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = ウェブサイトは一定期間有効な証明書で同一性を証明します。{ $hostname } の証明書は { $not-before-local-time } まで有効ではありません。
# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = エラーコード: <a data-l10n-name="error-code-link">{ $error }</a>
# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-symantec-distrust-description = ウェブサイトは認証局から発行された証明書で同一性を証明します。多くのブラウザーはもはや GeoTrust および RapidSSL、Symantec、Thawte、VeriSign により発行された証明書を信頼しません。{ $hostname } はこれらのうちいずれかの認証局からの証明書を使用しているため、ウェブサイトの同一性を証明できません。
cert-error-symantec-distrust-admin = この問題をウェブサイトの管理者に知らせることもできます。
# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = HTTP Strict Transport Security: { $hasHSTS }
# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = HTTP 公開鍵ピンニング: { $hasHPKP }

cert-error-details-cert-chain-label = 証明書チェーン:

open-in-new-window-for-csp-or-xfo-error = 新しいウィンドウでサイトを開く

# Variables:
# $hostname (String) - Hostname of the website blocked by csp or xfo error.
csp-xfo-blocked-long-desc = 安全のため、{ -brand-short-name } は他のサイトが埋め込まれた { $hostname } のページの表示を許可できません。このページを表示するには、新しいウィンドウで開く必要があります。

## Messages used for certificate error titles

connectionFailure-title = 正常に接続できませんでした
deniedPortAccess-title = このアドレスへの接続は制限されています
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = アクセスしようとしているサイトを見つけられません
fileNotFound-title = ファイルが見つかりませんでした
fileAccessDenied-title = ファイルへのアクセスが拒否されました
generic-title = リクエストを正常に完了できませんでした
captivePortal-title = ネットワークにログイン
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = アドレスが正しくないようです
netInterrupt-title = 接続が中断されました
notCached-title = ドキュメントが有効期限切れです
netOffline-title = オフラインモードです
contentEncodingError-title = 内容符号化 (Content-Encoding) に問題があります
unsafeContentType-title = 安全でないファイルタイプ
netReset-title = 接続がリセットされました
netTimeout-title = 接続がタイムアウトしました
unknownProtocolFound-title = アドレスのプロトコルが不明です
proxyConnectFailure-title = プロキシーサーバーへの接続を拒否されました
proxyResolveFailure-title = プロキシーサーバーが見つかりませんでした
redirectLoop-title = ページの自動転送設定が正しくありません
unknownSocketType-title = サーバーの応答が不正です
nssFailure2-title = 安全な接続ができませんでした
csp-xfo-error-title = { -brand-short-name } はこのページを開けません
corruptedContentError-title = コンテンツデータ破損エラー
remoteXUL-title = リモート XUL
sslv3Used-title = 安全な接続を確保できません
inadequateSecurityError-title = 接続が安全ではありません
blockedByPolicy-title = ブロックしたページ
clockSkewError-title = コンピューターの時刻が間違っています
networkProtocolError-title = ネットワークプロトコルエラー
nssBadCert-title = 警告: 潜在的なセキュリティリスクあり
nssBadCert-sts-title = 接続中止: 潜在的なセキュリティ問題
certerror-mitm-title = このサイトへの安全な接続を妨げるソフトウェア
