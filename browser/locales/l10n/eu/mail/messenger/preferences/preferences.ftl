# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

close-button =
    .aria-label = Itxi

preferences-title =
    .title =
        { PLATFORM() ->
            [windows] Aukerak
           *[other] Hobespenak
        }

pane-general-title = Orokorra
category-general =
    .tooltiptext = { pane-general-title }

pane-compose-title = Mezu-prestatzea
category-compose =
    .tooltiptext = Mezu-prestatzea

pane-privacy-title = Pribatutasuna eta segurtasuna
category-privacy =
    .tooltiptext = Pribatutasuna eta segurtasuna

pane-chat-title = Txata
category-chat =
    .tooltiptext = Txata

pane-calendar-title = Calendar
category-calendar =
    .tooltiptext = Calendar

general-language-and-appearance-header = Hizkuntza eta itxura

general-incoming-mail-header = Sarrerako postak

general-files-and-attachment-header = Fitxategi eta eranskinak

general-tags-header = Etiketak

general-reading-and-display-header = Irakurtze eta bistaratzea

general-updates-header = Eguneraketak

general-network-and-diskspace-header = Sarea eta diskoko lekua

general-indexing-label = Indexatzen

composition-category-header = Mezu-prestatzea

composition-attachments-header = Eranskinak

composition-spelling-title = Ortografia

compose-html-style-title = HTML estiloa

composition-addressing-header = Helbideratzea

privacy-main-header = Pribatutasuna

privacy-passwords-header = Pasahitzak

privacy-junk-header = Zaborra

collection-header = { -brand-short-name } datuen bilketa eta erabilera

collection-description = Aukerak ematen ahalegintzen gara { -brand-short-name } denontzat hobetzeko behar ditugun datuak soilik biltzeko. Informazio pertsonala jaso aurretik zure baimena eskatzen dugu beti.
collection-privacy-notice = Pribatutasun-oharra

collection-health-report-telemetry-disabled = Jada ez duzu baimentzen { -vendor-short-name }(e)k datu tekniko eta interakziozkoak kapturatzea. Iraganeko datu guztiak 30 egunen buruan ezabatuko dira.
collection-health-report-telemetry-disabled-link = Argibide gehiago

collection-health-report =
    .label = Baimendu { -brand-short-name }(r)i datu tekniko eta interakziozkoak { -vendor-short-name }ra bidaltzea
    .accesskey = B
collection-health-report-link = Argibide gehiago

# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = Datuen berri ematea desgaituta dago eraikitze-konfigurazio honetarako

collection-backlogged-crash-reports =
    .label = Baimendu { -brand-short-name }(r)i atzeratutako hutsegite-txostenak zuregatik bidaltzea
    .accesskey = B
collection-backlogged-crash-reports-link = Argibide gehiago

privacy-security-header = Segurtasuna

privacy-scam-detection-title = Iruzur detekzioa

privacy-anti-virus-title = Antibirusa

privacy-certificates-title = Ziurtagiriak

chat-pane-header = Txata

chat-status-title = Egoera

chat-notifications-title = Jakinarazpenak

chat-pane-styling-header = Diseinua

choose-messenger-language-description = Aukeratu hizkuntza { -brand-short-name } erabiliko duena pantailako menu, mezu eta jakinarazpenetan.
manage-messenger-languages-button =
    .label = Ezarri ordezkoak
    .accesskey = i
confirm-messenger-language-change-description = Barrabiarazi { -brand-short-name } aldaketa hauek aplikatzeko
confirm-messenger-language-change-button = Aplikatu eta berrabiarazi

update-setting-write-failure-title = Errorea eguneratze hobespenak gordetzean

# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    { -brand-short-name }(e)k errore bat aurkitu du eta ez du aldaketa hau gorde. Kontuan izan eguneraketen hobespen hau ezartzeak azpiko fitxategia idazteko baimenak behar dituela. Zu edo sistema-kudeatzaile bat errorea konpontzeko moduan izan zaitezkete erabiltzaileen taldeari fitxategi honetarako kontrol osoa emanez.
    
     Ezin da fitxategira idatzi: { $path }

update-in-progress-title = Eguneratzea egiten

update-in-progress-message = { -brand-short-name } eguneratze honekin jarraitzea nahi duzu?

update-in-progress-ok-button = &Baztertu
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Jarraitu

addons-button = Hedapenak eta Gaiak

## OS Authentication dialog

# This message can be seen by trying to add a Master Password.
master-password-os-auth-dialog-message-win = Pasahitz nagusi bat sortzeko, sartu zure Windows kredentzialak. Honek zure kontuen segurtasuna babesten laguntzen du.

# This message can be seen by trying to add a Master Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
master-password-os-auth-dialog-message-macosx = sortu pasahitz nagusia

# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Pasahitz nagusi bat sortzeko, sartu zure Windows kredentzialak. Honek zure kontuen segurtasuna babesten laguntzen du.

# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = Sortu pasahitz nagusia

# Don't change this label.
master-password-os-auth-dialog-caption = { -brand-full-name }

## General Tab

focus-search-shortcut =
    .key = f
focus-search-shortcut-alt =
    .key = k

general-legend = { -brand-short-name } hasiera-orria

start-page-label =
    .label = { -brand-short-name } abiaraztean, erakutsi hasiera-orria mezuaren eremuan
    .accesskey = b

location-label =
    .value = Kokalekua:
    .accesskey = o
restore-default-label =
    .label = Berrezarri lehenetsia
    .accesskey = r

default-search-engine = Bilatzaile lehenetsia
add-search-engine =
    .label = Gehitu fitxategitik
    .accesskey = f
remove-search-engine =
    .label = Kendu
    .accesskey = K

minimize-to-tray-label =
    .label = { -brand-short-name } txikitzen denean, mugitu erretilura
    .accesskey = t

new-message-arrival = Mezu berri bat iristerakoan:
mail-play-sound-label =
    .label =
        { PLATFORM() ->
            [macos] Erabili hurrengo soinu-fitxategia:
           *[other] Erreproduzitu soinua
        }
    .accesskey =
        { PLATFORM() ->
            [macos] E
           *[other] E
        }
mail-play-button =
    .label = Erreproduzitu
    .accesskey = p

change-dock-icon = Aldatu aplikazio-ikonoaren hobespenak
app-icon-options =
    .label = Aplikazio-ikonoaren aukerak…
    .accesskey = n

notification-settings = Alertak eta soinu lehenetsiak desgaitu dezakezu jakinarazpen paneleko sistemaren hobespenetan.

animated-alert-label =
    .label = Erakutsi abisua
    .accesskey = s
customize-alert-label =
    .label = Pertsonalizatu…
    .accesskey = P

tray-icon-label =
    .label = Erakutsi erretiluko ikonoa
    .accesskey = r

mail-system-sound-label =
    .label = Lehenetsitako sistema-soinua posta berriarentzat
    .accesskey = s
mail-custom-sound-label =
    .label = Erabili hurrengo soinu-fitxategia
    .accesskey = u
mail-browse-sound-button =
    .label = Arakatu…
    .accesskey = A

enable-gloda-search-label =
    .label = Gaitu bilaketa orokorra eta indexatzailea
    .accesskey = i

datetime-formatting-legend = Data eta denboraren formatua
language-selector-legend = Hizkuntza

allow-hw-accel =
    .label = Erabili hardware azelerazioa erabilgarri dagoenean
    .accesskey = h

store-type-label =
    .value = Mezuen biltegiratze mota kontu berrientzako:
    .accesskey = m

mbox-store-label =
    .label = Karpeta bakoitzeko fitxategi bat (mbox)
maildir-store-label =
    .label = Fitxategia mezuko (maildir)

scrolling-legend = Korritzea
autoscroll-label =
    .label = Erabili korritze automatikoa
    .accesskey = a
smooth-scrolling-label =
    .label = Erabili korritze leuna
    .accesskey = u

system-integration-legend = Sistemaren integrazioa
always-check-default =
    .label = Egiaztatu beti { -brand-short-name } posta-bezero lehenetsia dela abiaraztean
    .accesskey = g
check-default-button =
    .label = Egiaztatu orain…
    .accesskey = o

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windows bilaketa
       *[other] { "" }
    }

