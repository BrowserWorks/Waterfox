# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

close-button =
    .aria-label = Mdel

preferences-title =
    .title =
        { PLATFORM() ->
            [windows] Iɣewwaṛen
           *[other] Ismenyifen
        }

pane-general-title = Amatu
category-general =
    .tooltiptext = { pane-general-title }

pane-compose-title = Tira
category-compose =
    .tooltiptext = Tira

pane-privacy-title = Tudert tabaḍnit  & Taɣellist
category-privacy =
    .tooltiptext = Tudert tabaḍnit  & Taɣellist

pane-chat-title = Adiwenni usrid
category-chat =
    .tooltiptext = Adiwenni usrid

pane-calendar-title = Awitay
category-calendar =
    .tooltiptext = Awitay

general-language-and-appearance-header = Tutlayt d urwes

general-incoming-mail-header = Tirawt tukcimt

general-files-and-attachment-header = Ifulya d yimeddayen

general-tags-header = Tibzimin

general-reading-and-display-header = Taɣuri d uskan

general-updates-header = Ileqman

general-network-and-diskspace-header = Aẓeṭṭa d umkan n uḍebsi

general-indexing-label = Timerna n umatar

composition-category-header = Tasuddest

composition-attachments-header = Imeddayen

composition-spelling-title = Taɣdira

compose-html-style-title = Aɣanib HTML

composition-addressing-header = Tansiwin

privacy-main-header = Tabaḍnit

privacy-passwords-header = Awalen uffiren

privacy-junk-header = Aspam

collection-header = Alqqaḍ d useqdec n isefka { -brand-short-name }

collection-description = Ad k-d-nefk afus akken ad tferneḍ aleqqwaḍ n wayen kan ilaqen i weqaεed n { -brand-short-name } i yal yiwen. Ad k-d-nsuter yal tikkelt tasiregt send ad nawi talɣut tudmawant.
collection-privacy-notice = Tasertit n tbaḍnit

collection-health-report-telemetry-disabled = Dayen ur tettaǧǧaḍ ara { -vendor-short-name } ad d-yelqeḍ isefka itiknikanen akked wid n temyigawt. Meṛṛa isefka yezrin ad ttwakksen deg 30 n wussan.
collection-health-report-telemetry-disabled-link = Issin ugar

collection-health-report =
    .label = Sireg { -brand-short-name } ad yazen isefka itiknikanen ɣer { -vendor-short-name }
    .accesskey = r
collection-health-report-link = Issin ugar

# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = Aneqqis n isefka ur irmid ara i uswel-a n usefsu

collection-backlogged-crash-reports =
    .label = Sireg { -brand-short-name } akken ad yazen ineqqisen n uɣelluy deg ugilal
    .accesskey = c
collection-backlogged-crash-reports-link = Issin ugar

privacy-security-header = Taɣellist

privacy-scam-detection-title = Tifin n ukellex

privacy-anti-virus-title = Amgal infafaden

privacy-certificates-title = Iselkinen

chat-pane-header = Adiwenni usrid

chat-status-title = Addad

chat-notifications-title = Ilɣuten

chat-pane-styling-header = Afeṣṣel

choose-messenger-language-description = Fren tutlayt yettwaseqdacen i uskan n wumuɣen, iznan, akked yilɣa seg { -brand-short-name }.
manage-messenger-languages-button =
    .label = Fren wayeḍ...
    .accesskey = F
confirm-messenger-language-change-description = Ales tanekra n { -brand-short-name } akken ad ddun ibeddilen-a
confirm-messenger-language-change-button = Snes sakin ales tanekra

update-setting-write-failure-title = Tuccḍa deg usekles n yismenyifen n uleqqem

# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    { -brand-short-name } yemmuger-d tuccḍa ihi ur izmir ara ad isekles abeddel-a. Ẓer dakken abeddel n usmenyif-a n uleqqem, yesra tasiregt n tira deg ufaylu seddaw. Kečč neɣ anedbal n unagraw, tzemrem ahat ad tesseɣtim tuccḍa s umuddu n usenqed ummid n ufaylu-a i ugraw yiseqdacen.
    
    Ur yezmir ad yaru deg ufaylu: { $path }

update-in-progress-title = Aleqqem itteddu

update-in-progress-message = Tebɣiḍ { -brand-short-name } ad ikemmel aleqqem-a?

