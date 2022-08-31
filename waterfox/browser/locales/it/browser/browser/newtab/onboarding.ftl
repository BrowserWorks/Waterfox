# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


### UI strings for the MR1 onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## Welcome page strings

onboarding-welcome-header = Benvenuti in { -brand-short-name }
onboarding-start-browsing-button-label = Inizia a navigare
onboarding-not-now-button-label = Non adesso

## Custom Return To AMO onboarding strings

return-to-amo-subtitle = Ottimo, ora hai installato { -brand-short-name }
# <img data-l10n-name="icon"/> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-title = Perché adesso non provi <img data-l10n-name="icon"/> <b>{ $addon-name }</b>?
return-to-amo-add-extension-label = Aggiungi l’estensione
return-to-amo-add-theme-label = Aggiungi il tema

## Multistage 3-screen onboarding flow strings (about:welcome pages)

## Multistage onboarding strings (about:welcome pages)

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = Come iniziare: schermata { $current } di { $total }

onboarding-welcome-steps-indicator2 =
  .aria-valuetext = Avanzamento: passo { $current } di { $total }

# "Hero Text" displayed on left side of welcome screen.
# The "Fire" in "Fire starts here" plays on the "Fire" in "Waterfox".
# It also signals the passion users bring to Waterfox, how they use
# Waterfox to pursue those passions, as well as the boldness in their
# choice to use Waterfox over a larger competitor browser.
# An alternative title for localization is: "It starts here".
mr1-welcome-screen-hero-text = Cominciamo da qui

# Caption for background image in about:welcome. "Soraya Osorio" is the name
# of the person and shouldn't be translated.
mr1-onboarding-welcome-image-caption = Soraya Osorio — Designer di mobili, fan di Waterfox

# This button will open system settings to turn on prefers-reduced-motion
mr1-onboarding-reduce-motion-button-label = Disattiva animazioni

## Title and primary button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# Title used on welcome page when Waterfox is not pinned
mr1-onboarding-pin-header =
    { PLATFORM() ->
        [macos] Mantieni { -brand-short-name } nel Dock per un accesso più rapido
       *[other] Aggiungi { -brand-short-name } alla barra delle applicazioni per un accesso più rapido
    }
# Primary button string used on welcome page when Waterfox is not pinned.
mr1-onboarding-pin-primary-button-label =
    { PLATFORM() ->
        [macos] Mantieni nel Dock
       *[other] Aggiungi alla barra delle applicazioni
    }

## Multistage MR1 onboarding strings (about:welcome pages)

# This string will be used on welcome page primary button label
# when Waterfox is both pinned and default
mr1-onboarding-get-started-primary-button-label = Inizia

mr1-onboarding-welcome-header = Benvenuti in { -brand-short-name }
mr1-onboarding-set-default-pin-primary-button-label = Imposta { -brand-short-name } come browser principale
    .title = Imposta { -brand-short-name } come browser predefinito e lo aggiunge alla barra delle applicazioni

mr1-onboarding-set-default-only-primary-button-label = Imposta { -brand-short-name } come browser predefinito
mr1-onboarding-set-default-secondary-button-label = Non adesso
mr1-onboarding-sign-in-button-label = Accedi

## Title, subtitle and primary button string used on set default onboarding screen
## when Waterfox is not default browser

mr1-onboarding-default-header = Imposta { -brand-short-name } come browser predefinito
mr1-onboarding-default-subtitle = Velocità, sicurezza e privacy senza preoccupazioni.
mr1-onboarding-default-primary-button-label = Imposta come browser predefinito

## Multistage MR1 onboarding strings (about:welcome pages)

mr1-onboarding-import-header = Porta tutto con te
mr1-onboarding-import-subtitle = Importa password, segnalibri<br/>e altro ancora.

# The primary import button label will depend on whether we can detect which browser was used to download Waterfox.
# Variables:
#   $previous (Str) - Previous browser name, such as Edge, Chrome
mr1-onboarding-import-primary-button-label-attribution = Importa da { $previous }

# This string will be used in cases where we can't detect the previous browser name.
mr1-onboarding-import-primary-button-label-no-attribution = Importa da un browser esistente
mr1-onboarding-import-secondary-button-label = Non adesso

mr2-onboarding-colorway-header = Una vita a colori
mr2-onboarding-colorway-subtitle = Nuove vibranti tonalità. Disponibili per un periodo limitato.
mr2-onboarding-colorway-primary-button-label = Salva tonalità
mr2-onboarding-colorway-secondary-button-label = Non adesso
mr2-onboarding-colorway-label-soft = Delicata
mr2-onboarding-colorway-label-balanced = Bilanciata
# "Bold" is used in the sense of bravery or courage, not in the sense of
# emphasized text.
mr2-onboarding-colorway-label-bold = Forte

# Automatic theme uses operating system color settings
mr2-onboarding-theme-label-auto = Automatico

# This string will be used for Default theme
mr2-onboarding-theme-label-default = Tema predefinito

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

onboarding-theme-primary-button-label = Fatto

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.


## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

## Multistage MR1 onboarding strings (MR1 about:welcome pages)

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

# Tooltip displayed on hover of non-default colorway theme
# variations e.g. soft, balanced, bold
mr2-onboarding-theme-tooltip =
    .title = Utilizza questa tonalità.

# Selector description for non-default colorway theme
# variations e.g. soft, balanced, bold
mr2-onboarding-theme-description =
    .aria-description = Utilizza questa tonalità.

# Tooltip displayed on hover of colorway
# Variables:
#   $colorwayName (String) - Name of colorway
mr2-onboarding-colorway-tooltip =
    .title = Scopri le tonalità { $colorwayName }.

# Selector description for colorway
# Variables:
#   $colorwayName (String) - Name of colorway
mr2-onboarding-colorway-label = Scopri le tonalità { $colorwayName }.

# Tooltip displayed on hover of default themes
mr2-onboarding-default-theme-tooltip =
    .title = Scopri i temi predefiniti.

# Selector description for default themes
mr2-onboarding-default-theme-label = Scopri i temi predefiniti.

## Strings for Thank You page

mr2-onboarding-thank-you-header = Grazie per averci scelto
mr2-onboarding-thank-you-text = { -brand-short-name } è un browser indipendente sostenuto da un’organizzazione senza fini di lucro. Insieme possiamo rendere il Web più sicuro, più sano e più rispettoso della privacy.
mr2-onboarding-start-browsing-button-label = Inizia a navigare

## Multistage live language reloading onboarding strings (about:welcome pages)
##
## The following language names are generated by the browser's Intl.DisplayNames API.
##
## Variables:
##   $appLanguage (String) - The name of Waterfox's language, e.g. "American English"
##   $systemLanguage (String) - The name of the OS's language, e.g. "European Spanish"
##   $negotiatedLanguage (String) - The name of the langpack's language, e.g. "European Spanish"

## Multistage live language reloading onboarding strings (about:welcome pages)
##
## The following language names are generated by the browser's Intl.DisplayNames API.
##
## Variables:
##   $negotiatedLanguage (String) - The name of the langpack's language, e.g. "Español (ES)"

onboarding-live-language-header = Scegli la tua lingua

mr2022-onboarding-live-language-text = { -brand-short-name } parla la tua lingua

mr2022-language-mismatch-subtitle = Grazie alla nostra comunità, { -brand-short-name } è tradotto in oltre 90 lingue. Sembra che il tuo sistema utilizzi { $systemLanguage }, mentre { -brand-short-name } sta utilizzando { $appLanguage }.

onboarding-live-language-button-label-downloading = Download del pacchetto lingua per { $negotiatedLanguage }…
onboarding-live-language-waiting-button = Recupero elenco delle lingue disponibili…
onboarding-live-language-installing = Installazione del pacchetto lingua per { $negotiatedLanguage }…
onboarding-live-language-secondary-cancel-download = Annulla
onboarding-live-language-skip-button-label = Salta

mr2022-onboarding-live-language-switch-to = Passa a { $negotiatedLanguage }
mr2022-onboarding-live-language-continue-in = Continua in { $appLanguage }

## Waterfox 100 Thank You screens

# "Hero Text" displayed on left side of welcome screen. This text can be
# formatted to span multiple lines as needed. The <span data-l10n-name="zap">
# </span> in this string allows a "zap" underline style to be automatically
# added to the text inside it. "Yous" should stay inside the zap span, but
# "Thank" can be put inside instead if there's no "you" in the translation.
# The English text would normally be "100 Thank-Yous" i.e., plural noun, but for
# aesthetics of splitting it across multiple lines, the hyphen is omitted.
fx100-thank-you-hero-text =
  100
  volte
  <span data-l10n-name="zap">grazie</span>
fx100-thank-you-subtitle = Questa è la nostra centesima versione! Grazie al tuo supporto possiamo rendere Internet un luogo migliore e più sano.
fx100-thank-you-pin-primary-button-label = { PLATFORM() ->
    [macos] Mantieni { -brand-short-name } nel Dock
   *[other] Aggiungi { -brand-short-name } alla barra delle applicazioni
}

fx100-upgrade-thanks-header = 100 volte grazie
# Message shown with a start-browsing button. Emphasis <em> should be for "you"
# but "Thank" can be used instead if there's no "you" in the translation.
fx100-upgrade-thank-you-body = Questa è la nostra centesima versione di { -brand-short-name }. Grazie al <em>tuo</em> supporto possiamo rendere Internet un luogo migliore e più sano.
# Message shown with either a pin-to-taskbar or set-default button.
fx100-upgrade-thanks-keep-body = Questa è la nostra centesima versione! Grazie per essere parte della nostra comunità. Tieni { -brand-short-name } a portata di clic per le prossime 100.

mr2022-onboarding-secondary-skip-button-label = Salta questo passaggio

## MR2022 New User Pin Waterfox screen strings

# Title used on about:welcome for new users when Waterfox is not pinned.
# In this context, open up is synonymous with "Discover".
# The metaphor is that when they open their Waterfox browser, it helps them discover an amazing internet.
# If this translation does not make sense in your language, feel free to use the word "discover."
mr2022-onboarding-welcome-pin-header = Scopri le meraviglie di Internet
# Subtitle is used on onboarding page for new users page when Waterfox is not pinned
mr2022-onboarding-welcome-pin-subtitle = Avvia { -brand-short-name } con un semplice clic, ovunque ti trovi. Scegli ogni volta un Web più aperto e indipendente.
# Primary button string used on welcome page for when Waterfox is not pinned.
mr2022-onboarding-pin-primary-button-label = { PLATFORM() ->
    [macos] Mantieni { -brand-short-name } nel Dock
   *[other] Aggiungi { -brand-short-name } alla barra delle applicazioni
}
# Subtitle will be used when user already has Waterfox pinned, but
# has not set it as their default browser.
# When translating "zip", please feel free to pick a verb that signifies movement and/or exploration
# and makes sense in the context of navigating the web.
mr2022-onboarding-set-default-only-subtitle = Inizia con un browser realizzato da un’organizzazione non-profit. Proteggiamo la tua privacy mentre ti muovi da un sito all’altro.

## MR2022 Existing User Pin Waterfox Screen Strings

