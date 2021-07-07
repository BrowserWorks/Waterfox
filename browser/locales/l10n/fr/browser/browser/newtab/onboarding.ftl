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

onboarding-welcome-header = Bienvenue dans { -brand-short-name }
onboarding-start-browsing-button-label = Commencer la navigation
onboarding-not-now-button-label = Plus tard

## Custom Return To AMO onboarding strings

return-to-amo-subtitle = Parfait, vous disposez de { -brand-short-name }
# <img data-l10n-name="icon"/> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-title = À présent, installons <img data-l10n-name="icon"/> <b>{ $addon-name }</b>.
return-to-amo-add-extension-label = Ajouter l’extension

## Multistage 3-screen onboarding flow strings (about:welcome pages)

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-welcome-header = Bienvenue dans <span data-l10n-name="zap">{ -brand-short-name }</span>
onboarding-multistage-welcome-subtitle = Le navigateur rapide, sûr et privé soutenu par une organisation à but non lucratif.
onboarding-multistage-welcome-primary-button-label = Commencer la configuration
onboarding-multistage-welcome-secondary-button-label = Se connecter
onboarding-multistage-welcome-secondary-button-text = Vous avez déjà un compte ?
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "default" should stay inside the span.
onboarding-multistage-set-default-header = Définissez { -brand-short-name } <span data-l10n-name="zap">par défaut</span>
onboarding-multistage-set-default-subtitle = Toute votre navigation rapide, sûre et confidentielle.
onboarding-multistage-set-default-primary-button-label = Le définir par défaut
onboarding-multistage-set-default-secondary-button-label = Plus tard
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-pin-default-header = Commencez par rendre <span data-l10n-name="zap">{ -brand-short-name }</span> accessible d’un clic
onboarding-multistage-pin-default-subtitle = Une navigation rapide, sûre et privée à chaque fois que vous utilisez le Web.
# The "settings" here refers to "Windows 10 Settings App" and not the browser's
onboarding-multistage-pin-default-waiting-subtitle = Choisissez { -brand-short-name } dans Navigateur Web lorsque vos paramètres s’ouvrent
# The "settings" here refers to "Windows 10 Settings App" and not the browser's
onboarding-multistage-pin-default-help-text = Ceci épinglera { -brand-short-name } à la barre des tâches et ouvrira les paramètres
onboarding-multistage-pin-default-primary-button-label = Faire de { -brand-short-name } mon navigateur principal
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "more" should stay inside the span.
onboarding-multistage-import-header = Importez vos mots de passe, <br/>marque-pages et <span data-l10n-name="zap">bien plus</span>
onboarding-multistage-import-subtitle = Vous utilisiez un autre navigateur ? Vous pouvez facilement tout importer dans { -brand-short-name }.
onboarding-multistage-import-primary-button-label = Lancer l’importation
onboarding-multistage-import-secondary-button-label = Plus tard
# Info displayed in the footer of import settings screen during onboarding flow.
# This supports welcome screen showing top sites imported from the user's default browser.
onboarding-import-sites-disclaimer = Les sites listés ici ont été trouvés sur cet appareil. { -brand-short-name } n’enregistre ni ne synchronise les données d’autres navigateurs, sauf si vous choisissez de les importer.

## Multistage onboarding strings (about:welcome pages)

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = Premiers pas : écran { $current } sur { $total }
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "look" should stay inside the span.
onboarding-multistage-theme-header = Choisissez une <span data-l10n-name="zap">apparence</span>
onboarding-multistage-theme-subtitle = Personnalisez { -brand-short-name } avec un thème.
onboarding-multistage-theme-primary-button-label2 = Terminé
onboarding-multistage-theme-secondary-button-label = Plus tard
# Automatic theme uses operating system color settings
onboarding-multistage-theme-label-automatic = Automatique
onboarding-multistage-theme-label-light = Clair
onboarding-multistage-theme-label-dark = Sombre
# "Waterfox Alpenglow" here is the name of the theme, and should be kept in English.
onboarding-multistage-theme-label-alpenglow = Waterfox Alpenglow
# "Hero Text" displayed on left side of welcome screen.
# The "Fire" in "Fire starts here" plays on the "Fire" in "Waterfox".
# It also signals the passion users bring to Waterfox, how they use
# Waterfox to pursue those passions, as well as the boldness in their
# choice to use Waterfox over a larger competitor browser.
# An alternative title for localization is: "It starts here".
# This text can be formatted to span multiple lines as needed.
mr1-welcome-screen-hero-text = C’est ici que tout commence
# Caption for background image in about:welcome. "Soraya Osorio" is the name
# of the person and shouldn't be translated.
# In case your language needs to adapt the nouns to a gender, Soraya is a female name (she/her).
# You can see the picture in about:welcome in Nightly 90.
mr1-onboarding-welcome-image-caption = Soraya Osorio — créatrice de meubles, fan de Waterfox
# This button will open system settings to turn on prefers-reduced-motion
mr1-onboarding-reduce-motion-button-label = Désactiver les animations

