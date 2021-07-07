# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

account-setup-tab-title = Vytvoření účtu

## Header

account-setup-title = Nastavit existující e-mailový účet

account-setup-description =
    Pro použití existující e-mailové adresy vyplňte své přihlašovací údaje.<br/>
    { -brand-product-name } se pokusí automaticky najít funkční a doporučené nastavení serveru.

account-setup-secondary-description = { -brand-product-name } automaticky vyhledá funkční a doporučenou konfiguraci serveru.

account-setup-success-title = Účet byl úspěšně vytvořen

account-setup-success-description =
    Nyní můžete tento účet používat používat v { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "loc") }
        [feminine] { -brand-short-name(case: "loc") }
        [neuter] { -brand-short-name(case: "loc") }
       *[other] aplikaci { -brand-short-name }
    }.

account-setup-success-secondary-description = Připojení souvisejících služeb a konfigurace pokročilého nastavení účtu vám může usnadnit další práci.

## Form fields

account-setup-name-label = Vaše celé jméno
    .accesskey = n

# Note: "John Doe" is a multiple-use name that is used when the true name of a person is unknown. We use this fake name as an input placeholder. Translators should update this to reflect the placeholder name of their language/country.
account-setup-name-input =
    .placeholder = Jan Novák

account-setup-name-info-icon =
    .title = Vaše jméno tak, jak se bude zobrazovat ostatním


account-setup-name-warning-icon =
    .title = Zadejte prosím své jméno

account-setup-email-label = E-mailová adresa
    .accesskey = E

account-setup-email-input =
    .placeholder = vase-adresa@example.com

account-setup-email-info-icon =
    .title = Vaše stávající e-mailová adresa

account-setup-email-warning-icon =
    .title = Neplatná e-mailová adresa

account-setup-password-label = Heslo
    .accesskey = H
    .title = Potřeba pouze pro ověření vašeho uživatelského jména

account-provisioner-button = Získat novou e-mailovou adresu
    .accesskey = Z

account-setup-password-toggle =
    .title = Zobrazit/Skrýt heslo

account-setup-password-toggle-show =
    .title = Zobrazit heslo viditelně

account-setup-password-toggle-hide =
    .title = Skrýt heslo

account-setup-remember-password = Pamatovat si heslo
    .accesskey = m

account-setup-exchange-label = Vaše přihlašovací jméno
    .accesskey = l

#   YOURDOMAIN refers to the Windows domain in ActiveDirectory. yourusername refers to the user's account name in Windows.
account-setup-exchange-input =
    .placeholder = VAŠEDOMÉNA\vašeuživatelskéjméno

#   Domain refers to the Windows domain in ActiveDirectory. We mean the user's login in Windows at the local corporate network.
account-setup-exchange-info-icon =
    .title = Přihlášení k doméně

## Action buttons

account-setup-button-cancel = Zrušit
    .accesskey = Z

account-setup-button-manual-config = Nastavit ručně
    .accesskey = r

account-setup-button-stop = Zastavit
    .accesskey = s

account-setup-button-retest = Znovu otestovat
    .accesskey = t

account-setup-button-continue = Pokračovat
    .accesskey = o

account-setup-button-done = Hotovo
    .accesskey = H

## Notifications

account-setup-looking-up-settings = Vyhledávání nastavení…

account-setup-looking-up-settings-guess = Vyhledávání nastavení testováním obvyklých názvů serverů…

account-setup-looking-up-settings-half-manual = Vyhledávání konfigurace testováním serverů…

account-setup-looking-up-disk =
    Vyhledávání nastavení v adresářích { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "gen") }
        [feminine] { -brand-short-name(case: "gen") }
        [neuter] { -brand-short-name(case: "gen") }
       *[other] aplikace { -brand-short-name }
    }

account-setup-looking-up-isp = Vyhledávání nastavení u poskytovatele e-mailu…

# Note: Do not translate or replace Waterfox. It stands for the public project mozilla.org, not Waterfox Corporation. The database is a generic, public domain facility usable by any client.
account-setup-looking-up-db = Vyhledávání nastavení v databázi Mozilly…

account-setup-looking-up-mx = Vyhledávání nastavení: Doména příchozí pošty…

account-setup-looking-up-exchange = Vyhledávání nastavení: Server Exchange…

account-setup-checking-password = Probíhá kontrola hesla…

account-setup-installing-addon = Stahování a instalace doplňku…

account-setup-success-half-manual = Testováním serverů bylo nalezeno následující nastavení:

account-setup-success-guess = Testováním obvyklých názvů serverů bylo nalezeno následující nastavení:

account-setup-success-guess-offline = Jste v režimu offline. Nastavení bylo odhadnuto, je ale nutné ho správně doplnit.

account-setup-success-password = Heslo je v pořádku

account-setup-success-addon = Doplněk byl úspěšně nainstalován

# Note: Do not translate or replace Waterfox. It stands for the public project mozilla.org, not Waterfox Corporation. The database is a generic, public domain facility usable by any client.
account-setup-success-settings-db = V databázi Mozilly bylo nalezeno následující nastavení.

account-setup-success-settings-disk =
    V adresářích Vyhledávání nastavení v adresářích { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "gen") }
        [feminine] { -brand-short-name(case: "gen") }
        [neuter] { -brand-short-name(case: "gen") }
       *[other] aplikace { -brand-short-name }
    } bylo nalezeno následující nastavení.

account-setup-success-settings-isp = U poskytovatele e-mailu bylo nalezeno následující nastavení.

# Note: Microsoft Exchange is a product name.
account-setup-success-settings-exchange = Nastavení pro server Microsoft Exchange nalezeno.

## Illustrations

account-setup-step1-image =
    .title = Úvodní nastavení

account-setup-step2-image =
    .title = Načítání…

account-setup-step3-image =
    .title = Konfigurace nalezena

account-setup-step4-image =
    .title = Chyba spojení

account-setup-step5-image =
    .title = Účet vytvořen

account-setup-privacy-footnote2 = Vaše přihlašovací údaje budou uloženy jen ve vašem počítači.

account-setup-selection-help = Nevíte, co vybrat?

account-setup-selection-error = Potřebujete pomoci?

account-setup-success-help = Nevíte, co dál?

account-setup-documentation-help = Dokumentace k nastavení

account-setup-forum-help = Fórum podpory

account-setup-privacy-help = Zásady ochrany osobních údajů

account-setup-getting-started = Začínáme

## Results area

# Variables:
#  $count (Number) - Number of available protocols.
account-setup-results-area-title =
    { $count ->
        [one] Dostupné nastavení
        [few] Dostupná nastavení
       *[other] Dostupná nastavení
    }

# Note: IMAP is the name of a protocol.
account-setup-result-imap = IMAP

account-setup-result-imap-description = Udržuje vaše složky a e-maily synchronizované na vašem serveru

# Note: POP3 is the name of a protocol.
account-setup-result-pop = POP3

account-setup-result-pop-description = Uchová vaše složky a e-maily na vašem počítači

# Note: Exchange is the name of a product.
account-setup-result-exchange = Exchange

# Note: Exchange, Office365 are the name of products.
account-setup-result-exchange2-description = Použije server Microsoft Exchange nebo cloudové služby Office365

account-setup-incoming-title = Příchozí

account-setup-outgoing-title = Odchozí

account-setup-username-title = Uživatelské jméno

account-setup-exchange-title = Server

account-setup-result-smtp = SMTP

account-setup-result-no-encryption = Bez šifrování

account-setup-result-ssl = SSL/TLS

account-setup-result-starttls = STARTTLS

account-setup-result-outgoing-existing = Použít pro odchozí poštu existující server SMTP

# Variables:
#  $incoming (String): The email/username used to log into the incoming server
#  $outgoing (String): The email/username used to log into the outgoing server
account-setup-result-username-different = Příchozí: { $incoming }, Odchozí: { $outgoing }

## Error messages

# Note: The reference to "janedoe" (Jane Doe) is the name of an example person. You will want to translate it to whatever example persons would be named in your language. In the example, AD is the name of the Windows domain, and this should usually not be translated.
account-setup-credentials-incomplete = Ověření se nezdařilo. Buď nejsou zadané přihlašovací údaje správné, nebo je pro přihlášení vyžadováno samostatné uživatelské jméno. Takovým uživatelským jménem je obvykle vaše přihlašovací jméno k doméně systému Windows s doménou nebo bez ní (například jannovak nebo AD\\jannovak).

account-setup-credentials-wrong = Ověření se nezdařilo. Zkontrolujte prosím uživatelské jméno a heslo.

account-setup-find-settings-failed =
    { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "dat") }
        [feminine] { -brand-short-name(case: "dat") }
        [neuter] { -brand-short-name(case: "dat") }
       *[other] Aplikaci { -brand-short-name }
    } se nepodařilo najít nastavení vašeho e-mailového účtu

