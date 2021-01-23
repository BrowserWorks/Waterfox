# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

e2e-intro-description = Salattujen tai digitaalisesti allekirjoitettujen viestien lähettämistä varten on määritettävä joko OpenPGP- tai S/MIME-salaustekniikka.

e2e-intro-description-more = Ota OpenPGP käyttöösi valitsemalla henkilökohtainen avaimesi, tai S/MIME valitsemalla henkilökohtainen varmenteesi. Henkilökohtaista avainta tai varmennetta varten sinulla on vastaava oma salainen avain.

openpgp-key-user-id-label = Tili / käyttäjätunnus
openpgp-keygen-title-label =
    .title = Luo OpenPGP-avain
openpgp-cancel-key =
    .label = Peruuta
    .tooltiptext = Peruuta avaimen luonti
openpgp-key-gen-expiry-title =
    .label = Avaimen voimassaoloaika
openpgp-key-gen-expire-label = Avain vanhenee
openpgp-key-gen-days-label =
    .label = vuorokaudessa
openpgp-key-gen-months-label =
    .label = kuukaudessa
openpgp-key-gen-years-label =
    .label = vuodessa
openpgp-key-gen-no-expiry-label =
    .label = Avain ei vanhene
openpgp-key-gen-key-size-label = Avaimen koko
openpgp-key-gen-console-label = Avaimen luominen
openpgp-key-gen-key-type-label = Avaintyyppi
openpgp-key-gen-key-type-rsa =
    .label = RSA
openpgp-key-gen-key-type-ecc =
    .label = ECC (elliptinen käyrä)
openpgp-generate-key =
    .label = Luo avain
    .tooltiptext = Luo uuden salauksessa ja/tai allekirjoittamisessa tarvittavan OpenPGP -yhteensopivan avaimen
openpgp-advanced-prefs-button-label =
    .label = Lisäasetukset…
openpgp-keygen-desc = <a data-l10n-name="openpgp-keygen-desc-link">HUOMAA: Avaimen luominen saattaa kestää useita minuutteja.</a> Älä sulje sovellusta avaimen luomisen aikana. Aktiivinen selaaminen tai muiden levyintensiivisten toimintojen suorittaminen avaimen luomisen aikana tehostaa 'satunnaisuusaluetta' ja nopeuttaa prosessia. Kun avaimen luominen valmistuu, siitä annetaan ilmoitus.

openpgp-key-expiry-label =
    .label = Vanheneminen

openpgp-key-id-label =
    .label = Avaimen tunniste (ID)

openpgp-cannot-change-expiry = Tämä on avain, jolla on monimutkainen rakenne. Sen voimassaoloajan muuttamista ei tueta.

openpgp-key-man-title =
    .title = OpenPGP-avainhallinta
openpgp-key-man-generate =
    .label = Uusi avainpari
    .accesskey = U
openpgp-key-man-gen-revoke =
    .label = Kumoamisvarmenne
    .accesskey = K
openpgp-key-man-ctx-gen-revoke-label =
    .label = Luo ja tallenna kumoamisvarmenne

openpgp-key-man-file-menu =
    .label = Tiedosto
    .accesskey = T
openpgp-key-man-edit-menu =
    .label = Muokkaa
    .accesskey = M
openpgp-key-man-view-menu =
    .label = Näytä
    .accesskey = N
openpgp-key-man-generate-menu =
    .label = Luo
    .accesskey = L
openpgp-key-man-keyserver-menu =
    .label = Avainpalvelin
    .accesskey = A

openpgp-key-man-import-public-from-file =
    .label = Tuo julkiset avaimet tiedostosta
    .accesskey = T
openpgp-key-man-import-secret-from-file =
    .label = Tuo salaiset avaimet tiedostosta
openpgp-key-man-import-sig-from-file =
    .label = Tuo kumoamiset tiedostosta
openpgp-key-man-import-from-clipbrd =
    .label = Tuo avaimet leikepöydältä
    .accesskey = u
openpgp-key-man-import-from-url =
    .label = Tuo avaimet verkko-osoitteesta
    .accesskey = o
openpgp-key-man-export-to-file =
    .label = Vie julkiset avaimet tiedostoon
    .accesskey = V
openpgp-key-man-send-keys =
    .label = Lähetä julkiset avaimet sähköpostilla
    .accesskey = e
openpgp-key-man-backup-secret-keys =
    .label = Varmuuskopioi salaiset avaimet tiedostoon
    .accesskey = r

openpgp-key-man-discover-cmd =
    .label = Etsi avaimia verkossa
    .accesskey = E
openpgp-key-man-discover-prompt = Etsi OpenPGP-avaimia verkossa, avainpalvelimissa tai WKD-protokollaa käyttäen kirjoittamalla joko sähköpostiosoitteesi tai avaimesi tunniste (ID).
openpgp-key-man-discover-progress = Etsitään…

openpgp-key-copy-key =
    .label = Kopioi julkinen avain
    .accesskey = o

openpgp-key-export-key =
    .label = Vie julkinen avain tiedostoon
    .accesskey = j

openpgp-key-backup-key =
    .label = Varmuuskopioi salainen avain tiedostoon
    .accesskey = s

openpgp-key-send-key =
    .label = Lähetä julkinen avain sähköpostilla
    .accesskey = t

openpgp-key-man-copy-to-clipbrd =
    .label = Kopioi julkiset avaimet leikepöydälle
    .accesskey = d
openpgp-key-man-ctx-expor-to-file-label =
    .label = Vie avaimet tiedostoon
openpgp-key-man-ctx-copy-to-clipbrd-label =
    .label = Kopioi julkiset avaimet leikepöydälle

openpgp-key-man-close =
    .label = Sulje
openpgp-key-man-reload =
    .label = Lataa avainvälimuisti uudelleen
    .accesskey = L
openpgp-key-man-change-expiry =
    .label = Muuta vanhemenispäivää
    .accesskey = t
openpgp-key-man-del-key =
    .label = Poista avaimia
    .accesskey = P
openpgp-delete-key =
    .label = Poista avain
    .accesskey = a
openpgp-key-man-revoke-key =
    .label = Kumoa avain
    .accesskey = m
openpgp-key-man-key-props =
    .label = Avaimen ominaisuudet
    .accesskey = v
openpgp-key-man-key-more =
    .label = Lisää
    .accesskey = L
openpgp-key-man-view-photo =
    .label = Kuvan tunniste
    .accesskey = K
openpgp-key-man-ctx-view-photo-label =
    .label = Näytä kuvan tunniste
openpgp-key-man-show-invalid-keys =
    .label = Näytä virheelliset avaimet
    .accesskey = N
openpgp-key-man-show-others-keys =
    .label = Näytä muiden ihmisten avaimet
    .accesskey = m
openpgp-key-man-user-id-label =
    .label = Nimi
openpgp-key-man-fingerprint-label =
    .label = Sormenjälki
openpgp-key-man-select-all =
    .label = Valitse kaikki avaimet
    .accesskey = k
openpgp-key-man-empty-tree-tooltip =
    .label = Kirjoita hakusanat yllä olevaan kenttään
openpgp-key-man-nothing-found-tooltip =
    .label = Mikään avain ei vastaa hakusanojasi
openpgp-key-man-please-wait-tooltip =
    .label = Odota, avaimia ladataan ...

openpgp-key-man-filter-label =
    .placeholder = Etsi avaimia

openpgp-key-man-select-all-key =
    .key = K
openpgp-key-man-key-details-key =
    .key = T

openpgp-key-details-title =
    .title = Avaimen ominaisuudet
openpgp-key-details-signatures-tab =
    .label = Varmenteet
openpgp-key-details-structure-tab =
    .label = Rakenne
openpgp-key-details-uid-certified-col =
    .label = Käyttäjätunnus / varmentanut
openpgp-key-details-user-id2-label = Oletettu avaimen omistaja
openpgp-key-details-id-label =
    .label = Tunniste
openpgp-key-details-key-type-label = Tyyppi
openpgp-key-details-key-part-label =
    .label = Avaimen osa
openpgp-key-details-algorithm-label =
    .label = Algoritmi
openpgp-key-details-size-label =
    .label = Koko
openpgp-key-details-created-label =
    .label = Luotu
openpgp-key-details-created-header = Luotu
openpgp-key-details-expiry-label =
    .label = Vanhentuminen
openpgp-key-details-expiry-header = Vanhentuminen
openpgp-key-details-usage-label =
    .label = Käyttö
openpgp-key-details-fingerprint-label = Sormenjälki
openpgp-key-details-sel-action =
    .label = Valitse toiminto…
    .accesskey = V
openpgp-key-details-also-known-label = Avaimen omistajan oletetut vaihtoehtoiset henkilöydet:
openpgp-card-details-close-window-label =
    .buttonlabelaccept = Sulje
openpgp-acceptance-label =
    .label = Hyväksyntäsi
openpgp-acceptance-rejected-label =
    .label = Ei, hylkää tämä avain.
openpgp-acceptance-undecided-label =
    .label = Ei vielä, ehkä myöhemmin.
openpgp-acceptance-unverified-label =
    .label = Kyllä, mutta en ole varmistanut, että tämä on oikea avain.
openpgp-acceptance-verified-label =
    .label = Kyllä, olen henkilökohtaisesti varmistanut, että tällä avaimella on oikea sormenjälki.
key-accept-personal =
    Tätä avainta varten sinulla on sekä julkinen että salainen osa. Voit käyttää sitä henkilökohtaisena avaimenasi.
    Jos olet saanut tämän avaimen joltakin toiselta, älä käytä sitä henkilökohtaisena avaimena.
