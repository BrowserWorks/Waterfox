# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = Tembiapo ñepyrũ ha ñe’ẽñemi

# "Google Play" and "App Store" are both branding and should not be translated

login-app-promo-title = Egueraha ne ñe’ẽñemi opa hendápe
login-app-promo-subtitle = Emboguejy tembipuru’i reigua { -lockwise-brand-name }
login-app-promo-android =
    .alt = Emboguejy Google Play guive
login-app-promo-apple =
    .alt = Emboguejy App Store guive

login-filter =
    .placeholder = Tembiapo ñepyrũ jeheka

create-login-button = Tembiapo ñepyrũ moheñói

fxaccounts-sign-in-text = Egueru umi ne ñe’ẽñemi ne ambue mba’e’okágui
fxaccounts-sign-in-button = Eñemboheraguapy { -sync-brand-short-name }-pe
fxaccounts-avatar-button =
    .title = Eñangareko mba’etére

## The ⋯ menu that is in the top corner of the page

menu =
    .title = Poravorãme jeike
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = Egueru ambue kundahára guive…
about-logins-menu-menuitem-import-from-a-file = Marandurendágui jegueru…
about-logins-menu-menuitem-export-logins = Emba’egueraha tembiapo ñepyrũ…
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] Jeporavorã
       *[other] Jerohoryvéva
    }
about-logins-menu-menuitem-help = Pytyvõ
menu-menuitem-android-app = { -lockwise-brand-short-name } Android peg̃uarã
menu-menuitem-iphone-app = { -lockwise-brand-short-name } iPhone ha iPad peg̃uarã

## Login List

login-list =
    .aria-label = Emoñepyrũ tembiapo jehekaha ndive
login-list-count =
    { $count ->
        [one] { $count } tembiapo ñepyrũ
       *[other] { $count } Tembiapo ñepyrũ
    }
login-list-sort-label-text = Omoĩporã:
login-list-name-option = Téra  (A-Z)
login-list-name-reverse-option = Téra (Z-A)
about-logins-login-list-alerts-option = Kyhyjerã
login-list-last-changed-option = Ñemoambue ipyahuvéva
login-list-last-used-option = Ojepurúva ipahaitépe
login-list-intro-title = Ndojejuhúi jeikeha
login-list-intro-description = Eñongatúvo ñe’ẽñemi { -brand-product-name } ndive, kóva ojehecháta ápe.
about-logins-login-list-empty-search-title = Ndojejuhúi tembiapo ñepyrũ
about-logins-login-list-empty-search-description = Ndaipóri pe ehekáva.
login-list-item-title-new-login = Tembiapo ñepyrũ pyahu
login-list-item-subtitle-new-login = Emoinge nde reraite tembiapo ñepyrũme
login-list-item-subtitle-missing-username = (puruhára hera’ỹva)
about-logins-list-item-breach-icon =
    .title = Ñanduti renda imarãva
about-logins-list-item-vulnerable-password-icon =
    .title = Ñe’ẽñemi ivaikuaáva

## Introduction screen

login-intro-heading = ¿Eheka ne ñe’ẽñemi ñongatupyre? Emboheko { -sync-brand-short-name }.

about-logins-login-intro-heading-logged-out = ¿Eheka tembiapo ñepyrũ ñongatupyre? Emboheko { -sync-brand-short-name } térã emba’egueru.
about-logins-login-intro-heading-logged-in = Ndaipóri tembiapo ñepyrũ mbojuehepyre.
login-intro-description = Eñongatúvo nde jeike { -brand-product-name }-pe ambue mba’e’okápe.
login-intro-instruction-fxa = Emoheñói térã eike nde { -fxaccount-brand-name }-pe mba’e’oka eñongatuhápe eikehague
login-intro-instruction-fxa-settings = Eiporavokuaáke nde jeike { -sync-brand-short-name } ñemoĩporãme
about-logins-intro-instruction-help = Eho <a data-l10n-name="help-link">-pe { -lockwise-brand-short-name } Pytyvõ</a> eñepytyvõve hag̃ua
about-logins-intro-import = Ne rembiapo ñepyrũ oñeñongatúramo ambue kundahárape, ikatu <a data-l10n-name="import-link">ogueru { -lockwise-brand-short-name }pe</a>

