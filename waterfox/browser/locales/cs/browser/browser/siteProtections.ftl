# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

content-blocking-trackers-view-empty = Nenalezeny žádné sledovací prvky
content-blocking-cookies-blocking-trackers-label = Sledovací cookies
content-blocking-cookies-blocking-third-party-label = Cookies třetích stran
content-blocking-cookies-blocking-unvisited-label = Cookies z dosud nenavštívených stránek
content-blocking-cookies-blocking-all-label = Všechny cookies
content-blocking-cookies-view-first-party-label = Z této stránky
content-blocking-cookies-view-trackers-label = Sledovací cookies
content-blocking-cookies-view-third-party-label = Cookies třetích stran
# This label is shown next to a cookie origin in the cookies subview.
# It forms the end of the (imaginary) sentence "www.example.com [was] Allowed"
content-blocking-cookies-view-allowed-label =
    .value = Neblokováno
# This label is shown next to a cookie origin in the cookies subview.
# It forms the end of the (imaginary) sentence "www.example.com [was] Blocked"
content-blocking-cookies-view-blocked-label =
    .value = Zablokováno
# Variables:
#   $domain (String): the domain of the site.
content-blocking-cookies-view-remove-button =
    .tooltiptext = Zrušit výjimku z blokování cookies pro { $domain }
tracking-protection-icon-active = Sledovací prvky sociálních sítí, cookies třetích stran i vytváření otisku prohlížeče je blokováno.
tracking-protection-icon-active-container =
    .aria-label = { tracking-protection-icon-active }
tracking-protection-icon-disabled = Rozšířená ochrana proti sledování je pro tento web vypnuta.
tracking-protection-icon-disabled-container =
    .aria-label = { tracking-protection-icon-disabled }
tracking-protection-icon-no-trackers-detected =
    { -brand-short-name.gender ->
        [masculine] { -brand-short-name } na této stránce nenalezl žádné známé sledovací prvky.
        [feminine] { -brand-short-name } na této stránce nenalezla žádné známé sledovací prvky.
        [neuter] { -brand-short-name } na této stránce nenalezlo žádné známé sledovací prvky.
       *[other] Aplikace { -brand-short-name } na této stránce nenalezla žádné známé sledovací prvky.
    }
tracking-protection-icon-no-trackers-detected-container =
    .aria-label = { tracking-protection-icon-no-trackers-detected }

## Variables:
##   $host (String): the site's hostname

# Header of the Protections Panel.
protections-header = Ochrana proti sledování na serveru { $host }
# Text that gets spoken by a screen reader if the button will disable protections.
protections-disable =
    .aria-label = Vypnout ochranu na serveru { $host }
# Text that gets spoken by a screen reader if the button will enable protections.
protections-enable =
    .aria-label = Zapnout ochranu na serveru { $host }

## Blocking and Not Blocking sub-views in the Protections Panel

protections-blocking-fingerprinters =
    .title = Blokováno vytváření otisku prohlížeče
protections-blocking-cryptominers =
    .title = Blokována těžba kryproměn
protections-blocking-cookies-trackers =
    .title = Zablokované sledovací cookies
protections-blocking-cookies-third-party =
    .title = Zablokované cookies třetích stran
protections-blocking-cookies-all =
    .title = Všechny cookies jsou blokovány
protections-blocking-cookies-unvisited =
    .title = Zablokované cookies z dosud nenavštívených stránek
protections-blocking-tracking-content =
    .title = Blokován sledující obsah
protections-blocking-social-media-trackers =
    .title = Blokovány sledovací prvky sociálních sítí
protections-not-blocking-fingerprinters =
    .title = Vytváření otisku prohlížeče neblokováno
protections-not-blocking-cryptominers =
    .title = Těžba kryptoměn neblokována
protections-not-blocking-cookies-third-party =
    .title = Cookies třetích stan neblokovány
protections-not-blocking-cookies-all =
    .title = Cookies neblokovány
protections-not-blocking-cross-site-tracking-cookies =
    .title = Sledovací cookies neblokovány
protections-not-blocking-tracking-content =
    .title = Sledující obsah neblokován
protections-not-blocking-social-media-trackers =
    .title = Sledovací prvky sociálních sítí neblokovány

## Footer and Milestones sections in the Protections Panel
## Variables:
##   $trackerCount (Number): number of trackers blocked
##   $date (Date): the date on which we started counting

# This text indicates the total number of trackers blocked on all sites.
# In its tooltip, we show the date when we started counting this number.
protections-footer-blocked-tracker-counter =
    { $trackerCount ->
        [one] Zablokován jeden prvek
        [few] Zablokovány { $trackerCount } prvky
       *[other] Zablokováno { $trackerCount } prvků
    }
    .tooltiptext = Od { DATETIME($date, year: "numeric", month: "long", day: "numeric") }
# In English this looks like "Waterfox blocked over 10,000 trackers since October 2019"
protections-milestone =
    { $trackerCount ->
        [one]
            { -brand-short-name.gender ->
                [masculine] Od { DATETIME($date, year: "numeric", month: "long") } { -brand-short-name } zablokoval jeden sledovací prvek
                [feminine] Od { DATETIME($date, year: "numeric", month: "long") } { -brand-short-name } zablokovala jeden sledovací prvek
                [neuter] Od { DATETIME($date, year: "numeric", month: "long") } { -brand-short-name } zablokovalo jeden sledovací prvek
               *[other] Od { DATETIME($date, year: "numeric", month: "long") } aplikace { -brand-short-name } zablokovala jeden sledovací prvek
            }
        [few]
            { -brand-short-name.gender ->
                [masculine] Od { DATETIME($date, year: "numeric", month: "long") } { -brand-short-name } zablokoval více než { $trackerCount } sledovací prvky
                [feminine] Od { DATETIME($date, year: "numeric", month: "long") } { -brand-short-name } zablokovala více než { $trackerCount } sledovací prvky
                [neuter] Od { DATETIME($date, year: "numeric", month: "long") } { -brand-short-name } zablokovalo více než { $trackerCount } sledovací prvky
               *[other] Od { DATETIME($date, year: "numeric", month: "long") } aplikace { -brand-short-name } zablokovala více než { $trackerCount } sledovací prvky
            }
       *[other]
            { -brand-short-name.gender ->
                [masculine] Od { DATETIME($date, year: "numeric", month: "long") } { -brand-short-name } zablokoval více než { $trackerCount } sledovacích prvků
                [feminine] Od { DATETIME($date, year: "numeric", month: "long") } { -brand-short-name } zablokovala více než { $trackerCount } sledovacích prvků
                [neuter] Od { DATETIME($date, year: "numeric", month: "long") } { -brand-short-name } zablokovalo více než { $trackerCount } sledovacích prvků
               *[other] Od { DATETIME($date, year: "numeric", month: "long") } aplikace { -brand-short-name } zablokovala více než { $trackerCount } sledovacích prvků
            }
    }
