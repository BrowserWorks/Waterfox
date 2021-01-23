# This Source Code Form is subject to the terms of the Mozilla Public
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
downloads-panel-list =
    .style = width: 70ch

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

# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = Åbn hentningsmappe
    .accesskey = h

# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = Vis i Finder
    .accesskey = V

downloads-cmd-use-system-default =
  .label = Åbn i systemets standard-program
  .accesskey = s

downloads-cmd-always-use-system-default =
  .label = Åbn altid i systemets standard-program
  .accesskey = a

downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] Vis i Finder
           *[other] Åbn hentningsmappe
        }

downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] Vis i Finder
           *[other] Åbn hentningsmappe
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] Vis i Finder
           *[other] Åbn hentningsmappe
        }

downloads-cmd-show-downloads =
    .label = Vis filhentnings-mappen
downloads-cmd-retry =
    .tooltiptext = Prøv igen
downloads-cmd-retry-panel =
    .aria-label = Prøv igen
downloads-cmd-go-to-download-page =
    .label = Gå til siden, filen blev hentet fra
    .accesskey = t
downloads-cmd-copy-download-link =
    .label = Kopier linkadresse
    .accesskey = K
downloads-cmd-remove-from-history =
    .label = Fjern fra historik
    .accesskey = e
downloads-cmd-clear-list =
    .label = Ryd liste
    .accesskey = R
downloads-cmd-clear-downloads =
    .label = Ryd filhentninger
    .accesskey = f

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
