# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the MR1 onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## Welcome page strings

onboarding-welcome-header = Καλώς ήλθατε στο { -brand-short-name }
onboarding-start-browsing-button-label = Έναρξη περιήγησης
onboarding-not-now-button-label = Όχι τώρα

## Custom Return To AMO onboarding strings

return-to-amo-subtitle = Τέλεια, αποκτήσατε το { -brand-short-name }
# <img data-l10n-name="icon"/> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-title = Τώρα, προτείνουμε το <img data-l10n-name="icon"/> <b>{ $addon-name }</b>.
return-to-amo-add-extension-label = Προσθήκη επέκτασης
return-to-amo-add-theme-label = Προσθήκη θέματος

## Multistage onboarding strings (about:welcome pages)

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = Έναρξη: οθόνη { $current } από { $total }

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages

onboarding-welcome-steps-indicator2 =
    .aria-valuetext = Πρόοδος: βήμα { $current } από { $total }
# "Hero Text" displayed on left side of welcome screen.
# The "Fire" in "Fire starts here" plays on the "Fire" in "Waterfox".
# It also signals the passion users bring to Waterfox, how they use
# Waterfox to pursue those passions, as well as the boldness in their
# choice to use Waterfox over a larger competitor browser.
# An alternative title for localization is: "It starts here".
# This text can be formatted to span multiple lines as needed.
mr1-welcome-screen-hero-text =
    Η φωτιά ξεκινά
    εδώ
# Caption for background image in about:welcome. "Soraya Osorio" is the name
# of the person and shouldn't be translated.
# In case your language needs to adapt the nouns to a gender, Soraya is a female name (she/her).
# You can see the picture in about:welcome in Nightly 90.
mr1-onboarding-welcome-image-caption = Soraya Osorio — Σχεδιάστρια επίπλων, υποστηρίκτρια του Waterfox
# This button will open system settings to turn on prefers-reduced-motion
mr1-onboarding-reduce-motion-button-label = Απενεργοποίηση εφέ κίνησης

## Title and primary button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# Title used on welcome page when Waterfox is not pinned
mr1-onboarding-pin-header =
    { PLATFORM() ->
        [macos] Διατηρήστε το { -brand-short-name } στο Dock σας για εύκολη πρόσβαση
       *[other] Καρφιτσώστε το { -brand-short-name } στη γραμμή εργασιών σας για εύκολη πρόσβαση
    }
# Primary button string used on welcome page when Waterfox is not pinned.
mr1-onboarding-pin-primary-button-label =
    { PLATFORM() ->
        [macos] Διατήρηση στο Dock
       *[other] Καρφίτσωμα στη γραμμή εργασιών
    }

## Multistage MR1 onboarding strings (about:welcome pages)

# This string will be used on welcome page primary button label
# when Waterfox is both pinned and default
mr1-onboarding-get-started-primary-button-label = Έναρξη
mr1-onboarding-welcome-header = Καλώς ορίσατε στο { -brand-short-name }
mr1-onboarding-set-default-pin-primary-button-label = Ορισμός { -brand-short-name } ως κύριου φυλλομετρητή
    .title = Ορίζει το { -brand-short-name } ως το προεπιλεγμένο πρόγραμμα περιήγησης και το καρφιτσώνει στη γραμμή εργασιών
# This string will be used on welcome page primary button label
# when Waterfox is not default but already pinned
mr1-onboarding-set-default-only-primary-button-label = Ορισμός { -brand-short-name } ως προεπιλεγμένου φυλλομετρητή
mr1-onboarding-set-default-secondary-button-label = Όχι τώρα
mr1-onboarding-sign-in-button-label = Σύνδεση

## Title, subtitle and primary button string used on set default onboarding screen
## when Waterfox is not default browser

mr1-onboarding-default-header = Ορισμός { -brand-short-name } ως προεπιλογής
mr1-onboarding-default-subtitle = Βάλτε την ταχύτητα, την ασφάλεια και το απόρρητο στον αυτόματο πιλότο.
mr1-onboarding-default-primary-button-label = Ορισμός προεπιλεγμένου φυλλομετρητή

