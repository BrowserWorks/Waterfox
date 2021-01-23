# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] Při dlouhém stisku zobrazí historii
           *[other] Při dlouhém stisku či po klepnutí pravým tlačítkem zobrazí historii
        }

## Back

main-context-menu-back =
    .tooltiptext = Přejde na předchozí stránku
    .aria-label = Zpět
    .accesskey = Z

navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }

toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = Přejde na následující stránku
    .aria-label = Vpřed
    .accesskey = V

navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }

toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = Znovu načíst
    .accesskey = o

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = Zastavit
    .accesskey = s

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = Uložit stránku jako…
    .accesskey = j

toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = Přidat stránku do záložek
    .accesskey = P
    .tooltiptext = Přidá tuto stránku do záložek

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = Přidat stránku do záložek
    .accesskey = P
    .tooltiptext = Přidá tuto stránku do záložek ({ $shortcut })

main-context-menu-bookmark-change =
    .aria-label = Upravit záložku
    .accesskey = P
    .tooltiptext = Upraví tuto záložku

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = Upravit záložku
    .accesskey = P
    .tooltiptext = Upraví tuto záložku ({ $shortcut })

main-context-menu-open-link =
    .label = Otevřít odkaz
    .accesskey = O

main-context-menu-open-link-new-tab =
    .label = Otevřít odkaz v novém panelu
    .accesskey = n

main-context-menu-open-link-container-tab =
    .label = Otevřít odkaz v novém kontejnerovém panelu
    .accesskey = K

main-context-menu-open-link-new-window =
    .label = Otevřít odkaz v novém okně
    .accesskey = O

main-context-menu-open-link-new-private-window =
    .label = Otevřít odkaz v novém anonymním okně
    .accesskey = t

main-context-menu-bookmark-this-link =
    .label = Přidat odkaz do záložek
    .accesskey = d

main-context-menu-save-link =
    .label = Uložit odkaz jako…
    .accesskey = U

main-context-menu-save-link-to-pocket =
    .label = Uložit odkaz do { -pocket-brand-name(case: "gen") }
    .accesskey = o

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = Kopírovat e-mailovou adresu
    .accesskey = a

main-context-menu-copy-link =
    .label = Kopírovat adresu odkazu
    .accesskey = s

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = Přehrát
    .accesskey = P

main-context-menu-media-pause =
    .label = Pozastavit
    .accesskey = P

##

main-context-menu-media-mute =
    .label = Vypnout zvuk
    .accesskey = z

main-context-menu-media-unmute =
    .label = Zapnout zvuk
    .accesskey = z

main-context-menu-media-play-speed =
    .label = Rychlost přehrávání
    .accesskey = r

main-context-menu-media-play-speed-slow =
    .label = Pomalá (0.5×)
    .accesskey = P

main-context-menu-media-play-speed-normal =
    .label = Normální
    .accesskey = N

main-context-menu-media-play-speed-fast =
    .label = Rychlá (1.25×)
    .accesskey = R

main-context-menu-media-play-speed-faster =
    .label = Rychlejší (1.5×)
    .accesskey = e

# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = Absurdní (2 ×)
    .accesskey = A

main-context-menu-media-loop =
    .label = Smyčka
    .accesskey = S

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = Zobrazit ovládání
    .accesskey = o

main-context-menu-media-hide-controls =
    .label = Skrýt ovládání
    .accesskey = o

##

main-context-menu-media-video-fullscreen =
    .label = Celá obrazovka
    .accesskey = C

main-context-menu-media-video-leave-fullscreen =
    .label = Ukončit režim celé obrazovky
    .accesskey = k

# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-pip =
    .label = Obraz v obraze
    .accesskey = v

main-context-menu-image-reload =
    .label = Znovu načíst obrázek
    .accesskey = b

main-context-menu-image-view =
    .label = Zobrazit obrázek
    .accesskey = Z

main-context-menu-video-view =
    .label = Zobrazit video
    .accesskey = Z

main-context-menu-image-copy =
    .label = Kopírovat obrázek
    .accesskey = r

