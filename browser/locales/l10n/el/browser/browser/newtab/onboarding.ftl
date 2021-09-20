# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-learn-more = Μάθετε περισσότερα
onboarding-button-label-get-started = Έναρξη

## Welcome modal dialog strings


### UI strings for the simplified onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## Welcome page strings

onboarding-welcome-header = Καλώς ήλθατε στο { -brand-short-name }
onboarding-welcome-body = Έχετε το πρόγραμμα περιήγησης.<br/>Γνωρίστε τα υπόλοιπα προϊόντα του { -brand-product-name }.
onboarding-welcome-learn-more = Μάθετε περισσότερα σχετικά με τα οφέλη.
onboarding-welcome-modal-get-body = Έχετε το πρόγραμμα περιήγησης.<br/>Αξιοποιήστε στο έπακρο το { -brand-product-name }.
onboarding-welcome-modal-supercharge-body = Εξασφαλίστε την προστασία του απορρήτου σας.
onboarding-welcome-modal-privacy-body = Έχετε το πρόγραμμα περιήγησης. Ας προστατεύσουμε περισσότερο το απόρρητό σας.
onboarding-welcome-modal-family-learn-more = Μάθετε περισσότερα για την οικογένεια προϊόντων { -brand-product-name }.
onboarding-welcome-form-header = Έναρξη εδώ
onboarding-join-form-body = Εισάγετε τη διεύθυνση email σας για να ξεκινήσετε.
onboarding-join-form-email =
    .placeholder = Εισάγετε το email σας
onboarding-join-form-email-error = Απαιτείται έγκυρο email
onboarding-join-form-legal = Συνεχίζοντας, συμφωνείτε με τους <a data-l10n-name="terms">όρους υπηρεσίας</a> και τη <a data-l10n-name="privacy">σημείωση απορρήτου</a>.
onboarding-join-form-continue = Συνέχεια
# This message is followed by a link using onboarding-join-form-signin ("Sign In") as text.
onboarding-join-form-signin-label = Έχετε ήδη λογαριασμό;
# Text for link to submit the sign in form
onboarding-join-form-signin = Σύνδεση
onboarding-start-browsing-button-label = Έναρξη περιήγησης
onboarding-cards-dismiss =
    .title = Απόρριψη
    .aria-label = Απόρριψη

## Welcome full page string

onboarding-fullpage-welcome-subheader = Ας αρχίσουμε να εξερευνούμε ό,τι μπορείτε να κάνετε.
onboarding-fullpage-form-email =
    .placeholder = Η διεύθυνση email σας…

## Firefox Sync modal dialog strings.

onboarding-sync-welcome-header = Πάρτε το { -brand-product-name } μαζί σας
onboarding-sync-welcome-content = Κρατήστε τα αγαπημένα, το ιστορικό, τους κωδικούς πρόσβασης και άλλες ρυθμίσεις σας σε όλες σας τις συσκευές.
onboarding-sync-welcome-learn-more-link = Μάθετε περισσότερα για τους Λογαριασμούς Firefox
onboarding-sync-form-input =
    .placeholder = Email
onboarding-sync-form-continue-button = Συνέχεια
onboarding-sync-form-skip-login-button = Παράλειψη βήματος

## This is part of the line "Enter your email to continue to Firefox Sync"

onboarding-sync-form-header = Εισάγετε το email σας
onboarding-sync-form-sub-header = για να συνεχίσετε στο { -sync-brand-name }.

## These are individual benefit messages shown with an image, title and
## description.

