# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

close-button =
    .aria-label = Mbylle

preferences-title =
    .title =
        { PLATFORM() ->
            [windows] Mundësi
           *[other] Parapëlqime
        }

pane-general-title = Të përgjithshme
category-general =
    .tooltiptext = { pane-general-title }

pane-compose-title = Hartim
category-compose =
    .tooltiptext = Hartim

pane-privacy-title = Privatësi & Siguri
category-privacy =
    .tooltiptext = Privatësi & Siguri

pane-chat-title = Fjalosje
category-chat =
    .tooltiptext = Fjalosje

pane-calendar-title = Kalendar
category-calendar =
    .tooltiptext = Kalendar

general-language-and-appearance-header = Gjuhë & Dukje

general-incoming-mail-header = Email-e Ardhëse

general-files-and-attachment-header = Kartela & Bashkëngjitje

general-tags-header = Etiketa

general-reading-and-display-header = Lexim & Shfaqje

general-updates-header = Përditësime

general-network-and-diskspace-header = Hapësirë në Rrjet & Disk

general-indexing-label = Indeksim

composition-category-header = Hartim

composition-attachments-header = Bashkëngjitje

composition-spelling-title = Drejtshkrim

compose-html-style-title = Stil HTML

composition-addressing-header = Adresim

privacy-main-header = Privatësi

privacy-passwords-header = Fjalëkalime

privacy-junk-header = E pavlerë

collection-header = Grumbullim dhe Përdorim të Dhënash nga { -brand-short-name }-i

collection-description = Përpiqemi t’ju japim mundësi zgjedhjesh dhe grumbullojmë vetëm ç’na duhet për të ofruar dhe përmirësuar { -brand-short-name }-in për këdo. Kërkojmë përherë leje, përpara se të marrim të dhëna personale.
collection-privacy-notice = Shënim Mbi Privatësinë

collection-health-report-telemetry-disabled = S’e lejoni më { -vendor-short-name } të marrë të dhëna teknike dhe ndërveprimesh. Krejt të dhënat e dikurshme do të fshihen brenda 30 ditësh.
collection-health-report-telemetry-disabled-link = Mësoni më tepër

collection-health-report =
    .label = Lejojeni { -brand-short-name }-in të dërgojë te { -vendor-short-name } të dhëna teknike dhe ndërveprimesh
    .accesskey = L
collection-health-report-link = Mësoni më tepër

# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = Raportimi i të dhënave është i çaktivizuar për këtë formësim montimi

collection-backlogged-crash-reports =
    .label = Lejojeni { -brand-short-name }-in të dërgojë njoftime të dikurshme vithisjesh në emrin tuaj
    .accesskey = v
collection-backlogged-crash-reports-link = Mësoni më tepër

privacy-security-header = Siguri

privacy-scam-detection-title = Pikasje Mashtrimesh

privacy-anti-virus-title = Antivirus

privacy-certificates-title = Dëshmi

chat-pane-header = Fjalosje

chat-status-title = Gjendje

chat-notifications-title = Njoftime

chat-pane-styling-header = Stilizim

choose-messenger-language-description = Zgjidhni gjuhët e përdorura për shfaqje menush, mesazhesh, dhe njoftimesh nga { -brand-short-name }-i.
manage-messenger-languages-button =
    .label = Caktoni Alternativa…
    .accesskey = C
confirm-messenger-language-change-description = Që të hyjnë në fuqi këto ndryshime, rinisni { -brand-short-name }-in
confirm-messenger-language-change-button = Zbatoje dhe Rinisu

update-setting-write-failure-title = Gabim në ruajtje parapëlqimesh Përditësimi

# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    { -brand-short-name }-i hasi një gabim dhe s’e ruajti këtë ndryshim. Kini parasysh se caktimi i këtij parapëlqimi mbi përditësimet lyp leje për shkrim te kartela më poshtë. Ju, ose një përgjegjës sistemi mund të jeni në gjendje ta zgjidhni gabimin duke i akorduar grupit Përdorues kontroll të plotë të kësaj kartele.
    
    S’u shkrua dot në kartelë: { $path }

update-in-progress-title = Përditësim Në Kryerje e Sipër

update-in-progress-message = Doni që { -brand-short-name }-i të vazhdojë këtë përditësim?

