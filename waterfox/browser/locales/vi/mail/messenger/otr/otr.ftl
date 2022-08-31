# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-encryption-required-part1 = Bạn đã cố gửi một tin nhắn không được mã hóa tới { $name }. Là một chính sách, tin nhắn không được mã hóa sẽ không được phép.

msgevent-encryption-required-part2 = Đang thử bắt đầu một cuộc trò chuyện riêng tư. Tin nhắn của bạn sẽ được gửi lại khi cuộc trò chuyện riêng tư bắt đầu.
msgevent-encryption-error = Đã xảy ra lỗi khi mã hóa thư của bạn. Tin nhắn đã không được gửi.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-connection-ended = { $name } đã đóng kết nối được mã hóa của họ với bạn. Để tránh việc bạn vô tình gửi tin nhắn mà không mã hóa, tin nhắn của bạn đã không được gửi. Vui lòng kết thúc cuộc trò chuyện được mã hóa của bạn hoặc khởi động lại nó.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-setup-error = Đã xảy ra lỗi khi thiết lập cuộc trò chuyện riêng tư với { $name }.

# Do not translate 'OTR' (name of an encryption protocol)
msgevent-msg-reflected = Bạn đang nhận được tin nhắn OTR của chính mình. Bạn đang nói chuyện với chính mình hoặc ai đó đang lặp lại tin nhắn của bạn.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-msg-resent = Tin nhắn cuối cùng tới { $name } đã được gửi lại.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-not-private = Không thể đọc được tin nhắn mã hóa nhận được từ { $name } vì bạn hiện không liên lạc riêng tư.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-unreadable = Bạn đã nhận được một tin nhắn mã hóa không đọc được từ { $name }

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-malformed = Bạn đã nhận được một thông báo dữ liệu không đúng định dạng từ { $name }.

# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log-heartbeat-rcvd = Đã nhận Heartbeat từ { $name }.

# A Heartbeat is a technical message used to keep a connection alive.
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-log-heartbeat-sent = Đã gửi Heartbeat đến { $name }.

# Do not translate 'OTR' (name of an encryption protocol)
msgevent-rcvdmsg-general-err = Đã xảy ra lỗi không mong muốn khi cố gắng bảo vệ cuộc trò chuyện của bạn bằng OTR.

# Variables:
#   $name (String) - the screen name of a chat contact person
#   $msg (string) - the message that was received.
msgevent-rcvdmsg-unencrypted = Tin nhắn sau nhận được từ { $name } không được mã hóa: { $msg }

# Do not translate 'OTR' (name of an encryption protocol)
# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-unrecognized = Bạn đã nhận được một tin nhắn OTR không xác định từ { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
msgevent-rcvdmsg-for-other-instance = { $name } đã gửi một tin nhắn dành cho một phiên khác. Nếu bạn đăng nhập nhiều lần, một phiên khác có thể đã nhận được thông báo.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone-secure-private = Đã bắt đầu cuộc trò chuyện riêng tư với { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-gone-secure-unverified = Cuộc trò chuyện được mã hóa nhưng chưa được xác thực đã bắt đầu với { $name }.

# Variables:
#   $name (String) - the screen name of a chat contact person
context-still-secure = Đã làm mới cuộc trò chuyện được mã hóa với { $name }.

error-enc = Đã xảy ra lỗi khi mã hóa tin nhắn.

# Variables:
#   $name (String) - the screen name of a chat contact person
error-not-priv = Bạn đã gửi dữ liệu được mã hóa đến { $name }, nhưng bên kia không nhận được như mong đợi.

error-unreadable = Bạn đã truyền đi một tin nhắn được mã hóa không đọc được.
error-malformed = Bạn đã truyền một tin nhắn dữ liệu không đúng định dạng.

resent = [đã gửi lại]

# Variables:
#   $name (String) - the screen name of a chat contact person
tlv-disconnected = { $name } đã kết thúc cuộc trò chuyện được mã hóa của họ với bạn; bạn cũng nên làm vậy.

# Do not translate "Off-the-Record" and "OTR" which is the name of an encryption protocol
# Make sure that this string does NOT contain any numbers, e.g. like "3".
# Variables:
#   $name (String) - the screen name of a chat contact person
query-msg = { $name } đã yêu cầu một cuộc trò chuyện được mã hóa Off-the-Record (OTR). Tuy nhiên, bạn không có một plugin để hỗ trợ điều đó. Xem tại https://en.wikipedia.org/wiki/Off-the-Record_Messaging để biết thêm thông tin.
