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

onboarding-welcome-header = Witamy w przeglądarce { -brand-short-name }

onboarding-start-browsing-button-label = Zacznij przeglądać Internet

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

onboarding-not-now-button-label = Nie teraz

## Custom Return To AMO onboarding strings

return-to-amo-subtitle = Świetnie, masz już przeglądarkę { -brand-short-name }
# <img data-l10n-name="icon"/> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-title = Pobierzmy teraz rozszerzenie <img data-l10n-name="icon"/> <b>{ $addon-name }</b>.
return-to-amo-add-extension-label = Dodaj rozszerzenie

## Multistage 3-screen onboarding flow strings (about:welcome pages)

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-welcome-header = Witamy w przeglądarce <span data-l10n-name="zap">{ -brand-short-name }</span>
onboarding-multistage-welcome-subtitle = Szybka, bezpieczna i prywatna przeglądarka tworzona przez organizację non-profit.
onboarding-multistage-welcome-primary-button-label = Zacznij konfigurację
onboarding-multistage-welcome-secondary-button-label = Zaloguj się
onboarding-multistage-welcome-secondary-button-text = Masz konto?

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "default" should stay inside the span.
onboarding-multistage-set-default-header = Ustaw przeglądarkę { -brand-short-name } jako <span data-l10n-name="zap">domyślną</span>
onboarding-multistage-set-default-subtitle = Zawsze szybko, bezpiecznie i prywatnie przeglądaj Internet.
onboarding-multistage-set-default-primary-button-label = Ustaw jako domyślną
onboarding-multistage-set-default-secondary-button-label = Nie teraz

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-pin-default-header = Zacznij od ustawienia przeglądarki <span data-l10n-name="zap">{ -brand-short-name }</span> tak, aby była zawsze pod ręką
onboarding-multistage-pin-default-subtitle = Zawsze szybko, bezpiecznie i prywatnie przeglądaj Internet.
# The "settings" here refers to "Windows 10 Settings App" and not the browser's
onboarding-multistage-pin-default-waiting-subtitle = Po otwarciu ustawień wybierz „{ -brand-short-name }” w sekcji Przeglądarka sieci Web
# The "settings" here refers to "Windows 10 Settings App" and not the browser's
onboarding-multistage-pin-default-help-text = Spowoduje to przypięcie przeglądarki { -brand-short-name } do paska zadań i otwarcie ustawień
onboarding-multistage-pin-default-primary-button-label = Ustaw przeglądarkę { -brand-short-name } jako główną

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "more" should stay inside the span.
onboarding-multistage-import-header = Importuj hasła, <br/>zakładki i <span data-l10n-name="zap">więcej</span>
onboarding-multistage-import-subtitle = Przechodzisz z innej przeglądarki? Możesz łatwo przenieść wszystko do przeglądarki { -brand-short-name }.
onboarding-multistage-import-primary-button-label = Zacznij import
onboarding-multistage-import-secondary-button-label = Nie teraz

# Info displayed in the footer of import settings screen during onboarding flow.
# This supports welcome screen showing top sites imported from the user's default browser.
onboarding-import-sites-disclaimer = Na urządzeniu znaleziono te witryny. { -brand-short-name } nie zachowuje ani nie synchronizuje danych z innej przeglądarki, jeśli nie zdecydujesz się ich zaimportować.

## Multistage onboarding strings (about:welcome pages)

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = Pierwsze kroki: { $current }. ekran z { $total }

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "look" should stay inside the span.
onboarding-multistage-theme-header = Wybierz swój <span data-l10n-name="zap">wygląd</span>
onboarding-multistage-theme-subtitle = Spersonalizuj przeglądarkę { -brand-short-name } za pomocą motywu.
onboarding-multistage-theme-primary-button-label2 = Gotowe
onboarding-multistage-theme-secondary-button-label = Nie teraz

# Automatic theme uses operating system color settings
onboarding-multistage-theme-label-automatic = Automatyczny

onboarding-multistage-theme-label-light = Jasny
onboarding-multistage-theme-label-dark = Ciemny
# "Waterfox Alpenglow" here is the name of the theme, and should be kept in English.
onboarding-multistage-theme-label-alpenglow = Waterfox Alpenglow

# "Hero Text" displayed on left side of welcome screen.
# The "Fire" in "Fire starts here" plays on the "Fire" in "Waterfox".
# It also signals the passion users bring to Waterfox, how they use
# Waterfox to pursue those passions, as well as the boldness in their
# choice to use Waterfox over a larger competitor browser.
# An alternative title for localization is: "It starts here".
# This text can be formatted to span multiple lines as needed.
mr1-welcome-screen-hero-text =
    Tu zaczyna się
    ogień

# Caption for background image in about:welcome. "Soraya Osorio" is the name
# of the person and shouldn't be translated.
# In case your language needs to adapt the nouns to a gender, Soraya is a female name (she/her).
# You can see the picture in about:welcome in Nightly 90.
mr1-onboarding-welcome-image-caption = Soraya Osorio — projektantka mebli, fanka Firefoksa

# This button will open system settings to turn on prefers-reduced-motion
mr1-onboarding-reduce-motion-button-label = Wyłącz animacje

## Title and primary button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# Title used on welcome page when Waterfox is not pinned
mr1-onboarding-pin-header =
    { PLATFORM() ->
        [macos] Zatrzymaj przeglądarkę { -brand-short-name } w Docku, aby mieć do niej łatwy dostęp
       *[other] Przypnij przeglądarkę { -brand-short-name } do paska zadań, aby mieć do niej łatwy dostęp
    }
