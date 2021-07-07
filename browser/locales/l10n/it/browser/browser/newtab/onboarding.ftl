# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-learn-more = Ulteriori informazioni
onboarding-button-label-get-started = Inizia

## Welcome modal dialog strings

onboarding-welcome-header = Benvenuto in { -brand-short-name }
onboarding-welcome-body = Hai già il browser.<br/>Adesso esplora tutti gli altri prodotti della famiglia { -brand-product-name }.
onboarding-welcome-learn-more = Scopri tutti i vantaggi.
onboarding-welcome-modal-get-body = Hai già il browser.<br/>Adesso ottieni il massimo da { -brand-product-name }.
onboarding-welcome-modal-supercharge-body = Protezione della privacy al massimo livello.
onboarding-welcome-modal-privacy-body = Hai già il browser. Adesso aggiungi protezioni per la tua privacy.
onboarding-welcome-modal-family-learn-more = Ulteriori informazioni sulla famiglia di prodotti { -brand-product-name }.
onboarding-welcome-form-header = Inizia da qui
onboarding-join-form-body = Inserisci il tuo indirizzo email per iniziare
onboarding-join-form-email =
    .placeholder = Inserisci email
onboarding-join-form-email-error = Inserisci un indirizzo email valido
onboarding-join-form-legal = Proseguendo, accetti le <a data-l10n-name="terms">condizioni di utilizzo del servizio</a> e l’<a data-l10n-name="privacy">informativa sulla privacy</a>.
onboarding-join-form-continue = Continua
# This message is followed by a link using onboarding-join-form-signin ("Sign In") as text.
onboarding-join-form-signin-label = Hai già un account?
# Text for link to submit the sign in form
onboarding-join-form-signin = Accedi
onboarding-start-browsing-button-label = Inizia a navigare
onboarding-not-now-button-label = Non adesso
onboarding-cards-dismiss =
    .title = Rimuovi
    .aria-label = Rimuovi

## Custom Return To AMO onboarding strings

return-to-amo-subtitle = Ottimo, ora hai installato { -brand-short-name }
# <img data-l10n-name="icon"/> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-title = Perché adesso non provi <img data-l10n-name="icon"/> <b>{ $addon-name }</b>?
return-to-amo-add-extension-label = Aggiungi l’estensione

## Multistage 3-screen onboarding flow strings (about:welcome pages)

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-welcome-header = Benvenuto in <span data-l10n-name="zap">{ -brand-short-name }</span>
onboarding-multistage-welcome-subtitle = Il browser veloce, sicuro e riservato sostenuto da un’organizzazione senza fini di lucro.
onboarding-multistage-welcome-primary-button-label = Avvia la configurazione
onboarding-multistage-welcome-secondary-button-label = Accedi
onboarding-multistage-welcome-secondary-button-text = Hai già un account?
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "more" should stay inside the span.
onboarding-multistage-set-default-header = Imposta { -brand-short-name } come <span data-l10n-name="zap">predefinito</span>
onboarding-multistage-set-default-subtitle = Velocità, sicurezza e privacy sempre garantiti quando navighi online.
onboarding-multistage-set-default-primary-button-label = Imposta come predefinito
onboarding-multistage-set-default-secondary-button-label = Non adesso

onboarding-multistage-pin-default-header = Inizia mettendo <span data-l10n-name="zap">{ -brand-short-name }</span> a portata di mouse
onboarding-multistage-pin-default-subtitle = Navigazione veloce, sicura e riservata ogni volta che vuoi esplorare il Web.
# The "settings" here refers to "Windows 10 Settings App" and not the browser's
onboarding-multistage-pin-default-waiting-subtitle = Scegli { -brand-short-name } in Browser Web quando si aprono le impostazioni
# The "settings" here refers to "Windows 10 Settings App" and not the browser's
onboarding-multistage-pin-default-help-text = Questo aggiungerà { -brand-short-name } alla barra delle applicazioni e aprirà le impostazioni
onboarding-multistage-pin-default-primary-button-label = Imposta { -brand-short-name } come browser principale

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "more" should stay inside the span.
onboarding-multistage-import-header = Importa password, segnalibri <br/>e <span data-l10n-name="zap">altro ancora</span>
onboarding-multistage-import-subtitle = Arrivi da un altro browser? È semplice ritrovare tutti i tuoi dati in { -brand-short-name }.
onboarding-multistage-import-primary-button-label = Avvia importazione
onboarding-multistage-import-secondary-button-label = Non adesso
# Info displayed in the footer of import settings screen during onboarding flow.
# This supports welcome screen showing top sites imported from the user's default browser.
onboarding-import-sites-disclaimer =
    I siti visualizzati sono stati trovati su questo dispositivo.
    { -brand-short-name } non salva né sincronizza dati da un altro browser, a
    meno che non si decida di importarli.
# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = Come iniziare: schermata { $current } di { $total }
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "look" should stay inside the span.
onboarding-multistage-theme-header = Scegli un nuovo <span data-l10n-name="zap">look</span>
onboarding-multistage-theme-subtitle = Personalizza { -brand-short-name } con un tema.
onboarding-multistage-theme-primary-button-label2 = Fatto
onboarding-multistage-theme-secondary-button-label = Non adesso
# Automatic theme uses operating system color settings
onboarding-multistage-theme-label-automatic = Automatico
# System refers to the operating system
onboarding-multistage-theme-label-light = Chiaro
onboarding-multistage-theme-label-dark = Scuro
onboarding-multistage-theme-label-alpenglow = Firefox Alpenglow

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

# Tooltip displayed on hover of automatic theme
onboarding-multistage-theme-tooltip-automatic-2 =
    .title =
        Utilizza la stessa combinazione di colori
        del sistema operativo per pulsanti, menu
        e finestre.
# Input description for automatic theme
onboarding-multistage-theme-description-automatic-2 =
    .aria-description =
        Utilizza la stessa combinazione di colori
        del sistema operativo per pulsanti, menu
        e finestre.
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light-2 =
    .title =
        Utilizza una combinazione di colori
        chiara per pulsanti, menu e finestre.
# Input description for light theme
onboarding-multistage-theme-description-light =
    .aria-description =
        Utilizza una combinazione di colori
        chiara per pulsanti, menu e finestre.
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark-2 =
    .title =
        Utilizza una combinazione di colori
        scura per pulsanti, menu e finestre.
# Input description for dark theme
onboarding-multistage-theme-description-dark =
    .aria-description =
        Utilizza una combinazione di colori
        scura per pulsanti, menu e finestre.
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow-2 =
    .title =
        Utilizza una combinazione di colori
        variegata per pulsanti, menu e finestre.
# Input description for Alpenglow theme
onboarding-multistage-theme-description-alpenglow =
    .aria-description =
        Utilizza una combinazione di colori
        variegata per pulsanti, menu e finestre.

## Welcome full page string

onboarding-fullpage-welcome-subheader = Esploriamo insieme tutto ciò che puoi fare.
onboarding-fullpage-form-email =
    .placeholder = Il tuo indirizzo email…

## Firefox Sync modal dialog strings.

onboarding-sync-welcome-header = Porta { -brand-product-name } con te
onboarding-sync-welcome-content = Ritrova segnalibri, cronologia, password e altre impostazioni su tutti i tuoi dispositivi.
onboarding-sync-welcome-learn-more-link = Ulteriori informazioni sull’account Firefox
onboarding-sync-form-input =
    .placeholder = Email
onboarding-sync-form-continue-button = Continua
onboarding-sync-form-skip-login-button = Ignora questo passaggio

## This is part of the line "Enter your email to continue to Firefox Sync"

onboarding-sync-form-header = Inserisci la tua email
onboarding-sync-form-sub-header = per utilizzare { -sync-brand-name }.

## These are individual benefit messages shown with an image, title and
## description.

onboarding-benefit-products-text = Una famiglia completa di strumenti che rispetta la tua privacy su tutti i tuoi dispositivi.
onboarding-benefit-privacy-text = Ogni nostra azione avviene nel rispetto della nostra “Garanzia sui dati personali”: raccogli meno dati, mantienili al sicuro, nessun segreto.
onboarding-benefit-sync-title = { -sync-brand-short-name }
onboarding-benefit-sync-text = Mantieni segnalibri, password e cronologia sempre a portata di mano su tutti i dispositivi dove utilizzi { -brand-product-name }.
onboarding-benefit-monitor-title = { -monitor-brand-short-name }
onboarding-benefit-monitor-text = Ricevi una notifica nel caso in cui le tue informazioni personali vengano compromesse in una violazione di dati conosciuta.
onboarding-benefit-lockwise-title = { -lockwise-brand-short-name }
onboarding-benefit-lockwise-text = Gestisci le tue password in modo sicuro e portatile.

## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

