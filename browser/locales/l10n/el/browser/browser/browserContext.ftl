# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] Τραβήξτε προς στα κάτω για εμφάνιση του ιστορικού
           *[other] Κάντε δεξί κλικ ή τραβήξτε προς τα κάτω για εμφάνιση του ιστορικού
        }

## Back

# Variables
#   $shortcut (String) - A keyboard shortcut for the Go Back command.
main-context-menu-back-2 =
    .tooltiptext = Μετάβαση μία σελίδα πίσω ({ $shortcut })
    .aria-label = Πίσω
    .accesskey = Π

# This menuitem is only visible on macOS
main-context-menu-back-mac =
    .label = Πίσω
    .accesskey = Π

navbar-tooltip-back-2 =
    .value = { main-context-menu-back-2.tooltiptext }

toolbar-button-back-2 =
    .label = { main-context-menu-back-2.aria-label }

## Forward

# Variables
#   $shortcut (String) - A keyboard shortcut for the Go Forward command.
main-context-menu-forward-2 =
    .tooltiptext = Μετάβαση μία σελίδα μπροστά ({ $shortcut })
    .aria-label = Μπροστά
    .accesskey = Μ

# This menuitem is only visible on macOS
main-context-menu-forward-mac =
    .label = Μπροστά
    .accesskey = Μ

navbar-tooltip-forward-2 =
    .value = { main-context-menu-forward-2.tooltiptext }

