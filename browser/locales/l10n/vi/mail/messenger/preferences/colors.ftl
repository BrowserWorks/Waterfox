# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

colors-dialog-window =
    .title = Màu sắc
    .style =
        { PLATFORM() ->
            [macos] width: 41em !important
           *[other] width: 38em !important
        }

colors-dialog-legend = Văn bản và nền

text-color-label =
    .value = Văn bản:
    .accesskey = T

background-color-label =
    .value = Nền:
    .accesskey = B

use-system-colors =
    .label = Dùng màu sắc của hệ thống
    .accesskey = s

colors-link-legend = Màu liên kết

link-color-label =
    .value = Liên kết chưa truy cập:
    .accesskey = L

visited-link-color-label =
    .value = Liên kết đã truy cập:
    .accesskey = V

underline-link-checkbox =
    .label = Các liên kết được gạch chân
    .accesskey = U

override-color-label =
    .value = Ghi đè các màu được chỉ định bởi nội dung bằng các lựa chọn của tôi ở trên:
    .accesskey = O

override-color-always =
    .label = Luôn luôn

override-color-auto =
    .label = Chỉ trong các chủ đề có độ tương phản cao

override-color-never =
    .label = Không bao giờ
