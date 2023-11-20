# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

do-not-track-description = Αποστολή σήματος «Αποτροπή καταγραφής», ώστε να μην καταγράφεστε από ιστοτόπους
do-not-track-description2 =
    .label = Αποστολή αιτήματος «Αποτροπή καταγραφής» στους ιστοτόπους
    .accesskey = τ
do-not-track-learn-more = Μάθετε περισσότερα
do-not-track-option-default-content-blocking-known =
    .label = Μόνο όταν το { -brand-short-name } έχει ρυθμιστεί για φραγή γνωστών ιχνηλατών
do-not-track-option-always =
    .label = Πάντα
global-privacy-control-description =
    .label = Αποστολή αιτήματος μη πώλησης ή κοινοποίησης των δεδομένων μου στους ιστοτόπους
    .accesskey = σ
settings-page-title = Ρυθμίσεις
# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-input-box2 =
    .style = width: 15.4em
    .placeholder = Εύρεση στις ρυθμίσεις
managed-notice = Το πρόγραμμα περιήγησής σας ρυθμίζεται από τον οργανισμό σας.
category-list =
    .aria-label = Κατηγορίες
pane-general-title = Γενικά
category-general =
    .tooltiptext = { pane-general-title }
pane-home-title = Αρχική
category-home =
    .tooltiptext = { pane-home-title }
pane-search-title = Αναζήτηση
category-search =
    .tooltiptext = { pane-search-title }
pane-privacy-title = Απόρρητο και ασφάλεια
category-privacy =
    .tooltiptext = { pane-privacy-title }
pane-sync-title3 = Συγχρονισμός
category-sync3 =
    .tooltiptext = { pane-sync-title3 }
pane-experimental-title = Πειράματα { -brand-short-name }
category-experimental =
    .tooltiptext = Πειράματα { -brand-short-name }
pane-experimental-subtitle = Συνεχίστε με προσοχή
pane-experimental-search-results-header = Πειράματα { -brand-short-name }: Συνεχίστε με προσοχή
pane-experimental-description2 = Η αλλαγή παραμέτρων των σύνθετων ρυθμίσεων μπορεί να επηρεάσει την απόδοση ή την ασφάλεια του { -brand-short-name }.
pane-experimental-reset =
    .label = Επαναφορά προεπιλογών
    .accesskey = Ε
help-button-label = Υποστήριξη { -brand-short-name }
addons-button-label = Επεκτάσεις και θέματα
focus-search =
    .key = f
close-button =
    .aria-label = Κλείσιμο

## Browser Restart Dialog

feature-enable-requires-restart = Θα πρέπει να γίνει επανεκκίνηση του { -brand-short-name } για ενεργοποίηση αυτής της λειτουργίας.
feature-disable-requires-restart = Θα πρέπει να γίνει επανεκκίνηση του { -brand-short-name } για απενεργοποίηση αυτής της λειτουργίας..
should-restart-title = Επανεκκίνηση του { -brand-short-name }
should-restart-ok = Επανεκκίνηση του { -brand-short-name } τώρα
cancel-no-restart-button = Ακύρωση
restart-later = Επανεκκίνηση αργότερα

## Extension Control Notifications
##
## These strings are used to inform the user
## about changes made by extensions to browser settings.
##
## <img data-l10n-name="icon"/> is going to be replaced by the extension icon.
##
## Variables:
##   $name (string) - Name of the extension

# This string is shown to notify the user that the password manager setting
# is being controlled by an extension
extension-controlling-password-saving = Το <img data-l10n-name="icon"/> <strong>{ $name }</strong> ελέγχει αυτήν τη ρύθμιση.
# This string is shown to notify the user that their notifications permission
# is being controlled by an extension.
extension-controlling-web-notifications = Το <img data-l10n-name="icon"/> <strong>{ $name }</strong> ελέγχει αυτήν τη ρύθμιση.
# This string is shown to notify the user that Container Tabs
# are being enabled by an extension.
extension-controlling-privacy-containers = Το <img data-l10n-name="icon"/> <strong>{ $name }</strong> απαιτεί θεματικές καρτέλες.
# This string is shown to notify the user that their content blocking "All Detected Trackers"
# preferences are being controlled by an extension.
extension-controlling-websites-content-blocking-all-trackers = Το <img data-l10n-name="icon"/> <strong>{ $name }</strong> ελέγχει αυτήν τη ρύθμιση.
# This string is shown to notify the user that their proxy configuration preferences
# are being controlled by an extension.
extension-controlling-proxy-config = Το <img data-l10n-name="icon"/> <strong>{ $name }</strong> ελέγχει τον τρόπο σύνδεσης του { -brand-short-name } με το διαδίκτυο.
# This string is shown after the user disables an extension to notify the user
# how to enable an extension that they disabled.
#
# <img data-l10n-name="addons-icon"/> will be replaced with Add-ons icon
# <img data-l10n-name="menu-icon"/> will be replaced with Menu icon
extension-controlled-enable = Για να ενεργοποιήσετε την επέκταση, μεταβείτε στο <img data-l10n-name="addons-icon"/> "Πρόσθετα" στο μενού <img data-l10n-name="menu-icon"/>.

## Preferences UI Search Results

search-results-header = Αποτελέσματα αναζήτησης
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message2 = Δυστυχώς, δεν υπάρχουν αποτελέσματα για το «<span data-l10n-name="query"></span>» στις ρυθμίσεις.
search-results-help-link = Χρειάζεστε βοήθεια; Επισκεφθείτε την <a data-l10n-name="url">Υποστήριξη { -brand-short-name }</a>

## General Section

startup-header = Εκκίνηση
always-check-default =
    .label = Να ελέγχεται πάντα εάν το { -brand-short-name } είναι το προεπιλεγμένο πρόγραμμα περιήγησης
    .accesskey = γ
is-default = Το { -brand-short-name } έχει οριστεί ως προεπιλογή
is-not-default = Το { -brand-short-name } δεν έχει οριστεί ως προεπιλογή
set-as-my-default-browser =
    .label = Ορισμός ως προεπιλογή…
    .accesskey = Π
startup-restore-windows-and-tabs =
    .label = Άνοιγμα προηγούμενων παραθύρων και καρτελών
    .accesskey = π
startup-restore-warn-on-quit =
    .label = Προειδοποίηση κατά την έξοδο από το πρόγραμμα περιήγησης
disable-extension =
    .label = Απενεργοποίηση επέκτασης
preferences-data-migration-header = Εισαγωγή δεδομένων προγράμματος περιήγησης
preferences-data-migration-description = Εισαγάγετε τους σελιδοδείκτες, τους κωδικούς πρόσβασης, το ιστορικό και τα δεδομένα αυτόματης συμπλήρωσης στο { -brand-short-name }.
preferences-data-migration-button =
    .label = Εισαγωγή δεδομένων
    .accesskey = ι
tabs-group-header = Καρτέλες
ctrl-tab-recently-used-order =
    .label = Εναλλαγή καρτελών με το Ctrl+Tab σε σειρά πρόσφατης χρήσης
    .accesskey = T
open-new-link-as-tabs =
    .label = Άνοιγμα συνδέσμων σε καρτέλες αντί για νέα παράθυρα
    .accesskey = π
confirm-on-close-multiple-tabs =
    .label = Επιβεβαίωση πριν από το κλείσιμο πολλαπλών καρτελών
    .accesskey = β
# This string is used for the confirm before quitting preference.
# Variables:
#   $quitKey (string) - the quit keyboard shortcut, and formatted
#                       in the same manner as it would appear,
#                       for example, in the File menu.
confirm-on-quit-with-key =
    .label = Επιβεβαίωση πριν από την έξοδο με { $quitKey }
    .accesskey = ω
warn-on-open-many-tabs =
    .label = Προειδοποίηση όταν το άνοιγμα πολλαπλών καρτελών ενδέχεται να επιβραδύνει το { -brand-short-name }
    .accesskey = β
switch-to-new-tabs =
    .label = Κατά το άνοιγμα συνδέσμου, εικόνας ή πολυμέσου σε νέα καρτέλα, να γίνεται άμεση εναλλαγή σε αυτή
    .accesskey = μ
show-tabs-in-taskbar =
    .label = Προβολή προεπισκόπησης καρτελών στη γραμμή εργασιών των Windows
    .accesskey = ε
browser-containers-enabled =
    .label = Ενεργοποίηση θεματικών καρτελών
    .accesskey = ν
browser-containers-learn-more = Μάθετε περισσότερα
browser-containers-settings =
    .label = Ρυθμίσεις…
    .accesskey = ι
containers-disable-alert-title = Κλείσιμο όλων των θεματικών καρτελών;

## Variables:
##   $tabCount (number) - Number of tabs