about-logins-intro-import2 = Ne rembiapo ñepyrũ oñeñongatu { -brand-product-name }-gui okápe, ikatu <a data-l10n-name="import-browser-link">egueru ambue kundaháragui</a> térã <a data-l10n-name="import-file-link">maranduredágui</a>

## Login

login-item-new-login-title = Tembiapo ñepyrũ pyahu moheñói
login-item-edit-button = Mbosako’i
about-logins-login-item-remove-button = Mboguete
login-item-origin-label = Ñanduti kundaharape
login-item-origin =
    .placeholder = https://www.example.com
login-item-username-label = Puruhára réra
about-logins-login-item-username =
    .placeholder = (puruhára hera’ỹva)
login-item-copy-username-button-text = Monguatia
login-item-copied-username-button-text = Monguatiapyre!
login-item-password-label = Ñe’ẽñemi
login-item-password-reveal-checkbox =
    .aria-label = Ehechauka ñe’ẽñemi
login-item-copy-password-button-text = Monguatia
login-item-copied-password-button-text = Monguatiapyre!
login-item-save-changes-button = Moambue ñongatu
login-item-save-new-button = Ñongatu
login-item-cancel-button = Heja
login-item-time-changed = Moambue ipyahuvéva: { DATETIME($timeChanged, day: "numeric", month: "long", year: "numeric") }
login-item-time-created = Moheñoimbyre: { DATETIME($timeCreated, day: "numeric", month: "long", year: "numeric") }
login-item-time-used = Ojepuru ramovéva: { DATETIME($timeUsed, day: "numeric", month: "long", year: "numeric") }

## OS Authentication dialog

about-logins-os-auth-dialog-caption = { -brand-full-name }

## The macOS strings are preceded by the operating system with "Firefox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.

# This message can be seen when attempting to edit a login in about:logins on Windows.
about-logins-edit-login-os-auth-dialog-message-win = Embosako’ívo tembiapo ñepyrũ, emoĩ nde reraite Windows rembiapo ñepyrũme. Oipytyvõta emo’ãvo ne mba’ete rekorosã.
# This message can be seen when attempting to edit a login in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-edit-login-os-auth-dialog-message-macosx = embosako’i tembiapo ñepyrũ ñongatupyre

# This message can be seen when attempting to reveal a password in about:logins on Windows.
about-logins-reveal-password-os-auth-dialog-message-win = Ehecha hag̃ua ñe’ẽñemi, emoinge nde reraite tembiapo ñepyrũ pegua. Oipytyvõta emo’ãvo ne mba’etekuéra rekorosã.
# This message can be seen when attempting to reveal a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-reveal-password-os-auth-dialog-message-macosx = embosako’i ñe’ẽñemi ñongatupyre

# This message can be seen when attempting to copy a password in about:logins on Windows.
about-logins-copy-password-os-auth-dialog-message-win = Emonguatia hag̃ua ñe’ẽñemi, emoinge nde reraite Windows rembiapo ñepyrũme. Oipytyvõta emo’ãvo ne mba’etekuéra rekorosã.
# This message can be seen when attempting to copy a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-copy-password-os-auth-dialog-message-macosx = embokuatia ñe’ẽñemi ñongatupyre

## Master Password notification

master-password-notification-message = Emoinge ne ñe’ẽñemi ha’evéva ehecha hag̃ua tembiapo ñepyrũ ha ñe’ẽñemi ñongatupyre

# This message can be seen when attempting to export a password in about:logins on Windows.
about-logins-export-password-os-auth-dialog-message-win = Eguerahaukávo ne rembiapo ñepyrũ, emoĩ nde reraite Windows rembiapópe. Oipytyvõta emo’ãvo ne mba’ete rekorosã.
# This message can be seen when attempting to export a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-export-password-os-auth-dialog-message-macosx = erahauka puruhára ha ñe’ẽñemi ñongatupyre

## Primary Password notification

about-logins-primary-password-notification-message = Emoinge ne ñe’ẽñemi ha’evéva ehecha hag̃ua tembiapo ñepyrũ ha ñe’ẽñemi ñongatupyre
master-password-reload-button =
    .label = Tembiapo ñepyrũ
    .accesskey = L

## Password Sync notification