update-in-progress-ok-button = &Anef
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Kemmel

addons-button = Isiɣzaf & Isental

## OS Authentication dialog

# This message can be seen by trying to add a Master Password.
master-password-os-auth-dialog-message-win = Akken ad ternuḍ awal-inek uffir agejdan, sekcem inekcam-inek n tuqqna n Windows. Ayagi ad yeḍmen aḥraz n tɣellist n yimiḍanen-inek.

# This message can be seen by trying to add a Master Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
master-password-os-auth-dialog-message-macosx = Rnu awal uffir agejdan

# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Akken ad ternuḍ awal-inek·inem uffir agejdan, sekcem inekcam-inek·inem n tuqqna n Windows. Ayagi ad yeḍmen aḥraz n tɣellist n yimiḍanen-inek·inem.

# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = rnu awal uffir agejdan

# Don't change this label.
master-password-os-auth-dialog-caption = { -brand-full-name }

## General Tab

focus-search-shortcut =
    .key = f
focus-search-shortcut-alt =
    .key = k

general-legend = Asebter agejdan n { -brand-short-name }

start-page-label =
    .label = Ticki { -brand-short-name } yekker, sken asebter agejdan deg temnaṭ n yizen
    .accesskey = T

location-label =
    .value = Adig:
    .accesskey = o
restore-default-label =
    .label = Err-d iɣewwaṛen n uwennez n tazwara
    .accesskey = E

default-search-engine = Amsedday n unadi amezwer
add-search-engine =
    .label = Rnu seg ufaylu
    .accesskey = R
remove-search-engine =
    .label = Kkes
    .accesskey = d

minimize-to-tray-label =
    .label = Ticki { -brand-short-name } yuder, awi-t ɣer ufeggag n wadda
    .accesskey = y

new-message-arrival = Ma ad-awḍen iznan imaynuten:
mail-play-sound-label =
    .label =
        { PLATFORM() ->
            [macos] Urar afaylu n imesli-agi:
           *[other] Urar imesli
        }
    .accesskey =
        { PLATFORM() ->
            [macos] U
           *[other] d
        }
mail-play-button =
    .label = Urar
    .accesskey = U

change-dock-icon = Snifel ismenyifen i tignit n usnas
app-icon-options =
    .label = Iɣewwaṛen n tignit n usnas…
    .accesskey = g

notification-settings = Ilɣuten akked imesli amezwer zemren ad ttwasensen deg ugalis n ilɣuten seg ismenyifen n unagraw.

animated-alert-label =
    .label = Sken alɣu
    .accesskey = S
customize-alert-label =
    .label = Sagen…
    .accesskey = S

tray-icon-label =
    .label = Sken tignit n ufeggag n unagraw
    .accesskey = n

mail-system-sound-label =
    .label = Imesli n unagraw amezwer i yimayl amaynut
    .accesskey = D
mail-custom-sound-label =
    .label = Seqdec afaylu n imesli-agi
    .accesskey = S
mail-browse-sound-button =
    .label = Ḍum…
    .accesskey = Ḍ

enable-gloda-search-label =
    .label = Rmed anadi amatu akked timerna n ukatar
    .accesskey = m

datetime-formatting-legend = Amsal n uzemz akked wakud
language-selector-legend = Tutlayt

allow-hw-accel =
    .label = Seqdec tasɣiwelt n warrum ma tella
    .accesskey = q

store-type-label =
    .value = Tarrayt n usekles n yizen i yimiḍanen imaynuten:
    .accesskey = l

mbox-store-label =
    .label = Afaylu i wekaram(mbox)
maildir-store-label =
    .label = Afaylu i yizen (maildir)

scrolling-legend = Adrurem
autoscroll-label =
    .label = Seqdec adrurem awurman
    .accesskey = S
smooth-scrolling-label =
    .label = Seqdec adrurem aleggwaɣ
    .accesskey = e

system-integration-legend = Amsidef anagrawan
always-check-default =
    .label = Senqed yal tikelt deg usenker ma yella { -brand-short-name } d amsaɣ n tirawt amezwer
    .accesskey = n
check-default-button =
    .label = Senqed tura…
    .accesskey = t

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
search-engine-name =
    { PLATFORM() ->
        [macos] Amfeṛṛaz
        [windows] Anadi n isfulay
       *[other] { "" }
    }

