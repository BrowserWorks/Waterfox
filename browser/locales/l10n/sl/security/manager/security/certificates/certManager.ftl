# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certmgr-title =
    .title = Upravitelj digitalnih potrdil
certmgr-tab-mine =
    .label = Vaša digitalna potrdila
certmgr-tab-remembered =
    .label = Odločitve overjanja
certmgr-tab-people =
    .label = Ljudje
certmgr-tab-servers =
    .label = Strežniki
certmgr-tab-ca =
    .label = Overitelji
certmgr-mine = Imate digitalna potrdila naslednjih organizacij, ki predstavljajo vas
certmgr-remembered = Ta digitalna potrdila se uporabljajo za identifikacijo na spletnih mestih
certmgr-people = Imate digitalna potrdila, ki predstavljajo naslednje ljudi
certmgr-servers = Imate digitalna potrdila, ki predstavljajo naslednje strežnike
certmgr-ca = Imate digitalna potrdila, ki predstavljajo naslednje overitelje
certmgr-detail-general-tab-title =
    .label = Splošno
    .accesskey = S
certmgr-detail-pretty-print-tab-title =
    .label = Podrobnosti
    .accesskey = D
certmgr-pending-label =
    .value = Poteka preverjanje digitalnih potrdil …
certmgr-subject-label = Izdano za
certmgr-issuer-label = Izdajatelj
certmgr-period-of-validity = Obdobje veljavnosti
certmgr-fingerprints = Prstni odtisi
certmgr-cert-detail =
    .title = Podrobnosti digitalnega potrdila
    .buttonlabelaccept = Zapri
    .buttonaccesskeyaccept = Z
certmgr-cert-detail-commonname = Splošno ime (CN)
certmgr-cert-detail-org = Organizacija (O)
certmgr-cert-detail-orgunit = Organizacijska enota (OU)
certmgr-cert-detail-serial-number = Serijska številka
certmgr-cert-detail-sha-256-fingerprint = Prstni odtis SHA-256
certmgr-cert-detail-sha-1-fingerprint = Prstni odtis SHA1
certmgr-edit-ca-cert =
    .title = Urejanje nastavitev zaupanja overiteljem
    .style = width: 48em;
certmgr-edit-cert-edit-trust = Spremeni nastavitve zaupanja:
certmgr-edit-cert-trust-ssl =
    .label = To digitalno potrdilo lahko predstavlja spletne strani.
certmgr-edit-cert-trust-email =
    .label = Ta digitalno potrdilo lahko predstavlja uporabnike e-pošte.
certmgr-delete-cert =
    .title = Izbriši digitalno potrdilo
    .style = width: 48em; height: 24em;
certmgr-cert-host =
    .label = Gostitelj
certmgr-cert-name =
    .label = Ime digitalnega potrdila
certmgr-cert-server =
    .label = Strežnik
certmgr-override-lifetime =
    .label = Življenjska doba
certmgr-token-name =
    .label = Varnostna naprava
certmgr-begins-on = Začne veljati
certmgr-begins-label =
    .label = Začne veljati
certmgr-expires-on = Poteče
certmgr-expires-label =
    .label = Poteče
certmgr-email =
    .label = E-poštni naslov
certmgr-serial =
    .label = Serijska številka
certmgr-view =
    .label = Ogled …
    .accesskey = O
certmgr-edit =
    .label = Uredi zaupanje …
    .accesskey = e
certmgr-export =
    .label = Izvozi …
    .accesskey = i
certmgr-delete =
    .label = Izbriši …
    .accesskey = Z
certmgr-delete-builtin =
    .label = Izbriši ali umakni zaupanje …
    .accesskey = Z
certmgr-backup =
    .label = Varnostna kopija …
    .accesskey = K
certmgr-backup-all =
    .label = Varnostna kopija vseh
    .accesskey = v
certmgr-restore =
    .label = Uvozi …
    .accesskey = u
certmgr-details =
    .value = Polja digitalnega potrdila
    .accesskey = O
certmgr-fields =
    .value = Vrednost polja
    .accesskey = R
certmgr-hierarchy =
    .value = Hierarhija digitalnih potrdil
    .accesskey = H
certmgr-add-exception =
    .label = Dodaj izjemo …
    .accesskey = i
exception-mgr =
    .title = Dodaj varnostno izjemo
