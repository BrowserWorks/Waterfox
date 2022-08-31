# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the MR1 onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## Welcome page strings

onboarding-welcome-header = Witamy w przeglądarce { -brand-short-name }
onboarding-start-browsing-button-label = Zacznij przeglądać Internet
onboarding-not-now-button-label = Nie teraz

## Custom Return To AMO onboarding strings

return-to-amo-subtitle = Świetnie, masz już przeglądarkę { -brand-short-name }
# <img data-l10n-name="icon"/> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-title = Pobierzmy teraz rozszerzenie <img data-l10n-name="icon"/> <b>{ $addon-name }</b>.
return-to-amo-add-extension-label = Dodaj rozszerzenie
return-to-amo-add-theme-label = Dodaj motyw

## Multistage onboarding strings (about:welcome pages)

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = Pierwsze kroki: { $current }. ekran z { $total }

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages

onboarding-welcome-steps-indicator2 =
    .aria-valuetext = Postęp: { $current }. krok z { $total }
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
mr2-onboarding-colorway-header = Życie w kolorze
mr2-onboarding-colorway-subtitle = Energiczne nowe kolorystyki. Dostępne przez ograniczony czas.
mr2-onboarding-colorway-primary-button-label = Zachowaj kolorystykę
mr2-onboarding-colorway-secondary-button-label = Nie teraz
mr2-onboarding-colorway-label-soft = Stonowana
mr2-onboarding-colorway-label-balanced = Wyważona
# "Bold" is used in the sense of bravery or courage, not in the sense of
# emphasized text.
mr2-onboarding-colorway-label-bold = Odważna
# Automatic theme uses operating system color settings
mr2-onboarding-theme-label-auto = Automatyczny
# This string will be used for Default theme
mr2-onboarding-theme-label-default = Domyślny
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
onboarding-theme-primary-button-label = Gotowe

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

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
# Tooltip displayed on hover of non-default colorway theme
# variations e.g. soft, balanced, bold
mr2-onboarding-theme-tooltip =
    .title = Użyj tej kolorystyki.
# Selector description for non-default colorway theme
# variations e.g. soft, balanced, bold
mr2-onboarding-theme-description =
    .aria-description = Użyj tej kolorystyki.
# Tooltip displayed on hover of colorway
# Variables:
#   $colorwayName (String) - Name of colorway
mr2-onboarding-colorway-tooltip =
    .title = Poznaj kolorystykę { $colorwayName }.
# Selector description for colorway
# Variables:
#   $colorwayName (String) - Name of colorway
mr2-onboarding-colorway-label = Poznaj kolorystykę { $colorwayName }.
# Tooltip displayed on hover of default themes
mr2-onboarding-default-theme-tooltip =
    .title = Poznaj domyślne motywy.
# Selector description for default themes
mr2-onboarding-default-theme-label = Poznaj domyślne motywy.

## Strings for Thank You page

mr2-onboarding-thank-you-header = Dziękujemy za wybranie nas
mr2-onboarding-thank-you-text = { -brand-short-name } to niezależna przeglądarka wspierana przez organizację non-profit. Razem sprawiamy, że Internet jest bezpieczniejszy, zdrowszy i bardziej prywatny.
mr2-onboarding-start-browsing-button-label = Zacznij przeglądać Internet

## Multistage live language reloading onboarding strings (about:welcome pages)
##
## The following language names are generated by the browser's Intl.DisplayNames API.
##
## Variables:
##   $negotiatedLanguage (String) - The name of the langpack's language, e.g. "Español (ES)"

onboarding-live-language-header = Wybierz język
onboarding-live-language-button-label-downloading = Pobieranie pakietu językowego ({ $negotiatedLanguage })…
onboarding-live-language-waiting-button = Pobieranie dostępnych języków…
onboarding-live-language-installing = Instalowanie pakietu językowego ({ $negotiatedLanguage })…
onboarding-live-language-secondary-cancel-download = Anuluj
onboarding-live-language-skip-button-label = Pomiń

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
    <span data-l10n-name="zap">podziękowań</span>
fx100-thank-you-subtitle = To nasze setne wydanie! Dziękujemy za pomoc w budowaniu lepszego, zdrowszego Internetu.
fx100-thank-you-pin-primary-button-label =
    { PLATFORM() ->
        [macos] Zatrzymaj przeglądarkę { -brand-short-name } w Docku
       *[other] Przypnij przeglądarkę { -brand-short-name } do paska zadań
    }
fx100-upgrade-thanks-header = 100 podziękowań
# Message shown with a start-browsing button. Emphasis <em> should be for "you"
# but "Thank" can be used instead if there's no "you" in the translation.
fx100-upgrade-thank-you-body = To nasze setne wydanie przeglądarki { -brand-short-name }. <em>Dziękujemy</em> za pomoc w budowaniu lepszego, zdrowszego Internetu.
# Message shown with either a pin-to-taskbar or set-default button.
fx100-upgrade-thanks-keep-body = To nasze setne wydanie! Dziękujemy, że jesteś częścią naszej społeczności. Miej przeglądarkę { -brand-short-name } zawsze pod ręką przez następne sto.
