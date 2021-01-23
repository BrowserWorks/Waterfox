# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


preferences-title =
    .title =
        { PLATFORM() ->
            [windows] Valkostir
           *[other] Valkostir
        }

pane-compose-title = Samsetning
category-compose =
    .tooltiptext = Samsetning

pane-chat-title = Spjall
category-chat =
    .tooltiptext = Spjall

pane-calendar-title = Dagatal
category-calendar =
    .tooltiptext = Dagatal

## OS Authentication dialog


## General Tab

focus-search-shortcut =
    .key = f
focus-search-shortcut-alt =
    .key = k

general-legend = { -brand-short-name } ræsisíða

start-page-label =
    .label = Þegar { -brand-short-name } ræsir, sýna ræsisíðu í póstsvæði
    .accesskey = Þ

location-label =
    .value = Staðsetning:
    .accesskey = S
restore-default-label =
    .label = Endurheimta sjálfgildi
    .accesskey = E

default-search-engine = Sjálfgefin leitarvél

new-message-arrival = Þegar nýr póstur er móttekin:
mail-play-sound-label =
    .label =
        { PLATFORM() ->
            [macos] Spila eftirfarandi hljóðskrá:
           *[other] Spila hljóð
        }
    .accesskey =
        { PLATFORM() ->
            [macos] d
           *[other] h
        }
mail-play-button =
    .label = Spila
    .accesskey = S

change-dock-icon = Breyta stillingum fyrir app icon
app-icon-options =
    .label = App Icon valkostir…
    .accesskey = n

notification-settings = Hægt er loka á áminningar og sjálfgefið hljóð í tilkynningaflipa í kerfisstillingum.

animated-alert-label =
    .label = Sýna glugga
    .accesskey = g
customize-alert-label =
    .label = Sérsníða…
    .accesskey = S

tray-icon-label =
    .label = Sýna sem táknmynd í bakka
    .accesskey = t

mail-custom-sound-label =
    .label = Nota hljóðskrá
    .accesskey = N
mail-browse-sound-button =
    .label = Velja…
    .accesskey = V

enable-gloda-search-label =
    .label = Virkja víðtæka leit og atriðaskrá
    .accesskey = i

allow-hw-accel =
    .label = Nota vélbúnaðarhröðun ef mögulegt
    .accesskey = h

store-type-label =
    .value = Tegund geymslu fyrir nýja reikninga:
    .accesskey = T

mbox-store-label =
    .label = Skrá per möppu (mbox)
maildir-store-label =
    .label = Skrá per skilaboð (maildir)

scrolling-legend = Skrun
autoscroll-label =
    .label = Nota sjálfvirka skrunun
    .accesskey = u
smooth-scrolling-label =
    .label = Nota fíngerða skrunun
    .accesskey = f

system-integration-legend = Samþætting kerfis
always-check-default =
    .label = Alltaf athuga hvort { -brand-short-name } sé sjálfgefið póstforrit í ræsingu
    .accesskey = l
check-default-button =
    .label = Kanna núna…
    .accesskey = n

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windows leit
       *[other] { "" }
    }

search-integration-label =
    .label = Leyfa { search-engine-name } að leita í pósti
    .accesskey = s

config-editor-button =
    .label = Stillinga ritill…
    .accesskey = g

return-receipts-description = Skilgreina hvernig { -brand-short-name } meðhöndlar staðfestingu á móttöku pósts
return-receipts-button =
    .label = Staðfesting á lestri…
    .accesskey = S

automatic-updates-label =
    .label = Setja sjálfvirkt inn uppfærslur (mælt með: eykur öryggi)
    .accesskey = a
check-updates-label =
    .label = Athuga með uppfærslur, en leyfa mér að velja hvenær á að setja þær upp
    .accesskey = A

update-history-button =
    .label = Sýna uppfærslusögu
    .accesskey = p

use-service =
    .label = Nota bakgrunnsþjónustu til að setja inn uppfærslur
    .accesskey = b

networking-legend = Tenging
proxy-config-description = Stilla hvernig { -brand-short-name } tengist við Internetið

network-settings-button =
    .label = Stillingar…
    .accesskey = n

offline-legend = Ónettengdur
offline-settings = Stilla ónettengdar stillingar

offline-settings-button =
    .label = Ónettengdur…
    .accesskey = t

diskspace-legend = Diskpláss
offline-compact-folder =
    .label = Þjappa öllum möppum þegar vistað er yfir
    .accesskey = a

compact-folder-size =
    .value = MB alls

## Note: The entities use-cache-before and use-cache-after appear on a single
## line in preferences as follows:
## use-cache-before [ textbox for cache size in MB ] use-cache-after

use-cache-before =
    .value = Nota að hámarki
    .accesskey = o

use-cache-after = MB af plássi fyrir flýtiminni

##

clear-cache-button =
    .label = Hreinsa núna
    .accesskey = H

fonts-legend = Letur og litir

default-font-label =
    .value = Sjálfgefin leturgerð:
    .accesskey = j

default-size-label =
    .value = Stærð:
    .accesskey = S

font-options-button =
    .label = Leturgerðir…
    .accesskey = u

color-options-button =
    .label = Litir…
    .accesskey = L

display-width-legend = Ósniðinn textapóstur

# Note : convert-emoticons-label 'Emoticons' are also known as 'Smileys', e.g. :-)
convert-emoticons-label =
    .label = Birta broskalla sem myndir
    .accesskey = m

display-text-label = Þegar birtur er ósniðinn texti með tilvitnun:

style-label =
    .value = Stíll:
    .accesskey = t

regular-style-item =
    .label = Venjulegt
bold-style-item =
    .label = Feitletrað
italic-style-item =
    .label = Skáletrað
bold-italic-style-item =
    .label = Feit- og skáletrað

size-label =
    .value = Stærð:
    .accesskey = S

regular-size-item =
    .label = Venjuleg
bigger-size-item =
    .label = Stærra
smaller-size-item =
    .label = Minna

quoted-text-color =
    .label = Litur:
    .accesskey = L

search-input =
    .placeholder = Leita

type-column-label =
    .label = Efnistegund
    .accesskey = t

action-column-label =
    .label = Aðgerð
    .accesskey = A

save-to-label =
    .label = Vista skrár yfir á
    .accesskey = s

choose-folder-label =
    .label =
        { PLATFORM() ->
            [macos] Velja…
           *[other] Velja…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] V
           *[other] V
        }

always-ask-label =
    .label = Alltaf spyrja hvar á að vista skrár
    .accesskey = A


display-tags-text = Hægt er að nota flokka til að flokka og forgangsraða póstum.

new-tag-button =
    .label = Ný…
    .accesskey = N

edit-tag-button =
    .label = Breyta…
    .accesskey = e

delete-tag-button =
    .label = Eyða
    .accesskey = y

auto-mark-as-read =
    .label = Merkja sjálfkrafa póst sem lesinn
    .accesskey = a

mark-read-no-delay =
    .label = Strax við birtingu
    .accesskey = x

## Note: This will concatenate to "After displaying for [___] seconds",
## using (mark-read-delay) and a number (seconds-label).

mark-read-delay =
    .label = Eftir birtingu í
    .accesskey = b

seconds-label = sekúndur

##

open-msg-label =
    .value = Opna póst í:

open-msg-tab =
    .label = Nýjum flipa
    .accesskey = f

open-msg-window =
    .label = Í nýjum glugga
    .accesskey = n

open-msg-ex-window =
    .label = Í glugga sem er til fyrir
    .accesskey = e

close-move-delete =
    .label = Loka póstglugga/flipa þegar verið er að færa eða eyða
    .accesskey = L

condensed-addresses-label =
    .label = Sýna aðeins birtingarnafn fyrir tengiliði í nafnaskránni
    .accesskey = S

## Compose Tab

forward-label =
    .value = Áframsenda póst:
    .accesskey = f

inline-label =
    .label = Innfellt

as-attachment-label =
    .label = Sem viðhengi

extension-label =
    .label = bæta skráarendingu við skráarnafn
    .accesskey = b

## Note: This will concatenate to "Auto Save every [___] minutes",
## using (auto-save-label) and a number (auto-save-end).

auto-save-label =
    .label = Vista sjálfkrafa á
    .accesskey = V

auto-save-end = mínútna fresti

##

warn-on-send-accel-key =
    .label = Staðfesta að senda póst þegar notað er lyklaborðsflýtivísun
    .accesskey = i

spellcheck-label =
    .label = Athuga stafsetningu áður en póstur er sendur
    .accesskey = A

spellcheck-inline-label =
    .label = Virkja leiðréttingu á stafsetningu fyrir innsleginn texta
    .accesskey = k

language-popup-label =
    .value = Tungumál:
    .accesskey = g

download-dictionaries-link = Hlaða niður fleiri orðabókum

font-label =
    .value = Letur:
    .accesskey = L

font-color-label =
    .value = Stilla lit texta:
    .accesskey = x

bg-color-label =
    .value = Bakgrunnslitur:
    .accesskey = g

restore-html-label =
    .label = Endurstilla sjálfgefin gildi
    .accesskey = r

default-format-label =
    .label = Sjálfgefið nota málsgreinarsnið í staðinn fyrir meginmálstexta
    .accesskey = ð

format-description = Skilgreina hegðun textasniðs

send-options-label =
    .label = Sendingarkostir…
    .accesskey = k

autocomplete-description = Þegar slegið er inn póstfang, leita að samsvörun í:

ab-label =
    .label = Staðbundnar nafnaskrár
    .accesskey = a

directories-label =
    .label = Netfangaþjónn:
    .accesskey = N

directories-none-label =
    .none = Engar

edit-directories-label =
    .label = Breyta netfangaþjónum…
    .accesskey = e

email-picker-label =
    .label = Bæta sjálfkrafa útsendum póst í:
    .accesskey = t

default-directory-label =
    .value = Sjálfgefin ræsimappa fyrir nafnabókarglugga:
    .accesskey = { "" }

default-last-label =
    .none = Síðast notaða mappa

attachment-label =
    .label = Athuga hvort viðhengi vantar
    .accesskey = v

attachment-options-label =
    .label = Stikkorð…
    .accesskey = k

enable-cloud-share =
    .label = Bjóðast til að deila stærri skrám en
cloud-share-size =
    .value = MB

add-cloud-account =
    .label = Bæta við…
    .accesskey = a
    .defaultlabel = Bæta við…

remove-cloud-account =
    .label = Fjarlægja
    .accesskey = r

cloud-account-description = Bæta við nýrri geymsluþjónustu fyrir skrár


## Privacy Tab

mail-content = Innihald pósts

remote-content-label =
    .label = Leyfa fjartengd innihald í pósti
    .accesskey = a

exceptions-button =
    .label = Undanþágur…
    .accesskey = U

remote-content-info =
    .value = Fræðast meira um friðhelgisvandamál í fjartengdu innihaldi

web-content = Vefur

history-label =
    .label = Muna eftir vefsvæðum og tenglum sem ég heimsæki
    .accesskey = r

cookies-label =
    .label = Þiggja smákökur frá vefsvæðum
    .accesskey = a

third-party-label =
    .value = Þiggja smákökur frá þriðja aðila:
    .accesskey = ð

third-party-always =
    .label = Alltaf
third-party-never =
    .label = Aldrei
third-party-visited =
    .label = Frá heimsóttum síðum

keep-label =
    .value = Eiga þangað til:
    .accesskey = ð

keep-expire =
    .label = þær renna út
keep-close =
    .label = Ég loka { -brand-short-name }
keep-ask =
    .label = spyrja í hvert skipti

cookies-button =
    .label = Sýna smákökur…
    .accesskey = S

passwords-description = { -brand-short-name } getur munað öll þín lykilorð þannig að þú þurfir ekki að slá þau inn aftur.

passwords-button =
    .label = Vistuð lykilorð…
    .accesskey = V

master-password-description = Aðallykilorð verndar öll önnur lykilorð en þú verður að slá það inn í hverri vafralotu.

master-password-label =
    .label = Nota aðallykilorð
    .accesskey = N

master-password-button =
    .label = Breyta aðallykilorði…
    .accesskey = B


junk-description = Stilla sjálfgefnar ruslpóstsstillingar. Stillingar fyrir ruslpóst fyrir ákveðinn reikning er hægt að stilla í stillingum reiknings.

junk-label =
    .label = Þegar ég flokka póst sem ruslpóst:
    .accesskey = Þ

junk-move-label =
    .label = Færa þá í "Ruslpóstur" möppuna
    .accesskey = F

junk-delete-label =
    .label = Eyða þeim
    .accesskey = E

junk-read-label =
    .label = Merkja staðfestan ruslpóst sem lesinn
    .accesskey = M

junk-log-label =
    .label = Virkja atburðaskrá fyrir þjálfaða ruslpóstsíu
    .accesskey = V

junk-log-button =
    .label = Sýna kladda
    .accesskey = S

reset-junk-button =
    .label = Endursetja þjálfunargögn
    .accesskey = ö

phishing-description = { -brand-short-name } getur reynt að greina hvort póstur er svikapóstur með því að leita eftir dæmigerðum aðferðum í svikapóstum.

phishing-label =
    .label = Láta vita ef ég les póst sem er grunaður um að vera falsaður
    .accesskey = t

antivirus-description = { -brand-short-name } gerir vírusvörnum kleyft að athuga allan innkominn póst varðandi vírusa áður en pósturinn er geymdur.

antivirus-label =
    .label = Leyfa vírusvörn að setja einstaka innkomna pósta í sóttkví
    .accesskey = L

certificate-description = Þegar netþjónn biður um mitt skilríki:

certificate-auto =
    .label = Velja eitt sjálfkrafa
    .accesskey = V

certificate-ask =
    .label = Spyrja í hvert skipti
    .accesskey = a

ocsp-label =
    .label = Tala við OCSP svarþjóna til að staðfesta gildi núverandi skílríkja
    .accesskey = T

## Chat Tab

startup-label =
    .value = Þegar { -brand-short-name } ræsir:
    .accesskey = s

offline-label =
    .label = Aftengja spjallreikninga

auto-connect-label =
    .label = Tengja spjallreikninga sjálfvirkt

## Note: idle-label is displayed first, then there's a field where the user
## can enter a number, and itemTime is displayed at the end of the line.
## The translations of the idle-label and idle-time-label parts don't have
## to mean the exact same thing as in English; please try instead to
## translate the whole sentence.

idle-label =
    .label = Tilkynna tengiliðum ef ég er aðgerðalaus í
    .accesskey = i

idle-time-label = mínútur óvirkur

##

away-message-label =
    .label = og setja stöðu sem fjarverandi með skilaboðum:
    .accesskey = a

send-typing-label =
    .label = Senda tilkynningu um innslátt í spjalli
    .accesskey = t

notification-label = Þegar póstur sem er sendur beint á þig kemur:

show-notification-label =
    .label = Sýna tilkynningu:
    .accesskey = t

notification-all =
    .label = aðeins með nafni sendanda og forskoðun á skilaboðum
notification-name =
    .label = aðeins með nafni sendanda
notification-empty =
    .label = án upplýsinga

chat-play-sound-label =
    .label = Spila hljóð
    .accesskey = ð

chat-play-button =
    .label = Spila
    .accesskey = p

chat-system-sound-label =
    .label = Sjálfgefið hljóð fyrir nýjan póst
    .accesskey = ð

chat-custom-sound-label =
    .label = Nota hljóðskrá
    .accesskey = N

chat-browse-sound-button =
    .label = Velja…
    .accesskey = V

## Preferences UI Search Results

