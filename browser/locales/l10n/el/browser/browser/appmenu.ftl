# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## App Menu

appmenuitem-update-banner3 =
    .label-update-downloading = Λήψη ενημέρωσης του { -brand-shorter-name }
    .label-update-available = Διαθέσιμη ενημέρωση — λήψη τώρα
    .label-update-manual = Διαθέσιμη ενημέρωση — λήψη τώρα
    .label-update-unsupported = Αδυναμία ενημέρωσης — μη συμβατό σύστημα
    .label-update-restart = Διαθέσιμη ενημέρωση — επανεκκίνηση τώρα
appmenuitem-protection-dashboard-title = Πίνακας προστασίας
appmenuitem-customize-mode =
    .label = Προσαρμογή…

## Zoom Controls

appmenuitem-new-tab =
    .label = Νέα καρτέλα
appmenuitem-new-window =
    .label = Νέο παράθυρο
appmenuitem-new-private-window =
    .label = Νέο ιδιωτικό παράθυρο
appmenuitem-passwords =
    .label = Κωδικοί πρόσβασης
appmenuitem-addons-and-themes =
    .label = Πρόσθετα και θέματα
appmenuitem-find-in-page =
    .label = Εύρεση στη σελίδα…
appmenuitem-more-tools =
    .label = Περισσότερα εργαλεία
appmenuitem-exit2 =
    .label =
        { PLATFORM() ->
            [linux] Έξοδος
           *[other] Έξοδος
        }
appmenu-menu-button-closed2 =
    .tooltiptext = Άνοιγμα μενού εφαρμογής
    .label = { -brand-short-name }
appmenu-menu-button-opened2 =
    .tooltiptext = Κλείσιμο μενού εφαρμογής
    .label = { -brand-short-name }
# Settings is now used to access the browser settings across all platforms,
# instead of Options or Preferences.
appmenuitem-settings =
    .label = Ρυθμίσεις

## Zoom and Fullscreen Controls

appmenuitem-zoom-enlarge =
    .label = Μεγέθυνση
appmenuitem-zoom-reduce =
    .label = Σμίκρυνση
appmenuitem-fullscreen =
    .label = Πλήρης οθόνη

## Firefox Account toolbar button and Sync panel in App menu.

fxa-toolbar-sync-now =
    .label = Συγχρονισμός τώρα
appmenu-remote-tabs-sign-into-sync =
    .label = Σύνδεση στο Sync…
appmenu-remote-tabs-turn-on-sync =
    .label = Ενεργοποίηση Sync…
appmenuitem-fxa-toolbar-sync-now2 = Συγχρονισμός τώρα
appmenuitem-fxa-manage-account = Διαχείριση λογαριασμού
appmenu-fxa-header2 = { -fxaccount-brand-name }
# Variables
# $time (string) - Localized relative time since last sync (e.g. 1 second ago,
# 3 hours ago, etc.)
appmenu-fxa-last-sync = Τελευταίος συγχρονισμός: { $time }
    .label = Τελευταίος συγχρονισμός: { $time }
appmenu-fxa-sync-and-save-data2 = Συγχρονισμός και αποθήκευση δεδομένων
appmenu-fxa-signed-in-label = Σύνδεση
appmenu-fxa-setup-sync =
    .label = Ενεργοποίηση συγχρονισμού…
appmenu-fxa-show-more-tabs = Εμφάνιση περισσότερων καρτελών
appmenuitem-save-page =
    .label = Αποθήκευση σελίδας ως…

## What's New panel in App menu.

whatsnew-panel-header = Τι νέο υπάρχει
# Checkbox displayed at the bottom of the What's New panel, allowing users to
# enable/disable What's New notifications.
whatsnew-panel-footer-checkbox =
    .label = Ειδοποίηση για νέες λειτουργίες
    .accesskey = λ

## The Firefox Profiler – The popup is the UI to turn on the profiler, and record
## performance profiles. To enable it go to profiler.firefox.com and click
## "Enable Profiler Menu Button".

profiler-popup-title =
    .value = { -profiler-brand-name }
profiler-popup-reveal-description-button =
    .aria-label = Αποκάλυψη περισσότερων πληροφοριών
