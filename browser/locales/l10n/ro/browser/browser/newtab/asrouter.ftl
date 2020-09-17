# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Extensie recomandată
cfr-doorhanger-feature-heading = Funcție recomandată
cfr-doorhanger-pintab-heading = Încearcă asta: Fixează fila

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = De ce văd asta
cfr-doorhanger-extension-cancel-button = Nu acum
    .accesskey = N
cfr-doorhanger-extension-ok-button = Adaugă acum
    .accesskey = A
cfr-doorhanger-pintab-ok-button = Fixează această filă
    .accesskey = P
cfr-doorhanger-extension-manage-settings-button = Gestionează setările pentru recomandări
    .accesskey = M
cfr-doorhanger-extension-never-show-recommendation = Nu-mi afișa această recomandare
    .accesskey = S
cfr-doorhanger-extension-learn-more-link = Află mai multe
# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = de { $name }
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = Recomandare
cfr-doorhanger-extension-notification2 = Recomandare
    .tooltiptext = Recomandare extensie
    .a11y-announcement = Recomandare disponibilă pentru extensie
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = Recomandare
    .tooltiptext = Recomandare funcționalitate
    .a11y-announcement = Recomandare disponibilă pentru funcționalitate

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
            [one] { $total } stea
            [few] { $total } stele
           *[other] { $total } de stele
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [one] { $total } utilizator
        [few] { $total } utilizatori
       *[other] { $total } de utilizatori
    }
cfr-doorhanger-pintab-description = Obține un acces facil la cele mai utilizate site-uri. Ține site-urile deschise într-o filă (chiar și după o repornire).

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = <b>Dă clic dreapta</b> pe fila pe care vrei să o fixezi.
cfr-doorhanger-pintab-step2 = Selectează <b>Fixează fila</b> din meniu.
cfr-doorhanger-pintab-step3 = Dacă site-ul are o actualizare, vei vedea un punct albastru pe fila fixată.
cfr-doorhanger-pintab-animation-pause = Pauză
cfr-doorhanger-pintab-animation-resume = Continuă

## Firefox Accounts Message

cfr-doorhanger-bookmark-fxa-header = Sincronizează-ți marcajele oriunde ai fi
cfr-doorhanger-bookmark-fxa-body = Descoperire grozavă! Acum, ca să nu rămâi fără acest marcaj pe dispozitivele tale mobile, începe să folosești un { -fxaccount-brand-name }.
cfr-doorhanger-bookmark-fxa-link-text = Sincronizează marcajele acum...
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = Buton de închidere
    .title = Închidere

## Protections panel

cfr-protections-panel-header = Navighează fără să fii urmărit(ă)
cfr-protections-panel-body = Păstrează-ți datele pentru tine. { -brand-short-name } te protejează de multe dintre cele mai frecvente elemente de urmărire care monitorizează ce faci online.
cfr-protections-panel-link-text = Află mai multe

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = Funcționalitate nouă:
cfr-whatsnew-button =
    .label = Ce este nou
    .tooltiptext = Ce este nou
cfr-whatsnew-panel-header = Ce este nou
cfr-whatsnew-release-notes-link-text = Citește notele privind versiunea
cfr-whatsnew-fx70-title = { -brand-short-name } acum luptă și mai mult pentru protecția vieții tale private
cfr-whatsnew-fx70-body = Ultima actualizare sporește funcția de Protecție împotriva urmării și face mai ușoară ca niciodată crearea de parole securizate pentru fiecare site.
cfr-whatsnew-tracking-protect-title = Protejează-te împotriva elementelor de urmărire
cfr-whatsnew-tracking-protect-body = { -brand-short-name } blochează multe elemente frecvente de urmărire ale rețelelor socializare și între site-uri care îți urmăresc acțiunile online.
cfr-whatsnew-tracking-protect-link-text = Vezi raportul
# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
        [one] element de urmărire blocat
        [few] elemente de urmărire blocate
       *[other] de elemente de urmărire blocate
    }