search-integration-label =
    .label = Baimendu { search-engine-name }(r)i mezuak bilatzea
    .accesskey = B

config-editor-button =
    .label = Konfigurazio-editorea…
    .accesskey = g

return-receipts-description = Zehaztu hartu-agiriak nola kudeatzen dituen { -brand-short-name }(e)k
return-receipts-button =
    .label = Hartu-agiriak…
    .accesskey = r

update-app-legend = { -brand-short-name } eguneraketak

# Variables:
#   $version (String): version of Thunderbird, e.g. 68.0.1
update-app-version = Bertsioa { $version }

allow-description = Baimendu { -brand-short-name }(r)i
automatic-updates-label =
    .label = Instalatu eguneraketak automatikoki (gomendatua: hobetutako segurtasuna)
    .accesskey = a
check-updates-label =
    .label = Egiaztatu eguneraketarik dagoen baina galdetu instalatu nahi ditudan
    .accesskey = E

update-history-button =
    .label = Erakutsi eguneraketen historia
    .accesskey = n

use-service =
    .label = Erabili atzeko planoko zerbitzua eguneraketak instalatzeko
    .accesskey = z

cross-user-udpate-warning = Ezarpenak leiho guztiei aplikatuko zaizkie eta { -brand-short-name } profil guztiei, { -brand-short-name } instalazio hau erabiliz.

networking-legend = Konexioa
proxy-config-description = Konfiguratu { -brand-short-name } Internetera nola konektatzen den

network-settings-button =
    .label = Ezarpenak…
    .accesskey = n

offline-legend = Lineaz kanpo
offline-settings = Konfiguratu lineaz kanpoko ezarpenak

offline-settings-button =
    .label = Lineaz kanpo…
    .accesskey = o

diskspace-legend = Diskoko lekua
offline-compact-folder =
    .label = Trinkotu karpeta guztiak hau baino gehiago aurrezten denean:
    .accesskey = k

compact-folder-size =
    .value = MB guztira

## Note: The entities use-cache-before and use-cache-after appear on a single
## line in preferences as follows:
## use-cache-before [ textbox for cache size in MB ] use-cache-after

use-cache-before =
    .value = Erabili gehienez
    .accesskey = E

use-cache-after = MB cachearentzat

##

smart-cache-label =
    .label = Gainidatzi automatikoki cachearen kudeaketa
    .accesskey = a

clear-cache-button =
    .label = Garbitu orain
    .accesskey = G

fonts-legend = Letra-tipoak eta koloreak

default-font-label =
    .value = Letra-tipo lehenetsia:
    .accesskey = L

default-size-label =
    .value = Tamaina:
    .accesskey = T

font-options-button =
    .label = Letra-tipoak…
    .accesskey = L

color-options-button =
    .label = Koloreak…
    .accesskey = K

display-width-legend = Testu-arrunteko mezuak

# Note : convert-emoticons-label 'Emoticons' are also known as 'Smileys', e.g. :-)
convert-emoticons-label =
    .label = Bistaratu aurpegierak eta grafikoak
    .accesskey = a

display-text-label = Zitatutako testu-arrunteko mezuak bistaratzean:

style-label =
    .value = Estiloa:
    .accesskey = i

regular-style-item =
    .label = Arrunta
bold-style-item =
    .label = Lodia
italic-style-item =
    .label = Etzana
bold-italic-style-item =
    .label = Lodi etzana

size-label =
    .value = Tamaina:
    .accesskey = T

regular-size-item =
    .label = Arrunta
bigger-size-item =
    .label = Handiagoa
smaller-size-item =
    .label = Txikiagoa

quoted-text-color =
    .label = Kolorea:
    .accesskey = o

search-input =
    .placeholder = Bilatu

type-column-label =
    .label = Eduki mota
    .accesskey = t

action-column-label =
    .label = Ekintza
    .accesskey = a

save-to-label =
    .label = Gorde fitxategiak hemen:
    .accesskey = G

choose-folder-label =
    .label =
        { PLATFORM() ->
            [macos] Aukeratu…
           *[other] Arakatu…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] A
           *[other] A
        }

