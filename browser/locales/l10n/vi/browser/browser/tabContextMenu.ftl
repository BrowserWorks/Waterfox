# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

reload-tab =
    .label = Tải lại thẻ
    .accesskey = R
select-all-tabs =
    .label = Chọn tất cả các thẻ
    .accesskey = S
duplicate-tab =
    .label = Nhân đôi thẻ
    .accesskey = D
duplicate-tabs =
    .label = Nhân đôi các thẻ
    .accesskey = D
close-tabs-to-the-end =
    .label = Đóng các thẻ ở bên phải
    .accesskey = i
close-other-tabs =
    .label = Đóng các thẻ khác
    .accesskey = o
reload-tabs =
    .label = Tải lại các thẻ
    .accesskey = R
pin-tab =
    .label = Ghim thẻ
    .accesskey = P
unpin-tab =
    .label = Gỡ thẻ
    .accesskey = b
pin-selected-tabs =
    .label = Ghim thẻ
    .accesskey = P
unpin-selected-tabs =
    .label = Bỏ ghim thẻ
    .accesskey = b
bookmark-selected-tabs =
    .label = Đánh dấu các thẻ…
    .accesskey = k
bookmark-tab =
    .label = Đánh dấu thẻ
    .accesskey = B
reopen-in-container =
    .label = Mở trong Ngăn chứa
    .accesskey = e
move-to-start =
    .label = Di chuyển lên đầu
    .accesskey = S
move-to-end =
    .label = Di chuyển xuống cuối
    .accesskey = E
move-to-new-window =
    .label = Di chuyển sang cửa sổ mới
    .accesskey = W
tab-context-close-multiple-tabs =
    .label = Đóng nhiều thẻ
    .accesskey = M

## Variables:
##  $tabCount (Number): the number of tabs that are affected by the action.

tab-context-undo-close-tabs =
    .label =
        { $tabCount ->
            [1] Mở lại thẻ vừa đóng
           *[other] Mở lại các thẻ vừa đóng
        }
    .accesskey = U
close-tab =
    .label = Đóng thẻ
    .accesskey = c
close-tabs =
    .label = Đóng các thẻ
    .accesskey = S
move-tabs =
    .label = Di chuyển các thẻ
    .accesskey = v
move-tab =
    .label = Di chuyển thẻ
    .accesskey = v
tab-context-close-tabs =
    .label =
        { $tabCount ->
            [1] Đóng thẻ
           *[other] Đóng các thẻ
        }
    .accesskey = C
tab-context-move-tabs =
    .label =
        { $tabCount ->
            [1] Di chuyển thẻ
           *[other] Di chuyển các thẻ
        }
    .accesskey = v
