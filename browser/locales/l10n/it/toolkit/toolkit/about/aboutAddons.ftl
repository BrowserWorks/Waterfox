# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-page-title = Gestione componenti aggiuntivi

search-header =
    .placeholder = Cerca in addons.mozilla.org
    .searchbuttonlabel = Cerca

search-header-shortcut =
    .key = f

list-empty-get-extensions-message =
    Visita <a data-l10n-name="get-extensions">{ $domain }</a> per installare estensioni e temi

list-empty-installed =
    .value = Non risulta installato alcun componente aggiuntivo di questo tipo

list-empty-available-updates =
    .value = Nessun aggiornamento disponibile

list-empty-recent-updates =
    .value = Nessun componente aggiuntivo è stato aggiornato di recente

list-empty-find-updates =
    .label = Controlla aggiornamenti

list-empty-button =
    .label = Scopri altre informazioni sui componenti aggiuntivi

help-button = Supporto componenti aggiuntivi
sidebar-help-button-title =
    .title = Supporto componenti aggiuntivi

addons-settings-button = Impostazioni di { -brand-short-name }
sidebar-settings-button-title =
    .title = Impostazioni di { -brand-short-name }

show-unsigned-extensions-button =
    .label = Non è stato possibile verificare alcune estensioni

show-all-extensions-button =
    .label = Visualizza tutte le estensioni

detail-version =
    .label = Versione

detail-last-updated =
    .label = Ultimo aggiornamento

detail-contributions-description = Lo sviluppatore di questo componente aggiuntivo chiede agli utenti una piccola donazione per contribuire al suo sviluppo.

detail-contributions-button = Fai una donazione
    .title = Contribuisci allo sviluppo di questo componente aggiuntivo
    .accesskey = C

detail-update-type =
    .value = Aggiornamento automatico

detail-update-default =
    .label = Predefinito
    .tooltiptext = Installa automaticamente gli aggiornamenti se questa è l’impostazione predefinita

detail-update-automatic =
    .label = Attivo
    .tooltiptext = Installa automaticamente gli aggiornamenti

detail-update-manual =
    .label = Disattivato
    .tooltiptext = Non installare automaticamente gli aggiornamenti

detail-private-browsing-label = Funzionamento in finestre anonime

detail-private-disallowed-label = Disattivata in finestre anonime
detail-private-disallowed-description2 = Questa estensione non funziona in navigazione anonima. <<a data-l10n-name="learn-more">Ulteriori informazioni</a>

detail-private-required-label = Richiede accesso alle finestre anonime
detail-private-required-description2 = Questa estensione ha accesso alle tue attività online nelle finestre anonime. <a data-l10n-name="learn-more">Ulteriori informazioni</a>

detail-private-browsing-on =
    .label = Consenti
    .tooltiptext = Attiva in Navigazione anonima

detail-private-browsing-off =
    .label = Non consentire
    .tooltiptext = Disattiva in Navigazione anonima

detail-home =
    .label = Sito web

detail-home-value =
    .value = { detail-home.label }

detail-repository =
    .label = Profilo del componente aggiuntivo

detail-repository-value =
    .value = { detail-repository.label }

detail-check-for-updates =
    .label = Controlla aggiornamenti
    .accesskey = e
    .tooltiptext = Controlla aggiornamenti per questo componente aggiuntivo

detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] Opzioni
           *[other] Preferenze
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] P
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] Modifica le opzioni di questo componente aggiuntivo
           *[other] Modifica le preferenze di questo componente aggiuntivo
        }

detail-rating =
    .value = Voto

addon-restart-now =
    .label = Riavvia adesso

disabled-unsigned-heading =
    .value = Alcuni componenti aggiuntivi sono stati disattivati

disabled-unsigned-description = I seguenti componenti non sono stati verificati per l’utilizzo in { -brand-short-name }. È possibile <label data-l10n-name="find-addons">cercare delle alternative</label> o chiedere allo sviluppatore di farli verificare.

disabled-unsigned-learn-more = Scopri ulteriori informazioni sul nostro impegno per garantire la sicurezza degli utenti online.

disabled-unsigned-devinfo = Gli sviluppatori interessati al processo di verifica dei componenti aggiuntivi possono consultare il seguente <label data-l10n-name="learn-more">manuale</label>.

