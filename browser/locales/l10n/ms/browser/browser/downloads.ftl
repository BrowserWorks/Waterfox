# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = Muat turun
downloads-panel =
    .aria-label = Muat turun

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
    .label = Sambung
    .accesskey = m
downloads-cmd-cancel =
    .tooltiptext = Batal
downloads-cmd-cancel-panel =
    .aria-label = Batal

# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = Buka Kandungan Folder
    .accesskey = F
  
# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = Papar Dalam Finder
    .accesskey = F

downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] Papar Dalam Finder
           *[other] Buka Kandungan Folder
        }

downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] Papar Dalam Finder
           *[other] Buka Kandungan Folder
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] Papar Dalam Finder
           *[other] Buka Kandungan Folder
        }

downloads-cmd-show-downloads =
    .label = Papar Folder Muat turun
downloads-cmd-retry =
    .tooltiptext = Cuba lagi
downloads-cmd-retry-panel =
    .aria-label = Cuba lagi
downloads-cmd-go-to-download-page =
    .label = Pergi Ke Halaman Muat Turun
    .accesskey = P
downloads-cmd-copy-download-link =
    .label = Salin Pautan Muat Turun
    .accesskey = P
downloads-cmd-remove-from-history =
    .label = Buang Daripada Sejarah
    .accesskey = u
downloads-cmd-clear-list =
    .label = Buang Panel Previu
    .accesskey = a
downloads-cmd-clear-downloads =
    .label = Buang Muat turun
    .accesskey = B

# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = Izinkan Muat turun
    .accesskey = a

# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = Alih keluar Fail

downloads-cmd-remove-file-panel =
    .aria-label = Alih keluar Fail

# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = Buang Fail atau Izinkan Muat turun

downloads-cmd-choose-unblock-panel =
    .aria-label = Buang Fail atau Izinkan Muat turun

# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = Buka atau Buang Fail

downloads-cmd-choose-open-panel =
    .aria-label = Buka atau Buang Fail

# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = Papar maklumat selanjutnya

# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = Buka Fail

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = Muat turun Sekali lagi

# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = Batal Muat Turun

# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = Papar Semua Muat turun
    .accesskey = S

# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = Butiran Muat turun

downloads-clear-downloads-button =
    .label = Buang Muat turun
    .tooltiptext = Hapuskan yang telah selesai, batal dan gagalkan muat turun

# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = Tiada muat turun.

# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = Tiada muat turun untuk sesi ini.
