# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

page-title = Πληροφορίες επίλυσης προβλημάτων
page-subtitle =
    Αυτή η σελίδα περιέχει τεχνικές πληροφορίες που ενδέχεται να φανούν χρήσιμες κατά
    την επίλυση προβλημάτων. Αν ψάχνετε για απαντήσεις σε συχνές ερωτήσεις σχετικά με το
    { -brand-short-name }, δείτε τη <a data-l10n-name="support-link">σελίδα υποστήριξής</a> μας.

crashes-title = Αναφορές κατάρρευσης
crashes-id = ID αναφοράς
crashes-send-date = Υποβεβλημένα
crashes-all-reports = Όλες οι αναφορές κατάρρευσης
crashes-no-config = Αυτή η εφαρμογή δεν έχει ρυθμιστεί για εμφάνιση αναφορών κατάρρευσης.
support-addons-title = Πρόσθετα
support-addons-name = Όνομα
support-addons-type = Τύπος
support-addons-enabled = Ενεργό
support-addons-version = Έκδοση
support-addons-id = ID
security-software-title = Λογισμικό ασφαλείας
security-software-type = Τύπος
security-software-name = Όνομα
security-software-antivirus = Προστασία από ιούς
security-software-antispyware = Antispyware
security-software-firewall = Τείχος προστασίας
features-title = Χαρακτηριστικά { -brand-short-name }
features-name = Όνομα
features-version = Έκδοση
features-id = ID
processes-title = Απομακρυσμένες διεργασίες
processes-type = Τύπος
processes-count = Πλήθος
app-basics-title = Βασικά εφαρμογής
app-basics-name = Όνομα
app-basics-version = Έκδοση
app-basics-build-id = ID έκδοσης
app-basics-distribution-id = ID διανομής
app-basics-update-channel = Κανάλι ενημερώσεων
# This message refers to the folder used to store updates on the device,
# as in "Folder for updates". "Update" is a noun, not a verb.
app-basics-update-dir =
    { PLATFORM() ->
        [linux] Κατάλογος ενημερώσεων
       *[other] Φάκελος ενημερώσεων
    }
app-basics-update-history = Ιστορικό ενημερώσεων
app-basics-show-update-history = Εμφάνιση ιστορικού ενημερώσεων
# Represents the path to the binary used to start the application.
app-basics-binary = Αρχείο εφαρμογής
app-basics-profile-dir =
    { PLATFORM() ->
        [linux] Κατάλογος προφίλ
       *[other] Φάκελος προφίλ
    }
app-basics-enabled-plugins = Ενεργά αρθρώματα
app-basics-build-config = Ρύθμιση δομής
app-basics-user-agent = Παράγοντας χρήστη
app-basics-os = ΛΣ
app-basics-os-theme = Θέμα ΛΣ
# Rosetta is Apple's translation process to run apps containing x86_64
# instructions on Apple Silicon. This should remain in English.
app-basics-rosetta = Μεταφρασμένο με Rosetta
app-basics-memory-use = Χρήση μνήμης
app-basics-performance = Επιδόσεις
app-basics-service-workers = Εγγεγραμμένα service worker
app-basics-third-party = Λειτουργικές μονάδες τρίτων
app-basics-profiles = Προφίλ
app-basics-launcher-process-status = Διεργασία εκκίνησης
app-basics-multi-process-support = Παράθυρα πολυδιεργασιών
app-basics-fission-support = Παράθυρα Fission
app-basics-remote-processes-count = Απομακρυσμένες διεργασίες
app-basics-enterprise-policies = Πολιτικές επιχειρήσεων
app-basics-location-service-key-google = Κλειδί υπηρεσίας τοποθεσίας Google
app-basics-safebrowsing-key-google = Κλειδί ασφαλούς περιήγησης Google
app-basics-key-mozilla = Κλειδί υπηρεσίας τοποθεσίας Waterfox
app-basics-safe-mode = Ασφαλής λειτουργία
show-dir-label =
    { PLATFORM() ->
        [macos] Προβολή στο Finder
        [windows] Άνοιγμα φακέλου
       *[other] Άνοιγμα καταλόγου
    }
environment-variables-title = Μεταβλητές περιβάλλοντος
environment-variables-name = Όνομα
environment-variables-value = Τιμή
experimental-features-title = Πειραματικές λειτουργίες
experimental-features-name = Όνομα
experimental-features-value = Τιμή
modified-key-prefs-title = Σημαντικές τροποποιημένες προτιμήσεις
modified-prefs-name = Όνομα
modified-prefs-value = Τιμή
user-js-title = Προτιμήσεις user.js
user-js-description = Ο φάκελος του προφίλ σας περιέχει το <a data-l10n-name="user-js-link">αρχείο user.js</a>, στο οποίο αποθηκεύονται οι προτιμήσεις που δεν δημιουργήθηκαν από το { -brand-short-name }.
locked-key-prefs-title = Σημαντικές κλειδωμένες προτιμήσεις
locked-prefs-name = Όνομα
locked-prefs-value = Τιμή
graphics-title = Γραφικά
graphics-features-title = Λειτουργίες
graphics-diagnostics-title = Διαγνωστικά
graphics-failure-log-title = Αρχείο καταγραφής αποτυχιών
graphics-gpu1-title = GPU #1
graphics-gpu2-title = GPU #2
graphics-decision-log-title = Αρχείο καταγραφής αποφάσεων
graphics-crash-guards-title = Ανενεργές λειτουργίες φύλαξης καταρρεύσεων
graphics-workarounds-title = Λύσεις
# Windowing system in use on Linux (e.g. X11, Wayland).
graphics-window-protocol = Πρωτόκολλο παραθύρου
# Desktop environment in use on Linux (e.g. GNOME, KDE, XFCE, etc).
graphics-desktop-environment = Περιβάλλον επιφάνειας εργασίας
place-database-title = Βάση δεδομένων τοποθεσιών
place-database-integrity = Ακεραιότητα
place-database-verify-integrity = Επαλήθευση ακεραιότητας
a11y-title = Προσβασιμότητα
a11y-activated = Ενεργό
a11y-force-disabled = Αποτροπή προσβασιμότητας
a11y-handler-used = Προσβάσιμο handler σε χρήση
a11y-instantiator = Ενεργοποιητής προσβασιμότητας
library-version-title = Εκδόσεις βιβλιοθήκης
copy-text-to-clipboard-label = Αντιγραφή κειμένου στο πρόχειρο
copy-raw-data-to-clipboard-label = Αντιγραφή ακατέργαστων δεδομένων στο πρόχειρο
sandbox-title = Sandbox
sandbox-sys-call-log-title = Απορριφθείσες κλήσεις συστήματος
sandbox-sys-call-index = #
sandbox-sys-call-age = δευτερόλεπτα πριν
sandbox-sys-call-pid = PID
sandbox-sys-call-tid = TID
sandbox-sys-call-proc-type = Τύπος διεργασίας
sandbox-sys-call-number = Syscall
sandbox-sys-call-args = Ορίσματα
troubleshoot-mode-title = Διάγνωση προβλημάτων
restart-in-troubleshoot-mode-label = Λειτουργία επίλυσης προβλημάτων…
clear-startup-cache-title = Απαλοιφή κρυφής μνήμης εκκίνησης
clear-startup-cache-label = Απαλοιφή κρυφής μνήμης εκκίνησης…
startup-cache-dialog-title2 = Επανεκκίνηση { -brand-short-name } για απαλοιφή κρυφής μνήμης εκκίνησης;
startup-cache-dialog-body2 = Αυτό δεν θα αλλάξει τις ρυθμίσεις σας, ούτε θα αφαιρέσει τις επεκτάσεις σας.
restart-button-label = Επανεκκίνηση

## Media titles

audio-backend = Υποσύστημα ήχου
max-audio-channels = Μέγιστος αριθμός καναλιών
sample-rate = Επιθυμητός ρυθμός δειγματοληψίας
roundtrip-latency = Καθυστέρηση μετ' επιστροφής (τυπική απόκλιση)
media-title = Πολυμέσα
media-output-devices-title = Συσκευές εξόδου
media-input-devices-title = Συσκευές εισόδου
media-device-name = Όνομα
media-device-group = Ομάδα
media-device-vendor = Κατασκευαστής
media-device-state = Κατάσταση
media-device-preferred = Προτίμηση
media-device-format = Μορφή
media-device-channels = Κανάλια
media-device-rate = Ρυθμός
media-device-latency = Καθυστέρηση
media-capabilities-title = Δυνατότητες μέσων
# List all the entries of the database.
media-capabilities-enumerate = Απαρίθμηση βάσης δεδομένων

