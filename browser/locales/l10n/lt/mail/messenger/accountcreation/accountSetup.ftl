# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

account-setup-tab-title = Paskyros kūrimas

## Header

account-setup-title = Nustatykite turimą el. pašto adresą

account-setup-description =
    Norėdami naudoti turimą el. pašto adresą, užpildykite savo kredencialus. <br/>
    „{ -brand-product-name }“ bandys automatiškai surasti veikiančią ir rekomenduojamą serverių konfigūraciją.

## Form fields

account-setup-name-label = Jūsų vardas ir pavardė
    .accesskey = v

# Note: "John Doe" is a multiple-use name that is used when the true name of a person is unknown. We use this fake name as an input placeholder. Translators should update this to reflect the placeholder name of their language/country.
account-setup-name-input =
    .placeholder = Jonas Jonaitis (Jaunesnysis)

account-setup-name-info-icon =
    .title = Kitiems rodomas jūsų vardas


account-setup-name-warning-icon =
    .title = { account-setup-name-warning }

account-setup-email-label = Elektroninio pašto adresas
    .accesskey = E

account-setup-email-input =
    .placeholder = john.doe@example.com

account-setup-email-info-icon =
    .title = Jūsų turimas el. pašto adresas

account-setup-email-warning-icon =
    .title = { account-setup-email-warning }

account-setup-password-label = Slaptažodis
    .accesskey = S
    .title = Nebūtinas, bus naudojamas tikrinant naudotojo vardą

account-provisioner-button = Gauti naują el. pašto adresą
    .accesskey = n

account-setup-password-toggle =
    .title = Rodyti / slėpti slaptažodį

account-setup-remember-password = Įsiminti slaptažodį
    .accesskey = s

account-setup-exchange-label = Jūsų prisijungimo vardas
    .accesskey = p

#   YOURDOMAIN refers to the Windows domain in ActiveDirectory. yourusername refers to the user's account name in Windows.
account-setup-exchange-input =
    .placeholder = DOMENAS\naudotojas

#   Domain refers to the Windows domain in ActiveDirectory. We mean the user's login in Windows at the local corporate network.
account-setup-exchange-info-icon =
    .title = Prisijungimas pagal „Windows“ domeną

## Action buttons

account-setup-button-cancel = Atšaukti
    .accesskey = A

account-setup-button-manual-config = Konfigūruoti rankiniu būdu
    .accesskey = r

account-setup-button-stop = Stabdyti
    .accesskey = S

account-setup-button-retest = Patikrinti dar kartą
    .accesskey = P

account-setup-button-continue = Tęsti
    .accesskey = T

account-setup-button-done = Atlikta
    .accesskey = A

## Notifications

account-setup-looking-up-settings = Ieškoma konfigūracija …

account-setup-looking-up-settings-guess = Ieškoma konfigūracija: bandomi įprasti serverių pavadinimai …

account-setup-looking-up-settings-half-manual = Ieškoma konfigūracija: tikrinamas serveris …

account-setup-looking-up-disk = Ieškoma konfigūracijos: „{ -brand-short-name }“ nustatymuose ...

account-setup-looking-up-isp = Ieškoma konfigūracija: el. pašto teikėjas …

# Note: Do not translate or replace Waterfox. It stands for the public project mozilla.org, not Waterfox Corporation. The database is a generic, public domain facility usable by any client.
account-setup-looking-up-db = Ieškoma konfigūracija „Waterfox“ turimoje paslaugų tiekėjų duomenų bazėje …

account-setup-looking-up-mx = Ieškoma konfigūracija: gaunamo pašto domenas …

account-setup-looking-up-exchange = Ieškoma konfigūracija: „Exchange“ serveris …

account-setup-checking-password = Tikrinamas slaptažodis …

account-setup-installing-addon = Atsisiunčiamas ir įdiegiamas priedas …

account-setup-success-half-manual = Tikrinant nurodytą serverį rasti šie nustatymai :

account-setup-success-guess = Bandant įprastus serverių pavadinimus rasta ši konfigūracija.

account-setup-success-guess-offline = Šiuo metu atsijungta nuo tinklo. Programa pabandė nuspėti dalį nuostatų, tačiau jums reikės jas patikslinti.

account-setup-success-password = Slaptažodis tinkamas

account-setup-success-addon = Priedas sėkmingai įdiegtas

# Note: Do not translate or replace Waterfox. It stands for the public project mozilla.org, not Waterfox Corporation. The database is a generic, public domain facility usable by any client.
account-setup-success-settings-db = Konfigūracija rasta „Waterfox“ turimoje paslaugų tiekėjų duomenų bazėje.

account-setup-success-settings-disk = Konfigūracija rasta „{ -brand-short-name }“ nuostatose.

