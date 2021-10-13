# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

close-button =
    .aria-label = Bezárás

preferences-doc-title = Beállítások

category-list =
    .aria-label = Kategóriák

pane-general-title = Általános
category-general =
    .tooltiptext = { pane-general-title }

pane-compose-title = Szerkesztés
category-compose =
    .tooltiptext = Szerkesztés

pane-privacy-title = Adatvédelem és biztonság
category-privacy =
    .tooltiptext = Adatvédelem és biztonság

pane-chat-title = Csevegés
category-chat =
    .tooltiptext = Csevegés

pane-calendar-title = Naptár
category-calendar =
    .tooltiptext = Naptár

general-language-and-appearance-header = Nyelv és megjelenés

general-incoming-mail-header = Bejövő levelek

general-files-and-attachment-header = Fájlok és mellékletek

general-tags-header = Címkék

general-reading-and-display-header = Olvasás és megjelenítés

general-updates-header = Frissítések

general-network-and-diskspace-header = Hálózat és lemezterület

general-indexing-label = Indexelés

composition-category-header = Szerkesztés

composition-attachments-header = Mellékletek

composition-spelling-title = Helyesírás

compose-html-style-title = HTML stílus

composition-addressing-header = Címzés

privacy-main-header = Adatvédelem

privacy-passwords-header = Jelszavak

privacy-junk-header = Levélszemét

collection-header = { -brand-short-name } adatgyűjtés és felhasználás

collection-description = Arra törekszünk, hogy választást biztosítsunk, és csak azt gyűjtsük, amire szükségünk a van a { -brand-short-name } fejlesztéséhez, mindenki számára. Mindig engedélyt kérünk, mielőtt személyes információkat fogadunk.
collection-privacy-notice = Adatvédelmi nyilatkozat

collection-health-report-telemetry-disabled = Már nem engedélyezi, hogy a { -vendor-short-name } műszaki és interakciós adatokat rögzítsen. A múltbeli adatai 30 napon belül törölve lesznek.
collection-health-report-telemetry-disabled-link = További tudnivalók

collection-health-report =
    .label = Engedélyezés, hogy a { -brand-short-name } műszaki és interakciós adatokat küldjön a { -vendor-short-name } számára
    .accesskey = r
collection-health-report-link = További tudnivalók

# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = Az adatjelentés le lett tiltották ennél az összeállítási konfigurációnál

collection-backlogged-crash-reports =
    .label = A { -brand-short-name } a háttérben küldhet összeomlási jelentéseket az Ön nevében
    .accesskey = s
collection-backlogged-crash-reports-link = További tudnivalók

privacy-security-header = Biztonság

privacy-scam-detection-title = Átverésészlelés

privacy-anti-virus-title = Antivírus

privacy-certificates-title = Tanúsítványok

chat-pane-header = Csevegés

chat-status-title = Állapot

chat-notifications-title = Értesítések

chat-pane-styling-header = Stíluskezelés

choose-messenger-language-description = Válassza ki a { -brand-short-name } menüijeinek, üzeneteinek és értesítéseinek megjelenítési nyelvét
manage-messenger-languages-button =
    .label = Alternatívák beállítása…
    .accesskey = l
confirm-messenger-language-change-description = Indítsa újra a { -brand-short-name }öt a változások érvényesítéséhez
confirm-messenger-language-change-button = Alkalmaz és újraindítás

update-setting-write-failure-title = Hiba történt a frissítési beállítások mentésekor

# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    A { -brand-short-name } hibát észlelt, és nem mentette ezt a változtatást. Ne feledje, hogy ezen frissítési beállítás megadásához írási engedély szükségesen a lenti fájlon. Ön vagy a rendszergazdája megoldhatja a hibát azzal, hogy a Felhasználók csoportnak teljes jogosultságot ad a fájlhoz.
    
    Nem sikerült a fájlba írni: { $path }

update-in-progress-title = Frissítés folyamatban

