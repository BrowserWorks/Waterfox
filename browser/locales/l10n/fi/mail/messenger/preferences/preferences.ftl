# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

close-button =
    .aria-label = Sulje

preferences-title =
    .title =
        { PLATFORM() ->
            [windows] Asetukset
           *[other] Asetukset
        }

pane-general-title = Yleiset
category-general =
    .tooltiptext = { pane-general-title }

pane-compose-title = Viestin kirjoitus
category-compose =
    .tooltiptext = Viestin kirjoitus

pane-privacy-title = Yksityisyys ja turvallisuus
category-privacy =
    .tooltiptext = Yksityisyys ja turvallisuus

pane-chat-title = Keskustelut
category-chat =
    .tooltiptext = Keskustelut

pane-calendar-title = Kalenteri
category-calendar =
    .tooltiptext = Kalenteri

general-language-and-appearance-header = Kieli ja ulkoasu

general-incoming-mail-header = Saapuva sähköposti

general-files-and-attachment-header = Tiedostot ja liitteet

general-tags-header = Tunnisteet

general-reading-and-display-header = Lukeminen ja näyttäminen

general-updates-header = Päivitykset

general-network-and-diskspace-header = Verkko ja levytila

general-indexing-label = Indeksointi

composition-category-header = Viestin luominen

composition-attachments-header = Liitteet

composition-spelling-title = Oikoluku

compose-html-style-title = HTML-tyyli

composition-addressing-header = Osoittaminen

privacy-main-header = Yksityisyys

privacy-passwords-header = Salasanat

privacy-junk-header = Roska

collection-header = { -brand-short-name }in tietojen keräys ja käyttö

collection-description = Pyrimme antamaan sinulle vapauden valita ja keräämme vain tietoja, joita tarvitsemme voidaksemme tarjota { -brand-short-name }in kaikille ja parantaa sitä. Kysymme aina lupaa ennen kuin vastaanotamme henkilötietoja.
collection-privacy-notice = Tietosuojakäytäntö

collection-health-report-telemetry-disabled = Et enää salli { -vendor-short-name }in vastaanottaa teknisiä ja käyttötilastoja. Kaikki aikaisemmat tiedot poistetaan 30 päivän kuluessa.
collection-health-report-telemetry-disabled-link = Lue lisää

collection-health-report =
    .label = Salli, että { -brand-short-name } lähettää teknisiä ja käyttötilastoja { -vendor-short-name }lle
    .accesskey = a
collection-health-report-link = Lue lisää

# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = Tietojen kerääminen ei ole käytössä tässä koostamiskokoonpanossa

collection-backlogged-crash-reports =
    .label = Salli, että { -brand-short-name } lähettää lähettämättömät kaatumisilmoitukset puolestasi
    .accesskey = a
collection-backlogged-crash-reports-link = Lue lisää

privacy-security-header = Turvallisuus

privacy-scam-detection-title = Huijausten havaitseminen

privacy-anti-virus-title = Virustorjunta

privacy-certificates-title = Varmenteet

chat-pane-header = Keskustelu

chat-status-title = Tila

chat-notifications-title = Ilmoitukset

chat-pane-styling-header = Tyyli

choose-messenger-language-description = Valitse kieli, jolla näytetään sovelluksen { -brand-short-name } valikot, viestit ja ilmoitukset.
manage-messenger-languages-button =
    .label = Aseta vaihtoehdot...
    .accesskey = v
confirm-messenger-language-change-description = Toteuta nämä muutokset käynnistämällä { -brand-short-name } uudelleen
confirm-messenger-language-change-button = Toteuta ja käynnistä uudelleen

update-setting-write-failure-title = Virhe päivitysasetusten päivittämisessä

# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    { -brand-short-name } törmäsi virheeseen, eikä voinut tallentaa tätä muutosta. Huomaa, että tämän päivitysasetuksen muuttaminen edellyttää kirjoitusoikeutta alla mainittuun tiedostoon. Järjestelmänvalvojasi saattaa pystyä ratkaisemaan tämän virheen antamalla ryhmälle "Users" täydet oikeudet tähän tiedostoon
    
    Ei voitu kirjoittaa tiedostoon: { $path }

