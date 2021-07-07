# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

close-button =
    .aria-label = Zavřít
preferences-title =
    .title =
        { PLATFORM() ->
            [windows] Možnosti
           *[other] Předvolby
        }
preferences-tab-title =
    .title = Předvolby
preferences-doc-title = Předvolby
category-list =
    .aria-label = Kategorie
pane-general-title = Obecné
category-general =
    .tooltiptext = { pane-general-title }
pane-compose-title = Vytváření
category-compose =
    .tooltiptext = Vytváření
pane-privacy-title = Soukromí a zabezpečení
category-privacy =
    .tooltiptext = Soukromí a zabezpečení
pane-chat-title = Chat
category-chat =
    .tooltiptext = Chat
pane-calendar-title = Kalendář
category-calendar =
    .tooltiptext = Kalendář
general-language-and-appearance-header = Zobrazení a jazyk stránek
general-incoming-mail-header = Příchozí pošta
general-files-and-attachment-header = Soubory a přílohy
general-tags-header = Štítky
general-reading-and-display-header = Čtení a zobrazení
general-updates-header = Aktualizace
general-network-and-diskspace-header = Síť a místo na disku
general-indexing-label = indexování
composition-category-header = Vytváření zpráv
composition-attachments-header = Přílohy
composition-spelling-title = Pravopis
compose-html-style-title = Styl HTML
composition-addressing-header = Adresování
privacy-main-header = Soukromí
privacy-passwords-header = Hesla
privacy-junk-header = Nevyžádaná
collection-header =
    Sběr a používání dat o { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "loc") }
        [feminine] { -brand-short-name(case: "loc") }
        [neuter] { -brand-short-name(case: "loc") }
       *[other] aplikaci { -brand-short-name }
    }
collection-description = S daty vám dáváme vždy na výběr a sbíráme jen data potřebná pro vylepšování aplikace { -brand-short-name }. Před odesíláním osobních dat vždy žádáme o váš souhlas.
collection-privacy-notice = Zásady ochrany osobních údajů
collection-health-report-telemetry-disabled =
    Odesílat { -vendor-short-name.gender ->
        [masculine] { -vendor-short-name(case: "dat") }
        [feminine] { -vendor-short-name(case: "dat") }
        [neuter] { -vendor-short-name(case: "dat") }
       *[other] společnosti { -vendor-short-name }
    } technická data a data o interakcích není nadále povoleno. Všechna historická data budou smazána během 30 dnů.
collection-health-report-telemetry-disabled-link = Zjistit více
collection-health-report =
    .label =
        { -vendor-short-name.gender ->
            [masculine] Odesílat { -vendor-short-name(case: "dat") }
            [feminine] Odesílat { -vendor-short-name(case: "dat") }
            [neuter] Odesílat { -vendor-short-name(case: "dat") }
           *[other] Odesílat
        } technická data a data o interakcích
    .accesskey = r
collection-health-report-link = Zjistit více
# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = Odesílání dat je zakázáno konfigurací tohoto sestavení
collection-backlogged-crash-reports =
    .label =
        Odesílat nevyřízená hlášení o pádech { -brand-short-name.gender ->
            [masculine] { -brand-short-name(case: "gen") }
            [feminine] { -brand-short-name(case: "gen") }
            [neuter] { -brand-short-name(case: "gen") }
           *[other] aplikace
        } za vás
    .accesskey = c
collection-backlogged-crash-reports-link = Zjistit více
privacy-security-header = Zabezpečení
privacy-scam-detection-title = Detekce podvodů
privacy-anti-virus-title = Antivir
privacy-certificates-title = Certifikáty
chat-pane-header = Chat
chat-status-title = Stav
chat-notifications-title = Oznámení
chat-pane-styling-header = Stylování
choose-messenger-language-description = Vyberte požadovaný jazyk uživatelského rozhraní { -brand-short-name(case: "gen") }.
manage-messenger-languages-button =
    .label = Vybrat alternativy…
    .accesskey = l
