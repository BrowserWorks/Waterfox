# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = Filhentning
downloads-panel =
    .aria-label = Filhentning

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
    .label = Genoptag
    .accesskey = G
downloads-cmd-cancel =
    .tooltiptext = Annuller
downloads-cmd-cancel-panel =
    .aria-label = Annuller

downloads-cmd-show-menuitem-2 =
    .label =
        { PLATFORM() ->
            [macos] Vis i Finder
           *[other] Vis i mappe
        }
    .accesskey = V

## Displayed in the downloads context menu for files that can be opened.
## Variables:
##   $handler (String) - The name of the mime type's default file handler.
##   Example: "Notepad", "Acrobat Reader DC", "7-Zip File Manager"

downloads-cmd-use-system-default =
    .label = Åbn i systemets standard-program
    .accesskey = s
# This version is shown when the download's mime type has a valid file handler.
downloads-cmd-use-system-default-named =
    .label = Åbn i { $handler }
    .accesskey = n

# We can use the same accesskey as downloads-cmd-always-open-similar-files.
# Both should not be visible in the downloads context menu at the same time.
downloads-cmd-always-use-system-default =
    .label = Åbn altid i systemets standard-program
    .accesskey = a
# We can use the same accesskey as downloads-cmd-always-open-similar-files.
# Both should not be visible in the downloads context menu at the same time.
# This version is shown when the download's mime type has a valid file handler.
downloads-cmd-always-use-system-default-named =
    .label = Åben altid i { $handler }
    .accesskey = a

##

# We can use the same accesskey as downloads-cmd-always-use-system-default.
# Both should not be visible in the downloads context menu at the same time.
downloads-cmd-always-open-similar-files =
    .label = Åbn altid lignende filer
    .accesskey = a

downloads-cmd-show-button-2 =
    .tooltiptext =
        { PLATFORM() ->
            [macos] Vis i Finder
           *[other] Vis i mappe
        }

downloads-cmd-show-panel-2 =
    .aria-label =
        { PLATFORM() ->
            [macos] Vis i Finder
           *[other] Vis i mappe
        }
downloads-cmd-show-description-2 =
    .value =
        { PLATFORM() ->
            [macos] Vis i Finder
           *[other] Vis i mappe
        }

downloads-cmd-show-downloads =
    .label = Vis filhentnings-mappen
downloads-cmd-retry =
    .tooltiptext = Prøv igen
downloads-cmd-retry-panel =
    .aria-label = Prøv igen
downloads-cmd-go-to-download-page =
    .label = Gå til siden, filen blev hentet fra
    .accesskey = G
downloads-cmd-copy-download-link =
    .label = Kopier linkadresse
    .accesskey = K
downloads-cmd-remove-from-history =
    .label = Fjern fra historik
    .accesskey = F
downloads-cmd-clear-list =
    .label = Ryd liste
    .accesskey = R
downloads-cmd-clear-downloads =
    .label = Ryd filhentninger
    .accesskey = f
downloads-cmd-delete-file =
    .label = Slet
    .accesskey = S

# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = Tillad filhentning
    .accesskey = T

# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = Fjern fil

downloads-cmd-remove-file-panel =
    .aria-label = Fjern fil

# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = Fjern fil eller tillad filhentning

downloads-cmd-choose-unblock-panel =
    .aria-label = Fjern fil eller tillad filhentning

# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = Åbn eller fjern fil

downloads-cmd-choose-open-panel =
    .aria-label = Åbn eller fjern fil

# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = Vis mere information

# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = Åbn fil

## Displayed when the user clicked on a download in process. Indicates that the
## downloading file will be opened after certain amount of time using an app
## available in the system.
## Variables:
##   $hours (number) - Amount of hours left till the file opens.
##   $seconds (number) - Amount of seconds left till the file opens.
##   $minutes (number) - Amount of minutes till the file opens.

downloading-file-opens-in-hours-and-minutes = Åbnes om { $hours } t. og { $minutes } m…
downloading-file-opens-in-minutes = Åbnes om { $minutes } m…
downloading-file-opens-in-minutes-and-seconds = Åbnes om { $minutes } m. og { $seconds } s…
downloading-file-opens-in-seconds = Åbnes om { $seconds } s…
downloading-file-opens-in-some-time = Åbnes når afsluttet…
downloading-file-click-to-open =
    .value = Åbnes når afsluttet

##

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = Start filhentning igen

# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = Annuller filhentning

# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = Vis alle filhentninger
    .accesskey = V

# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = Detaljer om filhentning

## Displayed when a site attempts to automatically download many files.
## Variables:
##   $num (number) - Number of blocked downloads.
##   $url (string) - The url of the suspicious site, stripped of http, https and www prefix.

downloads-files-not-downloaded =
    { $num ->
        [one] Filen blev ikke hentet.
       *[other] { $num } filer blev ikke hentet.
    }
downloads-blocked-from-url = Filhentning fra { $url } blev blokeret.
downloads-blocked-download-detailed-info = { $url } forsøgte at hente adskillige filer automatisk. Webstedet kan være gået i stykker eller forsøger at gemme spam-filer på din enhed.

##

downloads-clear-downloads-button =
    .label = Ryd filhentninger
    .tooltiptext = Fjerner afsluttede, afbrudte og mislykkedes filhentninger

# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = Der er ingen filhentninger.

# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = Ingen filhentninger for denne session.

# This is displayed in an item at the bottom of the Downloads Panel when there
# are more downloads than can fit in the list in the panel.
#   $count (number) - number of files being downloaded that are not shown in the
#                     panel list.
downloads-more-downloading =
    { $count ->
        [one] { $count } fil til hentes
       *[other] { $count } filer til hentes
    }
