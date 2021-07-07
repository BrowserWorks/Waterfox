# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Strings used in about:unloads, allowing users to manage the "tab unloading"
### feature.

about-unloads-page-title = Quản lý dỡ thẻ
about-unloads-intro-1 =
    { -brand-short-name } có tính năng tự động dỡ thẻ
    để ngăn ứng dụng bị treo do không đủ bộ nhớ
    khi bộ nhớ khả dụng của hệ thống sắp hết. Thẻ tiếp theo sẽ dỡ xuống
    được chọn dựa trên nhiều thuộc tính. Trang này hiển thị cách
    { -brand-short-name } đặt ưu tiên các thẻ và thẻ nào sẽ được dỡ xuống
    khi lệnh dỡ thẻ được kích hoạt.
about-unloads-intro-2 =
    Các thẻ hiện có được hiển thị trong bảng bên dưới theo cùng thứ tự được sử dụng
    bởi { -brand-short-name } để chọn thẻ tiếp theo để dỡ xuống. ID tiến trình sẽ
    hiển thị dưới dạng <strong>in đậm</strong> khi chúng đang lưu trữ frame
    trên cùng của thẻ, và <em>in nghiêng</em> khi quy trình được chia sẻ giữa
    các thẻ. Bạn có thể kích hoạt dỡ thẻ theo cách thủ công bằng cách nhấp vào nút
    <em>Dỡ</em> bên dưới.
about-unloads-intro =
    { -brand-short-name } có tính năng tự động dỡ thẻ
    để ngăn ứng dụng bị treo do không đủ bộ nhớ
    khi bộ nhớ khả dụng của hệ thống sắp hết. Thẻ tiếp theo sẽ dỡ xuống
    được chọn dựa trên nhiều thuộc tính. Trang này hiển thị cách
    { -brand-short-name } đặt ưu tiên các thẻ và thẻ nào sẽ được dỡ xuống
    khi lệnh dỡ thẻ được kích hoạt. Bạn có thể kích hoạt dỡ thẻ theo cách
    thủ công bằng cách nhấp vào nút <em>Dỡ</em>.
# The link points to a Waterfox documentation page, only available in English,
# with title "Tab Unloading"
about-unloads-learn-more =
    Xem <a data-l10n-name="doc-link">Quản lý dỡ thẻ</a> để tìm hiểu thêm
    về tính năng và trang này.
about-unloads-last-updated = Cập nhật gần đây nhất: { DATETIME($date, year: "numeric", month: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric", hour12: "false") }
about-unloads-button-unload = Dỡ
    .title = Dỡ thẻ có mức độ ưu tiên cao nhất
about-unloads-no-unloadable-tab = Không có thẻ nào có thể dỡ xuống.
about-unloads-column-priority = Ưu tiên
about-unloads-column-host = Máy chủ
about-unloads-column-last-accessed = Lần truy cập cuối
about-unloads-column-weight = Base Weight
    .title = Các thẻ đầu tiên được sắp xếp theo giá trị này, bắt nguồn từ một số thuộc tính đặc biệt như phát âm thanh, WebRTC, v.v...
about-unloads-column-sortweight = Secondary Weight
    .title = Nếu có, các thẻ được sắp xếp theo giá trị này sau khi được sắp xếp theo base weight. Giá trị bắt nguồn từ việc sử dụng bộ nhớ của thẻ và số lượng các quá trình.
about-unloads-column-memory = Bộ nhớ
    .title = Mức sử dụng bộ nhớ ước tính của thẻ
about-unloads-column-processes = ID tiến trình
    .title = ID của các tiến trình lưu trữ nội dung của thẻ
about-unloads-last-accessed = { DATETIME($date, year: "numeric", month: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric", hour12: "false") }
about-unloads-memory-in-mb = { NUMBER($mem, maxFractionalUnits: 2) } MB
about-unloads-memory-in-mb-tooltip =
    .title = { NUMBER($mem, maxFractionalUnits: 2) } MB
