# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = Bejelentkezések és jelszavak

# "Google Play" and "App Store" are both branding and should not be translated

login-app-promo-title = Vigye magával a jelszavait bárhová
login-app-promo-subtitle = Szerezze be az ingyenes { -lockwise-brand-name } alkalmazást
login-app-promo-android =
    .alt = Szerezze be a Google Play-en
login-app-promo-apple =
    .alt = Töltse le az App Store-ból

login-filter =
    .placeholder = Bejelentkezések keresése

create-login-button = Új bejelentkezés létrehozása

fxaccounts-sign-in-text = Érje el jelszavait a többi eszközén is
fxaccounts-sign-in-button = Jelentkezzen be a { -sync-brand-short-name }be
fxaccounts-avatar-button =
    .title = Fiók kezelése

## The ⋯ menu that is in the top corner of the page

menu =
    .title = Menü megnyitása
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = Importálás egy másik böngészőből…
about-logins-menu-menuitem-import-from-a-file = Importálás fájlból…
about-logins-menu-menuitem-export-logins = Bejelentkezések exportálása…
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] Beállítások
       *[other] Beállítások
    }
about-logins-menu-menuitem-help = Súgó
menu-menuitem-android-app = { -lockwise-brand-short-name } Androidra
menu-menuitem-iphone-app = { -lockwise-brand-short-name } iPhone és iPad készülékekhez

## Login List

login-list =
    .aria-label = A keresésnek megfelelő bejelentkezések
login-list-count =
    { $count ->
        [one] { $count } bejelentkezés
       *[other] { $count } bejelentkezés
    }
login-list-sort-label-text = Rendezés:
login-list-name-option = Név (A-Z)
login-list-name-reverse-option = Név (Z-A)
about-logins-login-list-alerts-option = Riasztások
login-list-last-changed-option = Legutóbbi módosítás
login-list-last-used-option = Legutóbbi használat
login-list-intro-title = Nincsenek bejelentkezések
login-list-intro-description = Ha elment egy jelszót a { -brand-product-name }ban, akkor az itt fog megjelenni.
about-logins-login-list-empty-search-title = Nincsenek bejelentkezések
about-logins-login-list-empty-search-description = Nincs találat, amely megfelel a keresésnek.
login-list-item-title-new-login = Új bejelentkezés
login-list-item-subtitle-new-login = Adja meg a bejelentkezési adatait
login-list-item-subtitle-missing-username = (nincs felhasználónév)
about-logins-list-item-breach-icon =
    .title = Adatsértésben érintett weboldal
about-logins-list-item-vulnerable-password-icon =
    .title = Sebezhető jelszó

## Introduction screen

login-intro-heading = A mentett bejelentkezéseit keresi? Állítsa be a { -sync-brand-short-name }-t.

about-logins-login-intro-heading-logged-out = A mentett bejelentkezéseit keresi? Állítsa be a { -sync-brand-short-name }-et vagy importálja őket.
about-logins-login-intro-heading-logged-in = Nem található szinkronizált bejelentkezés.
login-intro-description = Ha egy másik eszközön mentette a bejelentkezéseit a { -brand-product-name }ban, akkor így érheti el őket itt:
login-intro-instruction-fxa = Hozzon létre egyet, vagy jelentkezzen be a { -fxaccount-brand-name }jába azon az eszközön, amelyen a bejelentkezéseit menti
login-intro-instruction-fxa-settings = Győződjön meg róla, hogy bejelölte a Bejelentkezések választómezőt a { -sync-brand-short-name } beállításokban
about-logins-intro-instruction-help = További segítéségért keresse fel a <a data-l10n-name="help-link">{ -lockwise-brand-short-name } támogatást</a>
about-logins-intro-import = Ha bejelentkezéseit egy másik böngészőben mentette el, <a data-l10n-name="import-link">importálhatja azokat a { -lockwise-brand-short-name }-ba</a>

about-logins-intro-import2 = Ha a bejelentkezéseit a { -brand-product-name }on kívül mentette, akkor <a data-l10n-name="import-browser-link">importálhatja őket egy másik böngészőből</a> vagy <a data-l10n-name="import-file-link">egy fájlból</a>

## Login

login-item-new-login-title = Új bejelentkezés létrehozása
login-item-edit-button = Szerkesztés
about-logins-login-item-remove-button = Eltávolítás
login-item-origin-label = Honlap címe
login-item-origin =
    .placeholder = https://www.example.com
login-item-username-label = Felhasználónév
about-logins-login-item-username =
    .placeholder = (nincs felhasználónév)
login-item-copy-username-button-text = Másolás
login-item-copied-username-button-text = Másolva!
login-item-password-label = Jelszó
login-item-password-reveal-checkbox =
    .aria-label = Jelszó megjelenítése
login-item-copy-password-button-text = Másolás
login-item-copied-password-button-text = Másolva!
login-item-save-changes-button = Változások mentése
login-item-save-new-button = Mentés
login-item-cancel-button = Mégse
login-item-time-changed = Legutóbb módosítva: { DATETIME($timeChanged, day: "numeric", month: "long", year: "numeric") }
login-item-time-created = Létrehozva: { DATETIME($timeCreated, day: "numeric", month: "long", year: "numeric") }
login-item-time-used = Legutóbb használva: { DATETIME($timeUsed, day: "numeric", month: "long", year: "numeric") }

## OS Authentication dialog

about-logins-os-auth-dialog-caption = { -brand-full-name }

## The macOS strings are preceded by the operating system with "Firefox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.

# This message can be seen when attempting to edit a login in about:logins on Windows.
about-logins-edit-login-os-auth-dialog-message-win = A bejelentkezés szerkesztéséhez írja be a Windows bejelentkezési adatait. Ez elősegíti a fiókja biztonságának védelmét.
# This message can be seen when attempting to edit a login in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-edit-login-os-auth-dialog-message-macosx = szerkessze a mentett bejelentkezést

# This message can be seen when attempting to reveal a password in about:logins on Windows.
about-logins-reveal-password-os-auth-dialog-message-win = A jelszava megtekintéséhez írja be a Windows bejelentkezési adatait. Ez elősegíti a fiókja biztonságának védelmét.
# This message can be seen when attempting to reveal a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-reveal-password-os-auth-dialog-message-macosx = felfedje a mentett jelszót

# This message can be seen when attempting to copy a password in about:logins on Windows.
about-logins-copy-password-os-auth-dialog-message-win = A jelszava másolásához írja be a Windows bejelentkezési adatait. Ez elősegíti a fiókja biztonságának védelmét.
# This message can be seen when attempting to copy a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-copy-password-os-auth-dialog-message-macosx = másolja a mentett jelszót

## Master Password notification

master-password-notification-message = Adja meg a mesterjelszavát a mentett bejelentkezések és jelszavak megtekintéséhez

# This message can be seen when attempting to export a password in about:logins on Windows.
about-logins-export-password-os-auth-dialog-message-win = A bejelentkezés exportálásához írja be a Windows bejelentkezési adatait. Ez elősegíti a fiókja biztonságának védelmét.
# This message can be seen when attempting to export a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-export-password-os-auth-dialog-message-macosx = mentett bejelentkezések és jelszavak exportálása

## Primary Password notification

about-logins-primary-password-notification-message = Adja meg az elsődleges jelszavát a mentett bejelentkezések és jelszavak megtekintéséhez
master-password-reload-button =
    .label = Bejelentkezés
    .accesskey = B

## Password Sync notification

enable-password-sync-notification-message =
    { PLATFORM() ->
        [windows] Mindenhol szeretne hozzáférni a bejelentkezéseihez, ahol a { -brand-product-name }ot használja? Ugorjon a { -sync-brand-short-name } beállításokhoz és jelölje be a Bejelentkezések választógombot.
       *[other] Mindenhol szeretne hozzáférni a bejelentkezéseihez, ahol a { -brand-product-name }ot használja? Ugorjon a { -sync-brand-short-name } beállításokhoz és jelölje be a Bejelentkezések választógombot.
    }
enable-password-sync-preferences-button =
    .label =
        { PLATFORM() ->
            [windows] { -sync-brand-short-name } beállítások megtekintése
           *[other] { -sync-brand-short-name } beállítások megtekintése
        }
    .accesskey = m
about-logins-enable-password-sync-dont-ask-again-button =
    .label = Ne kérdezze meg többet
    .accesskey = N

## Dialogs

confirmation-dialog-cancel-button = Mégse
confirmation-dialog-dismiss-button =
    .title = Mégse

about-logins-confirm-remove-dialog-title = Eltávolítja ezt a bejelentkezést?
confirm-delete-dialog-message = Ez a művelet nem vonható vissza.
about-logins-confirm-remove-dialog-confirm-button = Eltávolítás

about-logins-confirm-export-dialog-title = Bejelentkezések és jelszavak exportálása
about-logins-confirm-export-dialog-message = A jelszavai olvasható szövegként lesznek mentve (például R0sszJel$zó), így bárki megtekintheti, aki meg tudja nyitni az exportált fájlt.
about-logins-confirm-export-dialog-confirm-button = Exportálás…

confirm-discard-changes-dialog-title = Elveti a mentetlen módosításokat?
confirm-discard-changes-dialog-message = Minden nem mentett változás elvész.
confirm-discard-changes-dialog-confirm-button = Elvetés

## Breach Alert notification

about-logins-breach-alert-title = Weboldalon történt adatsértés
breach-alert-text = A jelszavai kiszivárogtak vagy ellopták őket a weboldalról a bejelentkezési adatai legutóbbi frissítése óta. A fiókja védelme érdekében cserélje le jelszavát.
about-logins-breach-alert-date = Ez az adatsértés ekkor történt: { DATETIME($date, day: "numeric", month: "long", year: "numeric") }
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-breach-alert-link = Ugrás ide: { $hostname }
about-logins-breach-alert-learn-more-link = További tudnivalók

## Vulnerable Password notification

about-logins-vulnerable-alert-title = Sebezhető jelszó
about-logins-vulnerable-alert-text2 = Ezt a jelszót egy másik fiókhoz használták, amely valószínűleg adatsértésben volt érintett. A hitelesítő adatok újbóli felhasználása veszélyezteti az összes fiókját. Cserélje le ezt a jelszót.
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-vulnerable-alert-link = Ugrás ide: { $hostname }
about-logins-vulnerable-alert-learn-more-link = További tudnivalók

## Error Messages

# This is an error message that appears when a user attempts to save
# a new login that is identical to an existing saved login.
# Variables:
#   $loginTitle (String) - The title of the website associated with the login.
about-logins-error-message-duplicate-login-with-link = Már létezik bejegyzése a(z) { $loginTitle } oldalhoz ezzel a felhasználónévvel. <a data-l10n-name="duplicate-link">Ugrás a létező bejegyzéshez?</a>

# This is a generic error message.
about-logins-error-message-default = Hiba történt a jelszó mentésekor.


## Login Export Dialog

# Title of the file picker dialog
about-logins-export-file-picker-title = Bejelentkezéseket tartalmazó fájl exportálása
# The default file name shown in the file picker when exporting saved logins.
# This must end in .csv
about-logins-export-file-picker-default-filename = logins.csv
about-logins-export-file-picker-export-button = Exportálás
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-export-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] CSV-dokumentum
       *[other] CSV-fájl
    }

## Login Import Dialog

# Title of the file picker dialog
about-logins-import-file-picker-title = Bejelentkezéseket tartalmazó fájl importálása
about-logins-import-file-picker-import-button = Importálás
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-import-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] CSV-dokumentum
       *[other] CSV-fájl
    }