##

intl-title = Διεθνοποίηση & μετάφραση
intl-app-title = Ρυθμίσεις εφαρμογής
intl-locales-requested = Ζητούμενες γλώσσες
intl-locales-available = Διαθέσιμες γλώσσες
intl-locales-supported = Γλώσσες εφαρμογής
intl-locales-default = Προεπιλεγμένη γλώσσα
intl-os-title = Λειτουργικό σύστημα
intl-os-prefs-system-locales = Γλώσσες συστήματος
intl-regional-prefs = Προτιμήσεις περιοχής

## Remote Debugging
##
## The Waterfox remote protocol provides low-level debugging interfaces
## used to inspect state and control execution of documents,
## browser instrumentation, user interaction simulation,
## and for subscribing to browser-internal events.
##
## See also https://firefox-source-docs.mozilla.org/remote/

remote-debugging-title = Απομακρυσμένος έλεγχος σφαλμάτων (Πρωτόκολλο Chromium)
remote-debugging-accepting-connections = Αποδεκτές συνδέσεις
remote-debugging-url = URL

##

# Variables
# $days (Integer) - Number of days of crashes to log
report-crash-for-days =
    { $days ->
        [one] Αναφορές κατάρρευσης της τελευταίας { $days } ημέρας
       *[other] Αναφορές κατάρρευσης των τελευταίων { $days } ημερών
    }

# Variables
# $minutes (integer) - Number of minutes since crash
crashes-time-minutes =
    { $minutes ->
        [one] { $minutes } λεπτό πριν
       *[other] { $minutes } λεπτά πριν
    }

# Variables
# $hours (integer) - Number of hours since crash
crashes-time-hours =
    { $hours ->
        [one] { $hours } ώρα πριν
       *[other] { $hours } ώρες πριν
    }

# Variables
# $days (integer) - Number of days since crash
crashes-time-days =
    { $days ->
        [one] { $days } μέρα πριν
       *[other] { $days } ημέρες πριν
    }

# Variables
# $reports (integer) - Number of pending reports
pending-reports =
    { $reports ->
        [one] Όλες οι αναφορές κατάρρευσης (συμπεριλαμβανομένης { $reports } κατάρρευσης σε αναμονή στο δεδομένο χρονικό διάστημα)
       *[other] Όλες οι αναφορές κατάρρευσης (συμπεριλαμβανομένων { $reports } καταρρεύσεων σε αναμονή στο δεδομένο χρονικό διάστημα)
    }

raw-data-copied = Τα ακατέργαστα δεδομένα αντιγράφτηκαν στο πρόχειρο
text-copied = Το κείμενο αντιγράφτηκε στο πρόχειρο

## The verb "blocked" here refers to a graphics feature such as "Direct2D" or "OpenGL layers".

blocked-driver = Αποκλείστηκε για την έκδοση του προγράμματος οδήγησης γραφικών σας.
blocked-gfx-card = Αποκλείστηκε για την κάρτα γραφικών σας, λόγω ανεπίλυτων προβλημάτων προγράμματος οδήγησης.
blocked-os-version = Αποκλείστηκε για την έκδοση του λειτουργικού σας συστήματος.
blocked-mismatched-version = Αποκλείστηκε λόγω ασυμφωνίας της έκδοσης του προγράμματος οδήγησης γραφικών μεταξύ μητρώου και DLL.
# Variables
# $driverVersion - The graphics driver version string
try-newer-driver = Αποκλείστηκε για το πρόγραμμα οδήγησης της κάρτας γραφικών σας. Δοκιμάστε να το αναβαθμίστε στην έκδοση { $driverVersion } ή νεότερη.

# "ClearType" is a proper noun and should not be translated. Feel free to leave English strings if
# there are no good translations, these are only used in about:support
clear-type-parameters = Παράμετροι ClearType

