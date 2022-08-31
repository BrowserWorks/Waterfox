# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = 密碼品質測量計

## Change Password dialog

change-device-password-window =
    .title = 更改密碼

# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = 安全裝置: { $tokenName }
change-password-old = 目前密碼:
change-password-new = 新密碼:
change-password-reenter = 新密碼 (再輸入一次):

## Reset Password dialog

pippki-failed-pw-change = 無法更改密碼。
pippki-incorrect-pw = 您輸入的目前密碼錯誤，請再試一次。
pippki-pw-change-ok = 成功變更密碼。

pippki-pw-empty-warning = 將不再保護您儲存的密碼與私鑰。
pippki-pw-erased-ok = 您已刪除密碼，{ pippki-pw-empty-warning }
pippki-pw-not-wanted = 警告，您已決定不使用密碼，{ pippki-pw-empty-warning }

pippki-pw-change2empty-in-fips-mode = 您目前使用 FIPS 模式。FIPS 模式必需設定密碼。

## Reset Primary Password dialog

reset-primary-password-window =
    .title = 重設主控密碼
    .style = width: 40em
reset-password-button-label =
    .label = 重設

reset-primary-password-text = 如果要重設主控密碼，您所有的網頁與電子郵件密碼、個人憑證、私密金鑰等資訊都會被清除。確定要重設主控密碼嗎？

pippki-reset-password-confirmation-title = 重設主控密碼
pippki-reset-password-confirmation-message = 成功重設您的主控密碼。

## Downloading cert dialog

download-cert-window =
    .title = 下載憑證
    .style = width: 46em
download-cert-message = 您被要求信任一個新憑證機構 (CA)。
download-cert-trust-ssl =
    .label = 信任此憑證機構以識別網站。
download-cert-trust-email =
    .label = 信任此憑證機構以識別郵件用戶。
download-cert-message-desc = 在信任此憑證機構前，您應該確認它的憑證及政策程序（如果有的話）。
download-cert-view-cert =
    .label = 檢視
download-cert-view-text = 檢查憑證機構的憑證

## Client Authorization Ask dialog

client-auth-window =
    .title = 使用者識別需求
client-auth-site-description = 此網站要求您提供可用來識別您自己的憑證:
client-auth-choose-cert = 選擇一項憑證以做為識別:
client-auth-cert-details = 所選憑證的詳細資訊:

## Set password (p12) dialog

set-password-window =
    .title = 選擇憑證備份密碼
set-password-message = 在此設定的憑證備份密碼可保護您要建立的備份檔。您必須設定密碼才能繼續備份。
set-password-backup-pw =
    .value = 憑證備份密碼:
set-password-repeat-backup-pw =
    .value = 憑證備份密碼 (再輸入一次):
set-password-reminder = 重要: 如果您忘了憑證備份密碼，將會無法回存備份。請多備一份到安全的地方。

## Protected Auth dialog

protected-auth-window =
    .title = 被保護的 Token 鑑別
protected-auth-msg = 請鑑別此 Token，鑑別方法會隨 Token 類型而不同。
protected-auth-token = Token:
