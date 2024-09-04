# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

tabbrowser-empty-tab-title = Νέα καρτέλα
tabbrowser-empty-private-tab-title = Νέα ιδιωτική καρτέλα

tabbrowser-menuitem-close-tab =
    .label = Κλείσιμο καρτέλας
tabbrowser-menuitem-close =
    .label = Κλείσιμο

# Displayed as a tooltip on container tabs
# Variables:
#   $title (String): the title of the current tab.
#   $containerName (String): the name of the current container.
tabbrowser-container-tab-title = { $title } — { $containerName }

# Variables:
#   $tabCount (Number): The number of tabs that will be closed.
tabbrowser-close-tabs-tooltip =
    .label =
        { $tabCount ->
            [one] Κλείσιμο καρτέλας
           *[other] Κλείσιμο { $tabCount } καρτελών
        }

## Tooltips for tab audio control
## Variables:
##   $tabCount (Number): The number of tabs that will be affected.

# Variables:
#   $shortcut (String): The keyboard shortcut for "Mute tab".
tabbrowser-mute-tab-audio-tooltip =
    .label =
        { $tabCount ->
            [one] Σίγαση καρτέλας ({ $shortcut })
           *[other] Σίγαση { $tabCount } καρτελών ({ $shortcut })
        }
# Variables:
#   $shortcut (String): The keyboard shortcut for "Unmute tab".
tabbrowser-unmute-tab-audio-tooltip =
    .label =
        { $tabCount ->
            [one] Άρση σίγασης καρτέλας ({ $shortcut })
           *[other] Άρση σίγασης { $tabCount } καρτελών ({ $shortcut })
        }
tabbrowser-mute-tab-audio-background-tooltip =
    .label =
        { $tabCount ->
            [one] Σίγαση καρτέλας
           *[other] Σίγαση { $tabCount } καρτελών
        }
tabbrowser-unmute-tab-audio-background-tooltip =
    .label =
        { $tabCount ->
            [one] Άρση σίγασης καρτέλας
           *[other] Άρση σίγασης { $tabCount } καρτελών
        }
tabbrowser-unblock-tab-audio-tooltip =
    .label =
        { $tabCount ->
            [one] Αναπαραγωγή καρτέλας
           *[other] Αναπαραγωγή { $tabCount } καρτελών
        }

## Confirmation dialog when closing a window with more than one tab open,
## or when quitting when only one window is open.

# The singular form is not considered since this string is used only for multiple tabs.
# Variables:
#   $tabCount (Number): The number of tabs that will be closed.
tabbrowser-confirm-close-tabs-title = Κλείσιμο { $tabCount } καρτελών;
tabbrowser-confirm-close-tabs-button = Κλείσιμο καρτελών
tabbrowser-confirm-close-tabs-checkbox = Επιβεβαίωση πριν από το κλείσιμο πολλαπλών καρτελών

## Confirmation dialog when quitting using the menu and multiple windows are open.

# The forms for 0 or 1 items are not considered since this string is used only for
# multiple windows.
# Variables:
#   $windowCount (Number): The number of windows that will be closed.
tabbrowser-confirm-close-windows-title = Κλείσιμο { $windowCount } παραθύρων;
tabbrowser-confirm-close-windows-button =
    { PLATFORM() ->
        [windows] Κλείσιμο και έξοδος
       *[other] Κλείσιμο και έξοδος
    }

## Confirmation dialog when quitting using the keyboard shortcut (Ctrl/Cmd+Q)
## Windows does not show a prompt on quit when using the keyboard shortcut by default.

tabbrowser-confirm-close-tabs-with-key-title = Κλείσιμο παραθύρου και έξοδος από το { -brand-short-name };
tabbrowser-confirm-close-tabs-with-key-button = Έξοδος από το { -brand-short-name }
# Variables:
#   $quitKey (String): the text of the keyboard shortcut for quitting.
tabbrowser-confirm-close-tabs-with-key-checkbox = Επιβεβαίωση πριν από την έξοδο με { $quitKey }

## Confirmation dialog when opening multiple tabs simultaneously

tabbrowser-confirm-open-multiple-tabs-title = Επιβεβαίωση ανοίγματος
# Variables:
#   $tabCount (Number): The number of tabs that will be opened.
tabbrowser-confirm-open-multiple-tabs-message =
    { $tabCount ->
       *[other] Πρόκειται να ανοίξετε { $tabCount } καρτέλες. Αυτό πιθανόν να επιβραδύνει το { -brand-short-name } κατά τη φόρτωση των σελίδων. Θέλετε σίγουρα να συνεχίσετε;
    }
tabbrowser-confirm-open-multiple-tabs-button = Άνοιγμα καρτελών
tabbrowser-confirm-open-multiple-tabs-checkbox = Προειδοποίηση όταν το άνοιγμα πολλαπλών καρτελών ενδέχεται να επιβραδύνει το { -brand-short-name }

## Confirmation dialog for enabling caret browsing

tabbrowser-confirm-caretbrowsing-title = Περιήγηση με κέρσορα
tabbrowser-confirm-caretbrowsing-message = Πατώντας το F7 (απ)ενεργοποιείται η περιήγηση με κέρσορα. Αυτή η λειτουργία προβάλλει έναν κινούμενο κέρσορα στις ιστοσελίδες και σας επιτρέπει να επιλέγετε κείμενο με το πληκτρολόγιο. Θέλετε να ενεργοποιήσετε την περιήγηση με κέρσορα;
tabbrowser-confirm-caretbrowsing-checkbox = Να μην εμφανιστεί αυτός ο διάλογος ξανά.

##

# Variables:
#   $domain (String): URL of the page that is trying to steal focus.
tabbrowser-allow-dialogs-to-get-focus =
    .label = Να επιτρέπεται σε ειδοποιήσεις του { $domain } να σας μεταφέρουν στην καρτέλα τους

tabbrowser-customizemode-tab-title = Προσαρμογή του { -brand-short-name }

## Context menu buttons, of which only one will be visible at a time

tabbrowser-context-mute-tab =
    .label = Σίγαση καρτέλας
    .accesskey = σ
tabbrowser-context-unmute-tab =
    .label = Άρση σίγασης καρτέλας
    .accesskey = σ
# The accesskey should match the accesskey for tabbrowser-context-mute-tab
tabbrowser-context-mute-selected-tabs =
    .label = Σίγαση καρτελών
    .accesskey = Σ
# The accesskey should match the accesskey for tabbrowser-context-unmute-tab
tabbrowser-context-unmute-selected-tabs =
    .label = Αναίρεση σίγασης καρτελών
    .accesskey = ν

# This string is used as an additional tooltip and accessibility description for tabs playing audio
tabbrowser-tab-audio-playing-description = Αναπαραγωγή ήχου

## Ctrl-Tab dialog

# Variables:
#   $tabCount (Number): The number of tabs in the current browser window. It will always be 2 at least.
tabbrowser-ctrl-tab-list-all-tabs =
    .label = Παράθεση και των { $tabCount } καρτελών

## Tab manager menu buttons

tabbrowser-manager-mute-tab =
    .tooltiptext = Σίγαση καρτέλας
tabbrowser-manager-unmute-tab =
    .tooltiptext = Άρση σίγασης καρτέλας
tabbrowser-manager-close-tab =
    .tooltiptext = Κλείσιμο καρτέλας
