# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Strings for the upgrade dialog that can be displayed on major version change.


## New changes screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-new-title = Sei hei til nye { -brand-short-name }
upgrade-dialog-new-subtitle = Utforma for å ta deg dit du vil, raskare
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline
# style to be automatically added to the text inside it. { -brand-short-name }
# should stay inside the span.
upgrade-dialog-new-alt-subtitle = Start med å gjere <span data-l10n-name="zap">{ -brand-short-name }</span> tilgjengeleg med eitt klikk
upgrade-dialog-new-item-menu-title = Straumlinjeforma verktøylinje og menyar
upgrade-dialog-new-item-menu-description = Prioriterer dei viktige tinga slik at du finn det du treng
upgrade-dialog-new-item-tabs-title = Moderne faner
upgrade-dialog-new-item-tabs-description = Inneheld tydeleg informasjon, hjelper deg å fokusere og er lett å flytte rundt.
upgrade-dialog-new-item-icons-title = Nye ikon og tydelegare meldingar
upgrade-dialog-new-item-icons-description = Hjelper deg med å finne vegen på ein lettare måte.
upgrade-dialog-new-primary-primary-button = Vel { -brand-short-name } som primærnettlesar
    .title = Stiller inn { -brand-short-name } som standardnettlesar og festar han til oppgåvelinja
upgrade-dialog-new-primary-default-button = Vel { -brand-short-name } som stanardnettlesar
upgrade-dialog-new-primary-pin-button = Fest { -brand-short-name } til oppgåvelinja
upgrade-dialog-new-primary-pin-alt-button = Fest til oppgåvelinja
upgrade-dialog-new-primary-theme-button = Vel eit tema
upgrade-dialog-new-secondary-button = Ikkje no
# This string is only shown on Windows 7, where we intentionally suppress the
# theme selection screen.
upgrade-dialog-new-primary-win7-button = OK, eg forstår!

## Pin Firefox screen
##
## These title, subtitle and button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-pin-title =
    { PLATFORM() ->
        [macos] Behald { -brand-short-name } i Dock
       *[other] Fest { -brand-short-name } til oppgåvelinja
    }
# The English macOS string avoids repeating "Keep" a third time, so if your
# translations don't repeat anyway, the same string can be used cross-platform.
upgrade-dialog-pin-subtitle =
    { PLATFORM() ->
        [macos] Få enkel tilgang til den mest moderne { -brand-short-name } til no.
       *[other] Ha den siste { -brand-short-name } innanfor rekkjevidde.
    }
upgrade-dialog-pin-primary-button =
    { PLATFORM() ->
        [macos] Behald i Dock
       *[other] Fest til oppgåvelinja
    }
upgrade-dialog-pin-secondary-button = Ikkje no

## Default browser screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-default-title = Bruke { -brand-short-name } som standardnettlesar?
upgrade-dialog-default-subtitle = Få fart, sikkerheit og personvern kvar gong du surfar.
upgrade-dialog-default-primary-button = Vel som standardnettlesar
# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-default-title-2 = Bruk { -brand-short-name } som standardnettlesar
upgrade-dialog-default-subtitle-2 = Set fart, sikkerheit og personvern på autopilot.
upgrade-dialog-default-primary-button-2 = Bruk som standardnettlesar
upgrade-dialog-default-secondary-button = Ikkje no

## Theme selection screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-theme-title =
    Få ein ny start
    med eit oppdatert tema
# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-theme-title-2 = Få ein ny start med eit nytt tema
upgrade-dialog-theme-system = Systemtema
    .title = Følg operativsystem-temaet for knappar, menyar og vindauge
upgrade-dialog-theme-light = Lyst
    .title = Bruk eit lyst tema for knappar, menyar og vindauge
upgrade-dialog-theme-dark = Mørkt
    .title = Bruk eit mørkt tema for knappar, menyar og vindauge
upgrade-dialog-theme-alpenglow = Alpenglow
    .title = Bruk eit dynamisk, fargerikt tema for knappar, menyar og vindauge
upgrade-dialog-theme-keep = Behald tidlegare tema
    .title = Bruk temaet du hadde installert før du oppdaterte { -brand-short-name }
upgrade-dialog-theme-primary-button = Lagre tema
upgrade-dialog-theme-secondary-button = Ikkje no
