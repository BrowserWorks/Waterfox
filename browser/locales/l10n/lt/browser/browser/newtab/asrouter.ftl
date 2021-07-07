# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Rekomenduojamas priedas
cfr-doorhanger-feature-heading = Rekomenduojama funkcija
cfr-doorhanger-pintab-heading = Pabandykite: kortelės įsegimas

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Kodėl tai matau
cfr-doorhanger-extension-cancel-button = Ne dabar
    .accesskey = N
cfr-doorhanger-extension-ok-button = Pridėti dabar
    .accesskey = P
cfr-doorhanger-pintab-ok-button = Įsegti šią kortelę
    .accesskey = s
cfr-doorhanger-extension-manage-settings-button = Tvarkyti rekomendacijų nuostatas
    .accesskey = T
cfr-doorhanger-extension-never-show-recommendation = Nerodyti man šios rekomendacijos
    .accesskey = N
cfr-doorhanger-extension-learn-more-link = Sužinoti daugiau
# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = sukūrė { $name }
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = Rekomendacija
cfr-doorhanger-extension-notification2 = Rekomendacija
    .tooltiptext = Priedo rekomendacija
    .a11y-announcement = Siūloma priedo rekomendacija
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = Rekomendacija
    .tooltiptext = Funkcijos rekomendacija
    .a11y-announcement = Siūloma funkcijos rekomendacija

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
            [one] { $total } žvaigždutė
            [few] { $total } žvaigždutės
           *[other] { $total } žvaigždučių
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [one] { $total } naudotojas
        [few] { $total } naudotojai
       *[other] { $total } naudotojų
    }
cfr-doorhanger-pintab-description = Lengvai pasiekite dažniausiai naudojamas svetaines. Laikykite jas atvertas kortelėse (net kai iš naujo atidarote naršyklę).

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = <b>Spustelėkite dešiniu pelės mygtuku</b> ant kortelės, kurią norite įsegti.
cfr-doorhanger-pintab-step2 = Iš meniu pasirinkite <b>įsegti kortelę</b>.
cfr-doorhanger-pintab-step3 = Jeigu svetainė atsinaujino, ant įsegtos kortelės matysite mėlyną tašką.
cfr-doorhanger-pintab-animation-pause = Pristabdyti
cfr-doorhanger-pintab-animation-resume = Tęsti

## Firefox Accounts Message

cfr-doorhanger-bookmark-fxa-header = Sinchronizuokite adresyną visuose įrenginiuose.
cfr-doorhanger-bookmark-fxa-body = Puikus radinys! O kad nepasigestumėte šio įrašo kituose įrenginiuose, susikurkite „{ -fxaccount-brand-name }“ paskyrą.
cfr-doorhanger-bookmark-fxa-link-text = Sinchronizuoti adresyną dabar…
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = Užvėrimo mygtukas
    .title = Užverti

## Protections panel

cfr-protections-panel-header = Nebūkite stebimi naršant
cfr-protections-panel-body = Jūsų duomenys skirti tik jums. „{ -brand-short-name }“ saugo jus nuo daugelio dažniausių stebėjimo elementų, stebinčių jūsų veiklą internete.
cfr-protections-panel-link-text = Sužinoti daugiau

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = Naujovė:
cfr-whatsnew-button =
    .label = Kas naujo
    .tooltiptext = Kas naujo
cfr-whatsnew-panel-header = Kas naujo
cfr-whatsnew-release-notes-link-text = Skaityti laidos apžvalgą
cfr-whatsnew-fx70-title = „{ -brand-short-name }“ už jūsų privatumą dabar kovoja dar labiau
cfr-whatsnew-fx70-body =
    Paskiausias naujinimas pagerina apsaugą nuo stebėjimo, ir leidžia dar lengviau
    sukurti saugius slaptažodžius visoms svetainėms.
cfr-whatsnew-tracking-protect-title = Apsaugokite save nuo stebėjimo elementų
cfr-whatsnew-tracking-protect-body =
    „{ -brand-short-name }“ blokuoja daugelį dažniausiai pasitaikančių socialinių ir tarp svetainių veikiančių
    stebėjimo elementų, sekančių jūsų veiklą internete.
cfr-whatsnew-tracking-protect-link-text = Peržiūrėti jūsų ataskaitą
# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
        [one] Užblokuotas stebėjimo elementas
        [few] Užblokuoti stebėjimo elementai
       *[other] Užblokuota stebėjimo elementų
    }