onboarding-tracking-protection-title2 = Protezione dal tracciamento
onboarding-tracking-protection-text2 = { -brand-short-name } impedisce ai siti web di tracciarti durante la navigazione, rendendo la vita difficile a quelle pubblicità che cercano di seguirti in tutto il Web.
onboarding-tracking-protection-button2 = Come funziona
onboarding-data-sync-title = Porta le tue personalizzazioni sempre con te
onboarding-data-sync-text2 = Sincronizza segnalibri, password e molto altro in tutti i dispositivi in cui usi { -brand-product-name }.
onboarding-data-sync-button2 = Accedi a { -sync-brand-short-name }
onboarding-firefox-monitor-title = Tieni sotto controllo le violazioni di dati
onboarding-firefox-monitor-text2 = { -monitor-brand-name } verifica se la tua email è stata coinvolta in una violazione di dati conosciuta e ti avvisa se appare in una nuova violazione.
onboarding-firefox-monitor-button = Iscriviti agli avvisi
onboarding-browse-privately-title = Naviga in modo riservato
onboarding-browse-privately-text = La navigazione anonima non conserva la cronologia di ricerca e navigazione, mantenendo le tue abitudini di navigazione al sicuro da chiunque altro utilizzi il tuo computer.
onboarding-browse-privately-button = Apri una finestra anonima
onboarding-firefox-send-title = Mantieni al sicuro i file che condividi
onboarding-firefox-send-text2 = Carica i tuoi file su { -send-brand-name } e condividili con crittografia end-to-end e un link che scade automaticamente.
onboarding-firefox-send-button = Prova { -send-brand-name }
onboarding-mobile-phone-title = Installa { -brand-product-name } sul tuo telefono
onboarding-mobile-phone-text = Scarica { -brand-product-name } per iOS e Android e sincronizza i tuoi dati con tutti i tuoi dispositivi.
onboarding-mobile-phone-button = Scarica il browser mobile
onboarding-send-tabs-title = Inviati una scheda
onboarding-send-tabs-text2 = Condividi pagine in modo semplice con altri dispositivi senza bisogno di usare copia e incolla o lasciare il browser.
onboarding-send-tabs-button = Inizia a utilizzare “Invia scheda”
onboarding-pocket-anywhere-title = Leggi e ascolta ovunque ti trovi
onboarding-pocket-anywhere-text2 = Salva i tuoi contenuti preferiti nell’app di { -pocket-brand-name }. Leggili, ascoltali o guardali quando ti fa più comodo, anche senza connessione a Internet.
onboarding-pocket-anywhere-button = Prova { -pocket-brand-name }
onboarding-lockwise-strong-passwords-title = Genera e memorizza password complesse
onboarding-lockwise-strong-passwords-text = Con { -lockwise-brand-name } puoi generare al volo password complesse e salvarle in un unico posto.
onboarding-lockwise-strong-passwords-button = Gestisci le tue credenziali
onboarding-facebook-container-title = Metti un limite a Facebook
onboarding-facebook-container-text2 = { -facebook-container-brand-name } mantiene il tuo profilo separato da tutto il resto. In questo modo per Facebook diventerà più difficile mostrarti pubblicità mirate.
onboarding-facebook-container-button = Aggiungi l’estensione
onboarding-import-browser-settings-title = Importa segnalibri, password e altro ancora
onboarding-import-browser-settings-text = Recupera facilmente i tuoi siti e le tue informazioni da Chrome e inizia subito a navigare.
onboarding-import-browser-settings-button = Importa i dati da Chrome
onboarding-personal-data-promise-title = Progettato per la privacy
onboarding-personal-data-promise-text = { -brand-product-name } rispetta la tua privacy: raccogliamo meno dati, li proteggiamo e indichiamo chiaramente come li utilizziamo.
onboarding-personal-data-promise-button = Scopri i dettagli del nostro impegno

## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = Ottimo, ora hai installato { -brand-short-name }
return-to-amo-addon-header = Perché adesso non provi <icon></icon><b>{ $addon-name }</b>?
return-to-amo-extension-button = Aggiungi l’estensione
return-to-amo-get-started-button = Inizia a usare { -brand-short-name }

## Multistage MR1 onboarding strings (MR1 about:welcome pages)

# "Hero Text" displayed on left side of welcome screen.
# The "Fire" in "Fire starts here" plays on the "Fire" in "Firefox".
# It also signals the passion users bring to Firefox, how they use
# Firefox to pursue those passions, as well as the boldness in their
# choice to use Firefox over a larger competitor browser.
# An alternative title for localization is: "It starts here".
mr1-welcome-screen-hero-text = Cominciamo da qui

# Caption for background image in about:welcome. "Soraya Osorio" is the name
# of the person and shouldn't be translated.
mr1-onboarding-welcome-image-caption = Soraya Osorio — Designer di mobili, fan di Firefox