onboarding-benefit-products-text = Κάντε περισσότερα με μια οικογένεια εργαλείων που σέβονται το απόρρητό σας στις συσκευές σας.
# "Personal Data Promise" is a concept that should be translated consistently
# across the product. It refers to a concept shown elsewhere to the user: "The
# Firefox Personal Data Promise is the way we honor your data in everything we
# make and do. We take less data. We keep it safe. And we make sure that we are
# transparent about how we use it."
onboarding-benefit-privacy-text = Όλα όσα κάνουμε τιμούν την υπόσχεση μας σχετικά με τα προσωπικά δεδομένα: Λιγότερα δεδομένα. Με ασφάλεια. Χωρίς μυστικά.
onboarding-benefit-sync-title = { -sync-brand-short-name }
onboarding-benefit-sync-text = Πάρτε τους σελιδοδείκτες, τους κωδικούς πρόσβασης, το ιστορικό σας και πολλά άλλα σε κάθε συσκευή με { -brand-product-name }.
onboarding-benefit-monitor-title = { -monitor-brand-short-name }
onboarding-benefit-monitor-text = Λάβετε ειδοποίηση όταν διαρρεύσουν τα προσωπικά στοιχεία σας.
onboarding-benefit-lockwise-title = { -lockwise-brand-short-name }
onboarding-benefit-lockwise-text = Διαχειριστείτε κωδικούς πρόσβασης που είναι ασφαλείς και φορητοί.

## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

onboarding-tracking-protection-title2 = Προστασία από καταγραφή
onboarding-tracking-protection-text2 = Το { -brand-short-name } βοηθά να σταματήσουν οι ιστοσελίδες να σας καταγράφουν στο διαδίκτυο, καθιστώντας πιο δύσκολη την παρακολούθησή σας από διαφημίσεις στον ιστό.
onboarding-tracking-protection-button2 = Πώς λειτουργεί
onboarding-data-sync-title = Πάρτε μαζί σας τις ρυθμίσεις σας
# "Sync" is short for synchronize.
onboarding-data-sync-text2 = Συγχρονίστε τους σελιδοδείκτες, τους κωδικούς πρόσβασης και πολλά άλλα όπου χρησιμοποιείτε το { -brand-product-name }.
onboarding-data-sync-button2 = Σύνδεση στο { -sync-brand-short-name }
onboarding-firefox-monitor-title = Ενημερωθείτε για παραβιάσεις δεδομένων
onboarding-firefox-monitor-text2 = Το { -monitor-brand-name } ελέγχει αν το email σας έχει εμφανιστεί σε κάποια παραβίαση δεδομένων και σας ειδοποιεί αν εμφανιστεί σε νέα παράβαση.
onboarding-firefox-monitor-button = Εγγραφή για ειδοποιήσεις
onboarding-browse-privately-title = Ιδιωτική περιήγηση
onboarding-browse-privately-text = Η ιδιωτική περιήγηση διαγράφει το ιστορικό αναζήτησης και περιήγησής σας για να διατηρούνται κρυφά από άλλους χρήστες του υπολογιστή σας.
onboarding-browse-privately-button = Άνοιγμα ιδιωτικού παραθύρου
onboarding-firefox-send-title = Διατηρήστε τα κοινόχρηστα αρχεία σας ιδιωτικά
onboarding-firefox-send-text2 = Μεταφορτώστε τα αρχεία σας στο { -send-brand-name } για να τα μοιραστείτε με κρυπτογράφηση από άκρο σε άκρο και έναν σύνδεσμο που λήγει αυτόματα.
onboarding-firefox-send-button = Δοκιμή του { -send-brand-name }
onboarding-mobile-phone-title = Λήψη του { -brand-product-name } στο τηλέφωνό σας
onboarding-mobile-phone-text = Κάντε λήψη του { -brand-product-name } για iOS ή Android και συγχρονίστε τα δεδομένα σας με όλες τις συσκευές σας.
# "Mobile" is short for mobile/cellular phone, "Browser" is short for web
# browser.
onboarding-mobile-phone-button = Λήψη προγράμματος περιήγησης για κινητά
onboarding-send-tabs-title = Άμεση αποστολή καρτελών στις συσκευές σας
# "Send Tabs" refers to "Send Tab to Device" feature that appears when opening a
# tab's context menu.
onboarding-send-tabs-text2 = Μοιραστείτε εύκολα σελίδες με τις συσκευές σας χωρίς αντιγραφή συνδέσμων και χωρίς να φύγετε από το πρόγραμμα περιήγησης.
onboarding-send-tabs-button = Έναρξη χρήσης της αποστολής καρτελών
onboarding-pocket-anywhere-title = Διαβάστε και ακούστε οπουδήποτε
onboarding-pocket-anywhere-text2 = Αποθηκεύστε το αγαπημένο σας περιεχόμενο εκτός σύνδεσης με την εφαρμογή { -pocket-brand-name } και διαβάστε, ακούστε και παρακολουθήστε όποτε σας βολεύει.
onboarding-pocket-anywhere-button = Δοκιμή του { -pocket-brand-name }
onboarding-lockwise-strong-passwords-title = Δημιουργία και αποθήκευση ισχυρών κωδικών πρόσβασης
onboarding-lockwise-strong-passwords-text = Το { -lockwise-brand-name } δημιουργεί ισχυρούς κωδικούς πρόσβασης επί τόπου και τους αποθηκεύει όλους σε ένα μέρος.
onboarding-lockwise-strong-passwords-button = Διαχείριση συνδέσεων
onboarding-facebook-container-title = Θέστε όρια με το Facebook
onboarding-facebook-container-text2 = Το { -facebook-container-brand-name } διατηρεί ξεχωριστά το προφίλ σας από όλα τα άλλα, εμποδίζοντας τις στοχευμένες διαφημίσεις του Facebook.
onboarding-facebook-container-button = Προσθήκη επέκτασης
onboarding-import-browser-settings-title = Εισάγετε τους σελιδοδείκτες, τους κωδικούς πρόσβασης σας και άλλα
onboarding-import-browser-settings-text = Ξεκινήστε αμέσως—εισάγετε εύκολα τις ιστοσελίδες και τις ρυθμίσεις του Chrome.
onboarding-import-browser-settings-button = Εισαγωγή δεδομένων Chrome
onboarding-personal-data-promise-title = Ιδιωτικό εκ κατασκευής
onboarding-personal-data-promise-text = Το { -brand-product-name } αντιμετωπίζει τα δεδομένα σας με σεβασμό, συλλέγοντας όσο το δυνατό λιγότερα, προστατεύοντάς τα και είναι ξεκάθαρο πώς τα χρησιμοποιούμε.
onboarding-personal-data-promise-button = Διαβάστε την υπόσχεσή μας

## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = Τέλεια, αποκτήσατε το { -brand-short-name }
# <icon></icon> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-header = Τώρα, ας αποκτήσουμε το <icon></icon><b>{ $addon-name }.</b>
return-to-amo-extension-button = Προσθήκη επέκτασης
return-to-amo-get-started-button = Έναρξη με το { -brand-short-name }
onboarding-not-now-button-label = Όχι τώρα

## Custom Return To AMO onboarding strings

return-to-amo-subtitle = Τέλεια, αποκτήσατε το { -brand-short-name }
# <img data-l10n-name="icon"/> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-title = Τώρα, προτείνουμε το <img data-l10n-name="icon"/> <b>{ $addon-name }</b>.
return-to-amo-add-extension-label = Προσθήκη επέκτασης

## Multistage 3-screen onboarding flow strings (about:welcome pages)

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-welcome-header = Καλώς ορίσατε στο <span data-l10n-name="zap">{ -brand-short-name }</span>
onboarding-multistage-welcome-subtitle = Το γρήγορο, ασφαλές και ιδιωτικό πρόγραμμα περιήγησης, που υποστηρίζεται από έναν μη κερδοσκοπικό οργανισμό.
onboarding-multistage-welcome-primary-button-label = Έναρξη ρύθμισης
onboarding-multistage-welcome-secondary-button-label = Σύνδεση
onboarding-multistage-welcome-secondary-button-text = Έχετε λογαριασμό;
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "default" should stay inside the span.
onboarding-multistage-set-default-header = Ορίστε το { -brand-short-name } ως <span data-l10n-name="zap">προεπιλογή</span>
onboarding-multistage-set-default-subtitle = Ταχύτητα, ασφάλεια και απόρρητο κάθε φορά που περιηγείστε.
onboarding-multistage-set-default-primary-button-label = Ορισμός ως προεπιλογή
onboarding-multistage-set-default-secondary-button-label = Όχι τώρα
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-pin-default-header = Ξεκινήστε κάνοντας το <span data-l10n-name="zap">{ -brand-short-name }</span> προσβάσιμο με ένα κλικ
onboarding-multistage-pin-default-subtitle = Γρήγορη, ασφαλής και ιδιωτική περιήγηση κάθε φορά που χρησιμοποιείτε το διαδίκτυο.
# The "settings" here refers to "Windows 10 Settings App" and not the browser's
onboarding-multistage-pin-default-waiting-subtitle = Επιλέξτε το { -brand-short-name } για "Πρόγραμμα περιήγησης Web" όταν ανοίξουν οι ρυθμίσεις
# The "settings" here refers to "Windows 10 Settings App" and not the browser's
onboarding-multistage-pin-default-help-text = Το { -brand-short-name } θα καρφιτσωθεί στη γραμμή εργασιών και θα ανοίξουν οι ρυθμίσεις
onboarding-multistage-pin-default-primary-button-label = Ορισμός { -brand-short-name } ως κύριου προγράμματος περιήγησης
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "more" should stay inside the span.
onboarding-multistage-import-header = Εισάγετε κωδικούς πρόσβασης, <br/>σελιδοδείκτες και <span data-l10n-name="zap">πολλά άλλα</span>
onboarding-multistage-import-subtitle = Έρχεστε από άλλο πρόγραμμα περιήγησης; Είναι εύκολο να μεταφέρετε τα πάντα στο { -brand-short-name }.
onboarding-multistage-import-primary-button-label = Έναρξη εισαγωγής
onboarding-multistage-import-secondary-button-label = Όχι τώρα
# Info displayed in the footer of import settings screen during onboarding flow.
# This supports welcome screen showing top sites imported from the user's default browser.
onboarding-import-sites-disclaimer = Οι παρακάτω σελίδες βρέθηκαν στη συσκευή. Το { -brand-short-name } δεν αποθηκεύει ούτε συγχρονίζει δεδομένα από άλλο πρόγραμμα περιήγησης, εκτός αν επιλέξετε εσείς να γίνει εισαγωγή.
# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = Έναρξη: οθόνη { $current } από { $total }
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "look" should stay inside the span.
onboarding-multistage-theme-header = Επιλέξτε <span data-l10n-name="zap">εμφάνιση</span>
onboarding-multistage-theme-subtitle = Εξατομίκευση του { -brand-short-name } με ένα θέμα.
onboarding-multistage-theme-primary-button-label2 = Τέλος
onboarding-multistage-theme-secondary-button-label = Όχι τώρα
# Automatic theme uses operating system color settings
onboarding-multistage-theme-label-automatic = Αυτόματο
onboarding-multistage-theme-label-light = Φωτεινό
onboarding-multistage-theme-label-dark = Σκούρο
# "Firefox Alpenglow" here is the name of the theme, and should be kept in English.
onboarding-multistage-theme-label-alpenglow = Waterfox Alpenglow

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