containers-disable-alert-desc =
    { $tabCount ->
        [one] Αν απενεργοποιήσετε τις θεματικές καρτέλες τώρα, θα κλείσει { $tabCount } θεματική καρτέλα. Θέλετε σίγουρα να απενεργοποιήσετε τις θεματικές καρτέλες;
       *[other] Αν απενεργοποιήσετε τις θεματικές καρτέλες τώρα, θα κλείσουν { $tabCount } θεματικές καρτέλες. Θέλετε σίγουρα να απενεργοποιήσετε τις θεματικές καρτέλες;
    }
containers-disable-alert-ok-button =
    { $tabCount ->
        [one] Κλείσιμο { $tabCount } θεματικής καρτέλας
       *[other] Κλείσιμο { $tabCount } θεματικών καρτελών
    }

##

containers-disable-alert-cancel-button = Να παραμείνουν ενεργές
containers-remove-alert-title = Αφαίρεση θεματικής καρτέλας;
# Variables:
#   $count (number) - Number of tabs that will be closed.
containers-remove-alert-msg =
    { $count ->
        [one] Αν αφαιρέσετε αυτήν τη θεματική ενότητα τώρα, θα κλείσει { $count } θεματική καρτέλα. Θέλετε σίγουρα να αφαιρέσετε αυτήν τη θεματική ενότητα;
       *[other] Αν αφαιρέσετε αυτήν τη θεματική ενότητα τώρα, θα κλείσουν { $count } θεματικές καρτέλες. Θέλετε σίγουρα να αφαιρέσετε αυτήν τη θεματική ενότητα;
    }
containers-remove-ok-button = Αφαίρεση θεματικής ενότητας
containers-remove-cancel-button = Διατήρηση θεματικής ενότητας

## General Section - Language & Appearance

language-and-appearance-header = Γλώσσα και εμφάνιση
preferences-web-appearance-header = Εμφάνιση ιστοτόπου
preferences-web-appearance-description = Ορισμένοι ιστότοποι προσαρμόζουν το σύνολο χρωμάτων τους με βάση τις προτιμήσεις σας. Επιλέξτε ποιο σύνολο χρωμάτων θέλετε να χρησιμοποιήσετε για αυτούς τους ιστοτόπους.
preferences-web-appearance-choice-auto = Αυτόματο
preferences-web-appearance-choice-light = Ανοιχτόχρωμο
preferences-web-appearance-choice-dark = Σκουρόχρωμο
preferences-web-appearance-choice-tooltip-auto =
    .title = Αυτόματη αλλαγή παρασκηνίου και περιεχομένου ιστοτόπων βάσει των ρυθμίσεων του συστήματός σας και του θέματος του { -brand-short-name }.
preferences-web-appearance-choice-tooltip-light =
    .title = Χρήση ανοιχτόχρωμης εμφάνισης για φόντο και περιεχόμενο ιστοτόπων.
preferences-web-appearance-choice-tooltip-dark =
    .title = Χρήση σκουρόχρωμης εμφάνισης για φόντο και περιεχόμενο ιστοτόπων.
preferences-web-appearance-choice-input-auto =
    .aria-description = { preferences-web-appearance-choice-tooltip-auto.title }
preferences-web-appearance-choice-input-light =
    .aria-description = { preferences-web-appearance-choice-tooltip-light.title }
preferences-web-appearance-choice-input-dark =
    .aria-description = { preferences-web-appearance-choice-tooltip-dark.title }
# This can appear when using windows HCM or "Override colors: always" without
# system colors.
preferences-web-appearance-override-warning = Οι επιλογές χρωμάτων σας υπερισχύουν της εμφάνισης του ιστοτόπου. <a data-l10n-name="colors-link">Διαχείριση χρωμάτων</a>
# This message contains one link. It can be moved within the sentence as needed
# to adapt to your language, but should not be changed.
preferences-web-appearance-footer = Διαχειριστείτε τα θέματα του { -brand-short-name } στην ενότητα <a data-l10n-name="themes-link">Επεκτάσεις και θέματα</a>
preferences-colors-header = Χρώματα
preferences-colors-description = Αντικατάσταση των προεπιλεγμένων χρωμάτων του { -brand-short-name } για κείμενο, παρασκήνια ιστοτόπων και συνδέσμους.
preferences-colors-manage-button =
    .label = Διαχείριση χρωμάτων…
    .accesskey = ω
preferences-fonts-header = Γραμματοσειρές
default-font = Προεπιλεγμένη γραμματοσειρά
    .accesskey = Π
default-font-size = Μέγεθος
    .accesskey = Μ
advanced-fonts =
    .label = Σύνθετα…
    .accesskey = Σ
# Zoom is a noun, and the message is used as header for a group of options
preferences-zoom-header = Ζουμ
preferences-default-zoom = Προεπιλεγμένο ζουμ
    .accesskey = ζ
# Variables:
#   $percentage (number) - Zoom percentage value
preferences-default-zoom-value =
    .label = { $percentage }%
preferences-zoom-text-only =
    .label = Ζουμ μόνο στο κείμενο
    .accesskey = κ
language-header = Γλώσσα
choose-language-description = Επιλέξτε την προτιμώμενη γλώσσα για την εμφάνιση σελίδων
choose-button =
    .label = Επιλογή…
    .accesskey = λ
choose-browser-language-description = Επιλέξτε τις γλώσσες εμφάνισης μενού, μηνυμάτων και ειδοποιήσεων από το { -brand-short-name }.
manage-browser-languages-button =
    .label = Ορισμός εναλλακτικών…
    .accesskey = ν
confirm-browser-language-change-description = Επανεκκίνηση του { -brand-short-name } για εφαρμογή αλλαγών
confirm-browser-language-change-button = Εφαρμογή και επανεκκίνηση
translate-web-pages =
    .label = Μετάφραση περιεχομένου του ιστού
    .accesskey = τ
fx-translate-web-pages = { -translations-brand-name }
# The <img> element is replaced by the logo of the provider
# used to provide machine translations for web pages.
translate-attribution = Μεταφράσεις από <img data-l10n-name="logo"/>
translate-exceptions =
    .label = Εξαιρέσεις…
    .accesskey = ξ
# Variables:
#    $localeName (string) - Localized name of the locale to be used.
use-system-locale =
    .label = Χρήση ρυθμίσεων λειτουργικού συστήματος για τα «{ $localeName }» για μορφοποίηση ημερομηνίας, ώρας, αριθμών και μετρήσεων.
check-user-spelling =
    .label = Έλεγχος ορθογραφίας κατά την πληκτρολόγηση
    .accesskey = π

## General Section - Files and Applications

files-and-applications-title = Αρχεία και εφαρμογές
download-header = Λήψεις
download-save-where = Αποθήκευση αρχείων σε
    .accesskey = θ
download-choose-folder =
    .label =
        { PLATFORM() ->
            [macos] Επιλογή…
           *[other] Περιήγηση…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] π
           *[other] η
        }
download-always-ask-where =
    .label = Να γίνεται πάντα ερώτηση για την τοποθεσία αποθήκευσης αρχείων
    .accesskey = α
applications-header = Εφαρμογές
applications-description = Επιλέξτε πώς διαχειρίζεται το { -brand-short-name } τα ληφθέντα αρχεία από το διαδίκτυο ή τις εφαρμογές που χρησιμοποιείτε κατά την περιήγηση.
applications-filter =
    .placeholder = Αναζήτηση τύπων αρχείων ή εφαρμογών
applications-type-column =
    .label = Τύπος περιεχομένου
    .accesskey = Τ
applications-action-column =
    .label = Ενέργεια
    .accesskey = Ε
# Variables:
#   $extension (String) - file extension (e.g .TXT)
applications-file-ending = Αρχείο { $extension }
applications-action-save =
    .label = Αποθήκευση αρχείου
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app =
    .label = Χρήση { $app-name }
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app-default =
    .label = Χρήση { $app-name } (προεπιλογή)
applications-use-os-default =
    .label =
        { PLATFORM() ->
            [macos] Χρήση προεπιλεγμένης εφαρμογής macOS
            [windows] Χρήση προεπιλεγμένης εφαρμογής Windows
           *[other] Χρήση προεπιλεγμένης εφαρμογής συστήματος
        }
applications-use-other =
    .label = Χρήση άλλου…
applications-select-helper = Επιλογή βοηθητικής εφαρμογής
applications-manage-app =
    .label = Λεπτομέρειες εφαρμογής…
applications-always-ask =
    .label = Ερώτηση πάντα
# Variables:
#   $type-description (string) - Description of the type (e.g "Portable Document Format")
#   $type (string) - The MIME type (e.g application/binary)
applications-type-description-with-type = { $type-description } ({ $type })
# Variables:
#   $extension (string) - File extension (e.g .TXT)
#   $type (string) - The MIME type (e.g application/binary)
applications-file-ending-with-type = { applications-file-ending } ({ $type })
# Variables:
#   $plugin-name (string) - Name of a plugin (e.g Adobe Flash)
applications-use-plugin-in =
    .label = Χρήση { $plugin-name } (στο { -brand-short-name })
applications-open-inapp =
    .label = Άνοιγμα στο { -brand-short-name }

