# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


preferences-title =
    .title =
        { PLATFORM() ->
            [windows] Roghanna
           *[other] Sainroghanna
        }

pane-compose-title = Cumadh
category-compose =
    .tooltiptext = Cumadh

pane-chat-title = Comhrá
category-chat =
    .tooltiptext = Comhrá

pane-calendar-title = Féilire
category-calendar =
    .tooltiptext = Féilire

## OS Authentication dialog


## General Tab

focus-search-shortcut =
    .key = f
focus-search-shortcut-alt =
    .key = k

general-legend = Leathanach Tosaigh { -brand-short-name }

start-page-label =
    .label = Agus { -brand-short-name } tar éis tosú, taispeáin an Leathanach Tosaigh i réimse na dteachtaireachtaí
    .accesskey = t

location-label =
    .value = Suíomh:
    .accesskey = o
restore-default-label =
    .label = Athchóirigh na Réamhshocruithe
    .accesskey = R

default-search-engine = Inneall Cuardaigh Réamhshocraithe

new-message-arrival = Ar theacht teachtaireachtaí nua:
mail-play-sound-label =
    .label =
        { PLATFORM() ->
            [macos] Seinn an comhad fuaime seo a leanas:
           *[other] Seinn fuaim
        }
    .accesskey =
        { PLATFORM() ->
            [macos] u
           *[other] d
        }
mail-play-button =
    .label = Seinn
    .accesskey = S

change-dock-icon = Roghanna a bhaineann leis an deilbhín
app-icon-options =
    .label = Roghanna an Deilbhín…
    .accesskey = n

notification-settings = Is féidir foláirimh agus an fhuaim réamhshocraithe a dhíchumasú sa bpána Fógraí i Sainroghanna an Chórais.

animated-alert-label =
    .label = Taispeáin airdeall
    .accesskey = s
customize-alert-label =
    .label = Saincheap…
    .accesskey = c

tray-icon-label =
    .label = Taispeáin deilbhín sa tráidire
    .accesskey = t

mail-custom-sound-label =
    .label = Úsáid an comhad fuaime seo
    .accesskey = u
mail-browse-sound-button =
    .label = Brabhsáil…
    .accesskey = B

enable-gloda-search-label =
    .label = Cumasaigh Cuardach Cuimsitheach agus an tInneacsóir
    .accesskey = e

datetime-formatting-legend = Formáidiú Dáta agus Ama

allow-hw-accel =
    .label = Bain úsáid as luasghéarú crua-earraí más féidir
    .accesskey = l

store-type-label =
    .value = Cineál Stórais na dTeachtaireachtaí le haghaidh cuntas nua:
    .accesskey = T

mbox-store-label =
    .label = Gach fillteán ina chomhad féin (mbox)
maildir-store-label =
    .label = Gach teachtaireacht ina comhad féin (maildir)

scrolling-legend = Scrollú
autoscroll-label =
    .label = Úsáid uathscrollú
    .accesskey = s
smooth-scrolling-label =
    .label = Úsáid mínscrollú
    .accesskey = m

system-integration-legend = Comhtháthú Córais
always-check-default =
    .label = Seiceáil i gcónaí ag am tosaithe an é { -brand-short-name } an cliant réamhshocraithe ríomhphoist
    .accesskey = a
check-default-button =
    .label = Seiceáil Anois…
    .accesskey = n

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
search-engine-name =
    { PLATFORM() ->
        [macos] Spotsolas
        [windows] Cuardach Windows
       *[other] { "" }
    }

search-integration-label =
    .label = Ceadaigh do { search-engine-name } teachtaireachtaí a chuardach
    .accesskey = C

config-editor-button =
    .label = Eagarthóir Cumraíochta…
    .accesskey = C

return-receipts-description = Socraigh conas a láimhseálann { -brand-short-name } admhálacha léite
return-receipts-button =
    .label = Admhálacha Léite…
    .accesskey = L

update-app-legend = Nuashonruithe { -brand-short-name }

# Variables:
#   $version (String): version of Thunderbird, e.g. 68.0.1
update-app-version = Leagan { $version }

automatic-updates-label =
    .label = Suiteáil nuashonruithe go huathoibríoch (molta: slándáil níos fearr)
    .accesskey = a
check-updates-label =
    .label = Lorg nuashonruithe, ach lig dom iad a shuiteáil nuair is mian liom
    .accesskey = L

update-history-button =
    .label = Taispeáin Stair na Nuashonruithe
    .accesskey = p