key-personal-warning = Loitko tämän avaimen itse, ja viittaako näytetty avaimen omistajuus sinuun?
openpgp-personal-no-label =
    .label = Ei, älä käytä sitä henkilökohtaisena avaimenani.
openpgp-personal-yes-label =
    .label = Kyllä, käytä tätä avainta henkilökohtaisena avaimenani.

openpgp-copy-cmd-label =
    .label = Kopioi

## e2e encryption settings

#   $count (Number) - the number of configured keys associated with the current identity
#   $identity (String) - the email address of the currently selected identity
openpgp-description =
    { $count ->
        [0] Thunderbirdilla ei ole henkilökohtaista OpenPGP-avainta henkilölle <b>{ $identity }</b>
        [one] Thunderbird löysi { $count } henkilökohtaisen OpenPGP-avaimen henkilölle <b>{ $identity }</b>
       *[other] Thunderbird löysi { $count } henkilökohtaista OpenPGP-avainta henkilölle <b>{ $identity }</b>
    }

#   $count (Number) - the number of configured keys associated with the current identity
#   $key (String) - the currently selected OpenPGP key
openpgp-selection-status =
    { $count ->
        [0] Ota OpenPGP-protokolla käyttöön valitsemalla voimassa oleva avain.
       *[other] Nykyinen kokoonpanosi käyttää avaimen tunnistetta <b>{ $key }</b>
    }

#   $key (String) - the currently selected OpenPGP key
openpgp-selection-status-error = Nykyinen kokoonpano käyttää avainta <b>{ $key }</b>, joka on vanhentunut.

openpgp-add-key-button =
    .label = Lisää avain…
    .accesskey = L

e2e-learn-more = Lue lisää

openpgp-keygen-success = OpenPGP-avain luotu onnistuneesti!

openpgp-keygen-import-success = OpenPGP-avainten tuonti onnistui!

openpgp-keygen-external-success = Ulkoisen GnuPG-avaimen tunniste tallennettu!

## OpenPGP Key selection area

openpgp-radio-none =
    .label = Ei mitään

openpgp-radio-none-desc = Älä käytä OpenPGP:tä tähän henkilöyteen.

#   $key (String) - the expiration date of the OpenPGP key
openpgp-radio-key-expires = Vanhenee: { $date }

openpgp-key-expires-image =
    .tooltiptext = Avain vanhenee alle 6 kuukaudessa

#   $key (String) - the expiration date of the OpenPGP key
openpgp-radio-key-expired = Vanhentunut: { $date }

openpgp-key-expired-image =
    .tooltiptext = Avain on vanhentunut

openpgp-key-expand-section =
    .tooltiptext = Lisätietoja

openpgp-key-revoke-title = Kumoa avain

openpgp-key-edit-title = Vaihda OpenPGP-avain

openpgp-key-edit-date-title = Myöhäistä vanhenemispäivää

openpgp-manager-description = Tarkastele ja hallinnoi yhteyshenkilöidesi julkisia avaimia ja muita yllä mainitsemattomia avaimia OpenPGP-avainhallinnalla.

openpgp-manager-button =
    .label = OpenPGP-avainhallinta
    .accesskey = O

openpgp-key-remove-external =
    .label = Poista ulkoisen avaimen tunniste
    .accesskey = P

key-external-label = Ulkoinen GnuPG-avain

# Strings in keyDetailsDlg.xhtml
key-type-public = julkinen avain
key-type-primary = ensisijainen avain
key-type-subkey = aliavain
key-type-pair = avainpari (salainen avain ja julkinen avain)
key-expiry-never = ei koskaan
key-usage-encrypt = Salaa
key-usage-sign = Allekirjoita
key-usage-certify = Varmenna
key-usage-authentication = Todennus
key-does-not-expire = Avain ei vanhene
key-expired-date = Avain vanhentui { $keyExpiry }
key-expired-simple = Avain on vanhentunut
key-revoked-simple = Avain kumottiin
key-do-you-accept = Hyväksytkö tämän avaimen digitaalisten allekirjoitusten todentamiseksi ja viestien salaamiseksi?
key-accept-warning = Vältä vilpillisen avaimen hyväksymistä. Vahvista vastapuolen avaimen sormenjälki jollakin muulla viestintäkanavalla kuin sähköpostilla.

# Strings enigmailMsgComposeOverlay.js
cannot-use-own-key-because = Viestiä ei voida lähettää, koska henkilökohtaisessa avaimessasi on ongelma. { $problem }
cannot-encrypt-because-missing = Tätä viestiä ei voi lähettää päästä päähän -salauksella, koska seuraavien vastaanottajien avaimissa on ongelmia: { $problem }
window-locked = Kirjoitusikkuna on lukittu; lähetys peruutettu

# Strings in mimeDecrypt.jsm
mime-decrypt-encrypted-part-attachment-label = Salattu viestiosa
mime-decrypt-encrypted-part-concealed-data = Tämä on salattu viestiosa. Avaa se erillisessä ikkunassa napsauttamalla liitettä.