enable-password-sync-notification-message =
    { PLATFORM() ->
        [windows] ¿Eipotápa tembiapo ñepyrũ opaite eipuruhápe { -brand-product-name }? Tereho { -sync-brand-short-name } Jeporavorãme ha embosa’y pe tembiapo ñepyrũ kora jehechajey.
       *[other] ¿Eipotápa tembiapo ñepyrũ opaite eipuruhápe { -brand-product-name }? Tereho { -sync-brand-short-name } Jeporavorãme ha embosa’y pe tembiapo ñepyrũ kora jehechajey.
    }
enable-password-sync-preferences-button =
    .label =
        { PLATFORM() ->
            [windows] Eike { -sync-brand-short-name } Jeporavorãme
           *[other] Eike { -sync-brand-short-name } Oguerohoryvévape
        }
    .accesskey = V
about-logins-enable-password-sync-dont-ask-again-button =
    .label = Anive eporandujey
    .accesskey = D

## Dialogs

confirmation-dialog-cancel-button = Heja
confirmation-dialog-dismiss-button =
    .title = Heja

about-logins-confirm-remove-dialog-title = ¿Emboguete ko tembiapo ñepyrũ?
confirm-delete-dialog-message = Ko tembiapoite ndaikatúi emboguevi.
about-logins-confirm-remove-dialog-confirm-button = Mboguete

about-logins-confirm-export-dialog-title = Emba’egueraha tembiapo ñepyrũ ha ñe’ẽñemi
about-logins-confirm-export-dialog-message = Ñe’ẽñemi oñeñongatúta moñe’ẽrãrõ (techapyrã, BadP@ssw0rd) oimeraẽva ombojurujakuaáva marandurenda guerahaukapyre ikatu ohecha.
about-logins-confirm-export-dialog-confirm-button = Emba’egueraha…

confirm-discard-changes-dialog-title = ¿Emboyke moambue eñongatu’ỹva?
confirm-discard-changes-dialog-message = Opaite ñemoambue oñeñongatu’ỹva oguepáta.
confirm-discard-changes-dialog-confirm-button = Hejarei

## Breach Alert notification

about-logins-breach-alert-title = Ñanduti renda ñembyai
breach-alert-text = Umi ñe’ẽñemi oñembogua térã oñemonda ko ñanduti rendágui hekopyahu rire ne mba’ekuaarã rembiapo ñepyrũ. Emoambue ne ñe’ẽñemi emo’ã hag̃ua ne mba’ete.
about-logins-breach-alert-date = Ko jejapo’ỹ oiko { DATETIME($date, day: "numeric", month: "long", year: "numeric") }
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-breach-alert-link = Eho { $hostname }
about-logins-breach-alert-learn-more-link = Kuaave

## Vulnerable Password notification

about-logins-vulnerable-alert-title = Ñe’ẽñemi ivaikuaáva
about-logins-vulnerable-alert-text2 = Ko ñe’ẽñemi ojepuru ambue mba’etépe ikatúva mba’ekuaarã ombyai. Eipurujey terachaukaha ombyaikuaáva opaite mba’etépe. Emoambue ko ñe’ẽñemi.
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-vulnerable-alert-link = Eho { $hostname }
about-logins-vulnerable-alert-learn-more-link = Kuaave

## Error Messages

# This is an error message that appears when a user attempts to save
# a new login that is identical to an existing saved login.
# Variables:
#   $loginTitle (String) - The title of the website associated with the login.
about-logins-error-message-duplicate-login-with-link = Eikekuaáma { $loginTitle } ko puruhára réra reheve. <a data-l10n-name="duplicate-link">¿Ehosépa pe jeikehápe?</a>

# This is a generic error message.
about-logins-error-message-default = Oiko jejavy eñongatukuévo ñe’ẽñemi.


## Login Export Dialog

# Title of the file picker dialog
about-logins-export-file-picker-title = Emba’egueraha tembiapo ñepyrũ marandurenda
# The default file name shown in the file picker when exporting saved logins.
# This must end in .csv
about-logins-export-file-picker-default-filename = logins.csv
about-logins-export-file-picker-export-button = Mba’egueraha
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-export-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] CSV Kuatiaite
       *[other] CSV Marandurenda
    }

## Login Import Dialog

# Title of the file picker dialog
about-logins-import-file-picker-title = Egueru marandurenda tembiapo ñepyrũgui
about-logins-import-file-picker-import-button = Mba’egueru
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-import-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] CSV Kuatiaite
       *[other] CSV Marandurenda
    }
