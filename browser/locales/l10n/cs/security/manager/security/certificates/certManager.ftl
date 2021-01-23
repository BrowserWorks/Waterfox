# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certmgr-title =
    .title = Správce certifikátů
certmgr-tab-mine =
    .label = Osobní
certmgr-tab-remembered =
    .label = Rozhodnutí o ověřování
certmgr-tab-people =
    .label = Lidé
certmgr-tab-servers =
    .label = Servery
certmgr-tab-ca =
    .label = Autority
certmgr-mine = Pro vaši osobní identifikaci jsou dostupné tyto certifikáty
certmgr-remembered = Tyto certifikáty slouží k vaší identifikaci na webových stránkách
certmgr-people = Pro identifikaci ostatních lidí jsou dostupné tyto certifikáty
certmgr-servers = Pro identifikaci serverů jsou dostupné tyto certifikáty
certmgr-ca = Pro identifikaci certifikačních autorit jsou dostupné tyto certifikáty
certmgr-detail-general-tab-title =
    .label = Obecné
    .accesskey = O
certmgr-detail-pretty-print-tab-title =
    .label = Podrobnosti
    .accesskey = d
certmgr-pending-label =
    .value = Probíhá ověřování certifikátu…
certmgr-subject-label = Vydáno pro
certmgr-issuer-label = Vydal
certmgr-period-of-validity = Doba platnosti
certmgr-fingerprints = Otisky
certmgr-cert-detail =
    .title = Podrobnosti certifikátu
    .buttonlabelaccept = Zavřít
    .buttonaccesskeyaccept = Z
certmgr-cert-detail-commonname = Obecné jméno (CN)
certmgr-cert-detail-org = Organizace (O)
certmgr-cert-detail-orgunit = Jednotka organizace (OU)
certmgr-cert-detail-serial-number = Sériové číslo
certmgr-cert-detail-sha-256-fingerprint = Otisk SHA-256
certmgr-cert-detail-sha-1-fingerprint = Otisk SHA1
certmgr-edit-ca-cert =
    .title = Upravit nastavení důvěryhodnosti CA
    .style = width: 48em;
certmgr-edit-cert-edit-trust = Upravit nastavení důvěryhodnosti:
certmgr-edit-cert-trust-ssl =
    .label = Tento certifikát může identifikovat server.
certmgr-edit-cert-trust-email =
    .label = Tento certifikát může identifikovat uživatele e-mailu.
certmgr-delete-cert =
    .title = Smazat certifikát
    .style = width: 48em; height: 24em;
certmgr-cert-host =
    .label = Server
certmgr-cert-name =
    .label = Jméno certifikátu
certmgr-cert-server =
    .label = Server
certmgr-override-lifetime =
    .label = Životnost
certmgr-token-name =
    .label = Bezpečnostní zařízení
certmgr-begins-on = Vydáno dne
certmgr-begins-label =
    .label = Vydáno dne
certmgr-expires-on = Platný do
certmgr-expires-label =
    .label = Platný do
certmgr-email =
    .label = E-mailová adresa
certmgr-serial =
    .label = Sériové číslo
certmgr-view =
    .label = Zobrazit…
    .accesskey = b
certmgr-edit =
    .label = Upravit důvěru…
    .accesskey = a
certmgr-export =
    .label = Exportovat…
    .accesskey = x
certmgr-delete =
    .label = Smazat…
    .accesskey = S
certmgr-delete-builtin =
    .label = Smazat nebo nedůvěřovat…
    .accesskey = d
certmgr-backup =
    .label = Zálohovat…
    .accesskey = l
certmgr-backup-all =
    .label = Zálohovat vše…
    .accesskey = o
certmgr-restore =
    .label = Importovat…
    .accesskey = m
certmgr-details =
    .value = Položky certifikátu
    .accesskey = c
certmgr-fields =
    .value = Hodnota
    .accesskey = n