# Primary button string used on welcome page when Waterfox is not pinned.
mr1-onboarding-pin-primary-button-label =
    { PLATFORM() ->
        [macos] Zatrzymaj w Docku
       *[other] Przypnij do paska zadań
    }

## Multistage MR1 onboarding strings (about:welcome pages)

# This string will be used on welcome page primary button label
# when Waterfox is both pinned and default
mr1-onboarding-get-started-primary-button-label = Pierwsze kroki

mr1-onboarding-welcome-header = Witamy w przeglądarce { -brand-short-name }
mr1-onboarding-set-default-pin-primary-button-label = Ustaw przeglądarkę { -brand-short-name } jako główną
    .title = Ustawia przeglądarkę { -brand-short-name } jako domyślną i przypina ją do paska zadań

# This string will be used on welcome page primary button label
# when Waterfox is not default but already pinned
mr1-onboarding-set-default-only-primary-button-label = Ustaw przeglądarkę { -brand-short-name } jako domyślną
mr1-onboarding-set-default-secondary-button-label = Nie teraz
mr1-onboarding-sign-in-button-label = Zaloguj się

## Title, subtitle and primary button string used on set default onboarding screen
## when Waterfox is not default browser

mr1-onboarding-default-header = Ustaw przeglądarkę { -brand-short-name } jako domyślną
mr1-onboarding-default-subtitle = Korzystaj z szybkości, bezpieczeństwa i prywatności na autopilocie.
mr1-onboarding-default-primary-button-label = Ustaw jako domyślną przeglądarkę

## Multistage MR1 onboarding strings (about:welcome pages)

mr1-onboarding-import-header = Zabierz to wszystko ze sobą
mr1-onboarding-import-subtitle = Zaimportuj swoje hasła, <br/>zakładki i nie tylko.

# The primary import button label will depend on whether we can detect which browser was used to download Waterfox.
# Variables:
#   $previous (Str) - Previous browser name, such as Edge, Chrome
mr1-onboarding-import-primary-button-label-attribution = Importuj z przeglądarki { $previous }

# This string will be used in cases where we can't detect the previous browser name.
mr1-onboarding-import-primary-button-label-no-attribution = Importuj z poprzedniej przeglądarki
mr1-onboarding-import-secondary-button-label = Nie teraz

mr1-onboarding-theme-header = Używaj jej po swojemu
mr1-onboarding-theme-subtitle = Spersonalizuj przeglądarkę { -brand-short-name } za pomocą motywu.
mr1-onboarding-theme-primary-button-label = Zachowaj motyw
mr1-onboarding-theme-secondary-button-label = Nie teraz

# System theme uses operating system color settings
mr1-onboarding-theme-label-system = Motyw systemu

mr1-onboarding-theme-label-light = Jasny
mr1-onboarding-theme-label-dark = Ciemny
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
        Przyciski, menu i okna wyglądające
        jak używany system operacyjny.

# Input description for automatic theme
onboarding-multistage-theme-description-automatic-2 =
    .aria-description =
        Przyciski, menu i okna wyglądające
        jak używany system operacyjny.

# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light-2 =
    .title = Jasne przyciski, menu i okna.

# Input description for light theme
onboarding-multistage-theme-description-light =
    .aria-description = Jasne przyciski, menu i okna.

# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark-2 =
    .title = Ciemne przyciski, menu i okna.

# Input description for dark theme
onboarding-multistage-theme-description-dark =
    .aria-description = Ciemne przyciski, menu i okna.

# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow-2 =
    .title = Kolorowe przyciski, menu i okna.

# Input description for Alpenglow theme
onboarding-multistage-theme-description-alpenglow =
    .aria-description = Kolorowe przyciski, menu i okna.

## Multistage MR1 onboarding strings (MR1 about:welcome pages)

# Tooltip displayed on hover of system theme
mr1-onboarding-theme-tooltip-system =
    .title =
        Używa motywu systemu operacyjnego
        do wyświetlania przycisków, menu i okien.

# Input description for system theme
mr1-onboarding-theme-description-system =
    .aria-description =
        Używa motywu systemu operacyjnego
        do wyświetlania przycisków, menu i okien.

# Tooltip displayed on hover of light theme
mr1-onboarding-theme-tooltip-light =
    .title =
        Używa jasnego motywu do wyświetlania
        przycisków, menu i okien.

# Input description for light theme
mr1-onboarding-theme-description-light =
    .aria-description =
        Używa jasnego motywu do wyświetlania
        przycisków, menu i okien.

# Tooltip displayed on hover of dark theme
mr1-onboarding-theme-tooltip-dark =
    .title =
        Używa ciemnego motywu do wyświetlania
        przycisków, menu i okien.

# Input description for dark theme
mr1-onboarding-theme-description-dark =
    .aria-description =
        Używa ciemnego motywu do wyświetlania
        przycisków, menu i okien.

# Tooltip displayed on hover of Alpenglow theme
mr1-onboarding-theme-tooltip-alpenglow =
    .title =
        Używa dynamicznego, kolorowego motywu
        do wyświetlania przycisków, menu i okien.

# Input description for Alpenglow theme
mr1-onboarding-theme-description-alpenglow =
    .aria-description =
        Używa dynamicznego, kolorowego motywu
        do wyświetlania przycisków, menu i okien.