confirm-messenger-language-change-description = Aby se změny projevily, restartujte { -brand-short-name(case: "acc") }
confirm-messenger-language-change-button = Potvrdit a restartovat
update-setting-write-failure-title = Chyba při ukládání nastavení aktualizací
# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    { -brand-short-name.gender ->
        [masculine] { -brand-short-name } zaznamenal
        [feminine] { -brand-short-name } zanamenala
        [neuter] { -brand-short-name } zaznamenalo
       *[other] Aplikace { -brand-short-name } zaznamenala
    } problém při ukládání změny nastavení. Změna těchto nastavení vyžaduje oprávnění k zápisu do níže uvedeného souboru. Vy nebo správce vašeho systému můžete tento problém vyřešit přidělením úplných oprávnění k tomuto souboru pro skupinu Users.
    
    Není možný zápis do souboru: { $path }
update-in-progress-title = Probíhá aktualizace
update-in-progress-message =
    { -brand-short-name.gender ->
        [masculine] Chcete, aby { -brand-short-name } pokračoval v aktualizaci?
        [feminine] Chcete, aby { -brand-short-name } pokračovala v aktualizaci?
        [neuter] Chcete, aby { -brand-short-name } pokračovalo v aktualizaci?
       *[other] Chcete, aby aplikace { -brand-short-name } pokračovala v aktualizaci?
    }
update-in-progress-ok-button = &Nepokračovat
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Pokračovat
addons-button = Rozšíření a vzhledy
account-button = Nastavení účtu
open-addons-sidebar-button = Doplňky a vzhledy

## OS Authentication dialog

# This message can be seen by trying to add a Master Password.
master-password-os-auth-dialog-message-win = Pro nastavení hlavního hesla prosím zadejte své přihlašovací údaje k systému Windows. Toto opatření pomáhá v zabezpečení vašich účtů.
# This message can be seen by trying to add a Master Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
master-password-os-auth-dialog-message-macosx = vytvořit hlavní heslo
# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Pro nastavení hlavního hesla prosím zadejte své přihlašovací údaje k systému Windows. Toto opatření pomáhá v zabezpečení vašich účtů.
# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = vytvořit hlavní heslo
# Don't change this label.
master-password-os-auth-dialog-caption = { -brand-full-name }

## General Tab

focus-search-shortcut =
    .key = f
focus-search-shortcut-alt =
    .key = k
general-legend =
    Úvodní stránka { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "gen") }
        [feminine] { -brand-short-name(case: "gen") }
        [neuter] { -brand-short-name(case: "gen") }
       *[other] aplikace { -brand-short-name }
    }
start-page-label =
    .label =
        Při spuštění { -brand-short-name.gender ->
            [masculine] { -brand-short-name(case: "gen") }
            [feminine] { -brand-short-name(case: "gen") }
            [neuter] { -brand-short-name(case: "gen") }
           *[other] aplikace { -brand-short-name }
        } zobrazit úvodní stránku
    .accesskey = s
location-label =
    .value = Adresa:
    .accesskey = A
restore-default-label =
    .label = Obnovit výchozí
    .accesskey = O
default-search-engine = Výchozí vyhledávač
add-search-engine =
    .label = Přidat ze souboru
    .accesskey = s
remove-search-engine =
    .label = Odebrat
    .accesskey = r
minimize-to-tray-label =
    .label =
        Při minimalizaci { -brand-short-name.gender ->
            [masculine] { -brand-short-name(case: "gen") } ho
            [feminine] { -brand-short-name(case: "gen") } ji
            [neuter] { -brand-short-name(case: "gen") } ho
           *[other] aplikace jo
        } přesunout do oznamovací oblasti
    .accesskey = o
new-message-arrival = Při přijetí nové zprávy:
mail-play-sound-label =
    .label =
        { PLATFORM() ->
            [macos] Přehrát zvukový soubor:
           *[other] Přehrát zvuk
        }
    .accesskey =
        { PLATFORM() ->
            [macos] v
           *[other] v
        }