update-in-progress-ok-button = &Hidhe Tej
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Vazhdo

addons-button = Zgjerimet & Tema

## OS Authentication dialog

# This message can be seen by trying to add a Master Password.
master-password-os-auth-dialog-message-win = Që të krijoni një Fjalëkalim të Përgjithshëm, jepni kredencialet tuaj për hyrje në Windows. Kjo ndihmon të mbrohet siguria e llogarive tuaja.

# This message can be seen by trying to add a Master Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
master-password-os-auth-dialog-message-macosx = të krijojë një Fjalëkalim të Përgjithshëm

# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Që të krijoni një Fjalëkalim të Përgjithshëm, jepni kredencialet tuaj për hyrje në Windows. Kjo ndihmon të mbrohet siguria e llogarive tuaja.

# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = të krijojë një Fjalëkalim të Përgjithshëm

# Don't change this label.
master-password-os-auth-dialog-caption = { -brand-full-name }

## General Tab

focus-search-shortcut =
    .key = f
focus-search-shortcut-alt =
    .key = k

general-legend = Faqe Fillimi për { -brand-short-name }-in

start-page-label =
    .label = Kur niset { -brand-short-name }-i, te fusha e mesazheve shfaq Faqen e Fillimit
    .accesskey = K

location-label =
    .value = Vendndodhje:
    .accesskey = V
restore-default-label =
    .label = Rimerr Parazgjedhjet
    .accesskey = R

default-search-engine = Motor Parazgjedhje Kërkimesh
add-search-engine =
    .label = Shtoni prej kartele
    .accesskey = S
remove-search-engine =
    .label = Hiqe
    .accesskey = q

minimize-to-tray-label =
    .label = Kur minimizohet { -brand-short-name }-i, shpjere te shtylla
    .accesskey = m

new-message-arrival = Kur mbërrijnë mesazhe të rinj:
mail-play-sound-label =
    .label =
        { PLATFORM() ->
            [macos] Luaj kartelën tingull vijuese:
           *[other] Luaj një tingull
        }
    .accesskey =
        { PLATFORM() ->
            [macos] i
           *[other] L
        }
mail-play-button =
    .label = Luaje
    .accesskey = u

change-dock-icon = Ndryshoni parapëlqimet për ikonën e aplikacionit
app-icon-options =
    .label = Mundësi Ikone Aplikacioni…
    .accesskey = M

notification-settings = Sinjalizimet dhe tingulli parazgjedhje mund të çaktivizohen te pjesa Njoftime në Parapëlqime Sistemi.

animated-alert-label =
    .label = Shfaq një sinjalizim
    .accesskey = S
customize-alert-label =
    .label = Përshtateni…
    .accesskey = P

tray-icon-label =
    .label = Shfaq ikonë paneli
    .accesskey = p

mail-system-sound-label =
    .label = Tingull parazgjedhje sistemi për postë të re
    .accesskey = p
mail-custom-sound-label =
    .label = Përdor kartelën zanore vijuese
    .accesskey = o
mail-browse-sound-button =
    .label = Shfletoni…
    .accesskey = f

enable-gloda-search-label =
    .label = Aktivizo Kërkim dhe Indeksues Global
    .accesskey = A

datetime-formatting-legend = Formatim Datash dhe Kohe
language-selector-legend = Gjuhë

allow-hw-accel =
    .label = Përdor përshpejtim hardware kur mundet
    .accesskey = h

store-type-label =
    .value = Lloj Depoje Mesazhesh për llogari të reja:
    .accesskey = L

mbox-store-label =
    .label = Një kartelë për dosje (mbox)
maildir-store-label =
    .label = Një kartelë për mesazh (maildir)

scrolling-legend = Rrëshqitje
autoscroll-label =
    .label = Përdor vetërrëshqitje
    .accesskey = v
smooth-scrolling-label =
    .label = Përdor rrëshqitje të butë
    .accesskey = b

system-integration-legend = Integrim me Sistemin
always-check-default =
    .label = Gjatë nisjes, kontrollo përherë nëse është apo jo { -brand-short-name }-i klienti parazgjedhje për postën
    .accesskey = G
check-default-button =
    .label = Kontrolloni Tani…
    .accesskey = K

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windows Search
       *[other] { "" }
    }

