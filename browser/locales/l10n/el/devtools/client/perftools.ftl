# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used in DevTools’ performance-new panel, about:profiling, and
### the remote profiling panel. There are additional profiler strings in the appmenu.ftl
### file that are used for the profiler popup.

perftools-intro-title = Ρυθμίσεις εργαλείου προφίλ
perftools-intro-description =
    Οι εγγραφές εκκινούν το profiler.firefox.com σε νέα καρτέλα. Όλα τα δεδομένα αποθηκεύονται
    τοπικά, αλλά μπορείτε να τα μεταφορτώσετε για διαμοιρασμό.

## All of the headings for the various sections.

perftools-heading-settings = Πλήρεις ρυθμίσεις
perftools-heading-buffer = Ρυθμίσεις buffer
perftools-heading-features = Λειτουργίες
perftools-heading-features-default = Λειτουργίες (Προτείνεται ενεργοποίηση από προεπιλογή)
perftools-heading-features-disabled = Ανενεργές λειτουργίες
perftools-heading-features-experimental = Πειραματικό
perftools-heading-threads = Νήματα
perftools-heading-local-build = Τοπική έκδοση δομής

##

perftools-description-intro =
    Οι εγγραφές εκκινούν το <a>profiler.firefox.com</a> σε νέα καρτέλα. Όλα τα δεδομένα αποθηκεύονται
    τοπικά, αλλά μπορείτε να τα μεταφορτώσετε για διαμοιρασμό.
perftools-description-local-build =
    Αν δημιουργείτε προφίλ για μια έκδοση που έχετε μεταγλωττίσει μόνοι σας,
    σε αυτή τη συσκευή, προσθέστε την objdir του έργου σας στην παρακάτω λίστα
    ώστε να μπορεί να χρησιμοποιηθεί για την αναζήτηση πληροφοριών συμβόλων.

## The controls for the interval at which the profiler samples the code.

perftools-range-interval-label = Διάστημα δειγματοληψίας:
perftools-range-interval-milliseconds = { NUMBER($interval, maxFractionalUnits: 2) } ms

##

# The size of the memory buffer used to store things in the profiler.
perftools-range-entries-label = Μέγεθος buffer:
perftools-custom-threads-label = Προσθήκη προσαρμοσμένων νημάτων ανά όνομα:
perftools-devtools-interval-label = Διάστημα:
perftools-devtools-threads-label = Νήματα:
perftools-devtools-settings-label = Ρυθμίσεις

## Various statuses that affect the current state of profiling, not typically displayed.

perftools-status-private-browsing-notice =
    Το εργαλείο προφίλ απενεργοποιείται όταν είναι ενεργή η Ιδιωτική περιήγηση.
    Κλείστε όλα τα Ιδιωτικά παράθυρα για εκ νέου ενεργοποίησή του
perftools-status-recording-stopped-by-another-tool = Η εγγραφή τερματίστηκε από άλλο εργαλείο.
perftools-status-restart-required = Θα πρέπει να επανεκκινήστε το πρόγραμμα περιήγησης για να ενεργοποιήσετε αυτή τη λειτουργία.

## These are shown briefly when the user is waiting for the profiler to respond.

perftools-request-to-stop-profiler = Διακοπή εγγραφής
perftools-request-to-get-profile-and-stop-profiler = Καταγραφή προφίλ

##

perftools-button-start-recording = Έναρξη εγγραφής
perftools-button-capture-recording = Αποθήκευση εγγραφής
perftools-button-cancel-recording = Ακύρωση εγγραφής
perftools-button-save-settings = Αποθήκευση ρυθμίσεων και επιστροφή
perftools-button-restart = Επανεκκίνηση
perftools-button-add-directory = Προσθήκη καταλόγου
perftools-button-remove-directory = Αφαίρεση επιλεγμένων
perftools-button-edit-settings = Επεξεργασία ρυθμίσεων…

## These messages are descriptions of the threads that can be enabled for the profiler.

perftools-thread-gecko-main =
    .title = Οι κύριες διεργασίες για τη γονική διεργασία, καθώς και τις διεργασίες περιεχομένου
perftools-thread-compositor =
    .title = Συνθέτει διαφορετικά, χρωματισμένα στοιχεία στη σελίδα
perftools-thread-dom-worker =
    .title = Αυτό διαχειρίζεται web worker και service worker
perftools-thread-renderer =
    .title = Το νήμα που εκτελεί κλήσεις OpenGL όταν είναι ενεργοποιημένο το WebRender
perftools-thread-render-backend =
    .title = Το νήμα WebRender RenderBackend
perftools-thread-paint-worker =
    .title = Το νήμα στο οποίο γίνεται ο χρωματισμός όταν είναι ενεργός ο χρωματισμός εκτός κύριου νήματος
perftools-thread-style-thread =
    .title = Ο υπολογισμός στυλ διαχωρίζεται σε πολλά νήματα
pref-thread-stream-trans =
    .title = Μεταφορά της ροής δικτύου
perftools-thread-socket-thread =
    .title = Το νήμα όπου ο κώδικας δικτύωσης εκτελεί αποκλεισμένες κλήσεις υποδοχής
perftools-thread-img-decoder =
    .title = Νήματα αποκωδικοποίησης εικόνων
perftools-thread-dns-resolver =
    .title = Η ανάλυση DNS συμβαίνει σε αυτό το thread
perftools-thread-task-controller =
    .title = Νήματα του TaskController pool

##

perftools-record-all-registered-threads = Παράκαμψη των παραπάνω επιλογών και εγγραφή όλων των καταχωρημένων νημάτων
perftools-tools-threads-input-label =
    .title = Αυτά τα ονόματα νημάτων είναι σε λίστα με διαχωρισμό με κόμματα όπου χρησιμοποιείται για την ενεργοποίηση της δημιουργίας προφίλ για νήματα στο εργαλείο προφίλ. Το όνομα θα πρέπει να περιέχει ένα μέρος του ονόματος του νήματος για αντιστοίχιση. Γίνεται διάκριση στο κενό διάστημα.

## Onboarding UI labels. These labels are displayed in the new performance panel UI, when
## both devtools.performance.new-panel-onboarding & devtools.performance.new-panel-enabled
## preferences are true.

perftools-onboarding-message = <b>Νέο</b>: Το { -profiler-brand-name } έχει ενσωματωθεί στα Εργαλεία προγραμματιστών. <a>Μάθετε περισσότερα</a> σχετικά με αυτό το νέο ισχυρό εργαλείο.
# `options-context-advanced-settings` is defined in toolbox-options.ftl
perftools-onboarding-reenable-old-panel = (Για περιορισμένο χρονικό διάστημα, μπορείτε να ανοίξετε το αρχικό παράθυρο "Επιδόσεις" από τις <a>{ options-context-advanced-settings }</a>)
perftools-onboarding-close-button =
    .aria-label = Κλείσιμο μηνύματος υποδοχής

## Profiler presets


# Presets and their l10n IDs are defined in the file
# devtools/client/performance-new/popup/background.jsm.js
# The same labels and descriptions are also defined in appmenu.ftl.

perftools-presets-web-developer-label = Ανάπτυξη web
perftools-presets-firefox-platform-label = Πλατφόρμα Waterfox
perftools-presets-firefox-graphics-label = Γραφικά Waterfox
perftools-presets-media-label = Πολυμέσα

##

