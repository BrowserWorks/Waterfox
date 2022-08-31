# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = Pobierane pliki
downloads-panel =
    .aria-label = Pobierane pliki

##

# The style attribute has the width of the Downloads Panel expressed using
# a CSS unit. The longest labels that should fit are usually those of
# in-progress and blocked downloads.
downloads-panel-items =
    .style = width: 35em

downloads-cmd-pause =
    .label = Wstrzymaj
    .accesskey = W
downloads-cmd-resume =
    .label = Wznów
    .accesskey = z
downloads-cmd-cancel =
    .tooltiptext = Anuluj
downloads-cmd-cancel-panel =
    .aria-label = Anuluj

downloads-cmd-show-menuitem-2 =
    .label =
        { PLATFORM() ->
            [macos] Pokaż w Finderze
           *[other] Pokaż w folderze
        }
    .accesskey = P

## Displayed in the downloads context menu for files that can be opened.
## Variables:
##   $handler (String) - The name of the mime type's default file handler.
##   Example: "Notepad", "Acrobat Reader DC", "7-Zip File Manager"

downloads-cmd-use-system-default =
    .label = Otwórz w przeglądarce systemowej
    .accesskey = O
# This version is shown when the download's mime type has a valid file handler.
downloads-cmd-use-system-default-named =
    .label = Otwórz w programie { $handler }
    .accesskey = O

# We can use the same accesskey as downloads-cmd-always-open-similar-files.
# Both should not be visible in the downloads context menu at the same time.
downloads-cmd-always-use-system-default =
    .label = Zawsze otwieraj w przeglądarce systemowej
    .accesskey = Z
# We can use the same accesskey as downloads-cmd-always-open-similar-files.
# Both should not be visible in the downloads context menu at the same time.
# This version is shown when the download's mime type has a valid file handler.
downloads-cmd-always-use-system-default-named =
    .label = Zawsze otwieraj w programie { $handler }
    .accesskey = w

##

# We can use the same accesskey as downloads-cmd-always-use-system-default.
# Both should not be visible in the downloads context menu at the same time.
downloads-cmd-always-open-similar-files =
    .label = Zawsze otwieraj podobne pliki
    .accesskey = w

downloads-cmd-show-button-2 =
    .tooltiptext =
        { PLATFORM() ->
            [macos] Pokaż w Finderze
           *[other] Pokaż w folderze
        }

downloads-cmd-show-panel-2 =
    .aria-label =
        { PLATFORM() ->
            [macos] Pokaż w Finderze
           *[other] Pokaż w folderze
        }
downloads-cmd-show-description-2 =
    .value =
        { PLATFORM() ->
            [macos] Pokaż w Finderze
           *[other] Pokaż w folderze
        }

downloads-cmd-show-downloads =
    .label = Pokaż folder z pobranymi
downloads-cmd-retry =
    .tooltiptext = Spróbuj ponownie
downloads-cmd-retry-panel =
    .aria-label = Spróbuj ponownie
downloads-cmd-go-to-download-page =
    .label = Przejdź do strony pobierania
    .accesskey = s
downloads-cmd-copy-download-link =
    .label = Kopiuj adres, z którego pobrano plik
    .accesskey = K
downloads-cmd-remove-from-history =
    .label = Usuń z historii
    .accesskey = h
downloads-cmd-clear-list =
    .label = Wyczyść listę
    .accesskey = c
downloads-cmd-clear-downloads =
    .label = Wyczyść listę
    .accesskey = c
downloads-cmd-delete-file =
    .label = Usuń plik z dysku
    .accesskey = U

# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = Pozwól pobrać
    .accesskey = P

# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = Usuń plik

downloads-cmd-remove-file-panel =
    .aria-label = Usuń plik

# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = Usuń plik lub pozwól go pobrać

downloads-cmd-choose-unblock-panel =
    .aria-label = Usuń plik lub pozwól go pobrać

# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = Otwórz lub usuń plik

downloads-cmd-choose-open-panel =
    .aria-label = Otwórz lub usuń plik

# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = Wyświetl więcej informacji

# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = Otwórz plik

## Displayed when the user clicked on a download in process. Indicates that the
## downloading file will be opened after certain amount of time using an app
## available in the system.
## Variables:
##   $hours (number) - Amount of hours left till the file opens.
##   $seconds (number) - Amount of seconds left till the file opens.
##   $minutes (number) - Amount of minutes till the file opens.

downloading-file-opens-in-hours-and-minutes = Otwieranie za { $hours } godz. { $minutes } min…
downloading-file-opens-in-minutes = Otwieranie za { $minutes } min…
downloading-file-opens-in-minutes-and-seconds = Otwieranie za { $minutes } min { $seconds } s…
downloading-file-opens-in-seconds = Otwieranie za { $seconds } s…
downloading-file-opens-in-some-time = Otwieranie po ukończeniu…
downloading-file-click-to-open =
    .value = Otwórz po ukończeniu

##

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = Pobierz ponownie

# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = Anuluj pobieranie

# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = Wyświetl wszystkie
    .accesskey = W

# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = Szczegóły pobieranego pliku

## Displayed when a site attempts to automatically download many files.
## Variables:
##   $num (number) - Number of blocked downloads.
##   $url (string) - The url of the suspicious site, stripped of http, https and www prefix.

downloads-files-not-downloaded =
    { $num ->
        [one] Nie pobrano pliku.
        [few] Nie pobrano { $num } plików.
       *[many] Nie pobrano { $num } plików.
    }
downloads-blocked-from-url = Zablokowano pobieranie z witryny { $url }.
downloads-blocked-download-detailed-info = Witryna { $url } próbowała automatycznie pobrać wiele plików. Może ona źle działać lub próbować pobrać niechciane pliki na komputer.

##

downloads-clear-downloads-button =
    .label = Wyczyść listę
    .tooltiptext = Ukończone, anulowane i nieudane pobierania zostaną usunięte

# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = Brak pobranych plików

# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = Brak pobranych podczas tej sesji.

# This is displayed in an item at the bottom of the Downloads Panel when there
# are more downloads than can fit in the list in the panel.
#   $count (number) - number of files being downloaded that are not shown in the
#                     panel list.
downloads-more-downloading =
    { $count ->
        [one] Pobierany jest jeszcze jeden plik
        [few] Pobierane są jeszcze { $count } pliki
       *[many] Pobieranych jest jeszcze { $count } plików
    }
