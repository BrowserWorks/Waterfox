# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# The button for "Waterfox Translations" in the url bar.
urlbar-translations-button =
    .tooltiptext = Deze pagina vertalen
# The button for "Waterfox Translations" in the url bar. Note that here "Beta" should
# not be translated, as it is a reflection of the un-localized BETA icon that is in the
# panel.
urlbar-translations-button2 =
    .tooltiptext = Deze pagina vertalen – Beta
# Note that here "Beta" should not be translated, as it is a reflection of the
# un-localized BETA icon that is in the panel.
urlbar-translations-button-intro =
    .tooltiptext = Probeer privévertalingen in { -brand-shorter-name } – Beta
# If your language requires declining the language name, a possible solution
# is to adapt the structure of the phrase, or use a support noun, e.g.
# `Page translated from: { $fromLanguage }. Current target language: { $toLanguage }`
#
# Variables:
#   $fromLanguage (string) - The original language of the document.
#   $toLanguage (string) - The target language of the translation.
urlbar-translations-button-translated =
    .tooltiptext = Pagina vertaald van het { $fromLanguage } naar het { $toLanguage }
urlbar-translations-button-loading =
    .tooltiptext = Vertaling wordt uitgevoerd
translations-panel-settings-button =
    .aria-label = Vertaalinstellingen beheren
# Text displayed on a language dropdown when the language is in beta
# Variables:
#   $language (string) - The localized display name of the detected language
translations-panel-displayname-beta =
    .label = { $language } BETA

## Options in the Waterfox Translations settings.

translations-panel-settings-manage-languages =
    .label = Talen beheren
translations-panel-settings-about = Over vertalingen in { -brand-shorter-name }
translations-panel-settings-about2 =
    .label = Over vertalingen in { -brand-shorter-name }
# Text displayed for the option to always translate a given language
# Variables:
#   $language (string) - The localized display name of the detected language
translations-panel-settings-always-translate-language =
    .label = { $language } altijd vertalen
translations-panel-settings-always-translate-unknown-language =
    .label = Deze taal altijd vertalen
translations-panel-settings-always-offer-translation =
    .label = Altijd aanbieden om te vertalen
# Text displayed for the option to never translate a given language
# Variables:
#   $language (string) - The localized display name of the detected language
translations-panel-settings-never-translate-language =
    .label = { $language } nooit vertalen
translations-panel-settings-never-translate-unknown-language =
    .label = Deze taal nooit vertalen
# Text displayed for the option to never translate this website
translations-panel-settings-never-translate-site =
    .label = Deze website nooit vertalen

## The translation panel appears from the url bar, and this view is the default
## translation view.

translations-panel-header = Deze pagina vertalen?
translations-panel-translate-button =
    .label = Vertalen
translations-panel-translate-button-loading =
    .label = Even geduld…
translations-panel-translate-cancel =
    .label = Annuleren
translations-panel-learn-more-link = Meer info
translations-panel-intro-header = Probeer privévertalingen in { -brand-shorter-name }
translations-panel-intro-description = Voor uw privacy verlaten vertalingen uw apparaat nooit. Binnenkort nieuwe talen en verbeteringen!
translations-panel-error-translating = Er is een probleem opgetreden bij het vertalen. Probeer het opnieuw.
translations-panel-error-load-languages = Kon talen niet laden
translations-panel-error-load-languages-hint = Controleer uw internetverbinding en probeer het opnieuw.
translations-panel-error-load-languages-hint-button =
    .label = Opnieuw proberen
translations-panel-error-unsupported = Er is voor deze pagina geen vertaling beschikbaar
translations-panel-error-dismiss-button =
    .label = Begrepen
translations-panel-error-change-button =
    .label = Brontaal wijzigen
# If your language requires declining the language name, a possible solution
# is to adapt the structure of the phrase, or use a support noun, e.g.
# `Sorry, we don't support the language yet: { $language }
#
# Variables:
#   $language (string) - The language of the document.
translations-panel-error-unsupported-hint-known = Sorry, we ondersteunen het { $language } nog niet.
translations-panel-error-unsupported-hint-unknown = Sorry, we ondersteunen deze taal nog niet.

## Each label is followed, on a new line, by a dropdown list of language names.
## If this structure is problematic for your locale, an alternative way is to
## translate them as `Source language:` and `Target language:`

translations-panel-from-label = Vertalen vanuit het
translations-panel-to-label = Vertalen naar het

## The translation panel appears from the url bar, and this view is the "restore" view
## that lets a user restore a page to the original language, or translate into another
## language.

# If your language requires declining the language name, a possible solution
# is to adapt the structure of the phrase, or use a support noun, e.g.
# `The page is translated from: { $fromLanguage }. Current target language: { $toLanguage }`
#
# Variables:
#   $fromLanguage (string) - The original language of the document.
#   $toLanguage (string) - The target language of the translation.
translations-panel-revisit-header = Deze pagina is van het { $fromLanguage } naar het { $toLanguage } vertaald
translations-panel-choose-language =
    .label = Kies een taal
translations-panel-restore-button =
    .label = Origineel tonen

## Waterfox Translations language management in about:preferences.

translations-manage-header = Vertalingen
translations-manage-settings-button =
    .label = Instellingen…
    .accesskey = t
translations-manage-description = Talen voor offline vertaling downloaden.
translations-manage-all-language = Alle talen
translations-manage-download-button = Downloaden
translations-manage-delete-button = Verwijderen
translations-manage-error-download = Er is een probleem opgetreden bij het downloaden van de taalbestanden. Probeer het opnieuw.
translations-manage-error-delete = Er is een probleem opgetreden bij het verwijderen van de taalbestanden. Probeer het opnieuw.
translations-manage-intro = Stel uw voorkeuren voor taal en websitevertaling in en beheer geïnstalleerde talen voor offline vertaling.
translations-manage-install-description = Talen voor offline vertaling installeren
translations-manage-language-install-button =
    .label = Installeren
translations-manage-language-install-all-button =
    .label = Alle installeren
    .accesskey = i
translations-manage-language-remove-button =
    .label = Verwijderen
translations-manage-language-remove-all-button =
    .label = Alle verwijderen
    .accesskey = w
translations-manage-error-install = Er is een probleem opgetreden bij het installeren van de taalbestanden. Probeer het opnieuw.
translations-manage-error-remove = Er is een probleem opgetreden bij het verwijderen van de taalbestanden. Probeer het opnieuw.
translations-manage-error-list = Kan de lijst met beschikbare talen voor vertaling niet ophalen. Vernieuw de pagina om het opnieuw te proberen.
translations-settings-title =
    .title = Vertaalinstellingen
    .style = min-width: 36em
translations-settings-close-key =
    .key = w
translations-settings-always-translate-langs-description = Voor de volgende talen zal de vertaling automatisch worden uitgevoerd
translations-settings-never-translate-langs-description = Voor de volgende talen zal geen vertaling worden aangeboden
translations-settings-never-translate-sites-description = Voor de volgende websites zal geen vertaling worden aangeboden
translations-settings-languages-column =
    .label = Talen
translations-settings-remove-language-button =
    .label = Taal verwijderen
    .accesskey = v
translations-settings-remove-all-languages-button =
    .label = Alle talen verwijderen
    .accesskey = e
translations-settings-sites-column =
    .label = Websites
translations-settings-remove-site-button =
    .label = Website verwijderen
    .accesskey = s
translations-settings-remove-all-sites-button =
    .label = Alle websites verwijderen
    .accesskey = b
translations-settings-close-dialog =
    .buttonlabelaccept = Sluiten
    .buttonaccesskeyaccept = S
