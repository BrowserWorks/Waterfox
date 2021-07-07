# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Thunderbird installations
## all at once. This is traditionally done through the Windows Group Policy
## feature, but the system also supports other forms of deployment.
## These are short descriptions for individual policies, to be displayed
## in the documentation section in about:policies.

policy-3rdparty = Ορισμός πολιτικών που μπορούν να προσπελάσουν τα WebExtensions μέσω του chrome.storage.managed.

policy-AppAutoUpdate = Ενεργοποίηση ή απενεργοποίηση αυτόματων ενημερώσεων εφαρμογής.

policy-AppUpdateURL = Ορισμός προσαρμοσμένου URL ενημέρωσης εφαρμογής.

policy-Authentication = Ρύθμιση ενσωματωμένης πιστοποίησης για ιστοτόπους που την υποστηρίζουν.

policy-BackgroundAppUpdate2 = Ενεργοποίηση ή απενεργοποίηση υπηρεσίας ενημερώσεων παρασκηνίου.

policy-BlockAboutAddons = Αποκλεισμός πρόσβασης στη Διαχείριση προσθέτων (about:addons).

policy-BlockAboutConfig = Αποκλεισμός πρόσβασης στη σελίδα about:config.

policy-BlockAboutProfiles = Αποκλεισμός πρόσβασης στη σελίδα about:profiles.

policy-BlockAboutSupport = Αποκλεισμός πρόσβασης στη σελίδα about:support.

policy-CaptivePortal = Ενεργοποίηση ή απενεργοποίηση υποστήριξης πυλών υποδοχής.

policy-CertificatesDescription = Προσθήκη πιστοποιητικών ή χρήση ενσωματωμένων πιστοποιητικών.

policy-Cookies = Αποδοχή ή απόρριψη τοποθέτησης cookies από ιστοτόπους.

policy-DisableBuiltinPDFViewer = Απενεργοποίηση του PDF.js, του ενσωματωμένου προγράμματος προβολής PDF στο { -brand-short-name }.

policy-DisabledCiphers = Απενεργοποίηση κρυπτογράφησης.

policy-DefaultDownloadDirectory = Ορισμός προεπιλεγμένου καταλόγου λήψης.

policy-DisableAppUpdate = Αποτροπή ενημέρωσης του { -brand-short-name }.

policy-DisableDefaultClientAgent = Αποτροπή οποιασδήποτε ενέργειας από την προεπιλεγμένη λειτουργία πελάτη. Ισχύει μόνο για Windows· οι άλλες πλατφόρμες δεν έχουν τέτοια υπηρεσία.

policy-DisableDeveloperTools = Αποκλεισμός πρόσβασης στα εργαλεία ανάπτυξης.

policy-DisableFeedbackCommands = Απενεργοποίηση εντολών για αποστολή σχολίων από το μενού «Βοήθεια» («Υποβολή σχολίων» και «Αναφορά παραπλανητικού ιστοτόπου»).

policy-DisableForgetButton = Αποτροπή πρόσβασης στο κουμπί «Διαγραφή».

policy-DisableFormHistory = Χωρίς διατήρηση ιστορικού αναζήτησης και φορμών.

policy-DisableMasterPasswordCreation = Αν αληθεύει, δεν μπορεί να δημιουργηθεί κύριος κωδικός πρόσβασης.

policy-DisablePasswordReveal = Να μην επιτρέπεται η αποκάλυψη κωδικών πρόσβασης σε αποθηκευμένες συνδέσεις.

policy-DisableProfileImport = Απενεργοποίηση της εντολής μενού για εισαγωγή δεδομένων από άλλη εφαρμογή.

policy-DisableSafeMode = Απενεργοποίηση της λειτουργίας για επανεκκίνηση στην Ασφαλή λειτουργία. Σημείωση: το πλήκτρο Shift για είσοδο στην Ασφαλή λειτουργία μπορεί να απενεργοποιηθεί μόνο στα Windows με την Πολιτική ομάδας.

policy-DisableSecurityBypass = Αποτροπή παράκαμψης ορισμένων προειδοποιήσεων ασφαλείας από το χρήστη.

policy-DisableSystemAddonUpdate = Αποτροπή εγκατάστασης και ενημέρωσης προσθέτων συστήματος από το { -brand-short-name }.

policy-DisableTelemetry = Απενεργοποίηση τηλεμετρίας.

policy-DisplayMenuBar = Εμφάνιση γραμμής μενού από προεπιλογή.

policy-DNSOverHTTPS = Ρύθμιση παραμέτρων DNS over HTTPS.

policy-DontCheckDefaultClient = Απενεργοποίηση ελέγχου για το προεπιλεγμένο πρόγραμμα email κατά την εκκίνηση.

policy-DownloadDirectory = Ορισμός και κλείδωμα καταλόγου λήψης.

# “lock” means that the user won’t be able to change this setting
policy-EnableTrackingProtection = Ενεργοποίηση ή απενεργοποίηση φραγής περιεχομένου και προαιρετικό κλείδωμα.

# “lock” means that the user won’t be able to change this setting
policy-EncryptedMediaExtensions = Ενεργοποίηση ή απενεργοποίηση κρυπτογραφημένων επεκτάσεων πολυμέσων και προαιρετικό κλείδωμα.

# A “locked” extension can’t be disabled or removed by the user. This policy
# takes 3 keys (“Install”, ”Uninstall”, ”Locked”), you can either keep them in
# English or translate them as verbs.
policy-Extensions = Εγκατάσταση, απεγκατάσταση ή κλείδωμα επεκτάσεων. Η επιλογή εγκατάστασης λαμβάνει τα URLs ή τις διαδρομές ως παραμέτρους. Οι επιλογές απεγκατάστασης και κλειδώματος λαμβάνουν IDs επεκτάσεων.