update-in-progress-message = Szeretné, hogy a { -brand-short-name } folytassa ezt a frissítést?

update-in-progress-ok-button = &Elvetés
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Folytatás

account-button = Fiókbeállítások
open-addons-sidebar-button = Kiegészítők és témák

## OS Authentication dialog

# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Elsődleges jelszó létrehozásához írja be a Windows bejelentkezési hitelesítő adatait. Ez elősegíti a fiókjai biztonságának védelmét.

# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = elsődleges jelszó létrehozása

# Don't change this label.
master-password-os-auth-dialog-caption = { -brand-full-name }

## General Tab

focus-search-shortcut =
    .key = f
focus-search-shortcut-alt =
    .key = k

general-legend = { -brand-short-name } kezdőoldal

start-page-label =
    .label = Kezdőoldal betöltése az üzenetek helyére a { -brand-short-name } indításakor
    .accesskey = K

location-label =
    .value = Hely:
    .accesskey = H
restore-default-label =
    .label = Alaphelyzet
    .accesskey = A

default-search-engine = Alapértelmezett keresőszolgáltatás
add-search-engine =
    .label = Hozzáadás fájlból
    .accesskey = a
remove-search-engine =
    .label = Eltávolítás
    .accesskey = E

minimize-to-tray-label =
    .label = Ha a { -brand-short-name } minimalizálva van, áthelyezés a tálcára
    .accesskey = m

new-message-arrival = Új üzenet érkezésekor:
mail-play-sound-label =
    .label =
        { PLATFORM() ->
            [macos] A következő hangfájl lejátszása:
           *[other] Hangjelzés
        }
    .accesskey =
        { PLATFORM() ->
            [macos] h
           *[other] H
        }
mail-play-button =
    .label = Lejátszás
    .accesskey = L

change-dock-icon = Az appikon beállításainak módosítása
app-icon-options =
    .label = Appikon beállításai…
    .accesskey = A

notification-settings = Az értesítések és az alapértelmezett hang letilthatók a Rendszerbeállítások Értesítés lapján.

animated-alert-label =
    .label = Figyelmeztetés megjelenítése
    .accesskey = F
customize-alert-label =
    .label = Testreszabás…
    .accesskey = T

biff-use-system-alert =
    .label = Rendszerértesítés használata

tray-icon-unread-label =
    .label = Tálcaikon megjelenítése az olvasatlan üzenetekhez
    .accesskey = T

tray-icon-unread-description = Kis tálcagombok használatakor ajánlott

mail-system-sound-label =
    .label = Alapértelmezett rendszerhang az új üzenethez
    .accesskey = A
mail-custom-sound-label =
    .label = A következő hangfájl használata
    .accesskey = h
mail-browse-sound-button =
    .label = Tallózás…
    .accesskey = T

enable-gloda-search-label =
    .label = Globális keresés és indexelő engedélyezése
    .accesskey = G

datetime-formatting-legend = Dátum és idő formázás
language-selector-legend = Nyelv

allow-hw-accel =
    .label = Hardveres gyorsítás használata, ha elérhető
    .accesskey = H

store-type-label =
    .value = Üzenettároló és típus új fiókokhoz:
    .accesskey = z

mbox-store-label =
    .label = Egy fájl mappánként (mbox)
maildir-store-label =
    .label = Egy fájl üzenetenként (maildir)

scrolling-legend = Görgetés
autoscroll-label =
    .label = Automatikus görgetés
    .accesskey = u
smooth-scrolling-label =
    .label = Finom görgetés
    .accesskey = F

system-integration-legend = Integrálódás a rendszerbe
always-check-default =
    .label = Indításkor ellenőrzés, hogy a { -brand-short-name }-e az alapértelmezett levelező
    .accesskey = I
check-default-button =
    .label = Ellenőrzés most…
    .accesskey = E

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windows Search
       *[other] { "" }
    }

search-integration-label =
    .label = A(z) { search-engine-name } kereshet az üzenetek között
    .accesskey = s

