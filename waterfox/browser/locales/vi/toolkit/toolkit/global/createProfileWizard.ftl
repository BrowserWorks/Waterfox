# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Trình tạo mới hồ sơ
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Giới thiệu
       *[other] Chào mừng đến với { create-profile-window.title }
    }

profile-creation-explanation-1 = { -brand-short-name } lưu các thông tin thiết lập và tùy chọn của bạn trong hồ sơ cá nhân.

profile-creation-explanation-2 = Nếu dùng chung { -brand-short-name } với người khác, bạn có thể dùng hồ sơ để lưu các thông tin riêng cho từng người. Để làm việc này, mỗi người nên tạo một hồ sơ riêng cho mình.

profile-creation-explanation-3 = Nếu là người duy nhất dùng { -brand-short-name }, bạn phải có ít nhất một hồ sơ. Nếu muốn, bạn có thể tạo nhiều hồ sơ cho chính mình để lưu các thiết lập và tùy chọn khác nhau. Ví dụ, có thể bạn muốn có các hồ sơ riêng rẽ cho công việc và cá nhân.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Để bắt đầu tạo hồ sơ, nhấn Tiếp tục.
       *[other] Để bắt đầu tạo hồ sơ, nhấn Tiến.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Kết thúc
       *[other] Đang hoàn tất { create-profile-window.title }
    }

profile-creation-intro = Nếu tạo vài hồ sơ, bạn có thể tách biệt chúng bằng cách đặt tên. Có thể dùng tên được cung cấp ở đây hoặc tự đặt theo ý bạn.

profile-prompt = Nhập tên hồ sơ mới:
    .accesskey = N

profile-default-name =
    .value = Default User

profile-directory-explanation = Thiết lập, tùy chọn và những dữ liệu liên quan đến người dùng sẽ được lưu tại:

create-profile-choose-folder =
    .label = Chọn thư mục…
    .accesskey = C

create-profile-use-default =
    .label = Sử dụng thư mục mặc định
    .accesskey = S
