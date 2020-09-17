# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = Ceŋorɗe e pinle

# "Google Play" and "App Store" are both branding and should not be translated

login-app-promo-title = Nawor ceŋorɗe e pinle maa kala nokku.
login-app-promo-subtitle = Heɓ jaaɓnirgal ngal yoɓetaake { -lockwise-brand-name }
login-app-promo-android =
    .alt = Heɓ ɗum e Google Play
login-app-promo-apple =
    .alt = Aawto to App Store

login-filter =
    .placeholder = Yiylo Ceŋorɗe

create-login-button = Sos Seŋorde Hesere

fxaccounts-sign-in-text = Heɓ pinle maa e kaɓirɗe maa goɗɗe
fxaccounts-sign-in-button = Seŋo to { -sync-brand-short-name }
fxaccounts-avatar-button =
    .title = Yiil konte

## The ⋯ menu that is in the top corner of the page

menu =
    .title = Uddit cuɓirgol
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = Jiggo Keɓe iwde e Wanngorde Woɗnde…
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] Cuɓe
       *[other] Cuɓoraaɗe
    }
about-logins-menu-menuitem-help = Ballal
menu-menuitem-android-app = { -lockwise-brand-short-name } mo Android
menu-menuitem-iphone-app = { -lockwise-brand-short-name } mo iPhone kam e iPad

## Login List

login-list =
    .aria-label = Ceŋorɗe jahdooje e ɗaɓɓitannde njiilaw
login-list-count =
    { $count ->
        [one] { $count } Seŋorde
       *[other] { $count } Ceŋorɗe
    }
login-list-sort-label-text = Laworo:
login-list-name-option = Innde (A-Z)
login-list-name-reverse-option = Innde (A-Z)
about-logins-login-list-alerts-option = Jeertine
login-list-last-changed-option = Waylo sakkitto
login-list-last-used-option = Kuutarogol cakkitiingol.
login-list-intro-title = Alaa ceŋorɗe njiytaa
login-list-intro-description = So a danndi finnde e nder { -brand-product-name }, ma nde feeñ ɗoo.
about-logins-login-list-empty-search-title = Alaa ceŋorɗe njiytaa
about-logins-login-list-empty-search-description = Hay njeñtudi wootiri tolnondiraani e niilaw maa.
login-list-item-title-new-login = Seŋorde hesere
login-list-item-subtitle-new-login = Naatnu humpito
login-list-item-subtitle-missing-username = [alaa innde kuutoro]
about-logins-list-item-breach-icon =
    .title = Loowe geese dañɗe ciigol keɓe
about-logins-list-item-vulnerable-password-icon =
    .title = Finnde yaafnde

## Introduction screen

login-intro-heading = Njiilotoɗaa ko ceŋorɗe maa danndaaɗe? Teelto { -sync-brand-short-name }.

about-logins-login-intro-heading-logged-in = Alaa ceŋorɗe jahdinaaɗe njiytaa.
login-intro-description = So a danndii ceŋorɗe maa e { -brand-product-name } e kaɓirgal goɗngal, ko nii keɓirtaaɗe ɗoo:
login-intro-instruction-fxa = Sos walla seŋo e { -fxaccount-brand-name } maa e kaɓirgal ngal ɗo ceŋorɗe maa ndanndaa
login-intro-instruction-fxa-settings = Yanane a suɓiima boyet ceŋorɗe ɗee nder teelte { -sync-brand-short-name }
about-logins-intro-instruction-help = Ngam heɓde ballal goɗngal, yillo <a data-l10n-name="help-link">{ -lockwise-brand-short-name } Wallitorde</a>
about-logins-intro-import = So ceŋorɗe maa ndanndaama e wanngorde woɗnde, aɗa waawi  <a data-l10n-name="import-link">jiggaade-ɗe nder { -lockwise-brand-short-name }</a>

## Login

login-item-new-login-title = Sos Seŋorde Hesere
login-item-edit-button = Taƴto
about-logins-login-item-remove-button = Momtu
login-item-origin-label = Ñiiɓirde lowre geese
login-item-origin =
    .placeholder = https://www.example.com
login-item-username-label = Innde kuutoro
about-logins-login-item-username =
    .placeholder = [alaa innde kuutoro]
login-item-copy-username-button-text = Natto
login-item-copied-username-button-text = Nattaama!
login-item-password-label = Finnde
login-item-password-reveal-checkbox =
    .aria-label = Hollu finnde
login-item-copy-password-button-text = Natto
login-item-copied-password-button-text = Nattaama!
login-item-save-changes-button = Danndu bayle
login-item-save-new-button = Danndu
login-item-cancel-button = Haaytu
login-item-time-changed = Sakkitii wayleede: { DATETIME($timeChanged, day: "numeric", month: "long", year: "numeric") }
login-item-time-created = Sosaa: { DATETIME($timeCreated, day: "numeric", month: "long", year: "numeric") }
login-item-time-used = Sakkitii huutoreede: { DATETIME($timeUsed, day: "numeric", month: "long", year: "numeric") }