config-editor-button =
    .label = Konfigurációszerkesztő…
    .accesskey = K

return-receipts-description = A { -brand-short-name } tértivevény-kezelésének beállítása
return-receipts-button =
    .label = Tértivevények…
    .accesskey = T

update-app-legend = { -brand-short-name } frissítések:

# Variables:
#   $version (String): version of Thunderbird, e.g. 68.0.1
update-app-version = Verzió: { $version }

allow-description = A { -brand-short-name } megteheti:
automatic-updates-label =
    .label = Frissítések automatikus telepítése (ez ajánlott a maximális biztonság érdekében)
    .accesskey = a
check-updates-label =
    .label = Frissítések keresése, de a telepítés kézzel történik
    .accesskey = k

update-history-button =
    .label = Frissítési előzmények megjelenítése
    .accesskey = z

use-service =
    .label = Háttérben futó szolgáltatás intézze a frissítést
    .accesskey = H

cross-user-udpate-warning = Ez a beállítás érvényes lesz minden Windows-fiókra és { -brand-short-name }-profilra, amely a { -brand-short-name } ezen telepítését használja.

networking-legend = Kapcsolat
proxy-config-description = A { -brand-short-name } internetkapcsolatának megadása

network-settings-button =
    .label = Beállítások…
    .accesskey = B

offline-legend = Kapcsolat nélküli munka
offline-settings = Kapcsolat nélküli munka beállításai

offline-settings-button =
    .label = Kapcsolat nélkül…
    .accesskey = K

diskspace-legend = Lemezterület
offline-compact-folder =
    .label = Minden mappa tömörítése, ha a megtakarított hely több lenne, mint
    .accesskey = t

offline-compact-folder-automatically =
    .label = Tömörítés előtt kérdezze meg minden alkalommal
    .accesskey = e

compact-folder-size =
    .value = MB összesen

## Note: The entities use-cache-before and use-cache-after appear on a single
## line in preferences as follows:
## use-cache-before [ textbox for cache size in MB ] use-cache-after

use-cache-before =
    .value = Legfeljebb
    .accesskey = L

use-cache-after = MB hely a gyorsítótárnak

##

smart-cache-label =
    .label = Az automatikus gyorsítótár-kezelés felülbírálása
    .accesskey = a

clear-cache-button =
    .label = Törlés most
    .accesskey = T

fonts-legend = Betűk és színek

default-font-label =
    .value = Alapértelmezett betű:
    .accesskey = b

default-size-label =
    .value = Méret:
    .accesskey = M

font-options-button =
    .label = Speciális…
    .accesskey = c

color-options-button =
    .label = Színek…
    .accesskey = n

display-width-legend = Normál szöveges levelek

# Note : convert-emoticons-label 'Emoticons' are also known as 'Smileys', e.g. :-)
convert-emoticons-label =
    .label = Hangulatjelek megjelenítése grafikaként
    .accesskey = H

display-text-label = A következő beállítások használata idézett szöveges levelek esetén:

style-label =
    .value = Stílus:
    .accesskey = t

regular-style-item =
    .label = Normál
bold-style-item =
    .label = Félkövér
italic-style-item =
    .label = Dőlt
bold-italic-style-item =
    .label = Félkövér dőlt

size-label =
    .value = Méret:
    .accesskey = M

regular-size-item =
    .label = Normál
bigger-size-item =
    .label = Nagyobb
smaller-size-item =
    .label = Kisebb

quoted-text-color =
    .label = Szín:
    .accesskey = z

search-handler-table =
    .placeholder = Tartalomtípusok és műveletek szűrése

type-column-label =
    .label = Tartalomtípus
    .accesskey = T

action-column-label =
    .label = Művelet
    .accesskey = M

save-to-label =
    .label = Fájlok mentése
    .accesskey = m

choose-folder-label =
    .label =
        { PLATFORM() ->
            [macos] Tallózás…
           *[other] Tallózás…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] T
           *[other] T
        }

