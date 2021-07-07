# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = Tích hợp Hệ thống
system-integration-dialog =
    .buttonlabelaccept = Đặt làm mặc định
    .buttonlabelcancel = Bỏ qua tích hợp
    .buttonlabelcancel2 = Hủy bỏ
default-client-intro = Dùng { -brand-short-name } làm chương trình mặc định cho:
unset-default-tooltip = Không thể bỏ đặt { -brand-short-name } là ứng dụng khách mặc định trong { -brand-short-name }. Để đặt ứng dụng khác thành mặc định, bạn phải sử dụng hộp thoại 'Đặt làm mặc định'.
checkbox-email-label =
    .label = Thư điện tử (E-Mail)
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = Nhóm tin
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = Nguồn cấp
    .tooltiptext = { unset-default-tooltip }
checkbox-calendar-label =
    .label = Lịch
    .tooltiptext = { unset-default-tooltip }
# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
system-search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Tìm kiếm Windows
       *[other] { "" }
    }
system-search-integration-label =
    .label = Cho phép { system-search-engine-name } tìm kiếm thư
    .accesskey = t
check-on-startup-label =
    .label = Luôn thực hiện việc kiểm tra này mỗi khi khởi động { -brand-short-name }
    .accesskey = L