cfr-whatsnew-tracking-blocked-subtitle = Din { DATETIME($earliestDate, month: "long", year: "numeric") }
cfr-whatsnew-tracking-blocked-link-text = Vezi raportul
cfr-whatsnew-lockwise-backup-title = Creează o copie de siguranță cu parolele
cfr-whatsnew-lockwise-backup-body = Acum generează parole securizate pe care le poți accesa de oriunde te conectezi.
cfr-whatsnew-lockwise-backup-link-text = Activează crearea de copii de siguranță
cfr-whatsnew-lockwise-take-title = Ia-ți parolele cu tine
cfr-whatsnew-lockwise-take-body = Aplicația pentru dispozitive mobile { -lockwise-brand-short-name } îți permite să îți accesezi în siguranță parolele cărora le-ai făcut backup, oriunde te-ai afla.
cfr-whatsnew-lockwise-take-link-text = Obține aplicația

## Search Bar

cfr-whatsnew-searchbar-title = Tastezi mai puțin, găsești mai multe cu bara de adrese
cfr-whatsnew-searchbar-body-topsites = Acum, trebuie doar să selectezi bara de adrese și o casetă se va extinde cu linkuri către site-urile tale de top.
cfr-whatsnew-searchbar-icon-alt-text = Pictogramă lupă

## Picture-in-Picture

cfr-whatsnew-pip-header = Urmărești videoclipuri în timp ce navighezi
cfr-whatsnew-pip-body = Funcția de imagine-în-imagine inserează videoclipul într-o fereastră flotantă ca să îl poți vedea în timp ce lucrezi în alte file.
cfr-whatsnew-pip-cta = Află mai multe

## Permission Prompt

cfr-whatsnew-permission-prompt-header = Mai puține ferestre contextuale iritante pe site-uri
cfr-whatsnew-permission-prompt-body = { -brand-shorter-name } acum blochează site-urile ca să te mai întrebe automat să îți trimită mesaje contextuale.
cfr-whatsnew-permission-prompt-cta = Află mai multe

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header =
    { $fingerprinterCount ->
        [one] Generator de amprente digitale blocat
        [few] Generatoare de amprente digitale blocate
       *[other] Generatoare de amprente digitale blocate
    }
cfr-whatsnew-fingerprinter-counter-body = { -brand-shorter-name } blochează multe generatoare de amprente digitale, care adună în secret informații despre dispozitivul și acțiunile tale ca să creeze un profil de publicitate despre tine.
# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = Generatoare de amprente digitale
cfr-whatsnew-fingerprinter-counter-body-alt = { -brand-shorter-name } poate bloca generatoarele de amprente digitale care adună în secret informații despre dispozitivul și acțiunile tale ca să creeze un profil de publicitate despre tine.

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = Obține acest marcaj pe telefon
cfr-doorhanger-sync-bookmarks-body = Ia-ți cu tine marcajele, parolele, istoricul și multe altele oriunde ești autentificat(ă) în { -brand-product-name }.
cfr-doorhanger-sync-bookmarks-ok-button = Activează  { -sync-brand-short-name }
    .accesskey = T

## Login Sync

cfr-doorhanger-sync-logins-header = Nu mai pierde niciodată vreo parolă
cfr-doorhanger-sync-logins-body = Stochează-ți și sincronizează-ți parolele în siguranță pe toate dispozitivele.
cfr-doorhanger-sync-logins-ok-button = Activează { -sync-brand-short-name }
    .accesskey = T

## Send Tab

cfr-doorhanger-send-tab-header = Citește din mers
cfr-doorhanger-send-tab-recipe-header = Du această rețetă în bucătărie
cfr-doorhanger-send-tab-body = Send Tabs îți permite să partajezi ușor acest link pe telefon sau oriunde te conectezi la { -brand-product-name }.
cfr-doorhanger-send-tab-ok-button = Încearcă Send Tab
    .accesskey = T

## Firefox Send

cfr-doorhanger-firefox-send-header = Partajează în siguranță acest PDF
cfr-doorhanger-firefox-send-body = Păstrează-ți documentele sensibile în siguranță și protejate de ochii indiscreți cu o criptare end-to-end și un link ce dispare când ai terminat.
cfr-doorhanger-firefox-send-ok-button = Încearcă { -send-brand-name }
    .accesskey = T

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = Vezi protecțiile
    .accesskey = P
cfr-doorhanger-socialtracking-close-button = Închide
    .accesskey = C
cfr-doorhanger-socialtracking-dont-show-again = Nu mai afișa mesaje de acest gen
    .accesskey = D
