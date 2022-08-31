# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

blocklist-window =
    .title = Danh sách chặn
    .style = width: 55em

blocklist-description = Chọn danh sách { -brand-short-name } sử dụng để chặn trình theo dõi trực tuyến. Danh sách được cung cấp bởi <a data-l10n-name="disconnect-link" title="Disconnect">Disconnect</a>.
blocklist-close-key =
    .key = w

blocklist-treehead-list =
    .label = Danh sách

blocklist-dialog =
    .buttonlabelaccept = Lưu thay đổi
    .buttonaccesskeyaccept = L


# This template constructs the name of the block list in the block lists dialog.
# It combines the list name and description.
# e.g. "Standard (Recommended). This list does a pretty good job."
#
# Variables:
#   $listName {string, "Standard (Recommended)."} - List name.
#   $description {string, "This list does a pretty good job."} - Description of the list.
blocklist-item-list-template = { $listName } { $description }

blocklist-item-moz-std-listName = Danh sách cấp 1 (Khuyến nghị).
blocklist-item-moz-std-description = Cho phép một số trình theo dõi để trang web ít bị hỏng hơn.
blocklist-item-moz-full-listName = Danh sách cấp 2.
blocklist-item-moz-full-description = Chặn tất cả các trình theo dõi được phát hiện. Một số trang web hoặc nội dung có thể không hoạt động đúng cách.
