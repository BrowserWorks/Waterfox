# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = Clàraidhean a-steach ⁊ faclan-faire

# "Google Play" and "App Store" are both branding and should not be translated

login-app-promo-title = Thoir leat na faclan-faire agad ge be càit an dèid thu
login-app-promo-subtitle = Faigh aplacaid { -lockwise-brand-name } an-asgaidh
login-app-promo-android =
    .alt = Faigh e air Google Play
login-app-promo-apple =
    .alt = Luchdaich a-nuas e on App Store

login-filter =
    .placeholder = Lorg sna clàraidhean a-steach

create-login-button = Cruthaich clàradh a-steach ùr

fxaccounts-sign-in-text = Faigh cothrom air na faclan-faire agad air uidheaman eile
fxaccounts-sign-in-button = Clàraich a-steach gu { -sync-brand-short-name }
fxaccounts-avatar-button =
    .title = Stiùirich an cunntas

## The ⋯ menu that is in the top corner of the page

menu =
    .title = Fosgail an clàr-taice
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = Ion-phortaich o bhrabhsair eile…
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] Roghainnean
       *[other] Roghainnean
    }
about-logins-menu-menuitem-help = Cobhair
menu-menuitem-android-app = { -lockwise-brand-short-name } airson Android
menu-menuitem-iphone-app = { -lockwise-brand-short-name } airson iPhone agus iPad

## Login List

login-list =
    .aria-label = Clàraidhean a-steach a fhreagras air na lorg thu
login-list-count =
    { $count ->
        [one] { $count } chlàradh a-steach
        [two] { $count } chlàradh a-steach
        [few] { $count } clàraidhean a-steach
       *[other] { $count } clàradh a-steach
    }
login-list-sort-label-text = Seòrsaich a-rèir:
login-list-name-option = Ainm (A-Z)
login-list-name-reverse-option = Ainm (Z-A)
login-list-last-changed-option = Atharrachadh mu dheireadh
login-list-last-used-option = Cleachdadh mu dheireadh
login-list-intro-title = Cha deach clàradh a-steach a lorg
login-list-intro-description = Nuair a shàbhaileas tu facal-faire ann an { -brand-product-name }, nochdaidh e an-seo.
about-logins-login-list-empty-search-title = Cha deach clàradh a-steach a lorg
about-logins-login-list-empty-search-description = Chan eil toradh ann a tha a’ freagairt ris na lorg thu.
login-list-item-title-new-login = Clàradh a-steach ùr
login-list-item-subtitle-new-login = Cuir a-steach an t-ainm is facal-faire agad
login-list-item-subtitle-missing-username = (gun ainm-cleachdaiche)
about-logins-list-item-breach-icon =
    .title = Làrach-lìn air an deach briseadh a-steach

## Introduction screen

login-intro-heading = A’ lorg nan clàraidhean a-steach a shàbhail thu? Suidhich { -sync-brand-short-name }.

about-logins-login-intro-heading-logged-in = Cha deach clàradh a-steach sioncronaichte a lorg.
login-intro-description = Ma shàbhail thu na clàraidhean a-steach agad ann am { -brand-product-name } air uidheam eile, seo mar a gheibh thu greim orra an-seo:
login-intro-instruction-fxa = Cruthaich { -fxaccount-brand-name } no clàraich a-steach dha air an uidheam far an deach na clàraidhean a-steach agad a shàbhaladh
login-intro-instruction-fxa-settings = Dèan cinnteach gu bheil cromag ann am bogsa nan clàraidhean a-steach ann an roghainnean { -sync-brand-short-name }
about-logins-intro-instruction-help = Tadhail air <a data-l10n-name="help-link">Taic { -lockwise-brand-short-name }</a> airson cobhair
about-logins-intro-import = Ma shàbhail thu na clàraidhean a-steach agad ann am brabhsair eile, ’s urrainn dhut <a data-l10n-name="import-link">an ion-phortadh gu { -lockwise-brand-short-name }</a>

## Login

login-item-new-login-title = Cruthaich clàradh a-steach ùr
login-item-edit-button = Deasaich
about-logins-login-item-remove-button = Thoir air falbh
login-item-origin-label = Seòladh na làraich-lìn
login-item-origin =
    .placeholder = https://www.example.com
login-item-username-label = Ainm-cleachdaiche
about-logins-login-item-username =
    .placeholder = (gun ainm-cleachdaiche)
