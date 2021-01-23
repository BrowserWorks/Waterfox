# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] Tarixçəni göstərmək üçün aşağı çəkin
           *[other] Tarixçəni göstərmək üçün sağ klikləyin və ya aşağı çəkin
        }

## Back

main-context-menu-back =
    .tooltiptext = Əvvəlki səhifəyə qayıt
    .aria-label = Geri
    .accesskey = G

navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }

toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = Sonrakı səhifəyə keç
    .aria-label = İrəli
    .accesskey = F

navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }

toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = Yenilə
    .accesskey = R

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = Dayan
    .accesskey = S

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = Fərqli saxla…
    .accesskey = P

toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = Bu Səhifəni Əlfəcinlə
    .accesskey = m
    .tooltiptext = Bu səhifəni əlfəcinlə

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = Bu Səhifəni Əlfəcinlə
    .accesskey = m
    .tooltiptext = Bu səhifəni əlfəcinlə ({ $shortcut })

main-context-menu-bookmark-change =
    .aria-label = Bu əlfəcini düzəlt
    .accesskey = m
    .tooltiptext = Bu əlfəcini redaktə et

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = Bu əlfəcini düzəlt
    .accesskey = m
    .tooltiptext = Bu əlfəcini redaktə et ({ $shortcut })

main-context-menu-open-link =
    .label = Keçidi Aç
    .accesskey = A

main-context-menu-open-link-new-tab =
    .label = Keçidi Yeni Vərəqdə Aç
    .accesskey = V

main-context-menu-open-link-container-tab =
    .label = Keçidi yeni konteyner vərəqində aç
    .accesskey = z

main-context-menu-open-link-new-window =
    .label = Keçidi Yeni Pəncərədə Aç
    .accesskey = P

main-context-menu-open-link-new-private-window =
    .label = Keçidi Yeni Məxfi Pəncərədə Aç
    .accesskey = M

main-context-menu-bookmark-this-link =
    .label = Bu Keçidi Əlfəcinlə
    .accesskey = K

main-context-menu-save-link =
    .label = Bağlantını fərqli saxla…
    .accesskey = f

main-context-menu-save-link-to-pocket =
    .label = Keçidi { -pocket-brand-name }-ə Saxla
    .accesskey = o

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = E-poçt ünvanını köçür
    .accesskey = E

main-context-menu-copy-link =
    .label = Keçid ünvanını köçür
    .accesskey = K

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = Oynat
    .accesskey = O

main-context-menu-media-pause =
    .label = Dayandır
    .accesskey = D

##

main-context-menu-media-mute =
    .label = Səssiz
    .accesskey = S

main-context-menu-media-unmute =
    .label = Səsi aç
    .accesskey = ə

main-context-menu-media-play-speed =
    .label = Oxutma Sürəti
    .accesskey = S

main-context-menu-media-play-speed-slow =
    .label = Yavaş (0,5×)
    .accesskey = Y

main-context-menu-media-play-speed-normal =
    .label = Normal
    .accesskey = N

main-context-menu-media-play-speed-fast =
    .label = Sürətli (1,25×)
    .accesskey = S

main-context-menu-media-play-speed-faster =
    .label = Daha sürətli (1,5×)
    .accesskey = D

# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = Çox sürətli (2×)
    .accesskey = l

main-context-menu-media-loop =
    .label = Dövr
    .accesskey = D

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = Düymələri göstər
    .accesskey = s

main-context-menu-media-hide-controls =
    .label = Düymələri gizlə
    .accesskey = D

##

main-context-menu-media-video-fullscreen =
    .label = Tam Ekran
    .accesskey = T

main-context-menu-media-video-leave-fullscreen =
    .label = Tam ekrandan çıx
    .accesskey = e

# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-pip =
    .label = Şəkildə-Şəkil
    .accesskey = u

main-context-menu-image-reload =
    .label = Şəkli Yenilə
    .accesskey = Y

main-context-menu-image-view =
    .label = Şəkli Göstər
    .accesskey = Ş

main-context-menu-video-view =
    .label = Videoya bax
    .accesskey = V

main-context-menu-image-copy =
    .label = Şəkli Köçür
    .accesskey = y

main-context-menu-image-copy-location =
    .label = Şəkil Ünvanını Köçür
    .accesskey = k

