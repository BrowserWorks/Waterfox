# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Note: This is currently placed under browser/base/content so that we can
# get the strings to appear without having our localization community need
# to go through and translate everything. Once these strings are ready for
# translation, we'll move it to the locales folder.


## These strings are used so that the window has a title in tools that
## enumerate/look for window titles. It is not normally visible anywhere.

webrtc-indicator-title = { -brand-short-name } - Δείκτης κοινής χρήσης
webrtc-indicator-window =
    .title = { -brand-short-name } - Δείκτης κοινής χρήσης

## Used as list items in sharing menu

webrtc-item-camera = κάμερα
webrtc-item-microphone = μικρόφωνο
webrtc-item-audio-capture = ήχος καρτέλας
webrtc-item-application = εφαρμογή
webrtc-item-screen = οθόνη
webrtc-item-window = παράθυρο
webrtc-item-browser = καρτέλα

##

# This is used for the website origin for the sharing menu if no readable origin could be deduced from the URL.
webrtc-sharing-menuitem-unknown-host = Άγνωστη προέλευση

# Variables:
#   $origin (String): The website origin (e.g. www.mozilla.org)
#   $itemList (String): A formatted list of items (e.g. "camera, microphone and tab audio")
webrtc-sharing-menuitem =
    .label = { $origin } ({ $itemList })
webrtc-sharing-menu =
    .label = Καρτέλες που μοιράζονται συσκευές
    .accesskey = σ

webrtc-sharing-window = Μοιράζεστε το παράθυρο μιας άλλης εφαρμογής.
webrtc-sharing-browser-window = Μοιράζεστε το { -brand-short-name }.
webrtc-sharing-screen = Μοιράζεστε ολόκληρη την οθόνη σας.
webrtc-stop-sharing-button = Διακοπή κοινής χρήσης
webrtc-microphone-unmuted =
    .title = Απενεργοποίηση μικροφώνου
webrtc-microphone-muted =
    .title = Ενεργοποίηση μικροφώνου
webrtc-camera-unmuted =
    .title = Απενεργοποίηση κάμερας
webrtc-camera-muted =
    .title = Ενεργοποίηση κάμερας
webrtc-minimize =
    .title = Ελαχιστοποίηση δείκτη

## These strings will display as a tooltip on supported systems where we show
## device sharing state in the OS notification area. We do not use these strings
## on macOS, as global menu bar items do not have native tooltips.

webrtc-camera-system-menu =
    .label = Κάνετε κοινή χρήση της κάμεράς σας. Κάντε κλικ για έλεγχο κοινής χρήσης.
webrtc-microphone-system-menu =
    .label = Κάνετε κοινή χρήση του μικροφώνου σας. Κάντε κλικ για έλεγχο κοινής χρήσης.
webrtc-screen-system-menu =
    .label = Κάνετε κοινή χρήση παραθύρου ή οθόνης. Κάντε κλικ για έλεγχο κοινής χρήσης.

## Tooltips used by the legacy global sharing indicator

webrtc-indicator-sharing-camera-and-microphone =
    .tooltiptext = Η κάμερα και το μικρόφωνό σας είναι κοινόχρηστα. Κάντε κλικ για έλεγχο κοινής χρήσης.
webrtc-indicator-sharing-camera =
    .tooltiptext = Η κάμερά σας είναι κοινόχρηστη. Κάντε κλικ για έλεγχο κοινής χρήσης.
webrtc-indicator-sharing-microphone =
    .tooltiptext = Το μικρόφωνό σας είναι κοινόχρηστο. Κάντε κλικ για έλεγχο κοινής χρήσης.
webrtc-indicator-sharing-application =
    .tooltiptext = Μια εφαρμογή είναι κοινόχρηστη. Κάντε κλικ για έλεγχο κοινής χρήσης.
webrtc-indicator-sharing-screen =
    .tooltiptext = Η οθόνη σας είναι κοινόχρηστη. Κάντε κλικ για έλεγχο κοινής χρήσης.
webrtc-indicator-sharing-window =
    .tooltiptext = Ένα παράθυρο είναι κοινόχρηστο. Κάντε κλικ για έλεγχο κοινής χρήσης.
webrtc-indicator-sharing-browser =
    .tooltiptext = Μια καρτέλα είναι κοινόχρηστη. Κάντε κλικ για έλεγχο κοινής χρήσης.

## These strings are only used on Mac for menus attached to icons
## near the clock on the mac menubar.
## Variables:
##   $streamTitle (String): the title of the tab using the share.
##   $tabCount (Number): the title of the tab using the share.