## The strings in this group are used to populate
## selected label element based on the string from
## the selected menu item.

applications-use-plugin-in-label =
    .value = { applications-use-plugin-in.label }
applications-action-save-label =
    .value = { applications-action-save.label }
applications-use-app-label =
    .value = { applications-use-app.label }
applications-open-inapp-label =
    .value = { applications-open-inapp.label }
applications-always-ask-label =
    .value = { applications-always-ask.label }
applications-use-app-default-label =
    .value = { applications-use-app-default.label }
applications-use-other-label =
    .value = { applications-use-other.label }
applications-use-os-default-label =
    .value = { applications-use-os-default.label }

##

applications-handle-new-file-types-description = Τι να κάνει το { -brand-short-name } με άλλα αρχεία;
applications-save-for-new-types =
    .label = Αποθήκευση αρχείων
    .accesskey = Α
applications-ask-before-handling =
    .label = Να γίνεται ερώτηση για το άνοιγμα ή την αποθήκευση αρχείων
    .accesskey = γ
drm-content-header = Περιεχόμενο διαχείρισης ψηφιακών δικαιωμάτων (DRM)
play-drm-content =
    .label = Αναπαραγωγή περιεχομένου με έλεγχο DRM
    .accesskey = Α
play-drm-content-learn-more = Μάθετε περισσότερα
update-application-title = Ενημερώσεις του { -brand-short-name }
update-application-description = Διατηρείτε το { -brand-short-name } ενημερωμένο για καλύτερη απόδοση, σταθερότητα και ασφάλεια.
# Variables:
# $version (string) - Waterfox version
update-application-version = Έκδοση { $version } <a data-l10n-name="learn-more">Τι νέο υπάρχει</a>
update-history =
    .label = Εμφάνιση ιστορικού ενημερώσεων…
    .accesskey = ν
update-application-allow-description = Να επιτρέπεται στο { -brand-short-name }
update-application-auto =
    .label = Αυτόματη εγκατάσταση ενημερώσεων (συνιστάται)
    .accesskey = Α
update-application-check-choose =
    .label = Έλεγχος για ενημερώσεις, αλλά με δυνατότητα επιλογής για εγκατάσταση
    .accesskey = Ε
update-application-manual =
    .label = Να μη γίνεται ποτέ έλεγχος για ενημερώσεις (δεν προτείνεται)
    .accesskey = Ν
update-application-background-enabled =
    .label = Όταν δεν εκτελείται το { -brand-short-name }
    .accesskey = Ό
update-application-warning-cross-user-setting = Αυτή η ρύθμιση θα εφαρμοστεί σε όλους τους λογαριασμούς των Windows και τα προφίλ του { -brand-short-name } που χρησιμοποιούν αυτήν την εγκατάσταση του { -brand-short-name }.
update-application-use-service =
    .label = Χρήση υπηρεσίας παρασκηνίου για την εγκατάσταση ενημερώσεων
    .accesskey = υ
update-application-suppress-prompts =
    .label = Εμφάνιση λιγότερων ειδοποιήσεων ενημέρωσης
    .accesskey = λ
update-setting-write-failure-title2 = Σφάλμα αποθήκευσης ρυθμίσεων ενημερώσεων
# Variables:
#   $path (string) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message2 =
    Το { -brand-short-name } αντιμετώπισε σφάλμα και δεν αποθήκευσε αυτή την αλλαγή. Σημειώστε ότι η αλλαγή αυτής της επιλογής ενημερώσεων απαιτεί δικαίωμα εγγραφής στο παρακάτω αρχείο. Εσείς ή κάποιος διαχειριστής συστήματος ενδέχεται να μπορέσει να επιλύσει το σφάλμα, χορηγώντας στην ομάδα "Χρήστες" τον πλήρη έλεγχο για αυτό το αρχείο.
    
    Δεν ήταν δυνατή η εγγραφή στο αρχείο: { $path }
update-in-progress-title = Ενημέρωση σε εξέλιξη
update-in-progress-message = Θέλετε το { -brand-short-name } να συνεχίσει με αυτή την ενημέρωση;
update-in-progress-ok-button = &Απόρριψη
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Συνέχεια

## General Section - Performance

performance-title = Επιδόσεις
performance-use-recommended-settings-checkbox =
    .label = Χρήση προτεινόμενων ρυθμίσεων επιδόσεων
    .accesskey = Χ
performance-use-recommended-settings-desc = Αυτές οι ρυθμίσεις είναι προσαρμοσμένες στο υλικό και το λειτουργικό σύστημα του υπολογιστή σας.
performance-settings-learn-more = Μάθετε περισσότερα
performance-allow-hw-accel =
    .label = Χρήση επιτάχυνσης υλικού όταν είναι διαθέσιμη
    .accesskey = λ
performance-limit-content-process-option = Όριο διεργασιών περιεχομένου
    .accesskey = Ο
performance-limit-content-process-enabled-desc = Οι επιπρόσθετες διεργασίες περιεχομένου μπορούν να βελτιώσουν τις επιδόσεις κατά τη χρήση πολλαπλών καρτελών, αλλά θα χρησιμοποιούν περισσότερη μνήμη.
performance-limit-content-process-blocked-desc = Η τροποποίηση του αριθμού των διεργασιών περιεχομένου είναι δυνατή μόνο στο { -brand-short-name } με τη δυνατότητα πολλαπλών διεργασιών. <a data-l10n-name="learn-more">Μάθετε πώς μπορείτε να ελέγξετε εάν είναι ενεργοποιημένη η λειτουργία πολλαπλών διεργασιών</a>
# Variables:
#   $num (number) - Default value of the `dom.ipc.processCount` pref.
performance-default-content-process-count =
    .label = { $num } (προεπιλογή)

## General Section - Browsing

browsing-title = Περιήγηση
browsing-use-autoscroll =
    .label = Χρήση αυτόματης κύλισης
    .accesskey = α
browsing-use-smooth-scrolling =
    .label = Χρήση ομαλής κύλισης
    .accesskey = μ
browsing-gtk-use-non-overlay-scrollbars =
    .label = Πάντα εμφάνιση γραμμών κύλισης
    .accesskey = μ
browsing-use-onscreen-keyboard =
    .label = Εμφάνιση πληκτρολογίου αφής όταν χρειάζεται
    .accesskey = π
browsing-use-cursor-navigation =
    .label = Πάντα χρήση των πλήκτρων κέρσορα για πλοήγηση στις σελίδες
    .accesskey = π
browsing-use-full-keyboard-navigation =
    .label = Χρήση του πλήκτρου Tab για μετακίνηση της εστίασης μεταξύ κουμπιών φόρμας και συνδέσμων
    .accesskey = T
browsing-search-on-start-typing =
    .label = Αναζήτηση κειμένου κατά την έναρξη πληκτρολόγησης
    .accesskey = ν
browsing-picture-in-picture-toggle-enabled =
    .label = Ενεργοποίηση στοιχείων ελέγχου βίντεο σε λειτουργία εικόνας εντός εικόνας
    .accesskey = Ε
browsing-picture-in-picture-learn-more = Μάθετε περισσότερα
browsing-media-control =
    .label = Έλεγχος πολυμέσων με πληκτρολόγιο, ακουστικά ή εικονική διεπαφή
    .accesskey = λ
browsing-media-control-learn-more = Μάθετε περισσότερα
browsing-cfr-recommendations =
    .label = Πρόταση επεκτάσεων κατά την περιήγησή σας
    .accesskey = Π
browsing-cfr-features =
    .label = Πρόταση λειτουργιών κατά την περιήγησή σας
    .accesskey = λ
browsing-cfr-recommendations-learn-more = Μάθετε περισσότερα

## General Section - Proxy

network-settings-title = Ρυθμίσεις δικτύου
network-proxy-connection-description = Ρυθμίστε τον τρόπο σύνδεσης του { -brand-short-name } στο διαδίκτυο.
network-proxy-connection-learn-more = Μάθετε περισσότερα
network-proxy-connection-settings =
    .label = Ρυθμίσεις…
    .accesskey = θ

## Home Section

home-new-windows-tabs-header = Νέα παράθυρα και καρτέλες
home-new-windows-tabs-description2 = Επιλέξτε τι θα βλέπετε όταν ανοίγετε την αρχική σας σελίδα, νέα παράθυρα και νέες καρτέλες.

## Home Section - Home Page Customization

home-homepage-mode-label = Αρχική σελίδα και νέα παράθυρα
home-newtabs-mode-label = Νέες καρτέλες
home-restore-defaults =
    .label = Επαναφορά προεπιλογών
    .accesskey = Ε
home-mode-choice-default-fx =
    .label = { -firefox-home-brand-name } (Προεπιλογή)
home-mode-choice-custom =
    .label = Προσαρμοσμένα URL…
home-mode-choice-blank =
    .label = Κενή σελίδα
home-homepage-custom-url =
    .placeholder = Επικόλληση URL…