main-context-menu-video-copy-location =
    .label = Video Ünvanını Köçür
    .accesskey = V

main-context-menu-audio-copy-location =
    .label = Səs Ünvanını Köçür
    .accesskey = S

main-context-menu-image-save-as =
    .label = Şəkili fərqli saxla…
    .accesskey = r

main-context-menu-image-email =
    .label = Rəsmi e-poçt ilə göndər…
    .accesskey = R

main-context-menu-image-set-as-background =
    .label = İşçi stolu arxa fonu et…
    .accesskey = s

main-context-menu-image-info =
    .label = Şəkil məlumatlarını göstər
    .accesskey = r

main-context-menu-image-desc =
    .label = Açıqlamanı Göstər
    .accesskey = A

main-context-menu-video-save-as =
    .label = Videonu Fərqli Saxla…
    .accesskey = a

main-context-menu-audio-save-as =
    .label = Səsi fərqli saxla…
    .accesskey = f

main-context-menu-video-image-save-as =
    .label = Ekran görüntüsünü fərqli saxla…
    .accesskey = E

main-context-menu-video-email =
    .label = Videonu e-poçt ilə göndər…
    .accesskey = V

main-context-menu-audio-email =
    .label = Audionu e-poçt ilə göndər…
    .accesskey = -

main-context-menu-plugin-play =
    .label = Bu qoşmanı aktivləşdir
    .accesskey = a

main-context-menu-plugin-hide =
    .label = Bu qoşmanı gizlət
    .accesskey = g

main-context-menu-save-to-pocket =
    .label = Səhifəni { -pocket-brand-name }-ə Saxla
    .accesskey = k

main-context-menu-send-to-device =
    .label = Səhifəni cihaza göndər
    .accesskey = d

main-context-menu-view-background-image =
    .label = Arxa fon şəklini göstər
    .accesskey = r

main-context-menu-generate-new-password =
    .label = Törədilən parolu işlət…
    .accesskey = G

main-context-menu-keyword =
    .label = Bu axtarış üçün Açar söz əlavə et…
    .accesskey = A

main-context-menu-link-send-to-device =
    .label = Keçidi cihaza göndər
    .accesskey = d

main-context-menu-frame =
    .label = Bu Çərçivə
    .accesskey = u

main-context-menu-frame-show-this =
    .label = Sadəcə bu çərçivəni göstər
    .accesskey = c

main-context-menu-frame-open-tab =
    .label = Çərçivəni Yeni Vərəqdə Aç
    .accesskey = V

main-context-menu-frame-open-window =
    .label = Çərçivəni Yeni Pəncərədə Aç
    .accesskey = P

main-context-menu-frame-reload =
    .label = Çərçivəni yenilə
    .accesskey = e

main-context-menu-frame-bookmark =
    .label = Bu Çərçivəni Əlfəcinlə
    .accesskey = Ə

main-context-menu-frame-save-as =
    .label = Çərçivəni Fərqli Saxla…
    .accesskey = Ç

main-context-menu-frame-print =
    .label = Çərçivəni Çap et…
    .accesskey = Ç

main-context-menu-frame-view-source =
    .label = Çərçivə qaynağını göstər
    .accesskey = v

main-context-menu-frame-view-info =
    .label = Çərçivə Məlumatlarını Göstər
    .accesskey = M

main-context-menu-view-selection-source =
    .label = Seçimin qaynaq kodunu göstər
    .accesskey = e

main-context-menu-view-page-source =
    .label = Səhifə qaynağını göstər
    .accesskey = a

main-context-menu-view-page-info =
    .label = Səhifə məlumatlarını göstər
    .accesskey = S

main-context-menu-bidi-switch-text =
    .label = Mətnin səmtini dəyiş
    .accesskey = M

main-context-menu-bidi-switch-page =
    .label = Səhifənin səmtini dəyiş
    .accesskey = d

main-context-menu-inspect-element =
    .label = Obyekti araşdır
    .accesskey = Q

main-context-menu-inspect-a11y-properties =
    .label = Əlverişlilik özəlliklərini yoxla

main-context-menu-eme-learn-more =
    .label = DRM haqqında ətraflı öyrən…
    .accesskey = D