update-in-progress-title = Päivitys käynnissä

update-in-progress-message = Haluatko, että { -brand-short-name } jatkaa tätä päivitystä?

update-in-progress-ok-button = &Hylkää
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Jatka

addons-button = Laajennukset ja teemat

## OS Authentication dialog

# This message can be seen by trying to add a Master Password.
master-password-os-auth-dialog-message-win = Luo pääsalasana kirjoittamalla Windows-kirjautumistietosi. Tämä auttaa suojaamaan tiliesi turvallisuutta.

# This message can be seen by trying to add a Master Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
master-password-os-auth-dialog-message-macosx = luoda pääsalasanan

# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Luo pääsalasana kirjoittamalla Windows-kirjautumistietosi. Tämä auttaa suojaamaan tilejäsi.

# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = Luo pääsalasana

# Don't change this label.
master-password-os-auth-dialog-caption = { -brand-full-name }

## General Tab

focus-search-shortcut =
    .key = f
focus-search-shortcut-alt =
    .key = k

general-legend = { -brand-short-name }in aloitussivu

start-page-label =
    .label = Näytä aloitussivuna viestikentässä { -brand-short-name }in käynnistyessä:
    .accesskey = N

location-label =
    .value = Osoite:
    .accesskey = O
restore-default-label =
    .label = Palauta oletusasetus
    .accesskey = P

default-search-engine = Oletushakukone
add-search-engine =
    .label = Lisää tiedostosta
    .accesskey = L
remove-search-engine =
    .label = Poista
    .accesskey = p

minimize-to-tray-label =
    .label = Kun { -brand-short-name } on pienennetty, piilota se
    .accesskey = p

new-message-arrival = Uuden viestin saapuessa:
mail-play-sound-label =
    .label =
        { PLATFORM() ->
            [macos] Toista seuraava äänitiedosto:
           *[other] Soita äänimerkki
        }
    .accesskey =
        { PLATFORM() ->
            [macos] ä
           *[other] o
        }
mail-play-button =
    .label = Toista
    .accesskey = T

change-dock-icon = Muokkaa sovelluskuvakkeen asetuksia
app-icon-options =
    .label = Sovelluskuvakkeen asetukset…
    .accesskey = v

notification-settings = Ilmoitukset ja oletusääni voidaan poistaa käytöstä Asetukset-ikkunan Ilmoitukset-paneelissa.

animated-alert-label =
    .label = Näytä hälytys
    .accesskey = ä
customize-alert-label =
    .label = Muokkaa…
    .accesskey = M

tray-icon-label =
    .label = Näytä ilmoitusalueen kuvake
    .accesskey = i

mail-system-sound-label =
    .label = Järjestelmän oletusääni uudelle sähköpostille
    .accesskey = J
mail-custom-sound-label =
    .label = Käytä seuraavaa äänitiedostoa
    .accesskey = K
mail-browse-sound-button =
    .label = Selaa…
    .accesskey = S

enable-gloda-search-label =
    .label = Ota käyttöön viestien yleishaku ja indeksointi
    .accesskey = O

datetime-formatting-legend = Päiväyksen ja ajan muoto
language-selector-legend = Kieli

allow-hw-accel =
    .label = Käytä laitteistokiihdytystä jos mahdollista
    .accesskey = l

store-type-label =
    .value = Viestisäilö uusilla tileillä:
    .accesskey = V

mbox-store-label =
    .label = Tiedosto jokaiselle kansiolle (mbox)
maildir-store-label =
    .label = Tiedosto jokaiselle viestille (maildir)

scrolling-legend = Vieritys
autoscroll-label =
    .label = Vieritä sivua automaattisesti
    .accesskey = V
smooth-scrolling-label =
    .label = Vieritä sivua tasaisesti
    .accesskey = e

system-integration-legend = Järjestelmään liittäminen
always-check-default =
    .label = Tarkista aina onko { -brand-short-name } järjestelmän oletussähköpostiohjelma
    .accesskey = T
