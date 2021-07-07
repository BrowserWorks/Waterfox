# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = Download
downloads-panel =
    .aria-label = Download

##

# The style attribute has the width of the Downloads Panel expressed using
# a CSS unit. The longest labels that should fit are usually those of
# in-progress and blocked downloads.
downloads-panel-list =
    .style = width: 70ch

downloads-panel-items =
    .style = width: 40em

downloads-cmd-pause =
    .label = Pausa
    .accesskey = P
downloads-cmd-resume =
    .label = Riprendi
    .accesskey = R
downloads-cmd-cancel =
    .tooltiptext = Annulla
downloads-cmd-cancel-panel =
    .aria-label = Annulla

# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = Apri cartella di destinazione
    .accesskey = A

# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = Mostra nel Finder
    .accesskey = F

downloads-cmd-use-system-default =
  .label = Apri nel visualizzatore del sistema
  .accesskey = v

downloads-cmd-always-use-system-default =
  .label = Apri sempre nel visualizzatore del sistema
  .accesskey = m

downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] Mostra nel Finder
           *[other] Apri cartella di destinazione
        }

downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] Mostra nel Finder
           *[other] Apri cartella di destinazione
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] Mostra nel Finder
           *[other] Apri cartella di destinazione
        }

downloads-cmd-show-downloads =
    .label = Visualizza cartella di download
downloads-cmd-retry =
    .tooltiptext = Riprova
downloads-cmd-retry-panel =
    .aria-label = Riprova
downloads-cmd-go-to-download-page =
    .label = Vai alla pagina di download
    .accesskey = w
downloads-cmd-copy-download-link =
    .label = Copia indirizzo di origine
    .accesskey = C
downloads-cmd-remove-from-history =
    .label = Elimina dalla cronologia
    .accesskey = m
downloads-cmd-clear-list =
    .label = Svuota pannello anteprima
    .accesskey = o
downloads-cmd-clear-downloads =
    .label = Cancella elenco download
    .accesskey = n

# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = Consenti download
    .accesskey = s

# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = Elimina file

downloads-cmd-remove-file-panel =
    .aria-label = Elimina file

# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = Elimina file o consenti download

downloads-cmd-choose-unblock-panel =
    .aria-label = Elimina file o consenti download

# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = Apri o elimina file

downloads-cmd-choose-open-panel =
    .aria-label = Apri o elimina file

# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = Visualizza ulteriori informazioni

# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = Apri file

## Displayed when the user clicked on a download in process. Indicates that the
## downloading file will be opened after certain amount of time using an app
## available in the system.
## Variables:
##   $hours (number) - Amount of hours left till the file opens.
##   $seconds (number) - Amount of seconds left till the file opens.
##   $minutes (number) - Amount of minutes till the file opens.

downloading-file-opens-in-hours-and-minutes = Verrà aperto in { $hours }h { $minutes }m…
downloading-file-opens-in-minutes = Verrà aperto in { $minutes }m…
downloading-file-opens-in-minutes-and-seconds = Verrà aperto in { $minutes }m { $seconds }s…
downloading-file-opens-in-seconds = Verrà aperto in { $seconds }s…
downloading-file-opens-in-some-time = Verrà aperto non appena completato…

##

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = Riprova download

# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = Annulla download

# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = Visualizza tutti i download
    .accesskey = V

# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = Dettagli download

downloads-clear-downloads-button =
    .label = Cancella elenco download
    .tooltiptext = Rimuovi dall’elenco i download completati, annullati o non riusciti

# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = Non sono presenti download.

# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = Nessun download per questa sessione.