cfr-whatsnew-tracking-blocked-subtitle = Nuo { DATETIME($earliestDate, month: "long", year: "numeric") }
cfr-whatsnew-tracking-blocked-link-text = Peržiūrėti ataskaitą
cfr-whatsnew-lockwise-backup-title = Pasidarykite savo slaptažodžių kopiją
cfr-whatsnew-lockwise-backup-body = Dabar susikurkite saugius slaptažodžius, kuriuos galėsite pasiekti visur, kur prisijungiate.
cfr-whatsnew-lockwise-backup-link-text = Įjungti atsargines kopijas
cfr-whatsnew-lockwise-take-title = Turėkite savo slaptažodžius su savimi
cfr-whatsnew-lockwise-take-body =
    Mobilioji „{ -lockwise-brand-short-name }“ programa leidžia saugiai
    pasiekti savo slaptažodžius iš bet kur.
cfr-whatsnew-lockwise-take-link-text = Parsisiųskite programą

## Search Bar

cfr-whatsnew-searchbar-title = Rašykite mažiau, raskite daugiau su adreso juosta
cfr-whatsnew-searchbar-body-topsites = Dabar jums spustelėjus ant adreso juostos, pasirodys jūsų lankomiausių svetainių sąrašas.

## Search bar

cfr-whatsnew-searchbar-icon-alt-text = Didinamojo stiklo piktograma

## Picture-in-Picture

cfr-whatsnew-pip-header = Žiūrėkite vaizdo įrašus naršydami
cfr-whatsnew-pip-body = Vaizdo-vaizde veiksena leidžia žiūrėti vaizdo įrašą atskirame lange, kurį galite matyti net vaikščiodami tarp kortelių.
cfr-whatsnew-pip-cta = Sužinoti daugiau

## Permission Prompt

cfr-whatsnew-permission-prompt-header = Mažiau erzinančių iškylančiųjų langų
cfr-whatsnew-permission-prompt-body = „{ -brand-shorter-name }“ dabar blokuoja automatinius svetainių prašymus rodyti iškylančiuosius langus.
cfr-whatsnew-permission-prompt-cta = Sužinoti daugiau

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header =
    { $fingerprinterCount ->
        [one] Užblokuotas skaitmeninių atspaudų stebėjimo elementas
        [few] Užblokuoti skaitmeninių atspaudų stebėjimo elementai
       *[other] Užblokuota skaitmeninių atspaudų stebėjimo elementų
    }
cfr-whatsnew-fingerprinter-counter-body = „{ -brand-shorter-name }“ blokuoja daugelį skaitmeninių atspaudų stebėjimo elementų, kurie nepastebimai renka informaciją apie jūsų įrenginį ir veiksmus, siekiant sukurti jūsų reklaminį profilį.
# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = Skaitmeninių atspaudų stebėjimo elementai
cfr-whatsnew-fingerprinter-counter-body-alt = „{ -brand-shorter-name }“ gali blokuoti skaitmeninių atspaudų stebėjimo elementus, kurie nepastebimai renka informaciją apie jūsų įrenginį ir veiksmus, siekiant sukurti jūsų reklaminį profilį.

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = Gaukite šį adresyno įrašą savo telefone
cfr-doorhanger-sync-bookmarks-body = Turėkite savo adresyną, slaptažodžius, žurnalą ir kitką visur, kur esate prisijungę prie „{ -brand-product-name }“.
cfr-doorhanger-sync-bookmarks-ok-button = Įjungti „{ -sync-brand-short-name }“
    .accesskey = j

## Login Sync

cfr-doorhanger-sync-logins-header = Daugiau niekada nepamirškite slaptažodžio
cfr-doorhanger-sync-logins-body = Saugiai laikykite ir sinchronizuokite slaptažodžius tarp visų savo įrenginių.
cfr-doorhanger-sync-logins-ok-button = Įjungti „{ -sync-brand-short-name }“
    .accesskey = t

## Send Tab

cfr-doorhanger-send-tab-header = Skaitykite tai keliaudami
cfr-doorhanger-send-tab-recipe-header = Nusineškite šį receptą į virtuvę
cfr-doorhanger-send-tab-body = Kortelių persiuntimas leidžia lengvai perduoti šį saitą į jūsų telefoną ar bet kur kitur, kur esate prisijungę prie „{ -brand-product-name }“.
cfr-doorhanger-send-tab-ok-button = Išbandyti  kortelių persiuntimą
    .accesskey = b

## Firefox Send

cfr-doorhanger-firefox-send-header = Dalintis šiuo PDF saugiai
cfr-doorhanger-firefox-send-body = Laikykite savo svarbius failus saugiai, naudodamiesi ištisiniu šifravimu ir gaudami saitą, kuris išnyksta po nustato laiko.
cfr-doorhanger-firefox-send-ok-button = Išbandyti „{ -send-brand-name }“
    .accesskey = b

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = Peržiūrėti apsaugas
    .accesskey = p
cfr-doorhanger-socialtracking-close-button = Užverti
    .accesskey = U
cfr-doorhanger-socialtracking-dont-show-again = Daugiau tokių pranešimų nerodyti
    .accesskey = D