check-default-button =
    .label = Tarkista heti…
    .accesskey = h

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windowsin haku
       *[other] { "" }
    }

search-integration-label =
    .label = Salli hakukoneen { search-engine-name } etsiä viesteistä
    .accesskey = S

config-editor-button =
    .label = Asetusten muokkain…
    .accesskey = A

return-receipts-description = Määrittele, kuinka { -brand-short-name } käsittelee vastaanottokuittauksia
return-receipts-button =
    .label = Vastaanottokuittaukset…
    .accesskey = V

update-app-legend = { -brand-short-name }-päivitykset

# Variables:
#   $version (String): version of Thunderbird, e.g. 68.0.1
update-app-version = Versio { $version }

allow-description = Anna sovellukselle { -brand-short-name } lupa
automatic-updates-label =
    .label = Asenna päivitykset automaattisesti (suositeltu: turvallisin)
    .accesskey = A
check-updates-label =
    .label = Hae päivityksiä, mutta minä päätän asennetaanko ne
    .accesskey = H

update-history-button =
    .label = Näytä päivityshistoria
    .accesskey = N

use-service =
    .label = Asenna päivitykset taustapalvelun avulla
    .accesskey = u

cross-user-udpate-warning = Tämä asetus vaikuttaa kaikkiin tätä { -brand-short-name }-asennusta käyttäviin Windows-tileihin ja { -brand-short-name }-profiileihin.

networking-legend = Yhteysasetukset
proxy-config-description = Määritä, kuinka { -brand-short-name } yhdistää internetiin

network-settings-button =
    .label = Yhteysasetukset…
    .accesskey = Y

offline-legend = Yhteydetön tila
offline-settings = Määritä verkkoyhteydettömän tilan asetukset

offline-settings-button =
    .label = Yhteydetön tila…
    .accesskey = h

diskspace-legend = Levytilan käyttö
offline-compact-folder =
    .label = Tiivistä kansiot kun se säästää yhteensä yli
    .accesskey = T

compact-folder-size =
    .value = Mt

## Note: The entities use-cache-before and use-cache-after appear on a single
## line in preferences as follows:
## use-cache-before [ textbox for cache size in MB ] use-cache-after

use-cache-before =
    .value = Käytä enintään
    .accesskey = K

use-cache-after = Mt:a levytilaa väliaikaistiedostoille

##

smart-cache-label =
    .label = Ohita automaattinen välimuistin hallinta
    .accesskey = O

clear-cache-button =
    .label = Tyhjennä heti
    .accesskey = T

fonts-legend = Kirjasinlajit ja värit

default-font-label =
    .value = Oletuskirjasin:
    .accesskey = O

default-size-label =
    .value = Koko:
    .accesskey = K

font-options-button =
    .label = Lisäasetukset…
    .accesskey = L

color-options-button =
    .label = Värit…
    .accesskey = V

display-width-legend = Pelkkä teksti -viestit

# Note : convert-emoticons-label 'Emoticons' are also known as 'Smileys', e.g. :-)
convert-emoticons-label =
    .label = Näytä hymiöt kuvina
    .accesskey = N

display-text-label = Kirjasinlaji lainattaessa pelkkä teksti -viestejä:

style-label =
    .value = Tyyli:
    .accesskey = T

regular-style-item =
    .label = Normaali
bold-style-item =
    .label = Lihavoitu
italic-style-item =
    .label = Kursivoitu
bold-italic-style-item =
    .label = Lihavoitu kursiivi

size-label =
    .value = Koko:
    .accesskey = o

regular-size-item =
    .label = Normaali
bigger-size-item =
    .label = Suurempi
smaller-size-item =
    .label = Pienempi

quoted-text-color =
    .label = Väri:
    .accesskey = V

search-input =
    .placeholder = Etsi

type-column-label =
    .label = Sisältötyyppi
    .accesskey = S

action-column-label =
    .label = Toiminto
    .accesskey = o

save-to-label =
    .label = Tallenna kansioon
    .accesskey = T

choose-folder-label =
    .label =
        { PLATFORM() ->
            [macos] Valitse…
           *[other] Selaa…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] V
           *[other] S
        }