# Tooltip displayed on hover of automatic theme
onboarding-multistage-theme-tooltip-automatic-2 =
    .title =
        Αντιγραφή της εμφάνισης του λειτουργικού σας
        συστήματος για τα κουμπιά, τα μενού και τα παράθυρα.
# Input description for automatic theme
onboarding-multistage-theme-description-automatic-2 =
    .aria-description =
        Αντιγραφή της εμφάνισης του λειτουργικού σας
        συστήματος για τα κουμπιά, τα μενού και τα παράθυρα.
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light-2 =
    .title =
        Χρήση ανοιχτόχρωμης εμφάνισης για τα κουμπιά,
        τα μενού και τα παράθυρα.
# Input description for light theme
onboarding-multistage-theme-description-light =
    .aria-description =
        Χρήση ανοιχτόχρωμης εμφάνισης για τα κουμπιά,
        τα μενού και τα παράθυρα.
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark-2 =
    .title =
        Χρήση σκουρόχρωμης εμφάνισης για τα κουμπιά,
        τα μενού και τα παράθυρα.
# Input description for dark theme
onboarding-multistage-theme-description-dark =
    .aria-description =
        Χρήση σκουρόχρωμης εμφάνισης για τα κουμπιά,
        τα μενού και τα παράθυρα.
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow-2 =
    .title =
        Χρήση πολύχρωμης εμφάνισης για τα κουμπιά,
        τα μενού και τα παράθυρα.
