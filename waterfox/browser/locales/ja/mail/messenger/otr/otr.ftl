# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-encryption-required-part1 = { $name } さんに暗号化されていないメッセージを送信しようとしています。セキュリティポリシーにより暗号化されていないメッセージは許可されません。
msgevent-encryption-required-part2 = プライベートな会話を開始しようとしています。プライベートな会話を開始するとあなたのメッセージが再送信されます。
msgevent-encryption-error = メッセージの暗号化時にエラーが発生しました。このメッセージは送信されませんでした。
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-connection-ended = { $name } さんは暗号化された接続をすでに閉じています。暗号化されていないメッセージの誤送信を避けるため、あなたのメッセージは送信されませんでした。暗号化された会話を一旦終了し、再開してください。
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-setup-error = { $name } さんとのプライベートな会話の準備中にエラーが発生しました。
# Do not translate 'OTR' (name of an encryption protocol)
msgevent-msg-reflected = 自分の OTR メッセージを受信しています。自分宛てにメッセージを送信しているか、誰かがあなたのメッセージを送り返しています。
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-msg-resent = { $name } さんへの最新のメッセージが再送信されました。
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-not-private = 現在の通信がプライベートではないため、{ $name } さんからの暗号化されたメッセージを読めません。
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-unreadable = { $name } さんから読めない暗号化されたメッセージを受信しました。
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-malformed = { $name } さんからデータ改竄されたメッセージを受信しました。
# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log-heartbeat-rcvd = { $name } さんから在席確認を受信しました。
# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log-heartbeat-sent = { $name } さんへ在席確認を送信しました。
# Do not translate 'OTR' (name of an encryption protocol)
msgevent-rcvdmsg-general-err = OTR による会話の保護中に予期しないエラーが発生しました。
# Variables:
#   $name (String) - the screen name of a chat contact person
#   $msg (string) - the message that was received.
msgevent-rcvdmsg-unencrypted = { $name } さんから受信した次のメッセージは暗号化されていません: { $msg }
# Do not translate 'OTR' (name of an encryption protocol)
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-unrecognized = { $name } さんから未認識の OTR メッセージを受信しました。
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-for-other-instance = { $name } さんが異なるセッションに対してメッセージを送信しました。あなたが複数回ログインしている場合、別のセッションでメッセージを受信している可能性があります。
# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone-secure-private = { $name } さんとのプライベートな会話を開始しました。
# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone-secure-unverified = 暗号化されていますが未確認の { $name } さんとの会話を開始しました。
# Variables:
#   $name (String) - the screen name of a chat contact person
context-still-secure = { $name } さんとの暗号化された会話のリフレッシュが完了しました。

error-enc = メッセージの暗号化中にエラーが発生しました。
# Variables:
#   $name (String) - the screen name of a chat contact person
error-not-priv = { $name } さんへ暗号化されたデータを送信しましたが、相手は予期していませんでした。
error-unreadable = 読めない暗号化されたメッセージを発信しました。
error-malformed = データ改竄されたメッセージを発信しました。
resent = [再送信]
# Variables:
#   $name (String) - the screen name of a chat contact person
tlv-disconnected = { $name } さんはあなたとの暗号化された会話を終了しています。同様に会話を終了してください。
# Do not translate "Off-the-Record" and "OTR" which is the name of an encryption protocol
# Make sure that this string does NOT contain any numbers, e.g. like "3".
# Variables:
#   $name (String) - the screen name of a chat contact person
query-msg = { $name } さんから Off-the-Record (OTR) の暗号化された会話を要求されていますが、OTR をサポートするプラグインがありません。詳しい情報は https://en.wikipedia.org/wiki/Off-the-Record_Messaging を参照してください。