cfr-doorhanger-socialtracking-heading = „{ -brand-short-name }“ neleido socialiniam tinklui čia jūsų sekti
cfr-doorhanger-socialtracking-description = Jūsų privatumas yra svarbus. „{ -brand-short-name }“ jau blokuoja dažniausius socialinių tinklų stebėjimo elementus, taip ribojant, kiek duomenų jie gali surinkti apie jūsų naršymo veiklą.
cfr-doorhanger-fingerprinters-heading = „{ -brand-short-name }“ šioje svetainėje užblokavo skaitmeninių atspaudų stebėjimo elementą
cfr-doorhanger-fingerprinters-description = Jūsų privatumas yra svarbus. „{ -brand-short-name }“ jau blokuoja skaitmeninių atspaudų stebėjimo elementus, kurie renka jūsų įrenginį identifikuoti leidžiančią informaciją, kad galėtų jus sekti.
cfr-doorhanger-cryptominers-heading = „{ -brand-short-name }“ šioje svetainėje užblokavo kriptovaliutų kasėją
cfr-doorhanger-cryptominers-description = Jūsų privatumas yra svarbus. „{ -brand-short-name }“ jau blokuoja kriptovaliutų kasėjus, kurie naudoja jūsų sistemos resursus skaitmeninių pinigų kasimui.

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    { $blockedCount ->
        [one] „{ -brand-short-name }“ užblokavo virš <b>{ $blockedCount }</b> stebėjimo elemento nuo { $date }!
        [few] „{ -brand-short-name }“ užblokavo virš <b>{ $blockedCount }</b> stebėjimo elementų nuo { $date }!
       *[other] „{ -brand-short-name }“ užblokavo virš <b>{ $blockedCount }</b> stebėjimo elementų nuo { $date }!
    }
# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (Datetime) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading2 =
    { $blockedCount ->
        [one] Nuo { DATETIME($date, month: "long", year: "numeric") } „{ -brand-short-name }“ užblokavo virš <b>{ $blockedCount }</b> stebėjimo elemento!
        [few] Nuo { DATETIME($date, month: "long", year: "numeric") } „{ -brand-short-name }“ užblokavo virš <b>{ $blockedCount }</b> stebėjimo elementų!
       *[other] Nuo { DATETIME($date, month: "long", year: "numeric") } „{ -brand-short-name }“ užblokavo virš <b>{ $blockedCount }</b> stebėjimo elementų!
    }
cfr-doorhanger-milestone-ok-button = Rodyti viską
    .accesskey = R

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = Lengvai susikurkite saugius slaptažodžius
cfr-whatsnew-lockwise-body = Sugalvoti unikalų ir saugų slaptažodį kiekvienai paskyrai yra sudėtinga. Kurdami slaptažodį, pasirinkite slaptažodžio lauką norėdami naudoti saugų, sugeneruotą slaptažodį iš „{ -brand-shorter-name }“.
cfr-whatsnew-lockwise-icon-alt = „{ -lockwise-brand-short-name }“ piktograma

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = Gaukite pranešimus apie pažeidžiamus slaptažodžius
cfr-whatsnew-passwords-body = Programišiai žino, kad žmonės mėgsta naudoti tuos pačius slaptažodžius. Jei tą patį slaptažodį naudojote keliose svetainėse, ir vienos iš jų duomenys nutekėjo, per „{ -lockwise-brand-short-name }“ pamatysite įspėjimą pasikeisti slaptažodį tose svetainėse.
cfr-whatsnew-passwords-icon-alt = Pažeidžiamo slaptažodžio rakto piktograma

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-header = Žiūrėkite vaizdą-vaizde visame ekrane
cfr-whatsnew-pip-fullscreen-body = Kai perkeliate vaizdo įrašą į atskirą langą, galite spustelėti dukart ant jo, kad pereitumėte į viso ekrano veikseną.
cfr-whatsnew-pip-fullscreen-icon-alt = Vaizdo-vaizde piktograma

## Protections Dashboard message

cfr-doorhanger-milestone-close-button = Užverti
    .accesskey = v

## What’s New Panel Content for Firefox 76
## Protections Dashboard message

cfr-whatsnew-protections-header = Apsaugos apžvalga
cfr-whatsnew-protections-body = Apsaugos skydelis pateikia duomenų nutekėjimų ir slaptažodžių tvarkymo ataskaitų santraukas. Čia galite sekti, kiek duomenų nutekėjimų esate patikrinę, ir matyti, ar tarp jūsų įrašytų slaptažodžių yra galimai nutekėjusių.
cfr-whatsnew-protections-cta-link = Rodyti apsaugos skydelį
cfr-whatsnew-protections-icon-alt = Skydo piktograma

## Better PDF message

cfr-whatsnew-better-pdf-header = Geresnis PDF veikimas
cfr-whatsnew-better-pdf-body = PDF dokumentai dabar atveriami tiesiogiai per „{ -brand-short-name }“, tad jūsų darbas lieka greitai pasiekiamas.

