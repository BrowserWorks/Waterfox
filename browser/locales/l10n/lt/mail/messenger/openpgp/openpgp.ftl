# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

e2e-intro-description = Norėdami siųsti užšifruotus ar skaitmeniškai pasirašytus pranešimus, turite sukonfigūruoti šifravimo technologiją - „OpenPGP“ arba „S/MIME“.
e2e-intro-description-more = Pasirinkite savo asmeninį raktą, kad galėtumėte naudoti „OpenPGP“, arba asmeninį sertifikatą, kad galėtumėte naudoti „S/MIME“. Kaip asmeninio rakto ar sertifikato savininkas, jūs turite atitinkamą slaptą raktą.
openpgp-key-user-id-label = Paskyra / Vartotojo ID
openpgp-keygen-title-label =
    .title = Sugeneruoti „OpenPGP“ raktą
openpgp-cancel-key =
    .label = Atšaukti
    .tooltiptext = Atšaukti rakto generavimą
openpgp-key-gen-expiry-title =
    .label = Rakto galiojimo laikas
openpgp-key-gen-expire-label = Rakto galiojimas baigiasi
openpgp-key-gen-days-label =
    .label = dienų
openpgp-key-gen-months-label =
    .label = mėnesių
openpgp-key-gen-years-label =
    .label = metų
openpgp-key-gen-no-expiry-label =
    .label = Raktas nenustoja galioti
openpgp-key-gen-key-size-label = Rakto dydis
openpgp-key-gen-console-label = Raktų generavimas
openpgp-key-gen-key-type-label = Rakto tipas
openpgp-key-gen-key-type-rsa =
    .label = RSA
openpgp-key-gen-key-type-ecc =
    .label = ECC (elipsinės kreivės)
openpgp-generate-key =
    .label = Sukurti raktą
    .tooltiptext = Sukuria naują, su „OpenPGP“ suderinamą raktų porą šifravimui ir (arba) pasirašymui
openpgp-advanced-prefs-button-label =
    .label = Papildomai…
openpgp-keygen-desc = <a data-l10n-name="openpgp-keygen-desc-link"><b>Raktų generavimas gali užtrukti iki kelių minučių.</b></a> Neišeikite iš programos, kol generuojami raktai. Aktyvus naršymas ar aktyvios disko naudojimas raktų generavimo metu pagerins atsitiktinių reikšmių statistiką ir pagreitins procesą. Kai raktai bus sukurti, jus įspės.
openpgp-key-expiry-label =
    .label = Galiojimo pabaiga
openpgp-key-id-label =
    .label = Rakto ID
openpgp-cannot-change-expiry = Tai raktas su sudėtinga struktūra, jo galiojimo pabaigos keitimas nepalaikomas.
openpgp-key-man-title =
    .title = „OpenPGP Key Manager“
openpgp-key-man-generate =
    .label = Nauja raktų pora
    .accesskey = N
openpgp-key-man-gen-revoke =
    .label = Atšaukimo pažymėjimas
    .accesskey = A
openpgp-key-man-ctx-gen-revoke-label =
    .label = Sukurti ir išsaugoti atšaukimo pažymėjimą
openpgp-key-man-file-menu =
    .label = Failas
    .accesskey = F
openpgp-key-man-edit-menu =
    .label = Keisti
    .accesskey = K
openpgp-key-man-view-menu =
    .label = Peržiūrėti
    .accesskey = P
openpgp-key-man-generate-menu =
    .label = Generuoti
    .accesskey = G
openpgp-key-man-keyserver-menu =
    .label = Raktų serveris
    .accesskey = R
openpgp-key-man-import-public-from-file =
    .label = Importuoti viešą (-us) raktą (-us) iš failo
    .accesskey = I
openpgp-key-man-import-secret-from-file =
    .label = Importuoti slaptą(-us) raktą (-us) iš failo
openpgp-key-man-import-sig-from-file =
    .label = Importuoti atšaukimą (-us) iš failo
openpgp-key-man-import-from-clipbrd =
    .label = Importuoti raktą (-us) iš mainų srities
    .accesskey = m
openpgp-key-man-import-from-url =
    .label = Importuoti raktą (-us) iš URL
    .accesskey = u
openpgp-key-man-export-to-file =
    .label = Eksportuoti viešą (-us) raktą (-us) į failą
    .accesskey = E
openpgp-key-man-send-keys =
    .label = Siųsti viešą (-us) raktą (-us) el. paštu
    .accesskey = S
openpgp-key-man-backup-secret-keys =
    .label = Išsaugoti slaptą raktą faile
    .accesskey = s
openpgp-key-man-discover-cmd =
    .label = Ieškoti raktų internete
    .accesskey = I
openpgp-key-man-discover-prompt = „OpenPGP“ raktų paieškai internete, raktų serveryje arba WKD protokolu įveskite arba elektroninio pašto adresą arba rakto ID.
openpgp-key-man-discover-progress = Ieškoma…
openpgp-key-copy-key =
    .label = Kopijuoti viešąjį raktą
    .accesskey = K
openpgp-key-export-key =
    .label = Eksportuoti viešą (-us) raktą (-us) į failą
    .accesskey = E
openpgp-key-backup-key =
    .label = Išsaugoti slaptą raktą faile
    .accesskey = s
openpgp-key-send-key =
    .label = Siųsti viešą raktą el. paštu
    .accesskey = s
openpgp-key-man-copy-to-clipbrd =
    .label = Kopijuoti viešąjį (-ius) raktą (-us) į mainų sritį
    .accesskey = K
openpgp-key-man-copy-key-ids =
    .label =
        { $count ->
            [one] Kopijuoti rakto ID į mainų sritį
            [few] Kopijuoti raktų ID į mainų sritį
           *[other] Kopijuoti raktų ID į mainų sritį
        }
    .accesskey = K
openpgp-key-man-copy-fprs =
    .label =
        { $count ->
            [one] Kopijuoti „piršto atspaudą“ į mainų sritį
            [few] Kopijuoti „pirštų atspaudus“ į mainų sritį
           *[other] Kopijuoti „pirštų atspaudus“ į mainų sritį
        }
    .accesskey = K
openpgp-key-man-copy-to-clipboard =
    .label =
        { $count ->
            [one] Kopijuoti viešąjį raktą į mainų sritį
            [few] Kopijuoti viešuosius raktus į mainų sritį
           *[other] Kopijuoti viešųjų raktų į mainų sritį
        }
    .accesskey = K
openpgp-key-man-ctx-expor-to-file-label =
    .label = Eksportuoti raktus į failą
openpgp-key-man-ctx-copy-to-clipbrd-label =
    .label = Kopijuoti viešuosius raktus į mainų sritį
openpgp-key-man-ctx-copy =
    .label = Kopijuoti
    .accesskey = K
openpgp-key-man-ctx-copy-fprs =
    .label =
        { $count ->
            [one] „Pirštų atspaudas“
            [few] „Pirštų atspaudai“
           *[other] „Pirštų atspaudų“
        }
    .accesskey = a
openpgp-key-man-ctx-copy-key-ids =
    .label =
        { $count ->
            [one] Rakto ID
            [few] Raktų ID
           *[other] Raktų ID
        }
    .accesskey = I
openpgp-key-man-ctx-copy-public-keys =
    .label =
        { $count ->
            [one] Viešasis raktas
            [few] Viešieji raktai
           *[other] Viešųjų raktų
        }
    .accesskey = V
openpgp-key-man-close =
    .label = Užverti
openpgp-key-man-reload =
    .label = Perkrauti raktų talpyklą
    .accesskey = P
openpgp-key-man-change-expiry =
    .label = Keisti galiojimo datą
    .accesskey = K
openpgp-key-man-del-key =
    .label = Ištrinti raktą (-us)
    .accesskey = I
openpgp-delete-key =
    .label = Ištrinti raktą
    .accesskey = I
openpgp-key-man-revoke-key =
    .label = Atšaukti raktą
    .accesskey = A
openpgp-key-man-key-props =
    .label = Rakto savybės
    .accesskey = R
openpgp-key-man-key-more =
    .label = Daugiau
    .accesskey = D
openpgp-key-man-view-photo =
    .label = Nuotrauka
    .accesskey = N
openpgp-key-man-ctx-view-photo-label =
    .label = Peržiūrėti nuotrauką
openpgp-key-man-show-invalid-keys =
    .label = Rodyti netinkamus raktus
    .accesskey = R
openpgp-key-man-show-others-keys =
    .label = Rodyti kitų žmonių raktus
    .accesskey = R
openpgp-key-man-user-id-label =
    .label = Vardas
openpgp-key-man-fingerprint-label =
    .label = „Pirštų atspaudas“
openpgp-key-man-select-all =
    .label = Pasirinkti visus raktus
    .accesskey = v
openpgp-key-man-empty-tree-tooltip =
    .label = Įįveskite paieškos sąlygas aukščiau esančiame laukelyje
openpgp-key-man-nothing-found-tooltip =
    .label = Nei vienas raktas neatitinka jūsų paieškos sąlygų
openpgp-key-man-please-wait-tooltip =
    .label = Palaukite, raktai įkeliami…
openpgp-key-man-filter-label =
    .placeholder = Raktų paieška
openpgp-key-man-select-all-key =
    .key = v
openpgp-key-man-key-details-key =
    .key = I
openpgp-key-details-title =
    .title = Rakto savybės
openpgp-key-details-signatures-tab =
    .label = Sertifikatai
openpgp-key-details-structure-tab =
    .label = struktūra
openpgp-key-details-uid-certified-col =
    .label = Vartotojo ID / patvirtino
openpgp-key-details-user-id2-label = Tariamas rakto savininkas
openpgp-key-details-id-label =
    .label = ID
openpgp-key-details-key-type-label = Tipas
openpgp-key-details-key-part-label =
    .label = Rakto dalis
openpgp-key-details-algorithm-label =
    .label = Algoritmas
openpgp-key-details-size-label =
    .label = Dydis
openpgp-key-details-created-label =
    .label = Sukurtas
openpgp-key-details-created-header = Sukurtas
openpgp-key-details-expiry-label =
    .label = Galiojimo pabaiga