account-setup-exchange-config-unverifiable = Konfiguraci nelze ověřit. Pokud jsou vaše uživatelské jméno a heslo správně, je pravděpodobné, že správce serveru zvolenou konfiguraci vašeho účtu zakázal. Zkuste vybrat jiný protokol.

## Manual configuration area

account-setup-manual-config-title = Ruční nastavení

account-setup-incoming-server-legend = Server příchozí pošty

account-setup-protocol-label = Protokol:

protocol-imap-option = { account-setup-result-imap }

protocol-pop-option = { account-setup-result-pop }

protocol-exchange-option = { account-setup-result-exchange }

account-setup-hostname-label = Server:

account-setup-port-label = Port:
    .title = Pro automatické nalezení nastavte port na 0.

account-setup-auto-description = { -brand-short-name } se pokusí automaticky doplnit pole, která jste nevyplnili.

account-setup-ssl-label = Zabezpečení spojení:

account-setup-outgoing-server-legend = Server odchozí pošty

## Incoming/Outgoing SSL Authentication options

ssl-autodetect-option = Rozpoznat automaticky

ssl-no-authentication-option = Bez ověření

ssl-cleartext-password-option = Heslo, zabezpečený přenos

ssl-encrypted-password-option = Šifrované heslo

## Incoming/Outgoing SSL options

ssl-noencryption-option = Žádné

account-setup-auth-label = Způsob ověření:

account-setup-username-label = Uživatelské jméno:

account-setup-advanced-setup-button = Rozšířené nastavení
    .accesskey = a

## Warning insecure server dialog

account-setup-insecure-title = Upozornění!

account-setup-insecure-incoming-title = Nastavení příchozí pošty:

account-setup-insecure-outgoing-title = Nastavené odchozí pošty:

# Variables:
#  $server (String): The name of the hostname of the server the user was trying to connect to.
account-setup-warning-cleartext = <b>{ $server }</b> nepoužívá žádné šifrování.

account-setup-warning-cleartext-details = Nezabezpečený server nechrání vaše heslo ani osobních informace pomocí šifrovaného spojení. Připojením k tomuto serveru můžete ohrozit své heslo a osobní informace.

account-setup-insecure-server-checkbox = Uvědomuji si rizika
    .accesskey = U

account-setup-insecure-description = { -brand-short-name } vám umožní pracovat s poštou dle zadaného nastavení, ale je vhodné kontaktovat správce nebo poskytovatele vaší e-mailové schránky ohledně řádného připojení. Pro více informací si přečtěte <a data-l10n-name="thunderbird-faq-link">často kladené dotazy k Thunderbirdu</a>.

insecure-dialog-cancel-button = Změnit nastavení
    .accesskey = s

insecure-dialog-confirm-button = Potvrdit
    .accesskey = P

## Warning Exchange confirmation dialog

# Variables:
#  $domain (String): The name of the server where the configuration was found, e.g. rackspace.com.
exchange-dialog-question =
    { -brand-short-name.gender ->
        [masculine] { -brand-short-name } našel
        [feminine] { -brand-short-name } našla
        [neuter] { -brand-short-name } našlo
       *[other] Aplikace { -brand-short-name } našla
    } informace pro nastavení vašeho účtu v na doméně { $domain }. Chcete pokračovat a odeslat své přihlašovací údaje?

exchange-dialog-confirm-button = Přihlašovací údaje

exchange-dialog-cancel-button = Zrušit

## Dismiss account creation dialog

exit-dialog-title = Není nastaven žádný e-mailový účet

exit-dialog-description =
    Opravdu chcete zrušit proces nastavení? { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "acc") }
        [feminine] { -brand-short-name(case: "acc") }
        [neuter] { -brand-short-name(case: "acc") }
       *[other] Aplikaci { -brand-short-name }
    } můžete používat i bez e-mailového účtu, ale mnoho funkcí pak nebude dostupných.

account-setup-no-account-checkbox =
    Používat { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "acc") }
        [feminine] { -brand-short-name(case: "acc") }
        [neuter] { -brand-short-name(case: "acc") }
       *[other] aplikaci { -brand-short-name }
    } bez e-mailového účtu
    .accesskey = u

exit-dialog-cancel-button = Pokračovat v nastavení
    .accesskey = P

exit-dialog-confirm-button = Zrušit nastavení
    .accesskey = Z

## Alert dialogs

account-setup-creation-error-title = Účet se nepodařilo vytvořit

account-setup-error-server-exists = Server příchozí pošty už existuje.

