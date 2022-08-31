# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certificate-viewer-certificate-section-title = 憑證

## Error messages

certificate-viewer-error-message = 找不到憑證資訊，或該憑證已經毀損。請再試一次。
certificate-viewer-error-title = 有些東西不對勁。

## Certificate information labels

certificate-viewer-algorithm = 演算法
certificate-viewer-certificate-authority = 憑證機構
certificate-viewer-cipher-suite = 加密套件組
certificate-viewer-common-name = 一般名稱
certificate-viewer-email-address = 電子郵件地址
# Variables:
#   $firstCertName (String) - Common Name for the displayed certificate
certificate-viewer-tab-title = { $firstCertName } 的憑證
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-country = 註冊國家
certificate-viewer-country = 國家
certificate-viewer-curve = 曲線
certificate-viewer-distribution-point = 發佈點
certificate-viewer-dns-name = DNS 名稱
certificate-viewer-ip-address = IP 地址
certificate-viewer-other-name = 其他名稱
certificate-viewer-exponent = 指數
certificate-viewer-id = ID
certificate-viewer-key-exchange-group = 金鑰交換群組
certificate-viewer-key-id = 金鑰 ID
certificate-viewer-key-size = 金鑰大小
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-locality = 公司註冊地
certificate-viewer-locality = 地區
certificate-viewer-location = 位置
certificate-viewer-logid = Log ID
certificate-viewer-method = 方法
certificate-viewer-modulus = 模數
certificate-viewer-name = 名稱
certificate-viewer-not-after = 不晚於
certificate-viewer-not-before = 不早於
certificate-viewer-organization = 組織
certificate-viewer-organizational-unit = 組織單位
certificate-viewer-policy = 政策
certificate-viewer-protocol = 通訊協定
certificate-viewer-public-value = 公開值
certificate-viewer-purposes = 用途
certificate-viewer-qualifier = Qualifier
certificate-viewer-qualifiers = Qualifier
certificate-viewer-required = 必需
certificate-viewer-unsupported = &lt;不支援&gt;
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-state-province = 註冊州 / 省
certificate-viewer-state-province = 州 / 省
certificate-viewer-sha-1 = SHA-1
certificate-viewer-sha-256 = SHA-256
certificate-viewer-serial-number = 序號
certificate-viewer-signature-algorithm = 簽章演算法
certificate-viewer-signature-scheme = 簽署方式
certificate-viewer-timestamp = 時間戳記
certificate-viewer-value = 值
certificate-viewer-version = 版本
certificate-viewer-business-category = 業務類別
certificate-viewer-subject-name = 主體名稱
certificate-viewer-issuer-name = 簽發者名稱
certificate-viewer-validity = 有效期
certificate-viewer-subject-alt-names = 主體替代名稱
certificate-viewer-public-key-info = 公鑰資訊
certificate-viewer-miscellaneous = 其他
certificate-viewer-fingerprints = 指紋
certificate-viewer-basic-constraints = 基礎限制
certificate-viewer-key-usages = 金鑰用途
certificate-viewer-extended-key-usages = 延伸金鑰用法
certificate-viewer-ocsp-stapling = OCSP Stapling
certificate-viewer-subject-key-id = 主體金鑰 ID
certificate-viewer-authority-key-id = 憑證簽發單位金鑰 ID
certificate-viewer-authority-info-aia = 憑證簽發單位資訊（AIA）
certificate-viewer-certificate-policies = 憑證政策
certificate-viewer-embedded-scts = 嵌入的 SCT
certificate-viewer-crl-endpoints = CRL 端點

# This message is used as a row header in the Miscellaneous section.
# The associated data cell contains links to download the certificate.
certificate-viewer-download = 下載
# This message is used to replace boolean values (true/false) in several certificate fields, e.g. Certificate Authority
# Variables:
#   $boolean (String) - true/false value for the specific field
certificate-viewer-boolean =
    { $boolean ->
        [true] 是
       *[false] 否
    }

## Variables:
##   $fileName (String) - The file name to save the PEM data in, derived from the common name from the certificate being displayed.

certificate-viewer-download-pem = PEM（憑證）
    .download = { $fileName }.pem
certificate-viewer-download-pem-chain = PEM（金鑰鏈）
    .download = { $fileName }-chain.pem

# The title attribute for Critical Extension icon
certificate-viewer-critical-extension =
    .title = 此擴充欄位標示為重要，代表客戶端若無法理解此欄位內容就必須拒絕接受憑證。
certificate-viewer-export = 匯出
    .download = { $fileName }.pem

##

# Label for a tab where we haven't found a better label:
certificate-viewer-unknown-group-label = （未知）

## Labels for tabs displayed in stand-alone about:certificate page

certificate-viewer-tab-mine = 您的憑證
certificate-viewer-tab-people = 人員
certificate-viewer-tab-servers = 伺服器
certificate-viewer-tab-ca = 憑證機構
certificate-viewer-tab-unkonwn = 未知