always-ask-label =
    .label = Kysy aina tiedoston tallennuskansio
    .accesskey = K


display-tags-text = Voit luokitella ja merkitä tärkeitä viestejä tunnuksilla.

new-tag-button =
    .label = Uusi…
    .accesskey = U

edit-tag-button =
    .label = Muokkaa…
    .accesskey = M

delete-tag-button =
    .label = Poista
    .accesskey = P

auto-mark-as-read =
    .label = Merkitse viestit automaattisesti luetuksi
    .accesskey = M

mark-read-no-delay =
    .label = Kun ne avataan
    .accesskey = K

## Note: This will concatenate to "After displaying for [___] seconds",
## using (mark-read-delay) and a number (seconds-label).

mark-read-delay =
    .label = Kun ne ovat olleet avattuna
    .accesskey = u

seconds-label = sekuntia

##

open-msg-label =
    .value = Avaa viestit:

open-msg-tab =
    .label = Uuteen välilehteen
    .accesskey = v

open-msg-window =
    .label = Uuteen viesti-ikkunaan
    .accesskey = i

open-msg-ex-window =
    .label = Avoinna olevaan viesti-ikkunaan
    .accesskey = A

close-move-delete =
    .label = Sulje viesti-ikkuna kun viesti siirretään tai poistetaan
    .accesskey = v

display-name-label =
    .value = Näyttönimi:

condensed-addresses-label =
    .label = Näytä osoitekirjassa olevien nimet ilman sähköpostiosoitetta
    .accesskey = N

## Compose Tab

forward-label =
    .value = Välitä viestit:
    .accesskey = V

inline-label =
    .label = Viestirungossa

as-attachment-label =
    .label = Liitteenä

extension-label =
    .label = lisää tiedostonimeen pääte
    .accesskey = s

## Note: This will concatenate to "Auto Save every [___] minutes",
## using (auto-save-label) and a number (auto-save-end).

auto-save-label =
    .label = Tallenna viestit automaattisesti
    .accesskey = T

auto-save-end = minuutin välein

##

warn-on-send-accel-key =
    .label = Pyydä vahvistus kun viesti lähetetään pikanäppäimillä
    .accesskey = y

spellcheck-label =
    .label = Oikolue viestit ennen lähettämistä
    .accesskey = O

spellcheck-inline-label =
    .label = Oikolue teksti kirjoitettaessa
    .accesskey = k

language-popup-label =
    .value = Kieli:
    .accesskey = K

download-dictionaries-link = Hae sanastoja

font-label =
    .value = Kirjasin:
    .accesskey = n

font-size-label =
    .value = Koko:
    .accesskey = K

default-colors-label =
    .label = Käytä lukijan oletusvärejä
    .accesskey = o

font-color-label =
    .value = Tekstin väri:
    .accesskey = s

bg-color-label =
    .value = Taustaväri:
    .accesskey = a

restore-html-label =
    .label = Palauta oletukset
    .accesskey = P

default-format-label =
    .label = Käytä oletuksena kappalemuotoilua leipätekstin sijaan
    .accesskey = p

format-description = Muokkaa viestimuodon lähetysasetuksia:

send-options-label =
    .label = Lähetysasetukset…
    .accesskey = L

autocomplete-description = Kirjoitettaessa vastaanottajia, etsi vastineita kohteesta:

ab-label =
    .label = Paikalliset osoitekirjat
    .accesskey = P

directories-label =
    .label = Hakemistopalvelin:
    .accesskey = H

directories-none-label =
    .none = Ei mitään

edit-directories-label =
    .label = Muokkaa hakemistoja…
    .accesskey = M

email-picker-label =
    .label = Lisää lähetettyjen viestien vastaanottajat osoitekirjaan:
    .accesskey = L

default-directory-label =
    .value = Oletuskansio osoitekirjan ikkunassa:
    .accesskey = k

default-last-label =
    .none = Viimeksi käytetty kansio

attachment-label =
    .label = Tarkista puuttuuko viestistä liitetiedosto
    .accesskey = p

