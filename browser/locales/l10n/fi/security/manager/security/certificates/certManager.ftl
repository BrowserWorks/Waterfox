# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certmgr-title =
    .title = Varmenteiden hallinta

certmgr-tab-mine =
    .label = Omat varmenteet

certmgr-tab-remembered =
    .label = Todennuspäätökset

certmgr-tab-people =
    .label = Henkilöt

certmgr-tab-servers =
    .label = Palvelimet

certmgr-tab-ca =
    .label = Varmentajat

certmgr-mine = Seuraavilta organisaatioilta on sinut todentava varmenne
certmgr-remembered = Näitä varmenteita käytetään sinun todentamiseen sivustoille
certmgr-people = Seuraavat yksilöt todentavia varmenteita on tiedossa
certmgr-servers = Seuraavat palvelimet todentavia varmenteita on tiedossa
certmgr-ca = Seuraavat varmentajat todentavia varmenteita on tiedossa

certmgr-detail-general-tab-title =
    .label = Yleistiedot
    .accesskey = Y

certmgr-detail-pretty-print-tab-title =
    .label = Yksityiskohdat
    .accesskey = t

certmgr-pending-label =
    .value = Todennetaan varmennetta…

certmgr-subject-label = Myönnetty

certmgr-issuer-label = Myöntäjä

certmgr-period-of-validity = Kelpoisuusaika

certmgr-fingerprints = Sormenjäljet

certmgr-cert-detail =
    .title = Varmenteen yksityiskohdat
    .buttonlabelaccept = Sulje
    .buttonaccesskeyaccept = S

certmgr-cert-detail-commonname = Yleinen nimi (CN)

certmgr-cert-detail-org = Organisaatio (O)

certmgr-cert-detail-orgunit = Organisaation yksikkö (OU)

certmgr-cert-detail-serial-number = Sarjanumero

certmgr-cert-detail-sha-256-fingerprint = SHA-256-sormenjälki

certmgr-cert-detail-sha-1-fingerprint = SHA1-sormenjälki

certmgr-edit-ca-cert =
    .title = Muokkaa varmentajan varmenteen luotettavuusasetuksia
    .style = width: 48em;

certmgr-edit-cert-edit-trust = Muokkaa luotettavuusasetuksia:

certmgr-edit-cert-trust-ssl =
    .label = Tämä varmenne voi todentaa verkkosivustoja.

certmgr-edit-cert-trust-email =
    .label = Tämä varmenne voi todentaa sähköpostittajia.

certmgr-delete-cert =
    .title = Poista varmenne
    .style = width: 48em; height: 24em;

certmgr-cert-host =
    .label = Palvelin

certmgr-cert-name =
    .label = Varmenteen nimi

certmgr-cert-server =
    .label = Palvelin

certmgr-override-lifetime =
    .label = Elinikä

certmgr-token-name =
    .label = Turvallisuuslaite

certmgr-begins-on = Astuu voimaan

certmgr-begins-label =
    .label = Astuu voimaan

certmgr-expires-on = Vanhenee

certmgr-expires-label =
    .label = Vanhenee

certmgr-email =
    .label = Sähköpostiosoite

certmgr-serial =
    .label = Sarjanumero

certmgr-view =
    .label = Näytä…
    .accesskey = N

certmgr-edit =
    .label = Muokkaa luottamusta…
    .accesskey = M

certmgr-export =
    .label = Vie…
    .accesskey = V

certmgr-delete =
    .label = Poista…
    .accesskey = P

certmgr-delete-builtin =
    .label = Poista tai älä luota…
    .accesskey = o

certmgr-backup =
    .label = Varmuuskopioi…
    .accesskey = V

certmgr-backup-all =
    .label = Varmuuskopioi kaikki…
    .accesskey = a

certmgr-restore =
    .label = Tuo…
    .accesskey = T

certmgr-details =
    .value = Varmenteen kentät
    .accesskey = m

certmgr-fields =
    .value = Kentän arvo
    .accesskey = K

certmgr-hierarchy =
    .value = Varmennehierarkia
    .accesskey = n