search-integration-label =
    .label = Sireg { search-engine-name } ad inadi iznan
    .accesskey = n

config-editor-button =
    .label = Amaẓrag n twila…
    .accesskey = w

return-receipts-description = Wali amek ara yexdem { -brand-short-name } akked ibagan n wawwaḍ
return-receipts-button =
    .label = Inagan n waggaḍ…
    .accesskey = g

update-app-legend = Ileqman n { -brand-short-name }

# Variables:
#   $version (String): version of Thunderbird, e.g. 68.0.1
update-app-version = Lqem { $version }

allow-description = Eǧǧ { -brand-short-name }
automatic-updates-label =
    .label = Sebded s wudem awurman ileqman (yelha i tɣellist-inek)
    .accesskey = A
check-updates-label =
    .label = Senqed ma llan ileqman, acu kan eǧǧi-yi a t-nesbeddeɣ
    .accesskey = n

update-history-button =
    .label = Sken amazray n ileqman
    .accesskey = S

use-service =
    .label = Seqdec tanfa n ugilal i wesebded n ileqman
    .accesskey = b

cross-user-udpate-warning = Aɣewwaṛ-a ad yeddu meṛṛa deg yimiḍanen Windows akked imeɣna yesseqdacen asebded-a n { -brand-short-name }.

networking-legend = Tuqqna
proxy-config-description = Swel tarrayt n tuqqna n { -brand-short-name } ɣer Internet

network-settings-button =
    .label = Iɣewwaṛen…
    .accesskey = w

offline-legend = Aruqqin
offline-settings = Swel iɣewwaṛan n uskar aruqqin

offline-settings-button =
    .label = Aruqqin…
    .accesskey = r

diskspace-legend = Tallunt n udebṣi
offline-compact-folder =
    .label = Ssed akk ikaramen ma yella ad yeḥrez amkan ugar n
    .accesskey = a

compact-folder-size =
    .value = Asemday s MAṬ

## Note: The entities use-cache-before and use-cache-after appear on a single
## line in preferences as follows:
## use-cache-before [ textbox for cache size in MB ] use-cache-after

use-cache-before =
    .value = Seqdec arama
    .accesskey = q

use-cache-after = MAṬ n tallunt i tuffirt

##

smart-cache-label =
    .label = Snifel asefrek awurman n tuffirt
    .accesskey = v

clear-cache-button =
    .label = Sfeḍ tura
    .accesskey = S

fonts-legend = Tise&fsiyin d tiɣmiyin

default-font-label =
    .value = Tasefsit tamezwert:
    .accesskey = T

default-size-label =
    .value = Teɣzi:
    .accesskey = T

font-options-button =
    .label = Talɣut leqqayen…
    .accesskey = T

color-options-button =
    .label = Tiɣmiyin…
    .accesskey = m

display-width-legend = Iznan n udris ačuṛan

# Note : convert-emoticons-label 'Emoticons' are also known as 'Smileys', e.g. :-)
convert-emoticons-label =
    .label = Skeyn iẓuyaṛ am idlifen
    .accesskey = ẓ

display-text-label = Ticki teskaneḍ-d iznan n uḍris aččuran i yettwabedren:

style-label =
    .value = Aɣanib:
    .accesskey = b

regular-style-item =
    .label = Amagnu
bold-style-item =
    .label = Zur
italic-style-item =
    .label = Uknan
bold-italic-style-item =
    .label = Uknan azuran

size-label =
    .value = Teɣzi:
    .accesskey = T

regular-size-item =
    .label = Amagnu
bigger-size-item =
    .label = Muqqaṛ
smaller-size-item =
    .label = Meẓẓi

quoted-text-color =
    .label = Ini:
    .accesskey = n

search-input =
    .placeholder = Nadi

type-column-label =
    .label = Tawsit n ugbur
    .accesskey = g

action-column-label =
    .label = Tigawt
    .accesskey = g

save-to-label =
    .label = Sekles ifuyla ɣeṛ
    .accesskey = k

choose-folder-label =
    .label =
        { PLATFORM() ->
            [macos] Fren...
           *[other] Ḍum…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] F
           *[other] Ḍ
        }

always-ask-label =
    .label = Suter yal tikelt anda atkelseḍ ifuyla
    .accesskey = S


