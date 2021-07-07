# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = Λήψεις
downloads-panel =
    .aria-label = Λήψεις

##

# The style attribute has the width of the Downloads Panel expressed using
# a CSS unit. The longest labels that should fit are usually those of
# in-progress and blocked downloads.
downloads-panel-list =
    .style = width: 70ch
# The style attribute has the width of the Downloads Panel expressed using
# a CSS unit. The longest labels that should fit are usually those of
# in-progress and blocked downloads.
downloads-panel-items =
    .style = width: 35em
downloads-cmd-pause =
    .label = Παύση
    .accesskey = Π
downloads-cmd-resume =
    .label = Συνέχεια
    .accesskey = ν
downloads-cmd-cancel =
    .tooltiptext = Ακύρωση
downloads-cmd-cancel-panel =
    .aria-label = Ακύρωση
# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = Άνοιγμα φακέλου λήψης
    .accesskey = φ
# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = Εμφάνιση στο Finder
    .accesskey = μ
downloads-cmd-use-system-default =
    .label = Άνοιγμα με το πρόγραμμα προβολής συστήματος
    .accesskey = π
downloads-cmd-always-use-system-default =
    .label = Άνοιγμα πάντα με το πρόγραμμα προβολής συστήματος
    .accesskey = ν
downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] Προβολή στο Finder
           *[other] Άνοιγμα φακέλου λήψης
        }
downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] Προβολή στο Finder
           *[other] Άνοιγμα φακέλου λήψης
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] Προβολή στο Finder
           *[other] Άνοιγμα φακέλου λήψης
        }
downloads-cmd-show-downloads =
    .label = Εμφάνιση φακέλου λήψεων
downloads-cmd-retry =
    .tooltiptext = Επανάληψη
downloads-cmd-retry-panel =
    .aria-label = Επανάληψη
downloads-cmd-go-to-download-page =
    .label = Μετάβαση στη σελίδα λήψης
    .accesskey = β
downloads-cmd-copy-download-link =
    .label = Αντιγραφή συνδέσμου λήψης
    .accesskey = δ
downloads-cmd-remove-from-history =
    .label = Αφαίρεση από το ιστορικό
    .accesskey = ι
downloads-cmd-clear-list =
    .label = Απαλοιφή περιοχής προεπισκόπησης
    .accesskey = κ
downloads-cmd-clear-downloads =
    .label = Απαλοιφή λήψεων
    .accesskey = λ
# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = Αποδοχή λήψης
    .accesskey = α
# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = Διαγραφή αρχείου
downloads-cmd-remove-file-panel =
    .aria-label = Διαγραφή αρχείου
# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = Διαγραφή αρχείου ή αποδοχή λήψης
downloads-cmd-choose-unblock-panel =
    .aria-label = Διαγραφή αρχείου ή αποδοχή λήψης
# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = Άνοιγμα ή αφαίρεση αρχείου
downloads-cmd-choose-open-panel =
    .aria-label = Άνοιγμα ή αφαίρεση αρχείου
# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = Εμφάνιση περισσότερων πληροφοριών
# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = Άνοιγμα αρχείου

## Displayed when the user clicked on a download in process. Indicates that the
## downloading file will be opened after certain amount of time using an app
## available in the system.
## Variables:
##   $hours (number) - Amount of hours left till the file opens.
##   $seconds (number) - Amount of seconds left till the file opens.
##   $minutes (number) - Amount of minutes till the file opens.

downloading-file-opens-in-hours-and-minutes = Άνοιγμα σε { $hours }ώ { $minutes }λ…
downloading-file-opens-in-minutes = Άνοιγμα σε { $minutes }λ…
downloading-file-opens-in-minutes-and-seconds = Άνοιγμα σε { $minutes }λ { $seconds }δ…
downloading-file-opens-in-seconds = Άνοιγμα σε { $seconds }δ…
downloading-file-opens-in-some-time = Άνοιγμα όταν ολοκληρωθεί…

##

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = Επανάληψη λήψης
# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = Ακύρωση λήψης
# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = Εμφάνιση όλων των λήψεων
    .accesskey = Ε
# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = Λεπτομέρειες λήψης
downloads-clear-downloads-button =
    .label = Απαλοιφή λήψεων
    .tooltiptext = Διαγράφει τις ολοκληρωμένες, ακυρωμένες και αποτυχημένες λήψεις
# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = Δεν υπάρχουν λήψεις.
# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = Καμία λήψη για αυτήν τη συνεδρία.