# Input description for Alpenglow theme
onboarding-multistage-theme-description-alpenglow =
    .aria-description =
        Χρήση πολύχρωμης εμφάνισης για τα κουμπιά,
        τα μενού και τα παράθυρα.

## Multistage MR1 onboarding strings (MR1 about:welcome pages)

# "Hero Text" displayed on left side of welcome screen.
# The "Fire" in "Fire starts here" plays on the "Fire" in "Waterfox".
# It also signals the passion users bring to Firefox, how they use
# Firefox to pursue those passions, as well as the boldness in their
# choice to use Firefox over a larger competitor browser.
# An alternative title for localization is: "It starts here".
# This text can be formatted to span multiple lines as needed.
mr1-welcome-screen-hero-text = Η φωτιά ξεκινά εδώ
# Caption for background image in about:welcome. "Soraya Osorio" is the name
# of the person and shouldn't be translated.
# In case your language needs to adapt the nouns to a gender, Soraya is a female name (she/her).
# You can see the picture in about:welcome in Nightly 90.
mr1-onboarding-welcome-image-caption = Soraya Osorio — Σχεδιάστρια επίπλων, υποστηρίκτρια του Firefox
# This button will open system settings to turn on prefers-reduced-motion
mr1-onboarding-reduce-motion-button-label = Απενεργοποίηση εφέ κίνησης

## Title and primary button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# Title used on welcome page when Firefox is not pinned
mr1-onboarding-pin-header =
    { PLATFORM() ->
        [macos] Διατηρήστε το { -brand-short-name } στο Dock σας για εύκολη πρόσβαση
       *[other] Καρφιτσώστε το { -brand-short-name } στη γραμμή εργασιών σας για εύκολη πρόσβαση
    }
# Primary button string used on welcome page when Firefox is not pinned.
mr1-onboarding-pin-primary-button-label =
    { PLATFORM() ->
        [macos] Διατήρηση στο Dock
       *[other] Καρφίτσωμα στη γραμμή εργασιών
    }

## Multistage MR1 onboarding strings (about:welcome pages)

# This string will be used on welcome page primary button label
# when Firefox is both pinned and default
mr1-onboarding-get-started-primary-button-label = Έναρξη
mr1-onboarding-welcome-header = Καλώς ορίσατε στο { -brand-short-name }
mr1-onboarding-set-default-pin-primary-button-label = Ορισμός { -brand-short-name } ως κύριου φυλλομετρητή
    .title = Ορίζει το { -brand-short-name } ως το προεπιλεγμένο πρόγραμμα περιήγησης και το καρφιτσώνει στη γραμμή εργασιών
# This string will be used on welcome page primary button label
# when Firefox is not default but already pinned
mr1-onboarding-set-default-only-primary-button-label = Ορισμός { -brand-short-name } ως προεπιλεγμένου φυλλομετρητή
mr1-onboarding-set-default-secondary-button-label = Όχι τώρα
mr1-onboarding-sign-in-button-label = Σύνδεση