mail-play-button =
    .label = Přehrát
    .accesskey = h
change-dock-icon = Změna nastavení pro ikonu aplikace
app-icon-options =
    .label = Nastavení ikony aplikace…
    .accesskey = n
notification-settings = Upozornění a výchozí zvuk můžete zakázat v systémovém nastavení panelu upozornění.
animated-alert-label =
    .label = Zobrazit upozornění
    .accesskey = Z
customize-alert-label =
    .label = Přizpůsobit…
    .accesskey = b
tray-icon-label =
    .label = Zobrazit ikonu v oznamovací oblasti
    .accesskey = t
biff-use-system-alert =
    .label = Použít systémová oznámení
tray-icon-unread-label =
    .label = Zobrazit pro nepřečtené zprávy ikonu na liště
    .accesskey = t
tray-icon-unread-description = Doporučeno, pokud máte na hlavním panelu jen malá tlačítka
mail-system-sound-label =
    .label = Zvuk nové pošty v systému
    .accesskey = u
mail-custom-sound-label =
    .label = Vlastní zvukový soubor
    .accesskey = V
mail-browse-sound-button =
    .label = Procházet…
    .accesskey = c
enable-gloda-search-label =
    .label = Povolit globální hledání a indexaci
    .accesskey = g
datetime-formatting-legend = Formátování data a času
language-selector-legend = Jazyk
allow-hw-accel =
    .label = Použít hardwarovou akceleraci, je-li dostupná
    .accesskey = h
store-type-label =
    .value = Typ úložiště zpráv pro nové účty:
    .accesskey = T
mbox-store-label =
    .label = Soubor pro každou složku (mbox)
maildir-store-label =
    .label = Soubor pro každou zprávu (maildir)
scrolling-legend = Posunování
autoscroll-label =
    .label = Použít automatické posouvání
    .accesskey = a
smooth-scrolling-label =
    .label = Použít plynulé posouvání
    .accesskey = l
system-integration-legend = Nastavení systému
always-check-default =
    .label =
        Při startu { -brand-short-name.gender ->
            [masculine] { -brand-short-name(case: "gen") }
            [feminine] { -brand-short-name(case: "gen") }
            [neuter] { -brand-short-name(case: "gen") }
           *[other] aplikace { -brand-short-name }
        } kontrolovat, zda je výchozím poštovním klientem
    .accesskey = s
check-default-button =
    .label = Zkontrolovat…
    .accesskey = Z
# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windows Search
       *[other] { "" }
    }
search-integration-label =
    .label = Povolit službě { search-engine-name } prohledávat zprávy
    .accesskey = v
config-editor-button =
    .label = Editor předvoleb…
    .accesskey = i
return-receipts-description = Určuje, jak { -brand-short-name } zachází s potvrzením o přečtení
return-receipts-button =
    .label = Potvrzení o přečtení…
    .accesskey = P
update-app-legend =
    Aktualizace { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "gen") }
        [feminine] { -brand-short-name(case: "gen") }
        [neuter] { -brand-short-name(case: "gen") }
       *[other] aplikace { -brand-short-name }
    }
# Variables:
#   $version (String): version of Thunderbird, e.g. 68.0.1
update-app-version = Verze { $version }
allow-description =
    Povolit { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "dat") }
        [feminine] { -brand-short-name(case: "dat") }
        [neuter] { -brand-short-name(case: "dat") }
       *[other] aplikaci { -brand-short-name }
    }
automatic-updates-label =
    .label = Instalovat aktualizace automaticky (doporučováno z důvodu vyšší bezpečnosti)
    .accesskey = A
check-updates-label =
    .label = Vyhledávat aktualizace, ale zeptat se, zda mají být nainstalovány
    .accesskey = C
update-history-button =
    .label = Zobrazit historii aktualizací
    .accesskey = b
use-service =
    .label = K instalaci aktualizací použít službu na pozadí
    .accesskey = s
