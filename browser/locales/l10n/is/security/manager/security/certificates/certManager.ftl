# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certmgr-title =
    .title = Umsýsla skilríkja

certmgr-tab-mine =
    .label = Skilríkin þín

certmgr-tab-people =
    .label = Fólk

certmgr-tab-servers =
    .label = Netþjónar

certmgr-tab-ca =
    .label = Vottunarstöðvar

certmgr-mine = Skilríki frá stofnunum sem auðkenna þig
certmgr-people = Skilríki sem auðkenna þetta fólk
certmgr-servers = Skilríki sem auðkenna þessi vefsvæði
certmgr-ca = Skilríki sem auðkenna þessar vottunarstöðvar

certmgr-detail-general-tab-title =
    .label = Almennt
    .accesskey = A

certmgr-detail-pretty-print-tab-title =
    .label = Nánar
    .accesskey = N

certmgr-pending-label =
    .value = Er að sannvotta skilríki…

certmgr-subject-label = Gefið út fyrir

certmgr-issuer-label = Gefið út af

certmgr-period-of-validity = Tímabil í gildi

certmgr-fingerprints = Fingraför

certmgr-cert-detail =
    .title = Nánar um skilríki
    .buttonlabelaccept = Loka
    .buttonaccesskeyaccept = L

certmgr-cert-detail-commonname = Almennt nafn (CN)

certmgr-cert-detail-org = Stofnun (O)

certmgr-cert-detail-orgunit = Stofnunareining (OU)

certmgr-cert-detail-serial-number = Raðnúmer

certmgr-cert-detail-sha-256-fingerprint = SHA-256 fingrafar

certmgr-cert-detail-sha-1-fingerprint = SHA1 fingrafar

certmgr-edit-ca-cert =
    .title = Breyta stillingum CA skilríkja trausts
    .style = width: 48em;

certmgr-edit-cert-edit-trust = Breyta traust stillingum:

certmgr-edit-cert-trust-ssl =
    .label = Þetta skilríki getur auðkennt vefsvæði.

certmgr-edit-cert-trust-email =
    .label = Þetta skilríki getur auðkennt póst notendur.

certmgr-delete-cert =
    .title = Eyða skilríki
    .style = width: 48em; height: 24em;

certmgr-cert-name =
    .label = Nafn skilríkis

certmgr-cert-server =
    .label = Netþjónn

certmgr-override-lifetime =
    .label = Æviskeið

certmgr-token-name =
    .label = Öryggistæki

certmgr-begins-on = Byrjar þann

certmgr-begins-label =
    .label = Byrjar þann

certmgr-expires-on = Rennur út

certmgr-expires-label =
    .label = Rennur út

certmgr-email =
    .label = Netfang

certmgr-serial =
    .label = Raðnúmer

certmgr-view =
    .label = Skoða…
    .accesskey = S

certmgr-edit =
    .label = Breyta trausti…
    .accesskey = e

certmgr-export =
    .label = Flytja út…
    .accesskey = F

certmgr-delete =
    .label = Eyða…
    .accesskey = E

certmgr-delete-builtin =
    .label = Eyða eða vantreysta…
    .accesskey = E

certmgr-backup =
    .label = Afrita…
    .accesskey = A

certmgr-backup-all =
    .label = Afrita allt…
    .accesskey = f

certmgr-restore =
    .label = Flytja inn…
    .accesskey = i

certmgr-details =
    .value = Skilríkjasvæði
    .accesskey = S

certmgr-fields =
    .value = Gildi
    .accesskey = G

certmgr-hierarchy =
    .value = Stigskipting skilríkja
    .accesskey = S

certmgr-add-exception =
    .label = Bæta við undantekningu…
    .accesskey = u

exception-mgr =
    .title = Bæta við öryggisfráviki

exception-mgr-extra-button =
    .label = Staðfesta öryggisfrávik
    .accesskey = S

exception-mgr-supplemental-warning = Löglegir bankar, verslanir, og aðrar opinberar stofnanir munu ekki biðja þig um að gera þetta.