plugin-deprecation-description = Manca qualcosa? Alcuni plugin non sono più supportati da { -brand-short-name }. <label data-l10n-name="learn-more">Ulteriori informazioni.</label>

legacy-warning-show-legacy = Mostra le estensioni obsolete

legacy-extensions =
    .value = Estensioni obsolete

legacy-extensions-description = Queste estensioni non soddisfano gli standard attualmente richiesti da { -brand-short-name } e sono state disattivate. <label data-l10n-name="legacy-learn-more">Ulteriori informazioni sui cambiamenti riguardanti le estensioni</label>

private-browsing-description2 =
    Il funzionamento delle estensioni in finestre anonime sta per cambiare.
    Qualunque estensione aggiunta a { -brand-short-name } non funzionerà in
    finestre anonime per impostazione predefinita. Un’estensione non funzionerà
    in finestre anonime e non avrà accesso alle attività online, a meno che il
    funzionamento non sia stato consentito nelle impostazioni. Questa modifica è
    stata introdotta per garantire la riservatezza dei dati di navigazione
    quando si utilizzano finestre anonime.
    <label data-l10n-name="private-browsing-learn-more">Scopri come gestire le impostazioni delle estensioni</label>

addon-category-discover = Consigli
addon-category-discover-title =
    .title = Consigli
addon-category-extension = Estensioni
addon-category-extension-title =
    .title = Estensioni
addon-category-theme = Temi
addon-category-theme-title =
    .title = Temi
addon-category-plugin = Plugin
addon-category-plugin-title =
    .title = Plugin
addon-category-dictionary = Dizionari
addon-category-dictionary-title =
    .title = Dizionari
addon-category-locale = Lingue
addon-category-locale-title =
    .title = Lingue
addon-category-available-updates = Aggiornamenti disponibili
addon-category-available-updates-title =
    .title = Aggiornamenti disponibili
addon-category-recent-updates = Aggiornamenti recenti
addon-category-recent-updates-title =
    .title = Aggiornamenti recenti

## These are global warnings

extensions-warning-safe-mode = Tutti i componenti aggiuntivi sono stati disattivati dalla modalità provvisoria.
extensions-warning-check-compatibility = Il controllo di compatibilità dei componenti aggiuntivi è disattivato. Potrebbero essere presenti dei componenti aggiuntivi non compatibili.
extensions-warning-check-compatibility-button = Attiva
    .title = Attiva il controllo di compatibilità dei componenti aggiuntivi
extensions-warning-update-security = Il controllo sulla sicurezza degli aggiornamenti dei componenti aggiuntivi è disattivato. Il sistema potrebbe essere danneggiato da un aggiornamento.
extensions-warning-update-security-button = Attiva
    .title = Attiva il controllo sulla sicurezza degli aggiornamenti dei componenti aggiuntivi


## Strings connected to add-on updates

addon-updates-check-for-updates = Controlla aggiornamenti
    .accesskey = C
addon-updates-view-updates = Visualizza aggiornamenti recenti
    .accesskey = V

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = Aggiorna automaticamente i componenti aggiuntivi
    .accesskey = A

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = Ripristina l’aggiornamento automatico per tutti i componenti aggiuntivi
    .accesskey = R
addon-updates-reset-updates-to-manual = Ripristina l’aggiornamento manuale per tutti i componenti aggiuntivi
    .accesskey = R

## Status messages displayed when updating add-ons

addon-updates-updating = Aggiornamento dei componenti aggiuntivi in corso
addon-updates-installed = I componenti aggiuntivi sono stati aggiornati.
addon-updates-none-found = Nessun aggiornamento disponibile
addon-updates-manual-updates-found = Visualizza aggiornamenti disponibili

## Add-on install/debug strings for page options menu

addon-install-from-file = Installa componente aggiuntivo da file…
    .accesskey = I
addon-install-from-file-dialog-title = Selezionare i componenti aggiuntivi da installare
addon-install-from-file-filter-name = Componenti aggiuntivi
addon-open-about-debugging = Debug componenti aggiuntivi
    .accesskey = D

## Extension shortcut management

# This is displayed in the page options menu
addon-manage-extensions-shortcuts = Gestisci scorciatoie da tastiera
    .accesskey = G

