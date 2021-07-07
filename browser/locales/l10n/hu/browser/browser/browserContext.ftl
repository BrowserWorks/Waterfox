# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] Lehúzás az előzményekhez
           *[other] Jobb kattintás vagy lehúzás az előzményekhez
        }

## Back

main-context-menu-back =
    .tooltiptext = Ugrás az előző oldalra
    .aria-label = Vissza
    .accesskey = V
navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }
toolbar-button-back =
    .label = { main-context-menu-back.aria-label }
# Variables
#   $shortcut (String) - A keyboard shortcut for the Go Back command.
main-context-menu-back-2 =
    .tooltiptext = Ugrás az előző oldalra ({ $shortcut })
    .aria-label = Vissza
    .accesskey = V
# This menuitem is only visible on macOS
main-context-menu-back-mac =
    .label = Vissza
    .accesskey = V
navbar-tooltip-back-2 =
    .value = { main-context-menu-back-2.tooltiptext }
toolbar-button-back-2 =
    .label = { main-context-menu-back-2.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = Ugrás a következő oldalra
    .aria-label = Előre
    .accesskey = E
navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }
toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }
# Variables
#   $shortcut (String) - A keyboard shortcut for the Go Forward command.
main-context-menu-forward-2 =
    .tooltiptext = Ugrás a következő oldalra ({ $shortcut })
    .aria-label = Előre
    .accesskey = E
# This menuitem is only visible on macOS
main-context-menu-forward-mac =
    .label = Előre
    .accesskey = E
navbar-tooltip-forward-2 =
    .value = { main-context-menu-forward-2.tooltiptext }
