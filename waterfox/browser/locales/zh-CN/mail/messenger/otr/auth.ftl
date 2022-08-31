# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

otr-auth =
    .title = 验证联系人的身份
    .buttonlabelaccept = 验证

# Variables:
#   $name (String) - the screen name of a chat contact person
auth-title = 验证 { $name } 的身份

# Variables:
#   $own_name (String) - the user's own screen name
auth-your-fp-value = 您的指纹，{ $own_name }：

# Variables:
#   $their_name (String) - the screen name of a chat contact
auth-their-fp-value = { $their_name } 的指纹：

auth-help = 验证联系人的身份有助于确保对话是真正私密的，从而使第三方很难窃听或操纵对话。

auth-help-title = 验证帮助

auth-question-received = 这是您的联系人提出的问题：

auth-yes =
    .label = 是

auth-no =
    .label = 否

auth-verified = 我已验证这的确是正确的指纹。

auth-manual-verification = 手动验证指纹
auth-question-and-answer = 通过问答验证
auth-shared-secret = 通过共享的密语验证

auth-manual-verification-label =
    .label = { auth-manual-verification }

auth-question-and-answer-label =
    .label = { auth-question-and-answer }

auth-shared-secret-label =
    .label = { auth-shared-secret }

auth-manual-instruction = 请通过其他可信的渠道（例如 OpenPGP 签名的电子邮件或拨打电话），与您要进行通信的另一方联系。你们应该互相告诉对方自己的指纹。（“指纹”用于标识加密密钥的校验和。）若指纹匹配，就在下方的对话框中指出双方已验证过指纹。

auth-how = 您想如何验证联系人的身份？

auth-qa-instruction = 想一个只有您和要联系的人知道答案的问题。输入问题与答案，然后等待对方回答。若答案不正确，则代表你们之间的通信渠道可能正被监听。

auth-secret-instruction = 想一个只有您和要联系的人知道的密语。但不要使用相同的网络连接来交换该秘密。您先输入秘密，然后等待对方也输入该密语。若密语不匹配，则你们之间的通信渠道可能正被监听。

auth-question = 请输入问题：

auth-answer = 请输入答案（区分大小写）：

auth-secret = 请输入密语：