cross-user-udpate-warning =
    Toto nastavení se uplatní pro všechny účty systému Windows a profily { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "gen") }
        [feminine] { -brand-short-name(case: "gen") }
        [neuter] { -brand-short-name(case: "gen") }
       *[other] aplikace { -brand-short-name }
    } používající tuto instalaci { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "gen") }
        [feminine] { -brand-short-name(case: "gen") }
        [neuter] { -brand-short-name(case: "gen") }
       *[other] aplikace { -brand-short-name }
    }.
networking-legend = Připojení
proxy-config-description =
    Konfigurovat připojení { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "gen") }
        [feminine] { -brand-short-name(case: "gen") }
        [neuter] { -brand-short-name(case: "gen") }
       *[other] aplikace { -brand-short-name }
    } k internetu.
network-settings-button =
    .label = Nastavení…
    .accesskey = a
offline-legend = Režim offline
offline-settings = Konfigurovat režim offline
offline-settings-button =
    .label = Režim offline…
    .accesskey = o
diskspace-legend = Místo na disku
offline-compact-folder =
    .label = Provést údržbu složek, ušetří-li se celkově přes
    .accesskey = k
compact-folder-size =
    .value = MB

## Note: The entities use-cache-before and use-cache-after appear on a single
## line in preferences as follows:
## use-cache-before [ textbox for cache size in MB ] use-cache-after

use-cache-before =
    .value = Použít maximálně
    .accesskey = P
use-cache-after = MB diskové mezipaměti

##

smart-cache-label =
    .label = Nepoužívat automatickou správu mezipaměti
    .accesskey = e
clear-cache-button =
    .label = Vymazat
    .accesskey = m
fonts-legend = Písma a barvy
default-font-label =
    .value = Výchozí písmo:
    .accesskey = p
default-size-label =
    .value = Velikost:
    .accesskey = e
font-options-button =
    .label = Rozšířené…
    .accesskey = o
color-options-button =
    .label = Barvy…
    .accesskey = B
display-width-legend = Zobrazení prostých textových zpráv a článků
# Note : convert-emoticons-label 'Emoticons' are also known as 'Smileys', e.g. :-)
convert-emoticons-label =
    .label = Zobrazit smajlíky jako ikony
    .accesskey = Z
display-text-label = Použít následující nastavení pro zobrazení citovaných zpráv v čistém textu:
style-label =
    .value = Styl:
    .accesskey = S
regular-style-item =
    .label = Normální
bold-style-item =
    .label = Tučné
italic-style-item =
    .label = Kurzíva
bold-italic-style-item =
    .label = Tučná kurzíva
size-label =
    .value = Velikost:
    .accesskey = V
regular-size-item =
    .label = Normální
bigger-size-item =
    .label = Větší
smaller-size-item =
    .label = Menší
quoted-text-color =
    .label = Barva:
    .accesskey = a
search-input =
    .placeholder = Hledat
search-handler-table =
    .placeholder = Filtrovat typy obsahu a akcí
type-column-label =
    .label = Typ obsahu
    .accesskey = T
action-column-label =
    .label = Akce
    .accesskey = A
save-to-label =
    .label = Ukládat všechny soubory do složky
    .accesskey = U
choose-folder-label =
    .label =
        { PLATFORM() ->
            [macos] Vybrat…
           *[other] Procházet…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] V
           *[other] r
        }
always-ask-label =
    .label = U každého souboru se zeptat, kam ho uložit
    .accesskey = k
display-tags-text = Štítky lze použít pro rozřazení zpráv dle kategorií a priorit.
new-tag-button =
    .label = Nový…
    .accesskey = N
edit-tag-button =
    .label = Upravit…
    .accesskey = U
delete-tag-button =
    .label = Smazat
    .accesskey = S
auto-mark-as-read =
    .label = Automaticky označit zprávu jako přečtenou
    .accesskey = A
mark-read-no-delay =
    .label = Okamžitě po zobrazení
    .accesskey = O