exception-mgr-extra-button =
    .label = Potrdi varnostno izjemo
    .accesskey = z
exception-mgr-supplemental-warning = Uveljavljene banke, trgovine in druge javne strani vas ne bodo prosile za to.
exception-mgr-cert-location-url =
    .value = Lokacija:
exception-mgr-cert-location-download =
    .label = Dobi digitalno potrdilo
    .accesskey = G
exception-mgr-cert-status-view-cert =
    .label = Ogled …
    .accesskey = O
exception-mgr-permanent =
    .label = Trajno shrani izjemo
    .accesskey = T
pk11-bad-password = Vnešeno geslo je napačno.
pkcs12-decode-err = Datoteke ne morem dekodirati. Lahko, da ni v formatu PKCS #12, morda je bila poškodovana, ali pa vnešeno geslo ni bilo pravilno.
pkcs12-unknown-err-restore = Datoteke PKCS #12 ni mogoče obnovititi zaradi neznanih razlogov.
pkcs12-unknown-err-backup = Varnostne kopije PKCS #12 ni bilo mogoče narediti zaradi neznanih vzrokov.
pkcs12-unknown-err = Operacija PKCS #12 ni uspela iz neznanih razlogov.
pkcs12-info-no-smartcard-backup = Digitalnih potrdil ni mogoče shraniti kot varnostno kopijo iz strojnih varnostnih naprav, kot so 'pametne kartice' (smart cards).
pkcs12-dup-data = Digitalno potrdilo in zasebni ključ že obstajata na varnostni napravi.

## PKCS#12 file dialogs

choose-p12-backup-file-dialog = Ime datoteke za varnostno kopijo
file-browse-pkcs12-spec = Datoteke PKCS12
choose-p12-restore-file-dialog = Datoteka z digitalnim potrdilom

## Import certificate(s) file dialog

file-browse-certificate-spec = Datoteke z digitalnimi potrdili
import-ca-certs-prompt = Izberite datoteko, ki vsebuje digitalno potrdilo CA za uvoz
import-email-cert-prompt = Izberite datoteko, ki vsebuje e-poštno digitalno potrdilo za uvoz

## For editing certificates trust

# Variables:
#   $certName: the name of certificate
edit-trust-ca = Digitalno potrdilo "{ $certName }" predstavlja overitelja.

## For Deleting Certificates

delete-user-cert-title =
    .title = Brisanje vaših digitalnih potrdil
delete-user-cert-confirm = Ste prepričani, da želite izbrisati ta digitalna potrdila?
delete-user-cert-impact = Če zbrišete enega svojih lastnih digitalnih potrdil, se z njim ne boste mogli več identificirati.
delete-ssl-cert-title =
    .title = Izbriši izjeme digitalnih potrdil strežnika
delete-ssl-cert-confirm = Ali ste prepričani, da želite zbrisati te izjeme strežnika?
delete-ssl-cert-impact = Če izbrišete izjemo strežnika, se bo obnovil običajni postopek varnostnega preverjanja za ta strežnik, ki bo potreboval tudi veljavno digitalno potrdilo?
delete-ca-cert-title =
    .title = Izbriši ali umakni zaupanje digitalnim potrdilom overitelja
delete-ca-cert-confirm = Zahtevali ste izbris teh digitalnih potrdil overitelja. Zaupanje vgrajenim digitalnim potrdilom bo umaknjeno, kar ima enak učinek. Ste prepričani, da jih želite zbrisati ali umakniti zaupanje?
delete-ca-cert-impact = Če zbrišete ali umaknete zaupanje digitalnemu potrdilu tega overitelja, ta program ne bo več zaupal nobenemu digitalnemu potrdilu, ki ga je izdal ta overitelj.
delete-email-cert-title =
    .title = Izbris e-poštnih digitalnih potrdil
delete-email-cert-confirm = Ste prepričani, da želite izbrisati digitalna potrdila za e-pošto naslednjih ljudi?
delete-email-cert-impact = Če zbrišete e-poštno digitalno potrdilo osebe, ne boste več mogli pošiljati šifrirane elektronske pošte tej osebi.
# Used for semi-uniquely representing a cert.
#
# Variables:
#   $serialNumber : the serial number of the cert in AA:BB:CC hex format.
cert-with-serial =
    .value = Digitalno potrdilo s serijsko številko: { $serialNumber }