openpgp-key-details-expiry-header = Galiojimo pabaiga
openpgp-key-details-usage-label =
    .label = Naudojimas
openpgp-key-details-fingerprint-label = „Pirštų atspaudas“
openpgp-key-details-sel-action =
    .label = Pasirinkite veiksmą…
    .accesskey = P
openpgp-key-details-also-known-label = Tariamos alternatyvios pagrindinio savininko tapatybės:
openpgp-card-details-close-window-label =
    .buttonlabelaccept = Užverti
openpgp-acceptance-label =
    .label = Jūsų nutarimas
openpgp-acceptance-rejected-label =
    .label = Ne, šį raktą atmesti.
openpgp-acceptance-undecided-label =
    .label = Dar ne, gal vėliau.
openpgp-acceptance-unverified-label =
    .label = Taip, bet aš nepatikrinau, ar tai teisingas raktas.
openpgp-acceptance-verified-label =
    .label = Taip, aš asmeniškai patikrinau, ar šis raktas turi teisingą „pirštų atspaudą“.
key-accept-personal =
    Šiam raktui turite ir viešoją, ir slaptąją dalis. Galite naudoti jį kaip asmeninį raktą.
    Bet jei šį raktą jums davė kažkas kitas, nenaudokite jo kaip asmeninio rakto.
key-personal-warning = Ar pats sukūrėte šį raktą, o rodomas rakto savininkas nurodo jus?
openpgp-personal-no-label =
    .label = Ne, nenaudoti jo kaip mano asmeninio rakto.
openpgp-personal-yes-label =
    .label = Taip, tai asmeninis raktas.
openpgp-copy-cmd-label =
    .label = Kopijuoti

## e2e encryption settings

#   $count (Number) - the number of configured keys associated with the current identity
#   $identity (String) - the email address of the currently selected identity
openpgp-description =
    { $count ->
        [0] „Thunderbird“ nerado asmeninių „OpenPGP“ raktų, susietų su <b> { $identity } </b>
        [one] „Thunderbird“ rado { $count } asmeninį „OpenPGP“ raktą, susietą su <b> { $identity } </b>
        [few] „Thunderbird“ rado { $count } asmeninius „OpenPGP“ raktus, susietus su <b> { $identity } </b>
       *[other] „Thunderbird“ rado { $count } asmeninių „OpenPGP“ raktus, susietų su <b> { $identity } </b>
    }
#   $count (Number) - the number of configured keys associated with the current identity
#   $key (String) - the currently selected OpenPGP key
openpgp-selection-status =
    { $count ->
        [0] Norėdami naudoti „OpenPGP“, nurodykite tinkamą raktą.
        [one] Dabartinėje konfigūracijoje naudojamo rakto ID: <b> { $key } </b>
        [few] Dabartinėje konfigūracijoje naudojamų raktų ID: <b> { $key } </b>
       *[other] Dabartinėje konfigūracijoje naudojamų raktų ID: <b> { $key } </b>
    }
#   $key (String) - the currently selected OpenPGP key
openpgp-selection-status-error = Dabartinėje konfigūracijoje naudojamas raktas <b> { $key } </b>, kurio galiojimo laikas baigėsi.
openpgp-add-key-button =
    .label = Pridėti raktą…
    .accesskey = P
e2e-learn-more = Sužinoti daugiau
openpgp-keygen-success = „OpenPGP“ raktas sukurtas sėkmingai!
openpgp-keygen-import-success = „OpenPGP“ raktai sėkmingai importuoti!
openpgp-keygen-external-success = Išorinio „GnuPG“ rakto ID išsaugotas.

## OpenPGP Key selection area

openpgp-radio-none =
    .label = Joks
openpgp-radio-none-desc = Šiai tapatybei „OpenPGP“ nenaudoti.
openpgp-radio-key-not-found = Šio rakto rasti nepavyko! Jei norite jį naudoti, turite jį importuoti į „{ -brand-short-name }“.
#   $key (String) - the expiration date of the OpenPGP key
openpgp-radio-key-expires = Galiojimas baigiasi: { $date }
openpgp-key-expires-image =
    .tooltiptext = Raktas baigs galioti mažiau nei po 6 mėnesių
#   $key (String) - the expiration date of the OpenPGP key
openpgp-radio-key-expired = Negalioja nuo: { $date }
openpgp-key-expired-image =
    .tooltiptext = Raktas nebegalioja
openpgp-key-expand-section =
    .tooltiptext = Daugiau informacijos
openpgp-key-revoke-title = Atšaukti raktą
openpgp-key-edit-title = Pakeisti „OpenPGP“ raktą
openpgp-key-edit-date-title = Pratęsti galiojimo datą
openpgp-manager-description = Korespondentų  viešųjų raktų ir visų kitų aukščiau neišvardintų raktų peržiūrai ir tvarkymui naudokite „OpenPGP Key Manager“.
openpgp-manager-button =
    .label = „OpenPGP Key Manager“
    .accesskey = O
openpgp-key-remove-external =
    .label = Pašalinti išorinio rakto ID
    .accesskey = P
