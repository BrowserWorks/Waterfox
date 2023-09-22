# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

content-blocking-trackers-view-empty = Tidak ada yang terdeteksi di situs ini
content-blocking-cookies-blocking-trackers-label = Kuki Pelacakan Lintas Situs
content-blocking-cookies-blocking-third-party-label = Kuki Pihak Ketiga
content-blocking-cookies-blocking-unvisited-label = Kuki Situs yang Tidak Dikunjungi
content-blocking-cookies-blocking-all-label = Semua Kuki
content-blocking-cookies-view-first-party-label = Dari Situs Ini
content-blocking-cookies-view-trackers-label = Kuki Pelacakan Lintas Situs
content-blocking-cookies-view-third-party-label = Kuki Pihak Ketiga
# This label is shown next to a cookie origin in the cookies subview.
# It forms the end of the (imaginary) sentence "www.example.com [was] Allowed"
content-blocking-cookies-view-allowed-label =
    .value = Diizinkan
# This label is shown next to a cookie origin in the cookies subview.
# It forms the end of the (imaginary) sentence "www.example.com [was] Blocked"
content-blocking-cookies-view-blocked-label =
    .value = Diblokir
# Variables:
#   $domain (String): the domain of the site.
content-blocking-cookies-view-remove-button =
    .tooltiptext = Bersihkan pengecualian kuki untuk { $domain }
tracking-protection-icon-active = Memblokir pelacak media sosial, kuki pelacakan lintas, dan pelacak sidik.
tracking-protection-icon-active-container =
    .aria-label = { tracking-protection-icon-active }
tracking-protection-icon-disabled = Perlindungan Pelacakan yang Ditingkatkan NONAKTIF untuk situs ini.
tracking-protection-icon-disabled-container =
    .aria-label = { tracking-protection-icon-disabled }
tracking-protection-icon-no-trackers-detected = Tidak ada pelacak yang dikenali { -brand-short-name } terdeteksi di laman ini.
tracking-protection-icon-no-trackers-detected-container =
    .aria-label = { tracking-protection-icon-no-trackers-detected }

## Variables:
##   $host (String): the site's hostname

# Header of the Protections Panel.
protections-header = Perlindungan untuk { $host }
# Text that gets spoken by a screen reader if the button will disable protections.
protections-disable =
    .aria-label = Nonaktifkan perlindungan untuk { $host }
# Text that gets spoken by a screen reader if the button will enable protections.
protections-enable =
    .aria-label = Aktifkan perlindungan untuk { $host }

## Blocking and Not Blocking sub-views in the Protections Panel

protections-blocking-fingerprinters =
    .title = Pelacak Sidik Diblokir
protections-blocking-cryptominers =
    .title = Penambang Kripto Diblokir
protections-blocking-cookies-trackers =
    .title = Kuki Pelacakan Lintas Diblokir
protections-blocking-cookies-third-party =
    .title = Kuki Pihak Ketiga Diblokir
protections-blocking-cookies-all =
    .title = Semua Kuki Diblokir
protections-blocking-cookies-unvisited =
    .title = Kuki Situs yang Belum Dikunjungi Diblokir
protections-blocking-tracking-content =
    .title = Konten Pelacak Diblokir
protections-blocking-social-media-trackers =
    .title = Pelacak Media Sosial Diblokir
protections-not-blocking-fingerprinters =
    .title = Tidak Memblokir Pelacak Sidik
protections-not-blocking-cryptominers =
    .title = Tidak Memblokir Penambang Kripto
protections-not-blocking-cookies-third-party =
    .title = Tidak memblokir Kuki Pihak Ketiga
protections-not-blocking-cookies-all =
    .title = Tidak Memblokir Kuki
protections-not-blocking-cross-site-tracking-cookies =
    .title = Tidak Memblokir Kuki Pelacakan Lintas
protections-not-blocking-tracking-content =
    .title = Tidak Memblokir Konten Pelacak
protections-not-blocking-social-media-trackers =
    .title = Tidak Memblokir Pelacak Media Sosial

## Footer and Milestones sections in the Protections Panel
## Variables:
##   $trackerCount (Number): number of trackers blocked
##   $date (Date): the date on which we started counting

# This text indicates the total number of trackers blocked on all sites.
# In its tooltip, we show the date when we started counting this number.
protections-footer-blocked-tracker-counter = { $trackerCount } Diblokir
    .tooltiptext = Sejak { DATETIME($date, year: "numeric", month: "long", day: "numeric") }
# In English this looks like "Waterfox blocked over 10,000 trackers since October 2019"
protections-milestone = { -brand-short-name } memblokir { $trackerCount } pelacak sejak { DATETIME($date, year: "numeric", month: "long") }
