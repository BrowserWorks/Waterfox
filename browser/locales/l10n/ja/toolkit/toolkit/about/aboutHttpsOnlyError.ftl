# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-httpsonly-title-alert = HTTPS-Only モード警告
about-httpsonly-title-connection-not-available = 安全な接続が利用できません

# Variables:
#   $websiteUrl (String) - Url of the website that failed to load. Example: www.example.com
about-httpsonly-explanation-unavailable2 = セキュリティを強化する HTTPS-Only モードは有効ですが、<em>{ $websiteUrl }</em> の HTTPS バージョンは利用できません。
about-httpsonly-explanation-question = この問題の原因は？
about-httpsonly-explanation-nosupport = おそらく、ウェブサイトが HTTPS をサポートしていないだけでしょう。
about-httpsonly-explanation-risk = また、攻撃者が関係している可能性もあります。ウェブサイトへ移動することにした場合でも、パスワードやメールアドレス、クレジットカードなどの取り扱いに注意が必要な情報を入力してはいけません。

about-httpsonly-explanation-continue = 続ける場合、このサイトでは HTTPS-Only モードが一時的にオフになります。

about-httpsonly-button-continue-to-site = HTTP サイトを開く
about-httpsonly-button-go-back = 戻る
about-httpsonly-link-learn-more = 詳細情報...

## Suggestion Box that only shows up if a secure connection to www can be established
## Variables:
##   $websiteUrl (String) - Url of the website that can be securely loded with these alternatives. Example: example.com

about-httpsonly-suggestion-box-header = 安全な https サイトがあります
about-httpsonly-suggestion-box-www-text = <em>www.{ $websiteUrl }</em> サイトの安全なバージョンがあります。<em>{ $websiteUrl }</em> の代わりにこのページへ移動してください。
about-httpsonly-suggestion-box-www-button = www.{ $websiteUrl } へ移動する