key-external-label = Išorinis „GnuPG“ raktas
# Strings in keyDetailsDlg.xhtml
key-type-public = viešas raktas
key-type-primary = pirminis raktas
key-type-subkey = dalinis raktas
key-type-pair = raktų pora (slaptas ir viešas raktai)
key-expiry-never = niekada
key-usage-encrypt = Užšifruoti
key-usage-sign = Pasirašyti
key-usage-certify = Patvirtinti
key-usage-authentication = Tapatumo nustatymas
key-does-not-expire = Raktas nenustoja galioti
key-expired-date = Raktas negalioja nuo { $keyExpiry }
key-expired-simple = Raktas nebegalioja
key-revoked-simple = Raktas atšauktas
key-do-you-accept = Ar priimate šį raktą skaitmeninių parašų tikrinimui ir pranešimų šifravimui?
key-accept-warning = Venkite priimti nepatikrintą raktą. Norėdami patikrinti korespondento rakto „pirštų atspaudą“ naudokite ir kitokį nei elektroninis paštas ryšio kanalą.
# Strings enigmailMsgComposeOverlay.js
cannot-use-own-key-because = Nepavyko išsiųsti pranešimo, nes yra problema su jūsų asmeniniu raktu. { $problem }
cannot-encrypt-because-missing = Nepavyko išsiųsti šio pranešimo su abipusiu šifravimu, nes kilo problemų su šių gavėjų raktais: { $problem }
window-locked = Kūrimo langas yra užrakintas; siuntimas atšauktas
# Strings in mimeDecrypt.jsm
mime-decrypt-encrypted-part-attachment-label = Šifruota pranešimo dalis
mime-decrypt-encrypted-part-concealed-data = Tai -  užšifruota pranešimo dalis. Turite šį priedą atidaryti atskirame lange.
# Strings in keyserver.jsm
keyserver-error-aborted = Nutraukta
keyserver-error-unknown = Įvyko nežinoma klaida
keyserver-error-server-error = Raktų serveris pranešė apie klaidą.
keyserver-error-import-error = Nepavyko importuoti atsisiųsto rakto.
keyserver-error-unavailable = Raktų serveris nepasiekiamas.
keyserver-error-security-error = Raktų serveris nepalaiko šifruotos prieigos.
keyserver-error-certificate-error = Raktų serverio sertifikatas negalioja.
keyserver-error-unsupported = Raktų serveris nepalaikomas.
# Strings in mimeWkdHandler.jsm
wkd-message-body-req =
    Jūsų el. pašto paslaugų teikėjas apdorojo jūsų užklausą įkelti viešąjį raktą į „OpenPGP“ žiniatinklio raktų katalogą.
    Patvirtinkite ir baigsite viešojo rakto paskelbimą.
wkd-message-body-process =
    Šis el. laiškas susijęs su automatiniu viešų „OpenPGP“ raktų įkėlimu į žiniatinklio raktų katalogą.
    Jums nereikia atlikti jokių rankinių veiksmų.
# Strings in persistentCrypto.jsm
converter-decrypt-body-failed =
    Nepavyko iššifruoti pranešimo, kurio tema
    { $subject }.
    Galima bandyti dar kartą, naudojant kitą slaptažodį, arba praleisti pranešimą.
# Strings in gpg.jsm
unknown-signing-alg = Nežinomas pasirašymo algoritmas (ID: { $id })
unknown-hash-alg = Nežinoma kriptografinė maiša (ID: { $id })
# Strings in keyUsability.jsm
expiry-key-expires-soon =
    Jūsų „{ $desc }“ raktas baigs galioti po mažiau nei { $days } dienų.
    Rekomenduojame sukurti naują raktų porą ir atitinkamai sukonfigūruoti paskyras.
expiry-keys-expire-soon =
    Šie raktai baigs galioti mažiau nei po { $days } dienų: { $desc }.
    Rekomenduojame susikurti naujus raktus ir atitinkamai sukonfigūruoti paskyras.
expiry-key-missing-owner-trust =
    Jūsų slaptas raktas { $desc } nepakankamai patikimas.
    Mes rekomenduojame pagrindinėse savybėse parinktį „Jūs pasitikite sertifikatais“ nustatyti kaip „Visiškas“.
expiry-keys-missing-owner-trust =
    Šie slapti raktai nepakankamai patikimo.
    { $desc }.
    Mes rekomenduojame pagrindinėse savybėse parinktį „Jūs pasitikite sertifikatais“ nustatyti kaip „Visiškas“.
expiry-open-key-manager = Atverti „OpenPGP Key Manager“
expiry-open-key-properties = Rakto savybės
# Strings filters.jsm
filter-folder-required = Reikia nurodyti aplanką.
filter-decrypt-move-warn-experimental =
    Įspėjimas - filtravimo veiksmas „Iššifruoti visam laikui“ gali sunaikinti pranešimus.
    Primygtinai rekomenduojama pirmiausia išbandyti filtrą „Sukurti iššifruotą kopiją“, atidžiai peržiūrėti rezultatą ir pradėti naudoti šį filtrą tik tada, kai esate šiuo rezultatu užtikrintas.