use-service =
    .label = Úsáid seirbhís sa chúlra chun nuashonruithe a shuiteáil
    .accesskey = b

networking-legend = Ceangal
proxy-config-description = Cumraigh conas a cheanglófar { -brand-short-name } leis an Idirlíon

network-settings-button =
    .label = Socruithe…
    .accesskey = S

offline-legend = As Líne
offline-settings = Cumraigh socruithe as líne

offline-settings-button =
    .label = As Líne…
    .accesskey = A

diskspace-legend = Spás Diosca
offline-compact-folder =
    .label = Dlúthaigh fillteáin dá sábhálfadh sé níos mó ná
    .accesskey = a

compact-folder-size =
    .value = MB iomlán

## Note: The entities use-cache-before and use-cache-after appear on a single
## line in preferences as follows:
## use-cache-before [ textbox for cache size in MB ] use-cache-after

use-cache-before =
    .value = Úsáid suas le
    .accesskey = s

use-cache-after = MB spás don taisce

##

smart-cache-label =
    .label = Sáraigh bainistíocht uathoibríoch na taisce
    .accesskey = b

clear-cache-button =
    .label = Bánaigh Anois
    .accesskey = B

fonts-legend = Clófhoirne agus Dathanna

default-font-label =
    .value = Cló réamhshocraithe:
    .accesskey = r

default-size-label =
    .value = Méid:
    .accesskey = M

font-options-button =
    .label = Casta…
    .accesskey = t

color-options-button =
    .label = Dathanna…
    .accesskey = D

display-width-legend = Teachtaireachtaí Gnáth-théacs

# Note : convert-emoticons-label 'Emoticons' are also known as 'Smileys', e.g. :-)
convert-emoticons-label =
    .label = Taispeáin straoiseoga mar ghraificí
    .accesskey = s

display-text-label = Agus teachtaireachtaí gnáth-théacs á dtaispeáint mar athfhriotal:

style-label =
    .value = Stíl:
    .accesskey = S

regular-style-item =
    .label = Gnáth
bold-style-item =
    .label = Trom
italic-style-item =
    .label = Iodálach
bold-italic-style-item =
    .label = Iodálach Trom

size-label =
    .value = Méid:
    .accesskey = M

regular-size-item =
    .label = Gnáth
bigger-size-item =
    .label = Níos Mó
smaller-size-item =
    .label = Níos Lú

quoted-text-color =
    .label = Dath:
    .accesskey = t

search-input =
    .placeholder = Cuardaigh

type-column-label =
    .label = Cineál Ábhair
    .accesskey = b

action-column-label =
    .label = Gníomh
    .accesskey = G

save-to-label =
    .label = Sábháil comhaid i
    .accesskey = S

choose-folder-label =
    .label =
        { PLATFORM() ->
            [macos] Roghnaigh…
           *[other] Brabhsáil…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] R
           *[other] B
        }

always-ask-label =
    .label = Fiafraigh díom cá sábhálfar an comhad i gcónaí
    .accesskey = g


display-tags-text = Is féidir clibeanna a úsáid le catagóirí agus tosaíochtaí a chur le do chuid teachtaireachtaí.

new-tag-button =
    .label = Nua…
    .accesskey = N

edit-tag-button =
    .label = Eagar…
    .accesskey = E

delete-tag-button =
    .label = Scrios
    .accesskey = S

auto-mark-as-read =
    .label = Marcáil teachtaireachtaí mar léite go huathoibríoch
    .accesskey = u

mark-read-no-delay =
    .label = Chomh luath agus a thaispeántar iad
    .accesskey = o

## Note: This will concatenate to "After displaying for [___] seconds",
## using (mark-read-delay) and a number (seconds-label).

mark-read-delay =
    .label = Tar éis iad a thaispeáint ar feadh
    .accesskey = t

seconds-label = soicind

##

open-msg-label =
    .value = Oscail teachtaireachtaí:

open-msg-tab =
    .label = i gcluaisín nua
    .accesskey = n

open-msg-window =
    .label = i bhfuinneog nua theachtaireachta
    .accesskey = n

open-msg-ex-window =
    .label = i bhfuinneog theachtaireachta atá ann cheana
    .accesskey = e

close-move-delete =
    .label = Dún fuinneog/cluaisín na teachtaireachta tar éis a bhogtha nó scriosta
    .accesskey = c

