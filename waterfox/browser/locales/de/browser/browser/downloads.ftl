# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = Downloads
downloads-panel =
    .aria-label = Downloads

##

# The style attribute has the width of the Downloads Panel expressed using
# a CSS unit. The longest labels that should fit are usually those of
# in-progress and blocked downloads.
downloads-panel-items =
    .style = width: 35em

downloads-cmd-pause =
    .label = Pause
    .accesskey = P
downloads-cmd-resume =
    .label = Fortsetzen
    .accesskey = o
downloads-cmd-cancel =
    .tooltiptext = Abbrechen
downloads-cmd-cancel-panel =
    .aria-label = Abbrechen

downloads-cmd-show-menuitem-2 =
    .label =
        { PLATFORM() ->
            [macos] Im Finder anzeigen
           *[other] In Ordner anzeigen
        }
    .accesskey = a

## Displayed in the downloads context menu for files that can be opened.
## Variables:
##   $handler (String) - The name of the mime type's default file handler.
##   Example: "Notepad", "Acrobat Reader DC", "7-Zip File Manager"

downloads-cmd-use-system-default =
    .label = Im Standardprogramm öffnen
    .accesskey = p
# This version is shown when the download's mime type has a valid file handler.
downloads-cmd-use-system-default-named =
    .label = In { $handler } öffnen
    .accesskey = n

# We can use the same accesskey as downloads-cmd-always-open-similar-files.
# Both should not be visible in the downloads context menu at the same time.
downloads-cmd-always-use-system-default =
    .label = Immer im Standardprogramm öffnen
    .accesskey = m
# We can use the same accesskey as downloads-cmd-always-open-similar-files.
# Both should not be visible in the downloads context menu at the same time.
# This version is shown when the download's mime type has a valid file handler.
downloads-cmd-always-use-system-default-named =
    .label = Immer in { $handler } öffnen
    .accesskey = m

##

# We can use the same accesskey as downloads-cmd-always-use-system-default.
# Both should not be visible in the downloads context menu at the same time.
downloads-cmd-always-open-similar-files =
    .label = Ähnliche Dateien immer öffnen
    .accesskey = i

downloads-cmd-show-button-2 =
    .tooltiptext =
        { PLATFORM() ->
            [macos] Im Finder anzeigen
           *[other] In Ordner anzeigen
        }

downloads-cmd-show-panel-2 =
    .aria-label =
        { PLATFORM() ->
            [macos] Im Finder anzeigen
           *[other] In Ordner anzeigen
        }
downloads-cmd-show-description-2 =
    .value =
        { PLATFORM() ->
            [macos] Im Finder anzeigen
           *[other] In Ordner anzeigen
        }

downloads-cmd-show-downloads =
    .label = Ordner "Downloads" öffnen
downloads-cmd-retry =
    .tooltiptext = Nochmals versuchen
downloads-cmd-retry-panel =
    .aria-label = Nochmals versuchen
downloads-cmd-go-to-download-page =
    .label = Zur Download-Seite gehen
    .accesskey = g
downloads-cmd-copy-download-link =
    .label = Download-Link kopieren
    .accesskey = D
downloads-cmd-remove-from-history =
    .label = Aus Chronik entfernen
    .accesskey = e
downloads-cmd-clear-list =
    .label = Schnellzugriffsliste leeren
    .accesskey = S
downloads-cmd-clear-downloads =
    .label = Liste leeren
    .accesskey = L
downloads-cmd-delete-file =
    .label = Löschen
    .accesskey = L

# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = Zugriff erlauben
    .accesskey = a

# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = Datei löschen

downloads-cmd-remove-file-panel =
    .aria-label = Datei löschen

# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = Datei löschen oder Download erlauben

downloads-cmd-choose-unblock-panel =
    .aria-label = Datei löschen oder Download erlauben

# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = Datei öffnen oder löschen

downloads-cmd-choose-open-panel =
    .aria-label = Datei öffnen oder löschen

# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = Weitere Informationen anzeigen

# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = Datei öffnen

## Displayed when the user clicked on a download in process. Indicates that the
## downloading file will be opened after certain amount of time using an app
## available in the system.
## Variables:
##   $hours (number) - Amount of hours left till the file opens.
##   $seconds (number) - Amount of seconds left till the file opens.
##   $minutes (number) - Amount of minutes till the file opens.

downloading-file-opens-in-hours-and-minutes = Wird in { $hours }h { $minutes }m geöffnet…
downloading-file-opens-in-minutes = Wird in { $minutes }m geöffnet…
downloading-file-opens-in-minutes-and-seconds = Wird in { $minutes }m { $seconds }s geöffnet…
downloading-file-opens-in-seconds = Wird in { $seconds }s geöffnet…
downloading-file-opens-in-some-time = Wird nach Abschluss geöffnet…
downloading-file-click-to-open =
    .value = Nach Abschluss öffnen

##

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = Download erneut versuchen

# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = Download abbrechen

# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = Alle Downloads anzeigen
    .accesskey = w

# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = Download-Informationen

## Displayed when a site attempts to automatically download many files.
## Variables:
##   $num (number) - Number of blocked downloads.
##   $url (string) - The url of the suspicious site, stripped of http, https and www prefix.

downloads-files-not-downloaded =
    { $num ->
        [one] Datei nicht heruntergeladen.
       *[other] { $num } Dateien nicht heruntergeladen.
    }
downloads-blocked-from-url = Downloads von { $url } blockiert.
downloads-blocked-download-detailed-info = { $url } hat versucht, mehrere Dateien automatisch herunterzuladen. Die Website könnte defekt sein oder versuchen, Spam-Dateien auf Ihrem Gerät zu speichern.

##

downloads-clear-downloads-button =
    .label = Liste leeren
    .tooltiptext = Entfernt abgeschlossene, abgebrochene und fehlgeschlagene Downloads aus der Liste

# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = Keine Downloads vorhanden

# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = Keine Downloads in dieser Sitzung

# This is displayed in an item at the bottom of the Downloads Panel when there
# are more downloads than can fit in the list in the panel.
#   $count (number) - number of files being downloaded that are not shown in the
#                     panel list.
downloads-more-downloading =
    { $count ->
        [one] { $count } weitere Datei wird heruntergeladen
       *[other] { $count } weitere Dateien werden heruntergeladen
    }