toolbar-button-forward-2 =
    .label = { main-context-menu-forward-2.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = Ανανέωση
    .accesskey = Α

# This menuitem is only visible on macOS
main-context-menu-reload-mac =
    .label = Ανανέωση
    .accesskey = Α

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = Διακοπή
    .accesskey = Δ

# This menuitem is only visible on macOS
main-context-menu-stop-mac =
    .label = Διακοπή
    .accesskey = Δ

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Waterfox Account Button

toolbar-button-fxaccount =
    .label = { -fxaccount-brand-name }
    .tooltiptext = { -fxaccount-brand-name }

## Save Page

main-context-menu-page-save =
    .label = Αποθήκευση σελίδας ως…
    .accesskey = λ

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = Δημιουργία σελιδοδείκτη
    .accesskey = δ
    .tooltiptext = Δημιουργία σελιδοδείκτη για αυτήν τη σελίδα

# This menuitem is only visible on macOS
# Cannot be shown at the same time as main-context-menu-bookmark-edit-mac,
# so should probably have the same access key if possible.
main-context-menu-bookmark-add-mac =
    .label = Προσθήκη σελιδοδείκτη
    .accesskey = λ

# This menuitem is only visible on macOS
# Cannot be shown at the same time as main-context-menu-bookmark-add-mac,
# so should probably have the same access key if possible.
main-context-menu-bookmark-edit-mac =
    .label = Επεξεργασία σελιδοδείκτη
    .accesskey = ξ

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = Δημιουργία σελιδοδείκτη
    .accesskey = δ
    .tooltiptext = Δημιουργία σελιδοδείκτη για αυτήν τη σελίδα ({ $shortcut })

main-context-menu-bookmark-change =
    .aria-label = Επεξεργασία σελιδοδείκτη
    .accesskey = δ
    .tooltiptext = Επεξεργασία σελιδοδείκτη

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = Επεξεργασία σελιδοδείκτη
    .accesskey = δ
    .tooltiptext = Επεξεργασία σελιδοδείκτη ({ $shortcut })

main-context-menu-open-link =
    .label = Άνοιγμα συνδέσμου
    .accesskey = ο

main-context-menu-open-link-new-tab =
    .label = Άνοιγμα συνδέσμου σε νέα καρτέλα
    .accesskey = τ

main-context-menu-open-link-container-tab =
    .label = Άνοιγμα συνδέσμου σε νέα θεματική καρτέλα
    .accesskey = κ

main-context-menu-open-link-new-window =
    .label = Άνοιγμα συνδέσμου σε νέο παράθυρο
    .accesskey = δ

main-context-menu-open-link-new-private-window =
    .label = Άνοιγμα συνδέσμου σε νέο ιδιωτικό παράθυρο
    .accesskey = δ

main-context-menu-bookmark-link =
    .label = Προσθήκη σελιδοδείκτη συνδέσμου
    .accesskey = κ

main-context-menu-save-link =
    .label = Αποθήκευση συνδέσμου ως…
    .accesskey = θ

main-context-menu-save-link-to-pocket =
    .label = Αποθήκευση συνδέσμου στο { -pocket-brand-name }
    .accesskey = o

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.


## The access keys for "Copy Link" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = Αντιγραφή διεύθυνσης email
    .accesskey = Ε

main-context-menu-copy-link-simple =
    .label = Αντιγραφή συνδέσμου
    .accesskey = σ

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = Αναπαραγωγή
    .accesskey = π

main-context-menu-media-pause =
    .label = Παύση
    .accesskey = η

##

main-context-menu-media-mute =
    .label = Σίγαση
    .accesskey = Σ

main-context-menu-media-unmute =
    .label = Άρση σίγασης
    .accesskey = ρ

main-context-menu-media-play-speed-2 =
    .label = Ταχύτητα
    .accesskey = χ

main-context-menu-media-play-speed-slow-2 =
    .label = 0.5×

main-context-menu-media-play-speed-normal-2 =
    .label = 1.0×

main-context-menu-media-play-speed-fast-2 =
    .label = 1.25×

main-context-menu-media-play-speed-faster-2 =
    .label = 1.5×

main-context-menu-media-play-speed-fastest-2 =
    .label = 2×

main-context-menu-media-loop =
    .label = Επανάληψη
    .accesskey = Ψ

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = Εμφάνιση στοιχείων ελέγχου
    .accesskey = φ

main-context-menu-media-hide-controls =
    .label = Απόκρυψη στοιχείων ελέγχου
    .accesskey = ψ

##

main-context-menu-media-video-fullscreen =
    .label = Πλήρης οθόνη
    .accesskey = Π

main-context-menu-media-video-leave-fullscreen =
    .label = Έξοδος από πλήρη οθόνη
    .accesskey = δ

# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-watch-pip =
    .label = Προβολή σε εικόνα εντός εικόνας
    .accesskey = ο

main-context-menu-image-reload =
    .label = Ανανέωση εικόνας
    .accesskey = ν

main-context-menu-image-view-new-tab =
    .label = Άνοιγμα εικόνας σε νέα καρτέλα
    .accesskey = ε

main-context-menu-video-view-new-tab =
    .label = Άνοιγμα βίντεο σε νέα καρτέλα
    .accesskey = σ

main-context-menu-image-copy =
    .label = Αντιγραφή εικόνας
    .accesskey = γ

main-context-menu-image-copy-link =
    .label = Αντιγραφή συνδέσμου εικόνας
    .accesskey = γ

main-context-menu-video-copy-link =
    .label = Αντιγραφή συνδέσμου βίντεο
    .accesskey = ρ

main-context-menu-audio-copy-link =
    .label = Αντιγραφή συνδέσμου ήχου
    .accesskey = φ

main-context-menu-image-save-as =
    .label = Αποθήκευση εικόνας ως…
    .accesskey = θ

main-context-menu-image-email =
    .label = Αποστολή εικόνας με email…
    .accesskey = σ

main-context-menu-image-set-image-as-background =
    .label = Ορισμός εικόνας ως φόντου επιφάνειας εργασίας…
    .accesskey = Ο

main-context-menu-image-info =
    .label = Προβολή πληροφοριών εικόνας
    .accesskey = φ

main-context-menu-image-desc =
    .label = Προβολή περιγραφής
    .accesskey = φ

main-context-menu-video-save-as =
    .label = Αποθήκευση βίντεο ως…
    .accesskey = θ

main-context-menu-audio-save-as =
    .label = Αποθήκευση ήχου ως…
    .accesskey = θ

main-context-menu-video-take-snapshot =
    .label = Λήψη στιγμιότυπου…
    .accesskey = τ

main-context-menu-video-email =
    .label = Αποστολή βίντεο με email…
    .accesskey = σ

main-context-menu-audio-email =
    .label = Αποστολή ήχου με email…
    .accesskey = σ

main-context-menu-plugin-play =
    .label = Ενεργοποίηση αρθρώματος
    .accesskey = γ

main-context-menu-plugin-hide =
    .label = Απόκρυψη αρθρώματος
    .accesskey = π

main-context-menu-save-to-pocket =
    .label = Αποθήκευση σελίδας στο { -pocket-brand-name }
    .accesskey = k

main-context-menu-send-to-device =
    .label = Αποστολή σελίδας σε συσκευή
    .accesskey = δ

## The access keys for "Use Saved Login" and "Use Saved Password"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-use-saved-login =
    .label = Χρήση αποθηκευμένης σύνδεσης
    .accesskey = υ

main-context-menu-use-saved-password =
    .label = Χρήση αποθηκευμένου κωδικού πρόσβασης
    .accesskey = υ

##

main-context-menu-suggest-strong-password =
    .label = Πρόταση ισχυρού κωδικού πρόσβασης…
    .accesskey = σ

main-context-menu-manage-logins2 =
    .label = Διαχείριση συνδέσεων
    .accesskey = Δ

main-context-menu-keyword =
    .label = Προσθήκη λέξης-κλειδιού για αυτήν την αναζήτηση…
    .accesskey = Π

main-context-menu-link-send-to-device =
    .label = Αποστολή συνδέσμου σε συσκευή
    .accesskey = μ

main-context-menu-frame =
    .label = Αυτό το πλαίσιο
    .accesskey = λ

main-context-menu-frame-show-this =
    .label = Προβολή μόνο αυτού του πλαισίου
    .accesskey = ν

main-context-menu-frame-open-tab =
    .label = Άνοιγμα πλαισίου σε νέα καρτέλα
    .accesskey = π

main-context-menu-frame-open-window =
    .label = Άνοιγμα πλαισίου σε νέο παράθυρο
    .accesskey = ν

main-context-menu-frame-reload =
    .label = Ανανέωση πλαισίου
    .accesskey = ν

main-context-menu-frame-bookmark =
    .label = Προσθήκη στους σελιδοδείκτες
    .accesskey = λ

main-context-menu-frame-save-as =
    .label = Αποθήκευση πλαισίου ως…
    .accesskey = π

main-context-menu-frame-print =
    .label = Εκτύπωση πλαισίου…
    .accesskey = λ

main-context-menu-frame-view-source =
    .label = Προβολή πηγαίου κώδικα πλαισίου
    .accesskey = β

main-context-menu-frame-view-info =
    .label = Προβολή πληροφοριών πλαισίου
    .accesskey = β

main-context-menu-print-selection =
    .label = Εκτύπωση επιλογής
    .accesskey = τ

main-context-menu-view-selection-source =
    .label = Προβολή πηγαίου κώδικα επιλογής
    .accesskey = ε

main-context-menu-take-screenshot =
    .label = Λήψη στιγμιότυπου
    .accesskey = Λ

main-context-menu-take-frame-screenshot =
    .label = Λήψη στιγμιότυπου
    .accesskey = ψ

main-context-menu-view-page-source =
    .label = Προβολή πηγαίου κώδικα σελίδας
    .accesskey = Π

main-context-menu-bidi-switch-text =
    .label = Αλλαγή κατεύθυνσης κειμένου
    .accesskey = κ

main-context-menu-bidi-switch-page =
    .label = Αλλαγή κατεύθυνσης σελίδας
    .accesskey = τ

main-context-menu-inspect =
    .label = Επιθεώρηση
    .accesskey = θ

main-context-menu-inspect-a11y-properties =
    .label = Επιθεώρηση ιδιοτήτων προσβασιμότητας

main-context-menu-eme-learn-more =
    .label = Μάθετε περισσότερα για το DRM…
    .accesskey = μ

# Variables
#   $containerName (String): The name of the current container
main-context-menu-open-link-in-container-tab =
    .label = Άνοιγμα συνδέσμου σε νέα καρτέλα «{ $containerName }»
    .accesskey = κ