## Note: This will concatenate to "After displaying for [___] seconds",
## using (mark-read-delay) and a number (seconds-label).

mark-read-delay =
    .label = Až po
    .accesskey = p
seconds-label = sekundách od zobrazení

##

open-msg-label =
    .value = Otevírat zprávy v:
open-msg-tab =
    .label = Novém panelu
    .accesskey = p
open-msg-window =
    .label = Novém okně
    .accesskey = N
open-msg-ex-window =
    .label = Existujícím okně se zprávou
    .accesskey = x
close-move-delete =
    .label = Při přesunutí nebo smazání zprávy zavřít panel/okno
    .accesskey = s
display-name-label =
    .value = Zobrazované jméno:
condensed-addresses-label =
    .label = U lidí z mých kontaktů zobrazovat pouze jméno
    .accesskey = U

## Compose Tab

forward-label =
    .value = Přeposílat zprávy:
    .accesskey = s
inline-label =
    .label = Vložené
as-attachment-label =
    .label = Jako přílohu
extension-label =
    .label = Přidat k názvu souboru příponu
    .accesskey = d

## Note: This will concatenate to "Auto Save every [___] minutes",
## using (auto-save-label) and a number (auto-save-end).

auto-save-label =
    .label = Automaticky ukládat každých
    .accesskey = A
auto-save-end = minut

##

warn-on-send-accel-key =
    .label = Při odeslání zprávy pomocí klávesové zkratky požadovat potvrzení
    .accesskey = i
spellcheck-label =
    .label = Před odesláním zprávy zkontrolovat pravopis
    .accesskey = P
spellcheck-inline-label =
    .label = Kontrolovat pravopis při psaní
    .accesskey = K
language-popup-label =
    .value = Jazyk:
    .accesskey = J
download-dictionaries-link = Stáhnout další slovníky
font-label =
    .value = Písmo:
    .accesskey = m
font-size-label =
    .value = Velikost:
    .accesskey = s
default-colors-label =
    .label = Použít výchozí barvy čtečky
    .accesskey = v
font-color-label =
    .value = Text:
    .accesskey = T
bg-color-label =
    .value = Barva pozadí:
    .accesskey = P
restore-html-label =
    .label = Obnovit výchozí
    .accesskey = O
default-format-label =
    .label = Ve výchozím nastavení používat formát odstavce namísto základního textu
    .accesskey = D
format-description = Nastavení chování textového formátu
send-options-label =
    .label = Předvolby odesílání…
    .accesskey = e
autocomplete-description = Při psaní adresy hledat vhodné položky v:
ab-label =
    .label = Místní kontakty
    .accesskey = M
directories-label =
    .label = Adresářový server:
    .accesskey = s
directories-none-label =
    .none = Žádný
edit-directories-label =
    .label = Upravit adresáře…
    .accesskey = U
email-picker-label =
    .label = Automaticky přidat odchozí e-mailovou adresu do složky:
    .accesskey = A
default-directory-label =
    .value = Výchozí počáteční složka v okně kontaktů:
    .accesskey = c
default-last-label =
    .none = Poslední používaná složka
attachment-label =
    .label = Kontrolovat zapomenuté přílohy
    .accesskey = n
attachment-options-label =
    .label = Klíčová slova…
    .accesskey = K
enable-cloud-share =
    .label = Nabízet nahrávání na úložiště pro soubory větší než
cloud-share-size =
    .value = MB
add-cloud-account =
    .label = Přidat…
    .accesskey = a
    .defaultlabel = Přidat…
remove-cloud-account =
    .label = Odebrat
    .accesskey = d
find-cloud-providers =
    .value = Najít další poskytovatele…
cloud-account-description = Přidat nové webové úložiště pro odesílání příloh

## Privacy Tab

mail-content = Obsah e-mailu
remote-content-label =
    .label = Povolit vzdálený obsah ve zprávách
    .accesskey = P
exceptions-button =
    .label = Výjimky…
    .accesskey = m