## Cert Viewer

# Title used for the Certificate Viewer.
#
# Variables:
#   $certificate : a string representative of the certificate being viewed.
cert-viewer-title =
    .title = Pregledovalnik digitalnih potrdil: “{ $certName }”
not-present =
    .value = <Ni del digitalnega potrdila>
# Cert verification
cert-verified = To digitalno potrdilo je bilo preverjeno za naslednje namene:
# Add usage
verify-ssl-client =
    .value = Klientovo digitalno potrdilo SSL
verify-ssl-server =
    .value = Strežniško digitalno potrdilo SSL
verify-ssl-ca =
    .value = Uradna oseba SSL za digitalna potrdila (Certificate Authority)
verify-email-signer =
    .value = Digitalno potrdilo e-poštnega podpisnika
verify-email-recip =
    .value = Digitalno potrdilo prejemnika e-pošte
# Cert verification
cert-not-verified-cert-revoked = Tega digitalnega potrdila ni bilo mogoče preveriti, ker je bil razveljavljen.
cert-not-verified-cert-expired = Tega digitalnega potrdila ni bilo mogoče preveriti, ker je pretekel.
cert-not-verified-cert-not-trusted = Tega digitalnega potrdila ni bilo mogoče preveriti, ker ni vreden zaupanja.
cert-not-verified-issuer-not-trusted = Tega digitalnega potrdila ni bilo mogoče preveriti, ker izdajatelj ni vreden zaupanja.
cert-not-verified-issuer-unknown = Tega digitalnega potrdila ni bilo mogoče preveriti, ker je izdajatelj neznan.
cert-not-verified-ca-invalid = Tega digitalnega potrdila ni bilo mogoče preveriti, ker digitalno potrdilo izdajatelja ni veljavno.
cert-not-verified_algorithm-disabled = Tega digitalnega potrdila ni bilo mogoče preveriti, ker je bilo podpisano z algoritmom, ki je bil iz varnostnih razlogov onemogočen..
cert-not-verified-unknown = Tega digitalnega potrdila ni bilo mogoče preveriti iz neznanih razlogov.
# Used to indicate that the user chose not to send a client authentication certificate to a server that requested one in a TLS handshake.
send-no-client-certificate = Ne pošiljaj klientovega digitalnega potrdila

## Add Security Exception dialog

add-exception-branded-warning = Prepisali boste način, kako { -brand-short-name } prepoznava to stran.
add-exception-invalid-header = Ta stran se poskuša predstaviti z neveljavnimi podatki.
add-exception-domain-mismatch-short = Napačna stran
add-exception-domain-mismatch-long = Potrdilo pripada drugi strani, kar lahko pomeni, da nekdo poskuša oponašati to stran.
add-exception-expired-short = Zastareli podatki
add-exception-expired-long = Potrdilo trenutno ni veljavno. Morda je bilo ukradeno ali izgubljeno, zato ga lahko kdo uporablja za oponašanje strani.
add-exception-unverified-or-bad-signature-short = Neznana identiteta
add-exception-unverified-or-bad-signature-long = Digitalno potrdilo ni vredno zaupanja, ker ga ni overila uradna oseba z uporabo varnostnega podpisa.
add-exception-valid-short = Veljavno digitalno potrdilo
add-exception-valid-long = Stran ponuja veljavno in overjeno predstavitev. Izjeme ni potrebno dodajati.
add-exception-checking-short = Preverjanje podatkov
add-exception-checking-long = Poskus prepoznavanja strani …
add-exception-no-cert-short = Podatki niso na voljo
add-exception-no-cert-long = Ni mogoče pridobiti stanja identifikacije te strani.

## Certificate export "Save as" and error dialogs

save-cert-as = Shrani digitalno potrdilo v datoteko
cert-format-base64 = Digitalno potrdilo X.509 (PEM)
cert-format-base64-chain = Digitalno potrdilo X.509 z verigo (PEM)
cert-format-der = Digitalno potrdilo X.509 (DER)
cert-format-pkcs7 = Digitalno potrdilo X.509 (PKCS#7)
cert-format-pkcs7-chain = Digitalno potrdilo X.509 z verigo (PKCS#7)
write-file-failure = Napaka datoteke