condensed-addresses-label =
    .label = Ná taispeáin ach an t-ainm taispeána le haghaidh daoine atá i mo leabhar seoltaí
    .accesskey = s

## Compose Tab

forward-label =
    .value = Cuir teachtaireachtaí ar aghaidh:
    .accesskey = g

inline-label =
    .label = Inlíne

as-attachment-label =
    .label = Mar Iatán

extension-label =
    .label = Cuir iarmhír le hainm an chomhaid
    .accesskey = e

## Note: This will concatenate to "Auto Save every [___] minutes",
## using (auto-save-label) and a number (auto-save-end).

auto-save-label =
    .label = Sábháil go huathoibríoch gach
    .accesskey = a

auto-save-end = nóiméad

##

warn-on-send-accel-key =
    .label = Deimhnigh agus aicearra méarchláir á úsáid chun teachtaireacht a sheoladh
    .accesskey = c

spellcheck-label =
    .label = Ceartaigh litriú sula seoltar teachtaireachtaí
    .accesskey = C

spellcheck-inline-label =
    .label = Cumasaigh litriú beo
    .accesskey = E

language-popup-label =
    .value = Teanga:
    .accesskey = T

download-dictionaries-link = Íoslódáil Tuilleadh Foclóirí

font-label =
    .value = Cló:
    .accesskey = l

font-color-label =
    .value = Dath an Téacs:
    .accesskey = T

bg-color-label =
    .value = Dath an Chúlra:
    .accesskey = l

restore-html-label =
    .label = Athchóirigh na Réamhshocruithe
    .accesskey = R

default-format-label =
    .label = Úsáid formáid an Ailt seachas Corpthéacs mar réamhshocrú
    .accesskey = A

format-description = Cumraigh iompar an fhormáidithe téacs

send-options-label =
    .label = Roghanna Seolta…
    .accesskey = S

autocomplete-description = Agus seoltaí á gcur le teachtaireachtaí, lorg iontrálacha oiriúnacha i:

ab-label =
    .label = Leabhar Seoltaí Logánta
    .accesskey = L

directories-label =
    .label = Freastalaí Eolaire:
    .accesskey = F

directories-none-label =
    .none = Gan sonrú

edit-directories-label =
    .label = Cuir Eolairí in Eagar…
    .accesskey = E

email-picker-label =
    .label = Cuir seoltaí ríomhphoist amach go huathoibríoch le mo:
    .accesskey = a

default-directory-label =
    .value = Fillteán tosaigh réamhshocraithe i bhfuinneog an leabhair seoltaí:
    .accesskey = s

default-last-label =
    .none = Fillteán is déanaí

attachment-label =
    .label = Seiceáil le haghaidh iatán ar iarraidh
    .accesskey = i

attachment-options-label =
    .label = Lorgfhocail…
    .accesskey = L

enable-cloud-share =
    .label = Tabhair tairiscint comhaid a chomhroinnt má tá siad níos mó ná
cloud-share-size =
    .value = MB

add-cloud-account =
    .label = Cuir Leis…
    .accesskey = L
    .defaultlabel = Cuir Leis…

remove-cloud-account =
    .label = Bain
    .accesskey = B

cloud-account-description = Cuir seirbhís stórála Filelink leis


## Privacy Tab

mail-content = Ábhar Ríomhphoist

remote-content-label =
    .label = Ceadaigh ábhar i gcéin i dteachtaireachtaí
    .accesskey = n

exceptions-button =
    .label = Eisceachtaí…
    .accesskey = E

remote-content-info =
    .value = Tuilleadh eolais faoin phríobháideacht agus ábhar i gcéin

web-content = Inneachar Gréasáin

history-label =
    .label = Meabhraigh suímh Ghréasáin agus naisc ar thug mé cuairt orthu
    .accesskey = M

cookies-label =
    .label = Glac le fianáin ó shuímh
    .accesskey = a

third-party-label =
    .value = Glac le fianáin tríú páirtí:
    .accesskey = c

third-party-always =
    .label = I gCónaí
third-party-never =
    .label = Riamh
third-party-visited =
    .label = Ó shuímh fheicthe

keep-label =
    .value = Coinnigh:
    .accesskey = o

keep-expire =
    .label = go dtí go mbeidh siad caite
keep-close =
    .label = go dtí go ndúnaim { -brand-short-name }
keep-ask =
    .label = fiafraigh díom i gcónaí

cookies-button =
    .label = Taispeáin Fianáin…
    .accesskey = s

