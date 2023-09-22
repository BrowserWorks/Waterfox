# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] Gedrückt halten, um Chronik anzuzeigen
           *[other] Rechtsklick oder gedrückt halten, um Chronik anzuzeigen
        }

## Back

# Variables
#   $shortcut (String) - A keyboard shortcut for the Go Back command.
main-context-menu-back-2 =
    .tooltiptext = Eine Seite zurück ({ $shortcut })
    .aria-label = Zurück
    .accesskey = Z
# This menuitem is only visible on macOS
main-context-menu-back-mac =
    .label = Zurück
    .accesskey = Z
navbar-tooltip-back-2 =
    .value = { main-context-menu-back-2.tooltiptext }
toolbar-button-back-2 =
    .label = { main-context-menu-back-2.aria-label }

## Forward

# Variables
#   $shortcut (String) - A keyboard shortcut for the Go Forward command.
main-context-menu-forward-2 =
    .tooltiptext = Eine Seite vor ({ $shortcut })
    .aria-label = Vor
    .accesskey = V
# This menuitem is only visible on macOS
main-context-menu-forward-mac =
    .label = Vor
    .accesskey = V
navbar-tooltip-forward-2 =
    .value = { main-context-menu-forward-2.tooltiptext }
toolbar-button-forward-2 =
    .label = { main-context-menu-forward-2.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = Neu laden
    .accesskey = N
# This menuitem is only visible on macOS
main-context-menu-reload-mac =
    .label = Neu laden
    .accesskey = N
toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = Stopp
    .accesskey = p
# This menuitem is only visible on macOS
main-context-menu-stop-mac =
    .label = Stopp
    .accesskey = p
toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Waterfox Account Button

toolbar-button-fxaccount =
    .label = { -fxaccount-brand-name }
    .tooltiptext = { -fxaccount-brand-name }

## Save Page

main-context-menu-page-save =
    .label = Seite speichern unter…
    .accesskey = e

## Simple menu items

main-context-menu-bookmark-page =
    .aria-label = Lesezeichen für Seite hinzufügen…
    .accesskey = L
    .tooltiptext = Lesezeichen für Seite hinzufügen
# This menuitem is only visible on macOS
# Cannot be shown at the same time as main-context-menu-edit-bookmark-mac,
# so should probably have the same access key if possible.
main-context-menu-bookmark-page-mac =
    .label = Lesezeichen für Seite hinzufügen…
    .accesskey = L
# This menuitem is only visible on macOS
# Cannot be shown at the same time as main-context-menu-bookmark-page-mac,
# so should probably have the same access key if possible.
main-context-menu-edit-bookmark-mac =
    .label = Lesezeichen bearbeiten…
    .accesskey = L
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-page-with-shortcut =
    .aria-label = Lesezeichen für Seite hinzufügen…
    .accesskey = L
    .tooltiptext = Lesezeichen für Seite hinzufügen ({ $shortcut })
main-context-menu-edit-bookmark =
    .aria-label = Lesezeichen bearbeiten…
    .accesskey = L
    .tooltiptext = Lesezeichen bearbeiten
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-edit-bookmark-with-shortcut =
    .aria-label = Lesezeichen bearbeiten…
    .accesskey = L
    .tooltiptext = Lesezeichen bearbeiten ({ $shortcut })
main-context-menu-open-link =
    .label = Link öffnen
    .accesskey = k
main-context-menu-open-link-new-tab =
    .label = Link in neuem Tab öffnen
    .accesskey = T
main-context-menu-open-link-container-tab =
    .label = Link in neuem Tab in Umgebung öffnen
    .accesskey = m
main-context-menu-open-link-new-window =
    .label = Link in neuem Fenster öffnen
    .accesskey = F
main-context-menu-open-link-new-private-window =
    .label = Link in neuem privaten Fenster öffnen
    .accesskey = p
main-context-menu-bookmark-link-2 =
    .label = Lesezeichen für Link hinzufügen…
    .accesskey = L
main-context-menu-save-link =
    .label = Ziel speichern unter…
    .accesskey = Z
main-context-menu-save-link-to-pocket =
    .label = Link in { -pocket-brand-name } speichern
    .accesskey = o

## The access keys for "Copy Link" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = E-Mail-Adresse kopieren
    .accesskey = k
main-context-menu-copy-phone =
    .label = Telefonnummer kopieren
    .accesskey = k
main-context-menu-copy-link-simple =
    .label = Link-Adresse kopieren
    .accesskey = k
# This command copies the link, removing additional
# query parameters used to track users across sites.
main-context-menu-strip-on-share-link =
    .label = Link ohne Website-Tracking kopieren
    .accesskey = y

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = Abspielen
    .accesskey = A
main-context-menu-media-pause =
    .label = Anhalten
    .accesskey = A

##

main-context-menu-media-mute =
    .label = Ton aus
    .accesskey = T
main-context-menu-media-unmute =
    .label = Ton an
    .accesskey = T
main-context-menu-media-play-speed-2 =
    .label = Geschwindigkeit
    .accesskey = G
main-context-menu-media-play-speed-slow-2 =
    .label = 0.5×
main-context-menu-media-play-speed-normal-2 =
    .label = 1.0×
main-context-menu-media-play-speed-fast-2 =
    .label = 1.25×
main-context-menu-media-play-speed-faster-2 =
    .label = 1.5×
main-context-menu-media-play-speed-fastest-2 =
    .label = 2×
main-context-menu-media-loop =
    .label = Endlosschleife
    .accesskey = f

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = Steuerung anzeigen
    .accesskey = S
main-context-menu-media-hide-controls =
    .label = Steuerung ausblenden
    .accesskey = S

##

main-context-menu-media-video-fullscreen =
    .label = Vollbild
    .accesskey = V
main-context-menu-media-video-leave-fullscreen =
    .label = Vollbild beenden
    .accesskey = e
# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-watch-pip =
    .label = In Bild-im-Bild ansehen
    .accesskey = m
main-context-menu-image-reload =
    .label = Grafik neu laden
    .accesskey = G
main-context-menu-image-view-new-tab =
    .label = Grafik in neuem Tab öffnen
    .accesskey = G
main-context-menu-video-view-new-tab =
    .label = Video in neuem Tab öffnen
    .accesskey = e
main-context-menu-image-copy =
    .label = Grafik kopieren
    .accesskey = o
main-context-menu-image-copy-link =
    .label = Grafikadresse kopieren
    .accesskey = d
main-context-menu-video-copy-link =
    .label = Video-Adresse kopieren
    .accesskey = d
main-context-menu-audio-copy-link =
    .label = Audio-Adresse kopieren
    .accesskey = d
main-context-menu-image-save-as =
    .label = Grafik speichern unter…
    .accesskey = u
main-context-menu-image-email =
    .label = Grafik per E-Mail senden…
    .accesskey = n
main-context-menu-image-set-image-as-background =
    .label = Bild als Hintergrundbild einrichten…
    .accesskey = B
main-context-menu-image-copy-text =
    .label = Text aus Grafik kopieren
    .accesskey = T
main-context-menu-image-info =
    .label = Grafik-Info anzeigen
    .accesskey = e
main-context-menu-image-desc =
    .label = Beschreibung anzeigen
    .accesskey = B
main-context-menu-video-save-as =
    .label = Video speichern unter…
    .accesskey = u
main-context-menu-audio-save-as =
    .label = Audio speichern unter…
    .accesskey = u
main-context-menu-video-take-snapshot =
    .label = Standbild aufnehmen…
    .accesskey = b
main-context-menu-video-email =
    .label = Video per E-Mail senden…
    .accesskey = n
main-context-menu-audio-email =
    .label = Audio per E-Mail senden…
    .accesskey = n
main-context-menu-save-to-pocket =
    .label = Seite in { -pocket-brand-name } speichern
    .accesskey = o
main-context-menu-send-to-device =
    .label = Seite an Gerät senden
    .accesskey = X

## The access keys for "Use Saved Login" and "Use Saved Password"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-use-saved-login =
    .label = Gespeicherte Zugangsdaten verwenden
    .accesskey = G
main-context-menu-use-saved-password =
    .label = Gespeichertes Passwort verwenden
    .accesskey = G

##

main-context-menu-use-relay-mask =
    .label = { -relay-brand-short-name }-E-Mail-Maske verwenden
    .accesskey = E
main-context-menu-suggest-strong-password =
    .label = Starkes Passwort vorschlagen…
    .accesskey = P
main-context-menu-manage-logins2 =
    .label = Zugangsdaten verwalten
    .accesskey = v
main-context-menu-keyword =
    .label = Ein Schlüsselwort für diese Suche hinzufügen…
    .accesskey = S
main-context-menu-link-send-to-device =
    .label = Link an Gerät senden
    .accesskey = X
main-context-menu-frame =
    .label = Aktueller Frame
    .accesskey = F
main-context-menu-frame-show-this =
    .label = Nur diesen Frame anzeigen
    .accesskey = N
main-context-menu-frame-open-tab =
    .label = Frame in neuem Tab öffnen
    .accesskey = T
main-context-menu-frame-open-window =
    .label = Frame in neuem Fenster öffnen
    .accesskey = F
main-context-menu-frame-reload =
    .label = Frame neu laden
    .accesskey = R
main-context-menu-frame-add-bookmark =
    .label = Lesezeichen für Frame hinzufügen…
    .accesskey = L
main-context-menu-frame-save-as =
    .label = Frame speichern unter…
    .accesskey = m
main-context-menu-frame-print =
    .label = Frame drucken…
    .accesskey = d
main-context-menu-frame-view-source =
    .label = Frame-Quelltext anzeigen
    .accesskey = F
main-context-menu-frame-view-info =
    .label = Frame-Informationen anzeigen
    .accesskey = I
main-context-menu-print-selection-2 =
    .label = Auswahl drucken…
    .accesskey = w
main-context-menu-view-selection-source =
    .label = Auswahl-Quelltext anzeigen
    .accesskey = A
main-context-menu-take-screenshot =
    .label = Bildschirmfoto aufnehmen
    .accesskey = a
main-context-menu-take-frame-screenshot =
    .label = Bildschirmfoto aufnehmen
    .accesskey = a
main-context-menu-view-page-source =
    .label = Seitenquelltext anzeigen
    .accesskey = a
main-context-menu-bidi-switch-text =
    .label = Textrichtung ändern
    .accesskey = ä
main-context-menu-bidi-switch-page =
    .label = Seitenrichtung ändern
    .accesskey = S
main-context-menu-inspect =
    .label = Untersuchen
    .accesskey = Q
main-context-menu-inspect-a11y-properties =
    .label = Barrierefreiheit-Eigenschaften untersuchen
main-context-menu-eme-learn-more =
    .label = Mehr über DRM-Kopierschutz erfahren…
    .accesskey = D
# Variables
#   $containerName (String): The name of the current container
main-context-menu-open-link-in-container-tab =
    .label = Link in neuem { $containerName }-Tab öffnen
    .accesskey = T
main-context-menu-reveal-password =
    .label = Passwort anzeigen
    .accesskey = o
