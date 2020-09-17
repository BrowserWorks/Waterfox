# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = İndirilenler
downloads-panel =
    .aria-label = İndirilenler

##

# The style attribute has the width of the Downloads Panel expressed using
# a CSS unit. The longest labels that should fit are usually those of
# in-progress and blocked downloads.
downloads-panel-list =
    .style = width: 70ch

downloads-cmd-pause =
    .label = Duraklat
    .accesskey = r
downloads-cmd-resume =
    .label = Devam et
    .accesskey = m
downloads-cmd-cancel =
    .tooltiptext = İptal
downloads-cmd-cancel-panel =
    .aria-label = İptal

# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = Bulunduğu klasörü aç
    .accesskey = d
  
# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = Finder’da göster
    .accesskey = F

downloads-cmd-use-system-default =
    .label = Sistem görüntüleyicisinde aç
    .accesskey = S

downloads-cmd-always-use-system-default =
    .label = Her zaman sistem görüntüleyicisinde aç
    .accesskey = H

downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] Finder’da göster
           *[other] Bulunduğu klasörü aç
        }

downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] Finder’da göster
           *[other] Bulunduğu klasörü aç
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] Finder’da göster
           *[other] Bulunduğu klasörü aç
        }

downloads-cmd-show-downloads =
    .label = İndirilenler klasörünü göster
downloads-cmd-retry =
    .tooltiptext = Yeniden dene
downloads-cmd-retry-panel =
    .aria-label = Yeniden dene
downloads-cmd-go-to-download-page =
    .label = İndirme sayfasına git
    .accesskey = s
downloads-cmd-copy-download-link =
    .label = İndirme bağlantısını kopyala
    .accesskey = b
downloads-cmd-remove-from-history =
    .label = Geçmişten kaldır
    .accesskey = e
downloads-cmd-clear-list =
    .label = Ön izleme panelini temizle
    .accesskey = a
downloads-cmd-clear-downloads =
    .label = İndirmeleri temizle
    .accesskey = t

# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = İndirmeye izin ver
    .accesskey = z

# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = Dosyayı sil

downloads-cmd-remove-file-panel =
    .aria-label = Dosyayı sil

# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = Dosyayı sil ve indirmeye izin ver

downloads-cmd-choose-unblock-panel =
    .aria-label = Dosyayı sil ve indirmeye izin ver

# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = Dosyayı aç veya sil

downloads-cmd-choose-open-panel =
    .aria-label = Dosyayı aç veya sil

# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = Daha fazla bilgi ver

# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = Dosyayı aç

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = İndirmeyi yeniden dene

# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = İndirmekten vazgeç

# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = Tüm indirmeleri göster
    .accesskey = T

# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = İndirme ayrıntıları

downloads-clear-downloads-button =
    .label = İndirmeleri temizle
    .tooltiptext = Tamamlanan, iptal edilen ve başarısız olan indirmeleri temizler

# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = İndirme yok.

# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = Bu oturumda indirme yapılmadı.