compositing = Σύνθεση
hardware-h264 = Αποκωδικοποίηση υλικού H264
main-thread-no-omtc = κύριο νήμα, όχι OMTC
yes = Ναι
no = Όχι
unknown = Άγνωστο
virtual-monitor-disp = Οθόνη εικονικής εποπτείας

## The following strings indicate if an API key has been found.
## In some development versions, it's expected for some API keys that they are
## not found.

found = Βρέθηκε
missing = Λείπει

gpu-process-pid = GPUProcessPid
gpu-process = GPUProcess
gpu-description = Περιγραφή
gpu-vendor-id = ID κατασκευαστή
gpu-device-id = ID συσκευής
gpu-subsys-id = ID υποσυστήματος
gpu-drivers = Προγράμματα οδήγησης
gpu-ram = RAM
gpu-driver-vendor = Εκδότης προγράμματος οδήγησης
gpu-driver-version = Έκδοση προγράμματος οδήγησης
gpu-driver-date = Ημερομηνία προγράμματος οδήγησης
gpu-active = Ενεργό
webgl1-wsiinfo = Πληροφορίες WSI προγράμματος οδήγησης WebGL 1
webgl1-renderer = Πρόγραμμα οδήγησης απεικόνισης WebGL 1
webgl1-version = Έκδοση προγράμματος οδήγησης WebGL 1
webgl1-driver-extensions = Επεκτάσεις προγράμματος οδήγησης WebGL 1
webgl1-extensions = Επεκτάσεις WebGL 1
webgl2-wsiinfo = Πληροφορίες WSI προγράμματος οδήγησης WebGL 2
webgl2-renderer = Πρόγραμμα οδήγησης απεικόνισης WebGL 2
webgl2-version = Έκδοση προγράμματος οδήγησης WebGL 2
webgl2-driver-extensions = Επεκτάσεις προγράμματος οδήγησης WebGL 2
webgl2-extensions = Επεκτάσεις WebGL 2

# Variables
#   $bugNumber (string) - Bug number on Bugzilla
support-blocklisted-bug = Αποκλείστηκε λόγω γνωστών ζητημάτων: <a data-l10n-name="bug-link">σφάλμα { $bugNumber }</a>

# Variables
# $failureCode (string) - String that can be searched in the source tree.
unknown-failure = Αποκλείστηκε· κωδικός αποτυχίας { $failureCode }

d3d11layers-crash-guard = Συνθέτης D3D11
glcontext-crash-guard = OpenGL
wmfvpxvideo-crash-guard = Αποκωδικοποιητής βίντεο WMF VPX

reset-on-next-restart = Επαναφορά στην επόμενη επανεκκίνηση
gpu-process-kill-button = Τερματισμός διεργασίας GPU
gpu-device-reset = Επαναφορά συσκευής
gpu-device-reset-button = Έναυσμα επαναφοράς συσκευής
uses-tiling = Χρησιμοποιεί παράθεση
content-uses-tiling = Χρησιμοποιεί παράθεση (περιεχόμενο)
off-main-thread-paint-enabled = Ενεργό off main thread painting
off-main-thread-paint-worker-count = Πλήθος worker για off main thread painting
target-frame-rate = Ρυθμός καρέ στόχου

min-lib-versions = Αναμενόμενη ελάχιστη έκδοση
loaded-lib-versions = Έκδοση σε χρήση

has-seccomp-bpf = Seccomp-BPF (Φιλτράρισμα κλήσεων συστήματος)
has-seccomp-tsync = Συγχρονισμός νήματος Seccomp
has-user-namespaces = Χώροι ονομάτων χρήστη
has-privileged-user-namespaces = Χώροι ονομάτων χρήστη για προνομιακές διεργασίες
can-sandbox-content = Sandboxing διεργασίας περιεχομένου
can-sandbox-media = Sandboxing αρθρώματος πολυμέσων
content-sandbox-level = Επίπεδο sandbox διεργασίας περιεχομένου
effective-content-sandbox-level = Αποτελεσματικό επίπεδο επεξεργασίας περιεχομένου sandbox
content-win32k-lockdown-state = Κατάσταση κλειδώματος Win32k για διεργασία περιεχομένου
sandbox-proc-type-content = περιεχόμενο
sandbox-proc-type-file = περιεχόμενο αρχείου
sandbox-proc-type-media-plugin = άρθρωμα πολυμέσων
sandbox-proc-type-data-decoder = αποκωδικοποιητής δεδομένων