# Title used on multistage onboarding page for existing users when Waterfox is not pinned
mr2022-onboarding-existing-pin-header = Grazie per il tuo supporto per { -brand-product-name }
# Subtitle is used on onboarding page for existing users when Waterfox is not pinned
mr2022-onboarding-existing-pin-subtitle = Accedi a un Internet più sano con un semplice clic, ovunque ti trovi. Il nostro ultimo aggiornamento include moltissime funzioni che adorerai.
# Subtitle will be used on the welcome screen for existing users
# when they already have Waterfox pinned but not set as default
mr2022-onboarding-existing-set-default-only-subtitle = Utilizza un browser che protegge la tua privacy mentre ti muovi da un sito all’altro. Il nostro ultimo aggiornamento include moltissime funzioni che adorerai.
mr2022-onboarding-existing-pin-checkbox-label = Aggiungi anche { -brand-short-name } — Navigazione anonima

## MR2022 New User Set Default screen strings

# This string is the title used when the user already has pinned the browser, but has not set default.
mr2022-onboarding-set-default-title = Rendi { -brand-short-name } il tuo browser di riferimento
mr2022-onboarding-set-default-primary-button-label = Imposta { -brand-short-name } come browser predefinito
# When translating "zip", please feel free to pick a verb that signifies movement and/or exploration
# and makes sense in the context of navigating the web.
mr2022-onboarding-set-default-subtitle = Utilizza un browser realizzato da un’organizzazione non-profit. Proteggiamo la tua privacy mentre ti muovi da un sito all’altro.

## MR2022 Get Started screen strings.
## These strings will be used on the welcome page
## when Waterfox is already set to default and pinned.

# When translating "zip", please feel free to pick a verb that signifies movement and/or exploration
# and makes sense in the context of navigating the web.
mr2022-onboarding-get-started-primary-subtitle = La nostra ultima versione è realizzata su misura per te, rendendo la navigazione su Internet ancora più facile. Include moltissime funzioni che adorerai.
mr2022-onboarding-get-started-primary-button-label = Configura in pochi secondi

## MR2022 Import Settings screen strings

mr2022-onboarding-import-header = Configurazione ultra rapida
mr2022-onboarding-import-subtitle = Imposta { -brand-short-name } come piace a te. Aggiungi segnalibri, password e altro ancora dal tuo vecchio browser.
mr2022-onboarding-import-primary-button-label-no-attribution = Importa dal browser precedente

## If your language uses grammatical genders, in the description for the
## colorway feel free to switch from "You are a X. You…" (e.g. "You are a
## Playmaker. You create…") to "X: you…" ("Playmaker: You create…"). This might
## help creating a more inclusive translation.

mr2022-onboarding-colorway-title = Scegli il colore che ti ispira
mr2022-onboarding-colorway-subtitle = Le voci indipendenti possono cambiare la società.
mr2022-onboarding-colorway-primary-button-label = Imposta tonalità
mr2022-onboarding-existing-colorway-checkbox-label = Utilizza { -firefox-home-brand-name } per una pagina iniziale multicolore

mr2022-onboarding-colorway-label-default = Predefinito
mr2022-onboarding-colorway-tooltip-default =
  .title = Predefinito
mr2022-onboarding-colorway-description-default = <b>Continua a utilizzare i colori correnti di { -brand-short-name }.</b>

mr2022-onboarding-colorway-label-playmaker = Regista
mr2022-onboarding-colorway-tooltip-playmaker =
  .title = Regista
mr2022-onboarding-colorway-description-playmaker = <b>Regista:</b> crei opportunità per vincere e aiuti le persone intorno a te a migliorare il loro gioco.

mr2022-onboarding-colorway-label-expressionist = Espressionista
mr2022-onboarding-colorway-tooltip-expressionist =
  .title = Espressionista
mr2022-onboarding-colorway-description-expressionist = <b>Espressionista:</b> vedi il mondo in modo diverso e le tue creazioni suscitano emozioni negli altri.

mr2022-onboarding-colorway-label-visionary = Visionaria
mr2022-onboarding-colorway-tooltip-visionary =
  .title = Visionaria
