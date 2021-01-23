# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

start-label = 开始加密对话
refresh-label = 刷新加密对话
auth-label = 验证联系人的身份
reauth-label = 重新验证联系人的身份

auth-cancel = 取消
auth-cancelAccessKey = C

auth-error = 验证联系人身份时发生错误。
auth-success = 已成功验证联系人的身份。
auth-successThem = 您的联系人已成功验证您的身份。您可能也想问他们问题，来验证其身份。
auth-fail = 无法验证联系人的身份。
auth-waiting = 等待联系人完成验证…

finger-verify = 验证
finger-verify-accessKey = V

# Do not translate 'OTR' (name of an encryption protocol)
buddycontextmenu-label = 添加 OTR 指纹

# Variables:
#   $name (String) - the screen name of a chat contact person
alert-start = 尝试与 { $name } 开始加密对话。

# Variables:
#   $name (String) - the screen name of a chat contact person
alert-refresh = 正在尝试刷新与 { $name } 的加密对话。

# Variables:
#   $name (String) - the screen name of a chat contact person
alert-gone_insecure = 与 { $name } 的加密对话结束。

# Variables:
#   $name (String) - the screen name of a chat contact person
finger-unseen = 保{ $name } 的身份尚未验证。尽管偶然的窃听不太可能，但为万无一失。请验证此联系人的身份来避免受到监控。

# Variables:
#   $name (String) - the screen name of a chat contact person
finger-seen = { $name } 使用未识别的计算机与您联系。尽管偶然的窃听不太可能，但为保万无一失。请验证此联系人的身份来避免受到监控。

state-not_private = 当前对话并不隐私。

# Variables:
#   $name (String) - the screen name of a chat contact person
state-unverified = 由于 { $name } 的身份尚未验证，当前对话已加密但并不隐私。

# Variables:
#   $name (String) - the screen name of a chat contact person
state-private = { $name }的身份已验证。当前对话已加密且能保证隐私。

# Variables:
#   $name (String) - the screen name of a chat contact person
state-finished = { $name } 已结束与您的加密对话；您也应该中断对话。

state-not_private-label = 不安全
state-unverified-label = 未验证
state-private-label = 私人
state-finished-label = 已完成

# Variables:
#   $name (String) - the screen name of a chat contact person
verify-request = { $name } 请求验证您的身份。

# Variables:
#   $name (String) - the screen name of a chat contact person
afterauth-private = 您已验证 { $name } 的身份。

# Variables:
#   $name (String) - the screen name of a chat contact person
afterauth-unverified = { $name } 的身份尚未验证。

verify-title = 验证联系人的身份
error-title = 错误
success-title = 端到端加密
successThem-title = 验证联系人的身份
fail-title = 无法验证
waiting-title = 验证请求已发送

# Do not translate 'OTR' (name of an encryption protocol)
# Variables:
#   $error (String) - contains an error message that describes the cause of the failure
otr-genkey-failed = 生成 OTR 私钥失败：{ $error }