login-item-copy-username-button-text = Lethbhreac
login-item-copied-username-button-text = Lethbhreac air a dhèanamh!
login-item-password-label = Facal-faire
login-item-password-reveal-checkbox =
    .aria-label = Seall am facal-faire
login-item-copy-password-button-text = Lethbhreac
login-item-copied-password-button-text = Lethbhreac air a dhèanamh!
login-item-save-changes-button = Sàbhail na h-atharraichean
login-item-save-new-button = Sàbhail
login-item-cancel-button = Sguir dheth
login-item-time-changed = An t-atharrachadh mu dheireadh: { DATETIME($timeChanged, day: "numeric", month: "long", year: "numeric") }
login-item-time-created = Air a chruthachadh: { DATETIME($timeCreated, day: "numeric", month: "long", year: "numeric") }
login-item-time-used = Cleachdadh mu dheireadh: { DATETIME($timeUsed, day: "numeric", month: "long", year: "numeric") }

## OS Authentication dialog

about-logins-os-auth-dialog-caption = { -brand-full-name }

## The macOS strings are preceded by the operating system with "Firefox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.

# This message can be seen by attempting to edit a login in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-edit-login-os-auth-dialog-message-macosx = an clàradh a-steach a shàbhail thu a dheasachadh

# This message can be seen by attempting to reveal a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-reveal-password-os-auth-dialog-message-macosx = am facal-faire a shàbhail thu a nochdadh

# This message can be seen by attempting to copy a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-copy-password-os-auth-dialog-message-macosx = lethbhreac a dhèanamh dhen fhacal-fhaire a shàbhail thu

## Master Password notification

master-password-notification-message = Cuir a-steach am facal-faire maighstir agad a dh’fhaicinn nan clàraidhean a-steach ⁊ faclan-faire a shàbhail thu

## Primary Password notification

master-password-reload-button =
    .label = Clàraich a-steach
    .accesskey = l

## Password Sync notification

enable-password-sync-notification-message =
    { PLATFORM() ->
        [windows] A bheil thu ag iarraidh nan clàraidhean a-steach àite sam bith a chleachdas tu { -brand-product-name }? Tadhail air roghainnean { -sync-brand-short-name } is cuir cromag sa bhogsa “Clàraidhean a-steach”.
       *[other] A bheil thu ag iarraidh nan clàraidhean a-steach àite sam bith a chleachdas tu { -brand-product-name }? Tadhail air roghainnean { -sync-brand-short-name } is cuir cromag sa bhogsa “Clàraidhean a-steach”.
    }
enable-password-sync-preferences-button =
    .label =
        { PLATFORM() ->
            [windows] Tadhail air roghainnean { -sync-brand-short-name }
           *[other] Tadhail air roghainnean { -sync-brand-short-name }
        }
    .accesskey = T
about-logins-enable-password-sync-dont-ask-again-button =
    .label = Na faighnich dhìom a-rithist
    .accesskey = N

## Dialogs

confirmation-dialog-cancel-button = Sguir dheth
confirmation-dialog-dismiss-button =
    .title = Sguir dheth

about-logins-confirm-remove-dialog-title = A bheil thu airson an clàradh a-steach seo a thoirt air falbh?
confirm-delete-dialog-message = Cha ghabh seo a neo-dhèanamh.
about-logins-confirm-remove-dialog-confirm-button = Thoir air falbh

confirm-discard-changes-dialog-title = A bheil thu airson na h-atharraichean gun sàbhaladh a thilgeil air falbh?
confirm-discard-changes-dialog-message = Thèid gach atharrachadh gun sàbhaladh air chall.
confirm-discard-changes-dialog-confirm-button = Tilg air falbh

## Breach Alert notification

breach-alert-text = Chaidh faclan-faire a ghoid air an làrach-lìn seo on a dh’ùraich thu an clàradh a-steach agad turas mu dheireadh. Atharraich am facal-faire agad a dhìon a’ chunntais agad.

## Vulnerable Password notification

## Error Messages

# This is an error message that appears when a user attempts to save
# a new login that is identical to an existing saved login.
# Variables:
#   $loginTitle (String) - The title of the website associated with the login.
about-logins-error-message-duplicate-login-with-link = Tha innteart airson { $loginTitle } leis an ainm-chleachdaiche seo mu thràth. <a data-l10n-name="duplicate-link">A bheil thu airson tadhal air an innteart làithreach?</a>

# This is a generic error message.
about-logins-error-message-default = Thachair mearachd nuair a dh’fheuch sinn ris am facal-faire seo a shàbhaladh.


## Login Export Dialog

## Login Import Dialog