display-tags-text = Tibzimin zemrent ad ttwasqedcent akken ad gent taggayin neɣ ad smizzewrent iznan-inek.

new-tag-button =
    .label = Amaynut…
    .accesskey = m

edit-tag-button =
    .label = Ẓreg…
    .accesskey = Ẓ

delete-tag-button =
    .label = Kkes
    .accesskey = K

auto-mark-as-read =
    .label = Creḍ s wudem awurman iznan amzun ttwaɣran
    .accesskey = C

mark-read-no-delay =
    .label = Imir imir deg uskan
    .accesskey = d

## Note: This will concatenate to "After displaying for [___] seconds",
## using (mark-read-delay) and a number (seconds-label).

mark-read-delay =
    .label = Ticki yettwaskan di
    .accesskey = T

seconds-label = tasinin

##

open-msg-label =
    .value = Ldi iznan di:

open-msg-tab =
    .label = Iccer amaynut
    .accesskey = y

open-msg-window =
    .label = Asfaylu n yizen amaynut
    .accesskey = f

open-msg-ex-window =
    .label = Asfaylu n yizen yellan
    .accesskey = z

close-move-delete =
    .label = Mdel asfaylu/iccer n yizen deg unkaz neɣ di tukksa
    .accesskey = M

display-name-label =
    .value = Isem yettwaseknen:

condensed-addresses-label =
    .label = Sken kan isem iyemdanen yellan deg imedlis inu n tensa
    .accesskey = S

## Compose Tab

forward-label =
    .value = Welleh iznan:
    .accesskey = z

inline-label =
    .label = Deg umnaḍ

as-attachment-label =
    .label = Am umedday

extension-label =
    .label = Rnu asi qzef i yisem n ufaylu
    .accesskey = e

## Note: This will concatenate to "Auto Save every [___] minutes",
## using (auto-save-label) and a number (auto-save-end).

auto-save-label =
    .label = Asekles awurman yal
    .accesskey = w

auto-save-end = tisdatin

##

warn-on-send-accel-key =
    .label = Sentem ticki tesseqdaceḍ anegzum n unasiw akken ad tazneḍ izen
    .accesskey = t

spellcheck-label =
    .label = Senqed taɣdira send tuzzna
    .accesskey = S

spellcheck-inline-label =
    .label = Rmed taɣdira mara  teţaruḍ
    .accesskey = E

language-popup-label =
    .value = Tutlayt:
    .accesskey = t

download-dictionaries-link = Zdem ugar n imawalen

font-label =
    .value = Tasefsit:
    .accesskey = s

font-size-label =
    .value = Teɣzi:
    .accesskey = z

default-colors-label =
    .label = Seqdec initen imezwar n umeɣri
    .accesskey = d

font-color-label =
    .value = Tiɣmi n uḍris:
    .accesskey = m

bg-color-label =
    .value = Tiɣmi n ugilal:
    .accesskey = g

restore-html-label =
    .label = Err-d iɣewwaṛen n uwennez n tazwara
    .accesskey = E

default-format-label =
    .label = Seqdec taseddaṛt deg umḍiq n uḍris n tfekka s wudem amezwer
    .accesskey = c

format-description = Swel amek ara yeddu umasal n uḍris

send-options-label =
    .label = Azen iɣewwaṛen…
    .accesskey = A

autocomplete-description = Ticki tettaruḍ tansiwin deg iznan, wali inekcam inmeɣra di:

ab-label =
    .label = Imedlisen n tensa idiganen
    .accesskey = d

directories-label =
    .label = Aqeddac n ukaram:
    .accesskey = q

directories-none-label =
    .none = Ula Yiwen

edit-directories-label =
    .label = Ẓreg ikaramen...
    .accesskey = Ẓ

email-picker-label =
    .label = Rnu s wudem awurman tansiwin n yimayl tuffiɣin i nek:
    .accesskey = d

default-directory-label =
    .value = Akatar amezwar deg lldi n imedlis n tansiwin:
    .accesskey = S

default-last-label =
    .none = Akaram aneggaru yettwasqedcen

attachment-label =
    .label = Senqed ticeqqufin ur d neddi ara
    .accesskey = q

attachment-options-label =
    .label = Awalen n tsaruţ…
    .accesskey = w

enable-cloud-share =
    .label = Asumer n beṭṭu n ifuyla ugar n
