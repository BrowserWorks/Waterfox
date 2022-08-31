# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Strings used for device manager

devmgr =
    .title = Quản lí thiết bị
    .style = width: 67em; height: 32em;

devmgr-devlist =
    .label = Mô-đun và thiết bị bảo mật

devmgr-header-details =
    .label = Chi tiết

devmgr-header-value =
    .label = Giá trị

devmgr-button-login =
    .label = Đăng nhập
    .accesskey = n

devmgr-button-logout =
    .label = Đăng xuất
    .accesskey = O

devmgr-button-changepw =
    .label = Thay đổi mật khẩu
    .accesskey = P

devmgr-button-load =
    .label = Nạp
    .accesskey = p

devmgr-button-unload =
    .label = Không Nạp
    .accesskey = K

devmgr-button-enable-fips =
    .label = Bật FIPS
    .accesskey = F

devmgr-button-disable-fips =
    .label = Tắt FIPS
    .accesskey = F

## Strings used for load device

load-device =
    .title = Tải trình điều khiển thiết bị PKCS#11

load-device-info = Nhập thông tin cho module bạn muốn thêm.

load-device-modname =
    .value = Tên mô-đun
    .accesskey = M

load-device-modname-default =
    .value = Module PKCS#11 Mới

load-device-filename =
    .value = Tên tập tin mô-đun
    .accesskey = f

load-device-browse =
    .label = Duyệt…
    .accesskey = B

## Token Manager

devinfo-status =
    .label = Trạng thái

devinfo-status-disabled =
    .label = Bị Vô Hiệu

devinfo-status-not-present =
    .label = Không Có

devinfo-status-uninitialized =
    .label = Chưa được Nhận diện

devinfo-status-not-logged-in =
    .label = Chưa đăng nhập

devinfo-status-logged-in =
    .label = Đã đăng nhập

devinfo-status-ready =
    .label = Sẵn sàng

devinfo-desc =
    .label = Mô tả

devinfo-man-id =
    .label = Nhà sản xuất

devinfo-hwversion =
    .label = Phiên bản HW
devinfo-fwversion =
    .label = Phiên bản FW

devinfo-modname =
    .label = Mô-đun

devinfo-modpath =
    .label = Đường dẫn

login-failed = Đăng nhập thất bại

devinfo-label =
    .label = Nhãn

devinfo-serialnum =
    .label = Số sê-ri

fips-nonempty-primary-password-required = Chế độ FIPS yêu cầu bạn phải đặt mật khẩu chính cho từng thiết bị bảo mật. Vui lòng đặt mật khẩu trước khi thử bật chế độ FIPS.
unable-to-toggle-fips = Không thể thay đổi chế độ FIPS cho thiết bị bảo mật. Bạn nên thoát và khởi động lại ứng dụng này.
load-pk11-module-file-picker-title = Chọn trình điều khiển thiết bị PKCS#11 để tải

# Load Module Dialog
load-module-help-empty-module-name =
    .value = Tên mô-đun không thể để trống.

# Do not translate 'Root Certs'
load-module-help-root-certs-module-name =
    .value = ‘Root Certs' được dành riêng và không thể được sử dụng làm tên mô-đun.

add-module-failure = Không thể thêm module
del-module-warning = Bạn có chắc muốn xóa module bảo mật này không?
del-module-error = Không thể xóa module