mr2022-onboarding-colorway-description-visionary = <b>Visionaria:</b> metti in dubbio lo status quo e spingi chi ti circonda a immaginare un mondo migliore.

mr2022-onboarding-colorway-label-activist = Attivista
mr2022-onboarding-colorway-tooltip-activist =
  .title = Attivista
mr2022-onboarding-colorway-description-activist = <b>Attivista:</b> rendi il mondo migliore di come l’hai trovato e convinci le altre persone a credere nel cambiamento.

mr2022-onboarding-colorway-label-dreamer = Sognatrice
mr2022-onboarding-colorway-tooltip-dreamer =
  .title = Sognatrice
mr2022-onboarding-colorway-description-dreamer = <b>Sognatrice:</b> credi che la fortuna aiuti gli audaci e ispiri gli altri a essere coraggiosi.

mr2022-onboarding-colorway-label-innovator = Innovatrice
mr2022-onboarding-colorway-tooltip-innovator =
  .title = Innovatrice
mr2022-onboarding-colorway-description-innovator = <b>Innovatrice:</b> vedi opportunità ovunque e lasci un segno nella vita di chi ti circonda.

## MR2022 Upgrade Dialog screens
## Pin private window screen shown only for users who don't have Waterfox private pinned

mr2022-upgrade-onboarding-pin-private-window-header = La libertà della navigazione anonima in un clic
mr2022-upgrade-onboarding-pin-private-window-subtitle = Niente cookie né cronologia, direttamente dal tuo desktop. Naviga come se nessuno ti stesse guardando.
mr2022-upgrade-onboarding-pin-private-window-primary-button-label = { PLATFORM() ->
    [macos] Mantieni { -brand-short-name } — Navigazione anonima nel Dock
   *[other] Aggiungi { -brand-short-name } — Navigazione anonima alla barra delle applicazioni
}

## MR2022 Multistage Mobile Download screen strings

mr2022-onboarding-mobile-download-title = Passa dal computer al telefono, e viceversa
mr2022-onboarding-mobile-download-subtitle = Recupera le schede da un altro dispositivo e riprendi esattamente da dove avevi interrotto. Inoltre, sincronizza i tuoi segnalibri e le tue password ovunque utilizzi { -brand-product-name }.
mr2022-onboarding-mobile-download-cta-text = Scansiona il codice QR per ottenere { -brand-product-name } per dispositivi mobili oppure <a data-l10n-name="download-label">inviati un link per il download.</a>
mr2022-onboarding-no-mobile-download-cta-text = Scansiona il codice QR per ottenere { -brand-product-name } per dispositivi mobili.

## MR2022 Privacy Segmentation screen strings

mr2022-onboarding-privacy-segmentation-title = Rispettiamo sempre la tua privacy
mr2022-onboarding-privacy-segmentation-subtitle = Da suggerimenti intelligenti a ricerche più efficienti, siamo sempre al lavoro per creare un’esperienza migliore e più personale in { -brand-product-name }.

mr2022-onboarding-privacy-segmentation-text-cta = Quale scelta preferisci quando introduciamo nuove funzioni che utilizzano i tuoi dati per migliorare la navigazione?
mr2022-onboarding-privacy-segmentation-button-primary-label = Usa le impostazioni consigliate da { -brand-product-name }
mr2022-onboarding-privacy-segmentation-button-secondary-label = Mostra informazioni dettagliate

## MR2022 Multistage Gratitude screen strings

mr2022-onboarding-gratitude-title = Ci stai aiutando a realizzare un Web migliore
mr2022-onboarding-gratitude-subtitle = Grazie per aver scelto di utilizzare { -brand-short-name }, il browser supportato da Waterfox Limited. Con il tuo supporto, lavoriamo per rendere Internet più aperto, più accessibile e migliore per tutti.
mr2022-onboarding-gratitude-primary-button-label = Scopri le novità
mr2022-onboarding-gratitude-secondary-button-label = Inizia a navigare