certmgr-hierarchy =
    .value = Hierarchie certifikátů
    .accesskey = H
certmgr-add-exception =
    .label = Přidat výjimku…
    .accesskey = P
exception-mgr =
    .title = Přidání bezpečnostní výjimky
exception-mgr-extra-button =
    .label = Schválit bezpečnostní výjimku
    .accesskey = S
exception-mgr-supplemental-warning = Legitimní banky, obchody a ostatní veřejné servery vás o toto žádat nebudou.
exception-mgr-cert-location-url =
    .value = Adresa:
exception-mgr-cert-location-download =
    .label = Získat certifikát
    .accesskey = c
exception-mgr-cert-status-view-cert =
    .label = Zobrazit…
    .accesskey = Z
exception-mgr-permanent =
    .label = Uložit tuto výjimku trvale
    .accesskey = U
pk11-bad-password = Zadané heslo není správné.
pkcs12-decode-err = Soubor nemohl být dekódován. Buď není ve formátu PCKS #12, nebo je porušen nebo zadané heslo není správné.
pkcs12-unknown-err-restore = Soubor PKCS #12 nemohl být obnoven z neznámých příčin.
pkcs12-unknown-err-backup = Soubor PKCS #12 nemohl být zálohován z neznámých důvodů.
pkcs12-unknown-err = Operace PKCS #12 z neznámých důvodů selhala.
pkcs12-info-no-smartcard-backup = Není možné zálohovat certifikáty z hardwarových bezpečnostních zařízení, jako např. čipové karty.
pkcs12-dup-data = Certifikát a soukromý klíč na bezpečnostním zařízení už existují.

## PKCS#12 file dialogs

choose-p12-backup-file-dialog = Název souboru pro zálohu
file-browse-pkcs12-spec = Soubory PKCS12
choose-p12-restore-file-dialog = Soubor s certifikátem pro import

## Import certificate(s) file dialog

file-browse-certificate-spec = Soubory s certifikáty
import-ca-certs-prompt = Vyberte soubor obsahující certifikát(y) CA pro import
import-email-cert-prompt = Vyberte soubor obsahující poštovní certifikát pro import

## For editing certificates trust

# Variables:
#   $certName: the name of certificate
edit-trust-ca = Certifikát „{ $certName }“ představuje Certifikační autoritu.

## For Deleting Certificates

delete-user-cert-title =
    .title = Smazání osobních certifikátů
delete-user-cert-confirm = Opravdu chcete smazat tyto certifikáty?
delete-user-cert-impact = Pokud smažete jeden ze svých vlastních certifikátů, nebudete moci dále prokazovat svoji identitu.
delete-ssl-cert-title =
    .title = Smazání výjimek pro certifikáty serverů
delete-ssl-cert-confirm = Opravdu chcete smazat výjimky pro tyto servery?
delete-ssl-cert-impact = Pokud odstraníte výjimku, obnovíte pro daný server obvyklé bezpečnostní kontroly a vyžadování platného certifikátu.
delete-ca-cert-title =
    .title = Smazání nebo nedůvěra certifikátů CA
delete-ca-cert-confirm = Požádali jste o smazání certifikátů CA. V případě vestavěných certifikátů jim bude odebrána důvěra, což má stejný efekt jako jejich smazání. Opravdu je chcete smazat nebo jim přestat důvěřovat?
delete-ca-cert-impact = Pokud smažete nebo přestanete důvěřovat certifikátům certifikační autority (CA), aplikace už nebude dále důvěřovat certifikátům vystaveným touto autoritou.
delete-email-cert-title =
    .title = Smazání certifikátů ostatních lidí
delete-email-cert-confirm = Opravdu chcete smazat poštovní certifikáty těchto lidí?
delete-email-cert-impact = Pokud smažete poštovní certifikát nějaké osoby, nebudete jí moci poslat zašifrovanou zprávu.
# Used for semi-uniquely representing a cert.
#
# Variables:
#   $serialNumber : the serial number of the cert in AA:BB:CC hex format.
cert-with-serial =
    .value = Certifikát se sériovým číslem: { $serialNumber }

