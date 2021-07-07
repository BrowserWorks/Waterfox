# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

## Welcome modal dialog strings

### UI strings for the simplified onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.

### UI strings for the MR1 onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.

## Welcome page strings

onboarding-welcome-header = Benvenuto in { -brand-short-name }

onboarding-start-browsing-button-label = Inizia a navigare

## Welcome full page string

## Waterfox Sync modal dialog strings.

## This is part of the line "Enter your email to continue to Waterfox Sync"


## These are individual benefit messages shown with an image, title and
## description.


## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

## Message strings belonging to the Return to AMO flow

onboarding-not-now-button-label = Non adesso

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
onboarding-multistage-welcome-subtitle = Il browser veloce, sicuro e rispettoso della privacy, sostenuto da un’organizzazione senza fini di lucro.
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

## Multistage onboarding strings (about:welcome pages)

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
onboarding-multistage-theme-label-alpenglow = Waterfox Alpenglow

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
mr1-onboarding-pin-header = { PLATFORM() ->
    [macos] Mantieni { -brand-short-name } nel Dock per un accesso più rapido
   *[other] Aggiungi { -brand-short-name } alla barra delle applicazioni per un accesso più rapido
}
# Primary button string used on welcome page when Waterfox is not pinned.
mr1-onboarding-pin-primary-button-label = { PLATFORM() ->
    [macos] Mantieni nel Dock
   *[other] Aggiungi alla barra delle applicazioni
}

## Multistage MR1 onboarding strings (about:welcome pages)

# This string will be used on welcome page primary button label
# when Waterfox is both pinned and default
mr1-onboarding-get-started-primary-button-label = Inizia

mr1-onboarding-welcome-header = Benvenuto in { -brand-short-name }
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

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

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
mr2-onboarding-colorway-description =
  .aria-description = Scopri le tonalità { $colorwayName }.

# Tooltip displayed on hover of default themes
mr2-onboarding-default-theme-tooltip =
  .title = Scopri i temi predefiniti.

# Selector description for default themes
mr2-onboarding-default-theme-description =
  .aria-description = Scopri i temi predefiniti.

mr2-onboarding-thank-you-header = Grazie per averci scelto
mr2-onboarding-thank-you-text = { -brand-short-name } è un browser indipendente sostenuto da un’organizzazione senza fini di lucro. Insieme possiamo rendere il Web più sicuro, più sano e più rispettoso della privacy.
mr2-onboarding-start-browsing-button-label = Inizia a navigare