## Title and primary button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# Title used on welcome page when Waterfox is not pinned
mr1-onboarding-pin-header =
    { PLATFORM() ->
        [macos] Ajoutez { -brand-short-name } à votre Dock pour un accès facile
       *[other] Épinglez { -brand-short-name } à votre barre des tâches pour un accès facile
    }
# Primary button string used on welcome page when Waterfox is not pinned.
mr1-onboarding-pin-primary-button-label =
    { PLATFORM() ->
        [macos] Ajouter au Dock
       *[other] Épingler à la barre des tâches
    }

## Multistage MR1 onboarding strings (about:welcome pages)

# This string will be used on welcome page primary button label
# when Waterfox is both pinned and default
mr1-onboarding-get-started-primary-button-label = Pour commencer
mr1-onboarding-welcome-header = Bienvenue dans { -brand-short-name }
mr1-onboarding-set-default-pin-primary-button-label = Faire de { -brand-short-name } mon navigateur principal
    .title = Fait de { -brand-short-name } votre navigateur par défaut et l’épingle à la barre des tâches
# This string will be used on welcome page primary button label
# when Waterfox is not default but already pinned
mr1-onboarding-set-default-only-primary-button-label = Faire de { -brand-short-name } mon navigateur par défaut
mr1-onboarding-set-default-secondary-button-label = Plus tard
mr1-onboarding-sign-in-button-label = Connexion

## Title, subtitle and primary button string used on set default onboarding screen
## when Waterfox is not default browser

mr1-onboarding-default-header = Faire de { -brand-short-name } votre navigateur par défaut
mr1-onboarding-default-subtitle = Laissez vitesse, sécurité et vie privée se configurer automatiquement.
mr1-onboarding-default-primary-button-label = Définir comme navigateur par défaut

## Multistage MR1 onboarding strings (about:welcome pages)

mr1-onboarding-import-header = Emportez tout avec vous
mr1-onboarding-import-subtitle = Importez vos mots de passe, <br/>vos marque-pages et bien plus.
# The primary import button label will depend on whether we can detect which browser was used to download Waterfox.
# Variables:
#   $previous (Str) - Previous browser name, such as Edge, Chrome
mr1-onboarding-import-primary-button-label-attribution = Importer depuis { $previous }
# This string will be used in cases where we can't detect the previous browser name.
mr1-onboarding-import-primary-button-label-no-attribution = Importer depuis un autre navigateur
mr1-onboarding-import-secondary-button-label = Plus tard
mr2-onboarding-colorway-subtitle = De nouveaux coloris somptueux. Disponibles pendant une durée limitée.
mr2-onboarding-colorway-primary-button-label = Enregistrer le coloris
mr2-onboarding-colorway-secondary-button-label = Plus tard
mr2-onboarding-colorway-label-soft = Doux
mr2-onboarding-colorway-label-balanced = Équilibré
# Automatic theme uses operating system color settings
mr2-onboarding-theme-label-auto = Automatique
# This string will be used for Default theme
mr2-onboarding-theme-label-default = Par défaut
mr1-onboarding-theme-header = Adaptez-le à votre style
mr1-onboarding-theme-subtitle = Personnalisez { -brand-short-name } avec un thème.
mr1-onboarding-theme-primary-button-label = Enregistrer le thème
mr1-onboarding-theme-secondary-button-label = Plus tard
# System theme uses operating system color settings
mr1-onboarding-theme-label-system = Thème du système
mr1-onboarding-theme-label-light = Clair
mr1-onboarding-theme-label-dark = Sombre
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
        Suivre l’apparence de votre système
        d’exploitation pour les boutons,
        les menus et les fenêtres.
# Input description for automatic theme
onboarding-multistage-theme-description-automatic-2 =
    .aria-description =
        Suivre l’apparence de votre système
        d’exploitation pour les boutons,
        les menus et les fenêtres.
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light-2 =
    .title =
        Utiliser un thème clair pour les boutons,
        les menus et les fenêtres.
# Input description for light theme
onboarding-multistage-theme-description-light =
    .aria-description =
        Utiliser un thème clair pour les boutons,
        les menus et les fenêtres.
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark-2 =
    .title =
        Utiliser un thème sombre pour les boutons,
        les menus et les fenêtres.
# Input description for dark theme
onboarding-multistage-theme-description-dark =
    .aria-description =
        Utiliser un thème sombre pour les boutons,
        les menus et les fenêtres.
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow-2 =
    .title =
        Utiliser un thème coloré pour les boutons,
        les menus et les fenêtres.
# Input description for Alpenglow theme
onboarding-multistage-theme-description-alpenglow =
    .aria-description =
        Utiliser un thème coloré pour les boutons,
        les menus et les fenêtres.

## Multistage MR1 onboarding strings (MR1 about:welcome pages)

# Tooltip displayed on hover of system theme
mr1-onboarding-theme-tooltip-system =
    .title =
        Utiliser le thème du système
        pour les boutons, menus et fenêtres.
# Input description for system theme
mr1-onboarding-theme-description-system =
    .aria-description =
        Utiliser le thème du système
        pour les boutons, menus et fenêtres.
# Tooltip displayed on hover of light theme
mr1-onboarding-theme-tooltip-light =
    .title =
        Utiliser un thème clair
        pour les boutons, menus et fenêtres.
# Input description for light theme
mr1-onboarding-theme-description-light =
    .aria-description =
        Utiliser un thème clair
        pour les boutons, menus et fenêtres.
# Tooltip displayed on hover of dark theme
mr1-onboarding-theme-tooltip-dark =
    .title =
        Utiliser un thème sombre
        pour les boutons, menus et fenêtres.
# Input description for dark theme
mr1-onboarding-theme-description-dark =
    .aria-description =
        Utiliser un thème sombre
        pour les boutons, menus et fenêtres.
# Tooltip displayed on hover of Alpenglow theme
mr1-onboarding-theme-tooltip-alpenglow =
    .title =
        Utiliser un thème dynamique et coloré
        pour les boutons, menus et fenêtres.
# Input description for Alpenglow theme
mr1-onboarding-theme-description-alpenglow =
    .aria-description =
        Utiliser un thème dynamique et coloré
        pour les boutons, menus et fenêtres.
# Tooltip displayed on hover of non-default colorway theme
# variations e.g. soft, balanced, bold
mr2-onboarding-theme-tooltip =
    .title = Utiliser ce coloris.
# Selector description for non-default colorway theme
# variations e.g. soft, balanced, bold
mr2-onboarding-theme-description =
    .aria-description = Utiliser ce coloris.
# Tooltip displayed on hover of colorway
# Variables:
#   $colorwayName (String) - Name of colorway
mr2-onboarding-colorway-tooltip =
    .title = Voir le coloris { $colorwayName }.
# Selector description for colorway
# Variables:
#   $colorwayName (String) - Name of colorway
mr2-onboarding-colorway-description =
    .aria-description = Voir le coloris { $colorwayName }.
# Tooltip displayed on hover of default themes
mr2-onboarding-default-theme-tooltip =
    .title = Découvrir les thèmes par défaut.
# Selector description for default themes
mr2-onboarding-default-theme-description =
    .aria-description = Découvrir les thèmes par défaut.

## Strings for Thank You page

mr2-onboarding-thank-you-header = Merci de nous avoir choisis
mr2-onboarding-thank-you-text = { -brand-short-name } est un navigateur indépendant soutenu par une organisation à but non lucratif. Ensemble, nous rendons le Web plus sûr, plus sain et plus privé.
mr2-onboarding-start-browsing-button-label = Commencer la navigation