filter-term-pgpencrypted-label = Šifruotas „OpenPGP“
filter-key-required = Turite pasirinkti gavėjo raktą.
filter-key-not-found = Nepavyko rasti „{ $desc }“ šifravimo rakto.
filter-warn-key-not-secret =
    Įspėjimas - filtravimo veiksmas „Šifruoti į raktą“ pakeičia gavėjus.
    Jei neturite slapto „{ $desc }“ rakto, nebegalėsite skaityti el. laiškų.
# Strings filtersWrapper.jsm
filter-decrypt-move-label = Iššifruoti visam laikui („OpenPGP“)
filter-decrypt-copy-label = Sukurti iššifruotą kopiją („OpenPGP“)
filter-encrypt-label = Šifruoti su raktu („OpenPGP“)
# Strings in enigmailKeyImportInfo.js
import-info-title =
    .title = Raktai sėkmingai importuoti
import-info-bits = bitų
import-info-created = Sukurtas
import-info-fpr = „Pirštų atspaudas“
import-info-details = Peržiūrėti išsamią informaciją ir tvarkyti raktų priėmimą
import-info-no-keys = Nėra importuotų raktų.
# Strings in enigmailKeyManager.js
import-from-clip = Ar tikrai norite importuoti raktą (-us) iš mainų srities?
import-from-url = Atsisiųsti viešąjį raktą iš šio URL:
copy-to-clipbrd-failed = Nepavyko nukopijuoti pasirinkto (-ų) rakto (-ų) į mainų sritį.
copy-to-clipbrd-ok = Raktas (-ai) nukopijuotas (-i) į mainų sritį
delete-secret-key =
    ĮSPĖJIMAS: ketinate ištrinti slaptą raktą!
    
    Kai ištrinsite slaptą raktą, nebegalėsite iššifruoti jokių šiam raktui šifruotų pranešimų, taip pat negalėsite jo atšaukti.
    
    Ar tikrai norite ištrinti ABU, slaptąjį ir viešąjį „{ $userId }“ raktus?
delete-mix =
    ĮSPĖJIMAS: ketinate ištrinti slaptus raktus!
    Kai ištrinsite slaptą raktą, nebegalėsite iššifruoti jokių šiam raktui užšifruotų pranešimų.
    Ar tikrai norite ištrinti pasirinktus ABU, slaptą ir viešą, raktus?
delete-pub-key =
    Ar norite ištrinti viešąjį raktą
    „{ $userId }“?
delete-selected-pub-key = Ar norite ištrinti šiuos viešuosius raktus?
refresh-all-question = Nepasirinkote jokio rakto. Ar norite atnaujinti VISUS raktus?
key-man-button-export-sec-key = Eksportuoti slaptus raktus
key-man-button-export-pub-key = Eksportuoti tik viešuosius raktus
key-man-button-refresh-all = Atnaujinti &visus raktus
key-man-loading-keys = Palaukite, įkeliami raktai…
ascii-armor-file = ASCII apsaugoti failai (* .asc)
no-key-selected = Norėdami atlikti pasirinktą operaciją, turėtumėte pasirinkti bent vieną raktą
export-to-file = Eksportuoti viešąjį raktą į failą
export-keypair-to-file = Eksportuoti slaptą ir viešąjį raktą į failą
export-secret-key = Ar norite įtraukti slaptąjį raktą į išsaugojamą „OpenPGP“ rakto failą?
save-keys-ok = Raktai išsaugoti
save-keys-failed = Nepavyko išsaugoti raktų
default-pub-key-filename = Eksportuoti viešieji raktai
default-pub-sec-key-filename = Slaptų raktų atsarginės kopijos
refresh-key-warn = Įspėjimas: atsižvelgiant į raktų skaičių ir ryšio greitį, visų raktų atnaujinimas gali būti gana ilgas procesas!
preview-failed = Nepavyko nuskaityti viešojo rakto failo.
general-error = Klaida: { $reason }
dlg-button-delete = Š&alinti

## Account settings export output

