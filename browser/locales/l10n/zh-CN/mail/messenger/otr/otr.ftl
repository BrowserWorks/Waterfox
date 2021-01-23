# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-encryption_required_part1 = 您试图将未加密的消息发送给 { $name }。根据政策，不允许发送未加密的消息。

msgevent-encryption_required_part2 = 尝试进行私人对话。将在私人对话开始后重发您的消息。
msgevent-encryption_error = 加密消息时出错，消息未发送。

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-connection_ended = { $name } 已关闭与您的加密连接。为避免意外发送未加密的消息，你的消息并未发送。请结束或重新开始您的加密对话。

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-setup_error = 与 { $name } 建立私人对话时出错。

# Do not translate 'OTR' (name of an encryption protocol)
msgevent-msg_reflected = 您正在接收自己的 OTR 消息。要么您正在自言自语，要么有人正在复读您的消息。

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-msg_resent = 已重发最后一条给 { $name } 的消息。

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_not_private = 由于您与 { $name } 当前未在私人对话，无法读取接收到的加密消息。

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_unreadable = 您收到一条来自 { $name } 的无法读取的加密消息。

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_malformed = 您收到一条来自 { $name } 的数据格式错误的消息。

# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log_heartbeat_rcvd = 从 { $name } 收到心跳。

# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log_heartbeat_sent = 已发送心跳至 { $name }。

# Do not translate 'OTR' (name of an encryption protocol)
msgevent-rcvdmsg_general_err = 尝试使用 OTR 保护您的对话时发生意外错误。

# Variables:
#   $name (String) - the screen name of a chat contact person
#   $msg (string) - the message that was received.
msgevent-rcvdmsg_unencrypted = 收到来自 { $name } 以下消息未加密：{ $msg }

# Do not translate 'OTR' (name of an encryption protocol)
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_unrecognized = 您收到来自 { $name } 的 OTR 消息无法识别。

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_for_other_instance = { $name } 在另一会话发送了消息。若您同时在多个设备登录，那么其他会话可能已收到该消息。

# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone_secure_private = 与 { $name } 的私人对话开始。

# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone_secure_unverified = 与 { $name } 有加密，但未经验证的对话开始。

# Variables:
#   $name (String) - the screen name of a chat contact person
context-still_secure = 与 { $name } 的加密对话已成功刷新。

error-enc = 加密消息时发生错误。

# Variables:
#   $name (String) - the screen name of a chat contact person
error-not_priv = 您已将加密的数据发送给 { $name }，而对方并未预期收到此数据。

error-unreadable = 您发出了无法读取的加密消息。
error-malformed = 您发出了数据格式错误的消息。

resent = [重发]

# Variables:
#   $name (String) - the screen name of a chat contact person
tlv-disconnected = { $name } 已结束与您的加密对话；您也应该中断对话。

# Do not translate "Off-the-Record" and "OTR" which is the name of an encryption protocol
# Make sure that this string does NOT contain any numbers, e.g. like "3".
# Variables:
#   $name (String) - the screen name of a chat contact person
query-msg = { $name } 请求进行非记录（OTR）加密对话，但您没有支持该功能的插件。若需更多信息，请参见 https://en.wikipedia.org/wiki/Off-the-Record_Messaging。