## Multistage MR1 onboarding strings (about:welcome pages)

mr1-onboarding-import-header = Μεταφέρετε όλα τα δεδομένα σας
mr1-onboarding-import-subtitle = Εισάγετε κωδικούς πρόσβασης <br/>σελιδοδείκτες και πολλά άλλα.
# The primary import button label will depend on whether we can detect which browser was used to download Waterfox.
# Variables:
#   $previous (Str) - Previous browser name, such as Edge, Chrome
mr1-onboarding-import-primary-button-label-attribution = Εισαγωγή από { $previous }
# This string will be used in cases where we can't detect the previous browser name.
mr1-onboarding-import-primary-button-label-no-attribution = Εισαγωγή από προηγούμενο πρόγραμμα περιήγησης
mr1-onboarding-import-secondary-button-label = Όχι τώρα
mr2-onboarding-colorway-header = Ζωή με χρώμα
mr2-onboarding-colorway-subtitle = Νέοι, δυναμικοί χρωματικοί συνδυασμοί. Διαθέσιμοι για περιορισμένο χρονικό διάστημα.
mr2-onboarding-colorway-primary-button-label = Αποθήκευση χρωματικού συνδυασμού
mr2-onboarding-colorway-secondary-button-label = Όχι τώρα
mr2-onboarding-colorway-label-soft = Απαλό
mr2-onboarding-colorway-label-balanced = Ισορροπημένο
# "Bold" is used in the sense of bravery or courage, not in the sense of
# emphasized text.
mr2-onboarding-colorway-label-bold = Έντονο
# Automatic theme uses operating system color settings
mr2-onboarding-theme-label-auto = Αυτόματο
# This string will be used for Default theme
mr2-onboarding-theme-label-default = Προεπιλογή
mr1-onboarding-theme-header = Κάντε το δικό σας
mr1-onboarding-theme-subtitle = Εξατομικεύστε το { -brand-short-name } με ένα θέμα.
mr1-onboarding-theme-primary-button-label = Αποθήκευση θέματος
mr1-onboarding-theme-secondary-button-label = Όχι τώρα
# System theme uses operating system color settings
mr1-onboarding-theme-label-system = Θέμα συστήματος
mr1-onboarding-theme-label-light = Ανοιχτόχρωμο
mr1-onboarding-theme-label-dark = Σκοτεινό
# "Alpenglow" here is the name of the theme, and should be kept in English.
mr1-onboarding-theme-label-alpenglow = Alpenglow
onboarding-theme-primary-button-label = Τέλος

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
# Tooltip displayed on hover of non-default colorway theme
# variations e.g. soft, balanced, bold
mr2-onboarding-theme-tooltip =
    .title = Χρήση αυτού του χρωματικού συνδυασμού.
# Selector description for non-default colorway theme
# variations e.g. soft, balanced, bold
mr2-onboarding-theme-description =
    .aria-description = Χρήση αυτού του χρωματικού συνδυασμού.
# Tooltip displayed on hover of colorway
# Variables:
#   $colorwayName (String) - Name of colorway
mr2-onboarding-colorway-tooltip =
    .title = Εξερευνήστε τους χρωματικούς συνδυασμούς «{ $colorwayName }».
# Selector description for colorway
# Variables:
#   $colorwayName (String) - Name of colorway
mr2-onboarding-colorway-label = Εξερευνήστε τους χρωματικούς συνδυασμούς «{ $colorwayName }».
# Tooltip displayed on hover of default themes
mr2-onboarding-default-theme-tooltip =
    .title = Εξερευνήστε τα προεπιλεγμένα θέματα.
# Selector description for default themes
mr2-onboarding-default-theme-label = Εξερευνήστε τα προεπιλεγμένα θέματα.

## Strings for Thank You page