startup-cache-title = Κρυφή μνήμη εκκίνησης
startup-cache-disk-cache-path = Διαδρομή κρυφής μνήμης δίσκου
startup-cache-ignore-disk-cache = Παράβλεψη κρυφής μνήμης δίσκου
startup-cache-found-disk-cache-on-init = Βρέθηκε κρυφή μνήμη δίσκου στο Init
startup-cache-wrote-to-disk-cache = Εγγράφηκε στην κρυφή μνήμη δίσκου

launcher-process-status-0 = Ενεργό
launcher-process-status-1 = Ανενεργό λόγω αποτυχίας
launcher-process-status-2 = Ανενεργό εξαναγκαστικά
launcher-process-status-unknown = Άγνωστη κατάσταση

# Variables
# $remoteWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
multi-process-windows = { $remoteWindows }/{ $totalWindows }
# Variables
# $fissionWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
fission-windows = { $fissionWindows }/{ $totalWindows }
fission-status-experiment-control = Απενεργοποιήθηκε από πείραμα
fission-status-experiment-treatment = Ενεργοποιήθηκε από πείραμα
fission-status-disabled-by-e10s-env = Απενεργοποιήθηκε από το περιβάλλον
fission-status-enabled-by-env = Ενεργοποιήθηκε από το περιβάλλον
fission-status-disabled-by-safe-mode = Απενεργοποιήθηκε από την ασφαλή λειτουργία
fission-status-enabled-by-default = Ενεργό από προεπιλογή
fission-status-disabled-by-default = Απενεργοποιήθηκε από προεπιλογή
fission-status-enabled-by-user-pref = Ενεργοποιήθηκε από το χρήστη
fission-status-disabled-by-user-pref = Απενεργοποιήθηκε από το χρήστη
fission-status-disabled-by-e10s-other = Ανενεργό E10s
fission-status-enabled-by-rollout = Ενεργό με σταδιακή διάθεση

async-pan-zoom = Ασύγχρονο pan/zoom
apz-none = κανένα
wheel-enabled = είσοδος ρόδας ενεργή
touch-enabled = είσοδος αφής ενεργή
drag-enabled = ολίσθηση γραμμής κύλισης ενεργή
keyboard-enabled = πληκτρολόγιο ενεργό
autoscroll-enabled = αυτόματη κύλιση ενεργή
zooming-enabled = ομαλό ζουμ ενεργό

## Variables
## $preferenceKey (string) - String ID of preference

wheel-warning = ανενεργή ασύγχρονη είσοδος ρόδας λόγω μη υποστηριζόμενης προτίμησης: { $preferenceKey }
touch-warning = ανενεργή ασύγχρονη είσοδος αφής λόγω μη υποστηριζόμενης προτίμησης: { $preferenceKey }

## Strings representing the status of the Enterprise Policies engine.

policies-inactive = Ανενεργό
policies-active = Ενεργό
policies-error = Σφάλμα

## Printing section

support-printing-title = Εκτύπωση
support-printing-troubleshoot = Επίλυση προβλημάτων
support-printing-clear-settings-button = Διαγραφή αποθηκευμένων ρυθμίσεων εκτύπωσης
support-printing-modified-settings = Τροποποιημένες ρυθμίσεις εκτύπωσης
support-printing-prefs-name = Όνομα
support-printing-prefs-value = Τιμή

## Normandy sections

support-remote-experiments-title = Απομακρυσμένα πειράματα
support-remote-experiments-name = Όνομα
support-remote-experiments-branch = Κλάδος πειραμάτων
support-remote-experiments-see-about-studies = Δείτε το <a data-l10n-name="support-about-studies-link">about:studies</a> για περισσότερες πληροφορίες, όπως για απενεργοποίηση μεμονωμένων πειραμάτων ή αποτροπή αυτού του τύπου πειραμάτων στο { -brand-short-name }.

support-remote-features-title = Απομακρυσμένες δυνατότητες
support-remote-features-name = Όνομα
support-remote-features-status = Κατάσταση
