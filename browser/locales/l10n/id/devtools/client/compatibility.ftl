# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Messages used as headers in the main pane

compatibility-selected-element-header = Elemen yang Dipilih
compatibility-all-elements-header = Semua Masalah

## Message used as labels for the type of issue

compatibility-issue-deprecated = (usang)
compatibility-issue-experimental = (eksperimental)
compatibility-issue-prefixneeded = (diperlukan prefiks)
compatibility-issue-deprecated-experimental = (usang, eksperimental)
compatibility-issue-deprecated-prefixneeded = (tidak disarankan, prefiks dibutuhkan)
compatibility-issue-experimental-prefixneeded = (eksperimental, diperlukan prefiks)
compatibility-issue-deprecated-experimental-prefixneeded = (tidak disarankan, eksperimental, prefiks dibutuhkan)

## Messages used as labels and titles for buttons in the footer

compatibility-settings-button-label = Pengaturan
compatibility-settings-button-title =
    .title = Pengaturan
compatibility-feedback-button-label = Umpan Balik
compatibility-feedback-button-title =
    .title = Umpan Balik

## Messages used as headers in settings pane

compatibility-settings-header = Pengaturan
compatibility-target-browsers-header = Peramban Target

##

# Text used as the label for the number of nodes where the issue occurred
# Variables:
#   $number (Number) - The number of nodes where the issue occurred
compatibility-issue-occurrences =
    { $number ->
       *[other] { $number } kemunculan
    }
compatibility-no-issues-found = Tidak ditemukan masalah kompatibilitas.
compatibility-close-settings-button =
    .title = Pengaturan tertutup
