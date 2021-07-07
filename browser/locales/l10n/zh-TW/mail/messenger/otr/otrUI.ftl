# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

start-label = 開始加密對話
refresh-label = 重新整理加密對話
auth-label = 確認聯絡人的身分
reauth-label = 重新確認聯絡人的身分

auth-cancel = 取消
auth-cancel-access-key = C

auth-error = 驗證聯絡人身分時發生錯誤。
auth-success = 已成功驗證您的聯絡人的身分。
auth-success-them = 您的聯絡人已成功驗證您的身分。您可能也想要問他們問題，來驗證他們的身分。
auth-fail = 無法驗證您的聯絡人的身分。
auth-waiting = 等待聯絡人完成驗證…

finger-verify = 驗證
finger-verify-access-key = V

# Do not translate 'OTR' (name of an encryption protocol)
buddycontextmenu-label = 新增 OTR 指紋

# Variables:
#   $name (String) - the screen name of a chat contact person
alert-start = 正在嘗試與 { $name } 開始進行加密對話…

# Variables:
#   $name (String) - the screen name of a chat contact person
alert-refresh = 正在嘗試與 { $name } 重新整理加密對話…

# Variables:
#   $name (String) - the screen name of a chat contact person
alert-gone-insecure = 與 { $name } 的加密對話結束。

# Variables:
#   $name (String) - the screen name of a chat contact person
finger-unseen = { $name } 的身分未經驗證。雖然不可能受到一般的竊聽，但有心人花點功夫還是可以暗中偷聽。請驗證此聯絡人的身分來防止您受到監控。

# Variables:
#   $name (String) - the screen name of a chat contact person
finger-seen = { $name } 使用未經識別的電腦聯絡您。雖然不可能受到一般的竊聽，但有心人花點功夫還是可以暗中偷聽。請驗證此聯絡人的身分來防止您受到監控。

state-not-private = 目前的對話不是私人對話。

state-generic-not-private = 目前的對話不是私人對話。

# Variables:
#   $name (String) - the screen name of a chat contact person
state-unverified = 由於尚未驗證 { $name } 的身分，目前的對話有加密但並不隱私。

state-generic-unverified = 由於尚未驗證某些人的身分，目前的對話雖經加密，但不能確保隱私。

# Variables:
#   $name (String) - the screen name of a chat contact person
state-private = { $name } 的身分已經驗證，目前的對話已加密也能確保隱私。

state-generic-private = 目前的對話已經加密，也已確認隱私。

# Variables:
#   $name (String) - the screen name of a chat contact person
state-finished = { $name } 結束了與您之間的加密對話，您也應該中斷對話。

state-not-private-label = 不安全
state-unverified-label = 未驗證
state-private-label = 私人
state-finished-label = 已完成

# Variables:
#   $name (String) - the screen name of a chat contact person
verify-request = { $name } 要求驗證您的身分。

# Variables:
#   $name (String) - the screen name of a chat contact person
afterauth-private = 您已驗證 { $name } 的身分。

# Variables:
#   $name (String) - the screen name of a chat contact person
afterauth-unverified = { $name } 的身分未經驗證。

verify-title = 確認聯絡人的身分
error-title = 錯誤
success-title = 端到端加密
success-them-title = 確認聯絡人的身分
fail-title = 無法驗證
waiting-title = 已送出驗證請求

# Do not translate 'OTR' (name of an encryption protocol)
# Variables:
#   $error (String) - contains an error message that describes the cause of the failure
otr-genkey-failed = OTR 私鑰產生失敗: { $error }