cfr-doorhanger-socialtracking-heading = { -brand-short-name } a împiedicat o rețea de socializare care voia să te urmărească aici
cfr-doorhanger-socialtracking-description = Confidențialitatea ta contează. { -brand-short-name } acum blochează elementele de urmărire prezente frecvent pe mediile de socializare, limitând cât de multe date pot colecta despre ce faci tu online.
cfr-doorhanger-fingerprinters-heading = { -brand-short-name } a blocat un generator de amprente digitale de pe această pagină
cfr-doorhanger-fingerprinters-description = Confidențialitatea ta contează. { -brand-short-name } acum blochează generatoarele de amprente digitale, care colectează informații de identificare unică despre dispozitivul tău ca să te urmărească.
cfr-doorhanger-cryptominers-heading = { -brand-short-name } a blocat un criptominer de pe această pagină
cfr-doorhanger-cryptominers-description = Confidențialitatea ta contează. { -brand-short-name } blochează acum criptominerii, care folosesc puterea de calcul a sistemului tău ca să mineze după monede digitale.

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    { $blockedCount ->
        [one] { -brand-short-name } a blocat peste <b>{ $blockedCount }</b> element de urmărire din { $date }!
        [few] { -brand-short-name } a blocat peste <b>{ $blockedCount }</b> elemente de urmărire din { $date }!
       *[other] { -brand-short-name } a blocat peste <b>{ $blockedCount }</b> de elemente de urmărire din { $date }!
    }
cfr-doorhanger-milestone-ok-button = Afișează tot
    .accesskey = S
cfr-doorhanger-milestone-close-button = Închide
    .accesskey = C

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = Creează ușor parole securizate
cfr-whatsnew-lockwise-body = Nu e ușor să te gândești la parole unice și sigure pentru fiecare cont. La crearea unei parole, selectează câmpul de parolă pentru a utiliza o parolă securizată, generată de { -brand-shorter-name }.
cfr-whatsnew-lockwise-icon-alt = Pictogramă { -lockwise-brand-short-name }

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = Obține alerte despre parole vulnerabile
cfr-whatsnew-passwords-body = Hackerii știu că oamenii refolosesc parolele. Dacă ai folosit aceeași parolă pe mai multe site-uri și unul dintre acele site-uri a fost implicat într-o încălcare a securității datelor, vei vedea o alertă în { -lockwise-brand-short-name } ca să îți schimbi parola pe acele site-uri.
cfr-whatsnew-passwords-icon-alt = Pictogramă de parolă vulnerabilă

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-header = Folosește modul imagine-în-imagine pe tot ecranul
cfr-whatsnew-pip-fullscreen-body = Când deschizi un videoclip într-o fereastră flotantă, poți da dublu clic pe ea ca să o vezi pe tot ecranul.
cfr-whatsnew-pip-fullscreen-icon-alt = Pictogramă de imagine-în-imagine

## Protections Dashboard message

cfr-whatsnew-protections-header = Protecții dintr-o privite
cfr-whatsnew-protections-body = Tablou de bord privind protecțiile include rapoarte sumare despre încălcările securității datelor și gestionarea parolelor. Acum poți urmări câte încălcări ai rezolvat și poți vedea dacă parolele salvate ți-au fost expuse într-o încălcare a securității datelor.
cfr-whatsnew-protections-cta-link = Vezi tabloul de bord privind protecțiile
cfr-whatsnew-protections-icon-alt = Pictogramă de scut

## Better PDF message

cfr-whatsnew-better-pdf-header = O experiență PDF mai bună
cfr-whatsnew-better-pdf-body = Documentele PDF se deschid acum direct din { -brand-short-name }, pentru a avea la îndemână fluxul de lucru.

## DOH Message

cfr-doorhanger-doh-body = Confidențialitatea ta contează. { -brand-short-name } îți rutează acum securizat cererile DNS ori de câte ori este posibil către un serviciu partener pentru a te proteja în timpul navigării.
cfr-doorhanger-doh-header = Căutări DNS criptate, mai securizate
cfr-doorhanger-doh-primary-button = OK, am înțeles
    .accesskey = O
cfr-doorhanger-doh-secondary-button = Dezactivează
    .accesskey = D

## What's new: Cookies message

cfr-whatsnew-clear-cookies-header = Protecție automată împotriva tacticilor insidioase de urmărire
cfr-whatsnew-clear-cookies-body = Unele elemente de urmărire te redirecționează pe alte site-uri web care setează cookie-uri în secret. Acum, { -brand-short-name } elimină automat aceste cookie-uri ca să nu poți fi urmărit(ă).
cfr-whatsnew-clear-cookies-image-alt = Ilustrație de cookie blocat