search-integration-label =
    .label = Lejo { search-engine-name }-n të kërkojë në mesazhe
    .accesskey = L

config-editor-button =
    .label = Përpunues Formësimesh…
    .accesskey = P

return-receipts-description = Përcaktoni se si i trajton { -brand-short-name }-i faturat e kthimit
return-receipts-button =
    .label = Fatura Kthimi…
    .accesskey = F

update-app-legend = Përditësime { -brand-short-name }-i

# Variables:
#   $version (String): version of Thunderbird, e.g. 68.0.1
update-app-version = Version { $version }

allow-description = Lejojeni { -brand-short-name }-in të
automatic-updates-label =
    .label = Instaloji vetvetiu përditësimet (e këshillueshme: përmirësohet siguria)
    .accesskey = v
check-updates-label =
    .label = Kontrollo për përditësime, por lejomë të zgjedh t'i instaloj apo jo
    .accesskey = K

update-history-button =
    .label = Shfaq Historik Përditësimesh
    .accesskey = H

use-service =
    .label = Për instalim përditësimesh përdor një shërbim në prapaskenë
    .accesskey = i

cross-user-udpate-warning = Ky rregullim do të zbatohet mbi krejt llogaritë Windows dhe profilet { -brand-short-name } që përdorin këtë instalim të { -brand-short-name }-it.

networking-legend = Lidhje
proxy-config-description = Formësoni mënyrën se si { -brand-short-name }-i lidhet në Internet

network-settings-button =
    .label = Rregullime…
    .accesskey = R

offline-legend = Jo në linjë
offline-settings = Formësoni rregullimet për jo në linjë

offline-settings-button =
    .label = Jo në linjë…
    .accesskey = J

diskspace-legend = Hapësirë Disku
offline-compact-folder =
    .label = Ngjeshi krejt dosjet kur kjo sjell kursim vendi
    .accesskey = N

compact-folder-size =
    .value = MB gjithsej

## Note: The entities use-cache-before and use-cache-after appear on a single
## line in preferences as follows:
## use-cache-before [ textbox for cache size in MB ] use-cache-after

use-cache-before =
    .value = Përdor deri më
    .accesskey = d

use-cache-after = MB hapësirë për fshehtinën

##

smart-cache-label =
    .label = Anashkalo administrim të vetvetishëm fshehtine
    .accesskey = A

clear-cache-button =
    .label = Spastroje Tani
    .accesskey = P

fonts-legend = Shkronja & Ngjyra

default-font-label =
    .value = Shkronja parazgjedhje:
    .accesskey = a

default-size-label =
    .value = Madhësi:
    .accesskey = M

font-options-button =
    .label = Të mëtejshme…
    .accesskey = S

color-options-button =
    .label = Ngjyra…
    .accesskey = N

display-width-legend = Mesazhe Tekst i Thjeshtë

# Note : convert-emoticons-label 'Emoticons' are also known as 'Smileys', e.g. :-)
convert-emoticons-label =
    .label = Emotikonet shfaqi si grafikë
    .accesskey = E

display-text-label = Kur shfaqen mesazhe teksti të thjeshtë të cituar:

style-label =
    .value = Stil:
    .accesskey = i

regular-style-item =
    .label = I rregullt
bold-style-item =
    .label = Të trasha
italic-style-item =
    .label = Të pjerrëta
bold-italic-style-item =
    .label = Të trasha Të pjerrëta

size-label =
    .value = Madhësi:
    .accesskey = a

regular-size-item =
    .label = Të rregullta
bigger-size-item =
    .label = Më të mëdha
smaller-size-item =
    .label = Më të vogla

quoted-text-color =
    .label = Ngjyrë:
    .accesskey = n

search-input =
    .placeholder = Kërko

type-column-label =
    .label = Lloj Lënde
    .accesskey = L

action-column-label =
    .label = Veprim
    .accesskey = V

save-to-label =
    .label = Kartelat ruaji te
    .accesskey = K

choose-folder-label =
    .label =
        { PLATFORM() ->
            [macos] Zgjidhni…
           *[other] Shfletoni…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] Z
           *[other] S
        }

always-ask-label =
    .label = Pyetmë përherë ku të ruhen kartelat
    .accesskey = P


display-tags-text = Etiketat mund të përdoren për të kategorizuar dhe treguar përparësi për mesazhet tuaj.

new-tag-button =
    .label = E re…
    .accesskey = r

edit-tag-button =
    .label = Përpunoni…
    .accesskey = P

delete-tag-button =
    .label = Fshije
    .accesskey = F

auto-mark-as-read =
    .label = Shënoji vetvetiu mesazhet si të lexuar
    .accesskey = v

mark-read-no-delay =
    .label = Sapo të shfaqen
    .accesskey = S

## Note: This will concatenate to "After displaying for [___] seconds",
## using (mark-read-delay) and a number (seconds-label).

mark-read-delay =
    .label = Pasi janë shfaqur për
    .accesskey = P

seconds-label = sekonda

##

open-msg-label =
    .value = Hapi mesazhet në:

open-msg-tab =
    .label = Skedë të re
    .accesskey = k

open-msg-window =
    .label = Dritare të re mesazhesh
    .accesskey = D

open-msg-ex-window =
    .label = Dritare ekzistuese mesazhesh
    .accesskey = e

close-move-delete =
    .label = Me lëvizjen ose fshirjen mbylle dritaren /skedën e mesazhit
    .accesskey = m

display-name-label =
    .value = Emër në ekran:

condensed-addresses-label =
    .label = Për persona në librin tim të adresave shfaq vetëm emër ekrani
    .accesskey = P

## Compose Tab

forward-label =
    .value = Mesazhet përcilli:
    .accesskey = M

inline-label =
    .label = Brendazi

as-attachment-label =
    .label = Si Bashkëngjitje

extension-label =
    .label = Shto prapashtesë te emri i kartelës
    .accesskey = s

## Note: This will concatenate to "Auto Save every [___] minutes",
## using (auto-save-label) and a number (auto-save-end).

auto-save-label =
    .label = Vetëruaje çdo
    .accesskey = V

auto-save-end = minuta

##

warn-on-send-accel-key =
    .label = Ripohoni përdorimin e shkurtoreve për dërgim mesazhi
    .accesskey = R

spellcheck-label =
    .label = Kontrolloji drejtshkrimin para se ta dërgosh
    .accesskey = K

spellcheck-inline-label =
    .label = Kontrollo drejtshkrimin në shkrim e sipër
    .accesskey = d

language-popup-label =
    .value = Gjuhë:
    .accesskey = G

download-dictionaries-link = Shkarkoni Më Tepër Fjalorë

font-label =
    .value = Shkronja:
    .accesskey = S

font-size-label =
    .value = Madhësi:
    .accesskey = M

default-colors-label =
    .label = Përdor ngjyrat parazgjedhje të lexuesit
    .accesskey = p

font-color-label =
    .value = Ngjyrë Teksti:
    .accesskey = T

bg-color-label =
    .value = Ngjyrë Sfondi:
    .accesskey = S

restore-html-label =
    .label = Rimerr Parazgjedhjet
    .accesskey = i

default-format-label =
    .label = Si parazgjedhje, përdor formatin Paragraf, në vend se të Lëndë Mesazhi
    .accesskey = P

format-description = Formësoni sjelljen lidhur me formate tekstesh

send-options-label =
    .label = Mundësi Dërgimi…
    .accesskey = u

autocomplete-description = Kur adresohen mesazhe, shih për zëra përputhjesh te:

ab-label =
    .label = Libra Vendorë Adresash
    .accesskey = L

directories-label =
    .label = Shërbyes Drejtorie:
    .accesskey = S

directories-none-label =
    .none = Asnjë

edit-directories-label =
    .label = Përpunoni Drejtori…
    .accesskey = P

email-picker-label =
    .label = Shto vetvetiu adresë dërgimi email-i te:
    .accesskey = v

default-directory-label =
    .value = Drejtori parazgjedhje për nisjen e dritares së librit të adresave:
    .accesskey = D

default-last-label =
    .none = Drejtoria e përdorur së fundit

attachment-label =
    .label = Kontrollo për bashkëngjitje që mungojnë
    .accesskey = K

attachment-options-label =
    .label = Fjalëkyçe…
    .accesskey = F

enable-cloud-share =
    .label = Ofroni për ndarje kartela më të mëdha se
cloud-share-size =
    .value = MB

add-cloud-account =
    .label = Shtoni…
    .accesskey = S
    .defaultlabel = Shtoni…

remove-cloud-account =
    .label = Hiqe
    .accesskey = H

find-cloud-providers =
    .value = Gjeni më tepër furnizues…

cloud-account-description = Shtoni një shërbim të ri depozitimi Filelink


## Privacy Tab

mail-content = Lëndë Poste

remote-content-label =
    .label = Lejo lëndë të largët në mesazhe
    .accesskey = L

exceptions-button =
    .label = Përjashtime…
    .accesskey = ë

remote-content-info =
    .value = Mësoni më tepër rreth çështjesh privatësie lënde të largët

web-content = Lëndë Web

history-label =
    .label = Mba mend sajte dhe lidhje që kam vizituar
    .accesskey = R

cookies-label =
    .label = Prano cookies prej sajtesh
    .accesskey = s

third-party-label =
    .value = Prano cookies palësh të treta:
    .accesskey = t

third-party-always =
    .label = Përherë
third-party-never =
    .label = Kurrë
third-party-visited =
    .label = Nga të vizituarit

keep-label =
    .value = Mbaji:
    .accesskey = M

keep-expire =
    .label = deri sa të skadojnë
keep-close =
    .label = deri sa të mbyll { -brand-short-name }-in
keep-ask =
    .label = pyetmë çdo herë

cookies-button =
    .label = Shfaqni Cookie-t…
    .accesskey = S

do-not-track-label =
    .label = Dërgojuni sajteve një sinjal “Mos Më Gjurmo” se nuk doni të ndiqeni
    .accesskey = D

learn-button =
    .label = Mësoni më tepër

passwords-description = { -brand-short-name }-i mund të mbajë mend fjalëkalimet për tërë llogaritë tuaja.

passwords-button =
    .label = Fjalëkalime të Ruajtur…
    .accesskey = F

master-password-description = Një Fjalëkalim i Përgjithshëm i mbron tërë fjalëkalimet tuaj, por do t'ju duhet ta jepni çdo herë për sesion.

master-password-label =
    .label = Përdor fjalëkalim të përgjithshëm
    .accesskey = P

master-password-button =
    .label = Ndryshoni Fjalëkalimin e Përgjithshëm…
    .accesskey = N


primary-password-description = Një Fjalëkalim i Përgjithshëm i mbron tërë fjalëkalimet tuaj, por do t&apos;ju duhet ta jepni çdo herë për sesion.

primary-password-label =
    .label = Përdorni një Fjalëkalim të Përgjithshëm
    .accesskey = P

primary-password-button =
    .label = Ndryshoni Fjalëkalimin e Përgjithshëm…
    .accesskey = N

forms-primary-pw-fips-title = Gjendeni nën mënyrën FIPS. FIPS lyp një Fjalëkalim të Përgjithshëm jo të zbrazët.
forms-master-pw-fips-desc = Ndryshimi i Fjalëkalimit Dështoi


junk-description = Caktoni rregullimet tuaja parazgjedhje për postën e pavlerë. Rregullimet për postë të pavlerë, sipas llogarish të veçanta, mund të formësohen te Rregullime Llogarish.

junk-label =
    .label = Kur shënoj mesazhe si të pavlera:
    .accesskey = K

junk-move-label =
    .label = Shpjeri te dosja "Të pavlera" e llogarisë përkatëse
    .accesskey = S

junk-delete-label =
    .label = Fshiji
    .accesskey = F

junk-read-label =
    .label = Mesazhet, për të cilat është përcaktuar se janë Të pavlera, shënoji si të lexuar
    .accesskey = M

junk-log-label =
    .label = Aktivizo regjistrim nga filtrat për të pavlerat
    .accesskey = A

junk-log-button =
    .label = Shfaq regjistrimin
    .accesskey = h

reset-junk-button =
    .label = Rirregulloni të Dhëna Stërvitjeje
    .accesskey = R

phishing-description = { -brand-short-name }-i mund t'i analizojë mesazhet për email mashtrues duke parë për teknika të zakonshme që përdoren për t'ju hedhur hi syve.

phishing-label =
    .label = Nëse mesazhi që po lexoj dyshohet si email mashtrim, ma bëj të ditur
    .accesskey = M

antivirus-description = { -brand-short-name }-i mund t'ia lehtësojë software-it tuaj anti-virus analizat për viruse në mesazhe poste ardhëse, përpara se ato të depozitohen lokalisht.

antivirus-label =
    .label = Lejo klientë anti-virus të vendosin në karantinë mesazhe të veçantë ardhës
    .accesskey = L

certificate-description = Kur një shërbyes kërkon dëshminë time vetjake:

certificate-auto =
    .label = Përzgjidh një vetvetiu
    .accesskey = P

certificate-ask =
    .label = Pyetmë çdo herë
    .accesskey = y

ocsp-label =
    .label = Kërkojuni shërbyesve me përgjigje OCSP të ripohojnë vlefshmërinë e tanishme të dëshmive
    .accesskey = K

certificate-button =
    .label = Administroni Dëshmi…
    .accesskey = A

security-devices-button =
    .label = Pajisje Sigurie…
    .accesskey = P

## Chat Tab

startup-label =
    .value = Kur niset { -brand-short-name }-i:
    .accesskey = K

offline-label =
    .label = Mbaji jashtë linje llogaritë e mia të fjalosjeve

auto-connect-label =
    .label = Bëje vetvetiu lidhjen e llogarive të mia të fjalosjeve

## Note: idle-label is displayed first, then there's a field where the user
## can enter a number, and itemTime is displayed at the end of the line.
## The translations of the idle-label and idle-time-label parts don't have
## to mean the exact same thing as in English; please try instead to
## translate the whole sentence.

idle-label =
    .label = Kontakteve të mia lejoju të më shohin si të plogësht pas
    .accesskey = K

idle-time-label = minutash pa veprimtari

##

away-message-label =
    .label = dhe gjendjen time kaloje si i Larguar, dhe me këtë mesazh gjendjeje:
    .accesskey = d

send-typing-label =
    .label = Dërgo gjatë bisedave njoftime lidhur me shtypje në tastierë
    .accesskey = ë

notification-label = Kur mbërrijnë mesazhe drejtuar jush:

show-notification-label =
    .label = Shfaq një njoftim:
    .accesskey = n

notification-all =
    .label = me emrin e dërguesit dhe një paraparje të mesazhit
notification-name =
    .label = vetëm me emrin e dërguesit
notification-empty =
    .label = pa ndonjë të dhënë

notification-type-label =
    .label =
        { PLATFORM() ->
            [macos] Kryej animacion ikone paneli
           *[other] Xixëlloje objektin e panelit
        }
    .accesskey =
        { PLATFORM() ->
            [macos] a
           *[other] X
        }

chat-play-sound-label =
    .label = Luaj një tingull
    .accesskey = L

chat-play-button =
    .label = Luaje
    .accesskey = L

chat-system-sound-label =
    .label = Tingull parazgjedhje sistemi për postë të re
    .accesskey = P

chat-custom-sound-label =
    .label = Përdor kartelën zanore vijuese
    .accesskey = P

chat-browse-sound-button =
    .label = Shfletoni…
    .accesskey = S

theme-label =
    .value = Temë:
    .accesskey = T

style-thunderbird =
    .label = Thunderbird
style-bubbles =
    .label = Flluska
style-dark =
    .label = E errët
style-paper =
    .label = Fletë Letre
style-simple =
    .label = E thjeshtë

preview-label = Paraparje:
no-preview-label = S’ka paraparje gati
no-preview-description = Kjo temë s’është e vlefshme ose hëpërhë jo gati (shtesë e çaktivizuar, mënyrë e parrezik, …).

chat-variant-label =
    .value = Variant:
    .accesskey = V

chat-header-label =
    .label = Shfaq Kryet
    .accesskey = K

# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-input-box =
    .style = width: 15.4em
    .placeholder =
        { PLATFORM() ->
            [windows] Gjej te Mundësitë
           *[other] Gjej te Parapalqimet
        }

## Preferences UI Search Results

search-results-header = Përfundime Kërkimi

# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] Na ndjeni! S’ka përfundime te Mundësitë për “<span data-l10n-name="query"></span>”.
       *[other] Na ndjeni! S’ka përfundime te Parapëlqimet për “<span data-l10n-name="query"></span>”.
    }

search-results-help-link = Ju duhet ndihmë? Vizitoni <a data-l10n-name="url">Asistencë { -brand-short-name }-i</a>

## Preferences UI Search Results

