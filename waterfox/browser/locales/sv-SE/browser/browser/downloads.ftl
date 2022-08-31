# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = Filhämtningar
downloads-panel =
    .aria-label = Filhämtningar

##

# The style attribute has the width of the Downloads Panel expressed using
# a CSS unit. The longest labels that should fit are usually those of
# in-progress and blocked downloads.
downloads-panel-items =
    .style = width: 35em

downloads-cmd-pause =
    .label = Pausa
    .accesskey = P
downloads-cmd-resume =
    .label = Återuppta
    .accesskey = Å
downloads-cmd-cancel =
    .tooltiptext = Avbryt
downloads-cmd-cancel-panel =
    .aria-label = Avbryt

downloads-cmd-show-menuitem-2 =
    .label =
        { PLATFORM() ->
            [macos] Visa i Finder
           *[other] Visa i mapp
        }
    .accesskey = V

## Displayed in the downloads context menu for files that can be opened.
## Variables:
##   $handler (String) - The name of the mime type's default file handler.
##   Example: "Notepad", "Acrobat Reader DC", "7-Zip File Manager"

downloads-cmd-use-system-default =
    .label = Öppna i systemvisaren
    .accesskey = s
# This version is shown when the download's mime type has a valid file handler.
downloads-cmd-use-system-default-named =
    .label = Öppna i { $handler }
    .accesskey = p

# We can use the same accesskey as downloads-cmd-always-open-similar-files.
# Both should not be visible in the downloads context menu at the same time.
downloads-cmd-always-use-system-default =
    .label = Öppna alltid i systemvisaren
    .accesskey = a
# We can use the same accesskey as downloads-cmd-always-open-similar-files.
# Both should not be visible in the downloads context menu at the same time.
# This version is shown when the download's mime type has a valid file handler.
downloads-cmd-always-use-system-default-named =
    .label = Öppna alltid i { $handler }
    .accesskey = a

##

# We can use the same accesskey as downloads-cmd-always-use-system-default.
# Both should not be visible in the downloads context menu at the same time.
downloads-cmd-always-open-similar-files =
    .label = Öppna alltid liknande filer
    .accesskey = a

downloads-cmd-show-button-2 =
    .tooltiptext =
        { PLATFORM() ->
            [macos] Visa i Finder
           *[other] Visa i mapp
        }

downloads-cmd-show-panel-2 =
    .aria-label =
        { PLATFORM() ->
            [macos] Visa i Finder
           *[other] Visa i mapp
        }
downloads-cmd-show-description-2 =
    .value =
        { PLATFORM() ->
            [macos] Visa i Finder
           *[other] Visa i mapp
        }

downloads-cmd-show-downloads =
    .label = Visa mapp för hämtade filer
downloads-cmd-retry =
    .tooltiptext = Försök igen
downloads-cmd-retry-panel =
    .aria-label = Försök igen
downloads-cmd-go-to-download-page =
    .label = Gå till hämtningssidan
    .accesskey = G
downloads-cmd-copy-download-link =
    .label = Kopiera filhämtningslänk
    .accesskey = K
downloads-cmd-remove-from-history =
    .label = Ta bort från historik
    .accesskey = T
downloads-cmd-clear-list =
    .label = Rensa förhandsgranskningspanelen
    .accesskey = R
downloads-cmd-clear-downloads =
    .label = Rensa hämtningar
    .accesskey = h
downloads-cmd-delete-file =
    .label = Ta bort
    .accesskey = T

# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = Tillåt hämtning
    .accesskey = m

# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = Ta bort fil

downloads-cmd-remove-file-panel =
    .aria-label = Ta bort fil

# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = Ta bort fil eller tillåt hämtning

downloads-cmd-choose-unblock-panel =
    .aria-label = Ta bort fil eller tillåt hämtning

# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = Öppna eller ta bort fil

downloads-cmd-choose-open-panel =
    .aria-label = Öppna eller ta bort fil

# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = Visa mer information

# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = Öppna fil

## Displayed when the user clicked on a download in process. Indicates that the
## downloading file will be opened after certain amount of time using an app
## available in the system.
## Variables:
##   $hours (number) - Amount of hours left till the file opens.
##   $seconds (number) - Amount of seconds left till the file opens.
##   $minutes (number) - Amount of minutes till the file opens.

downloading-file-opens-in-hours-and-minutes = Öppnar om { $hours }t { $minutes }m…
downloading-file-opens-in-minutes = Öppnar om { $minutes }m…
downloading-file-opens-in-minutes-and-seconds = Öppnar om { $minutes }m { $seconds }s…
downloading-file-opens-in-seconds = Öppnar om { $seconds }s…
downloading-file-opens-in-some-time = Öppnar när det är klart…
downloading-file-click-to-open =
    .value = Öppna när den är klar

##

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = Försök hämta igen

# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = Avbryt hämtning

# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = Visa alla hämtningar
    .accesskey = V

# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = Nedladdningsdetaljer

## Displayed when a site attempts to automatically download many files.
## Variables:
##   $num (number) - Number of blocked downloads.
##   $url (string) - The url of the suspicious site, stripped of http, https and www prefix.

downloads-files-not-downloaded =
    { $num ->
        [one] Filen har inte laddats ner.
       *[other] { $num } filer har inte laddats ned.
    }
downloads-blocked-from-url = Nedladdningar blockerade från { $url }.
downloads-blocked-download-detailed-info = { $url } försökte ladda ner flera filer automatiskt. Webbplatsen kan vara trasig eller försöka lagra skräppostfiler på din enhet.

##

downloads-clear-downloads-button =
    .label = Rensa hämtningar
    .tooltiptext = Rensar bort slutförda, avbrutna och misslyckade hämtningar

# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = Det finns inga hämtningar.

# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = Inga nedladdningar för denna session.

# This is displayed in an item at the bottom of the Downloads Panel when there
# are more downloads than can fit in the list in the panel.
#   $count (number) - number of files being downloaded that are not shown in the
#                     panel list.
downloads-more-downloading =
    { $count ->
        [one] { $count } fil till laddas ned
       *[other] { $count } filer till laddas ned
    }
