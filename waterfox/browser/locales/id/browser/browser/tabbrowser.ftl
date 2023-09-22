# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

tabbrowser-empty-tab-title = Tab Baru
tabbrowser-empty-private-tab-title = Tab Pribadi Baru

tabbrowser-menuitem-close-tab =
    .label = Tutup Tab
tabbrowser-menuitem-close =
    .label = Tutup

# Displayed as a tooltip on container tabs
# Variables:
#   $title (String): the title of the current tab.
#   $containerName (String): the name of the current container.
tabbrowser-container-tab-title = { $title } - { $containerName }

# Variables:
#   $tabCount (Number): The number of tabs that will be closed.
tabbrowser-close-tabs-tooltip =
    .label = Tutup { $tabCount } tab

## Tooltips for tab audio control
## Variables:
##   $tabCount (Number): The number of tabs that will be affected.

# Variables:
#   $shortcut (String): The keyboard shortcut for "Mute tab".
tabbrowser-mute-tab-audio-tooltip =
    .label = Bisukan { $tabCount } tab ({ $shortcut })
# Variables:
#   $shortcut (String): The keyboard shortcut for "Unmute tab".
tabbrowser-unmute-tab-audio-tooltip =
    .label = Suarakan { $tabCount } tab ({ $shortcut })
tabbrowser-mute-tab-audio-background-tooltip =
    .label = Bisukan { $tabCount } tab
tabbrowser-unmute-tab-audio-background-tooltip =
    .label = Suarakan { $tabCount } tab
tabbrowser-unblock-tab-audio-tooltip =
    .label = Putar { $tabCount } tab

## Confirmation dialog when closing a window with more than one tab open,
## or when quitting when only one window is open.

# The singular form is not considered since this string is used only for multiple tabs.
# Variables:
#   $tabCount (Number): The number of tabs that will be closed.
tabbrowser-confirm-close-tabs-title = Tutup { $tabCount } tab?
tabbrowser-confirm-close-tabs-button = Tutup Tab
tabbrowser-confirm-close-tabs-checkbox = Konfirmasi sebelum menutup banyak tab

## Confirmation dialog when quitting using the menu and multiple windows are open.

# The forms for 0 or 1 items are not considered since this string is used only for
# multiple windows.
# Variables:
#   $windowCount (Number): The number of windows that will be closed.
tabbrowser-confirm-close-windows-title = Tutup { $windowCount } jendela?
tabbrowser-confirm-close-windows-button =
    { PLATFORM() ->
        [windows] Tutup dan keluar
       *[other] Tutup dan keluar
    }

## Confirmation dialog when quitting using the keyboard shortcut (Ctrl/Cmd+Q)
## Windows does not show a prompt on quit when using the keyboard shortcut by default.

tabbrowser-confirm-close-tabs-with-key-title = Tutup jendela dan keluar dari { -brand-short-name }?
tabbrowser-confirm-close-tabs-with-key-button = Keluar dari { -brand-short-name }
# Variables:
#   $quitKey (String): the text of the keyboard shortcut for quitting.
tabbrowser-confirm-close-tabs-with-key-checkbox = Konfirmasi sebelum keluar dari { $quitKey }

## Confirmation dialog when opening multiple tabs simultaneously

tabbrowser-confirm-open-multiple-tabs-title = Konfirmasi pembukaan
# Variables:
#   $tabCount (Number): The number of tabs that will be opened.
tabbrowser-confirm-open-multiple-tabs-message =
    { $tabCount ->
       *[other] Anda akan membuka { $tabCount } tab. Ini mungkin akan melambatkan { -brand-short-name } saat laman dimuat. Yakin ingin dilanjutkan?
    }
tabbrowser-confirm-open-multiple-tabs-button = Buka tab
tabbrowser-confirm-open-multiple-tabs-checkbox = Ingatkan jika membuka banyak tab sekaligus akan melambatkan { -brand-short-name }

## Confirmation dialog for enabling caret browsing

tabbrowser-confirm-caretbrowsing-title = Jelajah Caret
tabbrowser-confirm-caretbrowsing-message = Tekan F7 untuk mengaktifkan/menonaktifkan Penjelajahan Caret. Fitur ini menempatkan kursor dalam laman web sehingga Anda bisa memilih teks dengan papan ketik. Ingin mengaktifkan Penjelajahan Caret?
tabbrowser-confirm-caretbrowsing-checkbox = Jangan tampilkan kotak dialog ini lagi.

##

# Variables:
#   $domain (String): URL of the page that is trying to steal focus.
tabbrowser-allow-dialogs-to-get-focus =
    .label = Izinkan notifikasi seperti ini dari { $domain } untuk membawa Anda membuka tab mereka

tabbrowser-customizemode-tab-title = Ubahsuai { -brand-short-name }

## Context menu buttons, of which only one will be visible at a time

tabbrowser-context-mute-tab =
    .label = Bisukan Tab
    .accesskey = B
tabbrowser-context-unmute-tab =
    .label = Suarakan Tab
    .accesskey = S
# The accesskey should match the accesskey for tabbrowser-context-mute-tab
tabbrowser-context-mute-selected-tabs =
    .label = Senyapkan Tab
    .accesskey = S
# The accesskey should match the accesskey for tabbrowser-context-unmute-tab
tabbrowser-context-unmute-selected-tabs =
    .label = Bunyikan Tab
    .accesskey = S

## Ctrl-Tab dialog

# Variables:
#   $tabCount (Number): The number of tabs in the current browser window. It will always be 2 at least.
tabbrowser-ctrl-tab-list-all-tabs =
    .label = Tampilkan Daftar Semua { $tabCount } Tab

## Tab manager menu buttons

