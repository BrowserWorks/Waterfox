# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certmgr-title =
    .title = Upravljač certifikata
certmgr-tab-mine =
    .label = Tvoji certifikati
certmgr-tab-people =
    .label = Osobe
certmgr-tab-servers =
    .label = Poslužitelji
certmgr-tab-ca =
    .label = Certifikacijska tijela
certmgr-mine = Imaš certifikate sljedećih organizacija koje te identificiraju
certmgr-people = Imaš spremljene certifikate koji identificiraju sljedeće osobe
certmgr-servers = Imaš spremljene certifikate koji identificiraju sljedeće poslužitelje
certmgr-ca = Imaš spremljene certifikate koji identificiraju ova certifikacijska tijela
certmgr-detail-general-tab-title =
    .label = Opće
    .accesskey = O
certmgr-detail-pretty-print-tab-title =
    .label = Detalji
    .accesskey = D
certmgr-pending-label =
    .value = Trenutno potvrđujem certifikat…
certmgr-subject-label = Izdano
certmgr-issuer-label = Izdao
certmgr-period-of-validity = Razdoblje valjanosti
certmgr-fingerprints = Otisci
certmgr-cert-detail =
    .title = Detalji certifikata
    .buttonlabelaccept = Zatvori
    .buttonaccesskeyaccept = Z
certmgr-cert-detail-commonname = Ime (CN)
certmgr-cert-detail-org = Organizacija (O)
certmgr-cert-detail-orgunit = Organizacijska jedinica (OU)
certmgr-cert-detail-serial-number = Serijski broj
certmgr-cert-detail-sha-256-fingerprint = SHA-256 otisak
certmgr-cert-detail-sha-1-fingerprint = SHA1 otisak
certmgr-edit-ca-cert =
    .title = Uredi postavke povjerenja CA-ovih certifikata
    .style = width: 48em;
certmgr-edit-cert-edit-trust = Uredi postavke povjerenja:
certmgr-edit-cert-trust-ssl =
    .label = Ovaj certifikat može identificirati web stranice.
certmgr-edit-cert-trust-email =
    .label = Ovaj certifikat može identificirati korisnike e-pošte.
certmgr-delete-cert =
    .title = Izbriši certifikat
    .style = width: 48em; height: 24em;
certmgr-cert-name =
    .label = Naziv certifikata
certmgr-cert-server =
    .label = Poslužitelj
certmgr-override-lifetime =
    .label = Vijek trajanja
certmgr-token-name =
    .label = Sigurnosni uređaj
certmgr-begins-on = Počinje na
certmgr-begins-label =
    .label = Počinje na
certmgr-expires-on = Isteći će
certmgr-expires-label =
    .label = Isteći će
certmgr-email =
    .label = Adresa e-pošte
certmgr-serial =
    .label = Serijski broj
certmgr-view =
    .label = Pogled…
    .accesskey = P
certmgr-edit =
    .label = Uredi povjerenje…
    .accesskey = U
certmgr-export =
    .label = Izvoz…
    .accesskey = z
certmgr-delete =
    .label = Izbriši …
    .accesskey = b
certmgr-delete-builtin =
    .label = Izbriši ili ne vjeruj …
    .accesskey = I
certmgr-backup =
    .label = Izradi sigurnosnu kopiju …
    .accesskey = s
certmgr-backup-all =
    .label = Izradi sigurnosnu kopiju za sve …
    .accesskey = k
certmgr-restore =
    .label = Uvezi…
    .accesskey = v
certmgr-details =
    .value = Polja certifikata
    .accesskey = P
certmgr-fields =
    .value = Vrijednost polja
    .accesskey = V
certmgr-hierarchy =
    .value = Hijerarhija certifikata
    .accesskey = H
certmgr-add-exception =
    .label = Dodaj iznimku…
    .accesskey = D
exception-mgr =
    .title = Dodaj sigurnosnu iznimku
