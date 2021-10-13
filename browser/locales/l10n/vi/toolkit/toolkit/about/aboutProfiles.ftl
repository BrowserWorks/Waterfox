# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = Thông tin về hồ sơ
profiles-subtitle = Trang này giúp bạn quản lý hồ sơ của bạn. Mỗi hồ sơ là một thế giới riêng biệt chứa lịch sử, dấu trang, cài đặt và tiện ích.
profiles-create = Tạo hồ sơ mới
profiles-restart-title = Khởi động lại
profiles-restart-in-safe-mode = Khởi động lại và vô hiệu hóa các Tiện ích…
profiles-restart-normal = Khởi động lại bình thường…
profiles-conflict = Một bản sao khác của { -brand-product-name } đã thực hiện các thay đổi đối với hồ sơ. Bạn phải khởi động lại { -brand-short-name } trước khi thực hiện nhiều thay đổi.
profiles-flush-fail-title = Các thay đổi chưa được lưu
profiles-flush-conflict = { profiles-conflict }
profiles-flush-failed = Một lỗi không mong muốn đã khiến các thay đổi của bạn không được lưu.
profiles-flush-restart-button = Khởi động lại { -brand-short-name }

# Variables:
#   $name (String) - Name of the profile
profiles-name = Hồ sơ: { $name }
profiles-is-default = Hồ sơ mặc định
profiles-rootdir = Thư mục gốc

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = Thư mục nội bộ
profiles-current-profile = Hồ sơ này đang được sử dụng nên nó không thể bị xóa.
profiles-in-use-profile = Hồ sơ này đang được sử dụng trong một ứng dụng khác và nó không thể bị xóa.

profiles-rename = Đổi tên
profiles-remove = Xóa
profiles-set-as-default = Đặt làm hồ sơ mặc định
profiles-launch-profile = Bắt đầu hồ sơ ở trình duyệt mới

profiles-cannot-set-as-default-title = Không thể đặt mặc định
profiles-cannot-set-as-default-message = Không thể thay đổi hồ sơ mặc định cho { -brand-short-name }.

profiles-yes = có
profiles-no = không

profiles-rename-profile-title = Đổi tên hồ sơ
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = Đổi tên hồ sơ { $name }

profiles-invalid-profile-name-title = Tên hồ sơ không hợp lệ
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = Không được phép đặt tên hồ sơ là “{ $name }”.

profiles-delete-profile-title = Xóa hồ sơ
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    Xóa một hồ sơ cũng sẽ gỡ bỏ nó ra khỏi danh sách các hồ sơ hiện tại và không thể hoàn tác được.
    Bạn có thể chọn xóa các tập tin dữ liệu của hồ sơ, bao gồm thiết lập, chứng chỉ và các dữ liệu người dùng khác. Tùy chọn này sẽ xóa thư mục “{ $dir }” và không thể hoàn tác được.
    Bạn có muốn xóa các tập tin dữ liệu của hồ sơ không?
profiles-delete-files = Xóa các tập tin
profiles-dont-delete-files = Không xóa các tập tin

profiles-delete-profile-failed-title = Lỗi
profiles-delete-profile-failed-message = Đã xảy ra lỗi khi cố gắng xóa hồ sơ này.


profiles-opendir =
    { PLATFORM() ->
        [macos] Hiển thị trong Finder
        [windows] Mở thư mục
       *[other] Mở thư mục
    }
