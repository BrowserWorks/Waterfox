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

downloads-cmd-show-menuitem-2 =
  .label = { PLATFORM() ->
      [macos] Mostra nel Finder
     *[other] Mostra nella cartella
  }
  .accesskey = n

## Displayed in the downloads context menu for files that can be opened.
## Variables:
##   $handler (String) - The name of the mime type's default file handler.
##   Example: "Notepad", "Acrobat Reader DC", "7-Zip File Manager"

downloads-cmd-use-system-default =
  .label = Apri nel visualizzatore del sistema
  .accesskey = n

downloads-cmd-use-system-default-named =
  .label = Apri in { $handler }
  .accesskey = n

downloads-cmd-always-use-system-default =
  .label = Apri sempre nel visualizzatore del sistema
  .accesskey = m

downloads-cmd-always-use-system-default-named =
  .label = Apri sempre in { $handler }
  .accesskey = m

##

# We can use the same accesskey as downloads-cmd-always-use-system-default.
# Both should not be visible in the downloads context menu at the same time.
downloads-cmd-always-open-similar-files =
  .label = Apri sempre file simili a questo
  .accesskey = m

downloads-cmd-show-button-2 =
    .tooltiptext =
        { PLATFORM() ->
            [macos] Mostra nel Finder
           *[other] Mostra nella cartella
        }

downloads-cmd-show-panel-2 =
    .aria-label =
        { PLATFORM() ->
            [macos] Mostra nel Finder
           *[other] Mostra nella cartella
        }
downloads-cmd-show-description-2 =
    .value =
        { PLATFORM() ->
            [macos] Mostra nel Finder
           *[other] Mostra nella cartella
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
downloads-cmd-delete-file =
    .label = Elimina
    .accesskey = E

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
downloading-file-click-to-open =
  .value = Apri non appena completato

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

## Displayed when a site attempts to automatically download many files.
## Variables:
##   $num (number) - Number of blocked downloads.
##   $url (string) - The url of the suspicious site, stripped of http, https and www prefix.

downloads-files-not-downloaded = { $num ->
    [one] File non scaricato.
   *[other] {$num} file non scaricati.
}
downloads-blocked-from-url = Bloccati download da { $url }.
downloads-blocked-download-detailed-info = { $url } ha cercato di scaricare automaticamente diversi file. È possibile che il sito contenga degli errori o che stia cercando di salvare contenuti indesiderati sul tuo dispositivo.

##

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

# This is displayed in an item at the bottom of the Downloads Panel when there
# are more downloads than can fit in the list in the panel.
#   $count (number) - number of files being downloaded that are not shown in the
#                     panel list.
downloads-more-downloading =
    { $count ->
        [one] { $count } altro file in download
       *[other] Altri { $count } file in download
    }
