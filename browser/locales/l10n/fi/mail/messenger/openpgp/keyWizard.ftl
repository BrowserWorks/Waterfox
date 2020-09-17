# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

#   $identity (String) - the email address of the currently selected identity
key-wizard-dialog-window =
    .title = Lisää henkilökohtainen OpenPGP-avain osoitteelle { $identity }

key-wizard-button =
    .buttonlabelaccept = Jatka
    .buttonlabelhelp = Takaisin

key-wizard-warning = <b>Jos sinulla on olemassa oleva avain</b> tälle sähköpostiosoitteelle, suosittelemme tuomaan avaimen. Muussa tapauksessa et pysty avaamaan aiemmin vastaanottamiasi salattuja viestejä, etkä pysty lukemaan saapuvia viestejä niiltä henkilöiltä, jotka edelleen käyttävät olemassa olevaa avaintasi.

key-wizard-learn-more = Lue lisää

radio-create-key =
    .label = Luo uusi OpenPGP-avain
    .accesskey = u

radio-import-key =
    .label = Tuo olemassa oleva OpenPGP-avain
    .accesskey = o

radio-gnupg-key =
    .label = Käytä ulkoista avainta GnuPG:n avulla (esimerkiksi älykortilta)
    .accesskey = K

## Generate key section

openpgp-generate-key-title = Luo OpenPGP-avain

openpgp-generate-key-info = <b>Avaimen luominen saattaa kestää useita minuutteja.</b> Älä sulje sovellusta, kun avaimen luominen on meneillään. Selaaminen tai levytoimintoja aiheuttavat toiminnot avaimen luonnin aikana täydentävät satunnaisuutta ja nopeuttavat avaimen luontia. Sinulle ilmoitetaan, kun avaimen luonti valmistuu.

openpgp-keygen-expiry-title = Avaimen vanheneminen

openpgp-keygen-expiry-description = Määritä uudelle avaimellesi vanhenemisaika. Voit halutessasi myöhemmin pidentää avaimen voimassaoloaikaa.

radio-keygen-expiry =
    .label = Avain vanhenee
    .accesskey = e

radio-keygen-no-expiry =
    .label = Avain ei vanhene
    .accesskey = h

openpgp-keygen-days-label =
    .label = päivää
openpgp-keygen-months-label =
    .label = kuukautta
openpgp-keygen-years-label =
    .label = vuotta

openpgp-keygen-advanced-title = Lisäasetukset

openpgp-keygen-advanced-description = Hallitse OpenPGP-avaimesi lisäasetuksia.

openpgp-keygen-keytype =
    .value = Avaimen tyyppi:
    .accesskey = t

openpgp-keygen-keysize =
    .value = Avaimen koko:
    .accesskey = a

openpgp-keygen-type-rsa =
    .label = RSA

openpgp-keygen-type-ecc =
    .label = ECC (elliptinen käyrä)

openpgp-keygen-button = Luo avain

openpgp-keygen-progress-title = Luodaan uutta OpenPGP-avaintasi…

openpgp-keygen-import-progress-title = Tuodaan OpenPGP-avaintasi…

openpgp-import-success = OpenPGP-avaimet tuotiin onnistuneesti!

openpgp-import-success-title = Viimeistele tuonti

openpgp-import-success-description = Käyttääksesi tuotua OpenPGP-avainta sähköpostin salaukseen, sulje tämä ikkuna ja siirry tiliasetuksiin valitaksesi avaimen.

openpgp-keygen-confirm =
    .label = Vahvista

openpgp-keygen-dismiss =
    .label = Peruuta

openpgp-keygen-cancel =
    .label = Peruuta toimenpide…

openpgp-keygen-import-complete =
    .label = Sulje
    .accesskey = S

openpgp-keygen-missing-username = Nykyiselle tilille ei ole määritetty nimeä. Anna arvo kenttään "Nimesi" tilin asetuksissa.
openpgp-keygen-long-expiry = Et voi luoda avainta, joka vanhenee yli 100 vuoden päästä.
openpgp-keygen-short-expiry = Avaimesi tulee oltava kelvollinen vähintään yhden päivän ajan.

openpgp-keygen-ongoing = Avaimen luominen on jo meneillään!