cloud-share-size =
    .value = MAṬ

add-cloud-account =
    .label = Rnu…
    .accesskey = R
    .defaultlabel = Rnu…

remove-cloud-account =
    .label = Kkes
    .accesskey = K

find-cloud-providers =
    .value = Af-d ugar n yisaǧǧawen...

cloud-account-description = Rnu ameẓlu n usekles n useɣwen n ufaylu amaynut


## Privacy Tab

mail-content = Agbur n yimayl

remote-content-label =
    .label = Sireg agbur anmeggag deg iznan
    .accesskey = m

exceptions-button =
    .label = Tisuraf...
    .accesskey = r

remote-content-info =
    .value = Issin ugar ɣef wuguren n tbaḍnit n ugbur anmeggag

web-content = Agbur Web

history-label =
    .label = Cfu ɣef ismal web akked iseɣwan aniɣer rziɣ
    .accesskey = C

cookies-label =
    .label = Qbel inagan n tuqqna seg ismal
    .accesskey = Q

third-party-label =
    .value = Qbel inagan n tuqqna seg wis kraḍ:
    .accesskey = b

third-party-always =
    .label = Yal tikelt
third-party-never =
    .label = Werǧin
third-party-visited =
    .label = Seg iseɣwan yettwarzan

keep-label =
    .value = Ḥrez arma:
    .accesskey = Ḥ

keep-expire =
    .label = ad mten
keep-close =
    .label = Ad medleɣ  { -brand-short-name }
keep-ask =
    .label = suter-iyi-d yal tikelt

cookies-button =
    .label = Sken
    .accesskey = S

do-not-track-label =
    .label = Ad yazen tamuli “ur sfu$yul ara” γer ismal web akken ad gzun d akken ur tebγiḍ ara asfuγel
    .accesskey = n

learn-button =
    .label = Issin ugar

passwords-description = { -brand-short-name } yezmer ad yecfu ɣef awalen uffiren n imiḍan-inek imeṛṛa.

passwords-button =
    .label = Awalen uffiren iţwakelsen…
    .accesskey = w

master-password-description = Awal uffir agejdan ad immesten akk awalen-ik uffiren, acukan issefk ad tsekcmeḍ yiwen i yal tiɣimit.

master-password-label =
    .label = Seqdec awal uffir agejdan
    .accesskey = S

master-password-button =
    .label = Snifel awal uffir agejdan…
    .accesskey = S


primary-password-description = Awal uffir agejdan ad yeḥrez akk awalen-ik·im uffiren, maca yessefk ad t-teskecmeḍ yiwet tikkelt i yal tiɣimit.

primary-password-label =
    .label = Seqdec awal uffir agejdan
    .accesskey = U

primary-password-button =
    .label = Beddel awal uffir agejdan…
    .accesskey = C

forms-primary-pw-fips-title = Aql-ak·akem tura deg uskar FIPS. FPIS yesra awal uffir agejdan arilem.
forms-master-pw-fips-desc = Asnifel n wawal uffir ur yeddi ara


junk-description = Sbadu iɣewwaren imezwar n yimaylen ispamen. Iɣewwaren n yimaylen ispamen n umiḍan yezmer ad ittuswel deg iɣewwaren n umiḍan.

junk-label =
    .label = Ticki ceṛḍeɣ iznan inu amzun d ispamen:
    .accesskey = c

junk-move-label =
    .label = Awi-ten ɣer ukaram "Aspam" n umiḍan
    .accesskey = w

junk-delete-label =
    .label = Kkes-iten
    .accesskey = K

junk-read-label =
    .label = Creḍ iznan ispamen amzun ttwaɣṛan
    .accesskey = C

junk-log-label =
    .label = Rmed asniɣmes n imzizdig aspam aserwestan
    .accesskey = R

junk-log-button =
    .label = Sken aɣmis
    .accesskey = k

reset-junk-button =
    .label = Wennez isefka yinek n ukayad
    .accesskey = n

phishing-description = { -brand-short-name } yezmer ad yesleḍ iznan igebren imaylen n ukellex s unadi n tetikniyin yettwasnen i yettuseqdacen akken ak-kelxen.

phishing-label =
    .label = Ini-d ma yella izen-agi ad ɣareɣ akka tura d imayl n ukellex
    .accesskey = I

