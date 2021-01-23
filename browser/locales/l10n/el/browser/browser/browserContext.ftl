# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] Τράβηγμα προς στα κάτω για προβολή ιστορικού
           *[other] Δεξί κλικ ή τράβηγμα προς τα κάτω για προβολή ιστορικού
        }

## Back

main-context-menu-back =
    .tooltiptext = Μετάβαση μια σελίδα πίσω
    .aria-label = Πίσω
    .accesskey = Π

navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }

toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = Μετάβαση μια σελίδα μπροστά
    .aria-label = Μπροστά
    .accesskey = Μ

navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }

toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = Ανανέωση
    .accesskey = Α

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = Διακοπή
    .accesskey = Δ

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = Αποθήκευση σελίδας ως…
    .accesskey = λ

toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = Δημιουργία σελιδοδείκτη
    .accesskey = δ
    .tooltiptext = Δημιουργία σελιδοδείκτη για αυτή τη σελίδα

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = Δημιουργία σελιδοδείκτη
    .accesskey = δ
    .tooltiptext = Δημιουργία σελιδοδείκτη για αυτή τη σελίδα ({ $shortcut })

main-context-menu-bookmark-change =
    .aria-label = Επεξεργασία σελιδοδείκτη
    .accesskey = θ
    .tooltiptext = Επεξεργασία σελιδοδείκτη

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = Επεξεργασία σελιδοδείκτη
    .accesskey = θ
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

main-context-menu-bookmark-this-link =
    .label = Προσθήκη στους σελιδοδείκτες
    .accesskey = δ

main-context-menu-save-link =
    .label = Αποθήκευση συνδέσμου ως…
    .accesskey = θ

main-context-menu-save-link-to-pocket =
    .label = Αποθήκευση συνδέσμου στο { -pocket-brand-name }
    .accesskey = o

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = Αντιγραφή διεύθυνσης email
    .accesskey = Ε

main-context-menu-copy-link =
    .label = Αντιγραφή τοποθεσίας συνδέσμου
    .accesskey = γ

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

main-context-menu-media-play-speed =
    .label = Ταχύτητα αναπαραγωγής
    .accesskey = τ

main-context-menu-media-play-speed-slow =
    .label = Αργή (0.5×)
    .accesskey = α

main-context-menu-media-play-speed-normal =
    .label = Κανονική
    .accesskey = Κ

main-context-menu-media-play-speed-fast =
    .label = Γρήγορη (1.25×)
    .accesskey = Ρ

main-context-menu-media-play-speed-faster =
    .label = Πιο γρήγορη (1.5×)
    .accesskey = γ

# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = Πολύ υψηλή (2×)
    .accesskey = Λ

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
main-context-menu-media-pip =
    .label = Εικόνα εντός εικόνας
    .accesskey = ν

main-context-menu-image-reload =
    .label = Ανανέωση εικόνας
    .accesskey = ν

main-context-menu-image-view =
    .label = Προβολή εικόνας
    .accesskey = κ

main-context-menu-video-view =
    .label = Προβολή βίντεο
    .accesskey = β

main-context-menu-image-copy =
    .label = Αντιγραφή εικόνας
    .accesskey = γ

main-context-menu-image-copy-location =
    .label = Αντιγραφή τοποθεσίας εικόνας
    .accesskey = ν

main-context-menu-video-copy-location =
    .label = Αντιγραφή τοποθεσίας βίντεο
    .accesskey = γ

main-context-menu-audio-copy-location =
    .label = Αντιγραφή τοποθεσίας ήχου
    .accesskey = γ

main-context-menu-image-save-as =
    .label = Αποθήκευση εικόνας ως…
    .accesskey = θ

main-context-menu-image-email =
    .label = Αποστολή εικόνας…
    .accesskey = σ

main-context-menu-image-set-as-background =
    .label = Ορισμός ως ταπετσαρία…
    .accesskey = τ

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

main-context-menu-video-image-save-as =
    .label = Αποθήκευση στιγμιότυπου ως…
    .accesskey = ς

main-context-menu-video-email =
    .label = Αποστολή βίντεο…
    .accesskey = σ

main-context-menu-audio-email =
    .label = Αποστολή ήχου…
    .accesskey = χ

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

main-context-menu-view-background-image =
    .label = Προβολή εικόνας παρασκηνίου
    .accesskey = β

main-context-menu-generate-new-password =
    .label = Χρήση προτεινόμενου κωδικού πρόσβασης…
    .accesskey = π

main-context-menu-keyword =
    .label = Προσθέστε μια λέξη-κλειδί για αυτή την αναζήτηση…
    .accesskey = κ

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

main-context-menu-view-selection-source =
    .label = Προβολή πηγαίου κώδικα επιλογής
    .accesskey = ε

main-context-menu-view-page-source =
    .label = Προβολή πηγαίου κώδικα
    .accesskey = Π

main-context-menu-view-page-info =
    .label = Προβολή πληροφοριών σελίδας
    .accesskey = λ

main-context-menu-bidi-switch-text =
    .label = Αλλαγή κατεύθυνσης κειμένου
    .accesskey = κ

main-context-menu-bidi-switch-page =
    .label = Αλλαγή κατεύθυνσης σελίδας
    .accesskey = τ

main-context-menu-inspect-element =
    .label = Επιθεώρηση στοιχείου
    .accesskey = υ

main-context-menu-inspect-a11y-properties =
    .label = Επιθεώρηση ιδιοτήτων προσβασιμότητας

main-context-menu-eme-learn-more =
    .label = Μάθετε περισσότερα για το DRM…
    .accesskey = μ