openpgp-keygen-error-core = OpenPGP Core Service -ydinpalvelujen alustaminen ei onnistunut

openpgp-keygen-error-failed = OpenPGP-avaimen luonti epäonnistui odottamatta

#   $identity (String) - the newly generate OpenPGP Key
openpgp-keygen-error-revocation = OpenPGP-avain luotiin onnistuneesti, mutta avaimelle { $key } ei saatu kumoamismahdollisuutta

openpgp-keygen-abort-title = Perutaanko avaimen luonti?
openpgp-keygen-abort = OpenPGP-avaimen luonti on meneillään. Haluatko perua avaimen luonnin?

#   $identity (String) - the name and email address of the currently selected identity
openpgp-key-confirm = Haluatko luoda julkisen ja yksityisen avaimen identiteetille { $identity }?

## Import Key section

openpgp-import-key-title = Tuo olemassa oleva henkilökohtainen OpenPGP-avain

openpgp-import-key-legend = Valitse aiemmin varmuuskopioitu tiedosto.

openpgp-import-key-description = Voit tuoda henkilökohtaisia avaimia, jotka on luotu jollain muulla OpenPGP-ohjelmistolla.

openpgp-import-key-info = Muut ohjelmistot saattavat viitata henkilökohtaiseen avaimeen termeillä kuten oma avain, salainen avain, yksityinen avain tai avainpari.

#   $count (Number) - the number of keys found in the selected files
openpgp-import-key-list-amount =
    { $count ->
        [one] Thunderbird löysi yhden avaimen, joka voidaan tuoda.
       *[other] Thunderbird löysi { $count } avainta, jotka voidaan tuoda.
    }

openpgp-import-key-list-description = Vahvista mitä avaimia voidaan käsitellä henkilökohtaisina avaiminasi. Vain avaimia, jotka olet luonut itse ja edustavat identiteettiäsi, tulisi käyttää henkilökohtaisina avaimia. Voit muuttaa tätä valintaa myöhemmin Avaimen ominaisuudet -ikkunassa.

openpgp-import-key-list-caption = Avaimet, jotka on merkitty käsiteltäväksi henkilökohtaisina avaimia, listataan Päästä päähän -salauksen osiossa. Muut avaimet ovat saatavilla avainhallinnan kautta.

openpgp-passphrase-prompt-title = Salalause vaaditaan

#   $identity (String) - the id of the key being imported
openpgp-passphrase-prompt = Kirjoita salalause avataksesi seuraavan avaimen: { $key }

openpgp-import-key-button =
    .label = Valitse tuotava tiedosto…
    .accesskey = V

import-key-file = Tuo OpenPGP-avaintiedosto

import-key-personal-checkbox =
    .label = Käytä tätä avainta henkilökohtaisena avaimenani

gnupg-file = GnuPG-tiedostot

import-error-file-size = <b>Virhe!</b> Yli 5 megatavun tiedostot eivät ole tuettuja.

#   $error (String) - the reported error from the failed key import method
import-error-failed = <b>Virhe!</b> Tiedoston tuonti epäonnistui. { $error }

#   $error (String) - the reported error from the failed key import method
openpgp-import-keys-failed = <b>Virhe!</b> Avainten tuonti epäonnistui. { $error }

openpgp-import-identity-label = Identiteetti

openpgp-import-fingerprint-label = Sormenjälki

openpgp-import-created-label = Luotu

openpgp-import-bits-label = Bittiä

openpgp-import-key-props =
    .label = Avaimen ominaisuudet
    .accesskey = m

## External Key section

openpgp-external-key-title = Ulkoinen GnuPG-avain

openpgp-external-key-description = Määritä ulkoinen GnuPG-avain kiroittamalla avaimen tunnisteen (Key ID)

openpgp-external-key-info = Lisäksi sinun tulee käyttää avainhallintaa tuodaksesi ja hyväksyäksesi vastaavan julkisen avaimen.

openpgp-external-key-warning = <b>Voit määrittää vain yhden ulkoisen GnuPG-avaimen.</b> Aiempi tietue korvataan.

openpgp-save-external-button = Tallenna avaimen tunniste

openpgp-external-key-label = Salaisen avaimen tunniste:

openpgp-external-key-input =
    .placeholder = 123456789341298340