remote-content-info =
    .value = Zjistit více o problémech se soukromím u vzdáleného obsahu
web-content = Webový obsah
history-label =
    .label = Pamatovat si navštívené stránky a adresy
    .accesskey = a
cookies-label =
    .label = Povolit serverům ukládat cookies
    .accesskey = c
third-party-label =
    .value = Povolit cookies třetích stran:
    .accesskey = i
third-party-always =
    .label = Vždy
third-party-never =
    .label = Nikdy
third-party-visited =
    .label = Pouze navštívené
keep-label =
    .value = Ponechat do:
    .accesskey = d
keep-expire =
    .label = konce doby platnosti
keep-close =
    .label =
        ukončení { -brand-short-name.gender ->
            [masculine] { -brand-short-name(case: "gen") }
            [feminine] { -brand-short-name(case: "gen") }
            [neuter] { -brand-short-name(case: "gen") }
           *[other] aplikace { -brand-short-name }
        }
keep-ask =
    .label = vždy se zeptat
cookies-button =
    .label = Správce cookies…
    .accesskey = S
do-not-track-label =
    .label = Říci webovým stránkám pomocí signálu Do Not Track, že nechcete být sledováni
    .accesskey = n
learn-button =
    .label = Zjistit více
passwords-description = { -brand-short-name } si může pamatovat vaše přihlašovací údaje pro jednotlivé účty, takže je nebudete muset znovu zadávat.
passwords-button =
    .label = Zobrazit hesla…
    .accesskey = h
master-password-description = Hlavní heslo, je-li nastaveno, chrání všechna vaše ostatní hesla. Jeho vložení je ale vyžadováno jednou během relace.
master-password-label =
    .label = Použít hlavní heslo
    .accesskey = P
master-password-button =
    .label = Změnit hlavní heslo…
    .accesskey = m
primary-password-description = Hlavní heslo, je-li nastaveno, chrání všechna vaše ostatní hesla. Jeho vložení je ale vyžadováno jednou během relace.
primary-password-label =
    .label = Použít hlavní heslo
    .accesskey = P
primary-password-button =
    .label = Změnit hlavní heslo…
    .accesskey = m
forms-primary-pw-fips-title = Momentálně jste v režimu FIPS, který vyžaduje neprázdné hlavní heslo.
forms-master-pw-fips-desc = Neúspěšná změna hesla
junk-description = Další nastavení nevyžádané pošty lze provést v dialogu Nastavení účtu.
junk-label =
    .label = Pokud ručně označím zprávy jako nevyžádané:
    .accesskey = r
junk-move-label =
    .label = Přesunout je do složky „Nevyžádaná“
    .accesskey = n
junk-delete-label =
    .label = Smazat
    .accesskey = S
junk-read-label =
    .label = Označit zprávy rozpoznané jako nevyžádaná pošta jako přečtené
    .accesskey = O
junk-log-label =
    .label = Povolit protokolování adaptivní nevyžádané pošty
    .accesskey = P
junk-log-button =
    .label = Zobrazit protokol
    .accesskey = Z
reset-junk-button =
    .label = Vymazat naučená pravidla
    .accesskey = V
phishing-description = { -brand-short-name } může analyzovat zprávy na podvodnou poštu pomocí odhalování technik používaných na vaše oklamání.
phishing-label =
    .label = Upozornit, pokud čtená zpráva je podezřelá na podvodnou poštu
    .accesskey = U
antivirus-description = { -brand-short-name } může antivirovým programům umožnit analyzování zpráv příchozí pošty na výskyt virů ještě dříve, než jsou tyto zprávy uloženy do složek pošty.
antivirus-label =
    .label = Povolit antivirovým klientům prohlížet jednotlivé příchozí zprávy
    .accesskey = P
certificate-description = Pokud server vyžaduje osobní certifikát:
certificate-auto =
    .label = Zvolit automaticky
    .accesskey = a
certificate-ask =
    .label = Vždy se zeptat
    .accesskey = d
