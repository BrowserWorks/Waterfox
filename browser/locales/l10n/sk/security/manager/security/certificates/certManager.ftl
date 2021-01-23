# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certmgr-title =
    .title = Správca certifikátov

certmgr-tab-mine =
    .label = Vaše certifikáty

certmgr-tab-people =
    .label = Ľudia

certmgr-tab-servers =
    .label = Servery

certmgr-tab-ca =
    .label = Autority

certmgr-mine = Máte certifikáty od týchto organizácií, ktoré vás identifikujú
certmgr-people = Máte uložené certifikáty, ktoré identifikujú týchto ľudí
certmgr-servers = Máte uložené certifikáty, ktoré identifikujú tieto servery
certmgr-ca = Máte uložené certifikáty, ktoré identifikujú tieto certifikačné autority

certmgr-detail-general-tab-title =
    .label = Všeobecné
    .accesskey = V

certmgr-detail-pretty-print-tab-title =
    .label = Podrobnosti
    .accesskey = d

certmgr-pending-label =
    .value = Práve sa overuje certifikát…

certmgr-subject-label = Vydaný pre

certmgr-issuer-label = Vydal

certmgr-period-of-validity = Doba platnosti

certmgr-fingerprints = Odtlačky prstov

certmgr-cert-detail =
    .title = Detail certifikátu
    .buttonlabelaccept = Zavrieť
    .buttonaccesskeyaccept = Z

certmgr-cert-detail-commonname = Bežný názov (CN)

certmgr-cert-detail-org = Organizácia (O)

certmgr-cert-detail-orgunit = Organizačná jednotka (OU)

certmgr-cert-detail-serial-number = Sériové číslo

certmgr-cert-detail-sha-256-fingerprint = Odtlačok prsta SHA-256

certmgr-cert-detail-sha-1-fingerprint = Odtlačok prsta SHA1

certmgr-edit-ca-cert =
    .title = Úprava nastavenia dôvery pre certifikát od certifikačnej autority
    .style = width: 48em;

certmgr-edit-cert-edit-trust = Upraviť nastavenie dôvery:

certmgr-edit-cert-trust-ssl =
    .label = Tento certifikát môže identifikovať internetové stránky.

certmgr-edit-cert-trust-email =
    .label = Tento certifikát môže identifikovať poštových používateľov.

certmgr-delete-cert =
    .title = Odstránenie certifikátu
    .style = width: 48em; height: 24em;

certmgr-cert-name =
    .label = Názov certifikátu

certmgr-cert-server =
    .label = Server

certmgr-override-lifetime =
    .label = Životnosť

certmgr-token-name =
    .label = Bezpečnostné zariadenie

certmgr-begins-on = Platnosť od

certmgr-begins-label =
    .label = Platnosť od

certmgr-expires-on = Platnosť vyprší

certmgr-expires-label =
    .label = Platnosť vyprší

certmgr-email =
    .label = E-mailová adresa

certmgr-serial =
    .label = Sériové číslo

certmgr-view =
    .label = Zobraziť…
    .accesskey = o

certmgr-edit =
    .label = Upraviť dôveryhodnosť…
    .accesskey = U

certmgr-export =
    .label = Exportovať…
    .accesskey = x

certmgr-delete =
    .label = Odstrániť…
    .accesskey = d

certmgr-delete-builtin =
    .label = Odstrániť alebo prestať dôverovať…
    .accesskey = d

certmgr-backup =
    .label = Zálohovať…
    .accesskey = a

certmgr-backup-all =
    .label = Zálohovať všetky…
    .accesskey = l

certmgr-restore =
    .label = Importovať…
    .accesskey = m

certmgr-details =
    .value = Polia certifikátu
    .accesskey = e

certmgr-fields =
    .value = Hodnota poľa
    .accesskey = H

certmgr-hierarchy =
    .value = Hierarchia certifikátu
    .accesskey = c

certmgr-add-exception =
    .label = Pridať výnimku…
    .accesskey = n

exception-mgr =
    .title = Pridanie bezpečnostnej výnimky