# This string has a special case for '1' and [other] (default). If necessary for
# your language, you can add {$tabCount} to your translations and use the
# standard CLDR forms, or only use the form for [other] if both strings should
# be identical.
use-current-pages =
    .label =
        { $tabCount ->
            [1] Χρήση τρέχουσας σελίδας
           *[other] Χρήση τρεχουσών σελίδων
        }
    .accesskey = τ
choose-bookmark =
    .label = Χρήση σελιδοδείκτη…
    .accesskey = σ

## Home Section - Waterfox Home Content Customization

home-prefs-content-header2 = Περιεχόμενο οθόνης «{ -firefox-home-brand-name }»
home-prefs-content-description2 = Επιλέξτε το περιεχόμενο που θέλετε στην οθόνη «{ -firefox-home-brand-name }».
home-prefs-search-header =
    .label = Διαδικτυακή αναζήτηση
home-prefs-shortcuts-header =
    .label = Συντομεύσεις
home-prefs-shortcuts-description = Ιστότοποι από σελιδοδείκτες ή ιστορικό
home-prefs-shortcuts-by-option-sponsored =
    .label = Χορηγούμενες συντομεύσεις

## Variables:
##  $provider (string) - Name of the corresponding content provider, e.g "Pocket".

home-prefs-recommended-by-header =
    .label = Προτάσεις του { $provider }
home-prefs-recommended-by-description-new = Εξαιρετικό περιεχόμενο από το { $provider }, μέρος της οικογένειας του { -brand-product-name }

##

home-prefs-recommended-by-learn-more = Πώς λειτουργεί
home-prefs-recommended-by-option-sponsored-stories =
    .label = Χορηγούμενες ιστορίες
home-prefs-recommended-by-option-recent-saves =
    .label = Εμφάνιση πρόσφατων αποθηκεύσεων
home-prefs-highlights-option-visited-pages =
    .label = Σελίδες που έχετε επισκεφθεί
home-prefs-highlights-options-bookmarks =
    .label = Σελιδοδείκτες
home-prefs-highlights-option-most-recent-download =
    .label = Πιο πρόσφατες λήψεις
home-prefs-highlights-option-saved-to-pocket =
    .label = Αποθηκευμένες σελίδες του { -pocket-brand-name }
home-prefs-recent-activity-header =
    .label = Πρόσφατη δραστηριότητα
home-prefs-recent-activity-description = Μια συλλογή πρόσφατων ιστοτόπων και περιεχομένου
# For the "Snippets" feature traditionally on about:home.
# Alternative translation options: "Small Note" or something that
# expresses the idea of "a small message, shortened from something else,
# and non-essential but also not entirely trivial and useless.
home-prefs-snippets-header =
    .label = Αποσπάσματα
home-prefs-snippets-description-new = Συμβουλές και νέα από τη { -vendor-short-name } και το { -brand-product-name }
# Variables:
#   $num (number) - Number of rows displayed
home-prefs-sections-rows-option =
    .label =
        { $num ->
            [one] { $num } σειρά
           *[other] { $num } σειρές
        }

## Search Section

search-bar-header = Γραμμή αναζήτησης
search-bar-hidden =
    .label = Χρήση της γραμμής διευθύνσεων για αναζήτηση και πλοήγηση
search-bar-shown =
    .label = Προσθήκη γραμμής αναζήτησης στη γραμμή εργαλείων
search-engine-default-header = Προεπιλεγμένη μηχανή αναζήτησης
search-engine-default-desc-2 = Αυτή είναι η προεπιλεγμένη μηχανή αναζήτησης στη γραμμή διευθύνσεων και τη γραμμή αναζήτησης. Μπορείτε να την αλλάξετε ανά πάσα στιγμή.
search-engine-default-private-desc-2 = Επιλέξτε μια διαφορετική προεπιλεγμένη μηχανή αναζήτησης μόνο για ιδιωτικά παράθυρα
search-separate-default-engine =
    .label = Χρήση αυτής της μηχανής αναζήτησης σε ιδιωτικά παράθυρα
    .accesskey = Χ
search-suggestions-header = Προτάσεις αναζήτησης
search-suggestions-desc = Επιλέξτε πώς εμφανίζονται οι προτάσεις από τις μηχανές αναζήτησης.
search-suggestions-option =
    .label = Παροχή προτάσεων αναζήτησης
    .accesskey = Π
search-show-suggestions-url-bar-option =
    .label = Εμφάνιση προτάσεων αναζήτησης στα αποτελέσματα της γραμμής διευθύνσεων
    .accesskey = τ
# With this option enabled, on the search results page
# the URL will be replaced by the search terms in the address bar
# when using the current default search engine.
search-show-search-term-option =
    .label = Εμφάνιση όρων αναζήτησης αντί του URL στη σελίδα αποτελεσμάτων της προεπιλεγμένης μηχανής αναζήτησης
# This string describes what the user will observe when the system
# prioritizes search suggestions over browsing history in the results
# that extend down from the address bar. In the original English string,
# "ahead" refers to location (appearing most proximate to), not time
# (appearing before).
search-show-suggestions-above-history-option =
    .label = Εμφάνιση προτάσεων αναζήτησης πριν το ιστορικό περιήγησης στα αποτελέσματα γραμμής διευθύνσεων
search-show-suggestions-private-windows =
    .label = Εμφάνιση προτάσεων αναζήτησης σε ιδιωτικά παράθυρα
suggestions-addressbar-settings-generic2 = Αλλαγή ρυθμίσεων για άλλες προτάσεις της γραμμής διευθύνσεων
search-suggestions-cant-show = Οι προτάσεις αναζήτησης δεν θα εμφανίζονται στη γραμμή διευθύνσεων, καθώς έχετε ρυθμίσει το { -brand-short-name } ώστε να μη διατηρεί ποτέ το ιστορικό.
search-one-click-header2 = Συντομεύσεις αναζήτησης
search-one-click-desc = Επιλέξτε τις εναλλακτικές μηχανές αναζήτησης που εμφανίζονται κάτω από τη γραμμή διευθύνσεων και τη γραμμή αναζήτησης όταν αρχίσετε να πληκτρολογείτε μια λέξη-κλειδί.
search-choose-engine-column =
    .label = Μηχανή αναζήτησης
search-choose-keyword-column =
    .label = Λέξη-κλειδί
search-restore-default =
    .label = Επαναφορά προεπιλεγμένων μηχανών αναζήτησης
    .accesskey = φ
search-remove-engine =
    .label = Αφαίρεση
    .accesskey = Α
search-add-engine =
    .label = Προσθήκη
    .accesskey = Π
search-find-more-link = Εύρεση περισσότερων μηχανών αναζήτησης
# This warning is displayed when the chosen keyword is already in use
# ('Duplicate' is an adjective)
search-keyword-warning-title = Διπλή λέξη-κλειδί
# Variables:
#   $name (string) - Name of a search engine.
search-keyword-warning-engine = Έχετε επιλέξει μια λέξη-κλειδί που χρησιμοποιείται ήδη από το «{ $name }». Παρακαλώ επιλέξτε κάποια άλλη.
search-keyword-warning-bookmark = Έχετε επιλέξει μια λέξη-κλειδί που χρησιμοποιείται ήδη από ένα σελιδοδείκτη. Παρακαλώ επιλέξτε κάποια άλλη.

## Containers Section

containers-back-button2 =
    .aria-label = Πίσω στις ρυθμίσεις
containers-header = Θεματικές καρτέλες
containers-add-button =
    .label = Προσθήκη νέας θεματικής ενότητας
    .accesskey = Π
containers-new-tab-check =
    .label = Επιλογή ενότητας για κάθε νέα καρτέλα
    .accesskey = Ε
containers-settings-button =
    .label = Ρυθμίσεις
containers-remove-button =
    .label = Αφαίρεση

## Waterfox account - Signed out. Note that "Sync" and "Waterfox account" are now
## more discrete ("signed in" no longer means "and sync is connected").

sync-signedout-caption = Πάρτε μαζί σας το διαδίκτυο
sync-signedout-description2 = Συγχρονίστε τους σελιδοδείκτες, το ιστορικό, τις καρτέλες, τους κωδικούς πρόσβασης, τα πρόσθετα και τις ρυθμίσεις σας σε όλες τις συσκευές σας.
sync-signedout-account-signin3 =
    .label = Σύνδεση για συγχρονισμό…
    .accesskey = ν
# This message contains two links and two icon images.
#   `<img data-l10n-name="android-icon"/>` - Android logo icon
#   `<a data-l10n-name="android-link">` - Link to Android Download
#   `<img data-l10n-name="ios-icon">` - iOS logo icon
#   `<a data-l10n-name="ios-link">` - Link to iOS Download
#
# They can be moved within the sentence as needed to adapt
# to your language, but should not be changed or translated.
sync-mobile-promo = Κάντε λήψη του Waterfox για <img data-l10n-name="android-icon"/> <a data-l10n-name="android-link">Android</a> ή <img data-l10n-name="ios-icon"/> <a data-l10n-name="ios-link">iOS</a> για συγχρονισμό με την κινητή σας συσκευή.