toolbar-button-forward-2 =
    .label = { main-context-menu-forward-2.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = Frissítés
    .accesskey = F
# This menuitem is only visible on macOS
main-context-menu-reload-mac =
    .label = Frissítés
    .accesskey = F
toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = Leállítás
    .accesskey = L
# This menuitem is only visible on macOS
main-context-menu-stop-mac =
    .label = Leállítás
    .accesskey = L
toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Firefox Account Button

toolbar-button-fxaccount =
    .label = { -fxaccount-brand-name }
    .tooltiptext = { -fxaccount-brand-name }

## Save Page

main-context-menu-page-save =
    .label = Oldal mentése…
    .accesskey = O
toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = Oldal hozzáadása a könyvjelzőkhöz
    .accesskey = k
    .tooltiptext = Oldal a könyvjelzők közé
# This menuitem is only visible on macOS
# Cannot be shown at the same time as main-context-menu-bookmark-edit-mac,
# so should probably have the same access key if possible.
main-context-menu-bookmark-add-mac =
    .label = Lap könyvjelzőzése
    .accesskey = k
# This menuitem is only visible on macOS
# Cannot be shown at the same time as main-context-menu-bookmark-add-mac,
# so should probably have the same access key if possible.
main-context-menu-bookmark-edit-mac =
    .label = Könyvjelző szerkesztése
    .accesskey = K
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = Oldal hozzáadása a könyvjelzőkhöz
    .accesskey = k
    .tooltiptext = Oldal a könyvjelzők közé ({ $shortcut })
main-context-menu-bookmark-change =
    .aria-label = Könyvjelző szerkesztése
    .accesskey = k
    .tooltiptext = Könyvjelző szerkesztése
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = Könyvjelző szerkesztése
    .accesskey = k
    .tooltiptext = Könyvjelző szerkesztése ({ $shortcut })
main-context-menu-open-link =
    .label = Hivatkozás megnyitása
    .accesskey = H
main-context-menu-open-link-new-tab =
    .label = Megnyitás új lapon
    .accesskey = l
main-context-menu-open-link-container-tab =
    .label = Hivatkozás megnyitása új konténerlapon
    .accesskey = k
main-context-menu-open-link-new-window =
    .label = Megnyitás új ablakban
    .accesskey = a
main-context-menu-open-link-new-private-window =
    .label = Hivatkozás megnyitása új privát ablakban
    .accesskey = p
main-context-menu-bookmark-this-link =
    .label = Hivatkozás felvétele a könyvjelzők közé
    .accesskey = f
main-context-menu-bookmark-link =
    .label = Hivatkozás könyvjelzőzése
    .accesskey = H
main-context-menu-save-link =
    .label = Hivatkozás mentése más néven…
    .accesskey = n
main-context-menu-save-link-to-pocket =
    .label = Hivatkozás mentése a { -pocket-brand-name }be
    .accesskey = o

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.


## The access keys for "Copy Link" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = E-mail cím másolása
    .accesskey = m
main-context-menu-copy-link =
    .label = Hivatkozás címének másolása
    .accesskey = v
main-context-menu-copy-link-simple =
    .label = Hivatkozás másolása
    .accesskey = m

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = Lejátszás
    .accesskey = L
main-context-menu-media-pause =
    .label = Szünet
    .accesskey = S

##

main-context-menu-media-mute =
    .label = Némítás
    .accesskey = N
main-context-menu-media-unmute =
    .label = Hang be
    .accesskey = n
main-context-menu-media-play-speed =
    .label = Lejátszási sebesség
    .accesskey = s
main-context-menu-media-play-speed-slow =
    .label = Lassú (0.5×)
    .accesskey = L
main-context-menu-media-play-speed-normal =
    .label = Normál
    .accesskey = N
main-context-menu-media-play-speed-fast =
    .label = Gyors (1.25×)
    .accesskey = G
main-context-menu-media-play-speed-faster =
    .label = Gyorsabb (1.5×)
    .accesskey = o
# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = Elképzelhetetlen (2×)
    .accesskey = k
main-context-menu-media-play-speed-2 =
    .label = Sebesség
    .accesskey = b
main-context-menu-media-play-speed-slow-2 =
    .label = 0,5×
main-context-menu-media-play-speed-normal-2 =
    .label = 1,0×
main-context-menu-media-play-speed-fast-2 =
    .label = 1,25×
main-context-menu-media-play-speed-faster-2 =
    .label = 1,5×
main-context-menu-media-play-speed-fastest-2 =
    .label = 2×
main-context-menu-media-loop =
    .label = Ismétlés
    .accesskey = I

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = Vezérlők megjelenítése
    .accesskey = V
main-context-menu-media-hide-controls =
    .label = Vezérlők elrejtése
    .accesskey = V

##

main-context-menu-media-video-fullscreen =
    .label = Teljes képernyő
    .accesskey = T
main-context-menu-media-video-leave-fullscreen =
    .label = Kilépés a teljes képernyős módból
    .accesskey = K
# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-pip =
    .label = Kép a képben
    .accesskey = p
# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-watch-pip =
    .label = Megtekintés Kép a képben módban
    .accesskey = K
main-context-menu-image-reload =
    .label = Kép újrabetöltése
    .accesskey = r
main-context-menu-image-view =
    .label = Kép megjelenítése
    .accesskey = s
main-context-menu-video-view =
    .label = Videó megtekintése
    .accesskey = V
main-context-menu-image-view-new-tab =
    .label = Kép megnyitása új lapon
    .accesskey = K
main-context-menu-video-view-new-tab =
    .label = Videó megnyitása új lapon
    .accesskey = V
main-context-menu-image-copy =
    .label = Kép másolása
    .accesskey = o
main-context-menu-image-copy-location =
    .label = Kép címének másolása
    .accesskey = c
main-context-menu-video-copy-location =
    .label = Videó címének másolása
    .accesskey = d
main-context-menu-audio-copy-location =
    .label = Hang címének másolása
    .accesskey = s
main-context-menu-image-copy-link =
    .label = Képhivatkozás másolása
    .accesskey = l
main-context-menu-video-copy-link =
    .label = Videóhivatkozás másolása
    .accesskey = V
main-context-menu-audio-copy-link =
    .label = Hanghivatkozás másolása
    .accesskey = H
main-context-menu-image-save-as =
    .label = Kép mentése más néven…
    .accesskey = m
main-context-menu-image-email =
    .label = Kép küldése e-mailben…
    .accesskey = p
main-context-menu-image-set-as-background =
    .label = Beállítás háttérképként…
    .accesskey = B
main-context-menu-image-set-image-as-background =
    .label = Kép beállítása háttérképként…
    .accesskey = K
main-context-menu-image-info =
    .label = Képadatok megjelenítése
    .accesskey = d
main-context-menu-image-desc =
    .label = Leírás megjelenítése
    .accesskey = L
main-context-menu-video-save-as =
    .label = Videó mentése más néven…
    .accesskey = v
main-context-menu-audio-save-as =
    .label = Hang mentése más néven…
    .accesskey = H
main-context-menu-video-image-save-as =
    .label = Pillanatkép mentése más néven…
    .accesskey = P
main-context-menu-video-take-snapshot =
    .label = Pillanatkép készítése…
    .accesskey = P
main-context-menu-video-email =
    .label = Videó küldése e-mailben…
    .accesskey = i
main-context-menu-audio-email =
    .label = Hang küldése e-mailben…
    .accesskey = a
main-context-menu-plugin-play =
    .label = Ezen bővítmény aktiválása
    .accesskey = k
main-context-menu-plugin-hide =
    .label = Bővítmény elrejtése
    .accesskey = r
main-context-menu-save-to-pocket =
    .label = Oldal mentése a { -pocket-brand-name }be
    .accesskey = k
main-context-menu-send-to-device =
    .label = Oldal küldése eszközre
    .accesskey = e
main-context-menu-view-background-image =
    .label = Háttérkép megjelenítése
    .accesskey = s
main-context-menu-generate-new-password =
    .label = Előállított jelszó használata
    .accesskey = E

## The access keys for "Use Saved Login" and "Use Saved Password"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-use-saved-login =
    .label = Mentett bejelentkezés használata
    .accesskey = b
main-context-menu-use-saved-password =
    .label = Mentett jelszó használata
    .accesskey = j

##

main-context-menu-suggest-strong-password =
    .label = Erős jelszó javaslata…
    .accesskey = E
main-context-menu-manage-logins2 =
    .label = Bejelentkezések kezelése…
    .accesskey = B
main-context-menu-keyword =
    .label = Kulcsszó hozzáadása a kereséshez…
    .accesskey = u
main-context-menu-link-send-to-device =
    .label = Hivatkozás küldése eszközre
    .accesskey = e
main-context-menu-frame =
    .label = Ez a keret
    .accesskey = z
main-context-menu-frame-show-this =
    .label = Csak az aktuális keret megjelenítése
    .accesskey = C
main-context-menu-frame-open-tab =
    .label = Keret megnyitása új lapon
    .accesskey = l
main-context-menu-frame-open-window =
    .label = Keret megnyitása új ablakban
    .accesskey = a
main-context-menu-frame-reload =
    .label = Keret frissítése
    .accesskey = r
main-context-menu-frame-bookmark =
    .label = Keret hozzáadása a könyvjelzőkhöz
    .accesskey = h
main-context-menu-frame-save-as =
    .label = Keret mentése más néven…
    .accesskey = K
main-context-menu-frame-print =
    .label = Keret nyomtatása…
    .accesskey = n
main-context-menu-frame-view-source =
    .label = Keret forrása
    .accesskey = f
main-context-menu-frame-view-info =
    .label = Keret adatainak megjelenítése
    .accesskey = d
main-context-menu-print-selection =
    .label = Kijelölés nyomtatása
    .accesskey = K
main-context-menu-view-selection-source =
    .label = Kijelölés forrásának megtekintése
    .accesskey = M
main-context-menu-take-screenshot =
    .label = Képernyőkép készítése
    .accesskey = e
main-context-menu-take-frame-screenshot =
    .label = Képernyőkép készítése
    .accesskey = K
main-context-menu-view-page-source =
    .label = Oldal forrása
    .accesskey = f
main-context-menu-view-page-info =
    .label = Oldal adatainak megjelenítése
    .accesskey = d
main-context-menu-bidi-switch-text =
    .label = Szöveg irányának átváltása
    .accesskey = z
main-context-menu-bidi-switch-page =
    .label = Oldal irányának átváltása
    .accesskey = l
main-context-menu-inspect-element =
    .label = Elem vizsgálata
    .accesskey = z
main-context-menu-inspect =
    .label = Vizsgálat
    .accesskey = V
main-context-menu-inspect-a11y-properties =
    .label = Akadálymentesítési tulajdonságok vizsgálata
main-context-menu-eme-learn-more =
    .label = Tudjon meg többet a DRM-ről…
    .accesskey = D
