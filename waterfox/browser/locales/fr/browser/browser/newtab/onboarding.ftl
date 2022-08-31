# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


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
return-to-amo-add-theme-label = Ajouter le thème

## Multistage onboarding strings (about:welcome pages)

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = Premiers pas : écran { $current } sur { $total }

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages

onboarding-welcome-steps-indicator2 =
    .aria-valuetext = Progression : étape { $current } sur { $total }
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
mr2-onboarding-colorway-header = La vie en couleur
mr2-onboarding-colorway-subtitle = De nouveaux coloris somptueux. Disponibles pendant une durée limitée.
mr2-onboarding-colorway-primary-button-label = Enregistrer le coloris
mr2-onboarding-colorway-secondary-button-label = Plus tard
mr2-onboarding-colorway-label-soft = Doux
mr2-onboarding-colorway-label-balanced = Équilibré
# "Bold" is used in the sense of bravery or courage, not in the sense of
# emphasized text.
mr2-onboarding-colorway-label-bold = Soutenu
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
onboarding-theme-primary-button-label = Terminé

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

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
mr2-onboarding-colorway-label = Voir le coloris { $colorwayName }.
# Tooltip displayed on hover of default themes
mr2-onboarding-default-theme-tooltip =
    .title = Découvrir les thèmes par défaut.
# Selector description for default themes
mr2-onboarding-default-theme-label = Découvrir les thèmes par défaut.

## Strings for Thank You page

mr2-onboarding-thank-you-header = Merci de nous avoir choisis
mr2-onboarding-thank-you-text = { -brand-short-name } est un navigateur indépendant soutenu par une organisation à but non lucratif. Ensemble, nous rendons le Web plus sûr, plus sain et plus privé.
mr2-onboarding-start-browsing-button-label = Commencer la navigation

## Multistage live language reloading onboarding strings (about:welcome pages)
##
## The following language names are generated by the browser's Intl.DisplayNames API.
##
## Variables:
##   $negotiatedLanguage (String) - The name of the langpack's language, e.g. "Español (ES)"


## Multistage live language reloading onboarding strings (about:welcome pages)
##
## The following language names are generated by the browser's Intl.DisplayNames API.
##
## Variables:
##   $negotiatedLanguage (String) - The name of the langpack's language, e.g. "Español (ES)"
##   $systemLanguage (String) - The name of the system language, e.g "Español (ES)"
##   $appLanguage (String) - The name of the language shipping in the browser build, e.g. "English (EN)"

onboarding-live-language-header = Choisissez votre langue
mr2022-onboarding-live-language-text = { -brand-short-name } parle votre langue
onboarding-live-language-button-label-downloading = Téléchargement du paquetage linguistique en { $negotiatedLanguage }…
onboarding-live-language-waiting-button = Obtention des langues disponibles…
onboarding-live-language-installing = Installation du paquetage linguistique en { $negotiatedLanguage }…
mr2022-onboarding-live-language-switch-to = Passer en { $negotiatedLanguage }
mr2022-onboarding-live-language-continue-in = Continuer en { $appLanguage }
onboarding-live-language-secondary-cancel-download = Annuler
onboarding-live-language-skip-button-label = Ignorer

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
    fois
    <span data-l10n-name="zap">merci</span>
fx100-thank-you-subtitle = C’est notre 100ᵉ version ! Merci de nous aider à construire un Internet meilleur et plus sain.
fx100-thank-you-pin-primary-button-label =
    { PLATFORM() ->
        [macos] Conserver { -brand-short-name } dans le Dock
       *[other] Épingler { -brand-short-name } à la barre des tâches
    }
fx100-upgrade-thanks-header = 100 fois merci
# Message shown with a start-browsing button. Emphasis <em> should be for "you"
# but "Thank" can be used instead if there's no "you" in the translation.
fx100-upgrade-thank-you-body = Il s’agit de notre 100ᵉ version de { -brand-short-name }. <em>Merci</em> de nous aider à construire un Internet meilleur et plus sain.
# Message shown with either a pin-to-taskbar or set-default button.
fx100-upgrade-thanks-keep-body = C’est notre 100ᵉ version ! Merci d’avoir fait partie de notre communauté. Gardez { -brand-short-name } à portée de clic pour les 100 prochaines.
mr2022-onboarding-secondary-skip-button-label = Ignorer cette étape