exception-mgr-extra-button =
    .label = Potvrdi sigurnosnu iznimku
    .accesskey = r
exception-mgr-supplemental-warning = Legitimne banke, trgovine i ostale javne stranice te neće tražiti da ovo učiniš.
exception-mgr-cert-location-url =
    .value = Lokacija:
exception-mgr-cert-location-download =
    .label = Preuzmi certifikat
    .accesskey = c
exception-mgr-cert-status-view-cert =
    .label = Pogled…
    .accesskey = P
exception-mgr-permanent =
    .label = Trajno spremi ovu iznimku
    .accesskey = i
pk11-bad-password = Lozinka koju ste upisali je bila netočna.
pkcs12-decode-err = Dekodiranje datoteke nije uspjelo. Ili datoteka nije u PKCS #12 formatu ili je oštećena ili je lozinka koju ste unijeli bila kriva.
pkcs12-unknown-err-restore = Vraćanje PKCS #12 datoteke nije uspjelo zbog nepoznatih razloga.
pkcs12-unknown-err-backup = Stvaranje sigurnosne kopije PKCS #12 datoteke nije uspjelo zbog nepoznatih razloga.
pkcs12-unknown-err = PKCS #12 operacija nije uspjela zbog nepoznatih razloga.
pkcs12-info-no-smartcard-backup = Nije moguće napraviti sigurnosnu kopiju certifikata iz hardverskog sigurnosnog uređaja poput smart kartice.
pkcs12-dup-data = Certifikat i sigurnosni ključ već postoje na sigurnosnom uređaju.

## PKCS#12 file dialogs

choose-p12-backup-file-dialog = Naziv datoteke za izradu sigurnosne kopije
file-browse-pkcs12-spec = PKCS12 Datoteke
choose-p12-restore-file-dialog = Datoteka certifikata za uvoz

## Import certificate(s) file dialog

file-browse-certificate-spec = Datoteke certifikata
import-ca-certs-prompt = Za uvoz odaberi datoteku koja sadrži CA certifikat
import-email-cert-prompt = Za uvoz odaberi datoteku koja sadrži nečiji certifikat e-pošte

## For editing certificates trust

# Variables:
#   $certName: the name of certificate
edit-trust-ca = Certifikat „{ $certName }” predstavlja certifikacijsko tijelo.

## For Deleting Certificates

delete-user-cert-title =
    .title = Izbriši svoje certifikate
delete-user-cert-confirm = Stvarno želiš izbrisati ove certifikate?
delete-user-cert-impact = Ako izbrišeš jedan od vlastitih certifikata, više ga nećeš moći koristiti za identifikaciju.
delete-ssl-cert-title =
    .title = Izbriši iznimku certifikata poslužitelja
delete-ssl-cert-confirm = Zaista želiš ukloniti ove iznimke poslužitelja?
delete-ssl-cert-impact = Ako izbrišeš iznimku poslužitelja, obnavljaš uobičajene sigurnosne provjere za te poslužitelje i uvjetuješ upotrebu ispravnih certifikata.
delete-ca-cert-title =
    .title = Brisanje ili poništavanje povjerenja CA certifikata
delete-ca-cert-confirm = Zatražio/la si brisanje ovih CA certifikata. Za ugrađene certifikate uklonit će se sva povjerenja, što ima isti efekt. Zaista želiš izbrisati certifikate ili poništiti povjerenje?
delete-ca-cert-impact = Ako izbrišeš ili poništiš povjerenje za certifikat certifikacijskog tijela, ovaj program više neće vjerovati certifikatima koje izdaje to certifikacijsko tijelo.
delete-email-cert-title =
    .title = Izbriši certifikate e-pošte
