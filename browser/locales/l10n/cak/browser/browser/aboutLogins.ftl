# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = Kitikirisaxik molojri'ïl & Ewan taq Tzij

# "Google Play" and "App Store" are both branding and should not be translated

login-app-promo-title = Xab'akuchi' ke'ak'waj ri ewan taq atzij
login-app-promo-subtitle = Tak'ulu' ri sipan { -lockwise-brand-name } chokoy
login-app-promo-android =
    .alt = Tak'ulu' pa Google Play
login-app-promo-apple =
    .alt = Taqasaj pa ri App Store

login-filter =
    .placeholder = Kekanöx Tikirib'äl taq Molojri'ïl

create-login-button = Titz'uk K'ak'a' Tikirib'äl Molojri'ïl

fxaccounts-sign-in-text = Ke'ak'ulu' ewan taq kitzij ru ch'aqa' chik taq okisab'äl
fxaccounts-sign-in-button = Titikirisäx molojri'ïl pa { -sync-brand-short-name }
fxaccounts-avatar-button =
    .title = Tinuk'samajïx rub'i' taqoya'l

## The ⋯ menu that is in the top corner of the page

menu =
    .title = Tijaq k'utsamaj
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = Tijik' pa Jun Chik Okik'amaya'l…
about-logins-menu-menuitem-import-from-a-file = Tijik' pa jun Yakb'äl…
about-logins-menu-menuitem-export-logins = Tik'wäx el Tikirib'äl Molojri'ïl…
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] Taq cha'oj
       *[other] Taq ajowab'äl
    }
about-logins-menu-menuitem-help = To'ïk
menu-menuitem-android-app = { -lockwise-brand-short-name } richin Android
menu-menuitem-iphone-app = { -lockwise-brand-short-name } richin iPhone chuqa' iPad

## Login List

login-list =
    .aria-label = Tikirib'äl taq molojri'ïl nikik'äm ki' rik'in ri nikanöx
login-list-count =
    { $count ->
        [one] { $count } tikirib'äl molojri'ïl
       *[other] { $count } tikirib'äl taq molojri'ïl
    }
login-list-sort-label-text = Tichol chi:
login-list-name-option = B'i'aj (A-Y)
login-list-name-reverse-option = B'i'aj (Z-A)
about-logins-login-list-alerts-option = Retal taq k'ayewal
login-list-last-changed-option = Ruk'isib'äl Jaloj
login-list-last-used-option = Ruk'isib'äl Rokisaxik
login-list-intro-title = Majun tikirib'äl molojri'ïl xilitäj
login-list-intro-description = Toq nayäk jun ewan tzij pa { -brand-product-name }, wawe' xtiq'alajin pe.
about-logins-login-list-empty-search-title = Majun tikirib'äl molojri'ïl xilitäj
about-logins-login-list-empty-search-description = Majun xilitäj achi'el ri nakanoj.
login-list-item-title-new-login = K'ak'a' Tikirib'äl Molojri'ïl
login-list-item-subtitle-new-login = Ke'atz'ib'aj ri taq retamab'al rutikirib'al molojri'ïl
login-list-item-subtitle-missing-username = (majun rub'i' okisanel)
about-logins-list-item-breach-icon =
    .title = Tz'ilan Ajk'amaya'l taq Ruxaq
about-logins-list-item-vulnerable-password-icon =
    .title = Tz'ilanel ewan tzij

## Introduction screen

login-intro-heading = ¿La ye'akanoj rutikirib'al taq amolojri'ïl e'ayakon kan? Tab'ana' runuk'ulem { -sync-brand-short-name }.

about-logins-login-intro-heading-logged-out = ¿La ye'akanoj rutikirib'al taq amolojri'ïl e'ayakon kan? Tab'ana' runuk'ulem { -sync-brand-short-name } o Tijik' Wachinel.
about-logins-login-intro-heading-logged-in = Majun ximon taq tikirib'äl molojri'ïl xe'ilitäj.
login-intro-description = We xe'ayäk ri rutikirib'al amolojri'ïl pa { -brand-product-name } pa jun chik wi okisab'äl, wawe' nik'ut pe richin nak'ul wawe' chuqa':
login-intro-instruction-fxa = Tatz'uku' o tatikirisaj molojri'ïl pa { -fxaccount-brand-name } chupam ri okisab'äl, akuchi' e yakäl ri tikirib'äl amolojri'ïl
login-intro-instruction-fxa-settings = Tatz'eta' chi xacha' ri k'ojlib'äl richin kitikitib'al molojri'ïl pa ri runuk'ulem { -sync-brand-short-name }.
about-logins-intro-instruction-help = Tatz'eta' <a data-l10n-name="help-link">{ -lockwise-brand-short-name } Tob'äl</a> richin ch'aqa' chik to'ïk.
about-logins-intro-import = We ri rutikirib'al amolojri'ïl yakon pa jun chik okik'amaya'l, yatikïr <a data-l10n-name="import-link">ye'ajïk' pa { -lockwise-brand-short-name }</a>

