# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

start-label = 暗号化された会話を開始
refresh-label = 暗号化された会話をリフレッシュ
auth-label = 相手の身元を確認
reauth-label = 相手の身元を再確認
auth-cancel = キャンセル
auth-cancel-access-key = C
auth-error = 相手の身元確認中にエラーが発生しました。
auth-success = 相手の身元確認が完了しました。
auth-success-them = 相手があなたの身元を確認しました。あなたも相手に質問して身元を確認してみましょう。
auth-fail = 相手の身元確認に失敗しました。
auth-waiting = 相手が身元確認を完了するまで待機しています...
finger-verify = 確認
finger-verify-access-key = V
# Do not translate 'OTR' (name of an encryption protocol)
buddycontextmenu-label = OTR フィンガープリントを追加
# Variables:
#   $name (String) - the screen name of a chat contact person
alert-start = { $name } さんとの暗号化された会話を開始しようとしています。
# Variables:
#   $name (String) - the screen name of a chat contact person
alert-refresh = { $name } さんとの暗号化された会話をリフレッシュしようとしています。
# Variables:
#   $name (String) - the screen name of a chat contact person
alert-gone-insecure = { $name } さんとの暗号化された会話を終了しました。
# Variables:
#   $name (String) - the screen name of a chat contact person
finger-unseen = { $name } さんの身元をまだ確認していません。計画的でない盗聴は不可能ですが、方法次第で盗聴できてしまう場合があります。相手の身元を確認して監視を避けてください。
# Variables:
#   $name (String) - the screen name of a chat contact person
finger-seen={ $name } さんが未認識のコンピューターからあなたと連絡を取っています。計画的でない盗聴は不可能ですが、方法次第で盗聴できてしまう場合があります。相手の身元を確認して監視を避けてください。
state-not-private = 現在の会話はプライベートではありません。
state-generic-not-private = 現在の会話はプライベートではありません。
# Variables:
#   $name (String) - the screen name of a chat contact person
state-unverified = 現在の会話は暗号化されていますが、{ $name } さんの身元がまだ確認されていないためプライベートではありません。
state-generic-unverified = 現在の会話は暗号化されていますが、一部の参加者の身元がまだ確認されていないためプライベートではありません。
# Variables:
#   $name (String) - the screen name of a chat contact person
state-private = { $name } さんの身元が確認されました。現在の会話は暗号化されておりプライベートです。
state-generic-private = 現在の会話は暗号化されておりプライベートです。
# Variables:
#   $name (String) - the screen name of a chat contact person
state-finished = { $name } さんはあなたとの暗号化された会話を終了しています。同様に会話を終了してください。
state-not-private-label = 安全でない
state-unverified-label = 未確認
state-private-label = プライベート
state-finished-label = 終了
# Variables:
#   $name (String) - the screen name of a chat contact person
verify-request = { $name } さんが身元確認を要求しています。
# Variables:
#   $name (String) - the screen name of a chat contact person
afterauth-private = { $name } さんの身元を確認しました。
# Variables:
#   $name (String) - the screen name of a chat contact person
afterauth-unverified = { $name } さんの身元はまだ確認されていません。
verify-title = 相手の身元確認
error-title = エラー
success-title = エンドツーエンド暗号化
success-them-title = 相手の身元を確認してください
fail-title = 確認できません
waiting-title = 身元確認要求を送信しました
# Do not translate 'OTR' (name of an encryption protocol)
# Variables:
#   $error (String) - contains an error message that describes the cause of the failure
otr-genkey-failed = OTR 秘密鍵の生成に失敗しました: { $error }
