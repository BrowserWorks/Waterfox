# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = Unduhan
downloads-panel =
    .aria-label = Unduhan

##

# The style attribute has the width of the Downloads Panel expressed using
# a CSS unit. The longest labels that should fit are usually those of
# in-progress and blocked downloads.
downloads-panel-list =
    .style = width: 70ch

downloads-cmd-pause =
    .label = Jeda
    .accesskey = J
downloads-cmd-resume =
    .label = Lanjutkan
    .accesskey = L
downloads-cmd-cancel =
    .tooltiptext = Batalkan
downloads-cmd-cancel-panel =
    .aria-label = Batalkan

# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = Buka Foldernya
    .accesskey = F

# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = Tampilkan di Finder
    .accesskey = F

downloads-cmd-use-system-default =
    .label = Buka di Penampil Sistem
    .accesskey = S

downloads-cmd-always-use-system-default =
    .label = Selalu Buka di Penampil Sistem
    .accesskey = S

downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] Tampilkan di Finder
           *[other] Buka Foldernya
        }

downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] Tampilkan di Finder
           *[other] Buka Foldernya
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] Tampilkan di Finder
           *[other] Buka Foldernya
        }

downloads-cmd-show-downloads =
    .label = Tampilkan Folder Unduhan
downloads-cmd-retry =
    .tooltiptext = Coba Lagi
downloads-cmd-retry-panel =
    .aria-label = Coba Lagi
downloads-cmd-go-to-download-page =
    .label = Buka Laman Unduhan
    .accesskey = m
downloads-cmd-copy-download-link =
    .label = Salin Tautan Unduhan
    .accesskey = T
downloads-cmd-remove-from-history =
    .label = Hapus dari Riwayat
    .accesskey = H
downloads-cmd-clear-list =
    .label = Bersihkan Panel Pratinjau
    .accesskey = a
downloads-cmd-clear-downloads =
    .label = Bersihkan Unduhan
    .accesskey = U

# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = Izinkan Unduhan
    .accesskey = I

# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = Hapus Berkas

downloads-cmd-remove-file-panel =
    .aria-label = Hapus Berkas

# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = Hapus Berkas atau Izinkan Unduhan

downloads-cmd-choose-unblock-panel =
    .aria-label = Hapus Berkas atau Izinkan Unduhan

# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = Buka atau Hapus Berkas

downloads-cmd-choose-open-panel =
    .aria-label = Buka atau Hapus Berkas

# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = Tampilkan informasi lebih lanjut

# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = Buka Berkas

## Displayed when the user clicked on a download in process. Indicates that the
## downloading file will be opened after certain amount of time using an app
## available in the system.
## Variables:
##   $hours (number) - Amount of hours left till the file opens.
##   $seconds (number) - Amount of seconds left till the file opens.
##   $minutes (number) - Amount of minutes till the file opens.

##

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = Coba Unduh Lagi

# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = Batalkan Unduhan

# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = Tampilkan Semua Unduhan
    .accesskey = U

# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = Detail Unduhan

downloads-clear-downloads-button =
    .label = Bersihkan Unduhan
    .tooltiptext = Bersihkan semua unduhan yang selesai, dibatalkan, atau gagal

# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = Tidak ada unduhan.

# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = Tidak ada unduhan untuk sesi ini.