## Waterfox account - Signed in

sync-profile-picture =
    .tooltiptext = Αλλαγή εικόνας προφίλ
sync-sign-out =
    .label = Αποσύνδεση…
    .accesskey = ν
sync-manage-account = Διαχείριση λογαριασμού
    .accesskey = η

## Variables
## $email (string) - Email used for Waterfox account

sync-signedin-unverified = { $email } Μη επαληθευμένος.
sync-signedin-login-failure = Παρακαλούμε συνδεθείτε ξανά για επανασύνδεση { $email }

##

sync-resend-verification =
    .label = Εκ νέου αποστολή επαλήθευσης
    .accesskey = λ
sync-remove-account =
    .label = Αφαίρεση λογαριασμού
    .accesskey = Α
sync-sign-in =
    .label = Σύνδεση
    .accesskey = σ

## Sync section - enabling or disabling sync.

prefs-syncing-on = Συγχρονισμός: ΕΝΕΡΓΟΣ
prefs-syncing-off = Συγχρονισμός: ΑΝΕΝΕΡΓΟΣ
prefs-sync-turn-on-syncing =
    .label = Ενεργοποίηση συγχρονισμού…
    .accesskey = ρ
prefs-sync-offer-setup-label2 = Συγχρονίστε τους σελιδοδείκτες, το ιστορικό, τις καρτέλες, τους κωδικούς πρόσβασης, τα πρόσθετα και τις ρυθμίσεις σας σε όλες τις συσκευές σας.
prefs-sync-now =
    .labelnotsyncing = Συγχρονισμός τώρα
    .accesskeynotsyncing = τ
    .labelsyncing = Συγχρονισμός…
prefs-sync-now-button =
    .label = Συγχρονισμός τώρα
    .accesskey = τ
prefs-syncing-button =
    .label = Συγχρονισμός…

## The list of things currently syncing.

sync-syncing-across-devices-heading = Μπορείτε να συγχρονίσετε αυτά τα στοιχεία σε όλες τις συνδεδεμένες συσκευές σας:
sync-currently-syncing-bookmarks = Σελιδοδείκτες
sync-currently-syncing-history = Ιστορικό
sync-currently-syncing-tabs = Ανοικτές καρτέλες
sync-currently-syncing-logins-passwords = Συνδέσεις και κωδικοί πρόσβασης
sync-currently-syncing-addresses = Διευθύνσεις
sync-currently-syncing-creditcards = Πιστωτικές κάρτες
sync-currently-syncing-addons = Πρόσθετα
sync-currently-syncing-settings = Ρυθμίσεις
sync-change-options =
    .label = Αλλαγή…
    .accesskey = Α

## The "Choose what to sync" dialog.

sync-choose-what-to-sync-dialog3 =
    .title = Επιλέξτε στοιχεία για συγχρονισμό
    .style = min-width: 36em;
    .buttonlabelaccept = Αποθήκευση αλλαγών
    .buttonaccesskeyaccept = π
    .buttonlabelextra2 = Αποσύνδεση…
    .buttonaccesskeyextra2 = Α
sync-choose-dialog-subtitle = Οι αλλαγές στη λίστα των στοιχείων προς συγχρονισμό θα αντικατοπτρίζονται σε όλες τις συνδεδεμένες συσκευές σας.
sync-engine-bookmarks =
    .label = Σελιδοδείκτες
    .accesskey = δ
sync-engine-history =
    .label = Ιστορικό
    .accesskey = ρ
sync-engine-tabs =
    .label = Ανοικτές καρτέλες
    .tooltiptext = Μια λίστα με όλα όσα είναι ανοικτά στις συγχρονισμένες συσκευές
    .accesskey = κ
sync-engine-logins-passwords =
    .label = Συνδέσεις και κωδικοί πρόσβασης
    .tooltiptext = Αποθηκευμένα ονόματα χρήστη και κωδικοί πρόσβασης
    .accesskey = Σ
sync-engine-addresses =
    .label = Διευθύνσεις
    .tooltiptext = Διευθύνσεις αποστολής που έχετε αποθηκεύσει (μόνο για υπολογιστές)
    .accesskey = ν
sync-engine-creditcards =
    .label = Πιστωτικές κάρτες
    .tooltiptext = Ονόματα, αριθμοί και ημερομηνίες λήξης (μόνο για υπολογιστές)
    .accesskey = Π
sync-engine-addons =
    .label = Πρόσθετα
    .tooltiptext = Επεκτάσεις και θέματα για το Waterfox για υπολογιστές
    .accesskey = Π
sync-engine-settings =
    .label = Ρυθμίσεις
    .tooltiptext = Ρυθμίσεις που έχετε αλλάξει στις ενότητες "Γενικά" και "Απόρρητο & ασφάλεια"
    .accesskey = θ

## The device name controls.

sync-device-name-header = Όνομα συσκευής
sync-device-name-change =
    .label = Αλλαγή ονόματος συσκευής…
    .accesskey = λ
sync-device-name-cancel =
    .label = Ακύρωση
    .accesskey = κ
sync-device-name-save =
    .label = Αποθήκευση
    .accesskey = θ
sync-connect-another-device = Σύνδεση άλλης συσκευής

## These strings are shown in a desktop notification after the
## user requests we resend a verification email.

sync-verification-sent-title = Η επιβεβαίωση εστάλη
# Variables:
#   $email (String): Email address of user's Waterfox account.
sync-verification-sent-body = Έχει σταλεί ένα σύνδεσμος επαλήθευσης στην διεύθυνση { $email }.
sync-verification-not-sent-title = Αδυναμία αποστολής επιβεβαίωσης
sync-verification-not-sent-body = Δεν μπορέσαμε να στείλουμε ένα email επαλήθευσης, παρακαλούμε δοκιμάστε ξανά αργότερα.

## Privacy Section

privacy-header = Απόρρητο προγράμματος περιήγησης

## Privacy Section - Logins and Passwords

# The search keyword isn't shown to users but is used to find relevant settings in about:preferences.
pane-privacy-logins-and-passwords-header = Συνδέσεις και κωδικοί πρόσβασης
    .searchkeywords = { -lockwise-brand-short-name }
# Checkbox to control whether UI is shown to users to save or fill logins/passwords.
forms-ask-to-save-logins =
    .label = Ερώτηση για αποθήκευση στοιχείων σύνδεσης για ιστοτόπους
    .accesskey = ρ
forms-exceptions =
    .label = Εξαιρέσεις…
    .accesskey = ξ
forms-generate-passwords =
    .label = Πρόταση και δημιουργία ισχυρών κωδικών πρόσβασης
    .accesskey = ρ
forms-breach-alerts =
    .label = Εμφάνιση ειδοποιήσεων για κωδικούς πρόσβασης από παραβιασμένους ιστοτόπους
    .accesskey = μ
forms-breach-alerts-learn-more-link = Μάθετε περισσότερα
preferences-relay-integration-checkbox =
    .label = Πρόταση μασκών email του { -relay-brand-name } για την προστασία της διεύθυνσης email σας
relay-integration-learn-more-link = Μάθετε περισσότερα
# Checkbox which controls filling saved logins into fields automatically when they appear, in some cases without user interaction.
forms-fill-logins-and-passwords =
    .label = Αυτόματη συμπλήρωση συνδέσεων και κωδικών πρόσβασης
    .accesskey = ρ
forms-saved-logins =
    .label = Αποθηκευμένες συνδέσεις…
    .accesskey = π
forms-primary-pw-use =
    .label = Χρήση κύριου κωδικού πρόσβασης
    .accesskey = Χ
forms-primary-pw-learn-more-link = Μάθετε περισσότερα
# This string uses the former name of the Primary Password feature
# ("Master Password" in English) so that the preferences can be found
# when searching for the old name. The accesskey is unused.
forms-master-pw-change =
    .label = Αλλαγή κύριου κωδικού…
    .accesskey = γ
forms-primary-pw-change =
    .label = Αλλαγή κύριου κωδικού πρόσβασης…
    .accesskey = κ
# Leave this message empty if the translation for "Primary Password" matches
# "Master Password" in your language. If you're editing the FTL file directly,
# use { "" } as the value.
forms-primary-pw-former-name = { "" }
forms-primary-pw-fips-title = Είστε σε λειτουργία FIPS. Το FIPS απαιτεί μη κενό κύριο κωδικό πρόσβασης.
forms-master-pw-fips-desc = Αποτυχία αλλαγής κωδικού
forms-windows-sso =
    .label = Να επιτρέπεται η καθολική σύνδεση των Windows για λογαριασμούς Microsoft, εργασίας και σχολείου.
forms-windows-sso-learn-more-link = Μάθετε περισσότερα
forms-windows-sso-desc = Διαχειριστείτε τους λογαριασμούς σας στις ρυθμίσεις συσκευής