account-setup-confirm-advanced-title = Potvrzení rozšířeného nastavení

account-setup-confirm-advanced-description = Toto dialogové okno bude zavřeno a bude vytvořen účet s aktuálním nastavením, i když je konfigurace nesprávná. Chcete pokračovat?

## Addon installation section

account-setup-addon-install-title = Nainstalovat

account-setup-addon-install-intro = Doplněk třetí strany vám může umožnit přístup k poštovnímu účtu na tomto serveru:

account-setup-addon-no-protocol = Tento e-mailový server bohužel nepodporuje otevřené protokoly. { account-setup-addon-install-intro }

## Success view

account-setup-settings-button = Nastavení účtu

account-setup-encryption-button = Koncové šifrování

account-setup-signature-button = Přidat podpis

account-setup-dictionaries-button = Stáhnout slovníky

account-setup-address-book-carddav-button = Připojit adresář CardDAV

account-setup-address-book-ldap-button = Připojit adresář LDAP

account-setup-calendar-button = Připojit vzdálený kalendář

account-setup-linked-services-title = Připojení propojených služeb

account-setup-linked-services-description =
    { -brand-short-name.gender ->
        [masculine] { -brand-short-name } zjistil
        [feminine] { -brand-short-name } zjistila
        [neuter] { -brand-short-name } zjistilo
       *[other] Aplikace { -brand-short-name } zjistila
    } další služby propojené s vaším e-mailovým účtem.

account-setup-no-linked-description =
    Nastavte si další služby, abyste { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "acc") }
        [feminine] { -brand-short-name(case: "acc") }
        [neuter] { -brand-short-name(case: "acc") }
       *[other] aplikaci { -brand-short-name }
    } využili na maximum.

# Variables:
# $count (Number) - The number of address books found during autoconfig.
account-setup-found-address-books-description =
    { -brand-short-name.gender ->
        [masculine] { -brand-short-name } našel
        [feminine] { -brand-short-name } našla
        [neuter] { -brand-short-name } našlo
       *[other] Aplikace { -brand-short-name } našla
    } { $count ->
        [one] jeden adresář propojený s vaším e-mailovým účtem.
        [few] { $count } adresáře propojené s vaším e-mailovým účtem.
       *[other] { $count } adresářů propojených s vaším e-mailovým účtem.
    }

# Variables:
# $count (Number) - The number of calendars found during autoconfig.
account-setup-found-calendars-description =
    { -brand-short-name.gender ->
        [masculine] { -brand-short-name } našel
        [feminine] { -brand-short-name } našla
        [neuter] { -brand-short-name } našlo
       *[other] Aplikace { -brand-short-name } našla
    } { $count ->
        [one] jeden kalendář propojený s vaším e-mailovým účtem.
        [few] { $count } kalendáře propojené s vaším e-mailovým účtem.
       *[other] { $count } kalendářů propojených s vaším e-mailovým účtem.
    }

account-setup-button-finish = Dokončit
    .accesskey = D

account-setup-looking-up-address-books = Vyhledávání adresářů…

account-setup-looking-up-calendars = Vyhledávání kalendářů…

account-setup-address-books-button = Adresáře

account-setup-calendars-button = Kalendáře

account-setup-connect-link = Připojit

account-setup-existing-address-book = Připojeno
    .title = Adresář je už připojen

account-setup-existing-calendar = Připojeno
    .title = Kalendář je už připojen

account-setup-connect-all-calendars = Připojit všechny kalendáře

account-setup-connect-all-address-books = Připojit všechny adresáře

## Calendar synchronization dialog

calendar-dialog-title = Připojení kalendáře

calendar-dialog-cancel-button = Zrušit
    .accesskey = Z

calendar-dialog-confirm-button = Připojit
    .accesskey = P

account-setup-calendar-name-label = Název

account-setup-calendar-name-input =
    .placeholder = Můj kalendář

account-setup-calendar-color-label = Barva

account-setup-calendar-refresh-label = Obnovit

account-setup-calendar-refresh-manual = Ručně

account-setup-calendar-refresh-interval =
    { $count ->
        [one] Jednou za minutu
        [few] Každé { $count } minuty
       *[other] Každých { $count } minut
    }

account-setup-calendar-read-only = Pouze pro čtení
    .accesskey = r

account-setup-calendar-show-reminders = Zobrazovat upozornění
    .accesskey = Z

account-setup-calendar-offline-support = Podpora režimu offline
    .accesskey = o