openpgp-export-public-success = <b> Viešasis raktas eksportuotas </b>
openpgp-export-public-fail = <b> Nepavyko eksportuoti pasirinkto viešojo rakto! </b>
openpgp-export-secret-success = <b> Slaptasis raktas eksportuotas </b>
openpgp-export-secret-fail = <b> Nepavyko eksportuoti pasirinkto slaptojo rakto! </b>
# Strings in keyObj.jsm
key-ring-pub-key-revoked = Raktas { $userId } (rakto ID { $keyId }) yra atšauktas.
key-ring-pub-key-expired = Rakto „{ $userId }“ (rakto ID „{ $keyId }“) galiojimas pasibaigęs.
key-ring-key-disabled = Raktas „{ $userId }“ (rakto ID „{ $keyId }“) išjungtas; jo negalima naudoti.
key-ring-key-invalid = Raktas { $userId } (rakto ID { $keyId }) neteisingas. Patikrinkite jį.
key-ring-key-not-trusted = Raktas { $userId } (rakto ID { $keyId }) nėra pakankamai patikimas. Jei norite jį naudoti pasirašydami, nustatykite šio rakto pasitikėjimo lygį „Visiškas“.
key-ring-no-secret-key = Panašu, kad jūs neturite slapto { $userId } (rakto ID { $keyId }) rakto, todėl negalite naudoti šio rakto pasirašymui.
key-ring-pub-key-not-for-signing = Raktas { $userId } (rakto ID { $keyId }) negali būti naudojamas pasirašymuit.
key-ring-pub-key-not-for-encryption = Raktas { $userId } (rakto ID { $keyId }) negali būti naudojamas užšifravimui.
key-ring-sign-sub-keys-revoked = Visi rakto { $userId } (rakto ID { $keyId }) pasirašymo raktai atšaukiami.
key-ring-sign-sub-keys-expired = Visi rakto { $userId } (rakto ID { $keyId }) pasirašymo raktai nebegalioja.
key-ring-sign-sub-keys-unusable = Visi rakto { $userId } (rakto ID { $keyId }) pasirašymo raktai yra atšaukti, jų galiojimo laikas pasibaigęs arba jie yra kitaip netinkami naudoti.
key-ring-enc-sub-keys-revoked = Visi rakto { $userId } (rakto ID { $keyId }) šifravimo raktai atšaukiami.
key-ring-enc-sub-keys-expired = Visi rakto { $userId } (rakto ID { $keyId }) šifravimo raktai nebegalioja.
key-ring-enc-sub-keys-unusable = Visi { $userId } rakto  "{ $keyId }“ šifravimo raktai arba atšaukti, arba nebegalioja, arba jie kitaip netinkami naudoti.
# Strings in gnupg-keylist.jsm
keyring-photo = Nuotrauka
user-att-photo = Vartotojo atributas (JPEG vaizdas)
# Strings in key.jsm
already-revoked = Šis raktas atšauktas.
#   $identity (String) - the id and associated user identity of the key being revoked
revoke-key-question =
    Ketinate atšaukti raktą „{ $identity }“.
    Jūs nebegalėsite pasirašyti šiou raktu, o kai atšaukimo informacija bus išplatinta, kiti nebegalės šifruoti šiuo raktu. Bet vis dar galėsite naudoti raktą iššifruoti seniems pranešimams.
    Ar norite testi?
#   $keyId (String) - the id of the key being revoked
revoke-key-not-present =
    Jūs neturite rakto (0x{ $keyId }), kuris atitiktų šį atšaukimo sertifikatą!
    Jei pametėte raktą, prieš importuodami atšaukimo sertifikatą turite šį raktą importuoti (pvz. iš raktų serverio).
#   $keyId (String) - the id of the key being revoked
revoke-key-already-revoked = Raktas 0x{ $keyId } jau atšauktas.
key-man-button-revoke-key = &Atšaukti raktą
openpgp-key-revoke-success = Raktas sėkmingai atšauktas.
after-revoke-info =
    Raktas atšauktas.
    Dar kartą bendrinkite šį viešąjį raktą siųsdami jį el. paštu arba įkeldami į raktų serverius, kad kiti žinotų, jog atšaukėte raktą.
    Kai tik kitų žmonių naudojama programinė įranga sužinos apie rakto atšaukimą, ji nustos naudoti seną raktą.
    Jei tam pačiam el. pašto adresui naudojate naują raktą ir jį pridedate prie siunčiamų el. laiškų, informacija apie panaikintą seną raktą bus įtraukta automatiškai .