webrtc-indicator-menuitem-control-sharing =
    .label = Έλεγχος κοινής χρήσης
webrtc-indicator-menuitem-control-sharing-on =
    .label = Έλεγχος κοινής χρήσης για «{ $streamTitle }»

webrtc-indicator-menuitem-sharing-camera-with =
    .label = Κοινή χρήση κάμερας με «{ $streamTitle }»
webrtc-indicator-menuitem-sharing-camera-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Κοινή χρήση κάμερας με { $tabCount } καρτέλα
           *[other] Κοινή χρήση κάμερας με { $tabCount } καρτέλες
        }

webrtc-indicator-menuitem-sharing-microphone-with =
    .label = Κοινή χρήση μικροφώνου με «{ $streamTitle }»
webrtc-indicator-menuitem-sharing-microphone-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Κοινή χρήση μικροφώνου με { $tabCount } καρτέλα
           *[other] Κοινή χρήση μικροφώνου με { $tabCount } καρτέλες
        }

webrtc-indicator-menuitem-sharing-application-with =
    .label = Κοινή χρήση εφαρμογής με «{ $streamTitle }»
webrtc-indicator-menuitem-sharing-application-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Κοινή χρήση εφαρμογής με { $tabCount } καρτέλα
           *[other] Κοινή χρήση εφαρμογών με { $tabCount } καρτέλες
        }

webrtc-indicator-menuitem-sharing-screen-with =
    .label = Κοινή χρήση οθόνης με «{ $streamTitle }»
webrtc-indicator-menuitem-sharing-screen-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Κοινή χρήση οθόνης με { $tabCount } καρτέλα
           *[other] Κοινή χρήση οθόνης με { $tabCount } καρτέλες
        }

webrtc-indicator-menuitem-sharing-window-with =
    .label = Κοινή χρήση παραθύρου με «{ $streamTitle }»
webrtc-indicator-menuitem-sharing-window-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Κοινή χρήση παραθύρου με { $tabCount } καρτέλα
           *[other] Κοινή χρήση παραθύρων με { $tabCount } καρτέλες
        }

webrtc-indicator-menuitem-sharing-browser-with =
    .label = Κοινή χρήση καρτέλας με «{ $streamTitle }»
# This message is shown when the contents of a tab is shared during a WebRTC
# session, which currently is only possible with Loop/Hello.
webrtc-indicator-menuitem-sharing-browser-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Κοινή χρήση καρτέλας με { $tabCount } καρτέλα
           *[other] Κοινή χρήση καρτελών με { $tabCount } καρτέλες
        }

## Variables:
##   $origin (String): the website origin (e.g. www.mozilla.org).

webrtc-allow-share-audio-capture = Να επιτρέπεται στο { $origin } η ακρόαση του ήχου αυτής της καρτέλας;
webrtc-allow-share-camera = Να επιτρέπεται στο { $origin } η χρήση της κάμεράς σας;
webrtc-allow-share-microphone = Να επιτρέπεται στο { $origin } η χρήση του μικροφώνου σας;
webrtc-allow-share-screen = Να επιτρέπεται στο { $origin } η θέαση της οθόνης σας;
# "Speakers" is used in a general sense that might include headphones or
# another audio output connection.
webrtc-allow-share-speaker = Να επιτρέπεται στο { $origin } η χρήση άλλων ηχείων;
webrtc-allow-share-camera-and-microphone = Να επιτρέπεται στο { $origin } η χρήση της κάμερας και του μικροφώνου σας;
webrtc-allow-share-camera-and-audio-capture = Να επιτρέπεται στο { $origin } η χρήση της κάμερας και η ακρόαση του ήχου αυτής της καρτέλας;
webrtc-allow-share-screen-and-microphone = Να επιτρέπεται στο { $origin } η χρήση του μικροφώνου και η θέαση της οθόνης σας;
webrtc-allow-share-screen-and-audio-capture = Να επιτρέπεται στο { $origin } η ακρόαση του ήχου αυτής της καρτέλας και η θέαση της οθόνης σας;

## Variables:
##   $origin (String): the first party origin.
##   $thirdParty (String): the third party origin.