## OS Authentication dialog

# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Για να δημιουργήσετε έναν κύριο κωδικό πρόσβασης, εισάγετε τα διαπιστευτήρια των Windows σας. Αυτό θα συμβάλλει στην ασφάλεια των λογαριασμών σας.
# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Waterfox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = δημιουργήσει κύριο κωδικό πρόσβασης
master-password-os-auth-dialog-caption = { -brand-full-name }

## Privacy Section - History

history-header = Ιστορικό
# This label is followed, on the same line, by a dropdown list of options
# (Remember history, etc.).
# In English it visually creates a full sentence, e.g.
# "Waterfox will" + "Remember history".
#
# If this doesn't work for your language, you can translate this message:
#   - Simply as "Waterfox", moving the verb into each option.
#     This will result in "Waterfox" + "Will remember history", etc.
#   - As a stand-alone message, for example "Waterfox history settings:".
history-remember-label = Το { -brand-short-name }
    .accesskey = ο
history-remember-option-all =
    .label = Θα διατηρεί το ιστορικό
history-remember-option-never =
    .label = Δεν θα διατηρεί ποτέ το ιστορικό
history-remember-option-custom =
    .label = Θα κάνει χρήση προσαρμοσμένων ρυθμίσεων ιστορικού
history-remember-description = Το { -brand-short-name } θα αποθηκεύει το ιστορικό περιήγησης, λήψεων, φορμών και αναζητήσεων.
history-dontremember-description = Το { -brand-short-name } θα χρησιμοποιεί τις ίδιες ρυθμίσεις με την ιδιωτική περιήγηση και δεν θα διατηρεί το ιστορικό περιήγησης σας.
history-private-browsing-permanent =
    .label = Μόνιμη λειτουργία ιδιωτικής περιήγησης
    .accesskey = ι
history-remember-browser-option =
    .label = Διατήρηση ιστορικού περιήγησης και λήψεων
    .accesskey = τ
history-remember-search-option =
    .label = Διατήρηση ιστορικού αναζήτησης και φορμών
    .accesskey = φ
history-clear-on-close-option =
    .label = Απαλοιφή ιστορικού όταν κλείνει το { -brand-short-name }
    .accesskey = κ
history-clear-on-close-settings =
    .label = Ρυθμίσεις…
    .accesskey = θ
history-clear-button =
    .label = Απαλοιφή ιστορικού…
    .accesskey = σ

## Privacy Section - Site Data

sitedata-header = Cookies και δεδομένα ιστοτόπων
sitedata-total-size-calculating = Υπολογισμός μεγέθους δεδομένων ιστοτόπου και προσωρινής μνήμης…
# Variables:
#   $value (number) - Value of the unit (for example: 4.6, 500)
#   $unit (string) - Name of the unit (for example: "bytes", "KB")
sitedata-total-size = Αυτή τη στιγμή, τα αποθηκευμένα cookies, τα δεδομένα ιστοτόπων και η κρυφή μνήμη καταλαμβάνουν { $value } { $unit } χώρου στον δίσκο.
sitedata-learn-more = Μάθετε περισσότερα
sitedata-delete-on-close =
    .label = Διαγραφή cookies και δεδομένων ιστοτόπων όταν κλείνει το { -brand-short-name }
    .accesskey = c
sitedata-delete-on-close-private-browsing = Στη λειτουργία μόνιμης ιδιωτικής περιήγησης, τα cookies και τα δεδομένα ιστοτόπων θα διαγράφονται πάντα όταν κλείνει το { -brand-short-name }.
sitedata-allow-cookies-option =
    .label = Αποδοχή cookies και δεδομένων ιστοτόπων
    .accesskey = Α
sitedata-disallow-cookies-option =
    .label = Φραγή cookies και δεδομένων ιστοτόπων
    .accesskey = Φ
# This label means 'type of content that is blocked', and is followed by a drop-down list with content types below.
# The list items are the strings named sitedata-block-*-option*.
sitedata-block-desc = Αποκλεισμένος τύπος
    .accesskey = τ
sitedata-option-block-cross-site-trackers =
    .label = Ιχνηλάτες μεταξύ ιστοτόπων
sitedata-option-block-cross-site-tracking-cookies =
    .label = Cookies καταγραφής μεταξύ ιστοτόπων
sitedata-option-block-cross-site-cookies =
    .label = Cookies καταγραφής μεταξύ ιστοτόπων και απομόνωση άλλων cookies μεταξύ ιστοτόπων
sitedata-option-block-unvisited =
    .label = Cookies από ιστοτόπους που δεν έχετε επισκεφθεί
sitedata-option-block-all-cross-site-cookies =
    .label = Όλα τα cookies μεταξύ ιστοτόπων (πιθανή δυσλειτουργία ιστοτόπων)
sitedata-option-block-all =
    .label = Όλα τα cookies (προκαλεί δυσλειτουργία ιστοτόπων)
sitedata-clear =
    .label = Απαλοιφή δεδομένων…
    .accesskey = ι
sitedata-settings =
    .label = Διαχείριση δεδομένων…
    .accesskey = Δ
sitedata-cookies-exceptions =
    .label = Διαχείριση εξαιρέσεων…
    .accesskey = σ

## Privacy Section - Cookie Banner Handling

cookie-banner-handling-header = Μείωση μηνυμάτων για cookies
cookie-banner-handling-description = Το { -brand-short-name } προσπαθεί να απορρίψει αυτόματα όλα τα μηνύματα αιτημάτων για cookies σε υποστηριζόμενους ιστότοπους.
cookie-banner-learn-more = Μάθετε περισσότερα
forms-handle-cookie-banners =
    .label = Μείωση μηνυμάτων για cookies

## Privacy Section - Address Bar

addressbar-header = Γραμμή διευθύνσεων
addressbar-suggest = Κατά τη χρήση της γραμμής διευθύνσεων, να γίνεται πρόταση
addressbar-locbar-history-option =
    .label = Ιστορικού περιήγησης
    .accesskey = Ι
addressbar-locbar-bookmarks-option =
    .label = Σελιδοδεικτών
    .accesskey = δ
addressbar-locbar-clipboard-option =
    .label = Πρόχειρο
    .accesskey = Π
addressbar-locbar-openpage-option =
    .label = Ανοικτών καρτελών
    .accesskey = Ο
# Shortcuts refers to the shortcut tiles on the new tab page, previously known as top sites. Translation should be consistent.
addressbar-locbar-shortcuts-option =
    .label = Συντομεύσεων
    .accesskey = Σ
addressbar-locbar-topsites-option =
    .label = Κορυφαίων ιστοτόπων
    .accesskey = Κ
addressbar-locbar-engines-option =
    .label = Μηχανών αναζήτησης
    .accesskey = α
addressbar-locbar-quickactions-option =
    .label = Γρήγορων ενεργειών
    .accesskey = Γ
addressbar-suggestions-settings = Αλλαγή προτιμήσεων για τις προτάσεις μηχανών αναζήτησης
addressbar-quickactions-learn-more = Μάθετε περισσότερα

## Privacy Section - Content Blocking

content-blocking-enhanced-tracking-protection = Ενισχυμένη προστασία από καταγραφή
content-blocking-section-top-level-description = Οι ιχνηλάτες σάς ακολουθούν στο διαδίκτυο ώστε να συλλέξουν δεδομένα για τις συνήθειες και τα ενδιαφέροντά σας. Το { -brand-short-name } αποκλείει πολλούς από αυτούς, καθώς και άλλα κακόβουλα σενάρια.
content-blocking-learn-more = Μάθετε περισσότερα
content-blocking-fpi-incompatibility-warning = Χρησιμοποιείτε τη λειτουργία First Party Isolation (FPI), που παρακάμπτει ορισμένες ρυθμίσεις cookie του { -brand-short-name }.

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

# "Standard" in this case is an adjective, meaning "default" or "normal".
enhanced-tracking-protection-setting-standard =
    .label = Τυπική
    .accesskey = Τ
enhanced-tracking-protection-setting-strict =
    .label = Αυστηρή
    .accesskey = Α
enhanced-tracking-protection-setting-custom =
    .label = Προσαρμοσμένη
    .accesskey = Π

##