attachment-options-label =
    .label = Avainsanat…
    .accesskey = A

enable-cloud-share =
    .label = Ehdota palvelua yli
cloud-share-size =
    .value = Mt:n tiedostoille

add-cloud-account =
    .label = Lisää…
    .accesskey = L
    .defaultlabel = Lisää…

remove-cloud-account =
    .label = Poista
    .accesskey = P

find-cloud-providers =
    .value = Etsi lisää palveluntarjoajia…

cloud-account-description = Lisää uusi tiedostoja linkittävä tallennuspalvelu


## Privacy Tab

mail-content = Sähköpostin sisältö

remote-content-label =
    .label = Salli etäsisältö sähköposteissa
    .accesskey = S

exceptions-button =
    .label = Poikkeukset…
    .accesskey = k

remote-content-info =
    .value = Lue lisää etäsisällön vaikutuksista yksityisyydensuojaan

web-content = Verkkosisältö

history-label =
    .label = Muista avaamani sivustot ja linkit
    .accesskey = M

cookies-label =
    .label = Sivustot saavat asettaa evästeitä
    .accesskey = v

third-party-label =
    .value = Salli kolmannen osapuolen evästeet:
    .accesskey = m

third-party-always =
    .label = Aina
third-party-never =
    .label = Ei milloinkaan
third-party-visited =
    .label = Vierailluilta sivustoilta

keep-label =
    .value = Säilytä evästeet:
    .accesskey = t

keep-expire =
    .label = kunnes ne vanhenevat
keep-close =
    .label = kunnes { -brand-short-name } suljetaan
keep-ask =
    .label = kysy aina erikseen

cookies-button =
    .label = Näytä evästeet…
    .accesskey = N

do-not-track-label =
    .label = Lähetä sivustoille ”Do Not Track”-signaali, joka kertoo ettet halua sinua seurattavan
    .accesskey = s

learn-button =
    .label = Lue lisää

passwords-description = Voit tallentaa { -brand-short-name }iin kaikkien sähköpostitiliesi salasanat.

passwords-button =
    .label = Tallennetut salasanat…
    .accesskey = T

master-password-description = Pääsalasanalla suojaat kaikkien sähköpostitiliesi salasanat, mutta se kysytään kerran joka istunnossa.

master-password-label =
    .label = Ota pääsalasana käyttöön
    .accesskey = p

master-password-button =
    .label = Muuta pääsalasanaa…
    .accesskey = M


primary-password-description = Pääsalasana suojaa kaikkien sähköpostitiliesi salasanat, mutta se kysytään kerran joka istunnossa.

primary-password-label =
    .label = Käytä pääsalasanaa
    .accesskey = K

primary-password-button =
    .label = Vaihda pääsalasana…
    .accesskey = V

forms-primary-pw-fips-title = Olet parhaillaan FIPS-tilassa. FIPS edellyttää, että pääsalasana ei ole tyhjä.
forms-master-pw-fips-desc = Salasanan vaihto epäonnistui


junk-description = Muokkaa alta roskapostisuodattimen oletusasetuksia. Tilikohtaisia asetuksia voi muokata Tilien asetuksista.

junk-label =
    .label = Kun merkitsen viestin roskapostiksi:
    .accesskey = K

junk-move-label =
    .label = Siirrä se tilin roskapostikansioon
    .accesskey = S

junk-delete-label =
    .label = Poista se
    .accesskey = P

junk-read-label =
    .label = Merkitse roskapostiviestit luetuiksi
    .accesskey = M

junk-log-label =
    .label = Pidä roskapostilokia
    .accesskey = P

junk-log-button =
    .label = Näytä loki
    .accesskey = N

reset-junk-button =
    .label = Nollaa harjoitustiedot
    .accesskey = N

phishing-description = { -brand-short-name } voi yrittää tunnistaa viestejä sähköpostihuijauksiksi tavanomaisia huijaustekniikoita etsien.

phishing-label =
    .label = Näytä varoitus epäillyistä sähköpostihuijauksista
    .accesskey = N

