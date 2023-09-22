# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# This is the title of the page
about-logging-title = Σχετικά με την καταγραφή
about-logging-page-title = Διαχείριση καταγραφής
about-logging-current-log-file = Τρέχον αρχείο καταγραφής:
about-logging-new-log-file = Νέο αρχείο καταγραφής:
about-logging-currently-enabled-log-modules = Τρέχουσες ενεργές μονάδες καταγραφής:
about-logging-log-tutorial = Δείτε την <a data-l10n-name="logging">Καταγραφή HTTP</a> για οδηγίες σχετικά με τη χρήση αυτού του εργαλείου.
# This message is used as a button label, "Open" indicates an action.
about-logging-open-log-file-dir = Άνοιγμα καταλόγου
about-logging-set-log-file = Ορισμός αρχείου καταγραφής
about-logging-set-log-modules = Ορισμός μονάδων καταγραφής
about-logging-start-logging = Έναρξη καταγραφής
about-logging-stop-logging = Τερματισμός καταγραφής
about-logging-buttons-disabled = Η καταγραφή διαμορφώθηκε μέσω μεταβλητών περιβάλλοντος, η δυναμική διαμόρφωση δεν είναι διαθέσιμη.
about-logging-some-elements-disabled = Η καταγραφή διαμορφώθηκε μέσω URL, ορισμένες επιλογές δεν είναι διαθέσιμες
about-logging-info = Πληροφορίες:
about-logging-log-modules-selection = Επιλογή μονάδας καταγραφής
about-logging-new-log-modules = Νέες μονάδες καταγραφής:
about-logging-logging-output-selection = Έξοδος καταγραφής
about-logging-logging-to-file = Καταγραφή σε αρχείο
about-logging-logging-to-profiler = Καταγραφή στο { -profiler-brand-name }
about-logging-no-log-modules = Καμία
about-logging-no-log-file = Κανένα
about-logging-logging-preset-selector-text = Προκαθορισμένη καταγραφή:
about-logging-with-profiler-stacks-checkbox = Ενεργοποίηση ιχνών στοίβας για μηνύματα καταγραφής

## Logging presets

about-logging-preset-networking-label = Δικτύωση
about-logging-preset-networking-description = Μονάδες καταγραφής για τη διάγνωση προβλημάτων δικτύωσης
about-logging-preset-networking-cookie-label = Cookies
about-logging-preset-networking-cookie-description = Μονάδες καταγραφής για τη διάγνωση προβλημάτων cookie
about-logging-preset-networking-websocket-label = WebSockets
about-logging-preset-networking-websocket-description = Μονάδες καταγραφής για τη διάγνωση προβλημάτων WebSocket
about-logging-preset-networking-http3-label = HTTP/3
about-logging-preset-networking-http3-description = Μονάδες καταγραφής για τη διάγνωση προβλημάτων HTTP/3 και QUIC
about-logging-preset-media-playback-label = Αναπαραγωγή πολυμέσων
about-logging-preset-media-playback-description = Μονάδες καταγραφής για τη διάγνωση προβλημάτων αναπαραγωγής πολυμέσων (όχι ζητημάτων τηλεδιασκέψεων)
about-logging-preset-webrtc-label = WebRTC
about-logging-preset-webrtc-description = Μονάδες καταγραφής για τη διάγνωση κλήσεων WebRTC
about-logging-preset-webgpu-label = WebGPU
about-logging-preset-webgpu-description = Μονάδες καταγραφής για τη διάγνωση προβλημάτων WebGPU
about-logging-preset-gfx-label = Γραφικά
about-logging-preset-gfx-description = Μονάδες καταγραφής για τη διάγνωση προβλημάτων γραφικών
about-logging-preset-custom-label = Προσαρμοσμένο
about-logging-preset-custom-description = Οι μονάδες καταγραφής επιλέχθηκαν χειροκίνητα
# Error handling
about-logging-error = Σφάλμα:

## Variables:
##   $k (String) - Variable name
##   $v (String) - Variable value

about-logging-invalid-output = Μη έγκυρη τιμή «{ $v }» για το κλειδί «{ $k }»
about-logging-unknown-logging-preset = Άγνωστη προκαθορισμένη τιμή καταγραφής «{ $v }»
about-logging-unknown-profiler-preset = Άγνωστη προκαθορισμένη τιμή καταγραφής σε προφίλ «{ $v }»
about-logging-unknown-option = Άγνωστη επιλογή about:logging «{ $k }»
about-logging-configuration-url-ignored = Αγνοήθηκε το URL ρυθμίσεων
about-logging-file-and-profiler-override = Δεν είναι δυνατή η ταυτόχρονη επιβολή της εξόδου αρχείου και της παράκαμψης των επιλογών του εργαλείου προφίλ
about-logging-configured-via-url = Η επιλογή διαμορφώθηκε μέσω URL