shortcuts-no-addons = Non ci sono estensioni attive.
shortcuts-no-commands = Le seguenti estensioni non hanno scorciatoie da tastiera:
shortcuts-input =
    .placeholder = Inserisci una scorciatoia

shortcuts-browserAction2 = Attiva pulsante nella barra degli strumenti
shortcuts-pageAction = Attiva azione pagina
shortcuts-sidebarAction = Attiva/disattiva barra laterale

shortcuts-modifier-mac = Includi Ctrl, Alt o ⌘
shortcuts-modifier-other = Includi Ctrl o Alt
shortcuts-invalid = Combinazione non valida
shortcuts-letter = Inserisci una lettera
shortcuts-system = Non è possibile sostituire una scorciatoia da tastiera di { -brand-short-name }

# String displayed in warning label when there is a duplicate shortcut
shortcuts-duplicate = Scorciatoia da tastiera duplicata

# String displayed when a keyboard shortcut is already assigned to more than one add-on
# Variables:
#   $shortcut (string) - Shortcut string for the add-on
shortcuts-duplicate-warning-message = La combinazione { $shortcut } è utilizzata come scorciatoia da tastiera per più comandi. Scorciatoie duplicate possono causare comportamenti imprevisti.

shortcuts-exists = Già utilizzata da { $addon }

shortcuts-card-expand-button = Visualizza altre { $numberToShow }

shortcuts-card-collapse-button = Mostra meno scorciatoie

header-back-button =
    .title = Torna indietro

## Recommended add-ons page

# Explanatory introduction to the list of recommended add-ons. The action word
# ("recommends") in the final sentence is a link to external documentation.
discopane-intro =
    Estensioni e temi sono l’equivalente delle app per il tuo browser;
    permettono di proteggere password, scaricare video, risparmiare negli
    acquisti online, bloccare pubblicità fastidiose, cambiare l’aspetto del
    browser, e molto altro ancora. Questi software sono spesso sviluppati da
    terze parti. Ecco una selezione <a data-l10n-name="learn-more-trigger">
    consigliata</a> da { -brand-product-name }, con la garanzia di sicurezza,
    prestazioni e funzionalità al massimo livello.

discopane-notice-recommendations =
    Alcuni consigli in questa pagina sono personalizzati. Sono basati sulle
    estensioni già installate, le impostazioni del profilo e statistiche
    d’utilizzo.
discopane-notice-learn-more = Ulteriori informazioni

privacy-policy = Informativa sulla privacy

# Refers to the author of an add-on, shown below the name of the add-on.
# Variables:
#   $author (string) - The name of the add-on developer.
created-by-author = di <a data-l10n-name="author">{ $author }</a>
user-count = Utenti: { $dailyUsers }
install-extension-button = Aggiungi a { -brand-product-name }
install-theme-button = Installa tema
# The label of the button that appears after installing an add-on. Upon click,
# the detailed add-on view is opened, from where the add-on can be managed.
manage-addon-button = Gestisci
find-more-addons = Trova altri componenti aggiuntivi
find-more-themes = Trova altri temi

# This is a label for the button to open the "more options" menu, it is only
# used for screen readers.
addon-options-button =
    .aria-label = Altre opzioni

## Add-on actions

report-addon-button = Segnala
remove-addon-button = Rimuovi
remove-addon-disabled-button = Impossibile rimuovere <a data-l10n-name="link">Perché?</a>
disable-addon-button = Disattiva
enable-addon-button = Attiva
extension-enable-addon-button-label =
    .aria-label = Attiva
preferences-addon-button =
    { PLATFORM() ->
        [windows] Opzioni
       *[other] Preferenze
    }
details-addon-button = Dettagli
release-notes-addon-button = Note di versione
permissions-addon-button = Permessi

extension-enabled-heading = Attive
extension-disabled-heading = Disattivate

theme-enabled-heading = Attivi
theme-disabled-heading = Disattivati

plugin-enabled-heading = Attivi
plugin-disabled-heading = Disattivati
theme-monochromatic-heading = Tonalità
theme-monochromatic-subheading = Nuove vibranti tonalità da { -brand-product-name }. Disponibili per un periodo limitato.

