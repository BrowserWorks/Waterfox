# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

tabbrowser-empty-tab-title = แท็บใหม่
tabbrowser-empty-private-tab-title = แท็บส่วนตัวใหม่

tabbrowser-menuitem-close-tab =
    .label = ปิดแท็บ
tabbrowser-menuitem-close =
    .label = ปิด

# Displayed as a tooltip on container tabs
# Variables:
#   $title (String): the title of the current tab.
#   $containerName (String): the name of the current container.
tabbrowser-container-tab-title = { $title } - { $containerName }

# Variables:
#   $tabCount (Number): The number of tabs that will be closed.
tabbrowser-close-tabs-tooltip =
    .label = ปิด { $tabCount } แท็บ

## Tooltips for tab audio control
## Variables:
##   $tabCount (Number): The number of tabs that will be affected.

# Variables:
#   $shortcut (String): The keyboard shortcut for "Mute tab".
tabbrowser-mute-tab-audio-tooltip =
    .label = ปิดเสียง { $tabCount } แท็บ ({ $shortcut })
# Variables:
#   $shortcut (String): The keyboard shortcut for "Unmute tab".
tabbrowser-unmute-tab-audio-tooltip =
    .label = เปิดเสียง { $tabCount } แท็บ ({ $shortcut })
tabbrowser-mute-tab-audio-background-tooltip =
    .label = ปิดเสียง { $tabCount } แท็บ
tabbrowser-unmute-tab-audio-background-tooltip =
    .label = เปิดเสียง { $tabCount } แท็บ
tabbrowser-unblock-tab-audio-tooltip =
    .label = เล่น { $tabCount } แท็บ

## Confirmation dialog when closing a window with more than one tab open,
## or when quitting when only one window is open.

# The singular form is not considered since this string is used only for multiple tabs.
# Variables:
#   $tabCount (Number): The number of tabs that will be closed.
tabbrowser-confirm-close-tabs-title = ต้องการปิด { $tabCount } แท็บหรือไม่?
tabbrowser-confirm-close-tabs-button = ปิดแท็บ
tabbrowser-confirm-close-tabs-checkbox = ยืนยันก่อนปิดหลายแท็บ

## Confirmation dialog when quitting using the menu and multiple windows are open.

# The forms for 0 or 1 items are not considered since this string is used only for
# multiple windows.
# Variables:
#   $windowCount (Number): The number of windows that will be closed.
tabbrowser-confirm-close-windows-title = ต้องการปิด { $windowCount } หน้าต่างหรือไม่?
tabbrowser-confirm-close-windows-button =
    { PLATFORM() ->
        [windows] ปิดแล้วออก
       *[other] ปิดแล้วออก
    }

## Confirmation dialog when quitting using the keyboard shortcut (Ctrl/Cmd+Q)
## Windows does not show a prompt on quit when using the keyboard shortcut by default.

tabbrowser-confirm-close-tabs-with-key-title = ต้องการปิดหน้าต่างแล้วออกจาก { -brand-short-name } หรือไม่?
tabbrowser-confirm-close-tabs-with-key-button = ออกจาก { -brand-short-name }
# Variables:
#   $quitKey (String): the text of the keyboard shortcut for quitting.
tabbrowser-confirm-close-tabs-with-key-checkbox = ยืนยันก่อนออกด้วย { $quitKey }

## Confirmation dialog when opening multiple tabs simultaneously

tabbrowser-confirm-open-multiple-tabs-title = ยืนยันการเปิด
# Variables:
#   $tabCount (Number): The number of tabs that will be opened.
tabbrowser-confirm-open-multiple-tabs-message =
    { $tabCount ->
       *[other] คุณกำลังจะเปิด { $tabCount } แท็บ  ซึ่งอาจทำให้ { -brand-short-name } ช้าลงขณะที่หน้ากำลังโหลด  คุณแน่ใจหรือไม่ว่าต้องการดำเนินการต่อ?
    }
tabbrowser-confirm-open-multiple-tabs-button = เปิดแท็บ
tabbrowser-confirm-open-multiple-tabs-checkbox = เตือนฉันเมื่อการเปิดหลายแท็บอาจทำให้ { -brand-short-name } ช้าลง

## Confirmation dialog for enabling caret browsing

tabbrowser-confirm-caretbrowsing-title = การเลื่อนดูด้วยแป้นพิมพ์
tabbrowser-confirm-caretbrowsing-message = กด F7 เพื่อเปิดปิดการเลื่อนดูโดยแป้นพิมพ์ ในการเลื่อนดูแบบนี้ จะมีเคอร์เซอร์ที่เคลื่อนที่ได้อยู่บนหน้าเว็บทำให้คุณเลือกข้อความด้วยแป้นพิมพ์ได้ คุณต้องการเปิดการเลื่อนดูโดยแป้นพิมพ์หรือไม่?
tabbrowser-confirm-caretbrowsing-checkbox = ไม่ต้องแสดงกล่องโต้ตอบนี้ให้ฉันเห็นอีก

##

# Variables:
#   $domain (String): URL of the page that is trying to steal focus.
tabbrowser-allow-dialogs-to-get-focus =
    .label = อนุญาตให้การแจ้งเตือนเช่นนี้จาก { $domain } นำคุณไปที่แท็บของไซต์

tabbrowser-customizemode-tab-title = ปรับแต่ง { -brand-short-name }

## Context menu buttons, of which only one will be visible at a time

tabbrowser-context-mute-tab =
    .label = ปิดเสียงแท็บ
    .accesskey = ส
tabbrowser-context-unmute-tab =
    .label = เปิดเสียงแท็บ
    .accesskey = ส
# The accesskey should match the accesskey for tabbrowser-context-mute-tab
tabbrowser-context-mute-selected-tabs =
    .label = ปิดเสียงแท็บ
    .accesskey = ส
# The accesskey should match the accesskey for tabbrowser-context-unmute-tab
tabbrowser-context-unmute-selected-tabs =
    .label = เปิดเสียงแท็บ
    .accesskey = ส

# This string is used as an additional tooltip and accessibility description for tabs playing audio
tabbrowser-tab-audio-playing-description = กำลังเล่นเสียง

## Ctrl-Tab dialog

# Variables:
#   $tabCount (Number): The number of tabs in the current browser window. It will always be 2 at least.
tabbrowser-ctrl-tab-list-all-tabs =
    .label = แสดงรายการ { $tabCount } แท็บทั้งหมด

## Tab manager menu buttons

tabbrowser-manager-mute-tab =
    .tooltiptext = ปิดเสียงแท็บ
tabbrowser-manager-unmute-tab =
    .tooltiptext = เปิดเสียงแท็บ
tabbrowser-manager-close-tab =
    .tooltiptext = ปิดแท็บ
