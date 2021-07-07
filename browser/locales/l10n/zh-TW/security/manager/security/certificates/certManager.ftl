# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certmgr-title =
    .title = 憑證管理員
certmgr-tab-mine =
    .label = 您的憑證
certmgr-tab-remembered =
    .label = 驗證決策
certmgr-tab-people =
    .label = 人員
certmgr-tab-servers =
    .label = 伺服器
certmgr-tab-ca =
    .label = 憑證機構
certmgr-mine = 您有來自下列組織的憑證可以識別您自己
certmgr-remembered = 下列憑證可用來向網站識別您的身分
certmgr-people = 您有可識別下列人員的憑證
certmgr-servers = 您有可識別下列伺服器的憑證
certmgr-server = 下列是伺服器憑證例外項目
certmgr-ca = 您有可識別下列憑證機構的憑證
certmgr-detail-general-tab-title =
    .label = 一般
    .accesskey = G
certmgr-detail-pretty-print-tab-title =
    .label = 詳細資訊
    .accesskey = D
certmgr-pending-label =
    .value = 正在驗證憑證…
certmgr-subject-label = 簽發給
certmgr-issuer-label = 簽發者
certmgr-period-of-validity = 有效期間
certmgr-fingerprints = 指紋
certmgr-cert-detail =
    .title = 憑證細節
    .buttonlabelaccept = 關閉
    .buttonaccesskeyaccept = C
certmgr-cert-detail-commonname = 一般名稱 (CN)
certmgr-cert-detail-org = 組織 (O)
certmgr-cert-detail-orgunit = 組織單位 (OU)
certmgr-cert-detail-serial-number = 序號
certmgr-cert-detail-sha-256-fingerprint = SHA-256 指紋
certmgr-cert-detail-sha-1-fingerprint = SHA1 指紋
certmgr-edit-ca-cert =
    .title = 編輯憑證機構信任關係設定
    .style = width: 48em;
certmgr-edit-cert-edit-trust = 編輯信任關係設定:
certmgr-edit-cert-trust-ssl =
    .label = 此憑證可用來識別網站。
certmgr-edit-cert-trust-email =
    .label = 此憑證可用來識別 Email 使用者。
certmgr-delete-cert =
    .title = 刪除憑證
    .style = width: 48em; height: 24em;
certmgr-cert-host =
    .label = 主機
certmgr-cert-name =
    .label = 憑證名稱
certmgr-cert-server =
    .label = 伺服器
certmgr-override-lifetime =
    .label = 有效時間
certmgr-token-name =
    .label = 安全裝置
certmgr-begins-on = 開始於
certmgr-begins-label =
    .label = 開始於
certmgr-expires-on = 過期於
certmgr-expires-label =
    .label = 過期於
certmgr-email =
    .label = E-Mail 地址
certmgr-serial =
    .label = 序號
certmgr-view =
    .label = 檢視…
    .accesskey = V
certmgr-edit =
    .label = 編輯信任…
    .accesskey = E
certmgr-export =
    .label = 匯出…
    .accesskey = x
certmgr-delete =
    .label = 刪除…
    .accesskey = D
certmgr-delete-builtin =
    .label = 刪除或取消信任…
    .accesskey = D
certmgr-backup =
    .label = 備份…
    .accesskey = B
certmgr-backup-all =
    .label = 全部備份…
    .accesskey = k
certmgr-restore =
    .label = 匯入…
    .accesskey = m
certmgr-details =
    .value = 憑證欄位
    .accesskey = f
certmgr-fields =
    .value = 欄位值
    .accesskey = V
certmgr-hierarchy =
    .value = 憑證層級
    .accesskey = H
certmgr-add-exception =
    .label = 新增例外網站…
    .accesskey = x
exception-mgr =
    .title = 新增安全例外
exception-mgr-extra-button =
    .label = 確認安全例外
    .accesskey = C
exception-mgr-supplemental-warning = 請注意，合法的銀行、商店或其他公開網站不會要求您這麼做！
exception-mgr-cert-location-url =
    .value = 位置:
exception-mgr-cert-location-download =
    .label = 取得憑證
    .accesskey = G
exception-mgr-cert-status-view-cert =
    .label = 檢視…
    .accesskey = V
exception-mgr-permanent =
    .label = 永久儲存此例外
    .accesskey = P
pk11-bad-password = 輸入的密碼不正確。
pkcs12-decode-err = 無法解碼檔案。它可能不是 PKCS #12 格式、或檔案損毀，或是您輸入的密碼有誤。
pkcs12-unknown-err-restore = 因為未知的原因而無法回存 PKCS #12 檔案。
pkcs12-unknown-err-backup = 因為未知的原因而無法備份 PKCS #12 檔案。
pkcs12-unknown-err = PKCS #12 因為不明原因失敗了。
pkcs12-info-no-smartcard-backup = 無法從像智慧卡等硬體安全裝置中備份憑證資訊。
pkcs12-dup-data = 此憑證及私密金鑰已存到安全裝置中了。

## PKCS#12 file dialogs

choose-p12-backup-file-dialog = 備份檔名
file-browse-pkcs12-spec = PKCS12 檔案
choose-p12-restore-file-dialog = 要匯入的憑證檔案

## Import certificate(s) file dialog

file-browse-certificate-spec = 憑證檔案
import-ca-certs-prompt = 選取包含憑證機構憑證的檔案以匯入
import-email-cert-prompt = 選取包含電子郵件憑證的檔案以匯入

