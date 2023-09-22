# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

content-blocking-trackers-view-empty = Κανένα σε αυτόν τον ιστότοπο
content-blocking-cookies-blocking-trackers-label = Cookies καταγραφής μεταξύ ιστοτόπων
content-blocking-cookies-blocking-third-party-label = Cookies τρίτων
content-blocking-cookies-blocking-unvisited-label = Cookies ιστοτόπων που δεν έχετε επισκεφθεί
content-blocking-cookies-blocking-all-label = Όλα τα cookies
content-blocking-cookies-view-first-party-label = Από αυτόν τον ιστότοπο
content-blocking-cookies-view-trackers-label = Cookies καταγραφής μεταξύ ιστοτόπων
content-blocking-cookies-view-third-party-label = Cookies τρίτων
# This label is shown next to a cookie origin in the cookies subview.
# It forms the end of the (imaginary) sentence "www.example.com [was] Allowed"
content-blocking-cookies-view-allowed-label =
    .value = Επιτρέπεται
# This label is shown next to a cookie origin in the cookies subview.
# It forms the end of the (imaginary) sentence "www.example.com [was] Blocked"
content-blocking-cookies-view-blocked-label =
    .value = Αποκλεισμένο
# Variables:
#   $domain (String): the domain of the site.
content-blocking-cookies-view-remove-button =
    .tooltiptext = Απαλοιφή εξαίρεσης cookie για το { $domain }
tracking-protection-icon-active = Φραγή ιχνηλατών κοινωνικών μέσων, cookies καταγραφής μεταξύ ιστοτόπων και fingerprinters.
tracking-protection-icon-active-container =
    .aria-label = { tracking-protection-icon-active }
tracking-protection-icon-disabled = Η ενισχυμένη προστασία από καταγραφή είναι ΑΝΕΝΕΡΓΗ για τον ιστότοπο.
tracking-protection-icon-disabled-container =
    .aria-label = { tracking-protection-icon-disabled }
tracking-protection-icon-no-trackers-detected = Δεν εντοπίστηκαν ιχνηλάτες γνωστοί στο { -brand-short-name } στη σελίδα.
tracking-protection-icon-no-trackers-detected-container =
    .aria-label = { tracking-protection-icon-no-trackers-detected }

## Variables:
##   $host (String): the site's hostname

# Header of the Protections Panel.
protections-header = Προστασία για το { $host }
# Text that gets spoken by a screen reader if the button will disable protections.
protections-disable =
    .aria-label = Απενεργοποίηση προστασίας για το { $host }
# Text that gets spoken by a screen reader if the button will enable protections.
protections-enable =
    .aria-label = Ενεργοποίηση προστασίας για το { $host }

## Blocking and Not Blocking sub-views in the Protections Panel

protections-blocking-fingerprinters =
    .title = Αποκλεισμένα fingerprinter
protections-blocking-cryptominers =
    .title = Αποκλεισμένα cryptominer
protections-blocking-cookies-trackers =
    .title = Αποκλεισμένα cookies καταγραφής μεταξύ ιστοτόπων
protections-blocking-cookies-third-party =
    .title = Αποκλεισμένα cookies τρίτων
protections-blocking-cookies-all =
    .title = Αποκλείονται όλα τα cookies
protections-blocking-cookies-unvisited =
    .title = Αποκλείονται τα cookies ιστοτόπων που δεν έχετε επισκεφθεί
protections-blocking-tracking-content =
    .title = Αποκλείεται περιεχόμενο καταγραφής
protections-blocking-social-media-trackers =
    .title = Αποκλείονται ιχνηλάτες κοινωνικών δικτύων
protections-not-blocking-fingerprinters =
    .title = Δεν αποκλείονται fingerprinter
protections-not-blocking-cryptominers =
    .title = Δεν αποκλείονται cryptominer
protections-not-blocking-cookies-third-party =
    .title = Δεν αποκλείονται cookies τρίτων
protections-not-blocking-cookies-all =
    .title = Δεν αποκλείονται cookies
protections-not-blocking-cross-site-tracking-cookies =
    .title = Δεν αποκλείονται cookies καταγραφής μεταξύ ιστοτόπων
protections-not-blocking-tracking-content =
    .title = Δεν αποκλείεται περιεχόμενο καταγραφής
protections-not-blocking-social-media-trackers =
    .title = Δεν αποκλείονται ιχνηλάτες κοινωνικών μέσων

## Footer and Milestones sections in the Protections Panel
## Variables:
##   $trackerCount (Number): number of trackers blocked
##   $date (Date): the date on which we started counting

# This text indicates the total number of trackers blocked on all sites.
# In its tooltip, we show the date when we started counting this number.
protections-footer-blocked-tracker-counter =
    { $trackerCount ->
        [one] { $trackerCount } αποκλεισμένο
       *[other] { $trackerCount } αποκλεισμένα
    }
    .tooltiptext = Από τις { DATETIME($date, year: "numeric", month: "long", day: "numeric") }
# In English this looks like "Waterfox blocked over 10,000 trackers since October 2019"
protections-milestone =
    { $trackerCount ->
        [one] Το { -brand-short-name } απέκλεισε { $trackerCount } ιχνηλάτη από τον { DATETIME($date, year: "numeric", month: "long") }
       *[other] Το { -brand-short-name } απέκλεισε { $trackerCount } ιχνηλάτες από τον { DATETIME($date, year: "numeric", month: "long") }
    }