about-logins-intro-import2 = We ri taq awujil man yek'oje' ta chupam { -brand-product-name } yatikïr <a data-l10n-name="import-browser-link">ye'ajïk pe chupam jun chik okik'amaya'l</a> o <a data-l10n-name="import-file-link">chupam jun yakb'äl</a>

## Login

login-item-new-login-title = Titz'uk K'ak'a' Tikirib'äl Molojri'ïl
login-item-edit-button = Nuk'b'äl
about-logins-login-item-remove-button = Tiyuj
login-item-origin-label = Ajk'amaya'l Ochochib'äl
login-item-origin =
    .placeholder = https://www.example.com
login-item-username-label = Rub'i' okisanel
about-logins-login-item-username =
    .placeholder = (majun rub'i' okisanel)
login-item-copy-username-button-text = Tiwachib'ëx
login-item-copied-username-button-text = ¡Xwachib'ëx!
login-item-password-label = Ewan tzij
login-item-password-reveal-checkbox =
    .aria-label = Tik'ut ewan tzij
login-item-copy-password-button-text = Tiwachib'ëx
login-item-copied-password-button-text = ¡Xwachib'ëx!
login-item-save-changes-button = Keyak Jaloj
login-item-save-new-button = Tiyak
login-item-cancel-button = Tiq'at
login-item-time-changed = Ruk'isib'äl jaloj: { DATETIME($timeChanged, day: "numeric", month: "long", year: "numeric") }
login-item-time-created = Xtz'uk: { DATETIME($timeCreated, day: "numeric", month: "long", year: "numeric") }
login-item-time-used = Ruk'isib'äl rokisaxik: { DATETIME($timeUsed, day: "numeric", month: "long", year: "numeric") }

## OS Authentication dialog

about-logins-os-auth-dialog-caption = { -brand-full-name }

## The macOS strings are preceded by the operating system with "Firefox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.

# This message can be seen when attempting to edit a login in about:logins on Windows.
about-logins-edit-login-os-auth-dialog-message-win = Richin nanük' ri rutikirib'al amolojri'ïl, tatz'ib'aj ri ruwujil rutikirisaxik molojri'ïl richin Windows. Re re' nuto' richin nuchajij rujikomal ri rub'i' ataqoya'l.
# This message can be seen when attempting to edit a login in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-edit-login-os-auth-dialog-message-macosx = tinuk' ri yakon rutikirib'al molojri'ïl

# This message can be seen when attempting to reveal a password in about:logins on Windows.
about-logins-reveal-password-os-auth-dialog-message-win = Richin natz'ët ri ewan atzij, tatz'ib'aj ri ruwujil rutikirisaxik molojri'ïl richin Windows. Re re' nuto' richin nuchajij rujikomal ri rub'i' ataqoya'l.
# This message can be seen when attempting to reveal a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-reveal-password-os-auth-dialog-message-macosx = tik'ut ri yakon ewan tzij

# This message can be seen when attempting to copy a password in about:logins on Windows.
about-logins-copy-password-os-auth-dialog-message-win = Richin nawachib'ej ri ewan atzij, tatz'ib'aj ri ruwujil rutikirisaxik molojri'ïl richin Windows. Re re' nuto' richin nuchajij rujikomal ri rub'i' ataqoya'l.
# This message can be seen when attempting to copy a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-copy-password-os-auth-dialog-message-macosx = tiwachib'ëx ri yakon ewan tzij

## Master Password notification

master-password-notification-message = Tatz'ib'aj ri ajtij ewan atzij richin ye'atz'ët ri rutikirib'al taq amolojri'ïl & ri ewan taq tzij

# This message can be seen when attempting to export a password in about:logins on Windows.
about-logins-export-password-os-auth-dialog-message-win = Richin ye'ak'waj ri rutikirib'al taq amolojri'ïl, tatz'ib'aj ri ruwujil rutikirisaxik molojri'ïl richin Windows. Re re' nuto' richin nuchajij rujikomal ri rub'i' ataqoya'l.
# This message can be seen when attempting to export a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-export-password-os-auth-dialog-message-macosx = kek'wäx el yakon tikirisaxik taq molojri'ïl chuqa' ewan taq tzij

## Primary Password notification

about-logins-primary-password-notification-message = Tatz'ib'aj ri Nab'ey Ewan Atzij richin ye'atz'ët ri rutikirib'al taq amolojri'ïl & ri ewan taq tzij
master-password-reload-button =
    .label = Titikirisäx molojri'ïl
    .accesskey = m

## Password Sync notification

