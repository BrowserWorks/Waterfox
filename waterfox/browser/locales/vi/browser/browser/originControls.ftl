# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These strings appear in Origin Controls for Extensions.  Currently,
## they are visible in the context menu for extension toolbar buttons,
## and are used to inform the user how the extension can access their
## data for the current website, and allow them to control it.

origin-controls-no-access =
    .label = Tiện ích mở rộng không thể đọc và thay đổi dữ liệu
origin-controls-quarantined =
    .label = Tiện ích không được phép đọc và thay đổi dữ liệu
origin-controls-quarantined-status =
    .label = Tiện ích mở rộng không được phép trên trang bị hạn chế
origin-controls-quarantined-allow =
    .label = Cho phép trên trang bị hạn chế
origin-controls-options =
    .label = Tiện ích mở rộng có thể đọc và thay đổi dữ liệu:
origin-controls-option-all-domains =
    .label = Trên tất cả các trang web
origin-controls-option-when-clicked =
    .label = Chỉ khi được nhấp
# This string denotes an option that grants the extension access to
# the current site whenever they visit it.
# Variables:
#   $domain (String) - The domain for which the access is granted.
origin-controls-option-always-on =
    .label = Luôn cho phép trên { $domain }

## These strings are used to map Origin Controls states to user-friendly
## messages. They currently appear in the unified extensions panel.

origin-controls-state-no-access = Không thể đọc và thay đổi dữ liệu trên trang này
origin-controls-state-quarantined = Không được phép bởi { -vendor-short-name } trên trang này
origin-controls-state-always-on = Luôn luôn đọc và thay đổi dữ liệu trên trang này
origin-controls-state-when-clicked = Cần quyền để đọc và thay đổi dữ liệu
origin-controls-state-hover-run-visit-only = Chỉ chạy cho lần truy cập này
origin-controls-state-runnable-hover-open = Mở tiện ích
origin-controls-state-runnable-hover-run = Chạy tiện ích
origin-controls-state-temporary-access = Có thể đọc và thay đổi dữ liệu trên trang này

## Extension's toolbar button.
## Variables:
##   $extensionTitle (String) - Extension name or title message.

origin-controls-toolbar-button =
    .label = { $extensionTitle }
    .tooltiptext = { $extensionTitle }
# Extension's toolbar button when permission is needed.
# Note that the new line is intentionally part of the tooltip.
origin-controls-toolbar-button-permission-needed =
    .label = { $extensionTitle }
    .tooltiptext =
        { $extensionTitle }
        Cần yêu cầu quyền hạn
# Extension's toolbar button when quarantined.
# Note that the new line is intentionally part of the tooltip.
origin-controls-toolbar-button-quarantined =
    .label = { $extensionTitle }
    .tooltiptext =
        { $extensionTitle }
        Không được phép bởi { -vendor-short-name } trên trang này