# Strings in keyserver.jsm
keyserver-error-aborted = Keskeytetty
keyserver-error-unknown = Tapahtui tuntematon virhe
keyserver-error-server-error = Avainpalvelin ilmoitti virheestä.
keyserver-error-import-error = Ladatun avaimen tuonti epäonnistui.
keyserver-error-unavailable = Avainpalvelin ei ole käytettävissä.
keyserver-error-security-error = Avainpalvelin ei tue salattua käyttöä.
keyserver-error-certificate-error = Avainpalvelimen varmenne ei ole kelvollinen.
keyserver-error-unsupported = Avainpalvelin ei ole tuettu.

# Strings in mimeWkdHandler.jsm
wkd-message-body-req =
    Sähköpostipalveluntarjoajasi käsitteli pyyntösi julkisen avaimesi lähettämiseksi OpenPGP-verkkoavainhakemistoon.
    Vahvista julkisen avaimesi julkaiseminen.
wkd-message-body-process =
    Tämä sähköpostiviesti liittyy julkisen avaimesi automaattiseen lähettämiseen OpenPGP-verkkoavainhakemistoon.
    Tässä vaiheessa sinulta ei edellytetä mitään toimia.

# Strings in persistentCrypto.jsm
converter-decrypt-body-failed =
    Ei pystytty purkamaan viestiä aiheella
    { $subject }.
    Haluatko yrittää uudelleen toisella tunnuslauseella, vai haluatko ohittaa viestin?

# Strings in gpg.jsm
unknown-signing-alg = Tuntematon allekirjoitusalgoritmi (tunniste: { $id })
unknown-hash-alg = Tuntematon salaustiiviste (tunniste: { $id })

# Strings in keyUsability.jsm
expiry-key-expires-soon =
    Avaimesi { $desc } vanhenemiseen on vähemmän kuin { $days } vuorokautta.
    Suosittelemme, että luot uuden avainparin ja määrität vastaavat tilit käyttämään sitä.
expiry-keys-expire-soon =
    Seuraavien avaimiesi vanhenemiseen on vähemmän kuin { $days } vuorokautta:{ $desc }.
    Suosittelemme, että luot uudet avaimet ja määrität vastaavat tilit käyttämään niitä.
expiry-key-missing-owner-trust =
    Salaiselta avaimeltasi { $desc } puuttuu luottamus.
    Suosittelemme, että vaihdat avaimen ominaisuuksissa ominaisuuden "Luotan varmenteisiin" arvoon  "ultimaattinen".
expiry-keys-missing-owner-trust =
    Seuraavilta salaisilta avaimiltasi puuttuu luottamus.
    { $desc }.
    Suosittelemme, että vaihdat avaimen ominaisuuksissa ominaisuuden "Luotan varmenteisiin" arvoon  "ultimaattinen".
expiry-open-key-manager = Avaa OpenPGP-avainhallinta
expiry-open-key-properties = Avaimen ominaisuudet

# Strings filters.jsm
filter-folder-required = Kohdekansio on valittava.
filter-decrypt-move-warn-experimental =
    Varoitus - suodatustoiminto "Pura salaus pysyvästi" saattaa johtaa tuhoutuneisiin viesteihin.
    Suositteleme vahvasti, että kokeilet ensin "Luo salauksesta purettu kopio"-suodatinta, testaat tuloksen huolellisesti, ja aloitat tämän suodattimen käytön vasta kun olet tyytyyväinen lopputulokseen.
filter-term-pgpencrypted-label = OpenPGP-salattu
filter-key-required = Vastaanottajan avain on valittava.
filter-key-not-found = Ei löytynyt salausavainta seuraaville '{ $desc }'.
filter-warn-key-not-secret =
    Varoitus - suodatintoiminto "Salaa avaimeen" korvaa vastaanottajat.
    Jos sinulla ei ole salaista avainta kohteisiin '{ $desc }', et pysty enää lukea sähköpostiviestejä.

# Strings filtersWrapper.jsm
filter-decrypt-move-label = Pura salaus pysyvästi (OpenPGP)
filter-decrypt-copy-label = Luo salauksesta purettu kopio (OpenPGP)
filter-encrypt-label = Salaa avaimeen (OpenPGP)

# Strings in enigmailKeyImportInfo.js
import-info-title =
    .title = Onnistui! Avaimet tuotu
import-info-bits = Bittiä
import-info-created = Luotu
import-info-fpr = Sormenjälki
import-info-details = Näytä yksityiskohdat ja hallitse avaimen hyväksyntää
import-info-no-keys = Avaimia ei ole tuotu.