## Title, subtitle and primary button string used on set default onboarding screen
## when Firefox is not default browser

mr1-onboarding-default-header = Ορισμός { -brand-short-name } ως προεπιλογής
mr1-onboarding-default-subtitle = Βάλτε την ταχύτητα, την ασφάλεια και το απόρρητο στον αυτόματο πιλότο.
mr1-onboarding-default-primary-button-label = Ορισμός προεπιλεγμένου φυλλομετρητή

## Multistage MR1 onboarding strings (about:welcome pages)

mr1-onboarding-import-header = Μεταφέρετε όλα τα δεδομένα σας
mr1-onboarding-import-subtitle = Εισάγετε κωδικούς πρόσβασης <br/>σελιδοδείκτες και πολλά άλλα.
# The primary import button label will depend on whether we can detect which browser was used to download Firefox.
# Variables:
#   $previous (Str) - Previous browser name, such as Edge, Chrome
mr1-onboarding-import-primary-button-label-attribution = Εισαγωγή από { $previous }
# This string will be used in cases where we can't detect the previous browser name.
mr1-onboarding-import-primary-button-label-no-attribution = Εισαγωγή από προηγούμενο πρόγραμμα περιήγησης
mr1-onboarding-import-secondary-button-label = Όχι τώρα
mr1-onboarding-theme-header = Κάντε το δικό σας
mr1-onboarding-theme-subtitle = Εξατομικεύστε το { -brand-short-name } με ένα θέμα.
mr1-onboarding-theme-primary-button-label = Αποθήκευση θέματος
mr1-onboarding-theme-secondary-button-label = Όχι τώρα
# System theme uses operating system color settings
mr1-onboarding-theme-label-system = Θέμα συστήματος
mr1-onboarding-theme-label-light = Φωτεινό
mr1-onboarding-theme-label-dark = Σκοτεινό
# "Alpenglow" here is the name of the theme, and should be kept in English.
mr1-onboarding-theme-label-alpenglow = Alpenglow

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

# Tooltip displayed on hover of system theme
mr1-onboarding-theme-tooltip-system =
    .title =
        Χρήση θέματος λειτουργικού συστήματος
        για κουμπιά, μενού και παράθυρα.
# Input description for system theme
mr1-onboarding-theme-description-system =
    .aria-description =
        Χρήση θέματος λειτουργικού συστήματος
        για κουμπιά, μενού και παράθυρα.
# Tooltip displayed on hover of light theme
mr1-onboarding-theme-tooltip-light =
    .title =
        Χρήση φωτεινού θέματος για τα κουμπιά,
        τα μενού και τα παράθυρα.
# Input description for light theme
mr1-onboarding-theme-description-light =
    .aria-description =
        Χρήση φωτεινού θέματος για τα κουμπιά,
        τα μενού και τα παράθυρα.
# Tooltip displayed on hover of dark theme
mr1-onboarding-theme-tooltip-dark =
    .title =
        Χρήση σκοτεινού θέματος για τα κουμπιά,
        τα μενού και τα παράθυρα.
# Input description for dark theme
mr1-onboarding-theme-description-dark =
    .aria-description =
        Χρήση σκοτεινού θέματος για τα κουμπιά,
        τα μενού και τα παράθυρα.
# Tooltip displayed on hover of Alpenglow theme
mr1-onboarding-theme-tooltip-alpenglow =
    .title =
        Χρήση ενός δυναμικού, πολύχρωμου θέματος για τα κουμπιά,
        τα μενού και τα παράθυρα.
# Input description for Alpenglow theme
mr1-onboarding-theme-description-alpenglow =
    .aria-description =
        Χρήση ενός δυναμικού, πολύχρωμου θέματος για τα κουμπιά,
        τα μενού και τα παράθυρα.