main-context-menu-image-copy-location =
    .label = Kopírovat adresu obrázku
    .accesskey = a

main-context-menu-video-copy-location =
    .label = Kopírovat adresu videa
    .accesskey = a

main-context-menu-audio-copy-location =
    .label = Kopírovat adresu audia
    .accesskey = a

main-context-menu-image-save-as =
    .label = Uložit obrázek jako…
    .accesskey = l

main-context-menu-image-email =
    .label = Poslat obrázek e-mailem…
    .accesskey = e

main-context-menu-image-set-as-background =
    .label = Nastavit jako pozadí plochy…
    .accesskey = t

main-context-menu-image-info =
    .label = Zobrazit vlastnosti obrázku
    .accesskey = v

main-context-menu-image-desc =
    .label = Zobrazit popis
    .accesskey = p

main-context-menu-video-save-as =
    .label = Uložit video jako…
    .accesskey = l

main-context-menu-audio-save-as =
    .label = Uložit audio jako……
    .accesskey = l

main-context-menu-video-image-save-as =
    .label = Uložit snímek jako…
    .accesskey = U

main-context-menu-video-email =
    .label = Poslat video e-mailem…
    .accesskey = a

main-context-menu-audio-email =
    .label = Poslat audio e-mailem…
    .accesskey = a

main-context-menu-plugin-play =
    .label = Spustit zásuvný modul
    .accesskey = p

main-context-menu-plugin-hide =
    .label = Skrýt zásuvný modul
    .accesskey = S

main-context-menu-save-to-pocket =
    .label = Uložit stránku do { -pocket-brand-name(case: "gen") }
    .accesskey = k

main-context-menu-send-to-device =
    .label = Poslat stránku do zařízení
    .accesskey = e

main-context-menu-view-background-image =
    .label = Zobrazit obrázek na pozadí
    .accesskey = b

main-context-menu-generate-new-password =
    .label = Vygenerovat bezpečné heslo…
    .accesskey = G

main-context-menu-keyword =
    .label = Přiřadit k tomuto vyhledávání klíčové slovo…
    .accesskey = h

main-context-menu-link-send-to-device =
    .label = Poslat odkaz do zařízení
    .accesskey = e

main-context-menu-frame =
    .label = Tento rám
    .accesskey = T

main-context-menu-frame-show-this =
    .label = Zobrazit pouze tento rám
    .accesskey = p

main-context-menu-frame-open-tab =
    .label = Otevřít rám v novém panelu
    .accesskey = n

main-context-menu-frame-open-window =
    .label = Otevřít rám v novém okně
    .accesskey = O

main-context-menu-frame-reload =
    .label = Znovu načíst rám
    .accesskey = m

main-context-menu-frame-bookmark =
    .label = Přidat rám do záložek
    .accesskey = d

main-context-menu-frame-save-as =
    .label = Uložit rám jako…
    .accesskey = r

main-context-menu-frame-print =
    .label = Tisknout rám…
    .accesskey = T

main-context-menu-frame-view-source =
    .label = Zobrazit zdrojový kód rámu
    .accesskey = j

main-context-menu-frame-view-info =
    .label = Zobrazit informace o rámu
    .accesskey = i

main-context-menu-view-selection-source =
    .label = Zobrazit zdrojový kód výběru
    .accesskey = j

main-context-menu-view-page-source =
    .label = Zobrazit zdrojový kód stránky
    .accesskey = r

main-context-menu-view-page-info =
    .label = Zobrazit informace o stránce
    .accesskey = i

main-context-menu-bidi-switch-text =
    .label = Změnit směr textu
    .accesskey = r

main-context-menu-bidi-switch-page =
    .label = Změnit orientaci stránky
    .accesskey = o

main-context-menu-inspect-element =
    .label = Prozkoumat prvek
    .accesskey = P

main-context-menu-inspect-a11y-properties =
    .label = Procházet vlastnosti přístupnosti

main-context-menu-eme-learn-more =
    .label = Zjistit více o DRM…
    .accesskey = D