# This button will open system settings to turn on prefers-reduced-motion
mr1-onboarding-reduce-motion-button-label = Disattiva animazioni

## Title and primary button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# Title used on welcome page when Firefox is not pinned
mr1-onboarding-pin-header = { PLATFORM() ->
    [macos] Mantieni { -brand-short-name } nel Dock per un accesso più rapido
   *[other] Aggiungi { -brand-short-name } alla barra delle applicazioni per un accesso più rapido
}
# Primary button string used on welcome page when Firefox is not pinned.
mr1-onboarding-pin-primary-button-label = { PLATFORM() ->
    [macos] Mantieni nel Dock
   *[other] Aggiungi alla barra delle applicazioni
}

## Multistage MR1 onboarding strings (about:welcome pages)

# This string will be used on welcome page primary button label
# when Firefox is both pinned and default
mr1-onboarding-get-started-primary-button-label = Inizia

mr1-onboarding-welcome-header = Benvenuto in { -brand-short-name }
mr1-onboarding-set-default-pin-primary-button-label = Imposta { -brand-short-name } come browser principale
  .title = Imposta { -brand-short-name } come browser predefinito e lo aggiunge alla barra delle applicazioni

mr1-onboarding-set-default-only-primary-button-label = Imposta { -brand-short-name } come browser predefinito
mr1-onboarding-set-default-secondary-button-label = Non adesso
mr1-onboarding-sign-in-button-label = Accedi

## Title, subtitle and primary button string used on set default onboarding screen
## when Firefox is not default browser

mr1-onboarding-default-header = Imposta { -brand-short-name } come browser predefinito
mr1-onboarding-default-subtitle = Velocità, sicurezza e privacy senza preoccupazioni.
mr1-onboarding-default-primary-button-label = Imposta come browser predefinito

## Multistage MR1 onboarding strings (about:welcome pages)

mr1-onboarding-import-header = Porta tutto con te
mr1-onboarding-import-subtitle = Importa password, segnalibri<br/>e altro ancora.

# The primary import button label will depend on whether we can detect which browser was used to download Firefox.
# Variables:
#   $previous (Str) - Previous browser name, such as Edge, Chrome
mr1-onboarding-import-primary-button-label-attribution = Importa da { $previous }

# This string will be used in cases where we can't detect the previous browser name.
mr1-onboarding-import-primary-button-label-no-attribution = Importa da un browser esistente
mr1-onboarding-import-secondary-button-label = Non adesso

mr1-onboarding-theme-header = Uno stile unico
mr1-onboarding-theme-subtitle = Personalizza { -brand-short-name } con un tema.
mr1-onboarding-theme-primary-button-label = Salva tema
mr1-onboarding-theme-secondary-button-label = Non adesso

# System theme uses operating system color settings
mr1-onboarding-theme-label-system = Tema di sistema

mr1-onboarding-theme-label-light = Chiaro
mr1-onboarding-theme-label-dark = Scuro
# "Alpenglow" here is the name of the theme, and should be kept in English.
mr1-onboarding-theme-label-alpenglow = Alpenglow

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

# Tooltip displayed on hover of system theme
mr1-onboarding-theme-tooltip-system =
  .title =
    Utilizza la stessa combinazione di colori
    del sistema operativo per pulsanti, menu
    e finestre.

# Input description for system theme
mr1-onboarding-theme-description-system =
  .aria-description =
    Utilizza la stessa combinazione di colori
    del sistema operativo per pulsanti, menu
    e finestre.

# Tooltip displayed on hover of light theme
mr1-onboarding-theme-tooltip-light =
  .title =
    Utilizza una combinazione di colori chiara
    per pulsanti, menu e finestre.

# Input description for light theme
mr1-onboarding-theme-description-light =
  .aria-description =
    Utilizza una combinazione di colori chiara
    per pulsanti, menu e finestre.

# Tooltip displayed on hover of dark theme
mr1-onboarding-theme-tooltip-dark =
  .title =
    Utilizza una combinazione di colori scura
    per pulsanti, menu e finestre.

# Input description for dark theme
mr1-onboarding-theme-description-dark =
  .aria-description =
    Utilizza una combinazione di colori scura
    per pulsanti, menu e finestre.

# Tooltip displayed on hover of Alpenglow theme
mr1-onboarding-theme-tooltip-alpenglow =
  .title =
    Utilizza una combinazione di colori dinamica
    e variegata per pulsanti, menu e finestre.

# Input description for Alpenglow theme
mr1-onboarding-theme-description-alpenglow =
  .aria-description =
    Utilizza una combinazione di colori dinamica
    e variegata per pulsanti, menu e finestre.
