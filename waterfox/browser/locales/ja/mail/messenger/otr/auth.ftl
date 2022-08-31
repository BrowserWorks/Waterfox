# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

otr-auth =
    .title = 相手の身元確認
    .buttonlabelaccept = 確認
# Variables:
#   $name (String) - the screen name of a chat contact person
auth-title = { $name } さんの身元確認
# Variables:
#   $own_name (String) - the user's own screen name
auth-your-fp-value = { $own_name } のフィンガープリント:
# Variables:
#   $their_name (String) - the screen name of a chat contact
auth-their-fp-value = { $their_name } さんのフィンガープリント:
auth-help = 相手の身元を確認することでプライベートな会話を行い、第三者による盗聴や改竄を非常に難しくすることができます。
auth-help-title = 身元確認ヘルプ
auth-question-received = これは相手からの質問です:
auth-yes =
    .label = はい
auth-no =
    .label = いいえ
auth-verified = これが事実に基づく正しいフィンガープリントであることを確認しました。
auth-manual-verification = フィンガープリントの確認
auth-question-and-answer = 質問と回答
auth-shared-secret = 秘密の合言葉
auth-manual-verification-label =
    .label = { auth-manual-verification }
auth-question-and-answer-label =
    .label = { auth-question-and-answer }
auth-shared-secret-label =
    .label = { auth-shared-secret }
auth-manual-instruction = 電話や OpenPGP で署名されたメールなど、別の信用できる通信チャンネルで会話の相手と連絡を取り、お互いのフィンガープリントを伝えてください。(フィンガープリントは暗号キーを識別するチェックサムです。) お互いのフィンガープリントが一致すると、下のダイアログにフィンガープリントを確認したことが表示されます。
auth-how = 相手の身元確認をどのようにして行いますか？
auth-qa-instruction = 質問の内容は、あなたと相手だけが答えられるものにしてください。質問と答えを入力したら、相手が回答するまで待ってください。回答が一致しない場合、ご使用の通信チャンネルが監視下にある可能性があります。
auth-secret-instruction = 秘密の合言葉は、あなたと相手だけが知っているものにしてください。同じインターネット接続の回線上で合言葉を交換してはいけません。合言葉を入力したら、相手が同じ合言葉を入力するまで待ってください。合言葉が一致しない場合、ご使用の通信チャンネルが監視下にある可能性があります。
auth-question = 質問を入力してください:
auth-answer = 回答を入力してください (大文字小文字を区別します):
auth-secret = 合言葉を入力してください:
