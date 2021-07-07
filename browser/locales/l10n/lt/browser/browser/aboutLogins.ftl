# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = Prisijungimai ir slaptažodžiai

# "Google Play" and "App Store" are both branding and should not be translated

login-app-promo-title = Turėkite savo slaptažodžius visur
login-app-promo-subtitle = Naudokite nemokamą programą „{ -lockwise-brand-name }“
login-app-promo-android =
    .alt = Parsisiųskite iš „Google Play“
login-app-promo-apple =
    .alt = Parsisiųskite iš „App Store“
login-filter =
    .placeholder = Ieškoti prisijungimų
create-login-button = Sukurti naują prisijungimą
fxaccounts-sign-in-text = Turėkite savo slaptažodžius ir kituose įrenginiuose
fxaccounts-sign-in-button = Prisijungti prie „{ -sync-brand-short-name }“
fxaccounts-sign-in-sync-button = Prisijungti sinchronizavimui
fxaccounts-avatar-button =
    .title = Tvarkyti paskyrą

## The ⋯ menu that is in the top corner of the page

menu =
    .title = Atverti meniu
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = Importuoti iš kitos naršyklės…
about-logins-menu-menuitem-import-from-a-file = Importuoti iš failo…
about-logins-menu-menuitem-export-logins = Eksportuoti prisijungimus…
about-logins-menu-menuitem-remove-all-logins = Pašalinti visus prisijungimus…
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] Nuostatos
       *[other] Nuostatos
    }
about-logins-menu-menuitem-help = Žinynas
menu-menuitem-android-app = „{ -lockwise-brand-short-name }“, skirta „Android“
menu-menuitem-iphone-app = „{ -lockwise-brand-short-name }“, skirta „iPhone“ ir „iPad“

## Login List

login-list =
    .aria-label = Surasti prisijungimai
login-list-count =
    { $count ->
        [one] { $count } prisijungimas
        [few] { $count } prisijungimai
       *[other] { $count } prisijungimų
    }
login-list-sort-label-text = Rikiuoti pagal:
login-list-name-option = Pavadinimas (A-Z)
login-list-name-reverse-option = Pavadinimas (Z-A)
about-logins-login-list-alerts-option = Įspėjimai
login-list-last-changed-option = Atnaujinimo laikas
login-list-last-used-option = Paskiausias naudojimo laikas
login-list-intro-title = Prisijungimų nerasta
login-list-intro-description = Kai įrašysite slaptažodį į „{ -brand-product-name }“, jis atsiras čia.
about-logins-login-list-empty-search-title = Prisijungimų nerasta
about-logins-login-list-empty-search-description = Nėra jūsų paiešką atitinkančių rezultatų.
login-list-item-title-new-login = Naujas prisijungimas
login-list-item-subtitle-new-login = Įveskite prisijungimo duomenis
login-list-item-subtitle-missing-username = (nėra naudotojo vardo)
about-logins-list-item-breach-icon =
    .title = Pažeista svetainė
about-logins-list-item-vulnerable-password-icon =
    .title = Pažeidžiami slaptažodžiai

## Introduction screen

login-intro-heading = Ieškote įrašytų prisijungimų? Naudokite „{ -sync-brand-short-name }“.
about-logins-login-intro-heading-logged-out = Ieškote savo įrašytų prisijungimų? Naudokite „{ -sync-brand-short-name }“, arba importuokite juos.
about-logins-login-intro-heading-logged-out2 = Ieškote įrašytų prisijungimų? Įjunkite sinchronizavimą arba importuokite juos.
about-logins-login-intro-heading-logged-in = Nerasta sinchronizuotų prisijungimų.
login-intro-description = Jeigu esate įrašę prisijungimus į „{ -brand-product-name }“ kitame įrenginyje, juos galite turėti čia:
login-intro-instruction-fxa = Susikurkite arba prisijunkite prie savo „{ -fxaccount-brand-name }“ paskyros tame įrenginyje, kur yra prisijungimai.
login-intro-instruction-fxa-settings = Įsitikinkite, kad „{ -sync-brand-short-name }“ nuostatose pažymėjote langelį „Prisijungimai“.
about-logins-intro-instruction-help = Aplankę <a data-l10n-name="help-link">„{ -lockwise-brand-short-name }“ žinyną</a>, rasite daugiau informacijos
login-intro-instructions-fxa = Susikurkite arba prisijunkite prie savo „{ -fxaccount-brand-name }“ paskyros tame įrenginyje, kur yra prisijungimai.
login-intro-instructions-fxa-settings = Eikite į „Nuostatos“ > „Sinchronizavimas“ > „Įjungti sinchronizavimą…“ Pažymėkite „Prisijungimai ir slaptažodžiai“ pasirinkimą.
login-intro-instructions-fxa-help = Aplankę <a data-l10n-name="help-link">„{ -lockwise-brand-short-name }“ žinyną</a>, rasite daugiau informacijos.
about-logins-intro-import = Jeigu turite kitoje naršyklėje įrašytų prisijungimų, galite <a data-l10n-name="import-link">juos importuoti į „{ -lockwise-brand-short-name }“</a>
about-logins-intro-import2 = Jei jūsų prisijungimai yra įrašyti kitur nei „{ -brand-product-name }“, galite <a data-l10n-name="import-browser-link">juos importuoti iš kitos naršyklės</a> arba <a data-l10n-name="import-file-link">iš failo</a>

## Login

login-item-new-login-title = Sukurti naują prisijungimą
login-item-edit-button = Taisyti
about-logins-login-item-remove-button = Pašalinti
login-item-origin-label = Svetainės adresas
login-item-tooltip-message = Įsitikinkite, kad tai sutampa su tiksliu svetainės adresu, į kurią prisijungiate.
login-item-origin =
    .placeholder = https://www.example.com
login-item-username-label = Naudotojo vardas
about-logins-login-item-username =
    .placeholder = (nėra naudotojo vardo)
login-item-copy-username-button-text = Kopijuoti
login-item-copied-username-button-text = Nukopijuota!
login-item-password-label = Slaptažodis
login-item-password-reveal-checkbox =
    .aria-label = Rodyti slaptažodį
login-item-copy-password-button-text = Kopijuoti
login-item-copied-password-button-text = Nukopijuota!
login-item-save-changes-button = Įrašyti pakeitimus
login-item-save-new-button = Įrašyti
login-item-cancel-button = Atsisakyti
login-item-time-changed = Paskutinis atnaujinimas: { DATETIME($timeChanged, day: "numeric", month: "long", year: "numeric") }
login-item-time-created = Sukurta: { DATETIME($timeCreated, day: "numeric", month: "long", year: "numeric") }
login-item-time-used = Paskutinis naudojimas: { DATETIME($timeUsed, day: "numeric", month: "long", year: "numeric") }

## OS Authentication dialog

about-logins-os-auth-dialog-caption = { -brand-full-name }

## The macOS strings are preceded by the operating system with "Firefox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.

# This message can be seen when attempting to edit a login in about:logins on Windows.
about-logins-edit-login-os-auth-dialog-message-win = Norėdami keisti savo prisijungimą, įveskite savo „Windows“ prisijungimo duomenis. Tai padeda apsaugoti jūsų paskyras.
# This message can be seen when attempting to edit a login in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-edit-login-os-auth-dialog-message-macosx = redaguoti įrašytą prisijungimą
# This message can be seen when attempting to reveal a password in about:logins on Windows.
about-logins-reveal-password-os-auth-dialog-message-win = Norėdami peržiūrėti savo slaptažodį, įveskite savo „Windows“ prisijungimo duomenis. Tai padeda apsaugoti jūsų paskyras.
# This message can be seen when attempting to reveal a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-reveal-password-os-auth-dialog-message-macosx = parodyti įrašytą slaptažodį
# This message can be seen when attempting to copy a password in about:logins on Windows.
about-logins-copy-password-os-auth-dialog-message-win = Norėdami nukopijuoti savo slaptažodį, įveskite savo „Windows“ prisijungimo duomenis. Tai padeda apsaugoti jūsų paskyras.
# This message can be seen when attempting to copy a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-copy-password-os-auth-dialog-message-macosx = nukopijuoti įrašytą slaptažodį

## Master Password notification

master-password-notification-message = Įveskite pagrindinį slaptažodį, norėdami peržiūrėti įrašytus prisijungimus ir slaptažodžius
# This message can be seen when attempting to export a password in about:logins on Windows.
about-logins-export-password-os-auth-dialog-message-win = Norėdami eksportuoti savo prisijungimus, įveskite savo „Windows“ prisijungimo duomenis. Tai padeda apsaugoti jūsų paskyras.
# This message can be seen when attempting to export a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-export-password-os-auth-dialog-message-macosx = eksportuoti įrašytus prisijungimus ir slaptažodžius

## Primary Password notification

about-logins-primary-password-notification-message = Įveskite pagrindinį slaptažodį, norėdami peržiūrėti įrašytus prisijungimus ir slaptažodžius
master-password-reload-button =
    .label = Prisijungti
    .accesskey = P

## Password Sync notification

enable-password-sync-notification-message =
    { PLATFORM() ->
        [windows] Norite turėti savo prisijungimus visur, kur naudojate { -brand-product-name }? Eikite į „{ -sync-brand-short-name }“ nuostatas ir pažymėkite langelį „Prisijungimai“.
       *[other] Norite turėti savo prisijungimus visur, kur naudojate { -brand-product-name }? Eikite į „{ -sync-brand-short-name }“ nuostatas ir pažymėkite langelį „Prisijungimai“.
    }
enable-password-sync-preferences-button =
    .label =
        { PLATFORM() ->
            [windows] Aplankyti „{ -sync-brand-short-name }“ nuostatas
           *[other] Aplankyti „{ -sync-brand-short-name }“ nuostatas
        }
    .accesskey = A
about-logins-enable-password-sync-dont-ask-again-button =
    .label = Daugiau neklausti
    .accesskey = D

## Dialogs

confirmation-dialog-cancel-button = Atsisakyti
confirmation-dialog-dismiss-button =
    .title = Atsisakyti
about-logins-confirm-remove-dialog-title = Pašalinti šį prisijungimą?
confirm-delete-dialog-message = Atlikus šį veiksmą, jo atšaukti neįmanoma.
about-logins-confirm-remove-dialog-confirm-button = Pašalinti
about-logins-confirm-remove-all-dialog-confirm-button-label =
    { $count ->
        [1] Pašalinti
        [one] Pašalinti
        [few] Pašalinti visus
       *[other] Pašalinti visus
    }
about-logins-confirm-remove-all-dialog-checkbox-label =
    { $count ->
        [1] Taip, pašalinti šį prisijungimą
        [one] Taip, pašalinti šį prisijungimą
        [few] Taip, pašalinti šiuos prisijungimus
       *[other] Taip, pašalinti šiuos prisijungimus
    }
about-logins-confirm-remove-all-dialog-title =
    { $count ->
        [one] Pašalinti { $count } prisijungimą?
        [few] Pašalinti visus { $count } prisijungimus?
       *[other] Pašalinti visus { $count } prisijungimų?
    }
about-logins-confirm-remove-all-dialog-message =
    { $count ->
        [1] Bus pašalintas į „{ -brand-short-name }“ įrašytas prisijungimas, ir visi čia matomi nutekėjimų pranešimai. Šis veiksmas galutinis.
        [one] Bus pašalintas į „{ -brand-short-name }“ įrašytas prisijungimas, ir visi čia matomi nutekėjimų pranešimai. Šis veiksmas galutinis.
        [few] Bus pašalinti į „{ -brand-short-name }“ įrašyti prisijungimai, ir visi čia matomi nutekėjimų pranešimai. Šis veiksmas galutinis.
       *[other] Bus pašalinti į „{ -brand-short-name }“ įrašytas prisijungimai, ir visi čia matomi nutekėjimų pranešimai. Šis veiksmas galutinis.
    }
about-logins-confirm-remove-all-sync-dialog-title =
    { $count ->
        [one] Pašalinti { $count } prisijungimą iš visų įrenginių?
        [few] Pašalinti visus { $count } prisijungimus iš visų įrenginių?
       *[other] Pašalinti visus { $count } prisijungimų iš visų įrenginių?
    }
about-logins-confirm-remove-all-sync-dialog-message =
    { $count ->
        [1] Bus pašalintas į „{ -brand-short-name }“ įrašytas prisijungimas, iš visų su „{ -fxaccount-brand-name }“ paskyra susietų įrenginių. Tuo pačiu bus pašalinti čia matomi nutekėjimų pranešimai. Šis veiksmas galutinis.
        [one] Bus pašalintas į „{ -brand-short-name }“ įrašytas prisijungimas, iš visų su „{ -fxaccount-brand-name }“ paskyra susietų įrenginių. Tuo pačiu bus pašalinti čia matomi nutekėjimų pranešimai. Šis veiksmas galutinis.
        [few] Bus pašalinti į „{ -brand-short-name }“ įrašyti prisijungimai, iš visų su „{ -fxaccount-brand-name }“ paskyra susietų įrenginių. Tuo pačiu bus pašalinti čia matomi nutekėjimų pranešimai. Šis veiksmas galutinis.
       *[other] Bus pašalinti į „{ -brand-short-name }“ įrašyti prisijungimai, iš visų su „{ -fxaccount-brand-name }“ paskyra susietų įrenginių. Tuo pačiu bus pašalinti čia matomi nutekėjimų pranešimai. Šis veiksmas galutinis.
    }
about-logins-confirm-export-dialog-title = Eksportuoti prisijungimus ir slaptažodžius
about-logins-confirm-export-dialog-message = Jūsų slaptažodžiai bus įrašyti kaip perskaitomas tekstas (pvz., BlogasSl@ptaz0dis), tad bet kas galintis atverti eksportuotą failą galės juos peržiūrėti.
about-logins-confirm-export-dialog-confirm-button = Eksportuoti…
about-logins-alert-import-title = Importas baigtas
about-logins-alert-import-message = Rodyti išsamią importo suvestinę
confirm-discard-changes-dialog-title = Atmesti neįrašytus pakeitimus?
confirm-discard-changes-dialog-message = Visi neįrašyti pakeitimai bus prarasti.
confirm-discard-changes-dialog-confirm-button = Atmesti

## Breach Alert notification

about-logins-breach-alert-title = Svetainės pažeidimas
breach-alert-text = Po jūsų paskutinio prisijungimo duomenų atnaujinimo, iš šios svetainės nutekėjo arba buvo pavogti slaptažodžiai. Pasikeiskite slaptažodį, kad apsaugotumėte savo paskyrą.
about-logins-breach-alert-date = Šis pažeidimas įvyko { DATETIME($date, day: "numeric", month: "long", year: "numeric") }
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-breach-alert-link = Eiti į { $hostname }
about-logins-breach-alert-learn-more-link = Sužinoti daugiau

## Vulnerable Password notification

about-logins-vulnerable-alert-title = Pažeidžiamas slaptažodis
about-logins-vulnerable-alert-text2 = Šis slaptažodis buvo panaudotas su kita paskyra, kuri galimai pateko tarp nutekėjusių duomenų. Naudodami tuos pačius slaptažodžius, rizikuojate visų savo paskyrų saugumu. Pasikeiskite šį slaptažodį.
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-vulnerable-alert-link = Eiti į { $hostname }
about-logins-vulnerable-alert-learn-more-link = Sužinoti daugiau

## Error Messages

# This is an error message that appears when a user attempts to save
# a new login that is identical to an existing saved login.
# Variables:
#   $loginTitle (String) - The title of the website associated with the login.
about-logins-error-message-duplicate-login-with-link = Jau yra { $loginTitle } įrašas su tokiu naudotojo vardu. <a data-l10n-name="duplicate-link">Parodyti esamą įrašą?</a>
# This is a generic error message.
about-logins-error-message-default = Bandant įrašyti šį slaptažodį įvyko klaida.

## Login Export Dialog

# Title of the file picker dialog
about-logins-export-file-picker-title = Eksportuoti prisijungimų failą
# The default file name shown in the file picker when exporting saved logins.
# This must end in .csv
about-logins-export-file-picker-default-filename = prisijungimai.csv
about-logins-export-file-picker-export-button = Eksportuoti
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-export-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] CSV dokumentas
       *[other] CSV failas
    }

## Login Import Dialog

# Title of the file picker dialog
about-logins-import-file-picker-title = Importuoti prisijungimų failą
about-logins-import-file-picker-import-button = Importuoti
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-import-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] CSV failas
       *[other] CSV failas
    }
# A description for the .tsv file format that may be shown as the file type
# filter by the operating system. TSV is short for 'tab separated values'.
about-logins-import-file-picker-tsv-filter-title =
    { PLATFORM() ->
        [macos] TSV dokumentas
       *[other] TSV failas
    }

##
## Variables:
##  $count (number) - The number of affected elements

about-logins-import-dialog-title = Importas baigtas
about-logins-import-dialog-items-added =
    { $count ->
        [one] <span>Pridėtas naujas prisijungimas:</span> <span data-l10n-name="count">{ $count }</span>
        [few] <span>Pridėti nauji prisijungimai:</span> <span data-l10n-name="count">{ $count }</span>
       *[other] <span>Pridėta naujų prisijungimų:</span> <span data-l10n-name="count">{ $count }</span>
    }
about-logins-import-dialog-items-modified =
    { $count ->
        [one] <span>Atnaujintas esamas prisijungimas:</span> <span data-l10n-name="count">{ $count }</span>
        [few] <span>Atnaujinti esami prisijungimai:</span> <span data-l10n-name="count">{ $count }</span>
       *[other] <span>Atnaujinta esamų prisijungimų:</span> <span data-l10n-name="count">{ $count }</span>
    }
about-logins-import-dialog-items-no-change =
    { $count ->
        [one] <span>Rastas pasikartojantis prisijungimas:</span> <span data-l10n-name="count">{ $count }</span> <span data-l10n-name="meta">(neimportuota)</span>
        [few] <span>Rasti pasikartojantys prisijungimai:</span> <span data-l10n-name="count">{ $count }</span> <span data-l10n-name="meta">(neimportuota)</span>
       *[other] <span>Rasta pasikartojančių prisijungimų:</span> <span data-l10n-name="count">{ $count }</span> <span data-l10n-name="meta">(neimportuota)</span>
    }
about-logins-import-dialog-items-error =
    { $count ->
        [one] <span>Klaida:</span> <span data-l10n-name="count">{ $count }</span> <span data-l10n-name="meta">(neimportuota)</span>
        [few] <span>Klaidos:</span> <span data-l10n-name="count">{ $count }</span> <span data-l10n-name="meta">(neimportuota)</span>
       *[other] <span>Klaidų:</span> <span data-l10n-name="count">{ $count }</span> <span data-l10n-name="meta">(neimportuota)</span>
    }
about-logins-import-dialog-done = Atlikta
about-logins-import-dialog-error-title = Importavimo klaida
about-logins-import-dialog-error-conflicting-values-title = Kelios nederančios vieno prisijungimo reikšmės
about-logins-import-dialog-error-conflicting-values-description = Pavyzdžiui: keli prisijungimo vardai, slaptažodžiai, URL adresai, ir t.t., tam pačiam prisijungimui.
about-logins-import-dialog-error-file-format-title = Failo formato problema
about-logins-import-dialog-error-file-format-description = Neteisingos arba trūkstamos stulpelių antraštės. Įsitikinkite, kad faile yra naudotojo vardo, slaptažodžio, ir URL stulpeliai.
about-logins-import-dialog-error-file-permission-title = Nepavyko perskaityti failo
about-logins-import-dialog-error-file-permission-description = „{ -brand-short-name }“ neturi leidimo skaityti failą. Pabandykite pakeisti failo leidimus.
about-logins-import-dialog-error-unable-to-read-title = Nepavyko išanalizuoti failo
about-logins-import-dialog-error-unable-to-read-description = Įsitikinkite, kad pasirinkote CSV arba TSV failą.
about-logins-import-dialog-error-no-logins-imported = Neimportuoti jokie prisijungimai
about-logins-import-dialog-error-learn-more = Sužinoti daugiau
about-logins-import-dialog-error-try-again = Bandyti dar kartą…
about-logins-import-dialog-error-try-import-again = Bandyti importuoti iš naujo…
about-logins-import-dialog-error-cancel = Atsisakyti
about-logins-import-report-title = Importo suvestinė
about-logins-import-report-description = Į „{ -brand-short-name }“ importuoti prisijungimai ir slaptažodžiai.
#
# Variables:
#  $number (number) - The number of the row
about-logins-import-report-row-index = Eilutė { $number }
about-logins-import-report-row-description-no-change = Dublikatas: tikslus jau esančio prisijungimo atitikmuo
about-logins-import-report-row-description-modified = Atnaujintas esamas prisijungimas
about-logins-import-report-row-description-added = Pridėtas naujas prisijungimas
about-logins-import-report-row-description-error = Klaida: trūksta lauko

##
## Variables:
##  $field (String) - The name of the field from the CSV file for example url, username or password

about-logins-import-report-row-description-error-multiple-values = Klaida: laukas „{ $field }“ turi keletą reikšmių
about-logins-import-report-row-description-error-missing-field = Klaida: trūksta lauko „{ $field }“

##
## Variables:
##  $count (number) - The number of affected elements


## Logins import report page

about-logins-import-report-page-title = Importo suvestinės ataskaita
