# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Firefox installations
## all at once. This is traditionally done through the Windows Group Policy
## feature, but the system also supports other forms of deployment.
## These are short descriptions for individual policies, to be displayed
## in the documentation section in about:policies.

policy-3rdparty = Ορισμός πολιτικών που μπορούν να προσπελάσουν τα WebExtensions μέσω του chrome.storage.managed.
policy-AllowedDomainsForApps = Καθορισμός τομέων στους οποίους επιτρέπεται πρόσβαση στο Google Workspace.
policy-AppAutoUpdate = Ενεργοποίηση ή απενεργοποίηση αυτόματων ενημερώσεων εφαρμογής.
policy-AppUpdateURL = Ορισμός προσαρμοσμένου URL ενημέρωσης εφαρμογής.
policy-Authentication = Ρύθμιση ενσωματωμένης πιστοποίησης για ιστοσελίδες που την υποστηρίζουν.
policy-AutoLaunchProtocolsFromOrigins = Καθορίστε μια λίστα με εξωτερικά πρωτόκολλα που μπορούν να χρησιμοποιηθούν από καταχωρημένες προελεύσεις χωρίς να ζητηθεί άδεια από τον χρήστη.
policy-BackgroundAppUpdate2 = Ενεργοποίηση ή απενεργοποίηση υπηρεσίας ενημερώσεων παρασκηνίου.
policy-BlockAboutAddons = Αποκλεισμός πρόσβασης στη Διαχείριση προσθέτων (about:addons).
policy-BlockAboutConfig = Αποκλεισμός πρόσβασης στη σελίδα about:config.
policy-BlockAboutProfiles = Αποκλεισμός πρόσβασης στη σελίδα about:profiles.
policy-BlockAboutSupport = Αποκλεισμός πρόσβασης στη σελίδα about:support.
policy-Bookmarks = Δημιουργία σελιδοδεικτών στη γραμμή σελιδοδεικτών, στο μενού σελιδοδεικτών ή σε ένα συγκεκριμένο φάκελο μέσα τους.
policy-CaptivePortal = Ενεργοποίηση ή απενεργοποίηση υποστήριξης captive portal.
policy-CertificatesDescription = Προσθήκη πιστοποιητικών ή χρήση ενσωματωμένων πιστοποιητικών.
policy-Cookies = Αποδοχή ή άρνηση αιτημάτων αποθήκευσης cookies.
policy-DisabledCiphers = Απενεργοποίηση κρυπτογράφησης.
policy-DefaultDownloadDirectory = Ορισμός προεπιλεγμένου καταλόγου λήψης.
policy-DisableAppUpdate = Αποτροπή ενημέρωσης προγράμματος περιήγησης.
policy-DisableBuiltinPDFViewer = Απενεργοποίηση PDF.js, του ενσωματωμένου προγράμματος προβολής PDF στο { -brand-short-name }.
policy-DisableDefaultBrowserAgent = Αποτροπή οποιασδήποτε ενέργειας από την προεπιλεγμένη λειτουργία προγράμματος περιήγησης. Ισχύει μόνο για Windows· οι άλλες πλατφόρμες δεν έχουν τέτοια υπηρεσία.
policy-DisableDeveloperTools = Αποκλεισμός πρόσβασης στα εργαλεία ανάπτυξης.
policy-DisableFeedbackCommands = Απενεργοποίηση εντολών για αποστολή σχολίων από το μενού "Βοήθεια" (Υποβολή σχολίων και αναφορά παραπλανητικής ιστοσελίδας).
policy-DisableFirefoxAccounts = Απενεργοποίηση υπηρεσιών { -fxaccount-brand-name(case: "gen", capitalization: "lower") }, καθώς και του συγχρονισμού.
# Firefox Screenshots is the name of the feature, and should not be translated.
policy-DisableFirefoxScreenshots = Απενεργοποίηση λειτουργίας Firefox Screenshots.
policy-DisableFirefoxStudies = Αποτροπή εκτέλεσης μελετών του { -brand-short-name }.
policy-DisableForgetButton = Αποτροπή πρόσβασης στο κουμπί "Διαγραφή".
policy-DisableFormHistory = Χωρίς διατήρηση ιστορικού αναζήτησης και φορμών.
policy-DisableMasterPasswordCreation = Αν αληθεύει, δεν μπορεί να δημιουργηθεί κύριος κωδικός πρόσβασης.
policy-DisablePrimaryPasswordCreation = Αν είναι αληθές, δεν είναι δυνατή η δημιουργία κύριου κωδικού πρόσβασης.
policy-DisablePasswordReveal = Να μην επιτρέπεται η αποκάλυψη κωδικών πρόσβασης σε αποθηκευμένες συνδέσεις.
policy-DisablePocket = Απενεργοποίηση λειτουργίας για αποθήκευση ιστοσελίδων στο Pocket.
policy-DisablePrivateBrowsing = Απενεργοποίηση ιδιωτικής περιήγησης.
policy-DisableProfileImport = Απενεργοποίηση της εντολής μενού για εισαγωγή δεδομένων από άλλο πρόγραμμα περιήγησης.
policy-DisableProfileRefresh = Απενεργοποίηση του κουμπιού ανανέωσης { -brand-short-name } στη σελίδα about:support.
policy-DisableSafeMode = Απενεργοποίηση της λειτουργίας για επανεκκίνηση στην Ασφαλή λειτουργία. Σημείωση: το πλήκτρο Shift για είσοδο στην Ασφαλή λειτουργία μπορεί να απενεργοποιηθεί μόνο στα Windows με την Πολιτική ομάδας.
policy-DisableSecurityBypass = Αποτροπή παράκαμψης ορισμένων προειδοποιήσεων ασφαλείας από το χρήστη.
policy-DisableSetAsDesktopBackground = Απενεργοποίηση της εντολής μενού "Ορισμός ως φόντο επιφάνειας εργασίας" για εικόνες.
policy-DisableSystemAddonUpdate = Αποτροπή εγκατάστασης και ενημέρωσης προσθέτων συστήματος από το πρόγραμμα περιήγησης.
policy-DisableTelemetry = Απενεργοποίηση τηλεμετρίας.
policy-DisplayBookmarksToolbar = Προβολή της γραμμής σελιδοδεικτών από προεπιλογή.
policy-DisplayMenuBar = Προβολή γραμμής μενού από προεπιλογή.
policy-DNSOverHTTPS = Ρύθμιση παραμέτρων DNS over HTTPS.
policy-DontCheckDefaultBrowser = Απενεργοποίηση ελέγχου για το προεπιλεγμένο πρόγραμμα περιήγησης κατά την εκκίνηση.
policy-DownloadDirectory = Ορισμός και κλείδωμα καταλόγου λήψης.
# “lock” means that the user won’t be able to change this setting
policy-EnableTrackingProtection = Ενεργοποίηση ή απενεργοποίηση φραγής περιεχομένου και προαιρετικό κλείδωμα.
# “lock” means that the user won’t be able to change this setting
policy-EncryptedMediaExtensions = Ενεργοποίηση ή απενεργοποίηση κρυπτογραφημένων επεκτάσεων πολυμέσων και προαιρετικό κλείδωμα.
# A “locked” extension can’t be disabled or removed by the user. This policy
# takes 3 keys (“Install”, ”Uninstall”, ”Locked”), you can either keep them in
# English or translate them as verbs.
policy-Extensions = Εγκατάσταση, αφαίρεση ή κλείδωμα επεκτάσεων. Η επιλογή εγκατάστασης παίρνει ως παραμέτρους τα URL ή τις διαδρομές. Οι επιλογές αφαίρεσης και κλειδώματος παίρνουν τα ID επεκτάσεων.
policy-ExtensionSettings = Διαχείριση όλων των πτυχών της εγκατάστασης επεκτάσεων.
policy-ExtensionUpdate = Ενεργοποίηση ή απενεργοποίηση αυτόματων ενημερώσεων επεκτάσεων.
policy-FirefoxHome = Ρύθμιση παραμέτρων της Αρχικής Firefox.
policy-FlashPlugin = Αποδοχή ή απόρριψη χρήσης του αρθρώματος Flash.
policy-Handlers = Ρύθμιση παραμέτρων χειριστών προεπιλεγμένης εφαρμογής.
policy-HardwareAcceleration = Αν είναι ψευδές, απενεργοποίηση επιτάχυνσης υλικού.
# “lock” means that the user won’t be able to change this setting
policy-Homepage = Ορισμός και προαιρετικό κλείδωμα της αρχικής σελίδας.
policy-InstallAddonsPermission = Αποδοχή εγκατάστασης προσθέτων από ορισμένες ιστοσελίδες.
policy-LegacyProfiles = Απενεργοποίηση της λειτουργίας που απαιτεί ξεχωριστό προφίλ για κάθε εγκατάσταση.