always-ask-label =
    .label = Rákérdezés a fájlok letöltési helyére
    .accesskey = R


display-tags-text = A címkék az üzenetek kategorizálására és priorálására használhatók.

new-tag-button =
    .label = Új…
    .accesskey = j

edit-tag-button =
    .label = Szerkesztés…
    .accesskey = z

delete-tag-button =
    .label = Törlés
    .accesskey = T

auto-mark-as-read =
    .label = Üzenetek automatikus megjelölése olvasottként
    .accesskey = a

mark-read-no-delay =
    .label = Megjelenítéskor azonnal
    .accesskey = M

## Note: This will concatenate to "After displaying for [___] seconds",
## using (mark-read-delay) and a number (seconds-label).

mark-read-delay =
    .label = Megjelenítés után
    .accesskey = e

seconds-label = másodperc

##

open-msg-label =
    .value = Üzenetek megnyitása:

open-msg-tab =
    .label = Új üzenetlapon
    .accesskey = l

open-msg-window =
    .label = Új üzenetablakban
    .accesskey = z

open-msg-ex-window =
    .label = Létező üzenetablakban
    .accesskey = l

close-move-delete =
    .label = Üzenetablak/-lap bezárása áthelyezéskor vagy törléskor
    .accesskey = z

display-name-label =
    .value = Megjelenítendő név:

condensed-addresses-label =
    .label = Csak a név megjelenítése a címjegyzékben szereplő személyeknél
    .accesskey = C

## Compose Tab

forward-label =
    .value = Levél továbbítása:
    .accesskey = L

inline-label =
    .label = Beágyazva

as-attachment-label =
    .label = Mellékletként

extension-label =
    .label = kiterjesztés hozzáadása a fájlnévhez
    .accesskey = K

## Note: This will concatenate to "Auto Save every [___] minutes",
## using (auto-save-label) and a number (auto-save-end).

auto-save-label =
    .label = Automatikus mentés
    .accesskey = A

auto-save-end = percenként

##

warn-on-send-accel-key =
    .label = Jóváhagyás kérése gyorsbillentyűvel végzett levélküldéskor
    .accesskey = J

spellcheck-label =
    .label = Helyesírás ellenőrzése küldés előtt
    .accesskey = H

spellcheck-inline-label =
    .label = Helyesírás ellenőrzése beírás közben
    .accesskey = E

language-popup-label =
    .value = Nyelv:
    .accesskey = N

download-dictionaries-link = További szótárak letöltése

font-label =
    .value = Betű:
    .accesskey = B

font-size-label =
    .value = Méret:
    .accesskey = M

default-colors-label =
    .label = Az olvasó alapértelmezett színeinek használata
    .accesskey = a

font-color-label =
    .value = Szövegszín:
    .accesskey = z

bg-color-label =
    .value = Háttérszín:
    .accesskey = H

restore-html-label =
    .label = Alapértelmezett értékek visszaállítása
    .accesskey = A

default-format-label =
    .label = Alapértelmezésben a Bekezdés formátum használata Szövegtörzs helyett
    .accesskey = B

format-description = Szövegformátum beállítása

send-options-label =
    .label = Üzenetküldési beállítások…
    .accesskey = b

autocomplete-description = Üzenetek címzésekor egyezések keresése a következő helyeken:

ab-label =
    .label = Helyi címjegyzékek
    .accesskey = H

directories-label =
    .label = Címtárkiszolgáló:
    .accesskey = C

directories-none-label =
    .none = Nincs

edit-directories-label =
    .label = Címtárak szerkesztése…
    .accesskey = C

email-picker-label =
    .label = A kimenő levelek címeinek automatikus hozzáadása:
    .accesskey = e

default-directory-label =
    .value = Alapértelmezett indítási könyvtár a címjegyzék ablakban:
    .accesskey = d

default-last-label =
    .none = Utoljára használt könyvtár