## For editing certificates trust

# Variables:
#   $certName: the name of certificate
edit-trust-ca = 此憑證「{ $certName }」代表憑證機構。

## For Deleting Certificates

delete-user-cert-title =
    .title = 刪除您的憑證
delete-user-cert-confirm = 您確定要刪除這些憑證嗎？
delete-user-cert-impact = 如果您刪除了您自己的憑證，您就再也不能用它來識別您自己了。
delete-ssl-cert-title =
    .title = 刪除伺服器憑證例外
delete-ssl-cert-confirm = 您確定要刪除這些例外伺服器嗎？
delete-ssl-cert-impact = 若您刪除了例外伺服器，下次再連線到該伺服器時又會進行安全性檢查，要求使用有效憑證。
delete-ssl-override-title =
    .title = 刪除伺服器憑證例外項目
delete-ssl-override-confirm = 您確定要刪除此伺服器例外項目嗎？
delete-ssl-override-impact = 若您刪除了例外伺服器，下次再連線到該伺服器時又會進行安全性檢查，要求使用有效憑證。
delete-ca-cert-title =
    .title = 刪除或取消信任憑證機構的憑證
delete-ca-cert-confirm = 您要求刪除這些憑證機構的憑證。對內建的憑證來說，取消您對該憑證的信任也有一樣的效果。您確定想刪除或取消對憑證的信任嗎？
delete-ca-cert-impact = 若您刪除或取消對憑證機構（CA）的信任，此應用程式將不再信任任何由該機構簽發的憑證。
delete-email-cert-title =
    .title = 刪除 E-Mail 憑證
delete-email-cert-confirm = 您確定要刪除這些人的 E-mail 憑證嗎？
delete-email-cert-impact = 如果您刪除了一個人的 E-mail 憑證，您將無法在寄信給這個人時予以加密。
# Used for semi-uniquely representing a cert.
#
# Variables:
#   $serialNumber : the serial number of the cert in AA:BB:CC hex format.
cert-with-serial =
    .value = 序號為 { $serialNumber } 的憑證

## Cert Viewer

# Title used for the Certificate Viewer.
#
# Variables:
#   $certificate : a string representative of the certificate being viewed.
cert-viewer-title =
    .title = 憑證檢視器:「{ $certName }」
not-present =
    .value = <不存在於憑證中>
# Cert verification
cert-verified = 此憑證已驗證用於下列用途:
# Add usage
verify-ssl-client =
    .value = SSL 客戶端憑證
verify-ssl-server =
    .value = SSL 伺服器憑證
verify-ssl-ca =
    .value = SSL 憑證機構
verify-email-signer =
    .value = Email 簽署憑證
verify-email-recip =
    .value = Email 接收憑證
# Cert verification
cert-not-verified-cert-revoked = 無法驗證此憑證，因為憑證已廢止。
cert-not-verified-cert-expired = 無法驗證此憑證，因為憑證已過期。
cert-not-verified-cert-not-trusted = 無法驗證此憑證，因為憑證未被信任。
cert-not-verified-issuer-not-trusted = 無法驗證此憑證，因為憑證發行者未被信任。
cert-not-verified-issuer-unknown = 無法驗證此憑證，因為憑證發行者不明。
cert-not-verified-ca-invalid = 無法驗證此憑證，因為憑證機構憑證不正確。
cert-not-verified_algorithm-disabled = 由於簽章所使用的演算法不安全被停用的緣故，無法驗證此憑證。
cert-not-verified-unknown = 無法驗證此憑證，原因不明。
# Used to indicate that the user chose not to send a client authentication certificate to a server that requested one in a TLS handshake.
send-no-client-certificate = 並未傳送客戶端憑證
# Used when no cert is stored for an override
no-cert-stored-for-override = （未儲存）

## Used to show whether an override is temporary or permanent

permanent-override = 永久
temporary-override = 暫時

## Add Security Exception dialog

add-exception-branded-warning = 您正試圖覆蓋 { -brand-short-name } 要如何識別此網站的設定。
add-exception-invalid-header = 此網站嘗試用無效的資訊識別自己。
add-exception-domain-mismatch-short = 錯誤的網站
add-exception-domain-mismatch-long = 憑證屬於不同網站，有可能是某人想要仿造此網站。
add-exception-expired-short = 過時的資訊
add-exception-expired-long = 憑證已經失效，可能是被偷走或遺失，可能會被別人用於仿造此網站。
add-exception-unverified-or-bad-signature-short = 未知身份
add-exception-unverified-or-bad-signature-long = 因為無法確認此憑證是由受信任的單位以安全的方式簽署，無法信任此憑證。
add-exception-valid-short = 有效憑證
add-exception-valid-long = 此網站提供有效且經過驗證的識別資訊，不需要加入例外清單。
add-exception-checking-short = 檢查資訊中
add-exception-checking-long = 正在識別此網站…
add-exception-no-cert-short = 無可用資訊
add-exception-no-cert-long = 無法取得此網站的識別資訊。

## Certificate export "Save as" and error dialogs

save-cert-as = 儲存憑證到檔案
cert-format-base64 = X.509 憑證 (PEM)
cert-format-base64-chain = X.509 憑證鏈 (PEM)
cert-format-der = X.509 憑證 (DER)
cert-format-pkcs7 = X.509 憑證 (PKCS#7)
cert-format-pkcs7-chain = X.509 憑證鏈 (PKCS#7)
write-file-failure = 檔案錯誤