mr2-onboarding-thank-you-header = Ευχαριστούμε που μας επιλέξατε
mr2-onboarding-thank-you-text = Το { -brand-short-name } είναι ένα ανεξάρτητο πρόγραμμα περιήγησης που υποστηρίζεται από έναν μη κερδοσκοπικό οργανισμό. Μαζί, κάνουμε το διαδίκτυο πιο ασφαλές, υγιές και ιδιωτικό.
mr2-onboarding-start-browsing-button-label = Έναρξη περιήγησης

## Multistage live language reloading onboarding strings (about:welcome pages)
##
## The following language names are generated by the browser's Intl.DisplayNames API.
##
## Variables:
##   $negotiatedLanguage (String) - The name of the langpack's language, e.g. "Español (ES)"


## Multistage live language reloading onboarding strings (about:welcome pages)
##
## The following language names are generated by the browser's Intl.DisplayNames API.
##
## Variables:
##   $negotiatedLanguage (String) - The name of the langpack's language, e.g. "Español (ES)"
##   $systemLanguage (String) - The name of the system language, e.g "Español (ES)"
##   $appLanguage (String) - The name of the language shipping in the browser build, e.g. "English (EN)"

onboarding-live-language-header = Επιλέξτε τη γλώσσα σας
mr2022-onboarding-live-language-text = Το { -brand-short-name } μιλάει τη γλώσσα σας
mr2022-language-mismatch-subtitle = Χάρη στην κοινότητά μας, το { -brand-short-name } έχει μεταφραστεί σε πάνω από 90 γλώσσες. Φαίνεται ότι το σύστημά σας χρησιμοποιεί { $systemLanguage } και το { -brand-short-name } χρησιμοποιεί { $appLanguage }.
onboarding-live-language-button-label-downloading = Λήψη πακέτου γλώσσας για τα { $negotiatedLanguage }…
onboarding-live-language-waiting-button = Λήψη διαθέσιμων γλωσσών…
onboarding-live-language-installing = Εγκατάσταση πακέτου γλώσσας για τα { $negotiatedLanguage }…
mr2022-onboarding-live-language-switch-to = Εναλλαγή σε { $negotiatedLanguage }
mr2022-onboarding-live-language-continue-in = Συνέχεια με { $appLanguage }
onboarding-live-language-secondary-cancel-download = Ακύρωση
onboarding-live-language-skip-button-label = Παράλειψη

## Waterfox 100 Thank You screens

# "Hero Text" displayed on left side of welcome screen. This text can be
# formatted to span multiple lines as needed. The <span data-l10n-name="zap">
# </span> in this string allows a "zap" underline style to be automatically
# added to the text inside it. "Yous" should stay inside the zap span, but
# "Thank" can be put inside instead if there's no "you" in the translation.
# The English text would normally be "100 Thank-Yous" i.e., plural noun, but for
# aesthetics of splitting it across multiple lines, the hyphen is omitted.
fx100-thank-you-hero-text =
    100
    <span data-l10n-name="zap">Ευχαριστώ</span>
fx100-thank-you-subtitle = Είναι η 100η μας έκδοση! Σας ευχαριστούμε για τη βοήθειά σας για ένα καλύτερο, υγιέστερο διαδίκτυο.
fx100-thank-you-pin-primary-button-label =
    { PLATFORM() ->
        [macos] Καρφίτσωμα { -brand-short-name } στο Dock
       *[other] Καρφίτσωμα { -brand-short-name } στη γραμμή εργασιών
    }
fx100-upgrade-thanks-header = 100 Ευχαριστώ
# Message shown with a start-browsing button. Emphasis <em> should be for "you"
# but "Thank" can be used instead if there's no "you" in the translation.
fx100-upgrade-thank-you-body = Είναι η 100η μας έκδοση του { -brand-short-name }. <em>Σας</em> ευχαριστούμε για τη βοήθειά σας για ένα καλύτερο, υγιέστερο διαδίκτυο.
# Message shown with either a pin-to-taskbar or set-default button.
fx100-upgrade-thanks-keep-body = Είναι η 100η μας έκδοση! Σας ευχαριστούμε που είστε μέλος της κοινότητάς μας. Κρατήστε το { -brand-short-name } ένα κλικ μακριά για τις επόμενες 100.
mr2022-onboarding-secondary-skip-button-label = Παράβλεψη βήματος

