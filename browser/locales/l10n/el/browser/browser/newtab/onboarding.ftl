# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


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

## Multistage onboarding strings (about:welcome pages)

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
onboarding-multistage-theme-label-light = Ανοιχτόχρωμο
onboarding-multistage-theme-label-dark = Σκουρόχρωμο
# "Waterfox Alpenglow" here is the name of the theme, and should be kept in English.
onboarding-multistage-theme-label-alpenglow = Waterfox Alpenglow
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

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.


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
        Πολύχρωμη εμφάνιση για τα κουμπιά,
        τα μενού και τα παράθυρα.
# Input description for Alpenglow theme
onboarding-multistage-theme-description-alpenglow =
    .aria-description =
        Πολύχρωμη εμφάνιση για τα κουμπιά,
        τα μενού και τα παράθυρα.

## Multistage MR1 onboarding strings (MR1 about:welcome pages)

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
mr2-onboarding-colorway-description =
    .aria-description = Εξερευνήστε τους χρωματικούς συνδυασμούς «{ $colorwayName }».
# Tooltip displayed on hover of default themes
mr2-onboarding-default-theme-tooltip =
    .title = Εξερευνήστε τα προεπιλεγμένα θέματα.
# Selector description for default themes
mr2-onboarding-default-theme-description =
    .aria-description = Εξερευνήστε τα προεπιλεγμένα θέματα.

## Strings for Thank You page

mr2-onboarding-thank-you-header = Ευχαριστούμε που μας επιλέξατε
mr2-onboarding-thank-you-text = Το { -brand-short-name } είναι ένα ανεξάρτητο πρόγραμμα περιήγησης που υποστηρίζεται από έναν μη κερδοσκοπικό οργανισμό. Μαζί, κάνουμε το διαδίκτυο πιο ασφαλές, υγιές και ιδιωτικό.
mr2-onboarding-start-browsing-button-label = Έναρξη περιήγησης
