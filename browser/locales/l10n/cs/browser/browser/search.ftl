# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These strings are used for errors when installing OpenSearch engines, e.g.
## via "Add Search Engine" on the address bar or search bar.
## Variables
## $location-url (String) - the URL of the OpenSearch engine that was attempted to be installed.

opensearch-error-duplicate-title = Chyba instalace
opensearch-error-duplicate-desc =
    { -brand-short-name.gender ->
        [masculine] { -brand-short-name } nemohl
        [feminine] { -brand-short-name } nemohla
        [neuter] { -brand-short-name } nemohlo
       *[other] Aplikace { -brand-short-name } nemohla
    } nainstalovat vyhledávač z „{ $location-url }“, protože už existuje jiný se stejným názvem.
opensearch-error-format-title = Neplatný formát
opensearch-error-format-desc =
    { -brand-short-name.gender ->
        [masculine] { -brand-short-name } nemohl
        [feminine] { -brand-short-name } nemohla
        [neuter] { -brand-short-name } nemohlo
       *[other] Aplikace { -brand-short-name } nemohla
    } nainstalovat vyhledávač z „{ $location-url }“
opensearch-error-download-title = Chyba stahování
opensearch-error-download-desc =
    { -brand-short-name.gender ->
        [masculine] { -brand-short-name } nemohl
        [feminine] { -brand-short-name } nemohla
        [neuter] { -brand-short-name } nemohlo
       *[other] Aplikace { -brand-short-name } nemohla
    } stáhnout vyhledávač z „{ $location-url }“

##