## MR2022 New User Pin Waterfox screen strings

# Title used on about:welcome for new users when Waterfox is not pinned.
# In this context, open up is synonymous with "Discover".
# The metaphor is that when they open their Waterfox browser, it helps them discover an amazing internet.
# If this translation does not make sense in your language, feel free to use the word "discover."
mr2022-onboarding-welcome-pin-header = Ανοίξτε ένα καταπληκτικό διαδίκτυο
# Primary button string used on welcome page for when Waterfox is not pinned.
mr2022-onboarding-pin-primary-button-label =
    { PLATFORM() ->
        [macos] Διατήρηση του { -brand-short-name } στο Dock
       *[other] Καρφίτσωμα του { -brand-short-name } στη γραμμή εργασιών
    }

## MR2022 Existing User Pin Waterfox Screen Strings

mr2022-onboarding-existing-pin-checkbox-label = Προσθήκη συντόμευσης και για την ιδιωτική περιήγηση του { -brand-short-name }

## MR2022 New User Set Default screen strings

mr2022-onboarding-set-default-primary-button-label = Ορισμός του { -brand-short-name } ως προεπιλογής

## MR2022 Get Started screen strings.
## These strings will be used on the welcome page
## when Waterfox is already set to default and pinned.

mr2022-onboarding-get-started-primary-button-label = Ρύθμιση σε δευτερόλεπτα

## MR2022 Import Settings screen strings

mr2022-onboarding-import-header = Αστραπιαία ρύθμιση
mr2022-onboarding-import-primary-button-label-no-attribution = Εισαγωγή από προηγούμενο πρόγραμμα περιήγησης

## If your language uses grammatical genders, in the description for the
## colorway feel free to switch from "You are a X. You…" (e.g. "You are a
## Playmaker. You create…") to "X: you…" ("Playmaker: You create…"). This might
## help creating a more inclusive translation.

mr2022-onboarding-colorway-title = Επιλέξτε το χρώμα που σας εμπνέει
mr2022-onboarding-colorway-subtitle = Οι ανεξάρτητες φωνές μπορούν να αλλάξουν τον πολιτισμό.
mr2022-onboarding-colorway-primary-button-label = Ορισμός χρωματικού συνδυασμού
mr2022-onboarding-existing-colorway-checkbox-label = Κάντε την { -firefox-home-brand-name } σας μια πολύχρωμη αρχική σελίδα
mr2022-onboarding-colorway-label-default = Προεπιλογή
mr2022-onboarding-colorway-tooltip-default =
    .title = Προεπιλογή
mr2022-onboarding-colorway-description-default = <b>Χρήση τρεχόντων χρωμάτων στο { -brand-short-name }.</b>
mr2022-onboarding-colorway-label-playmaker = Δημιουργός
mr2022-onboarding-colorway-tooltip-playmaker =
    .title = Δημιουργός
mr2022-onboarding-colorway-description-playmaker = <b>Δημιουργός:</b> Δημιουργείτε ευκαιρίες για να κερδίσετε και βοηθάτε όλα τα άτομα γύρω σας να καταβάλουν τα μέγιστα.
mr2022-onboarding-colorway-label-expressionist = Εξπρεσιονιστής
mr2022-onboarding-colorway-tooltip-expressionist =
    .title = Εξπρεσιονιστής
mr2022-onboarding-colorway-description-expressionist = <b>Εξπρεσιονιστής:</b> Βλέπετε τον κόσμο διαφορετικά και οι δημιουργίες σας διεγείρουν τα συναισθήματα των άλλων.
mr2022-onboarding-colorway-label-visionary = Οραματιστής
mr2022-onboarding-colorway-tooltip-visionary =
    .title = Οραματιστής