always-ask-label =
    .label = Beti galdetu niri fitxategiak non  gorde
    .accesskey = B


display-tags-text = Mezuak sailkatu eta lehentasunak zehazteko erabil daitezke etiketak.

new-tag-button =
    .label = Berria…
    .accesskey = B

edit-tag-button =
    .label = Editatu…
    .accesskey = E

delete-tag-button =
    .label = Ezabatu
    .accesskey = z

auto-mark-as-read =
    .label = Markatu automatikoki mezuak irakurrita gisa
    .accesskey = a

mark-read-no-delay =
    .label = Bistaratu bezain laster
    .accesskey = B

## Note: This will concatenate to "After displaying for [___] seconds",
## using (mark-read-delay) and a number (seconds-label).

mark-read-delay =
    .label = Denbora batez bistaratu eta gero:
    .accesskey = e

seconds-label = segundoz

##

open-msg-label =
    .value = Ireki mezuak:

open-msg-tab =
    .label = Fitxa berrian
    .accesskey = t

open-msg-window =
    .label = Mezu-leiho berrian
    .accesskey = h

open-msg-ex-window =
    .label = Dagoen mezu-leihoan
    .accesskey = D

close-move-delete =
    .label = Itxi mezu-leihoa/fitxa lekuz aldatzean edo ezabatzean
    .accesskey = I

display-name-label =
    .value = Bistaratzeko izena:

condensed-addresses-label =
    .label = Erakutsi nire helbide-liburuko pertsonen bistarazte-izena bakarrik
    .accesskey = p

## Compose Tab

forward-label =
    .value = Birbidali mezuak:
    .accesskey = B

inline-label =
    .label = Barnean

as-attachment-label =
    .label = Eranskin gisa

extension-label =
    .label = gehitu luzapena fitxategi-izenari
    .accesskey = f

## Note: This will concatenate to "Auto Save every [___] minutes",
## using (auto-save-label) and a number (auto-save-end).

auto-save-label =
    .label = Gorde automatikoki
    .accesskey = u

auto-save-end = minutuan behin

##

warn-on-send-accel-key =
    .label = Eskatu berrespena mezua bidaltzeko laster-tekla erabiltzean
    .accesskey = i

spellcheck-label =
    .label = Egiaztatu ortografia bidali aurretik
    .accesskey = g

spellcheck-inline-label =
    .label = Gaitu ortografia egiaztatzea idatzi ahala
    .accesskey = r

language-popup-label =
    .value = Hizkuntza:
    .accesskey = z

download-dictionaries-link = Deskargatu hiztegi gehiago

font-label =
    .value = Letra-tipoa:
    .accesskey = r

font-size-label =
    .value = Tamaina:
    .accesskey = t

default-colors-label =
    .label = Erabili irakurlearen kolore lehenetsiak
    .accesskey = l

font-color-label =
    .value = Testuaren kolorea:
    .accesskey = s

bg-color-label =
    .value = Atzeko planoko kolorea:
    .accesskey = A

restore-html-label =
    .label = Berrezarri lehenetsiak
    .accesskey = r

default-format-label =
    .label = Erabili paragrafo formatua testu gorputzaren ordez lehenetsirik
    .accesskey = p

format-description = Konfiguratu testuaren formatuaren portaera

send-options-label =
    .label = Bidalketa-aukerak…
    .accesskey = B

autocomplete-description = Bilatu bat datozen sarrerak mezuak helbideratzean:

ab-label =
    .label = Helbide-liburu lokaletan
    .accesskey = a

directories-label =
    .label = Direktorio-zerbitzarian:
    .accesskey = D

directories-none-label =
    .none = Bat ere ez

edit-directories-label =
    .label = Editatu direktorioak…
    .accesskey = E

email-picker-label =
    .label = Gehitu hemen automatikoki bidalitako posta-helbideak:
    .accesskey = t

default-directory-label =
    .value = Helbide liburu leihoko abioko direktorio lehenetsia:
    .accesskey = H

default-last-label =
    .none = Azken direktorio erabilia

attachment-label =
    .label = Egiaztatu eranskinak falta diren
    .accesskey = f

attachment-options-label =
    .label = Gako-hitzak…
    .accesskey = k

enable-cloud-share =
    .label = Eskaini partekatzea hau baino handiagoak diren fitxategientzat:
cloud-share-size =
    .value = MB

add-cloud-account =
    .label = Gehitu…
    .accesskey = G
    .defaultlabel = Gehitu…

remove-cloud-account =
    .label = Kendu
    .accesskey = K

find-cloud-providers =
    .value = Bilatu hornitzaile gehiago…

cloud-account-description = Gehitu Filelink biltegiratze-zerbitzu berri bat


## Privacy Tab

mail-content = Postaren edukia

remote-content-label =
    .label = Baimendu urruneko edukia mezuetan
    .accesskey = B

exceptions-button =
    .label = Salbuespenak…
    .accesskey = e

remote-content-info =
    .value = Urruneko edukiaren pribatutasun-arazoei buruzko argibide gehiago

web-content = Web edukia

history-label =
    .label = Gogoratu bisitatu ditudan webgune eta loturak
    .accesskey = G

cookies-label =
    .label = Onartu guneetako cookieak
    .accesskey = O

third-party-label =
    .value = Onartu hirugarrenen cookieak:
    .accesskey = n

third-party-always =
    .label = Beti
third-party-never =
    .label = Inoiz ez
third-party-visited =
    .label = Bisitatutakoetatik

keep-label =
    .value = Mantendu:
    .accesskey = M

keep-expire =
    .label = iraungi arte
keep-close =
    .label = { -brand-short-name } itxi arte
keep-ask =
    .label = galdetu niri beti

cookies-button =
    .label = Erakutsi cookieak…
    .accesskey = E

do-not-track-label =
    .label = Bidali webguneei "Do Not Track" seinalea zure jarraipena ez egitea adierazteko
    .accesskey = n

learn-button =
    .label = Argibide gehiago

passwords-description = { -brand-short-name }(e)k pasahitzen informazioa gogora dezake zure kontu guztientzat.

passwords-button =
    .label = Gordetako pasahitzak…
    .accesskey = G

master-password-description = Pasahitz nagusiak zure pasahitz guztiak babesten ditu, baina saio bakoitzeko behin sartu behar duzu.

master-password-label =
    .label = Erabili pasahitz nagusia
    .accesskey = n

master-password-button =
    .label = Aldatu pasahitz nagusia…
    .accesskey = A


primary-password-description = Pasahitz nagusiak zure pasahitz guztiak babesten ditu, baina saio bakoitzeko behin sartu behar duzu.

primary-password-label =
    .label = Erabili pasahitz nagusia
    .accesskey = E

primary-password-button =
    .label = Aldatu pasahitz nagusia…
    .accesskey = A

forms-primary-pw-fips-title = Une honetan FIPS moduan zaude. FIPS moduak pasahitz nagusia ezartzea eskatzen du.
forms-master-pw-fips-desc = Pasahitz aldaketak huts egin du


junk-description = Ezarri zabor-postaren ezarpen lehenetsiak. Kontu bakoitzari lotutako zabor-postaren ezarpenak kontu-ezarpenetan konfiguratu daitezke.

junk-label =
    .label = Mezuak zabor gisa markatzen ditudanean:
    .accesskey = z

junk-move-label =
    .label = Aldatu lekuz kontuaren "Zaborra" karpetara
    .accesskey = d

junk-delete-label =
    .label = Ezabatu
    .accesskey = E

junk-read-label =
    .label = Markatu zabor-mezuak irakurrita gisa
    .accesskey = M

junk-log-label =
    .label = Gaitu zabor-iragazki moldakorraren loga
    .accesskey = G

junk-log-button =
    .label = Erakutsi loga
    .accesskey = s

reset-junk-button =
    .label = Berrezarri trebatze-datuak
    .accesskey = r

phishing-description = { -brand-short-name }(e)k mezuak azter ditzake posta-iruzurrak bilatzeko, iruzur egiteko erabil daitezkeen oinarrizko teknikak begiratuz.

phishing-label =
    .label = Esaidazu irakurtzen ari naizen mezua posta-iruzurra izan daitekeen
    .accesskey = E

antivirus-description = { -brand-short-name } erraztuko du antibirus softwareak datozen mezuak aztertu ditzan lokalki gorde aurretik.

antivirus-label =
    .label = Baimendu antibirus bezeroari mezuak koarentenan jartzea
    .accesskey = k

certificate-description = Webgune batek nire ziurtagiri pertsonala eskatzen duenean:

certificate-auto =
    .label = Hautatu bat automatikoki
    .accesskey = S

certificate-ask =
    .label = Galdetu beti
    .accesskey = G

ocsp-label =
    .label = Galdetu OCSP erantzule-zerbitzariei ziurtagiriak baliozkoak diren egiaztatzeko
    .accesskey = G

certificate-button =
    .label = Kudeatu ziurtagiriak…
    .accesskey = K

security-devices-button =
    .label = Segurtasun-gailuak…
    .accesskey = S

## Chat Tab

startup-label =
    .value = { -brand-short-name } abiatzean:
    .accesskey = a

offline-label =
    .label = Mantendu txat-kontuak deskonektatuta

auto-connect-label =
    .label = Konektatu txat-kontuak automatikoki

## Note: idle-label is displayed first, then there's a field where the user
## can enter a number, and itemTime is displayed at the end of the line.
## The translations of the idle-label and idle-time-label parts don't have
## to mean the exact same thing as in English; please try instead to
## translate the whole sentence.

idle-label =
    .label = Jakinarazi nire kontaktuei inaktibo nagoela
    .accesskey = i

idle-time-label = minutu ondoren

##

away-message-label =
    .label = eta ezarri nire egoera Kanpoan egoera-mezu honekin:
    .accesskey = K

send-typing-label =
    .label = Bidali idazketa-jakinarazpenak berriketetan
    .accesskey = d

notification-label = Zuri zuzendutako mezuak iristean:

show-notification-label =
    .label = Erakutsi jakinarazpena:
    .accesskey = n

notification-all =
    .label = bidaltzailearen izenarekin eta mezuaren aurrebistarekin
notification-name =
    .label = bidaltzailearen izenarekin soilik
notification-empty =
    .label = inolako informaziorik gabe

notification-type-label =
    .label =
        { PLATFORM() ->
            [macos] Atrakeko ikonoak animatu
           *[other] Keinuka ataza-barrako elementua
        }
    .accesskey =
        { PLATFORM() ->
            [macos] A
           *[other] K
        }

chat-play-sound-label =
    .label = Erreproduzitu soinua
    .accesskey = d

chat-play-button =
    .label = Erreproduzitu
    .accesskey = p

chat-system-sound-label =
    .label = Lehenetsitako sistema-soinua posta berriarentzat
    .accesskey = i

chat-custom-sound-label =
    .label = Erabili hurrengo soinu-fitxategia
    .accesskey = u

chat-browse-sound-button =
    .label = Arakatu…
    .accesskey = A

theme-label =
    .value = Gaia:
    .accesskey = G

style-thunderbird =
    .label = Thunderbird
style-bubbles =
    .label = Burbuilak
style-dark =
    .label = Iluna
style-paper =
    .label = Papera orriak
style-simple =
    .label = Sinplea

preview-label = Aurrebista:
no-preview-label = Aurrebista ez dago erabilgarri
no-preview-description = Gai hau ez da baliokoa edo une honetan ez dago erabilgarri (desgaitu gehigarria, modu-segurua, …).

chat-variant-label =
    .value = Aldaerak:
    .accesskey = A

chat-header-label =
    .label = Erakutsi goiburua
    .accesskey = g

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
            [windows] Bilatu aukeretan
           *[other] Bilatu hobespenetan
        }

## Preferences UI Search Results

search-results-header = Bilaketaren emaitzak

# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] Barkatu! Aukeretan ez dago "<span data-l10n-name="query"></span>" bilaketarako emaitzarik.
       *[other] Barkatu! Hobespenetan ez dago "<span data-l10n-name="query"></span>" bilaketarako emaitzarik.
    }

search-results-help-link = Laguntza behar duzu? Bisitatu <a data-l10n-name="url">{ -brand-short-name }(r)en laguntza</a>