attachment-label =
    .label = Figyelmeztetés a hiányzó mellékletekre
    .accesskey = m

attachment-options-label =
    .label = Kulcsszavak…
    .accesskey = K

enable-cloud-share =
    .label = Fájlmegosztás ajánlása, ha a fájl nagyobb, mint
cloud-share-size =
    .value = MB

add-cloud-account =
    .label = Hozzáadás…
    .accesskey = H
    .defaultlabel = Hozzáadás…

remove-cloud-account =
    .label = Eltávolítás
    .accesskey = E

find-cloud-providers =
    .value = További szolgáltatók keresése…

cloud-account-description = Adjon hozzá új óriásfájl-küldési tárolószolgáltatást


## Privacy Tab

mail-content = Levéltartalom

remote-content-label =
    .label = Távoli tartalom engedélyezése az üzenetekben
    .accesskey = T

exceptions-button =
    .label = Kivételek…
    .accesskey = v

remote-content-info =
    .value = Tudjon meg többet a távoli tartalommal kapcsolatos adatvédelmi problémákról

web-content = Webtartalom

history-label =
    .label = Meglátogatott webhelyek és hivatkozások megjegyzése
    .accesskey = z

cookies-label =
    .label = Sütik elfogadása webhelyekről
    .accesskey = w

third-party-label =
    .value = Harmadik féltől származó sütik elfogadása:
    .accesskey = H

third-party-always =
    .label = Mindig
third-party-never =
    .label = Soha
third-party-visited =
    .label = Meglátogatottól

keep-label =
    .value = Sütik megtartása:
    .accesskey = m

keep-expire =
    .label = amíg le nem járnak
keep-close =
    .label = a { -brand-short-name } bezárásáig
keep-ask =
    .label = megerősítés minden alkalommal

cookies-button =
    .label = Sütik megtekintése…
    .accesskey = t

do-not-track-label =
    .label = „Do Not Track” jelzés küldése a webhelyeknek, jelezve, hogy nem szeretné, hogy kövessék
    .accesskey = n

learn-button =
    .label = További tudnivalók

passwords-description = A { -brand-short-name } képes megjegyezni az összes fiók jelszavát.

passwords-button =
    .label = Mentett jelszavak…
    .accesskey = e


primary-password-description = Az elsődleges jelszó az összes jelszót védi. Minden munkamenet során egyszer meg kell adni.

primary-password-label =
    .label = Elsődleges jelszó használata
    .accesskey = E

primary-password-button =
    .label = Elsődleges jelszó megváltoztatása…
    .accesskey = m

forms-primary-pw-fips-title = Jelenleg FIPS-módban van. A FIPS-hez nem üres elsődleges jelszó szükséges.
forms-master-pw-fips-desc = Sikertelen jelszóváltoztatás


junk-description = Az alapértelmezett levélszemét-kezelés beállítása. A postafiókra jellemző levélszemét-kezelés beállításait a Postafiókok beállításai alatt végezheti el.

junk-label =
    .label = A levélszemét kézi megjelölésekor:
    .accesskey = k

junk-move-label =
    .label = Áthelyezés a postafiók „Szemét” mappájába
    .accesskey = h

junk-delete-label =
    .label = Törlés
    .accesskey = T

junk-read-label =
    .label = A szemétként megjelölt levelek megjelölése olvasottként
    .accesskey = o

junk-log-label =
    .label = Adaptív levélszemétszűrő-naplózás engedélyezése
    .accesskey = A

junk-log-button =
    .label = Napló megjelenítése
    .accesskey = N

reset-junk-button =
    .label = Tanulási adatok törlése
    .accesskey = T

phishing-description = A { -brand-short-name } képes elemezni az üzeneteket, és kiszűrni a leggyakrabban használt trükköket, amelyekkel Önt becsaphatják.

phishing-label =
    .label = Figyelmeztetés a gyanús e-mailekre
    .accesskey = F