# Strings in enigmailKeyManager.js
import-from-clip = Haluatko tuoda yhden tai useamman avaimen leikepöydältä?
import-from-url = Lataa julkinen avain tästä osoitteesta:
copy-to-clipbrd-failed = Yhtä tai useampaa valittua avainta ei voitu kopioida leikepöydälle.
copy-to-clipbrd-ok = Yksi tai useampi avain kopioitu leikepöydälle
delete-secret-key =
    VAROITUS: Olet aikeissa poistaa salaisen avaimen!
    
    Jos poistat salaisen avaimen, et voi enää purkaa minkään kyseiselle avaimelle salatun viestin salausta, etkä pysty kumoamaan sitä.
    
    Haluatko varmasti poistaa MOLEMMAT, salaisen avaimen ja julkisen avaimen
    '{ $userId }'?
delete-mix =
    VAROITUS: Olet aikeissa poistaa salaisia avaimia!
    Jos poistat salaisen avaimesi, et pysty enää avata niiden viestien salausta, jotka on salattu kyseisellä avaimella.
    Haluatko varmasti poistaa MOLEMMAT, sekä valitut salaiset että julkiset avaimet?
delete-pub-key =
    Haluatko poistaa julkisen avaimen
    '{ $userId }'?
delete-selected-pub-key = Haluatko poistaa julkiset avaimet?
refresh-all-question = Et valinnut yhtäkään avainta. Haluatko päivittää KAIKKI avaimet?
key-man-button-export-sec-key = Vie &salaiset avaimet
key-man-button-export-pub-key = Vie vain &julkiset avaimet
key-man-button-refresh-all = &Päivitä kaikki avaimet
key-man-loading-keys = Ladataan avaimia, odota hetki…
ascii-armor-file = ASCII-panssaroidut tiedostot (*.asc)
no-key-selected = Valitse vähintään yksi avain suorittaaksesi valitun toimenpiteen
export-to-file = Vie julkinen avain tiedostoon
export-keypair-to-file = Vie salainen ja julkinen avain tiedostoon
export-secret-key = Haluatko sisällyttää salaisen avaimen tallennettuun OpenPGP-avaintiedostoon?
save-keys-ok = Avaimet tallennettiin onnistuneesti
save-keys-failed = Avainten tallentaminen epäonnistui
default-pub-key-filename = Viedyt-julkiset-avaimet
default-pub-sec-key-filename = Salaisten-avainten-varmuuskopio
refresh-key-warn = Varoitus: riippuen avainten määrästä ja yhteyden nopeudesta, kaikkien avainten päivittäminen saattaa kestää!
preview-failed = Julkisen avaintiedoston lukeminen ei onnistu.
general-error = Virhe: { $reason }
dlg-button-delete = &Poista

## Account settings export output

openpgp-export-public-success = <b>Julkinen avain viety onnistuneesti!</b>
openpgp-export-public-fail = <b>Valitun julkisen avaimen vienti ei onnistunut!</b>

openpgp-export-secret-success = <b>Salainen avain viety onnistuneesti!</b>
openpgp-export-secret-fail = <b>Valitun salaisen avaimen vienti ei onnistunut!</b>

# Strings in keyObj.jsm
key-ring-pub-key-revoked = Avain { $userId } (avaimen tunniste { $keyId }) on kumottu.
key-ring-pub-key-expired = Avain { $userId } (avaimen tunniste { $keyId }) on vanhentunut.
key-ring-key-disabled = Avain { $userId } (avaimen tunniste { $keyId }) on poistettu käytöstä; sitä ei voi käyttää.
key-ring-key-invalid = Avain { $userId } (avaimen tunniste { $keyId }) ei ole kelvollinen. Harkitse sen kelvollista vahvistamista.
key-ring-key-not-trusted = Avain { $userId } (avaimen tunniste { $keyId }) ei ole riittävän luotettu. Aseta avaimesi luottamustasoksi "ultimaattinen" käyttääksesi sitä allekirjoitukseen.
key-ring-no-secret-key = Sinulla ei vaikuta olevan salaista avainta käyttäjälle { $userId } (avaimen tunniste { $keyId }) avainnipussasi; et voi käyttää avainta allekirjoitukseen.
key-ring-pub-key-not-for-signing = Avainta { $userId } (avaimen tunniste { $keyId }) ei voi käyttää allekirjoittamiseen.
key-ring-pub-key-not-for-encryption = Avainta { $userId } (avaimen tunniste { $keyId }) ei voi käyttää salaukseen.
key-ring-sign-sub-keys-revoked = Kaikki avaimen { $userId } (avaimen tunniste { $keyId }) allekirjoitukseen tarkoitetut aliavaimet on kumottu.
key-ring-sign-sub-keys-expired = Kaikki avaimen { $userId } (avaimen tunniste { $keyId }) allekirjoitukseen tarkoitetut aliavaimet ovat vanhentuneet.
key-ring-sign-sub-keys-unusable = Kaikki avaimen { $userId } (avaimen tunniste { $keyId }) allekirjoitukseen tarkoitetut aliavaimet on kumottu, vanhentuneet tai muuten käyttökelvottomia.
key-ring-enc-sub-keys-revoked = Kaikki avaimen { $userId } (avaimen tunniste { $keyId }) salaukseen tarkoitetut aliavaimet on kumottu.
key-ring-enc-sub-keys-expired = Kaikki avaimen { $userId } (avaimen tunniste { $keyId }) salaukseen tarkoitetut aliavaimet ovat vanhentuneet.
key-ring-enc-sub-keys-unusable = Kaikki avaimen { $userId } (avaimen tunniste { $keyId }) salaukseen tarkoitetut aliavaimet on kumottu, vanhentuneet tai muuten käyttökelvottomia.