## MR2022 New User Pin Waterfox screen strings

# Subtitle is used on onboarding page for new users page when Waterfox is not pinned
mr2022-onboarding-welcome-pin-subtitle = Lancez { -brand-short-name } depuis n’importe où en un seul clic. Chaque fois que vous le faites, vous choisissez un Web plus ouvert et indépendant.
# Primary button string used on welcome page for when Waterfox is not pinned.
mr2022-onboarding-pin-primary-button-label =
    { PLATFORM() ->
        [macos] Conserver { -brand-short-name } dans le Dock
       *[other] Épingler { -brand-short-name } à la barre des tâches
    }

## MR2022 Existing User Pin Waterfox Screen Strings


## MR2022 New User Set Default screen strings


## MR2022 Get Started screen strings.
## These strings will be used on the welcome page
## when Waterfox is already set to default and pinned.

mr2022-onboarding-get-started-primary-button-label = Configurer en quelques secondes

## MR2022 Import Settings screen strings

mr2022-onboarding-import-header = Configuration ultra-rapide
mr2022-onboarding-import-primary-button-label-no-attribution = Importer depuis un autre navigateur

## If your language uses grammatical genders, in the description for the
## colorway feel free to switch from "You are a X. You…" (e.g. "You are a
## Playmaker. You create…") to "X: you…" ("Playmaker: You create…"). This might
## help creating a more inclusive translation.

mr2022-onboarding-colorway-title = Choisissez la couleur qui vous inspire
mr2022-onboarding-existing-colorway-checkbox-label = Faites de la { -firefox-home-brand-name } votre page d’accueil colorée
mr2022-onboarding-colorway-label-default = Par défaut
mr2022-onboarding-colorway-tooltip-default =
    .title = Par défaut
mr2022-onboarding-colorway-label-playmaker = Meneur/Meneuse
mr2022-onboarding-colorway-tooltip-playmaker =
    .title = Meneur/Meneuse
mr2022-onboarding-colorway-description-playmaker = <b>Meneur/Meneuse :</b> vous créez des occasions de gagner et vous aidez tout un chacun autour de vous à élever le niveau de son jeu.
mr2022-onboarding-colorway-label-expressionist = Expressionniste
mr2022-onboarding-colorway-tooltip-expressionist =
    .title = Expressionniste
mr2022-onboarding-colorway-description-expressionist = <b>Expressionniste :</b> vous voyez le monde différemment et vos créations suscitent l’émotion chez les autres.
mr2022-onboarding-colorway-label-visionary = Visionnaire
mr2022-onboarding-colorway-tooltip-visionary =
    .title = Visionnaire
mr2022-onboarding-colorway-description-visionary = <b>Visionnaire :</b> vous remettez en cause les statu quo et poussez les autres à imaginer un monde meilleur.
mr2022-onboarding-colorway-label-activist = Militant/Militante
mr2022-onboarding-colorway-tooltip-activist =
    .title = Militant/Militante
mr2022-onboarding-colorway-description-activist = <b>Militant/Militante :</b> vous rendez le monde meilleur que vous ne l’avez trouvé et convainquez les autres de croire au changement.
mr2022-onboarding-colorway-label-dreamer = Rêveur/Rêveuse
mr2022-onboarding-colorway-tooltip-dreamer =
    .title = Rêveur/Rêveuse
mr2022-onboarding-colorway-description-dreamer = <b>Rêveur/Rêveuse : </b> vous croyez que la chance sourit aux audacieux et vous insufflez le courage aux autres.
mr2022-onboarding-colorway-label-innovator = Pionnier/Pionnière
mr2022-onboarding-colorway-tooltip-innovator =
    .title = Pionnier/Pionnière
mr2022-onboarding-colorway-description-innovator = <b>Pionnier/Pionnière :</b> vous voyez partout des opportunités et vous influencez le cours des vies de tous et toutes autour de vous.

## MR2022 Multistage Mobile Download screen strings


## MR2022 Upgrade Dialog screens
## Pin private window screen shown only for users who don't have Waterfox private pinned


## MR2022 Privacy Segmentation screen strings


## MR2022 Multistage Gratitude screen strings

mr2022-onboarding-gratitude-primary-button-label = Découvrir les nouveautés
mr2022-onboarding-gratitude-secondary-button-label = Commencer la navigation