dictionary-enabled-heading = Attivi
dictionary-disabled-heading = Disattivati

locale-enabled-heading = Attive
locale-disabled-heading = Disattivate

always-activate-button = Attiva sempre
never-activate-button = Non attivare mai

addon-detail-author-label = Autore
addon-detail-version-label = Versione
addon-detail-last-updated-label = Ultimo aggiornamento
addon-detail-homepage-label = Sito web
addon-detail-rating-label = Voto

# Message for add-ons with a staged pending update.
install-postponed-message = Questa estensione verrà aggiornata al riavvio di { -brand-short-name }.
install-postponed-button = Aggiorna adesso

# The average rating that the add-on has received.
# Variables:
#   $rating (number) - A number between 0 and 5. The translation should show at most one digit after the comma.
five-star-rating =
    .title = Voto: { NUMBER($rating, maximumFractionDigits: 1) } su 5

addon-name-disabled = { $name } (disattivato)

addon-detail-reviews-link =
    { $numberOfReviews ->
        [one] { $numberOfReviews } recensione
       *[other] { $numberOfReviews } recensioni
    }

## Pending uninstall message bar

pending-uninstall-description = <span data-l10n-name="addon-name">{ $addon }</span> è stato rimosso.
pending-uninstall-undo-button = Annulla

addon-detail-updates-label = Aggiornamento automatico
addon-detail-updates-radio-default = Predefinito
addon-detail-updates-radio-on = Attivo
addon-detail-updates-radio-off = Disattivato
addon-detail-update-check-label = Controlla aggiornamenti
install-update-button = Aggiorna

addon-badge-private-browsing-allowed2 =
    .title = Attiva in finestre anonime
    .aria-label = { addon-badge-private-browsing-allowed2.title }
addon-detail-private-browsing-help = Se viene garantito il permesso, l’estensione potrà accedere alle tue attività online nelle finestre anonime. <a data-l10n-name="learn-more">Ulteriori informazioni</a>
addon-detail-private-browsing-allow = Consenti
addon-detail-private-browsing-disallow = Non consentire

## This is the tooltip text for the recommended badges for an extension in about:addons. The
## badge is a small icon displayed next to an extension when it is recommended on AMO.

addon-badge-recommended2 =
    .title = Vengono consigliate solo estensioni che soddisfano i requisiti di sicurezza e prestazioni di { -brand-product-name }
    .aria-label = { addon-badge-recommended2.title }

addon-badge-line3 =
  .title = Estensione ufficiale realizzata da Waterfox. Rispetta gli standard in materia di sicurezza e prestazioni
  .aria-label = { addon-badge-line3.title }
addon-badge-verified2 =
  .title = Questa estensione è stata verificata per garantire il rispetto dei nostri standard in materia di sicurezza e prestazioni
  .aria-label = { addon-badge-verified2.title }

##

available-updates-heading = Aggiornamenti disponibili
recent-updates-heading = Aggiornamenti recenti

release-notes-loading = Caricamento in corso…
release-notes-error = Siamo spiacenti, si è verificato un errore durante il caricamento delle note di versione.

addon-permissions-empty = Questa estensione non richiede alcun permesso

addon-permissions-required = Permessi obbligatori per funzionalità principali:
addon-permissions-optional = Permessi facoltativi per funzionalità aggiuntive:
addon-permissions-learnmore = Ulteriori informazioni sui permessi

recommended-extensions-heading = Estensioni consigliate
recommended-themes-heading = Temi consigliati

recommended-theme-1 = Ti senti creativo? <a data-l10n-name="link">Disegna il tuo tema con Waterfox Color</a>.

## Page headings

extension-heading = Gestione estensioni
theme-heading = Gestione temi
plugin-heading = Gestione plugin
dictionary-heading = Gestione dizionari
locale-heading = Gestione lingue
updates-heading = Gestione aggiornamenti
discover-heading = Personalizza { -brand-short-name }
shortcuts-heading = Gestione scorciatoie da tastiera

default-heading-search-label = Trova altri componenti aggiuntivi
addons-heading-search-input =
    .placeholder = Cerca in addons.mozilla.org

addon-page-options-button =
    .title = Strumenti per tutti i componenti aggiuntivi