# Strings in gnupg-keylist.jsm
keyring-photo = Kuva
user-att-photo = Käyttäjän ominaisuus (JPEG-kuva)

# Strings in key.jsm
already-revoked = Tämä avain on jo kumottu.

#   $identity (String) - the id and associated user identity of the key being revoked
revoke-key-question =
    Olet aikeissa kumota avaimen '{ $identity }'.
    Et voi enää allekirjoittaa tällä avaimella, ja kun jaettu muille, muut eivät enää pysty salata kyseisellä avaimella. Voit silti käyttää avainta vanhojen viestien salauksen purkamiseen.
    Haluatko jatkaa?

#   $keyId (String) - the id of the key being revoked
revoke-key-not-present =
    Sinulla ei ole avainta (0x{ $keyId }) mikä täsmäisi tätä kumoamisvarmennetta!
    Jos olet kadottanut avaimesi, sinun tulee tuoda (esim. avainpalvelimelta), ennen kuin tuot kumoamisvarmenteen!

#   $keyId (String) - the id of the key being revoked
revoke-key-already-revoked = Avain 0x{ $keyId } on jo kumottu.

key-man-button-revoke-key = &Kumoa avain

openpgp-key-revoke-success = Avain kumottu onnistuneesti.

after-revoke-info =
    Avain on kumottu.
    Jaa tämä julkinen avain uudelleen, lähettämällä se ihmisille sähköpostitse tai lähettämällä avainpalvelimille, jotta muut saavat tietää sinun kumonneen avaimesi.
    Kun muiden ihmisten käyttämät ohjelmat saavat tiedon kumoamisesta, ohjelmat lopettavat vanhan avaimesi käytön.
    Jos käytät uutta avainta samaan sähköpostiosoitteeseen, ja liität uuden julkisen avaimesi lähettämiisi sähköposteihin, niin tieto kumotusta vanhasta avaimestasi sisällytetään automaattisesti.

# Strings in keyRing.jsm & decryption.jsm
key-man-button-import = &Tuo

delete-key-title = Poista OpenPGP-avain

delete-external-key-title = Poista ulkoinen GnuPG-avain

delete-external-key-description = Haluatko poistaa tämän ulkoisen GnuPG-avaimen tunnisteen?

key-in-use-title = OpenPGP-avain on parhaillaan käytössä

delete-key-in-use-description = Ei voi jatkaa! Poistettavaksi valitsemasi avain on parhaillaan tämän identiteetin käytössä. Valitse eri avain, tai älä valitse mitään avainta, ja yritä uudelleen.

revoke-key-in-use-description = Ei voi jatkaa! Kumottavaksi valitsemasi avain on parhaillaan tämän identiteetin käytössä. Valitse eri avain, tai älä valitse mitään avainta, ja yritä uudelleen.

# Strings used in errorHandling.jsm
key-error-key-spec-not-found = Sähköpostiosoitetta '{ $keySpec }' ei voida täsmätä avainnipussasi olevaan avaimeen.
key-error-key-id-not-found = Määritettyä avaimen tunnistetta '{ $keySpec }' ei löydy avainnipustasi.
key-error-not-accepted-as-personal = Et ole vahvistanut, että avain tunnisteella '{ $keySpec }' on henkilökohtainen avaimesi.

# Strings used in enigmailKeyManager.js & windows.jsm
need-online = Valitsemasi toiminto ei ole käytettävissä yhteydettömässä tilassa. Yhdistä verkkoon ja yritä uudelleen.

# Strings used in keyRing.jsm & keyLookupHelper.jsm
no-key-found = Hakuehtoja vastaavia avaimia ei löytynyt.

# Strings used in keyRing.jsm & GnuPGCryptoAPI.jsm
fail-key-extract = Virhe - avaimen purkamiskomento epäonnistui

# Strings used in keyRing.jsm
fail-cancel = Virhe - Avaimen vastaanotto peruttu käyttäjän toimesta
not-first-block = Virhe - Ensimmäinen OpenPGP-lohko ei ole julkisen avaimen lohko
import-key-confirm = Haluatko tuoda yhden tai useamman viestiin upotetun julkisen avaimen?
fail-key-import = Virhe - avaimen tuominen epäonnistui
file-write-failed = Kirjoitus tiedostoon { $output } epäonnistui
no-pgp-block = Virhe - Kelvollista panssaroitua OpenPGP-datalohkoa ei löytynyt
confirm-permissive-import = Tuonti epäonnistui. Avain, jota yritit tuoda, saattaa olla rikkoutunut tai se se saattaa käyttää tuntemattomia ominaisuuksia. Haluatko yrittää tuoda kelvolliset osat avaimesta? Tämä saattaa johtaa epätäydellisten ja käyttökelvottomien avainten tuontiin.