antivirus-description = { -brand-short-name } yezmer ad t-yessifusu i umgal avirus akken ad yesleḍ iznan n tirawt ukcimen ɣef ivirusen send ad ttwakelsen.

antivirus-label =
    .label = Sireg imsaɣen n imgal ivirusen akked ad ɛezlen iznan d-ikecmen
    .accesskey = S

certificate-description = Ticki aqeddac isuter iselkan-iw udmawanen:

certificate-auto =
    .label = Fren yiwen s wudem awurman
    .accesskey = S

certificate-ask =
    .label = Steqsi yid yal tikelt
    .accesskey = A

ocsp-label =
    .label = Suter iqeddacen imerrayen OCSP iwakken ad sentmen taneɣbalt tamirant n iselkan
    .accesskey = S

certificate-button =
    .label = Sefrek iselkan…
    .accesskey = S

security-devices-button =
    .label = Ibenkan n tɣellist…
    .accesskey = k

## Chat Tab

startup-label =
    .value = Di tnekra n { -brand-short-name }:
    .accesskey = D

offline-label =
    .label = Eǧǧ amiḍan inu n udiwenni usrid di war  tuqqna

auto-connect-label =
    .label = Qqen amiḍan inu n udiwenni s srid s wudem awurman

## Note: idle-label is displayed first, then there's a field where the user
## can enter a number, and itemTime is displayed at the end of the line.
## The translations of the idle-label and idle-time-label parts don't have
## to mean the exact same thing as in English; please try instead to
## translate the whole sentence.

idle-label =
    .label = Eǧǧ inermisen-iw ad ẓren d akken ulac-iyi di
    .accesskey = I

idle-time-label = tisdatin anda ulac-iyi

##

away-message-label =
    .label = u sbadu addad inu ɣer Ulac-it s yizen-agi n waddad
    .accesskey = U

send-typing-label =
    .label = Azen alɣu ticki ttaruɣ deg udiwenni
    .accesskey = c

notification-label = Ticki iznan ttuwelhen mara d-awḍen:

show-notification-label =
    .label = Sken alɣu:
    .accesskey = ɣ

notification-all =
    .label = s yisem n umazan akked teskant n yizen
notification-name =
    .label = S yisem n umazan kan
notification-empty =
    .label = swar talɣut

notification-type-label =
    .label =
        { PLATFORM() ->
            [macos] Ḥerrek tignit n tacirra
           *[other] Sebrureq aferdis deg ufeggag n yirmuden
        }
    .accesskey =
        { PLATFORM() ->
            [macos] o
           *[other] F
        }

chat-play-sound-label =
    .label = Urar imesli
    .accesskey = l

chat-play-button =
    .label = Urar
    .accesskey = U

chat-system-sound-label =
    .label = Imesli n unagraw amezwer i yimayl amaynut
    .accesskey = m

chat-custom-sound-label =
    .label = Seqdec afaylu-yagi n imesli
    .accesskey = S

chat-browse-sound-button =
    .label = Ḍum…
    .accesskey = Ḍ

theme-label =
    .value = Asentel:
    .accesskey = T

style-thunderbird =
    .label = Thunderbird
style-bubbles =
    .label = Tililac
style-dark =
    .label = Aberkan
style-paper =
    .label = Tawriqt
style-simple =
    .label = Aḥerfi

preview-label = Taskant:
no-preview-label = Ulac taskant
no-preview-description = Asentel-agi mačči d ameɣtu neɣ ulac-it akka tura (azegrir yettwasens, askar war taruẓi, ...).

chat-variant-label =
    .value = Talmest:
    .accesskey = V

chat-header-label =
    .label = Sken-d aqeṛṛu
    .accesskey = H

# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-input-box =
    .style = width: 19em
    .placeholder =
        { PLATFORM() ->
            [windows] Af-d deg textiṛiyin
           *[other] Af-d deg yismenyafen
        }

## Preferences UI Search Results

search-results-header = Igmaḍ n unadi

# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] Nesḥassef! Ulac igmaḍ deg textiṛiyin i "<span data-l10n-name="query"></span>"
       *[other] Nesḥassef! Ulac igmaḍ deg yismenyifen i "<span data-l10n-name="query"></span>"
    }

search-results-help-link = Tesriḍ tallelt? Rzu γer <a data-l10n-name="url">{ -brand-short-name } Tallelt</a>