exception-mgr-extra-button =
    .label = Potvrdiť bezpečnostnú výnimku
    .accesskey = P

exception-mgr-supplemental-warning = Skutočné banky, obchody a iné verejné stránky toto nebudú od vás vyžadovať.

exception-mgr-cert-location-url =
    .value = Adresa:

exception-mgr-cert-location-download =
    .label = Získať certifikát
    .accesskey = c

exception-mgr-cert-status-view-cert =
    .label = Zobraziť…
    .accesskey = Z

exception-mgr-permanent =
    .label = Túto výnimku uložiť natrvalo
    .accesskey = n

pk11-bad-password = Zadané heslo je nesprávne.
pkcs12-decode-err = Nepodarilo sa dekódovať súbor. Buď nie je vo formáte PKCS #12, alebo je súbor poškodený, alebo ste zadali nesprávne heslo.
pkcs12-unknown-err-restore = Nepodarilo sa obnoviť PKCS #12 súbor z neznámeho dôvodu.
pkcs12-unknown-err-backup = Nepodarilo sa vytvoriť záložný súbor PKCS #12 z neznámych dôvodov.
pkcs12-unknown-err = Operácia PKCS #12 zlyhala z neznámych príčin.
pkcs12-info-no-smartcard-backup = Nie je možné zálohovať certifikáty s hardvérového bezpečnostného zariadenia, ako napríklad Smart Card.
pkcs12-dup-data = Tento certifikát a privátny kľúč už na tomto bezpečnostnom zariadení existuje.

## PKCS#12 file dialogs

choose-p12-backup-file-dialog = Názov súboru, ktorý sa má zálohovať
file-browse-pkcs12-spec = Súbory PKCS12
choose-p12-restore-file-dialog = Súbor s certifikátom, ktorý sa má importovať

## Import certificate(s) file dialog

file-browse-certificate-spec = Súbory certifikátov
import-ca-certs-prompt = Vyberte súbor s certifikátom autority, ktorý sa má naimportovať
import-email-cert-prompt = Vyberte súbor s e-mailovým certifikátom, ktorý sa má naimportovať

## For editing certificates trust

# Variables:
#   $certName: the name of certificate
edit-trust-ca = Certifikát "{ $certName }" reprezentuje certifikačnú autoritu.

## For Deleting Certificates

delete-user-cert-title =
    .title = Odstránenie vašich certifikátov
delete-user-cert-confirm = Naozaj chcete odstrániť tieto certifikáty?
delete-user-cert-impact = Ak odstránite jeden zo svojich vlastných certifikátov, nebudete ho môcť ďalej používať na svoju identifikáciu.


delete-ssl-cert-title =
    .title = Odstránenie výnimky certifikátu webového servera
delete-ssl-cert-confirm = Naozaj chcete odstrániť tieto výnimky pre certifikáty servera?
delete-ssl-cert-impact = Ak odstránite výnimku certifikátu servera, obnovíte zvyčajné kontroly zabezpečenia tohto servera a vyžadovanie platného certifikátu.

delete-ca-cert-title =
    .title = Odstránenie alebo zrušenie dôveryhodnosti certifikátov certifikačnej autority
delete-ca-cert-confirm = Požiadali ste o odstránenie certifikátov certifikačnej autority. Pre zabudované certifikáty bude zrušená dôveryhodnosť, čo má rovnaký efekt ako ich odstránenie. Naozaj chcete certifikáty odstrániť resp. zrušiť od dôveryhodnosť?
delete-ca-cert-impact = Ak odstránite alebo prestanete dôverovať certifikátu certifikačnej autority (CA), táto aplikácia nebude dôverovať certifikátom, ktoré táto CA vydala.


delete-email-cert-title =
    .title = Odstránenie e-mailových certifikátov
delete-email-cert-confirm = Naozaj chcete odstrániť e-mailové certifikáty týchto ľudí?
delete-email-cert-impact = Ak odstránite e-mailový certifikát osoby, nebudete môcť tomuto adresátovi odoslať zašifrovanú e-mailovú správu.