content-blocking-etp-standard-desc = Ισορροπία μεταξύ προστασίας και επιδόσεων. Οι σελίδες θα φορτώνονται κανονικά.
content-blocking-etp-strict-desc = Ισχυρότερη προστασία, αλλά πιθανή δυσλειτουργία μερικών ιστοτόπων ή περιεχομένου.
content-blocking-etp-custom-desc = Επιλέξτε ιχνηλάτες και σενάρια για αποκλεισμό.
content-blocking-etp-blocking-desc = Το { -brand-short-name } αποκλείει τα εξής:
content-blocking-private-windows = Περιεχόμενο καταγραφής σε ιδιωτικά παράθυρα
content-blocking-cross-site-cookies-in-all-windows2 = Cookies μεταξύ ιστοτόπων σε όλα τα παράθυρα
content-blocking-cross-site-tracking-cookies = Cookies καταγραφής μεταξύ ιστοτόπων
content-blocking-all-cross-site-cookies-private-windows = Cookies μεταξύ ιστοτόπων σε ιδιωτικά παράθυρα
content-blocking-cross-site-tracking-cookies-plus-isolate = Cookies καταγραφής μεταξύ ιστοτόπων και απομόνωση των υπόλοιπων
content-blocking-social-media-trackers = Ιχνηλάτες κοινωνικών δικτύων
content-blocking-all-cookies = Όλα τα cookies
content-blocking-unvisited-cookies = Cookies από ιστοτόπους που δεν έχετε επισκεφθεί
content-blocking-all-windows-tracking-content = Περιεχόμενο καταγραφής σε όλα τα παράθυρα
content-blocking-all-cross-site-cookies = Όλα τα cookies μεταξύ ιστοτόπων
content-blocking-cryptominers = Cryptominers
content-blocking-fingerprinters = Fingerprinters
# The known fingerprinters are those that are known for collecting browser fingerprints from user devices. And
# the suspected fingerprinters are those that we are uncertain about browser fingerprinting activities. But they could
# possibly acquire browser fingerprints because of the behavior on accessing APIs that expose browser fingerprints.
content-blocking-known-and-suspected-fingerprinters = Γνωστά και ύποπτα fingerprinter

# The tcp-rollout strings are no longer used for the rollout but for tcp-by-default in the standard section

# "Contains" here means "isolates", "limits".
content-blocking-etp-standard-tcp-rollout-description = Η Ολική προστασία cookie περιορίζει τα cookies στον ιστότοπο που βρίσκεστε, ώστε να μην μπορούν να χρησιμοποιηθούν από ιχνηλάτες για την καταγραφή της δραστηριότητάς σας.
content-blocking-etp-standard-tcp-rollout-learn-more = Μάθετε περισσότερα
content-blocking-etp-standard-tcp-title = Περιλαμβάνει την Ολική προστασία cookie, την πιο ισχυρή μας λειτουργία απορρήτου
content-blocking-warning-title = Προσοχή!
content-blocking-and-isolating-etp-warning-description-2 = Αυτή η ρύθμιση ενδέχεται να εμποδίσει την εμφάνιση περιεχομένου ή τη σωστή λειτουργία ορισμένων ιστοτόπων. Αν κάποιος ιστότοπος δεν λειτουργεί σωστά, μπορείτε να απενεργοποιήσετε την προστασία από καταγραφή για να γίνει φόρτωση όλου του περιεχομένου.
content-blocking-warning-learn-how = Μάθετε πώς
content-blocking-reload-description = Θα πρέπει να φορτώσετε ξανά τις καρτέλες σας για εφαρμογή των αλλαγών αυτών.
content-blocking-reload-tabs-button =
    .label = Ανανέωση όλων των καρτελών
    .accesskey = Α
content-blocking-tracking-content-label =
    .label = Περιεχόμενο καταγραφής
    .accesskey = Π
content-blocking-tracking-protection-option-all-windows =
    .label = Σε όλα τα παράθυρα
    .accesskey = ό
content-blocking-option-private =
    .label = Μόνο σε ιδιωτικά παράθυρα
    .accesskey = ι
content-blocking-tracking-protection-change-block-list = Αλλαγή λίστας φραγής
content-blocking-cookies-label =
    .label = Cookies
    .accesskey = C
content-blocking-expand-section =
    .tooltiptext = Περισσότερες πληροφορίες
# Cryptomining refers to using scripts on websites that can use a computer’s resources to mine cryptocurrency without a user’s knowledge.
content-blocking-cryptominers-label =
    .label = Cryptominer
    .accesskey = y
# Browser fingerprinting is a method of tracking users by the configuration and settings information (their "digital fingerprint")
# that is visible to websites they browse, rather than traditional tracking methods such as IP addresses and unique cookies.
content-blocking-fingerprinters-label =
    .label = Fingerprinters
    .accesskey = F
# Browser fingerprinting is a method of tracking users by the configuration and settings information (their "digital fingerprint")
# that is visible to websites they browse, rather than traditional tracking methods such as IP addresses and unique cookies.
#
# The known fingerprinters are those that are known for collecting browser fingerprints from user devices.
content-blocking-known-fingerprinters-label =
    .label = Γνωστά fingerprinter
    .accesskey = Γ
# The suspected fingerprinters are those that we are uncertain about browser fingerprinting activities. But they could
# possibly acquire browser fingerprints because of the behavior on accessing APIs that expose browser fingerprints.
content-blocking-suspected-fingerprinters-label =
    .label = Πιθανά fingerprinter
    .accesskey = Π

## Privacy Section - Tracking

tracking-manage-exceptions =
    .label = Διαχείριση εξαιρέσεων…
    .accesskey = χ

## Privacy Section - Permissions

permissions-header = Δικαιώματα
permissions-location = Τοποθεσία
permissions-location-settings =
    .label = Ρυθμίσεις…
    .accesskey = θ
permissions-xr = Εικονική πραγματικότητα
permissions-xr-settings =
    .label = Ρυθμίσεις…
    .accesskey = μ
permissions-camera = Κάμερα
permissions-camera-settings =
    .label = Ρυθμίσεις…
    .accesskey = θ
permissions-microphone = Μικρόφωνο
permissions-microphone-settings =
    .label = Ρυθμίσεις…
    .accesskey = θ
# Short form for "the act of choosing sound output devices and redirecting audio to the chosen devices".
permissions-speaker = Επιλογή ηχείου
permissions-speaker-settings =
    .label = Ρυθμίσεις…
    .accesskey = θ
permissions-notification = Ειδοποιήσεις
permissions-notification-settings =
    .label = Ρυθμίσεις…
    .accesskey = θ
permissions-notification-link = Μάθετε περισσότερα
permissions-notification-pause =
    .label = Παύση ειδοποιήσεων μέχρι να επανεκκινηθεί το { -brand-short-name }
    .accesskey = ε
permissions-autoplay = Αυτόματη αναπαραγωγή
permissions-autoplay-settings =
    .label = Ρυθμίσεις...
    .accesskey = θ
permissions-block-popups =
    .label = Φραγή αναδυόμενων παραθύρων
    .accesskey = Φ
# "popup" is a misspelling that is more popular than the correct spelling of
# "pop-up" so it's included as a search keyword, not displayed in the UI.
permissions-block-popups-exceptions-button =
    .label = Εξαιρέσεις…
    .accesskey = Ε
    .searchkeywords = αναδυόμενα
permissions-addon-install-warning =
    .label = Προειδοποίηση όταν οι ιστότοποι προσπαθούν να εγκαταστήσουν πρόσθετα
    .accesskey = Π
permissions-addon-exceptions =
    .label = Εξαιρέσεις…
    .accesskey = Ε

## Privacy Section - Data Collection

collection-header = Συλλογή και χρήση δεδομένων { -brand-short-name }
collection-header2 = Συλλογή και χρήση δεδομένων { -brand-short-name }
    .searchkeywords = τηλεμετρία
collection-description = Αγωνιζόμαστε για να σας παρέχουμε επιλογές και συλλέγουμε μόνο αυτά που χρειαζόμαστε, ώστε να παρέχουμε και να βελτιώσουμε το { -brand-short-name } για όλους. Ζητούμε πάντα την άδεια πριν λάβουμε προσωπικές πληροφορίες.
collection-privacy-notice = Σημείωση απορρήτου
collection-health-report-telemetry-disabled = Δεν επιτρέπεται πλέον στη { -vendor-short-name } η συλλογή τεχνικών δεδομένων και δεδομένων αλληλεπίδρασης. Όλα τα προηγούμενα δεδομένα θα διαγραφούν μέσα σε 30 ημέρες.
collection-health-report-telemetry-disabled-link = Μάθετε περισσότερα
collection-health-report =
    .label = Να επιτρέπεται στο { -brand-short-name } η αποστολή τεχνικών και διαδραστικών δεδομένων στη { -vendor-short-name }
    .accesskey = δ
collection-health-report-link = Μάθετε περισσότερα
collection-studies =
    .label = Να επιτρέπεται στο { -brand-short-name } να εγκαθιστά και να εκτελεί μελέτες
collection-studies-link = Προβολή μελετών του { -brand-short-name }
addon-recommendations =
    .label = Αποδοχή εξατομικευμένων προτάσεων για επεκτάσεις από το { -brand-short-name }
addon-recommendations-link = Μάθετε περισσότερα
# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = Η αναφορά δεδομένων είναι ανενεργή για αυτήν τη ρύθμιση δομής
collection-backlogged-crash-reports-with-link = Να επιτρέπεται στο { -brand-short-name } η αποστολή αναφορών καταρρεύσεων με καθυστέρηση <a data-l10n-name="crash-reports-link">Μάθετε περισσότερα</a>
    .accesskey = κ