# Strings in keyRing.jsm & decryption.jsm
key-man-button-import = &Importuoti
delete-key-title = Pašalingti „OpenPGP“ raktą
delete-external-key-title = Pašalinti išorinį „GnuPG“ raktą
delete-external-key-description = Ar norite pašalinti šį išorinio „GnuPG“ rakto ID?
key-in-use-title = Šis „OpenPGP“ raktas šiuo metu naudojamas
delete-key-in-use-description = Neįmanoma tęsti! Ši tapatybė šiuo metu naudoja raktą, kurį norite ištrinti. Pasirinkite tapatybei kitą raktą ( arba jokio rakto) ir bandykite dar kartą.
revoke-key-in-use-description = Neįmanoma tęsti! Ši tapatybė šiuo metu naudoja raktą, kurį norite atšaukti. Pasirinkite tapatybei kitą raktą ( arba jokio rakto) ir bandykite dar kartą.
# Strings used in errorHandling.jsm
key-error-key-spec-not-found = El. pašto adreso „{ $keySpec }“ nėra jūsų raktų sąraše.
key-error-key-id-not-found = Nurodyto rakto ID „{ $keySpec }“ nėrai jūsų raktų saraše.
key-error-not-accepted-as-personal = Jūs nepatvirtinote, kad raktas, kurio ID „{ $keySpec }“, yra jūsų asmeninis raktas.
# Strings used in enigmailKeyManager.js & windows.jsm
need-online = Pasirinkta funkcija negalima neprisijungus prie tinklo. Prisijunkite prie interneto ir bandykite dar kartą.
# Strings used in keyRing.jsm & keyLookupHelper.jsm
no-key-found = Nepavyko rasti jokių raktų, atitinkančių nurodytus paieškos kriterijus.
# Strings used in keyRing.jsm & GnuPGCryptoAPI.jsm
fail-key-extract = Klaida - nepavyko išgauti rakto
# Strings used in keyRing.jsm
fail-cancel = Klaida - rakto gavimą atšaukė vartotojas
not-first-block = Klaida - pirmasis „OpenPGP“ blokas nėra viešojo rakto blokas
import-key-confirm = Ar importuoti į pranešimą įdėtą(-us) viešąjį raktą(-us)?
fail-key-import = Klaida - nepavyko importuoti rakto
file-write-failed = Nepavyko įrašyti į failą { $output }
no-pgp-block = Klaida - nerastas galiojantis apsaugotas „OpenPGP“ duomenų blokas
confirm-permissive-import = Nepavyko importuoti. Raktas, kurį bandote importuoti, gali būti sugadintas arba naudoja nežinomus atributus. Galima pabandyti importuoti teisingas dalis, bet dėl to gali būti importuojami neišsamūs ar netinkami naudojimui raktai.
# Strings used in trust.jsm
key-valid-unknown = nežinomas
key-valid-invalid = netinkamas
key-valid-disabled = išjungtas
key-valid-revoked = atšauktas
key-valid-expired = nebegalioja
key-trust-untrusted = nepatikimas
key-trust-marginal = ribinis
key-trust-full = patikimas
key-trust-ultimate = visiškas
key-trust-group = (grupė)
# Strings used in commonWorkflows.js
import-key-file = Importuoti „OpenPGP“ raktų failą
import-rev-file = Importuoti „OpenPGP“ atšaukimų failą
gnupg-file = „GnuPG“ failai
import-keys-failed = Nepavyko importuoti raktų
passphrase-prompt = Įveskite rakto „{ $key }“ slaptažodį.
file-to-big-to-import = Šis failas per didelis. Neimportuokite didelių raktų rinkinių vienu metu.
# Strings used in enigmailKeygen.js
save-revoke-cert-as = Sukurti ir išsaugoti atšaukimo pažymėjimą
revoke-cert-ok = Atšąukimo sertifikatas sėkmingai sukurtas. Galite jį naudoti norėdami anuliuoti savo viešąjį raktą, pvz. jei pamestumėte slaptą raktą.
revoke-cert-failed = Nepavyko sukurti atšaukimo pažymėjimo.
gen-going = Raktai jau generuojami!
keygen-missing-user-name = Pasirinktoje paskyroje / tapatybėje nenurodytas vardas. Paskyros nustatymuose įrašykite vardą lauke „Jūsų vardas“.
expiry-too-short = Jūsų raktas turi galioti mažiausiai vieną dieną.
expiry-too-long = Negalite sukurti rakto, kurio galiojimo laikas baigsis daugiau nei po 100 metų.
key-confirm = Generuoti viešą ir slaptąjį „{ $id }“ raktą?
key-man-button-generate-key = &Sukurti raktą
key-abort = Nutraukti raktų generavimą?
key-man-button-generate-key-abort = &Nutraukti raktų generavimą?
key-man-button-generate-key-continue = &Tęsti raktų generavimą

# Strings used in enigmailMessengerOverlay.js

failed-decrypt = Klaida - nepavyko iššifruoti
fix-broken-exchange-msg-failed = Nepavyko ištaisyti šio pranešimo.
attachment-no-match-from-signature = Nepavyko suderinti parašo failo „{ $attachment }“ ir priedo
attachment-no-match-to-signature = Nepavyko suderinti priedo „{ $attachment }“ ir parašo failo
signature-verified-ok = Priedo „{ $attachment }“ parašas buvo sėkmingai patvirtintas
signature-verify-failed = Nepavyko patvirtinti priedo „{ $attachment }“ parašo
decrypt-ok-no-sig =
    Įspėjimas
    Iššifruoti pavyko, tačiau parašo nepavyko teisingai patikrinti.
msg-ovl-button-cont-anyway = &Tęsti bet kokiu atveju
enig-content-note = * Šio pranešimo priedai nebuvo pasirašyti ir užšifruoti *
# Strings used in enigmailMsgComposeOverlay.js
msg-compose-button-send = Išsiųsti laišką
msg-compose-details-button-label = Išsamiau…
msg-compose-details-button-access-key = D
send-aborted = Siuntimas nutrauktas.
key-not-trusted = Nepakankamai pasitikima raktu „{ $key }“
key-not-found = Raktas „{ $key }“ nerastas
key-revoked = Raktas „{ $key }“ buvo atšauktas
key-expired = Raktas „{ $key }“ nebegalioja
msg-compose-internal-error = Įvyko vidinė klaida.
keys-to-export = Pasirinkite „OpenPGP“ raktą įterpimui
msg-compose-partially-encrypted-inlinePGP =
    Pranešime, į kurį atsakote, buvo tiek nešifruotų, tiek ir užšifruotų dalių. Jei siuntėjas iš pradžių negalėjo iššifruoti kai kurių pranešimų dalių, galite nutekėti konfidenciali informacij, kurios siuntėjas negalėjo pats iššifruoti.
    Apsvarstykite galimybę pašalinti visą cituojamą tekstą iš atsakymo šiam siuntėjui.