## DOH Message

cfr-doorhanger-doh-body = Jūsų privatumas yra svarbus. „{ -brand-short-name }“ dabar saugiai nukreipia jūsų DNS užklausas, kai tik įmanoma, į partnerių tarnybą, kad apsaugotų jus naršant.
cfr-doorhanger-doh-header = Saugesnės, šifruotos DNS užklausos
cfr-doorhanger-doh-primary-button-2 = Gerai
    .accesskey = G
cfr-doorhanger-doh-secondary-button = Išjungti
    .accesskey = I

## Fission Experiment Message

cfr-doorhanger-fission-body-approved = Jūsų privatumas yra svarbus. „{ -brand-short-name }“ jau izoliuoja, arba laiko atskirai, svetaines vieną nuo kitos, kas apsunkina piktavalių bandymus pavogti slaptažodžius, banko kortelių duomenis, ir kitus jautrius duomenis.
cfr-doorhanger-fission-header = Svetainių izoliavimas
cfr-doorhanger-fission-primary-button = Gerai, supratau
    .accesskey = G
cfr-doorhanger-fission-secondary-button = Sužinoti daugiau
    .accesskey = S

## What's new: Cookies message

cfr-whatsnew-clear-cookies-header = Automatinė apsauga nuo slaptų stebėjimo būdų
cfr-whatsnew-clear-cookies-body = Kai kurie stebėjimo elementai nukreipia jus į kitas svetaines, kurios slaptai įrašo slapukus. „{ -brand-short-name }“ dabar automatiškai išvalo tokius slapukus, kad nebūtumėte sekami.
cfr-whatsnew-clear-cookies-image-alt = Užblokuoto slapuko iliustracija

## What's new: Media controls message

cfr-whatsnew-media-keys-header = Daugiau medijos valdymo
cfr-whatsnew-media-keys-body = Leiskite ir pristabdykite garso bei vaizdo įrašus naudodamiesi savo klaviatūra ar ausinėmis, taip patogiau valdydami mediją iš kitos kortelės, programos, ar net kai kompiuteris užrakintas. Galite net pereiti tarp dainų, naudodamiesi mygtukais pirmyn ir atgal.
cfr-whatsnew-media-keys-button = Sužinoti kaip

## What's new: Search shortcuts

cfr-whatsnew-search-shortcuts-header = Paieškos leistukai adreso lauke
cfr-whatsnew-search-shortcuts-body = Dabar jums renkant ieškyklės ar tam tikros svetainės pavadinimą adreso lauke, žemiau esančiuose paieškos siūlymuose pasirodys mėlynas leistukas. Pasirinkę šį leistuką, paiešką įvykdysite tiesiai iš adreso lauko.

## What's new: Cookies protection

cfr-whatsnew-supercookies-header = Apsauga nuo kenkėjiškų „super“ slapukų
cfr-whatsnew-supercookies-body = Svetainės gali slapta prieš jūsų naršyklės pridėti „super“ slapuką, kuris seks jus naršant, net kai išvalote slapukus. „{ -brand-short-name }“ dabar suteikia stiprią apsaugą nuo „super“ slapukų, tad jie nebegali būtų naudojami sekti jūsų naršymo veiksmus tarp svetainių.

## What's new: Better bookmarking

cfr-whatsnew-bookmarking-header = Geresnis adresynas
cfr-whatsnew-bookmarking-body = Dabar dar lengviau sekti savo mėgstamas svetaines. „{ -brand-short-name }“ nuo šiol įsimena jūsų adresyno įrašų vietą, rodo adresyno juostą naujose kortelėse, ir suteikia jums lengvą priėjimą prie likusio adresyno per priemonių juostos aplanką.

## What's new: Cross-site cookie tracking

cfr-whatsnew-cross-site-tracking-header = Išsami apsauga nuo tarp svetainių veikiančių slapukų sekimo
cfr-whatsnew-cross-site-tracking-body = Dabar galite naudotis geresne apsauga nuo slapukų sekimo. „{ -brand-short-name }“ gali izoliuoti jūsų veiklą ir duomenis naršomoje svetainėje, tad naršyklėje esanti informacija nepasiekia kitų svetainių.

## Full Video Support CFR message

cfr-doorhanger-video-support-body = Šios svetainės vaizdo įrašai gali būti rodomi netinkamai su šia „{ -brand-short-name }“ versija. Norėdami gauti geriausią palaikymą, atnaujinkite „{ -brand-short-name }“.
cfr-doorhanger-video-support-header = Atnaujinkite „{ -brand-short-name }“, norėdami paleisti vaizdo įrašą
cfr-doorhanger-video-support-primary-button = Atnaujinti dabar
    .accesskey = A