delete-email-cert-confirm = Stvarno želiš izbrisati certifikate e-pošte ovih ljudi?
delete-email-cert-impact = Ako izbrišete certifikat e-pošte određene osobe, više nećeš moći toj osobi slati šifrirane e-poruke.
# Used for semi-uniquely representing a cert.
#
# Variables:
#   $serialNumber : the serial number of the cert in AA:BB:CC hex format.
cert-with-serial =
    .value = Certifikat sa serijskim brojem: { $serialNumber }

## Cert Viewer

# Title used for the Certificate Viewer.
#
# Variables:
#   $certificate : a string representative of the certificate being viewed.
cert-viewer-title =
    .title = Preglednik certifikata: “{ $certName }”
not-present =
    .value = <Nije dio certifikata>
# Cert verification
cert-verified = Ovaj certifikat je ovjeren za sljedeće namjene:
# Add usage
verify-ssl-client =
    .value = Certifikat SSL klijenta
verify-ssl-server =
    .value = Certifikat SSL poslužitelja
verify-ssl-ca =
    .value = Certifikacijsko tijelo za SSL
verify-email-signer =
    .value = Certifikat potpisnika e-pošte
verify-email-recip =
    .value = Certifikat primatelja e-pošte
# Cert verification
cert-not-verified-cert-revoked = Ovjera ovog certifikata nije moguća jer je poništen.
cert-not-verified-cert-expired = Ovjera ovog certifikata nije moguća jer je istekao.
cert-not-verified-cert-not-trusted = Ovjera ovog certifikata nije moguća jer nije pouzdan.
cert-not-verified-issuer-not-trusted = Ovjera ovog certifikata nije moguća jer izdavač nije pouzdan.
cert-not-verified-issuer-unknown = Ovjera ovog certifikata nije moguća jer je izdavač nepoznat.
cert-not-verified-ca-invalid = Ovjera ovog certifikata nije moguća jer CA certifikat nije važeći.
cert-not-verified_algorithm-disabled = Ovjera ovog certifikata nije moguća jer je potpisan koristeći algoritam potpisa koji je onemogućen iz sigurnosnih razloga.
cert-not-verified-unknown = Ovjera ovog certifikata nije moguća zbog nepoznatih razloga.

## Add Security Exception dialog

add-exception-branded-warning = Promijeniti ćete na način na koji { -brand-short-name } identificira ovu stranicu.
add-exception-invalid-header = Ova se stranica pokušava identificirati s neispravnim informacijama.
add-exception-domain-mismatch-short = Pogrešna stranica
add-exception-domain-mismatch-long = Certifikat pripada drugoj stranici, što može značiti da netko pokušava krivotvoriti ovu stranicu.
add-exception-expired-short = Zastarjela informacija
add-exception-expired-long = Certifikat trenutno nije ispravan. Možda je ukraden ili izgubljen, i može biti upotrebljen za krivotvorenje ove stranice.
add-exception-unverified-or-bad-signature-short = Nepoznat identitet
add-exception-unverified-or-bad-signature-long = Certifikatu se ne vjeruje jer nije potvrđen kao certifikat, kojeg je izdalo priznato certifikacijsko tijelo sa sigurnim potpisom.
add-exception-valid-short = Ispravan certifikat
add-exception-valid-long = Ova stranica pruža ispravnu, potvrđenu identifikaciju. Nema potrebe za dodavanjem iznimke.
add-exception-checking-short = Provjera informacija
add-exception-checking-long = Pokušaj identificiranja stranice…
add-exception-no-cert-short = Nema dostupnih informacija
add-exception-no-cert-long = Nije moguće dobiti identifikacijski status za ovu stranicu.

## Certificate export "Save as" and error dialogs

save-cert-as = Spremiti certifikat u datoteku
cert-format-base64 = X.509 certifikat (PEM)
cert-format-base64-chain = X.509 lančani certifikat (PEM)
cert-format-der = X.509 certifikat (DER)
cert-format-pkcs7 = X.509 certifikat (PKCS#7)
cert-format-pkcs7-chain = X.509 lančani certifikat (PKCS#7)
write-file-failure = Greška datoteke