## Cert Viewer

# Title used for the Certificate Viewer.
#
# Variables:
#   $certificate : a string representative of the certificate being viewed.
cert-viewer-title =
    .title = Prohlížeč certifikátů: „{ $certName }“
not-present =
    .value = <není součástí certifikátu>
# Cert verification
cert-verified = Tento certifikát byl ověřen pro následující použití:
# Add usage
verify-ssl-client =
    .value = Certifikát SSL klienta
verify-ssl-server =
    .value = Certifikát SSL serveru
verify-ssl-ca =
    .value = Certifikační autorita SSL
verify-email-signer =
    .value = Certifikát pro podepsání e-mailu
verify-email-recip =
    .value = Certifikát příjemce e-mailu
# Cert verification
cert-not-verified-cert-revoked = Certifikát nemohl být ověřen, protože byl zneplatněn.
cert-not-verified-cert-expired = Certifikát nemohl být ověřen, protože jeho platnost už vypršela.
cert-not-verified-cert-not-trusted = Certifikát nemohl být ověřen, protože není důvěryhodný.
cert-not-verified-issuer-not-trusted = Certifikát nemohl být ověřen, protože vydavatel není důvěryhodný.
cert-not-verified-issuer-unknown = Certifikát nemohl být ověřen, protože jeho vydavatel není znám.
cert-not-verified-ca-invalid = Certifikát nemohl být ověřen, protože certifikát CA je neplatný.
cert-not-verified_algorithm-disabled = Certifikát nemohl být ověřen, protože byl podepsán algoritmem, který je z bezpečnostních důvodů zakázán.
cert-not-verified-unknown = Certifikát nemohl být z neznámého důvodu ověřen.
# Used to indicate that the user chose not to send a client authentication certificate to a server that requested one in a TLS handshake.
send-no-client-certificate = Neposílat klientský certifikát

## Add Security Exception dialog

add-exception-branded-warning = Chystáte se změnit způsob, jakým { -brand-short-name } identifikuje tento server.
add-exception-invalid-header = Tento server se prokazuje neplatnými informacemi.
add-exception-domain-mismatch-short = Chybný server
add-exception-domain-mismatch-long = Certifikát patří jinému serveru, což může znamenat, že se někdo za tento server snaží vydávat.
add-exception-expired-short = Zastaralé informace
add-exception-expired-long = Certifikát už není platný. Mohl být odcizen nebo ztracen, a mohl být použit někým, kdo se snaží za tento server vydávat.
add-exception-unverified-or-bad-signature-short = Neznámá identita
add-exception-unverified-or-bad-signature-long = Certifikát není důvěryhodný, protože nebylo ověřeno, že byl vydán důvěryhodnou autoritou za použití bezpečného podpisu.
add-exception-valid-short = Platný certifikát
add-exception-valid-long = Tento server poskytuje platnou a ověřenou identifikaci. Není důvod, proč tomuto serveru dávat výjimku.
add-exception-checking-short = Kontrola informací
add-exception-checking-long = Probíhá pokus o identifikaci serveru…
add-exception-no-cert-short = Informace nejsou dostupné
add-exception-no-cert-long = Získání stavu identifikace pro tento server se nezdařilo.

## Certificate export "Save as" and error dialogs

save-cert-as = Uložit certifikát do souboru
cert-format-base64 = Certifikát typu X.509 (PEM)
cert-format-base64-chain = Certifikát typu X.509 s řetězem (PEM)
cert-format-der = Certifikát typu X.509  (DER)
cert-format-pkcs7 = Certifikát typu X.509 (PKCS#7)
cert-format-pkcs7-chain = Certifikát typu X.509 s řetězem (PKCS#7)
write-file-failure = Chyba souboru
