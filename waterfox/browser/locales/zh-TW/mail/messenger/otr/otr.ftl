# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-encryption-required-part1 = 您嘗試要傳送未加密過的訊息給 { $name }。政策規定，不允許傳送未加密過的訊息。

msgevent-encryption-required-part2 = 將嘗試進行私人對話，將在私人對話開始後重新送出您的訊息。
msgevent-encryption-error = 加密訊息時發生錯誤，訊息並未送出。

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-connection-ended = { $name } 已關閉了與您之間的加密連線。為了避免您意外送出未經加密的訊息，並未送出您的訊息。請結束或重新開始加密對話。

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-setup-error = 建立與 { $name } 之間的私人對話時發生錯誤。

# Do not translate 'OTR' (name of an encryption protocol)
msgevent-msg-reflected = 您接收到來自您自己的 OTR 訊息。不是您正在自言自語，就是有人將訊息反射回來給您。

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-msg-resent = 已重發上一封給 { $name } 的訊息。

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-not-private = 由於您與 { $name } 並不在私人通訊當中，無法閱讀收到的加密訊息。

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-unreadable = 您收到來自 { $name } 的無法閱讀的加密訊息。

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-malformed = 您收到來自 { $name } 的資料格式錯誤的訊息。

# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log-heartbeat-rcvd = 您收到來自 { $name } 的 Heartbeat 訊息。

# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log-heartbeat-sent = 已傳送 Heartbeat 訊息給 { $name }。

# Do not translate 'OTR' (name of an encryption protocol)
msgevent-rcvdmsg-general-err = 嘗試使用 OTR 保護對話訊息時，發生未知錯誤。

# Variables:
#   $name (String) - the screen name of a chat contact person
#   $msg (string) - the message that was received.
msgevent-rcvdmsg-unencrypted = 收到來自 { $name } 的下列訊息未經加密: { $msg }

# Do not translate 'OTR' (name of an encryption protocol)
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-unrecognized = 您收到來自 { $name } 的無法識別的 OTR 訊息。

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-for-other-instance = { $name } 送出了要發給不同使用階段的訊息。若您在多個地方登入，其他的使用階段可能也收到了該封訊息。

# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone-secure-private = 與 { $name } 的私人對話開始。

# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone-secure-unverified = 與 { $name } 有加密，但未經驗證的對話開始。

# Variables:
#   $name (String) - the screen name of a chat contact person
context-still-secure = 成功重新整理與 { $name } 的加密對話。

error-enc = 加密訊息時發生錯誤。

# Variables:
#   $name (String) - the screen name of a chat contact person
error-not-priv = 您傳送了加密資料給 { $name }，但對方並未預期收到此資料。

error-unreadable = 您傳送了無法閱讀的加密訊息。
error-malformed = 您傳送了資料格式錯誤的訊息。

resent = [重寄]

# Variables:
#   $name (String) - the screen name of a chat contact person
tlv-disconnected = { $name } 結束了與您之間的加密對話，您也應該中斷對話。

# Do not translate "Off-the-Record" and "OTR" which is the name of an encryption protocol
# Make sure that this string does NOT contain any numbers, e.g. like "3".
# Variables:
#   $name (String) - the screen name of a chat contact person
query-msg = { $name } 要求進行不留紀錄（OTR）加密聊天，但您沒有支援該功能的外掛程式。若需更多資訊，請參考 https://en.wikipedia.org/wiki/Off-the-Record_Messaging 。
