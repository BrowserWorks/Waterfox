# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-encryption_required_part1 = You attempted to send an unencrypted message to { $name }. As a policy, unencrypted messages are not allowed.
msgevent-encryption_required_part2 = Attempting to start a private conversation. Your message will be resent when the private conversation starts.
msgevent-encryption_error = An error occurred when encrypting your message. The message was not sent.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-connection_ended = { $name } has already closed their encrypted connection to you. To avoid that you accidentally send a message without encryption, your message was not sent. Please end your encrypted conversation, or restart it.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-setup_error = An error occurred while setting up a private conversation with { $name }.
# Do not translate 'OTR' (name of an encryption protocol)
msgevent-msg_reflected = You are receiving your own OTR messages. You are either trying to talk to yourself, or someone is reflecting your messages back at you.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-msg_resent = The last message to { $name } was resent.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_not_private = The encrypted message received from { $name } is unreadable, as you are not currently communicating privately.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_unreadable = You received an unreadable encrypted message from { $name }.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_malformed = You received a malformed data message from { $name }.
# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log_heartbeat_rcvd = Heartbeat received from { $name }.
# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log_heartbeat_sent = Heartbeat sent to { $name }.
# Do not translate 'OTR' (name of an encryption protocol)
msgevent-rcvdmsg_general_err = An unexpected error occurred while trying to protect your conversation using OTR.
# Variables:
#   $name (String) - the screen name of a chat contact person
#   $msg (string) - the message that was received.
msgevent-rcvdmsg_unencrypted = The following message received from { $name } was not encrypted: { $msg }
# Do not translate 'OTR' (name of an encryption protocol)
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_unrecognized = You received an unrecognised OTR message from { $name }.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg_for_other_instance = { $name } has sent a message intended for a different session. If you are logged in multiple times, another session may have received the message.
# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone_secure_private = Private conversation with { $name } started.
# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone_secure_unverified = Encrypted, but unverified conversation with { $name } started.
# Variables:
#   $name (String) - the screen name of a chat contact person
context-still_secure = Successfully refreshed the encrypted conversation with { $name }.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-encryption-required-part1 = You attempted to send an unencrypted message to { $name }. As a policy, unencrypted messages are not allowed.
msgevent-encryption-required-part2 = Attempting to start a private conversation. Your message will be resent when the private conversation starts.
msgevent-encryption-error = An error occurred when encrypting your message. The message was not sent.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-connection-ended = { $name } has already closed their encrypted connection to you. To avoid that you accidentally send a message without encryption, your message was not sent. Please end your encrypted conversation, or restart it.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-setup-error = An error occurred while setting up a private conversation with { $name }.
# Do not translate 'OTR' (name of an encryption protocol)
msgevent-msg-reflected = You are receiving your own OTR messages. You are either trying to talk to yourself, or someone is reflecting your messages back at you.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-msg-resent = The last message to { $name } was resent.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-not-private = The encrypted message received from { $name } is unreadable, as you are not currently communicating privately.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-unreadable = You received an unreadable encrypted message from { $name }.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-malformed = You received a malformed data message from { $name }.
# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log-heartbeat-rcvd = Heartbeat received from { $name }.
# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log-heartbeat-sent = Heartbeat sent to { $name }.
# Do not translate 'OTR' (name of an encryption protocol)
msgevent-rcvdmsg-general-err = An unexpected error occurred while trying to protect your conversation using OTR.
# Variables:
#   $name (String) - the screen name of a chat contact person
#   $msg (string) - the message that was received.
msgevent-rcvdmsg-unencrypted = The following message received from { $name } was not encrypted: { $msg }
# Do not translate 'OTR' (name of an encryption protocol)
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-unrecognized = You received an unrecognised OTR message from { $name }.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-for-other-instance = { $name } has sent a message intended for a different session. If you are logged in multiple times, another session may have received the message.
# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone-secure-private = Private conversation with { $name } started.
# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone-secure-unverified = Encrypted, but unverified conversation with { $name } started.
# Variables:
#   $name (String) - the screen name of a chat contact person
context-still-secure = Successfully refreshed the encrypted conversation with { $name }.
error-enc = An error occurred while encrypting the message.
# Variables:
#   $name (String) - the screen name of a chat contact person
error-not_priv = You sent encrypted data to { $name }, who wasn't expecting it.
# Variables:
#   $name (String) - the screen name of a chat contact person
error-not-priv = You sent encrypted data to { $name }, who wasn’t expecting it.
error-unreadable = You transmitted an unreadable encrypted message.
error-malformed = You transmitted a malformed data message.
resent = [resent]
# Variables:
#   $name (String) - the screen name of a chat contact person
tlv-disconnected = { $name } has ended their encrypted conversation with you; you should do the same.
# Do not translate "Off-the-Record" and "OTR" which is the name of an encryption protocol
# Make sure that this string does NOT contain any numbers, e.g. like "3".
# Variables:
#   $name (String) - the screen name of a chat contact person
query-msg = { $name } has requested an Off-the-Record (OTR) encrypted conversation. However, you do not have a plugin to support that. See https://en.wikipedia.org/wiki/Off-the-Record_Messaging for more information.