profiler-popup-description-title =
    .value = Εγγραφή, ανάλυση, κοινοποίηση
profiler-popup-description = Αντιμετωπίστε ζητήματα επιδόσεων κάνοντας κοινή χρήση των προφίλ με την ομάδα σας.
profiler-popup-learn-more = Μάθετε περισσότερα
profiler-popup-settings =
    .value = Ρυθμίσεις
# This link takes the user to about:profiling, and is only visible with the Custom preset.
profiler-popup-edit-settings = Επεξεργασία ρυθμίσεων…
profiler-popup-disabled =
    Το profiler είναι ανενεργό αυτή τη στιγμή, πιθανότατα επειδή είναι ανοικτό ένα παράθυρο
    ιδιωτικής περιήγησης.
profiler-popup-recording-screen = Εγγραφή…
# The profiler presets list is generated elsewhere, but the custom preset is defined
# here only.
profiler-popup-presets-custom =
    .label = Προσαρμοσμένο
profiler-popup-start-recording-button =
    .label = Έναρξη εγγραφής
profiler-popup-discard-button =
    .label = Απόρριψη
profiler-popup-capture-button =
    .label = Καταγραφή
profiler-popup-start-shortcut =
    { PLATFORM() ->
        [macos] ⌃⇧1
       *[other] Ctrl+Shift+1
    }
profiler-popup-capture-shortcut =
    { PLATFORM() ->
        [macos] ⌃⇧2
       *[other] Ctrl+Shift+2
    }

## History panel

appmenu-manage-history =
    .label = Διαχείριση ιστορικού
appmenu-reopen-all-tabs = Επαναφορά όλων των καρτελών
appmenu-reopen-all-windows = Επαναφορά όλων των παραθύρων
appmenu-restore-session =
    .label = Επαναφορά προηγούμενης συνεδρίας
appmenu-clear-history =
    .label = Εκκαθάριση πρόσφατου ιστορικού…
appmenu-recent-history-subheader = Πρόσφατο ιστορικό
appmenu-recently-closed-tabs =
    .label = Πρόσφατα κλεισμένες καρτέλες
appmenu-recently-closed-windows =
    .label = Πρόσφατα κλεισμένα παράθυρα

## Help panel

appmenu-help-header =
    .title = Βοήθεια { -brand-shorter-name }
appmenu-about =
    .label = Σχετικά με το { -brand-shorter-name }
    .accesskey = τ
appmenu-get-help =
    .label = Λήψη βοήθειας
    .accesskey = β
appmenu-help-more-troubleshooting-info =
    .label = Πληροφορίες επίλυσης προβλημάτων
    .accesskey = Π
appmenu-help-report-site-issue =
    .label = Αναφορά ζητήματος ιστοσελίδας…
appmenu-help-feedback-page =
    .label = Υποβολή σχολίων…
    .accesskey = λ

## appmenu-help-enter-troubleshoot-mode and appmenu-help-exit-troubleshoot-mode
## are mutually exclusive, so it's possible to use the same accesskey for both.

appmenu-help-enter-troubleshoot-mode2 =
    .label = Λειτουργία επίλυσης προβλημάτων…
    .accesskey = Λ
appmenu-help-exit-troubleshoot-mode =
    .label = Απενεργοποίηση λειτουργίας επίλυσης προβλημάτων
    .accesskey = Α

## appmenu-help-report-deceptive-site and appmenu-help-not-deceptive
## are mutually exclusive, so it's possible to use the same accesskey for both.

appmenu-help-report-deceptive-site =
    .label = Αναφορά παραπλανητικής σελίδας…
    .accesskey = Α
appmenu-help-not-deceptive =
    .label = Αυτή δεν είναι παραπλανητική ιστοσελίδα…
    .accesskey = δ

## More Tools

appmenu-customizetoolbar =
    .label = Προσαρμογή γραμμής εργαλειών…
appmenu-taskmanager =
    .label = Διαχείριση εργασιών
appmenu-developer-tools-subheader = Εργαλεία προγράμματος περιήγησης
appmenu-developer-tools-extensions =
    .label = Επεκτάσεις για προγραμματιστές