account-setup-success-settings-isp = Konfigūracija rasta el. pašto paslaugų teikėjo nustatymuose.

# Note: Microsoft Exchange is a product name.
account-setup-success-settings-exchange = Rasta „Microsoft Exchange“ serverio konfigūracija.

## Illustrations

account-setup-step1-image =
    .title = Pradiniai nustatymai

account-setup-step2-image =
    .title = Įkeliama …

account-setup-step3-image =
    .title = Konfigūracija rasta

account-setup-step4-image =
    .title = Ryšio klaida

account-setup-selection-help = Nežinote, ką pasirinkti?

account-setup-selection-error = Reikia pagalbos?

account-setup-documentation-help = Sąrankos žinynas

account-setup-forum-help = Palaikymo forumas

## Results area

# Note: IMAP is the name of a protocol.
account-setup-result-imap = IMAP

account-setup-result-imap-description = Aplankus ir el. laiškus visada sinchronizuoti su serveriu.

# Note: POP3 is the name of a protocol.
account-setup-result-pop = POP3

account-setup-result-pop-description = Aplankus ir el. laiškus saugoti tik kompiuteryje

# Note: Exchange is the name of a product.
account-setup-result-exchange = „Exchange“

account-setup-incoming-title = Gaunami

account-setup-outgoing-title = Siunčiami

account-setup-username-title = Naudotojo vardas

account-setup-exchange-title = Serveris

account-setup-result-smtp = SMTP

account-setup-result-no-encryption = Be šifravimo

account-setup-result-ssl = SSL/TLS

account-setup-result-starttls = STARTTLS

account-setup-result-outgoing-existing = Bus naudojamas esamas SMTP serveris

## Error messages

# Note: The reference to "janedoe" (Jane Doe) is the name of an example person. You will want to translate it to whatever example persons would be named in your language. In the example, AD is the name of the Windows domain, and this should usually not be translated.
account-setup-credentials-incomplete = Autentifikuotis nepavyko. Arba įvesti kredencialai yra neteisingi, arba norint prisijungti reikia kitokio vartotojo vardo. Šis vartotojo vardas paprastai yra jūsų „Windows“ domeno prisijungimo vardas su domenu arba be jo (pvz., jonasjonaitis arba AD\\jonasjonaitis)

account-setup-credentials-wrong = Nepavyko autentifikuoti. Patikrinkite vartotojo vardą ir slaptažodį

account-setup-find-settings-failed = „{ -brand-short-name }“ nepavyko rasti jūsų el. pašto paskyros nustatymų

account-setup-exchange-config-unverifiable = Nepavyko patvirtinti konfigūracijos. Jei jūsų vartotojo vardas ir slaptažodis yra teisingi, tikėtina, kad serverio administratorius išjungė pasirinktą jūsų paskyros konfigūraciją. Pabandykite pasirinkti kitą protokolą.

## Manual configuration area

account-setup-manual-config-title = Serverio nuostatos

account-setup-incoming-server-legend = Gaunamų laišku serveris

account-setup-protocol-label = Protokolas:

protocol-imap-option = { account-setup-result-imap }

protocol-pop-option = { account-setup-result-pop }

protocol-exchange-option = { account-setup-result-exchange }

account-setup-hostname-label = Serverio pavadinimas:

account-setup-ssl-label = Saugusis ryšys:

account-setup-outgoing-server-legend = Siunčiamu laiškų serveris

## Incoming/Outgoing SSL Authentication options

ssl-autodetect-option = Nustatyti automatiškai

ssl-no-authentication-option = Tapatumas netikrinamas

ssl-cleartext-password-option = Paprastas slaptažodis

ssl-encrypted-password-option = Šifruotas slaptažodis

## Incoming/Outgoing SSL options

ssl-noencryption-option = Joks

account-setup-auth-label = Tapatumo tikrinimo metodas:

account-setup-username-label = Naudotojo vardas:

account-setup-advanced-setup-button = Sudėtingesnis derinimas
    .accesskey = S

## Warning insecure server dialog

account-setup-insecure-title = Dėmesio!

account-setup-insecure-server-checkbox = Aš suprantu pavojus
    .accesskey = s

## Warning Exchange confirmation dialog

exchange-dialog-cancel-button = Atšaukti

## Dismiss account creation dialog

## Alert dialogs

account-setup-creation-error-title = Klaida kuriant paskyrą

account-setup-error-server-exists = Toks laiškų gavimo serveris jau yra.

account-setup-confirm-advanced-description = Šis dialogo langas bus užvertas ir paskyra bus sukurta naudojant esamus parametrus, net jei jie neteisingi. Ar tikrai norite tęsti?

## Addon installation section

account-setup-addon-install-title = Įdiegti

## Success view

## Calendar synchronization dialog