enable-password-sync-notification-message =
    { PLATFORM() ->
        [windows] ¿La nawajo' ye'atz'ët rutikirib'al taq amolojri'ïl xab'akuchi' nawokisaj { -brand-product-name } { -brand-product-name }? Tajaqa' Taq Rucha'oj { -sync-brand-short-name } richin nacha' ri peraj rujikib'axik rutikirib'al taq molojri'ïl.
       *[other] ¿La nawajo' ye'atz'ët rutikirib'al taq amolojri'ïl xab'akuchi' nawokisaj { -brand-product-name } { -brand-product-name }? Tajaqa' Taq Rajowab'al{ -sync-brand-short-name } richin nacha' ri peraj rujikib'axik rutikirib'al taq molojri'ïl.
    }
enable-password-sync-preferences-button =
    .label =
        { PLATFORM() ->
            [windows] Titz'et { -sync-brand-short-name } Taq Cha'oj
           *[other] Titz'et { -sync-brand-short-name } Taq Ajowab'äl
        }
    .accesskey = t
about-logins-enable-password-sync-dont-ask-again-button =
    .label = Mani nik'utüx chik pe chwe
    .accesskey = M

## Dialogs

confirmation-dialog-cancel-button = Tiq'at
confirmation-dialog-dismiss-button =
    .title = Tiq'at

about-logins-confirm-remove-dialog-title = ¿La niyuj el rutikirib'al re moloj re'?
confirm-delete-dialog-message = Man tikirel ta nitzolïx re b'anïk.
about-logins-confirm-remove-dialog-confirm-button = Tiyuj

about-logins-confirm-export-dialog-title = Kek'wäx el kitikirisaxik molojri'ïl chuqa' ewan taq tzij
about-logins-confirm-export-dialog-message = Xkeyak ri ewan taq atzij achi'el tz'etel tz'ib'anïk (achi'el, BadP@ssw0rd) richin chi xab'achike xtijaqon ri yakb'äl k'wa'an, nitikïr nutz'ët.
about-logins-confirm-export-dialog-confirm-button = Tik'wäx el…

confirm-discard-changes-dialog-title = ¿La yech'aqïx ri taq jaloj man eyakon ta?
confirm-discard-changes-dialog-message = Xkesach ronojel ri jaloj man eyakon ta.
confirm-discard-changes-dialog-confirm-button = Tich'aqïx

## Breach Alert notification

about-logins-breach-alert-title = Rutz'ilanem Ajk'amaya'l Ruxaq
breach-alert-text = Xechayüx o xe'eleq'äx ri ewan taq tzij pa re ajk'amaya'l ruxaq re' toq xek'ex ri taq rutzij rutikirib'al molojri'ïl ri ruk'isib'äl q'ij. Tajala' ri ewan atzij richin nachajij ri rub'i' ataqoya'l.
about-logins-breach-alert-date = Re tz'ilanem re' xk'ulwachitäj pa { DATETIME($date, day: "numeric", month: "long", year: "numeric") }
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-breach-alert-link = Tib'e pa { $hostname }
about-logins-breach-alert-learn-more-link = Tetamäx ch'aqa' chik

## Vulnerable Password notification

about-logins-vulnerable-alert-title = Tz'ilanel Ewan Tzij
about-logins-vulnerable-alert-text2 = Re ewan tzij re' okisan pa jun chik rub'i' taqoya'l, ri xuk'ulwachij tz'ilanem. We ye'okisäx chik ri taq wujil xkekitz'ila' ronojel ri rub'i' taqoya'l. Tajala' re ewan tzij re'.
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-vulnerable-alert-link = Tib'e pa { $hostname }
about-logins-vulnerable-alert-learn-more-link = Tetamäx ch'aqa' chik

## Error Messages

# This is an error message that appears when a user attempts to save
# a new login that is identical to an existing saved login.
# Variables:
#   $loginTitle (String) - The title of the website associated with the login.
about-logins-error-message-duplicate-login-with-link = K'o chik jun okib'äl richin { $loginTitle } rik'in ri rub'i' winäq ri'. <a data-l10n-name="duplicate-link">¿La nawajo' yab'e pa ri okib'äl ri'?</a>

# This is a generic error message.
about-logins-error-message-default = Xk'ulwachitäj jun sachoj toq niyak re ewan tzij.


## Login Export Dialog

# Title of the file picker dialog
about-logins-export-file-picker-title = Tik'wäx el Ruyakb'al Tikirib'äl Molojri'ïl
# The default file name shown in the file picker when exporting saved logins.
# This must end in .csv
about-logins-export-file-picker-default-filename = logins.csv
about-logins-export-file-picker-export-button = Tik'wäx el
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-export-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] Wuj CSV
       *[other] Yakb'äl CSV
    }

## Login Import Dialog

# Title of the file picker dialog
about-logins-import-file-picker-title = Tijik' Ruyakb'al Tikirib'äl Molojri'ïl
about-logins-import-file-picker-import-button = Tijik'
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-import-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] CSV Wuj
       *[other] CSV Yakb'äl
    }
