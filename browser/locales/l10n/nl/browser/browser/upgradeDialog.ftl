# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Strings for the upgrade dialog that can be displayed on major version change.


## New changes screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-new-title = Hartelijk welkom bij een nieuwe { -brand-short-name }
upgrade-dialog-new-subtitle = Ontworpen om u sneller te brengen waar u heen wilt
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline
# style to be automatically added to the text inside it. { -brand-short-name }
# should stay inside the span.
upgrade-dialog-new-alt-subtitle = Begin door <span data-l10n-name="zap">{ -brand-short-name }</span> een klik verwijderd te maken
upgrade-dialog-new-item-menu-title = Gestroomlijnde werkbalk en menu’s
upgrade-dialog-new-item-menu-description = Geef prioriteit aan de belangrijke dingen, zodat u vindt wat u nodig hebt.
upgrade-dialog-new-item-tabs-title = Moderne tabbladen
upgrade-dialog-new-item-tabs-description = Houd gegevens netjes bij elkaar, waardoor u gefocust kunt blijven en flexibel kunt handelen.
upgrade-dialog-new-item-icons-title = Nieuwe pictogrammen en duidelijkere berichten
upgrade-dialog-new-item-icons-description = Helpen u op luchtiger manier uw weg te vinden.
upgrade-dialog-new-primary-primary-button = { -brand-short-name } mijn voorkeursbrowser maken
    .title = Stelt { -brand-short-name } in als standaardbrowser en maakt het vast aan de taakbalk
upgrade-dialog-new-primary-default-button = { -brand-short-name } mijn voorkeursbrowser maken
upgrade-dialog-new-primary-pin-button = { -brand-short-name } aan mijn taakbalk vastmaken
upgrade-dialog-new-primary-pin-alt-button = Aan taakbalk vastzetten
upgrade-dialog-new-primary-theme-button = Kies een thema
upgrade-dialog-new-secondary-button = Niet nu
# This string is only shown on Windows 7, where we intentionally suppress the
# theme selection screen.
upgrade-dialog-new-primary-win7-button = OK, begrepen!

## Pin Firefox screen
##
## These title, subtitle and button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-pin-title =
    { PLATFORM() ->
        [macos] { -brand-short-name } aan uw Dock toevoegen
       *[other] { -brand-short-name } aan uw taakbalk vastzetten
    }
# The English macOS string avoids repeating "Keep" a third time, so if your
# translations don't repeat anyway, the same string can be used cross-platform.
upgrade-dialog-pin-subtitle =
    { PLATFORM() ->
        [macos] Krijg eenvoudig toegang tot de meest frisse { -brand-short-name } tot nu toe.
       *[other] Houd de meest frisse { -brand-short-name } tot nu toe binnen handbereik.
    }
upgrade-dialog-pin-primary-button =
    { PLATFORM() ->
        [macos] Aan Dock toevoegen
       *[other] Aan taakbalk vastzetten
    }
upgrade-dialog-pin-secondary-button = Niet nu

## Default browser screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-default-title = { -brand-short-name } uw standaardbrowser maken?
upgrade-dialog-default-subtitle = Ontvang snelheid, veiligheid en privacy, telkens als u surft.
upgrade-dialog-default-primary-button = Als standaardbrowser instellen
# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-default-title-2 = { -brand-short-name } uw standaardbrowser maken
upgrade-dialog-default-subtitle-2 = Zet snelheid, veiligheid en privacy op de automatische piloot.
upgrade-dialog-default-primary-button-2 = Standaardbrowser maken
upgrade-dialog-default-secondary-button = Niet nu

## Theme selection screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-theme-title =
    Zorg voor een frisse start
    met een bijgewerkt thema
# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-theme-title-2 = Zorg voor een schone start met een fris thema
upgrade-dialog-theme-system = Systeemthema
    .title = Het thema van het besturingssysteem volgen voor knoppen, menu’s en vensters
upgrade-dialog-theme-light = Licht
    .title = Een licht thema voor knoppen, menu’s en vensters gebruiken
upgrade-dialog-theme-dark = Donker
    .title = Een donker thema voor knoppen, menu’s en vensters gebruiken
upgrade-dialog-theme-alpenglow = Alpenglow
    .title = Een dynamisch, kleurrijk thema voor knoppen, menu’s en vensters gebruiken
upgrade-dialog-theme-keep = Vorige behouden
    .title = Het thema dat u had geïnstalleerd voordat u { -brand-short-name } bijwerkte gebruiken
upgrade-dialog-theme-primary-button = Thema opslaan
upgrade-dialog-theme-secondary-button = Niet nu