exception-mgr-cert-location-url =
    .value = Staðsetning:

exception-mgr-cert-location-download =
    .label = Ná í skilríki
    .accesskey = N

exception-mgr-cert-status-view-cert =
    .label = Skoða…
    .accesskey = k

exception-mgr-permanent =
    .label = Geyma þessa undanþágu til frambúðar
    .accesskey = G

pk11-bad-password = Innslegið lykilorð er vitlaust.
pkcs12-decode-err = Gat ekki afkóðað skrá.  Annaðhvort er þetta ekki skrá á PKCS #12 sniði, skráin er skemmd, eða innslegið lykilorð er rangt.
pkcs12-unknown-err-restore = Vegna óþekktra ástæðna var ekki hægt að endurheimta PKCS #12 skrána.
pkcs12-unknown-err-backup = Vegna óþekktra ástæðna var ekki hægt að búa til PKCS #12 afritunarskrá.
pkcs12-unknown-err = Vegna óþekktra ástæðna tókst PKCS #12 aðgerðin ekki.
pkcs12-info-no-smartcard-backup = Ekki er hægt að afrita skilríki frá öryggistæki sem er í vélbúnaði eins og til dæmis snjallkorti.
pkcs12-dup-data = Skilríkið og einkalykillinn er þegar til á öryggistækinu.

## PKCS#12 file dialogs

choose-p12-backup-file-dialog = Skráarnafn til að taka afrit af
file-browse-pkcs12-spec = PKCS12 skrár
choose-p12-restore-file-dialog = Skírteinisskrá til að flytja inn

## Import certificate(s) file dialog

file-browse-certificate-spec = Skilríkja skrár
import-ca-certs-prompt = Veldu skrá til að flytja inn sem inniheldur CA skilríki
import-email-cert-prompt = Veldu skrá til að flytja inn sem inniheldur skilríki netfangs

## For editing certificates trust

# Variables:
#   $certName: the name of certificate
edit-trust-ca = Skilríkið “{ $certName }” er fulltrúi fyrir vottunarstöð.

## For Deleting Certificates

delete-user-cert-title =
    .title = Eyða skilríkjum
delete-user-cert-confirm = Ertu viss um að þú viljir eyða þessum skilríkjum?
delete-user-cert-impact = Ef þú eyðir þínum eigin skilríkjum geturðu ekki lengur notað þau til að auðkenna sjálfan þig.


delete-ssl-cert-title =
    .title = Eyða skilríkja undantekningum netþjóna
delete-ssl-cert-confirm = Ertu viss um að viljir eyða þessum undantekningum netþjóns?
delete-ssl-cert-impact = EF þú eyðir undantekningu netþjóns, gerirðu aftur virkar venjulegar öryggisaðgerðir sem athuga netþjóna og gera kröfur um gilt skilríki.

delete-ca-cert-title =
    .title = Eyða eða vantreysta CA skilríkjum
delete-ca-cert-confirm = Þú hefur valið að eyða CA skilríkjum. Ef þetta er innbyggð skilríki mun allt traust verða fjarlægt, sem hefur sömu áhrif. Ertu viss um að þú viljir eyða eða vantreysta?
delete-ca-cert-impact = Ef þú eyðir út eða vantreystir skilríki vottunarstöðvar (CA) mun forritið ekki lengur treysta neinum skilríkjum útgefnum af þeirri CA.


delete-email-cert-title =
    .title = Eyða póst skilríkjum
delete-email-cert-confirm = Ertu viss um að þú viljir eyða póst skilríkjum fyrir þetta fólk?
delete-email-cert-impact = Ef þú eyðir skilríki notanda, muntu ekki lengur geta sent dulkóðaðan póst til viðkomandi.

# Used for semi-uniquely representing a cert.
#
# Variables:
#   $serialNumber : the serial number of the cert in AA:BB:CC hex format.
cert-with-serial =
    .value = Skilríki með raðnúmer: { $serialNumber }