policy-ExtensionSettings = Διαχείριση όλων των πτυχών της εγκατάστασης μιας επέκτασης.

policy-ExtensionUpdate = Ενεργοποίηση ή απενεργοποίηση αυτόματων ενημερώσεων επεκτάσεων.

policy-Handlers = Ρύθμιση προκαθορισμένων χειριστών εφαρμογών.

policy-HardwareAcceleration = Αν είναι ψευδές, απενεργοποίηση επιτάχυνσης υλικού.

policy-InstallAddonsPermission = Αποδοχή εγκατάστασης προσθέτων από ορισμένους ιστοτόπους.

policy-LegacyProfiles = Απενεργοποίηση της λειτουργίας που απαιτεί ξεχωριστό προφίλ για κάθε εγκατάσταση.

## Do not translate "SameSite", it's the name of a cookie attribute.

policy-LegacySameSiteCookieBehaviorEnabled = Ενεργοποίηση προεπιλεγμένης ρύθμισης συμπεριφοράς του παλαιού SameSite cookie.

policy-LegacySameSiteCookieBehaviorEnabledForDomainList = Επαναφορά στην παλαιά συμπεριφορά SameSite για cookies σε καθορισμένους ιστοτόπους.

##

policy-LocalFileLinks = Να επιτρέπεται σε συγκεκριμένους ιστοτόπους η σύνδεση με τοπικά αρχεία.

policy-ManualAppUpdateOnly = Αποδοχή μόνο των χειροκίνητων ενημερώσεων και να μην ειδοποιείται ο χρήστης σχετικά με ενημερώσεις.

policy-NetworkPrediction = Ενεργοποίηση ή απενεργοποίηση πρόβλεψης δικτύου (προφόρτωση DNS).

policy-OfferToSaveLogins = Εξαναγκασμός της ρύθμισης για να επιτρέπεται στο { -brand-short-name } η πρόταση για απομνημόνευση αποθηκευμένων συνδέσεων και κωδικών πρόσβασης. Αποδεκτές η τιμή true και η τιμή false.

policy-OfferToSaveLoginsDefault = Ορισμός προεπιλεγμένης τιμής για να επιτρέπεται στο { -brand-short-name } η πρόταση για απομνημόνευση αποθηκευμένων συνδέσεων και κωδικών πρόσβασης. Είναι αποδεκτές οι τιμές true και false.

policy-OverrideFirstRunPage = Παράκαμψη της σελίδας πρώτης εκτέλεσης. Αφήστε αυτή την πολιτική κενή αν θέλετε να απενεργοποιήσετε τη σελίδα πρώτης εκτέλεσης.

policy-OverridePostUpdatePage = Παράκαμψη της σελίδας «Τι νέο υπάρχει» μετά από ενημέρωση. Αφήστε αυτήν την πολιτική κενή αν θέλετε να απενεργοποιήσετε τη σελίδα μετά την ενημέρωση.

policy-PasswordManagerEnabled = Ενεργοποίηση αποθήκευσης κωδικών πρόσβασης στη διαχείριση κωδικών πρόσβασης.

# PDF.js and PDF should not be translated
policy-PDFjs = Απενεργοποίηση ή ρύθμιση του PDF.js, του ενσωματωμένου προγράμματος προβολής PDF στο { -brand-short-name }.

policy-Permissions2 = Ρύθμιση δικαιωμάτων για κάμερα, μικρόφωνο, τοποθεσία, ειδοποιήσεις και αυτόματη αναπαραγωγή.

policy-Preferences = Ορισμός και κλείδωμα τιμής ενός υποσυνόλου προτιμήσεων.

policy-PrimaryPassword = Απαίτηση ή αποτροπή χρήσης κύριου κωδικού πρόσβασης.

policy-PromptForDownloadLocation = Ερώτηση για την τοποθεσία αποθήκευσης αρχείων κατά τη λήψη.

policy-Proxy = Ρύθμιση παραμέτρων διακομιστή μεσολάβησης.

policy-RequestedLocales = Ορισμός λίστας απαιτούμενων γλωσσών για την εφαρμογή σε σειρά προτίμησης.

policy-SanitizeOnShutdown2 = Απαλοιφή δεδομένων πλοήγησης κατά το κλείσιμο.

policy-SearchEngines = Διαμόρφωση ρυθμίσεων μηχανής αναζήτησης. Αυτή η πολιτική είναι διαθέσιμη μόνο στην έκδοση εκτεταμένης υποστήριξης (ESR).

policy-SearchSuggestEnabled = Ενεργοποίηση ή απενεργοποίηση προτάσεων αναζήτησης.

# For more information, see https://developer.mozilla.org/en-US/docs/Waterfox/Projects/NSS/PKCS11/Module_Installation
policy-SecurityDevices = Εγκατάσταση μονάδων PKCS #11.

policy-SSLVersionMax = Ορισμός μέγιστης έκδοσης SSL.

policy-SSLVersionMin = Ορισμός ελάχιστης έκδοσης SSL.

policy-SupportMenu = Προσθήκη προσαρμοσμένου στοιχείου μενού υποστήριξης στο μενού βοήθειας.

policy-UserMessaging = Απόκρυψη ορισμένων μηνυμάτων από τον χρήστη.

# “format” refers to the format used for the value of this policy.
policy-WebsiteFilter = Αποκλεισμός επίσκεψης σε ιστοτόπους. Δείτε την τεκμηρίωση για περισσότερες λεπτομέρειες σχετικά με τη μορφή.