webrtc-allow-share-audio-capture-unsafe-delegation = Να επιτρέπεται στο { $origin } να παραχωρεί στο { $thirdParty } άδεια για ακρόαση του ήχου αυτής της καρτέλας;
webrtc-allow-share-camera-unsafe-delegation = Να επιτρέπεται στο { $origin } να παραχωρεί στο { $thirdParty } πρόσβαση στην κάμερά σας;
webrtc-allow-share-microphone-unsafe-delegation = Να επιτρέπεται στο { $origin } να παραχωρεί στο { $thirdParty } πρόσβαση στο μικρόφωνό σας;
webrtc-allow-share-screen-unsafe-delegation = Να επιτρέπεται στο { $origin } να παραχωρεί στο { $thirdParty } άδεια για θέαση της οθόνης σας;
# "Speakers" is used in a general sense that might include headphones or
# another audio output connection.
webrtc-allow-share-speaker-unsafe-delegation = Να επιτρέπεται στο { $origin } να παραχωρεί στο { $thirdParty } πρόσβαση σε άλλα ηχεία;
webrtc-allow-share-camera-and-microphone-unsafe-delegation = Να επιτρέπεται στο { $origin } να παραχωρεί στο { $thirdParty } πρόσβαση στην κάμερα και το μικρόφωνό σας;
webrtc-allow-share-camera-and-audio-capture-unsafe-delegation = Να επιτρέπεται στο { $origin } να παραχωρεί στο { $thirdParty } πρόσβαση στην κάμερά σας και δικαίωμα ακρόασης του ήχου αυτής της καρτέλας;
webrtc-allow-share-screen-and-microphone-unsafe-delegation = Να επιτρέπεται στο { $origin } να παραχωρεί στο { $thirdParty } πρόσβαση στο μικρόφωνό σας και άδεια θέασης της οθόνης σας;
webrtc-allow-share-screen-and-audio-capture-unsafe-delegation = Να επιτρέπεται στο { $origin } να παραχωρεί στο { $thirdParty } άδεια για ακρόαση του ήχου αυτής της καρτέλας και θέαση της οθόνης σας;

##

webrtc-share-screen-warning = Να μοιράζεστε οθόνες μόνο με αξιόπιστες ιστοσελίδες. Η κοινή χρήση μπορεί να επιτρέψει σε παραπλανητικές ιστοσελίδες να περιηγηθούν με την ταυτότητά σας και να υποκλέψουν τα προσωπικά δεδομένα σας.
webrtc-share-browser-warning = Να μοιράζεστε το { -brand-short-name } μόνο με αξιόπιστες ιστοσελίδες. Η κοινή χρήση μπορεί να επιτρέψει σε παραπλανητικές ιστοσελίδες να περιηγηθούν με την ταυτότητά σας και να υποκλέψουν τα προσωπικά δεδομένα σας.

webrtc-share-screen-learn-more = Μάθετε περισσότερα
webrtc-pick-window-or-screen = Επιλέξτε παράθυρο ή οθόνη
webrtc-share-entire-screen = Ολόκληρη η οθόνη
webrtc-share-pipe-wire-portal = Χρήση ρυθμίσεων λειτουργικού συστήματος
# Variables:
#   $monitorIndex (String): screen number (digits 1, 2, etc).
webrtc-share-monitor = Οθόνη { $monitorIndex }
# Variables:
#   $windowCount (Number): the number of windows currently displayed by the application.
#   $appName (String): the name of the application.
webrtc-share-application =
    { $windowCount ->
        [one] { $appName } ({ $windowCount } παράθυρο)
       *[other] { $appName } ({ $windowCount } παράθυρα)
    }

## These buttons are the possible answers to the various prompts in the "webrtc-allow-share-*" strings.

webrtc-action-allow =
    .label = Αποδοχή
    .accesskey = Α
webrtc-action-block =
    .label = Φραγή
    .accesskey = Φ
webrtc-action-always-block =
    .label = Πάντα φραγή
    .accesskey = τ
webrtc-action-not-now =
    .label = Όχι τώρα
    .accesskey = χ

##

webrtc-remember-allow-checkbox = Απομνημόνευση επιλογής
webrtc-mute-notifications-checkbox = Σίγαση ειδοποιήσεων ιστοτόπου κατά την κοινή χρήση

webrtc-reason-for-no-permanent-allow-screen = Το { -brand-short-name } δεν μπορεί να επιτρέψει μόνιμη πρόσβαση στην οθόνη σας.
webrtc-reason-for-no-permanent-allow-audio = Το { -brand-short-name } δεν μπορεί να επιτρέψει μόνιμη πρόσβαση στον ήχο της καρτέλας σας χωρίς να ρωτήσει ποια καρτέλα θα διαμοιραστεί.
webrtc-reason-for-no-permanent-allow-insecure = Η σύνδεσή σας με αυτόν τον ιστότοπο δεν είναι ασφαλής. Για την προστασία σας, το { -brand-short-name } θα επιτρέψει την πρόσβαση μόνο για αυτήν τη συνεδρία.
