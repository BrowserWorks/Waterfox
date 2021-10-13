# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certificate-viewer-certificate-section-title = 証明書

## Error messages

certificate-viewer-error-message = 証明書情報が見つからないか、証明書が破損しています。もう一度試してください。
certificate-viewer-error-title = 何か問題が発生しました。

## Certificate information labels

certificate-viewer-algorithm = アルゴリズム
certificate-viewer-certificate-authority = 認証局
certificate-viewer-cipher-suite = 暗号スイート
certificate-viewer-common-name = 共通名
certificate-viewer-email-address = メールアドレス
# Variables:
#   $firstCertName (String) - Common Name for the displayed certificate
certificate-viewer-tab-title = Certificate for { $firstCertName }
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-country = 国籍
certificate-viewer-country = 国
certificate-viewer-curve = 楕円曲線
certificate-viewer-distribution-point = 配布点
certificate-viewer-dns-name = DNS 名
certificate-viewer-ip-address = IP アドレス
certificate-viewer-other-name = 別名
certificate-viewer-exponent = 冪剰余
certificate-viewer-id = ID
certificate-viewer-key-exchange-group = 鍵交換グループ
certificate-viewer-key-id = 鍵 ID
certificate-viewer-key-size = 鍵サイズ
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-locality = 在籍地
certificate-viewer-locality = 場所
certificate-viewer-location = URL
certificate-viewer-logid = ログ ID
certificate-viewer-method = 方式
certificate-viewer-modulus = 母数
certificate-viewer-name = 名称
certificate-viewer-not-after = 終了日
certificate-viewer-not-before = 開始日
certificate-viewer-organization = 組織
certificate-viewer-organizational-unit = 組織単位
certificate-viewer-policy = ポリシー
certificate-viewer-protocol = プロトコル
certificate-viewer-public-value = パブリック値
certificate-viewer-purposes = 使用目的
certificate-viewer-qualifier = 運用規程
certificate-viewer-qualifiers = 修飾子
certificate-viewer-required = 必須
certificate-viewer-unsupported = &lt;未対応&gt;
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-state-province = 在籍地 (州/県)
certificate-viewer-state-province = 州/県
certificate-viewer-sha-1 = SHA-1
certificate-viewer-sha-256 = SHA-256
certificate-viewer-serial-number = シリアル番号
certificate-viewer-signature-algorithm = 署名アルゴリズム
certificate-viewer-signature-scheme = 署名スキーム
certificate-viewer-timestamp = タイムスタンプ
certificate-viewer-value = 評価
certificate-viewer-version = バージョン
certificate-viewer-business-category = 業種
certificate-viewer-subject-name = 主体者名
certificate-viewer-issuer-name = 発行者名
certificate-viewer-validity = 有効期間
certificate-viewer-subject-alt-names = 主体者代替名
certificate-viewer-public-key-info = 公開鍵情報
certificate-viewer-miscellaneous = その他の情報
certificate-viewer-fingerprints = フィンガープリント
certificate-viewer-basic-constraints = 基本制約
certificate-viewer-key-usages = 鍵用途
certificate-viewer-extended-key-usages = 拡張鍵用途
certificate-viewer-ocsp-stapling = OCSP 応答添付
certificate-viewer-subject-key-id = 主体者の鍵 ID
certificate-viewer-authority-key-id = 機関の鍵 ID
certificate-viewer-authority-info-aia = 機関情報アクセス (AIA)
certificate-viewer-certificate-policies = 証明書ポリシー
certificate-viewer-embedded-scts = 埋め込み SCT
certificate-viewer-crl-endpoints = CRL エンドポイント

# This message is used as a row header in the Miscellaneous section.
# The associated data cell contains links to download the certificate.
certificate-viewer-download = ダウンロード
# This message is used to replace boolean values (true/false) in several certificate fields, e.g. Certificate Authority
# Variables:
#   $boolean (String) - true/false value for the specific field
certificate-viewer-boolean = { $boolean ->
  [true] はい
 *[false] いいえ
}

## Variables:
##   $fileName (String) - The file name to save the PEM data in, derived from the common name from the certificate being displayed.

certificate-viewer-download-pem = PEM (証明書)
  .download = { $fileName }.pem
certificate-viewer-download-pem-chain = PEM (チェーン)
  .download = { $fileName }-chain.pem

# The title attribute for Critical Extension icon
certificate-viewer-critical-extension =
  .title = この拡張には危険マークが付けられており、クライアントがこれを理解できない場合は証明書を却下すべきであることを意味します。
certificate-viewer-export = エクスポート
  .download = { $fileName }.pem

##

# Label for a tab where we haven't found a better label:
certificate-viewer-unknown-group-label = (不明)

## Labels for tabs displayed in stand-alone about:certificate page

certificate-viewer-tab-mine = 独自の証明書
certificate-viewer-tab-people = 人々
certificate-viewer-tab-servers = サーバー
certificate-viewer-tab-ca = 認証局
certificate-viewer-tab-unkonwn = 不明