certmgr-add-exception =
    .label = Lisää poikkeus…
    .accesskey = L

exception-mgr =
    .title = Lisää turvallisuuspoikkeus

exception-mgr-extra-button =
    .label = Vahvista turvallisuuspoikkeus
    .accesskey = V

exception-mgr-supplemental-warning = Luotettavat pankit, kaupat ja muut julkiset sivustot eivät pyydä sinua tekemään tätä.

exception-mgr-cert-location-url =
    .value = Osoite:

exception-mgr-cert-location-download =
    .label = Lataa varmenne
    .accesskey = L

exception-mgr-cert-status-view-cert =
    .label = Näytä…
    .accesskey = N

exception-mgr-permanent =
    .label = Tallenna poikkeus pysyvästi
    .accesskey = T

pk11-bad-password = Kirjoitettu salasana oli väärä.
pkcs12-decode-err = Tiedoston purku epäonnistui. Joko se ei ole PKCS #12 -muodossa, se on viallinen, tai kirjoittamasi salasana oli väärä.
pkcs12-unknown-err-restore = PKCS #12 -tiedoston palauttaminen epäonnistui tuntemattomasta syystä.
pkcs12-unknown-err-backup = PKCS #12 -tiedoston varmuuskopiointi epäonnistui tuntemattomista syistä.
pkcs12-unknown-err = PKCS #12 -toiminto epäonnistui tuntemattomista syistä.
pkcs12-info-no-smartcard-backup = Varmenteiden varmuuskopioiminen turvalaitteelta, kuten älykortilta, ei ole mahdollista.
pkcs12-dup-data = Varmenne ja salainen avain ovat jo olemassa tällä turvalaitteella.

## PKCS#12 file dialogs

choose-p12-backup-file-dialog = Varmuuskopioitavan tiedoston nimi
file-browse-pkcs12-spec = PKCS12-tiedostot
choose-p12-restore-file-dialog = Tuotava varmennetiedosto

## Import certificate(s) file dialog

file-browse-certificate-spec = Varmennetiedostot
import-ca-certs-prompt = Valitse tiedosto, jossa on tuotavat varmentajien varmenteet
import-email-cert-prompt = Valitse tiedosto, jossa on tuotava sähköpostivarmenne

## For editing certificates trust

# Variables:
#   $certName: the name of certificate
edit-trust-ca = Varmenne { $certName } todentaa varmentajan.

## For Deleting Certificates

delete-user-cert-title =
    .title = Omien varmenteiden poisto
delete-user-cert-confirm = Poistetaanko nämä varmenteet?
delete-user-cert-impact = Poistettua varmennetta ei voi enää käyttää itsensä todentamiseen.


delete-ssl-cert-title =
    .title = Poista palvelinvarmenteen poikkeus
delete-ssl-cert-confirm = Poistetaanko nämä palvelinkohtaiset poikkeukset?
delete-ssl-cert-impact = Palvelinkohtaisen poikkeuksen poistamisen jälkeen normaalit turvallisuustarkastukset ovat taas voimassa ja palvelimelta vaaditaan tällöin kelvollinen varmenne.

delete-ca-cert-title =
    .title = Poista varmentajan varmenne tai luottamus siihen
delete-ca-cert-confirm = Olet poistamassa näiden varmentajien varmenteita. Sisäänrakennettujen varmenteiden tapauksessa luottamus varmenteeseen poistetaan, joka on käytännössä sama kuin varmenteen poistaminen. Poistetaanko varmenteet tai luottamus niihin?
delete-ca-cert-impact = Jos poistat varmentajan varmenteen tai luottamuksen siihen, tämä ohjelma ei enää luota yhteenkään tuon varmentajan myöntämään varmenteeseen.


delete-email-cert-title =
    .title = Poista sähköpostivarmenteet
delete-email-cert-confirm = Poistetaanko nämä sähköpostivarmenteet?
delete-email-cert-impact = Jos sähköpostivarmenne poistetaan, varmenteen kohteelle ei voi enää lähettää salattuja viestejä.