mr2022-onboarding-colorway-description-visionary = <b>Οραματιστής:</b> Αμφισβητείτε το status quo και κάνετε τους άλλους να φαντάζονται ένα καλύτερο μέλλον.
mr2022-onboarding-colorway-label-activist = Ακτιβιστής
mr2022-onboarding-colorway-tooltip-activist =
    .title = Ακτιβιστής
mr2022-onboarding-colorway-description-activist = <b>Ακτιβιστής:</b> Παραδίδετε έναν καλύτερο κόσμο στους επόμενους και κάνετε τους άλλους να πιστεύουν.
mr2022-onboarding-colorway-label-dreamer = Ονειροπόλος
mr2022-onboarding-colorway-tooltip-dreamer =
    .title = Ονειροπόλος
mr2022-onboarding-colorway-description-dreamer = <b>Ονειροπόλος:</b> Πιστεύετε ότι η τύχη ευνοεί τους τολμηρούς και εμπνέετε τους άλλους να είναι γενναίοι.

## MR2022 Multistage Mobile Download screen strings

mr2022-onboarding-mobile-download-cta-text = Σαρώστε τον κωδικό QR για να αποκτήσετε το { -brand-product-name } για κινητές συσκευές ή <a data-l10n-name="download-label">στείλτε στον εαυτό σας έναν σύνδεσμο λήψης.</a>
mr2022-onboarding-no-mobile-download-cta-text = Σαρώστε τον κωδικό QR για λήψη του { -brand-product-name } για κινητές συσκευές.

## MR2022 Upgrade Dialog screens
## Pin private window screen shown only for users who don't have Waterfox private pinned

mr2022-upgrade-onboarding-pin-private-window-header = Η ελευθερία της ιδιωτικής περιήγησης, με ένα κλικ
mr2022-upgrade-onboarding-pin-private-window-subtitle = Χωρίς αποθήκευση cookies ή ιστορικού, απευθείας από την επιφάνεια εργασίας σας. Περιηγηθείτε σαν να μην σας παρακολουθεί κανείς.
mr2022-upgrade-onboarding-pin-private-window-primary-button-label =
    { PLATFORM() ->
        [macos] Διατήρηση της ιδιωτικής περιήγησης του { -brand-short-name } στο Dock
       *[other] Καρφίτσωμα της ιδιωτικής περιήγησης του { -brand-short-name } στη γραμμή εργασιών
    }

## MR2022 Privacy Segmentation screen strings

mr2022-onboarding-privacy-segmentation-title = Σεβόμαστε πάντοτε το απόρρητό σας
mr2022-onboarding-privacy-segmentation-subtitle = Από έξυπνες προτάσεις έως πιο έξυπνη αναζήτηση, εργαζόμαστε συνεχώς για να δημιουργήσουμε ένα καλύτερο, πιο εξατομικευμένο { -brand-product-name }.
mr2022-onboarding-privacy-segmentation-text-cta = Τι θέλετε να βλέπετε όταν προσφέρουμε νέες δυνατότητες που χρησιμοποιούν τα δεδομένα σας για τη βελτίωση της περιήγησής σας;
mr2022-onboarding-privacy-segmentation-button-primary-label = Χρήση προτάσεων του { -brand-product-name }
mr2022-onboarding-privacy-segmentation-button-secondary-label = Εμφάνιση λεπτομερών πληροφοριών

## MR2022 Multistage Gratitude screen strings

mr2022-onboarding-gratitude-title = Μας βοηθάτε να δημιουργήσουμε ένα καλύτερο διαδίκτυο.
mr2022-onboarding-gratitude-primary-button-label = Δείτε τι νέο υπάρχει
mr2022-onboarding-gratitude-secondary-button-label = Έναρξη περιήγησης