## Do not translate "SameSite", it's the name of a cookie attribute.

policy-LegacySameSiteCookieBehaviorEnabled = Ενεργοποίηση προεπιλεγμένης ρύθμισης συμπεριφοράς του παλαιού SameSite cookie.
policy-LegacySameSiteCookieBehaviorEnabledForDomainList = Επαναφορά στην παλαιά συμπεριφορά SameSite για cookies σε καθορισμένες ιστοσελίδες.

##

policy-LocalFileLinks = Να επιτρέπεται σε συγκεκριμένες ιστοσελίδες η σύνδεση με τοπικά αρχεία.
policy-ManagedBookmarks = Ρυθμίζει μια λίστα σελιδοδεικτών που διαχειρίζεται ένας διαχειριστής και δεν μπορεί να τροποποιηθεί από το χρήστη.
policy-MasterPassword = Απαίτηση ή αποτροπή χρήσης κύριου κωδικού πρόσβασης.
policy-ManualAppUpdateOnly = Αποδοχή μόνο χειροκίνητων ενημερώσεων χωρίς ειδοποίηση των χρηστών σχετικά με τις ενημερώσεις.
policy-PrimaryPassword = Απαίτηση ή αποτροπή χρήσης κύριου κωδικού πρόσβασης.
policy-NetworkPrediction = Ενεργοποίηση ή απενεργοποίηση πρόβλεψης δικτύου (προφόρτωση DNS).
policy-NewTabPage = Ενεργοποίηση ή απενεργοποίηση της σελίδας νέας καρτέλας.
policy-NoDefaultBookmarks = Απενεργοποίηση δημιουργίας των προεπιλεγμένων σελιδοδεικτών που έρχονται με το { -brand-short-name }, καθώς και των "έξυπνων" σελιδοδεικτών (Συχνές επισκέψεις, Πρόσφατες ετικέτες). Σημείωση: η πολιτική υλοποιείται μόνο αν χρησιμοποιηθεί πριν την πρώτη εκτέλεση του προφίλ.
policy-OfferToSaveLogins = Εξαναγκασμός της ρύθμισης για να επιτρέπεται στο { -brand-short-name } η πρόταση για απομνημόνευση αποθηκευμένων συνδέσεων και κωδικών πρόσβασης. Αποδεκτές η τιμή "αληθές" και η τιμή "ψευδές".
policy-OfferToSaveLoginsDefault = Ορισμός προεπιλεγμένης τιμής για να επιτρέπεται στο { -brand-short-name } η πρόταση για απομνημόνευση αποθηκευμένων συνδέσεων και κωδικών πρόσβασης. Είναι αποδεκτές οι τιμές true και false.
policy-OverrideFirstRunPage = Παράκαμψη της σελίδας πρώτης εκτέλεσης. Αφήστε αυτή την πολιτική κενή αν θέλετε να απενεργοποιήσετε τη σελίδα πρώτης εκτέλεσης.
policy-OverridePostUpdatePage = Παράκαμψη της σελίδας "Τι νέο υπάρχει" μετά την ενημέρωση. Αφήστε αυτή την πολιτική κενή αν θέλετε να απενεργοποιήσετε τη σελίδα μετά την ενημέρωση.
policy-PasswordManagerEnabled = Ενεργοποίηση αποθήκευσης κωδικών πρόσβασης στη διαχείριση κωδικών πρόσβασης.
# PDF.js and PDF should not be translated
policy-PDFjs = Απενεργοποίηση ή ρύθμιση του PDF.js, του ενσωματωμένου προγράμματος προβολής PDF στο { -brand-short-name }.
policy-Permissions2 = Ρύθμιση δικαιωμάτων για κάμερα, μικρόφωνο, τοποθεσία, ειδοποιήσεις και αυτόματη αναπαραγωγή.
policy-PictureInPicture = Ενεργοποίηση ή απενεργοποίηση Εικόνας-εντός-εικόνας.
policy-PopupBlocking = Αποδοχή αναδυόμενων από ορισμένες ιστοσελίδες, από προεπιλογή.
policy-Preferences = Ορισμός και κλείδωμα τιμής ενός υποσυνόλου προτιμήσεων.
policy-PromptForDownloadLocation = Ερώτηση για την τοποθεσία αποθήκευσης αρχείων κατά τη λήψη.
policy-Proxy = Προσαρμογή ρυθμίσεων μεσολάβησης.
policy-RequestedLocales = Ορισμός λίστας απαιτούμενων γλωσσών για την εφαρμογή σε σειρά προτίμησης.
policy-SanitizeOnShutdown2 = Εκκαθάριση δεδομένων πλοήγησης κατά τον τερματισμό λειτουργίας.
policy-SearchBar = Ορίστε την προεπιλεγμένη τοποθεσία της γραμμής αναζήτησης. Ο χρήστης θα μπορεί να την προσαρμόσει.
policy-SearchEngines = Διαμόρφωση ρυθμίσεων μηχανής αναζήτησης. Αυτή η πολιτική είναι διαθέσιμη μόνο στην έκδοση εκτεταμένης υποστήριξης (ESR).
policy-SearchSuggestEnabled = Ενεργοποίηση ή απενεργοποίηση προτάσεων αναζήτησης.
# For more information, see https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/PKCS11/Module_Installation
policy-SecurityDevices = Εγκατάσταση προσθέτων PKCS #11.
policy-ShowHomeButton = Εμφάνιση του κουμπιού αρχικής σελίδας στη γραμμή εργαλείων.
policy-SSLVersionMax = Ορισμός μέγιστης έκδοσης SSL.
policy-SSLVersionMin = Ορισμός ελάχιστης έκδοσης SSL.
policy-SupportMenu = Προσθήκη προσαρμοσμένου στοιχείου μενού υποστήριξης στο μενού βοήθειας.
policy-UserMessaging = Απόκρυψη ορισμένων μηνυμάτων από τον χρήστη.
# “format” refers to the format used for the value of this policy.
policy-WebsiteFilter = Αποκλεισμός επίσκεψης σε ιστοσελίδες. Δείτε την τεκμηρίωση για περισσότερες λεπτομέρειες σχετικά με τη μορφή.
policy-Windows10SSO = Να επιτρέπεται η ενιαία είσοδος των Windows για λογαριασμούς Microsoft, εργασίας και σχολείου.