# Strings used in trust.jsm
key-valid-unknown = tuntematon
key-valid-invalid = virheellinen
key-valid-disabled = pois käytöstä
key-valid-revoked = kumottu
key-valid-expired = vanhentunut
key-trust-untrusted = ei luotettu
key-trust-marginal = marginaalinen
key-trust-full = luotettu
key-trust-ultimate = ultimaattinen
key-trust-group = (ryhmä)

# Strings used in commonWorkflows.js
import-key-file = Tuo OpenPGP-avaintiedosto
import-rev-file = Tuo OpenPGP-kumoamistiedosto
gnupg-file = GnuPG-tiedostot
import-keys-failed = Avainten tuonti epäonnistui
passphrase-prompt = Kirjoita salalause joka avaa seuraavan avaimen: { $key }
file-to-big-to-import = Tämä tiedosto on liian suuri. Älä tuo liian suurta määrää avaimia kerralla.

# Strings used in enigmailKeygen.js
save-revoke-cert-as = Luo ja tallenna kumoamisvarmenne
revoke-cert-ok = Kumoamisvarmenne on luotu onnistuneesti. Voit käyttää sitä julkisen avaimesi mitätöimiseen, jos esimerkiksi kadotat salaisen avaimesi.
revoke-cert-failed = Kumoamisvarmennetta ei voitu luoda.
gen-going = Avaimen luominen on jo meneillään!
keygen-missing-user-name = Valitulle tilille/identiteetille ei ole määritetty nimeä. Anna arvo kenttään "Nimesi" tilin asetuksissa.
expiry-too-short = Avaimesi tulee olla kelvollinen vähintään yhden päivän ajan.
expiry-too-long = Et voi luoda avainta, joka vanhenee yli 100 vuoden päästä.
key-confirm = Haluatko luoda julkisen ja salaisen avaimen identiteetille '{ $id }'?
key-man-button-generate-key = &Luo avain
key-abort = Lopetetaanko avaimen luominen?
key-man-button-generate-key-abort = &Lopeta avaimen luominen
key-man-button-generate-key-continue = &Jatka avaimen luomista

# Strings used in enigmailMessengerOverlay.js
failed-decrypt = Virhe - salauksen purkaminen epäonnistui
fix-broken-exchange-msg-failed = Viestin korjaaminen ei onnistunut.
attachment-no-match-from-signature = Allekirjoitustiedostoa '{ $attachment }' ei voitu täsmätä liitteeseen
attachment-no-match-to-signature = Liitettä '{ $attachment }' ei voitu täsmätä allekirjoitustiedostoon
signature-verified-ok = Liitteen { $attachment } allekirjoitus vahvistettiin onnistuneesti
signature-verify-failed = Liitteen { $attachment } allekirjoitusta ei voitu vahvistaa
decrypt-ok-no-sig =
    Varoitus
    Viestin salauksen purkaminen onnistui, mutta allekirjoitusta ei voitu vahvistaa oikeaoppisesti
msg-ovl-button-cont-anyway = &Jatka silti
enig-content-note = *Tämän viestin liitteitä ei ole allekirjoitettu tai salattu*

# Strings used in enigmailMsgComposeOverlay.js
msg-compose-button-send = &Lähetä viesti
msg-compose-details-button-label = Lisätiedot…
msg-compose-details-button-access-key = L
send-aborted = Lähetys keskeytetty.
key-not-trusted = Ei riittävästi luottamusta avaimeen '{ $key }'
key-not-found = Avainta '{ $key }' ei löytynyt
key-revoked = Avain '{ $key }' kumottu
key-expired = Avain '{ $key }' vanhentui
msg-compose-internal-error = Tapahtui sisäinen virhe.
keys-to-export = Valitse sisällytettävät OpenPGP-avaimet
msg-compose-partially-encrypted-inlinePGP =
    Viesti johon vastaat sisälsi sekä salaamattomia että salattuja osia. Jos lähettäjä ei kyennyt purkamaan joitain viestin osia alunperin, saatat vuotaa arkaluonteista tietoa, jota lähettäjä ei aiemmin itse pystynyt purkamaan salauksesta.
    On suositeltavaa poistaa kaikki lainattu teksti vastauksestasi tälle lähettäjälle.
msg-compose-cannot-save-draft = Virhe luonnosta tallennettaessa
msg-compose-partially-encrypted-short = Varo vuotamasta arkaluonteisia tietoja - osittain salattu sähköposti.
quoted-printable-warn =
    Olet ottanut käyttöön 'quoted-printable'-enkoodauksen lähettäville viesteille. Tämä saattaa johtaa virheelliseen salauksen purkuun tai viestisi vahvistukseen.
    Haluatko poistaa käytöstä 'quoted-printable'-viestien lähettämisen nyt?
