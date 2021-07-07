# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Thêm ngăn chứa mới
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = Tùy chọn ngăn chứa { $name }
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update-settings =
    .title = Cài đặt ngăn chứa { $name }
    .style = width: 45em
containers-window-close =
    .key = w
# This is a term to store style to be applied
# on the three labels in the containers add/edit dialog:
#   - name
#   - icon
#   - color
#
# Using this term and referencing it in the `.style` attribute
# of the three messages ensures that all three labels
# will be aligned correctly.
-containers-labels-style = min-width: 4rem
containers-name-label = Tên
    .accesskey = N
    .style = { -containers-labels-style }
containers-name-text =
    .placeholder = Nhập tên vùng chứa
containers-icon-label = Biểu tượng
    .accesskey = I
    .style = { -containers-labels-style }
containers-color-label = Màu
    .accesskey = o
    .style = { -containers-labels-style }
containers-button-done =
    .label = Xong
    .accesskey = X
containers-dialog =
    .buttonlabelaccept = Xong
    .buttonaccesskeyaccept = X
containers-color-blue =
    .label = Xanh lam
containers-color-turquoise =
    .label = Ngọc lam
containers-color-green =
    .label = Xanh lục
containers-color-yellow =
    .label = Vàng
containers-color-orange =
    .label = Da cam
containers-color-red =
    .label = Đỏ
containers-color-pink =
    .label = Hồng
containers-color-purple =
    .label = Tím
containers-color-toolbar =
    .label = Thanh công cụ phù hợp
containers-icon-fence =
    .label = Hàng rào
containers-icon-fingerprint =
    .label = Dấu vết (Fingerprintng)
containers-icon-briefcase =
    .label = Cặp tài liệu
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Ký hiệu đô la
containers-icon-cart =
    .label = Giỏ hàng
containers-icon-circle =
    .label = Chấm
containers-icon-vacation =
    .label = Nghỉ phép
containers-icon-gift =
    .label = Quà tặng
containers-icon-food =
    .label = Thực phẩm
containers-icon-fruit =
    .label = Trái cây
containers-icon-pet =
    .label = Vật nuôi
containers-icon-tree =
    .label = Cây
containers-icon-chill =
    .label = Khuôn