# Used for semi-uniquely representing a cert.
#
# Variables:
#   $serialNumber : the serial number of the cert in AA:BB:CC hex format.
cert-with-serial =
    .value = Varmenne sarjanumerolla: { $serialNumber }

## Cert Viewer

# Title used for the Certificate Viewer.
#
# Variables:
#   $certificate : a string representative of the certificate being viewed.
cert-viewer-title =
    .title = Varmenteen tarkastelu: ”{ $certName }”

not-present =
    .value = <Ei osa varmennetta>

# Cert verification
cert-verified = Tämä varmenne on seuraaviin tarkoituksiin:

# Add usage
verify-ssl-client =
    .value = SSL-asiakasohjelman varmenne

verify-ssl-server =
    .value = SSL-palvelimen varmenne

verify-ssl-ca =
    .value = SSL-varmentaja

verify-email-signer =
    .value = Sähköpostin allekirjoittajan varmenne

verify-email-recip =
    .value = Sähköpostin vastaanottajan varmenne

# Cert verification
cert-not-verified-cert-revoked = Varmennetta ei voitu todentaa, koska se on sulkulistalla.
cert-not-verified-cert-expired = Varmennetta ei voitu todentaa, koska se on vanhentunut.
cert-not-verified-cert-not-trusted = Varmennetta ei voitu todentaa, koska siihen ei luoteta.
cert-not-verified-issuer-not-trusted = Varmennetta ei voitu todentaa, koska sen myöntäjään ei luoteta.
cert-not-verified-issuer-unknown = Varmennetta ei voitu todentaa, koska sen myöntäjä on tuntematon.
cert-not-verified-ca-invalid = Varmennetta ei voitu todentaa, koska sen varmentajan varmenne on epäkelpo.
cert-not-verified_algorithm-disabled = Varmennetta ei voitu todentaa, koska se on allekirjoitettu allekirjoitusalgoritmilla, joka ei ole turvallinen.
cert-not-verified-unknown = Varmennetta ei voitu todentaa tuntemattomasta syystä.

# Used to indicate that the user chose not to send a client authentication certificate to a server that requested one in a TLS handshake.
send-no-client-certificate = Älä lähetä asiakasvarmennetta

## Add Security Exception dialog

add-exception-branded-warning = Olet muuttamassa { -brand-short-name }in tapaa todentaa tämä sivusto.
add-exception-invalid-header = Sivusto yrittää todentaa itseään virheellisillä tiedoilla.
add-exception-domain-mismatch-short = Väärä sivusto
add-exception-domain-mismatch-long = Varmenne kuuluu toiselle sivustolle. Tämä voi olla tarkoittaa, että joku yrittää tekeytyä sivustoksi.
add-exception-expired-short = Vanhentunutta tietoa
add-exception-expired-long = Varmenne ei ole tällä hetkellä voimassa. Se on voinut hävitä tai se on voitu varastaa, ja joku voi käyttää sitä tekeytyäkseen täksi sivustoksi.
add-exception-unverified-or-bad-signature-short = Tuntematon identiteetti
add-exception-unverified-or-bad-signature-long = Varmenteeseen ei luoteta, koska yksikään luotettu varmentaja ei todenna sitä suojatulla allekirjoituksella.
add-exception-valid-short = Voimassa oleva varmenne
add-exception-valid-long = Sivustoon on liitetty todennettu, voimassa oleva identiteetti. Ei ole syytä asettaa poikkeusta.
add-exception-checking-short = Tarkistetaan tietoja
add-exception-checking-long = Yritetään todentaa sivustoa…
add-exception-no-cert-short = Tietoja ei ole saatavilla
add-exception-no-cert-long = Tunnistustietoja ei ollut saatavilla sivustolle.

## Certificate export "Save as" and error dialogs

save-cert-as = Tallenna varmenne tiedostoon
cert-format-base64 = X.509-varmenne (PEM)
cert-format-base64-chain = X.509-varmenne ketjulla (PEM)
cert-format-der = X.509-varmenne (DER)
cert-format-pkcs7 = X.509-varmenne (PKCS#7)
cert-format-pkcs7-chain = X.509-varmenne ketjulla (PKCS#7)
write-file-failure = Tiedostovirhe