## OS Authentication dialog

about-logins-os-auth-dialog-caption = { -brand-full-name }

## The macOS strings are preceded by the operating system with "Firefox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.

# This message can be seen when attempting to edit a login in about:logins on Windows.
about-logins-edit-login-os-auth-dialog-message-win = Ngam taƴtaade seŋorde maa, naatnu humpito seŋorde maa Windows. Ɗuum ina walla reende kisal konte maa.
# This message can be seen when attempting to edit a login in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-edit-login-os-auth-dialog-message-macosx = Taƴto seŋorde danndaande ndee

# This message can be seen when attempting to reveal a password in about:logins on Windows.
about-logins-reveal-password-os-auth-dialog-message-win = Ngam yiyde finnde maa, naatnu humpito seŋorde maa Windows. Ɗuum ina walla reende kisal konte maa.
# This message can be seen when attempting to reveal a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-reveal-password-os-auth-dialog-message-macosx = Saaktu finnde danndaande ndee

# This message can be seen when attempting to copy a password in about:logins on Windows.
about-logins-copy-password-os-auth-dialog-message-win = Ngam nattaade finnde maa, naatnu humpito seŋorde maa Windows. Ɗuum ina walla reende kisal konte maa.
# This message can be seen when attempting to copy a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-copy-password-os-auth-dialog-message-macosx = Natto finnde danndaande ndee

## Master Password notification

master-password-notification-message = Tiiɗno naatnu finnde maa dowrowre ngam yiyde ceŋorɗe danndaaɗe & pinle

## Primary Password notification

master-password-reload-button =
    .label = Seŋo
    .accesskey = S

## Password Sync notification

enable-password-sync-notification-message =
    { PLATFORM() ->
        [windows] Aɗa yiɗi ceŋoɗe maa kala ɗo kuutoriɗaa { -brand-product-name }? Yah to cuɓe { -sync-brand-short-name } e labo boyet ceŋorɗe ɗee.
       *[other] Aɗa yiɗi ceŋoɗe maa kala ɗo kuutoriɗaa { -brand-product-name }? Yah to cuɓoraaɗe { -sync-brand-short-name } e labo boyet ceŋorɗe ɗee.
    }
enable-password-sync-preferences-button =
    .label =
        { PLATFORM() ->
            [windows] Yillo cuɓoraaɗe { -sync-brand-short-name }
           *[other] Y
        }
    .accesskey = Y
about-logins-enable-password-sync-dont-ask-again-button =
    .label = Hoto naamnito-mi goɗngol
    .accesskey = H

## Dialogs

confirmation-dialog-cancel-button = Haaytu
confirmation-dialog-dismiss-button =
    .title = Haaytu

about-logins-confirm-remove-dialog-title = Momtu ndee seŋorde?
confirm-delete-dialog-message = Ngal baɗal waawaa firteede.
about-logins-confirm-remove-dialog-confirm-button = Ittu

confirm-discard-changes-dialog-title = Faalkisaade bayle ɗe ndanndaaka?
confirm-discard-changes-dialog-message = Bayle ɗe ndanndaaka fof ko baasateeɗe.
confirm-discard-changes-dialog-confirm-button = Woppu

## Breach Alert notification

about-logins-breach-alert-title = Ciigol keɓe lowre geese
breach-alert-text = Pinle maa ciyiino walla ngujjanooma e ndee lowre geese gila nde cakkitiɗaa hesɗitinde silloor seŋorde maa. Waylu finnde maa nam reende kontemaa.
about-logins-breach-alert-date = Ngol cigol keɓe waɗi ko { DATETIME($date, day: "numeric", month: "long", year: "numeric") }
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-breach-alert-link = Yah to { $hostname }
about-logins-breach-alert-learn-more-link = Ɓeydu humpito

## Vulnerable Password notification

about-logins-vulnerable-alert-title = Finnde yaafnde
about-logins-vulnerable-alert-text2 = Ndee finnde huutoranooma e konte goɗɗe tuumaaɗe jeyeede e ciigol keɓe. Kuutorogol humpito kadi ina waɗa konte maa fof e caɗeele. Waylu ndee finnde.
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-vulnerable-alert-link = Yah to { $hostname }
about-logins-vulnerable-alert-learn-more-link = Ɓeydu humpito

## Error Messages

# This is an error message that appears when a user attempts to save
# a new login that is identical to an existing saved login.
# Variables:
#   $loginTitle (String) - The title of the website associated with the login.
about-logins-error-message-duplicate-login-with-link = Naatol ngam { $loginTitle } e ndee innde kuutoro ina woodi kisa.  <a data-l10n-name="duplicate-link"> Yah to naatol goodngol ngol?</a>

# This is a generic error message.
about-logins-error-message-default = Juumre waɗii tuma etagol danndude ndee finnde.


## Login Export Dialog

## Login Import Dialog