antivirus-description = A { -brand-short-name } könnyen lehetővé teszi a vírusellenes szoftverek számára a bejövő üzenetek ellenőrzését, még mielőtt helyileg tárolná azokat.

antivirus-label =
    .label = A vírusellenes szoftverek karanténba tehetik a bejövő üzeneteket
    .accesskey = v

certificate-description = Ha a kiszolgáló elkéri a személyes tanúsítványt:

certificate-auto =
    .label = Automatikus választás
    .accesskey = u

certificate-ask =
    .label = Megerősítés minden alkalommal
    .accesskey = M

ocsp-label =
    .label = Az OCSP válaszoló kiszolgálók lekérdezése a tanúsítványok érvényességének megerősítéséhez
    .accesskey = C

certificate-button =
    .label = Tanúsítványok kezelése…
    .accesskey = T

security-devices-button =
    .label = Biztonsági eszközök…
    .accesskey = B

## Chat Tab

startup-label =
    .value = A { -brand-short-name } indításakor:
    .accesskey = s

offline-label =
    .label = A csevegőfiókok kapcsolat nélküli módban legyenek

auto-connect-label =
    .label = Automatikus csatlakozás a csevegőfiókokhoz

## Note: idle-label is displayed first, then there's a field where the user
## can enter a number, and itemTime is displayed at the end of the line.
## The translations of the idle-label and idle-time-label parts don't have
## to mean the exact same thing as in English; please try instead to
## translate the whole sentence.

idle-label =
    .label = Partnereim értesítése tétlen állapotomról
    .accesskey = P

idle-time-label = perc tétlenség után

##

away-message-label =
    .label = Az állapotom beállítása távollevőre ezzel az üzenettel:
    .accesskey = A

send-typing-label =
    .label = A beszélgetések során értesítés küldése a gépelésről
    .accesskey = k

notification-label = Önnek címzett új üzenet érkezésekor:

show-notification-label =
    .label = Értesítés megjelenítése:
    .accesskey = r

notification-all =
    .label = feladó nevével és az üzenet előnézetével
notification-name =
    .label = csak a feladó nevével
notification-empty =
    .label = információ nélkül

notification-type-label =
    .label =
        { PLATFORM() ->
            [macos] Dokkolóikon animálása
           *[other] A tálca elem felvillantása
        }
    .accesskey =
        { PLATFORM() ->
            [macos] o
           *[other] f
        }

chat-play-sound-label =
    .label = Hangjelzés
    .accesskey = H

chat-play-button =
    .label = Lejátszás
    .accesskey = L

chat-system-sound-label =
    .label = Alapértelmezett rendszerhang az új üzenethez
    .accesskey = A

chat-custom-sound-label =
    .label = A következő hangfájl használata
    .accesskey = v

chat-browse-sound-button =
    .label = Tallózás…
    .accesskey = T

theme-label =
    .value = Téma:
    .accesskey = T

style-thunderbird =
    .label = Thunderbird
style-bubbles =
    .label = Buborékok
style-dark =
    .label = Sötét
style-paper =
    .label = Papírlapok
style-simple =
    .label = Egyszerű

preview-label = Előnézet:
no-preview-label = Nem érhető el előnézet
no-preview-description = Ez a téma nem érvényes, vagy jelenleg nem érhető el (letiltott kiegészítő, biztonságos mód, …).

chat-variant-label =
    .value = Változat:
    .accesskey = V

# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-preferences-input =
    .style = width: 15.4em
    .placeholder = Keresés a Beállításokban

## Preferences UI Search Results

search-results-header = Találatok

# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] Elnézését, nincs találat a Beállítások közt erre: „<span data-l10n-name="query"></span>”.
       *[other] Elnézését, nincs találat a Beállítások közt erre: „<span data-l10n-name="query"></span>”.
    }

search-results-help-link = Segítségre van szüksége? Látogasson el ide: <a data-l10n-name="url">{ -brand-short-name } támogatás</a>