msg-compose-cannot-save-draft = Klaida išsaugant juodraštį
msg-compose-partially-encrypted-short = Nenutekinkite neskelbtinos informacijos - tik dalis pranešimo užšifruota.
quoted-printable-warn =
    Pranešimų siuntimui nustatėte 'quoted-printable'  kodavimą. Todėl jūsų pranešimas gali būti neteisingai iššifruotas ir (arba) patvirtintas.
    Gal norite dabar išjungti 'quoted-printable' pranešimų siuntimą?
minimal-line-wrapping =
    Jūs nustatėte { $width } simbolių eilutęs ilgį. Norint teisingai užšifruoti ir (arba) pasirašyti, šis ilgis turi būti bent 68.
    Ar norite pakeisti eilučių ilgį į 68 simbolius?
sending-hidden-rcpt = Nematomos kopijos (BCC) gavėjams užšifruotas pranešimas negali būti siunčiamas. Norėdami išsiųsti šį užšifruotą pranešimą, pašalinkite nematomų kopijų gavėjus arba perkelkite juos į lauką „Kopija“.
sending-news =
    Šifruota siuntimo operacija nutraukta.
    Šio pranešimo negalima užšifruoti, nes jį gaus ir naujienų grupės. Išsiųskite pranešimą iš naujo, be šifravimo.
send-to-news-warning =
    Įspėjimas: ruošiatės siųsti užšifruotą pranešimą naujienų grupei.
    Tai nerekomenduojama, nes turi prasmę tik tuomet, kai visi grupės nariai galės iššifruoti šį pranešimą, todėl pranešimą reikia užšifruoti visų grupės dalyvių raktais. Siųskite šį pranešimą tik tada, jei tiksliai žinote, ką darote.
    Tęsti?
save-attachment-header = Išsaugoti iššifruotą priedą
no-temp-dir =
    Nepavyko rasti laikino katalogo, į kurį galėtumėte rašyti.
    Tinkamia nustatykite TEMP aplinkos kintamąjį.
possibly-pgp-mime = Galbūt tai PGP/MIME šifruotas arba pasirašytas pranešimas; patikrinimui naudokite funkciją „Iššifruoti / patvirtinti“
cannot-send-sig-because-no-own-key = Negalima pasirašyti šio pranešimo skaitmeniniu būdu, nes raktui „<{ $key }>“ dar nesukonfigūravote abipusio šifravimo
cannot-send-enc-because-no-own-key = Negalima užšifruoti ir išsiųsti šio pranešimo, nes raktui „<{ $key }>“ dar nesukonfigūravote abipusio šifravimo
# Strings used in decryption.jsm
do-import-multiple =
    Importuoti šiuos raktus?
    { $key }
do-import-one = Importuoti „{ $name }“ ({ $id })?
cant-import = Importuojant viešąjį raktą įvyko klaida
unverified-reply = Įtraukta pranešimo dalis (atsakymas) tikriausiai buvo modifikuota
key-in-message-body = Pranešimo tekste rastas raktas. Norėdami jį importuoti, pasirinkite „Importuoti raktą“
sig-mismatch = Klaida - neatitinka parašas
invalid-email = Klaida - netinkamas(-i) elektroninio pašto adresas (-ai)
attachment-pgp-key =
    Panašu, kad atidaromas priedas „{ $name }“ yra „OpenPGP“ rakto failas.
    Spustelėkite „Importuoti“, jei norite importuoti esančius raktus, arba „Žiūrėti“, jei norite peržiūrėti failo turinį naršyklės lange
dlg-button-view = &Peržiūrėti
# Strings used in enigmailMsgHdrViewOverlay.js
decrypted-msg-with-format-error = Iššifruotas pranešimas ( tai atkurtas sugadintas PGP el. pašto pranešimas, kurį tikriausiai sugadino senas „Exchange“ serveris. Rezultatas gali būti netikslus ar neįskaitomas)
# Strings used in encryption.jsm
not-required = Klaida - šifruoti nereikia
# Strings used in windows.jsm
no-photo-available = Nuotraukos nėra
error-photo-path-not-readable = Nepavyko nuskaityti nuotraukų iš nurodytos vietos „{ $photo }“
debug-log-title = „OpenPGP“ derinimo žurnalas
# Strings used in dialog.jsm
repeat-prefix = Šis įspėjimas pasikartos { $count }
repeat-suffix-singular = daugiau laiko.
repeat-suffix-plural = daugiau kartų.
no-repeat = Šis perspėjimas daugiau nebus rodomas.
dlg-keep-setting = Įsiminti mano atsakymą ir daugiau nebeklausti
dlg-button-ok = &Gerai
dlg-button-close = &Užverti
dlg-button-cancel = &Atsisakyti
dlg-no-prompt = Šio dialogo daugiau neberodyti.
enig-prompt = „OpenPGP“ pranešimas
enig-confirm = „OpenPGP“ patvirtinimas
enig-alert = „OpenPGP“ įspėjimas
enig-info = „OpenPGP“ informacija
# Strings used in persistentCrypto.jsm
dlg-button-retry = Kartoti
dlg-button-skip = &Praleisti
# Strings used in enigmailCommon.js
enig-error = „OpenPGP“ klaida
# Strings used in enigmailMsgBox.js
enig-alert-title =
    .title = „OpenPGP“ įspėjimas