passwords-description = Is féidir le { -brand-short-name } focail fhaire do chuid cuntas go léir a mheabhrú.

passwords-button =
    .label = Focail Fhaire Sábháilte…
    .accesskey = S

master-password-description = Cosnaíonn Príomhfhocal Faire do chuid focal faire go léir, ach beidh ort é a chur isteach uair amháin sa seisiún.

master-password-label =
    .label = Úsáid príomhfhocal faire
    .accesskey = p

master-password-button =
    .label = Athraigh an Príomhfhocal Faire…
    .accesskey = c


junk-description = Socraigh na réamhshocruithe dramhphoist. Téigh go Socruithe an Chuntais chun socruithe dramhphoist do chuntas áirithe a chumrú.

junk-label =
    .label = Agus teachtaireachtaí marcáilte mar dhramhphost agam:
    .accesskey = A

junk-move-label =
    .label = Bog go dtí fillteán "Dramhphost" an chuntais iad
    .accesskey = o

junk-delete-label =
    .label = Scrios iad
    .accesskey = d

junk-read-label =
    .label = Marcáil teachtaireachtaí ar Dramhphost iad mar léite
    .accesskey = M

junk-log-label =
    .label = Cumasaigh logáil don scagaire dramhphoist
    .accesskey = C

junk-log-button =
    .label = Taispeáin an logchomhad
    .accesskey = s

reset-junk-button =
    .label = Glan na Sonraí Traenála
    .accesskey = r

phishing-description = Is féidir le { -brand-short-name } camscéimeanna ríomhphoist a lorg i dteachtaireachtaí trí cleasanna coitianta a úsáidtear chun tú a mhealladh a chuardach iontu.

phishing-label =
    .label = Inis dom má mheastar gur camscéim í an teachtaireacht atá á léamh agam
    .accesskey = t

antivirus-description = Is féidir le { -brand-short-name } cabhrú le bogearraí frithvíris chun teachtaireachtaí isteach a chuardach le haghaidh víreas sula stórálfar go logánta iad.

antivirus-label =
    .label = Ceadaigh do chliaint fhrithvíris teachtaireachtaí isteach a chur ar coraintín
    .accesskey = a

certificate-description = Nuair atá freastalaí ag iarraidh mo theastas pearsanta:

certificate-auto =
    .label = Roghnaigh go huathoibríoch
    .accesskey = S

certificate-ask =
    .label = Fiafraigh díom i gcónaí
    .accesskey = W

ocsp-label =
    .label = Iarr ar fhreastalaí freagróra OCSP bailíocht teastais a dheimhniú
    .accesskey = O

## Chat Tab

startup-label =
    .value = Agus { -brand-short-name } á thosú:
    .accesskey = u

offline-label =
    .label = Coinnigh mo Chuntais Chomhrá as líne

auto-connect-label =
    .label = Ceangail mo chuntais chomhrá go huathoibríoch

## Note: idle-label is displayed first, then there's a field where the user
## can enter a number, and itemTime is displayed at the end of the line.
## The translations of the idle-label and idle-time-label parts don't have
## to mean the exact same thing as in English; please try instead to
## translate the whole sentence.

idle-label =
    .label = Abair le mo chairde go bhfuilim díomhaoin tar éis
    .accesskey = A

idle-time-label = nóiméad gan gníomh

##

away-message-label =
    .label = agus socraigh go bhfuilim Amuigh, leis an teachtaireacht stádais seo:
    .accesskey = A

send-typing-label =
    .label = Abair le daoine nuair a bhím ag clóscríobh
    .accesskey = d

notification-label = Nuair a thagann teachtaireacht atá dírithe agatsa isteach:

show-notification-label =
    .label = Taispeáin fógra:
    .accesskey = r

notification-all =
    .label = le hainm an tseoltóra agus réamhamharc
notification-name =
    .label = le hainm an tseoltóra amháin
notification-empty =
    .label = gan aon fhaisnéis

chat-play-sound-label =
    .label = Seinn fuaim
    .accesskey = m

chat-play-button =
    .label = Seinn
    .accesskey = S

chat-system-sound-label =
    .label = Fuaim réamhshocraithe ar an gcóras le haghaidh ríomhphoist nua
    .accesskey = r

chat-custom-sound-label =
    .label = Úsáid an comhad fuaime seo
    .accesskey = u

chat-browse-sound-button =
    .label = Brabhsáil…
    .accesskey = B

## Preferences UI Search Results