minimal-line-wrapping =
    Olet asettanut rivityksen { $width } merkkiin. Oikeaoppisen salauksen ja/tai allekirjoituksen vuoksi tämän arvon tulee olla vähintään 68.
    Haluatko muuttaa rivityksen arvon 68 merkkiin?
sending-hidden-rcpt = Piilokopioita (BCC) ei voi käyttää, kun on tarkoitus lähettää salattu viesti. Lähettääksesi tämän salatun viestin, poista piilokopion vastaanottajat tai siirrä ne kopiokenttään.
sending-news =
    Salattu lähetys keskeytetty.
    Tätä viestiä ei voi salata, koska vastaanottajissa on uutisryhmiä. Lähetä tämä viesti uudelleen ilman salausta.
send-to-news-warning =
    Varoitus: olet aikeissa lähettää salatun sähköpostin uutisryhmään.
    Tämä ei ole suositeltavaa, koska siinä on järkeä vain jos kaikilla ryhmän jäsenillä on mahdollisuus purkaa viestin salaus. Toisin sanoen viesti tulee olla salattu kaikkien ryhmän jäsenten avaimilla. Lähetä tämä viesti vain, jos tiedät tarkalleen mitä olet tekemässä.
    Haluatko jatkaa?
save-attachment-header = Tallenna salauksesta purettu liite
no-temp-dir =
    Kirjoituskelpoista väliaikaishakemistoa ei löytynyt
    Aseta TEMP-ympäristömuuttuja
possibly-pgp-mime = Mahdollisesti PGP/MIME-salattu tai allekirjoitettu viesti; käytä "Pura salaus/Vahvista'-toimintoa vahvistaaksesi
cannot-send-sig-because-no-own-key = Tätä viestiä ei voi digitaalisesti allekirjoittaa, koska et ole vielä määrittänyt päästä päähän -salausta avaimelle <{ $key }>
cannot-send-enc-because-no-own-key = Tätä viestiä ei voi lähettää salattuna, koska et ole vielä määrittänyt päästä päähän -salausta avaimelle <{ $key }>

# Strings used in decryption.jsm
do-import-multiple =
    Haluatko tuoda seuraavat avaimet?
    { $key }
do-import-one = Haluatko tuoda { $name } ({ $id })?
cant-import = Virhe tuotaessa julkista avainta
unverified-reply = Sisennettyä viestin osaa (vastaus) luultavasti muokattiin
key-in-message-body = Avain löydettiin viestin sisällöstä. Napsauta "Tuo avain" tuodaksesi avaimen
sig-mismatch = Virhe - Allekirjoituksen yhteensopimattomuus
invalid-email = Virhe - yksi tai useampi virheellinen sähköpostiosoite
attachment-pgp-key =
    Liite '{ $name }' vaikuttaa olevan OpenPGP-avaintiedosto.
    Napsauta "Tuo" tuodaksesi avaimen tai "Näytä" tarkastellaksesi tiedoston sisältöä selainikkunassa
dlg-button-view = &Näytä

# Strings used in enigmailMsgHdrViewOverlay.js
decrypted-msg-with-format-error = Salauksesta purettu viesti (palautettu rikkoutuneesta PGP-sähköpostimuodosta, jonka aiheutti mitä luultavimmin vanha Exchange-palvelin, joten lopputulos ei välttämättä ole täydellisesti luettavissa)

# Strings used in encryption.jsm
not-required = Virhe - salausta ei vaadita

# Strings used in windows.jsm
no-photo-available = Ei kuvaa saatavilla
error-photo-path-not-readable = Kuvan polku '{ $photo }' ei ole luettavissa
debug-log-title = OpenPGP-vianjäljitysloki

# Strings used in dialog.jsm
repeat-prefix = Tämä hälytys toistetaan { $count }
repeat-suffix-singular = kerran.
repeat-suffix-plural = kertaa.
no-repeat = Tätä hälytystä ei näytetä uudelleen.
dlg-keep-setting = Muista vastaukseni, älä kysy uudestaan
dlg-button-ok = &OK
dlg-button-close = &Sulje
dlg-button-cancel = &Peruuta
dlg-no-prompt = Älä näytä tätä ikkunaa uudestaan
enig-prompt = OpenPGP-kehote
enig-confirm = OpenPGP-vahvistus
enig-alert = OpenPGP-hälytys
enig-info = OpenPGP-tiedot

# Strings used in persistentCrypto.jsm
dlg-button-retry = &Yritä uudelleen
dlg-button-skip = &Ohita

# Strings used in enigmailCommon.js
enig-error = OpenPGP-virhe
enig-alert-title =
    .title = OpenPGP-hälytys
