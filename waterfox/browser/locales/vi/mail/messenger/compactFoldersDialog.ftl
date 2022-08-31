# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

compact-dialog-window =
    .title = Làm gọn thư mục
    .style = width: 50em;

compact-dialog =
    .buttonlabelaccept = Làm gọn ngay
    .buttonaccesskeyaccept = C
    .buttonlabelcancel = Nhắc tôi sau
    .buttonaccesskeycancel = R
    .buttonlabelextra1 = Tìm hiểu thêm…
    .buttonaccesskeyextra1 = L

# Variables:
#  $data (String): The amount of space to be freed, formatted byte, MB, GB, etc., based on the size.
compact-dialog-message = { -brand-short-name } cần thực hiện bảo trì tập tin thường xuyên để cải thiện hiệu suất của các thư mục thư của bạn.  Điều này sẽ phục hồi { $data } dung lượng trống mà không cần thay đổi thư của bạn.  Để { -brand-short-name } thực hiện việc này tự động trong tương lai mà không cần hỏi, hãy chọn hộp bên dưới trước khi chọn ‘{ compact-dialog.buttonlabelaccept }’.

compact-dialog-never-ask-checkbox =
    .label = Tự động làm gọn các thư mục trong tương lai
    .accesskey = a