## Cert Viewer

# Title used for the Certificate Viewer.
#
# Variables:
#   $certificate : a string representative of the certificate being viewed.
cert-viewer-title =
    .title = Skilríkjaskoðari: “{ $certName }”

not-present =
    .value = <Ekki hluti af skilríki>

# Cert verification
cert-verified = Þetta skilríki hefur verið sannreynt fyrir eftirfarandi notkun:

# Add usage
verify-ssl-client =
    .value = SSL biðlaraskírteini

verify-ssl-server =
    .value = SSL netþjónsskírteini

verify-ssl-ca =
    .value = SSL Vottunarstöð skilríkja

verify-email-signer =
    .value = Póst skilríki

verify-email-recip =
    .value = Skilríki póstviðtakanda

# Cert verification
cert-not-verified-cert-revoked = Get ekki sannreynt þetta skilríki vegna þess að það hefur verið afturkallað.
cert-not-verified-cert-expired = Get ekki sannreynt þetta skilríki vegna þess að það er útrunnið.
cert-not-verified-cert-not-trusted = Get ekki sannreynt þetta skilríki vegna þess að því er ekki treystandi.
cert-not-verified-issuer-not-trusted = Get ekki sannreynt þetta skilríki vegna þess útgefanda er ekki treystandi.
cert-not-verified-issuer-unknown = Get ekki sannreynt þetta skilríki vegna þess að útgefandi er óþekktur.
cert-not-verified-ca-invalid = Get ekki sannreynt þetta skilríki vegna þess að CA skilríki er óleyfilegt.
cert-not-verified_algorithm-disabled = Gat ekki sannreynt þetta skilríki vegna þess að það var undirritað með undirskriftar algrími sem er ekki lengur virkt vegna þess að algrímið er ekki öruggt.
cert-not-verified-unknown = Get ekki sannreynt þetta skilríki vegna óþekktra ástæðna.

## Add Security Exception dialog

add-exception-branded-warning = Þú ert í þann veginn að fara hunsa hvernig { -brand-short-name } auðkennir þetta vefsvæði.
add-exception-invalid-header = Þetta vefsvæði reynir að auðkenna sig með röngum upplýsingum.
add-exception-domain-mismatch-short = Vitlaust vefsvæði
add-exception-domain-mismatch-long = Skilríkið tilheyrir öðru vefsvæði, sem gæti þýtt að einhver sé að reyna að þykjast vera þetta vefsvæði.
add-exception-expired-short = Úreltar upplýsingar
add-exception-expired-long = Skilríkið er ekki gilt. Það gæti verið stolið eða týnt, og einhver gæti notað það til að þykjast vera þetta vefsvæði.
add-exception-unverified-or-bad-signature-short = Óþekkt auðkenni
add-exception-unverified-or-bad-signature-long = Skilríki er ekki treyst, þar sem það hefur ekki verið sannreynt af viðurkenndum aðila með öruggri undirskrift.
add-exception-valid-short = Gilt skilríki
add-exception-valid-long = Þetta vefsvæði hefur gilt, auðkennt auðkenni.  Það þarf ekki að bæta við undantekningu.
add-exception-checking-short = Athuga upplýsingar
add-exception-checking-long = Reyni að auðkenna vefsvæði…
add-exception-no-cert-short = Engar upplýsingar tiltækar
add-exception-no-cert-long = Get ekki náð í stöðu auðkennis fyrir valið vefsvæði.

## Certificate export "Save as" and error dialogs

save-cert-as = Vista skilríki í skrá
cert-format-base64 = X.509 Skilríki (PEM)
cert-format-base64-chain = X.509 Skilríki með keðju (PEM)
cert-format-der = X.509 Skilríki (DER)
cert-format-pkcs7 = X.509 Skilríki (PKCS#7)
cert-format-pkcs7-chain = X.509 Skilríki með keðju (PKCS#7)
write-file-failure = Skrárvilla