# Used for semi-uniquely representing a cert.
#
# Variables:
#   $serialNumber : the serial number of the cert in AA:BB:CC hex format.
cert-with-serial =
    .value = Certifikát so sériovým číslom: { $serialNumber }

## Cert Viewer

# Title used for the Certificate Viewer.
#
# Variables:
#   $certificate : a string representative of the certificate being viewed.
cert-viewer-title =
    .title = Zobrazenie certifikátu: „{ $certName }“

not-present =
    .value = <nie je súčasťou certifikátu>

# Cert verification
cert-verified = Tento certifikát bol overený pre nasledujúce použitie:

# Add usage
verify-ssl-client =
    .value = Certifikát klienta SSL

verify-ssl-server =
    .value = Certifikát servera SSL

verify-ssl-ca =
    .value = Certifikačná autorita SSL

verify-email-signer =
    .value = Certifikát podpisovateľa správy

verify-email-recip =
    .value = Certifikát adresáta e-mailu

# Cert verification
cert-not-verified-cert-revoked = Tento certifikát sa nedá overiť, pretože je zrušený.
cert-not-verified-cert-expired = Nepodarilo sa overiť tento certifikát, pretože vypršal.
cert-not-verified-cert-not-trusted = Nepodarilo sa overiť tento certifikát, pretože nie je dôveryhodný.
cert-not-verified-issuer-not-trusted = Nepodarilo sa overiť tento certifikát, pretože jeho vydavateľ nie je dôveryhodný.
cert-not-verified-issuer-unknown = Nepodarilo sa overiť tento certifikát, pretože jeho vydavateľ je neznámy.
cert-not-verified-ca-invalid = Nepodarilo sa overiť tento certifikát, pretože certifikát certifikačnej autority je neplatný.
cert-not-verified_algorithm-disabled = Nepodarilo sa overiť tento certifikát, pretože bol podpísaný pomocou algoritmu, ktorý nie je bezpečný.
cert-not-verified-unknown = Z neznámych dôvodov sa nepodarilo overiť tento certifikát.

## Add Security Exception dialog

add-exception-branded-warning = Chystáte sa potlačiť spôsob, akým { -brand-short-name } identifikuje túto stránku.
add-exception-invalid-header = Táto stránka sa pokúša identifikovať neplatnými údajmi.
add-exception-domain-mismatch-short = Nesprávna stránka
add-exception-domain-mismatch-long = Certifikát patrí inej stránke, čo môže naznačovať, že niekto sa snaží vydávať sa za túto stránku.
add-exception-expired-short = Informácie sú zastarané
add-exception-expired-long = Certifikát servera už nie je platný. Mohol byť ukradnutý alebo stratený, a mohol byť použitý niekým, kto sa snaží vydávať sa za túto stránku.
add-exception-unverified-or-bad-signature-short = Neznáma identita
add-exception-unverified-or-bad-signature-long = Certifikát servera nie je dôveryhodný, pretože nebol vydaný dôveryhodnou autoritou použitím bezpečného algoritmu.
add-exception-valid-short = Platný certifikát
add-exception-valid-long = Táto stránka poskytuje platnú, overenú identifikáciu. Nie je potrebné pridať výnimku.
add-exception-checking-short = Kontrola informácií
add-exception-checking-long = Pokus o identifikovanie tejto stránky…
add-exception-no-cert-short = Informácie nie sú dostupné
add-exception-no-cert-long = Nie je možné získať stav identifikácie pre túto stránku.

## Certificate export "Save as" and error dialogs

save-cert-as = Uložiť certifikát ako súbor
cert-format-base64 = Certifikát X.509 (PEM)
cert-format-base64-chain = Certifikát X.509 s reťazcom (PEM)
cert-format-der = Certifikát X.509 (DER)
cert-format-pkcs7 = Certifikát X.509 (PKCS#7)
cert-format-pkcs7-chain = Certifikát X.509 s reťazcom (PKCS#7)
write-file-failure = Chyba súboru