ocsp-label =
    .label = Aktuální platnost certifikátů ověřovat na serverech OCSP
    .accesskey = p
certificate-button =
    .label = Spravovat certifikáty…
    .accesskey = c
security-devices-button =
    .label = Bezpečnostní zařízení…
    .accesskey = B

## Chat Tab

startup-label =
    .value =
        Při startu { -brand-short-name.gender ->
            [masculine] { -brand-short-name(case: "gen") }
            [feminine] { -brand-short-name(case: "gen") }
            [neuter] { -brand-short-name(case: "gen") }
           *[other] aplikace { -brand-short-name }
        }:
    .accesskey = s
offline-label =
    .label = Ponechat mé účty chatu offline
auto-connect-label =
    .label = Automaticky připojit mé účty chatu

## Note: idle-label is displayed first, then there's a field where the user
## can enter a number, and itemTime is displayed at the end of the line.
## The translations of the idle-label and idle-time-label parts don't have
## to mean the exact same thing as in English; please try instead to
## translate the whole sentence.

idle-label =
    .label = Zobrazit se mým kontaktům jako Nečinný po
    .accesskey = N
idle-time-label = minutách nečinnosti

##

away-message-label =
    .label = a nastavit stav Pryč s touto zprávou:
    .accesskey = r
send-typing-label =
    .label = Odesílat v konverzaci upozornění, že píši
    .accesskey = a
notification-label = Při přijetí zprávy určené mně:
show-notification-label =
    .label = Zobrazit upozornění
    .accesskey = Z
notification-all =
    .label = se jménem odesílatele a náhledem zprávy
notification-name =
    .label = pouze se jménem odesílatele
notification-empty =
    .label = bez dalších informací
notification-type-label =
    .label =
        { PLATFORM() ->
            [macos] Animovat ikonku v doku
           *[other] Blikat v hlavním panelu
        }
    .accesskey =
        { PLATFORM() ->
            [macos] o
           *[other] F
        }
chat-play-sound-label =
    .label = Přehrát zvuk
    .accesskey = P
chat-play-button =
    .label = Přehrát
    .accesskey = h
chat-system-sound-label =
    .label = Zvuk nové pošty v systému
    .accesskey = u
chat-custom-sound-label =
    .label = Vlastní zvukový soubor
    .accesskey = V
chat-browse-sound-button =
    .label = Procházet…
    .accesskey = c
theme-label =
    .value = Motiv vzhledu:
    .accesskey = t
style-thunderbird =
    .label = Thunderbird
style-bubbles =
    .label = Bubliny
style-dark =
    .label = Tmavý
style-paper =
    .label = Papírové listy
style-simple =
    .label = Jednoduchý
preview-label = Náhled:
no-preview-label = Náhled není k dispozici
no-preview-description = Tento motiv vzhledu není platný, nebo je momentálně nedostupný (zakázaný doplněk, nouzový režim, …).
chat-variant-label =
    .value = Varianta:
    .accesskey = V
chat-header-label =
    .label = Zobrazit hlavičku
    .accesskey = h
# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-input-box =
    .style = width: 15.4em
    .placeholder =
        { PLATFORM() ->
            [windows] Najít v možnostech
           *[other] Najít v předvolbách
        }
# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-preferences-input =
    .style = width: 15.4em
    .placeholder = Najít v předvolbách

## Preferences UI Search Results

search-results-header = Výsledky vyhledávání
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] Je nám líto, pro „<span data-l10n-name="query"></span>“ jsme v možnostech nic nenašli.
       *[other] Je nám líto, pro „<span data-l10n-name="query"></span>“ jsme v předvolbách nic nenašli.
    }
search-results-help-link =
    Potřebujete pomoc? Navštivte <a data-l10n-name="url">Podporu { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "gen") }
        [feminine] { -brand-short-name(case: "gen") }
        [neuter] { -brand-short-name(case: "gen") }
       *[other] aplikace { -brand-short-name }
    }</a>