privacy-segmentation-section-header = Νέες λειτουργίες που βελτιώνουν την περιήγησή σας
privacy-segmentation-section-description = Όταν προσφέρουμε λειτουργίες που χρησιμοποιούν τα δεδομένα σας για μια πιο εξατομικευμένη εμπειρία:
privacy-segmentation-radio-off =
    .label = Χρήση προτάσεων του { -brand-product-name }
privacy-segmentation-radio-on =
    .label = Εμφάνιση λεπτομερών πληροφοριών

## Privacy Section - Security
##
## It is important that wording follows the guidelines outlined on this page:
## https://developers.google.com/safe-browsing/developers_guide_v2#AcceptableUsage

security-header = Ασφάλεια
security-browsing-protection = Προστασία από παραπλανητικό περιεχόμενο και επικίνδυνο λογισμικό
security-enable-safe-browsing =
    .label = Φραγή επικίνδυνου και παραπλανητικού περιεχομένου
    .accesskey = Φ
security-enable-safe-browsing-link = Μάθετε περισσότερα
security-block-downloads =
    .label = Φραγή επικίνδυνων λήψεων
    .accesskey = λ
security-block-uncommon-software =
    .label = Προειδοποίηση για ανεπιθύμητο και ασυνήθιστο λογισμικό
    .accesskey = σ

## Privacy Section - Certificates

certs-header = Πιστοποιητικά
certs-enable-ocsp =
    .label = Αίτημα σε διακομιστές OCSP για την επιβεβαίωση της τρέχουσας εγκυρότητας των πιστοποιητικών
    .accesskey = δ
certs-view =
    .label = Προβολή πιστοποιητικών…
    .accesskey = Π
certs-devices =
    .label = Συσκευές ασφαλείας…
    .accesskey = Σ
space-alert-over-5gb-settings-button =
    .label = Άνοιγμα ρυθμίσεων
    .accesskey = Ά
space-alert-over-5gb-message2 = <strong>Το { -brand-short-name } δεν διαθέτει επαρκή χώρο στον δίσκο.</strong> Το περιεχόμενο των ιστοτόπων ενδέχεται να μην εμφανίζεται κανονικά. Μπορείτε να διαγράψετε τα αποθηκευμένα δεδομένα στις Ρυθμίσεις > Απόρρητο και ασφάλεια > Cookies και δεδομένα ιστοτόπων.
space-alert-under-5gb-message2 = <strong>Το { -brand-short-name } δεν διαθέτει επαρκή χώρο στον δίσκο.</strong> Το περιεχόμενο των ιστοτόπων ενδέχεται να μην εμφανίζεται κανονικά. Επισκεφθείτε το «Μάθετε περισσότερα» για να βελτιστοποιήσετε τη χρήση δίσκου σας για μια καλύτερη εμπειρία περιήγησης.

## Privacy Section - HTTPS-Only

httpsonly-header = Λειτουργία «Μόνο HTTPS»
httpsonly-description = Το HTTPS παρέχει μια ασφαλή, κρυπτογραφημένη σύνδεση μεταξύ του { -brand-short-name } και των ιστοτόπων που επισκέπτεστε. Οι περισσότεροι ιστότοποι υποστηρίζουν το HTTPS και αν είναι ενεργή η λειτουργία «Μόνο HTTPS», τότε το { -brand-short-name } θα αναβαθμίζει όλες τις συνδέσεις σε HTTPS.
httpsonly-learn-more = Μάθετε περισσότερα
httpsonly-radio-enabled =
    .label = Ενεργοποίηση λειτουργίας «Μόνο HTTPS» σε όλα τα παράθυρα
httpsonly-radio-enabled-pbm =
    .label = Ενεργοποίηση λειτουργίας «Μόνο HTTPS» μόνο σε ιδιωτικά παράθυρα
httpsonly-radio-disabled =
    .label = Να μην ενεργοποιηθεί η λειτουργία «Μόνο HTTPS»

## DoH Section

preferences-doh-header = DNS over HTTPS
preferences-doh-description = Το DNS (Domain Name System) over HTTPS στέλνει το αίτημά σας για όνομα τομέα μέσω κρυπτογραφημένης σύνδεσης, δημιουργώντας ένα ασφαλές DNS και δυσκολεύοντας τους άλλους να δουν σε ποιον ιστότοπο πρόκειται να αποκτήσετε πρόσβαση.
# Variables:
#   $status (string) - The status of the DoH connection
preferences-doh-status = Κατάσταση: { $status }
# Variables:
#   $name (string) - The name of the DNS over HTTPS resolver. If a custom resolver is used, the name will be the domain of the URL.
preferences-doh-resolver = Πάροχος: { $name }
# This is displayed instead of $name in preferences-doh-resolver
# when the DoH URL is not a valid URL
preferences-doh-bad-url = Μη έγκυρο URL
preferences-doh-steering-status = Χρήση τοπικού παρόχου
preferences-doh-status-active = Ενεργό
preferences-doh-status-disabled = Ανενεργό
# Variables:
#   $reason (string) - A string representation of the reason DoH is not active. For example NS_ERROR_UNKNOWN_HOST or TRR_RCODE_FAIL.
preferences-doh-status-not-active = Μη ενεργό ({ $reason })
preferences-doh-group-message = Ενεργοποίηση ασφαλούς DNS με:
preferences-doh-expand-section =
    .tooltiptext = Περισσότερες πληροφορίες
preferences-doh-setting-default =
    .label = Προεπιλεγμένη προστασία
    .accesskey = Π
preferences-doh-default-desc = Το { -brand-short-name } αποφασίζει πότε θα χρησιμοποιεί ασφαλές DNS για την προστασία του απορρήτου σας.
preferences-doh-default-detailed-desc-1 = Χρήση ασφαλούς DNS σε περιοχές όπου είναι διαθέσιμο
preferences-doh-default-detailed-desc-2 = Χρήση προεπιλεγμένης ανάλυσης DNS εάν υπάρχει πρόβλημα με τον πάροχο ασφαλούς DNS
preferences-doh-default-detailed-desc-3 = Χρήση τοπικού παρόχου εάν είναι δυνατόν
preferences-doh-default-detailed-desc-4 = Απενεργοποίηση όταν είναι ενεργό το VPN, ο γονικός έλεγχος ή οι εταιρικές πολιτικές
preferences-doh-default-detailed-desc-5 = Απενεργοποίηση όταν ένα δίκτυο ενημερώνει το { -brand-short-name } ότι δεν πρέπει να χρησιμοποιεί ασφαλές DNS
preferences-doh-setting-enabled =
    .label = Αυξημένη προστασία
    .accesskey = Α
preferences-doh-enabled-desc = Εσείς ελέγχετε πότε θα χρησιμοποιείται ασφαλές DNS και επιλέγετε τον πάροχό σας.
preferences-doh-enabled-detailed-desc-1 = Χρήση του παρόχου της επιλογής σας
preferences-doh-enabled-detailed-desc-2 = Χρήση προεπιλεγμένης ανάλυσης DNS μόνο εάν υπάρχει πρόβλημα με το ασφαλές DNS
preferences-doh-setting-strict =
    .label = Μέγιστη προστασία
    .accesskey = Μ
preferences-doh-strict-desc = Το { -brand-short-name } θα χρησιμοποιεί πάντα ασφαλές DNS. Θα βλέπετε μια προειδοποίηση πριν χρησιμοποιήσουμε το DNS του συστήματός σας.
preferences-doh-strict-detailed-desc-1 = Χρήση μόνο του παρόχου της επιλογής σας
preferences-doh-strict-detailed-desc-2 = Πάντα προειδοποίηση εάν το ασφαλές DNS δεν είναι διαθέσιμο
preferences-doh-strict-detailed-desc-3 = Εάν δεν διατίθεται ασφαλές DNS, οι ιστότοποι δεν θα φορτώνονται ή δεν θα λειτουργούν σωστά
preferences-doh-setting-off =
    .label = Ανενεργή προστασία
    .accesskey = Α
preferences-doh-off-desc = Χρήση προεπιλεγμένης ανάλυσης DNS
preferences-doh-checkbox-warn =
    .label = Προειδοποίηση εάν ένα τρίτο μέρος εμποδίζει ενεργά το ασφαλές DNS
    .accesskey = Π
preferences-doh-select-resolver = Επιλογή παρόχου:
preferences-doh-exceptions-description = Το { -brand-short-name } δεν θα χρησιμοποιεί ασφαλές DNS σε αυτούς τους ιστοτόπους
preferences-doh-manage-exceptions =
    .label = Διαχείριση εξαιρέσεων…
    .accesskey = χ

## The following strings are used in the Download section of settings

desktop-folder-name = Επιφάνεια εργασίας
downloads-folder-name = Στοιχεία λήψεων
choose-download-folder-title = Επιλογή φακέλου λήψεων:
