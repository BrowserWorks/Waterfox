# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


close-button =
    .aria-label = Serriñ

preferences-title =
    .title =
        { PLATFORM() ->
            [windows] Dibarzhioù
           *[other] Gwellvezioù
        }

category-general =
    .tooltiptext = { pane-general-title }

pane-compose-title = Aozañ
category-compose =
    .tooltiptext = Aozañ

pane-chat-title = Postelerezh prim
category-chat =
    .tooltiptext = Postelerezh prim

pane-calendar-title = Deiziataer
category-calendar =
    .tooltiptext = Deiziataer

general-language-and-appearance-header = Yezhoù & Neuz

general-incoming-mail-header = Posteloù o tont

general-files-and-attachment-header = Restroù & Kenstagadurioù

general-tags-header = Merkoù

general-reading-and-display-header = Lenn & Skrammañ

general-updates-header = Hizivadennoù

compose-html-style-title = Doare HTML

privacy-passwords-header = Gerioù-tremen

privacy-security-header = Diogelroez

privacy-certificates-title = Testenioù

choose-messenger-language-description = Dibabit ar yezhoù arveret evit diskouez al lañserioù, kemennadennoù ha rebuzadurioù eus { -brand-short-name }.
manage-messenger-languages-button =
    .label = Yezhoù all...
    .accesskey = Y
confirm-messenger-language-change-description = Adloc'hit { -brand-short-name } da arloañ ar c'hemmoù
confirm-messenger-language-change-button = Arloañ hag adloc'hañ

update-in-progress-title = Hizivadenn war ober

update-in-progress-message = Fellout a ra deoc'h e kendalc'hfe { -brand-short-name } da hizivaat?

update-in-progress-ok-button = &Dilezel
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Kenderc'hel

addons-button = Askouezhioù & Neuzioù

## OS Authentication dialog


## General Tab

focus-search-shortcut =
    .key = f
focus-search-shortcut-alt =
    .key = k

general-legend = Pajenn degemer { -brand-short-name }

start-page-label =
    .label = Pa loc'h { -brand-short-name }, diskouez ar bajenn degemer war tachad ar gemennadenn
    .accesskey = l

location-label =
    .value = Lec'hiadur :
    .accesskey = e
restore-default-label =
    .label = Assav ar re dre ziouer
    .accesskey = r

default-search-engine = Keflusker Enklask dre Ziouer
add-search-engine =
    .label = Ouzhpennañ diwar ur restr
    .accesskey = O
remove-search-engine =
    .label = Lemel
    .accesskey = L

new-message-arrival = P'en em gav kemennadennoù nevez :
mail-play-sound-label =
    .label =
        { PLATFORM() ->
            [macos] Ober gant ar restr son da heul:
           *[other] Seniñ ur son
        }
    .accesskey =
        { PLATFORM() ->
            [macos] u
           *[other] s
        }
mail-play-button =
    .label = Lenn
    .accesskey = e

change-dock-icon = Kemmañ gwellvezioù arlun an arload
app-icon-options =
    .label = Gwellvezioù arlun an arload…
    .accesskey = a

notification-settings = Ar galvoù-diwall hag ar son dre ziouer a c'hall bezañ diweredekaet war penel rebuziñ ar gwellvezioù reizhiad.

animated-alert-label =
    .label = Diskouez ur c'hemenn evezhiañ
    .accesskey = s
customize-alert-label =
    .label = Personelaat…
    .accesskey = P

tray-icon-label =
    .label = Diskouez un arlun er varrenn rebuziñ
    .accesskey = a

mail-custom-sound-label =
    .label = Ober gant ar restr son da heul
    .accesskey = u
mail-browse-sound-button =
    .label = Furchal…
    .accesskey = F

enable-gloda-search-label =
    .label = Gweredekaat ar c'hlask hag an ibiliañ hollek
    .accesskey = h

datetime-formatting-legend = Mentrezh an deiziad hag an eur
language-selector-legend = Yezh

allow-hw-accel =
    .label = Implijout ar buanadur periant pa vez tu
    .accesskey = I

store-type-label =
    .value = Rizh Kadaviñ Kemennadenn evit kontoù nevez :
    .accesskey = R

mbox-store-label =
    .label = Restr dre teuliad (mbox)
maildir-store-label =
    .label = Restr dre kemennadenn (kavlec'h postel)

scrolling-legend = Dibunañ
autoscroll-label =
    .label = Arverañ an dibunañ emgefreek
    .accesskey = e
smooth-scrolling-label =
    .label = Arverañ an dibunañ flour
    .accesskey = f

system-integration-legend = Enframmadur reizhiad
always-check-default =
    .label = Gwiriañ bepred, pa loc'h ar goulev, ma'z eo { -brand-short-name } ho posteler dre ziouer
    .accesskey = z
check-default-button =
    .label = Gwiriañ diouzhtu…
    .accesskey = d

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Enklask Windows
       *[other] { "" }
    }

search-integration-label =
    .label = Aotren { search-engine-name } da glask e-touez ar c'hemennadennoù
    .accesskey = A

config-editor-button =
    .label = Embanner kefluniañ…
    .accesskey = E

return-receipts-description = Despizañ penaos e dornatao { -brand-short-name } an testenioù degemer.
return-receipts-button =
    .label = Testenioù-degemer…
    .accesskey = r

update-app-legend = Hizivadurioù evit { -brand-short-name }

# Variables:
#   $version (String): version of Thunderbird, e.g. 68.0.1
update-app-version = Handelv { $version }

allow-description = Aotren { -brand-short-name } da
automatic-updates-label =
    .label = Staliañ an hizivadurioù ent emgefreek (erbedet : diogelroez gwellaet)
    .accesskey = e
check-updates-label =
    .label = Gwiriañ mard ez eus hizivadurioù met leuskel ac'hanon dibab mar bezint staliet
    .accesskey = G

update-history-button =
    .label = Diskouez roll istor an hizivadurioù
    .accesskey = u

use-service =
    .label = Arverañ ur gwazerezh e drekleur evit staliañ an hizivadurioù
    .accesskey = v

cross-user-udpate-warning = An arventenn-mañ a vo arloet war an holl gontoù Windows hag an holl arladoù { -brand-short-name } a arver ar staliadur { -brand-short-name }-mañ.

networking-legend = Kennask
proxy-config-description = Despizañ penaos e kennasko { -brand-short-name } ouzh internet

network-settings-button =
    .label = Arventennoù…
    .accesskey = A

offline-legend = Ezlinenn
offline-settings = Kefluniañ an arventennoù ezlinenn

offline-settings-button =
    .label = Ezlinenn…
    .accesskey = z

diskspace-legend = Egor war ar gantenn
offline-compact-folder =
    .label = Koazhañ an holl deuliadoù pa e tieub an dra-se muioc'h eget
    .accesskey = a

compact-folder-size =
    .value = Me en holl

## Note: The entities use-cache-before and use-cache-after appear on a single
## line in preferences as follows:
## use-cache-before [ textbox for cache size in MB ] use-cache-after

use-cache-before =
    .value = Arverañ betek
    .accesskey = r

use-cache-after = Me a egor evit ar grubuilh

##

smart-cache-label =
    .label = Tremen dreist ardeiñ emgefreek ar grubuilh
    .accesskey = d

clear-cache-button =
    .label = Skarzhañ diouzhtu
    .accesskey = S

fonts-legend = Nodrezhoù ha livioù

default-font-label =
    .value = Nodrezh dre ziouer:
    .accesskey = z

default-size-label =
    .value = Ment:
    .accesskey = M

font-options-button =
    .label = Kempleshoc'h…
    .accesskey = K

color-options-button =
    .label = Livioù…
    .accesskey = i

display-width-legend = Kemennadennoù testenn eeun

# Note : convert-emoticons-label 'Emoticons' are also known as 'Smileys', e.g. :-)
convert-emoticons-label =
    .label = Diskouez fromarlunioù evel kevregadoù
    .accesskey = D

display-text-label = Pa 'z emañ o skrammañ kemennadennoù gant testenn eeun meneget :

style-label =
    .value = Stil :
    .accesskey = S

regular-style-item =
    .label = Ingal
bold-style-item =
    .label = Tev
italic-style-item =
    .label = Stouet
bold-italic-style-item =
    .label = Stouet tev

size-label =
    .value = Ment :
    .accesskey = M

regular-size-item =
    .label = Ingal
bigger-size-item =
    .label = Brasoc'h
smaller-size-item =
    .label = Bihanoc'h

quoted-text-color =
    .label = Liv :
    .accesskey = L

search-input =
    .placeholder = Klask

type-column-label =
    .label = Rizh an endalc'h
    .accesskey = R

action-column-label =
    .label = Gwezh
    .accesskey = G

save-to-label =
    .label = Enrollañ ar restroù e
    .accesskey = E

choose-folder-label =
    .label =
        { PLATFORM() ->
            [macos] Dibab…
           *[other] Furchal…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] D
           *[other] F
        }

always-ask-label =
    .label = Atav goulenn diganin pelec'h enrollañ ar restroù
    .accesskey = A


display-tags-text = Arveret e vez merkoù da rummañ ha lakaat tevet war ho kemennadennoù.

new-tag-button =
    .label = Nevez...
    .accesskey = N

edit-tag-button =
    .label = Embann…
    .accesskey = E

delete-tag-button =
    .label = Dilemel
    .accesskey = D

auto-mark-as-read =
    .label = Merkañ ar c'hemennadennoù evel lennet ent emgefreek
    .accesskey = a

mark-read-no-delay =
    .label = Adalek ar skrammañ
    .accesskey = s

## Note: This will concatenate to "After displaying for [___] seconds",
## using (mark-read-delay) and a number (seconds-label).

mark-read-delay =
    .label = Goude
    .accesskey = d

seconds-label = a eilennoù

##

open-msg-label =
    .value = Digeriñ ar c'hemennadennoù e-barzh:

open-msg-tab =
    .label = Un ivinell nevez
    .accesskey = i

open-msg-window =
    .label = Ur prenestr kemennadenn nevez
    .accesskey = p

open-msg-ex-window =
    .label = Ur prenestr kemennadenn digor
    .accesskey = d

close-move-delete =
    .label = Serrin prenestr / ivinell ar gemennadenn goude an dilec'hiañ pe an dilemel
    .accesskey = S

condensed-addresses-label =
    .label = Diskouez an anv evit an den eus ma c'harned chomlec'hioù nemetken
    .accesskey = D

## Compose Tab

forward-label =
    .value = Treuzkas ar gemennadenn evel :
    .accesskey = k

inline-label =
    .label = Testenn enkorfet

as-attachment-label =
    .label = Evel kenstagadur

extension-label =
    .label = ouzhpennañ un askouezh d'an anv restr
    .accesskey = e

## Note: This will concatenate to "Auto Save every [___] minutes",
## using (auto-save-label) and a number (auto-save-end).

auto-save-label =
    .label = Enrollañ emgefre bep
    .accesskey = E

auto-save-end = a vunutennoù

##

warn-on-send-accel-key =
    .label = Kadarnaat pa vez graet gant berradennoù klavier evit kas ur gemennadenn
    .accesskey = i

spellcheck-label =
    .label = Gwiriañ ar reizhskrivañ a-raok kas
    .accesskey = w

spellcheck-inline-label =
    .label = Gweredekaat reizhskrivañ en ur vizskrivañ
    .accesskey = k

language-popup-label =
    .value = Yezh :
    .accesskey = Y

download-dictionaries-link = Pellgargañ muioc'h a c'heriadurioù

font-label =
    .value = Nodrezh :
    .accesskey = N

font-size-label =
    .value = Ment :
    .accesskey = M

default-colors-label =
    .label = Arverañ livioù dre ziouer al lenner
    .accesskey = A

font-color-label =
    .value = Liv an destenn :
    .accesskey = L

bg-color-label =
    .value = Liv an drekleur :
    .accesskey = L

restore-html-label =
    .label = Assav ar re dre ziouer
    .accesskey = r

default-format-label =
    .label = Arverañ ar mentrezh Rannbennad e-lec'h ar C'horf Testenn dre ziouer
    .accesskey = R

format-description = Kefluniañ emzalc'h ar mentrezh testenn

send-options-label =
    .label = Dibarzhioù kas…
    .accesskey = k

autocomplete-description = Pa lakait chomlec'h ar c'hemennadennoù, sellit ouzh an enankadoù a glot e :

ab-label =
    .label = Karned-chomlec'hioù lec'hel
    .accesskey = a

directories-label =
    .label = Kavlec'hiad an dafariad:
    .accesskey = d

directories-none-label =
    .none = Tra ebet

edit-directories-label =
    .label = Aozañ kavlec'hiadoù…
    .accesskey = A

email-picker-label =
    .label = Ouzhpennañ ent emgefreek ar chomlec'hioù eus ar posteloù kaset d'am :
    .accesskey = t

default-directory-label =
    .value = Kavlec'hiad dre ziouer er prenestr karned chomlec'hioù:
    .accesskey = K

default-last-label =
    .none = Kavlec'hiad arveret da ziwezhañ

attachment-label =
    .label = Gwiriañ ar c'henstagadurioù a vank
    .accesskey = v

attachment-options-label =
    .label = Gerioù-alc'hwez…
    .accesskey = G

enable-cloud-share =
    .label = Kinnig evit rannañ restroù vrasoc'h eget
cloud-share-size =
    .value = Me

add-cloud-account =
    .label = Ouzhpennañ...
    .accesskey = O
    .defaultlabel = Ouzhpennañ...

remove-cloud-account =
    .label = Lemel
    .accesskey = L

cloud-account-description = Ouzhpennañ ur gwazerezh kadaviñ Filelink nevez


## Privacy Tab

mail-content = Endalc'had ar postel

remote-content-label =
    .label = Aotren an endalc'hadoù a-bell er c'hemennadennoù
    .accesskey = A

exceptions-button =
    .label = Nemedennoù…
    .accesskey = e

remote-content-info =
    .value = Gouzout hiroc'h a-zivout kudennoù an endalc'hadoù a-bell a-fet buhez prevez

web-content = Endalc'had Web

history-label =
    .label = Derc'hel soñj eus al lec'hiennoù hag an ereoù gweladennet ganin
    .accesskey = s

cookies-label =
    .label = Degemer toupinoù adalek lec'hiennoù
    .accesskey = D

third-party-label =
    .value = Degemer toupinoù un trede :
    .accesskey = g

third-party-always =
    .label = Atav
third-party-never =
    .label = Morse
third-party-visited =
    .label = Adalek lec'hiennoù gweladennet

keep-label =
    .value = Mirout betek:
    .accesskey = M

keep-expire =
    .label = ez echuont
keep-close =
    .label = ma serrin { -brand-short-name }
keep-ask =
    .label = goulenn ganin bewech

cookies-button =
    .label = Diskouez an toupinoù…
    .accesskey = s

learn-button =
    .label = Gouzout hiroc'h

passwords-description = Gallout a ra { -brand-short-name } derc'hel soñj eus ho kerioù-tremen evit ho holl kontoù.

passwords-button =
    .label = Gerioù-tremen enrollet…
    .accesskey = e

master-password-description = Pa vez implijet anezhañ e tiwall ar ger-tremen mestr ho holl kerioù-tremen - met ret eo deoc'h e reiñ ur wech dre estez.

master-password-label =
    .label = Implijout ur ger-tremen mestr
    .accesskey = I

master-password-button =
    .label = Kemmañ ar ger-tremen mestr…
    .accesskey = K


junk-description = Kefluniañ arventennoù ar posteloù lastez dre ziouer. Kefluniet e vez ur gont evit ar posteloù lastez e Arventennoù ar gont.

junk-label =
    .label = Pa verkan kemennadennoù evel lastez :
    .accesskey = v

junk-move-label =
    .label = Dilec'hiañ anezho betek teuliad "Lastez" ar gont
    .accesskey = b

junk-delete-label =
    .label = Dilemel anezho
    .accesskey = D

junk-read-label =
    .label = Merkañ evel bet lennet ar c'hemennadennoù despizet evel lastez
    .accesskey = M

junk-log-label =
    .label = Gweredekaat ar c'herzhlevr evit sil azasaus al lastez
    .accesskey = G

junk-log-button =
    .label = Diskouez ar c'herzhlevr
    .accesskey = s

reset-junk-button =
    .label = Adderaouekaat ar pleustriñ war ar roadennoù
    .accesskey = A

phishing-description = Barrek eo { -brand-short-name } da zezrannañ kemennadennoù da gavout posteloù c'hwibañ dre glask an doareoù boutin arveret evit ho kwallbakañ.

phishing-label =
    .label = Lavar din hag-eñ emaon o lenn ur postel gant c'hwezh ar c'hwiberezh warnañ
    .accesskey = e

antivirus-description = Gallout a ray { -brand-short-name } aesaat labour an enep-viruzoù da zielfennañ kemennadennoù ouzh ar viruzoù, a-raok ma vo gwaredet ar c'hemennadennoù war hoc'h urzhiataer.

antivirus-label =
    .label = Aotren an enep-viruzoù da lakaat en dispell ar c'hemennadennoù oc'h erruout.
    .accesskey = A

certificate-description = Pa vez goulennet ma zesteni personel gant un dafariad:

certificate-auto =
    .label = Diuz unan ent emgefreek
    .accesskey = D

certificate-ask =
    .label = Goulenn diganin bewech
    .accesskey = b

ocsp-label =
    .label = Goulenn kadarnaat talvoudegezh an testenioù gant an dafariadoù OCSP
    .accesskey = G

certificate-button =
    .label = Merañ an testenioù…
    .accesskey = M

security-devices-button =
    .label = Trevnadoù diogelroez…
    .accesskey = T

## Chat Tab

startup-label =
    .value = Pa loc'h { -brand-short-name } :
    .accesskey = l

offline-label =
    .label = Mirout ma c'hontoù postelerezh prim ezlinenn

auto-connect-label =
    .label = Kennaskañ ma c'hontoù postelerezh prim ent emgefreek

## Note: idle-label is displayed first, then there's a field where the user
## can enter a number, and itemTime is displayed at the end of the line.
## The translations of the idle-label and idle-time-label parts don't have
## to mean the exact same thing as in English; please try instead to
## translate the whole sentence.

idle-label =
    .label = Reiñ da c'houzout da'm darempredoù ez eo dioberiant ma c'hont goude
    .accesskey = R

idle-time-label = a vunutennoù eus dioberiantiz

##

away-message-label =
    .label = ha kemmañ ma stad da Ezvezant gant ar gemennadenn da-heul :
    .accesskey = E

send-typing-label =
    .label = Kas rebuziñ e-barzh ar c'haozeadennoù pa'z emaon o vizskrivañ
    .accesskey = b

notification-label = Pa vez degemeret kemennadennoù kaset deoc'h :

show-notification-label =
    .label = Diskouez ur rebuzadur
    .accesskey = r

notification-all =
    .label = gant anv ar c'haser hag alberz ar gemennadenn
notification-name =
    .label = gant anv ar c'haser nemetken
notification-empty =
    .label = hep titour ebet

notification-type-label =
    .label =
        { PLATFORM() ->
            [macos] Bevaat arlun an dock
           *[other] Lakit da vlinkañ an elfenn e barrenn an drevellioù
        }
    .accesskey =
        { PLATFORM() ->
            [macos] o
           *[other] F
        }

chat-play-sound-label =
    .label = Seniñ ur son
    .accesskey = S

chat-play-button =
    .label = Lenn
    .accesskey = L

chat-system-sound-label =
    .label = Son ar reizhiad dre ziouer evit ur postel nevez
    .accesskey = S

chat-custom-sound-label =
    .label = Ober gant ar restr son da heul
    .accesskey = u

chat-browse-sound-button =
    .label = Furchal…
    .accesskey = F

theme-label =
    .value = Neuz:
    .accesskey = T

style-thunderbird =
    .label = Thunderbird
style-bubbles =
    .label = Lagadennoù
style-dark =
    .label = Teñval
style-paper =
    .label = Follennoù paper
style-simple =
    .label = Eeun

preview-label = Alberz:
no-preview-label = Alberz ebet hegerz
no-preview-description = N'eo ket mat an tem-mañ pe dihegerz emañ evit ar mare (mollad lazhet, mod sur, …).

chat-variant-label =
    .value = Variezon:
    .accesskey = V

chat-header-label =
    .label = Diskouez talbenn
    .accesskey = H

## Preferences UI Search Results