antivirus-description = { -brand-short-name }issä virustorjuntaohjelman voi antaa tarkistaa saapuvat sähköpostiviestit virusten varalta ennen kuin ne tallennetaan tietokoneelle.

antivirus-label =
    .label = Virustorjuntaohjelmat voivat asettaa yksittäiset viestit karanteeniin
    .accesskey = V

certificate-description = Palvelimen pyytäessä henkilökohtaista varmennettani:

certificate-auto =
    .label = Valitse sellainen automaattisesti
    .accesskey = V

certificate-ask =
    .label = Kysy joka kerta
    .accesskey = K

ocsp-label =
    .label = Vahvista varmenteiden ajantasainen voimassaolo OCSP-vastaajapalvelimilta
    .accesskey = C

certificate-button =
    .label = Hallitse varmenteita…
    .accesskey = H

security-devices-button =
    .label = Turvalaitteet…
    .accesskey = T

## Chat Tab

startup-label =
    .value = Kun { -brand-short-name } käynnistyy:
    .accesskey = T

offline-label =
    .label = Älä yhdistä pikaviestitilejäni

auto-connect-label =
    .label = Yhdistä automaattisesti pikaviestitilit

## Note: idle-label is displayed first, then there's a field where the user
## can enter a number, and itemTime is displayed at the end of the line.
## The translations of the idle-label and idle-time-label parts don't have
## to mean the exact same thing as in English; please try instead to
## translate the whole sentence.

idle-label =
    .label = Näytä tuttaville kun tietokoneellani ei tapahdu mitään
    .accesskey = A

idle-time-label = minuuttiin

##

away-message-label =
    .label = ja aseta minut poissaolevaksi tämän viestin kera:
    .accesskey = A

send-typing-label =
    .label = Lähetä tieto kirjoittamisesta keskustelujen aikana
    .accesskey = L

notification-label = Kun sinulle osoitettu viesti saapuu:

show-notification-label =
    .label = Näytä ilmoituksessa:
    .accesskey = i

notification-all =
    .label = lähettäjän nimi ja viestin esikatselu
notification-name =
    .label = vain lähettäjän nimi
notification-empty =
    .label = ilman lisätietoja

notification-type-label =
    .label =
        { PLATFORM() ->
            [macos] Animoi Dockin kohde
           *[other] Vilkuta työkalupalkin kohdetta
        }
    .accesskey =
        { PLATFORM() ->
            [macos] A
           *[other] V
        }

chat-play-sound-label =
    .label = Toista ääni
    .accesskey = a

chat-play-button =
    .label = Toista
    .accesskey = T

chat-system-sound-label =
    .label = Järjestelmän oletusääni uudelle sähköpostille
    .accesskey = J

chat-custom-sound-label =
    .label = Käytä seuraavaa äänitiedostoa
    .accesskey = K

chat-browse-sound-button =
    .label = Selaa…
    .accesskey = S

theme-label =
    .value = Teema:
    .accesskey = T

style-thunderbird =
    .label = Thunderbird
style-bubbles =
    .label = Kuplat
style-dark =
    .label = Tumma
style-paper =
    .label = Paperiarkit
style-simple =
    .label = Yksinkertainen

preview-label = Esikatselu:
no-preview-label = Esikatselu ei ole käytettävissä
no-preview-description = Tämä teema ei ole kelvollinen tai sitä ei tilapäisesti ole saatavilla (estetty liitännäinen, vikasietotila, …).

chat-variant-label =
    .value = Muunnelma:
    .accesskey = M

chat-header-label =
    .label = Näytä otsikko
    .accesskey = O

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
            [windows] Etsi asetuksista
           *[other] Etsi asetuksista
        }

## Preferences UI Search Results

search-results-header = Hakutulokset

# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] Pahoittelut! Ei hakutuloksia asetuksista haulle ”<span data-l10n-name="query"></span>”.
       *[other] Pahoittelut! Ei hakutuloksia asetuksista haulle ”<span data-l10n-name="query"></span>”.
    }

search-results-help-link = Tarvitsetko apua? Vieraile <a data-l10n-name="url">{ -brand-short-name }-tuessa</a>
