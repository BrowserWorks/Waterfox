# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

tabbrowser-empty-tab-title = Thẻ mới
tabbrowser-empty-private-tab-title = Thẻ riêng tư mới

tabbrowser-menuitem-close-tab =
    .label = Đóng thẻ
tabbrowser-menuitem-close =
    .label = Đóng

# Displayed as a tooltip on container tabs
# Variables:
#   $title (String): the title of the current tab.
#   $containerName (String): the name of the current container.
tabbrowser-container-tab-title = { $title } - { $containerName }

# Variables:
#   $tabCount (Number): The number of tabs that will be closed.
tabbrowser-close-tabs-tooltip =
    .label = Đóng { $tabCount } thẻ

## Tooltips for tab audio control
## Variables:
##   $tabCount (Number): The number of tabs that will be affected.

# Variables:
#   $shortcut (String): The keyboard shortcut for "Mute tab".
tabbrowser-mute-tab-audio-tooltip =
    .label = Tắt tiếng { $tabCount } thẻ ({ $shortcut })
# Variables:
#   $shortcut (String): The keyboard shortcut for "Unmute tab".
tabbrowser-unmute-tab-audio-tooltip =
    .label = Bật tiếng { $tabCount } thẻ ({ $shortcut })
tabbrowser-mute-tab-audio-background-tooltip =
    .label = Tắt tiếng { $tabCount } thẻ
tabbrowser-unmute-tab-audio-background-tooltip =
    .label = Bật tiếng { $tabCount } thẻ
tabbrowser-unblock-tab-audio-tooltip =
    .label = Phát âm thanh { $tabCount } thẻ

## Confirmation dialog when closing a window with more than one tab open,
## or when quitting when only one window is open.

# The singular form is not considered since this string is used only for multiple tabs.
# Variables:
#   $tabCount (Number): The number of tabs that will be closed.
tabbrowser-confirm-close-tabs-title = Đóng { $tabCount } thẻ?
tabbrowser-confirm-close-tabs-button = Đóng thẻ
tabbrowser-confirm-close-tabs-checkbox = Xác nhận trước khi đóng nhiều thẻ

## Confirmation dialog when quitting using the menu and multiple windows are open.

# The forms for 0 or 1 items are not considered since this string is used only for
# multiple windows.
# Variables:
#   $windowCount (Number): The number of windows that will be closed.
tabbrowser-confirm-close-windows-title = Đóng { $windowCount } cửa sổ?
tabbrowser-confirm-close-windows-button =
    { PLATFORM() ->
        [windows] Đóng và thoát
       *[other] Đóng và thoát
    }

## Confirmation dialog when quitting using the keyboard shortcut (Ctrl/Cmd+Q)
## Windows does not show a prompt on quit when using the keyboard shortcut by default.

tabbrowser-confirm-close-tabs-with-key-title = Đóng cửa sổ và thoát { -brand-short-name }?
tabbrowser-confirm-close-tabs-with-key-button = Thoát { -brand-short-name }
# Variables:
#   $quitKey (String): the text of the keyboard shortcut for quitting.
tabbrowser-confirm-close-tabs-with-key-checkbox = Xác nhận trước khi thoát bằng { $quitKey }

## Confirmation dialog when opening multiple tabs simultaneously

tabbrowser-confirm-open-multiple-tabs-title = Xác nhận mở
# Variables:
#   $tabCount (Number): The number of tabs that will be opened.
tabbrowser-confirm-open-multiple-tabs-message =
    { $tabCount ->
       *[other] Bạn đang chuẩn bị mở { $tabCount } thẻ. Nó sẽ gây chậm { -brand-short-name } khi các trang web đang tải. Bạn có muốn tiếp tục?
    }
tabbrowser-confirm-open-multiple-tabs-button = Mở các thẻ
tabbrowser-confirm-open-multiple-tabs-checkbox = Cảnh báo tôi khi mở nhiều thẻ có thể làm chậm { -brand-short-name }

## Confirmation dialog for enabling caret browsing

tabbrowser-confirm-caretbrowsing-title = Duyệt với con trỏ
tabbrowser-confirm-caretbrowsing-message = Nhấn F7 để bật hoặc tắt chế độ duyệt với con trỏ. Chức năng này đặt một con trỏ có thể di chuyển được trên trang web, cho phép bạn chọn văn bản bằng bàn phím. Bạn có muốn bật chế độ này không?
tabbrowser-confirm-caretbrowsing-checkbox = Không hiện lại hộp thoại này.

##

# Variables:
#   $domain (String): URL of the page that is trying to steal focus.
tabbrowser-allow-dialogs-to-get-focus =
    .label = Cho phép các thông báo như thế này từ { $domain } đưa bạn đến thẻ của họ

tabbrowser-customizemode-tab-title = Tùy biến { -brand-short-name }

## Context menu buttons, of which only one will be visible at a time

tabbrowser-context-mute-tab =
    .label = Tắt tiếng thẻ
    .accesskey = M
tabbrowser-context-unmute-tab =
    .label = Bật tiếng thẻ
    .accesskey = m
# The accesskey should match the accesskey for tabbrowser-context-mute-tab
tabbrowser-context-mute-selected-tabs =
    .label = Tắt tiếng thẻ
    .accesskey = M
# The accesskey should match the accesskey for tabbrowser-context-unmute-tab
tabbrowser-context-unmute-selected-tabs =
    .label = Bỏ tắt tiếng thẻ
    .accesskey = m

# This string is used as an additional tooltip and accessibility description for tabs playing audio
tabbrowser-tab-audio-playing-description = Đang phát âm thanh

## Ctrl-Tab dialog

# Variables:
#   $tabCount (Number): The number of tabs in the current browser window. It will always be 2 at least.
tabbrowser-ctrl-tab-list-all-tabs =
    .label = Hiển thị tất cả { $tabCount } thẻ

## Tab manager menu buttons

tabbrowser-manager-mute-tab =
    .tooltiptext = Tắt tiếng thẻ
tabbrowser-manager-unmute-tab =
    .tooltiptext = Bỏ tắt tiếng thẻ
tabbrowser-manager-close-tab =
    .tooltiptext = Đóng thẻ
