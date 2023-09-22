# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# The button for "Waterfox Translations" in the url bar.
urlbar-translations-button =
    .tooltiptext = Oversæt denne side
# The button for "Waterfox Translations" in the url bar. Note that here "Beta" should
# not be translated, as it is a reflection of the un-localized BETA icon that is in the
# panel.
urlbar-translations-button2 =
    .tooltiptext = Oversæt denne side - Beta
# Note that here "Beta" should not be translated, as it is a reflection of the
# un-localized BETA icon that is in the panel.
urlbar-translations-button-intro =
    .tooltiptext = Prøv beta-versionen af oversættelse i { -brand-shorter-name }, der respekterer dit privatliv
# If your language requires declining the language name, a possible solution
# is to adapt the structure of the phrase, or use a support noun, e.g.
# `Page translated from: { $fromLanguage }. Current target language: { $toLanguage }`
#
# Variables:
#   $fromLanguage (string) - The original language of the document.
#   $toLanguage (string) - The target language of the translation.
urlbar-translations-button-translated =
    .tooltiptext = Side oversat fra { $fromLanguage } til { $toLanguage }
urlbar-translations-button-loading =
    .tooltiptext = Oversættelse i gang
translations-panel-settings-button =
    .aria-label = Håndter indstillinger for oversættelse
# Text displayed on a language dropdown when the language is in beta
# Variables:
#   $language (string) - The localized display name of the detected language
translations-panel-displayname-beta =
    .label = { $language } BETA

## Options in the Waterfox Translations settings.

translations-panel-settings-manage-languages =
    .label = Håndter sprog
translations-panel-settings-about = Om oversættelser i { -brand-shorter-name }
translations-panel-settings-about2 =
    .label = Om oversættelser i { -brand-shorter-name }
# Text displayed for the option to always translate a given language
# Variables:
#   $language (string) - The localized display name of the detected language
translations-panel-settings-always-translate-language =
    .label = Oversæt altid { $language }
translations-panel-settings-always-translate-unknown-language =
    .label = Oversæt altid dette sprog
translations-panel-settings-always-offer-translation =
    .label = Tilbyd altid at oversætte
# Text displayed for the option to never translate a given language
# Variables:
#   $language (string) - The localized display name of the detected language
translations-panel-settings-never-translate-language =
    .label = Oversæt aldrig { $language }
translations-panel-settings-never-translate-unknown-language =
    .label = Oversæt aldrig dette sprog
# Text displayed for the option to never translate this website
translations-panel-settings-never-translate-site =
    .label = Oversæt aldrig dette websted

## The translation panel appears from the url bar, and this view is the default
## translation view.

translations-panel-header = Oversæt siden?
translations-panel-translate-button =
    .label = Oversæt
translations-panel-translate-button-loading =
    .label = Vent venligst…
translations-panel-translate-cancel =
    .label = Annuller
translations-panel-learn-more-link = Læs mere
translations-panel-intro-header = Prøv oversættelse, der respekterer dit privatliv, i { -brand-shorter-name }
translations-panel-intro-description = For at beskytte dit privatliv forlader oversættelserne aldrig din enhed. Nye sprog og andre forbedringer kommer snart!
translations-panel-error-translating = Der opstod et problem med at oversætte. Prøv igen.
translations-panel-error-load-languages = Kunne ikke indlæse sprog
translations-panel-error-load-languages-hint = Kontroller din internetforbindelse og prøv igen.
translations-panel-error-load-languages-hint-button =
    .label = Prøv igen
translations-panel-error-unsupported = Der er ingen tilgængelig oversættelse af siden
translations-panel-error-dismiss-button =
    .label = Forstået
translations-panel-error-change-button =
    .label = Skift kildesprog
# If your language requires declining the language name, a possible solution
# is to adapt the structure of the phrase, or use a support noun, e.g.
# `Sorry, we don't support the language yet: { $language }
#
# Variables:
#   $language (string) - The language of the document.
translations-panel-error-unsupported-hint-known = Beklager, vi understøtter ikke { $language } endnu.
translations-panel-error-unsupported-hint-unknown = Beklager, vi understøtter ikke dette sprog endnu.

## Each label is followed, on a new line, by a dropdown list of language names.
## If this structure is problematic for your locale, an alternative way is to
## translate them as `Source language:` and `Target language:`

translations-panel-from-label = Oversæt fra
translations-panel-to-label = Oversæt til

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
translations-panel-revisit-header = Denne side er oversat fra { $fromLanguage } til { $toLanguage }
translations-panel-choose-language =
    .label = Vælg et sprog
translations-panel-restore-button =
    .label = Vis oprindelig

## Waterfox Translations language management in about:preferences.

translations-manage-header = Oversættelser
translations-manage-settings-button =
    .label = Indstillinger…
    .accesskey = t
translations-manage-description = Hent sprog til oversættelse offline.
translations-manage-all-language = Alle sprog
translations-manage-download-button = Hent
translations-manage-delete-button = Slet
translations-manage-error-download = Der opstod et problem med at hente sprogfilerne. Prøv igen.
translations-manage-error-delete = Der opstod en fejl under sletningen af sprogfilerne. Prøv igen.
translations-manage-intro = Vælg dit sprog, indstillinger for oversættelser af websteder og håndter sprog installeret til brug for oversættelse offline.
translations-manage-install-description = Installer sprog til offline oversættelse
translations-manage-language-install-button =
    .label = Installer
translations-manage-language-install-all-button =
    .label = Installer alle
    .accesskey = a
translations-manage-language-remove-button =
    .label = Fjern
translations-manage-language-remove-all-button =
    .label = Fjern alle
    .accesskey = e
translations-manage-error-install = Der opstod et problem med at installere sprogfilerne. Prøv igen.
translations-manage-error-remove = Der opstod en fejl med at fjerne sprogfilerne. Prøv igen.
translations-manage-error-list = Kunne ikke hente listen med tilgængelige sprog til oversættelse. Genindlæs siden for at prøve igen.
translations-settings-title =
    .title = Oversættelses-indstillinger
    .style = min-width: 36em
translations-settings-close-key =
    .key = w
translations-settings-always-translate-langs-description = Oversættelse vil ske automatisk for følgende sprog
translations-settings-never-translate-langs-description = Oversættelse vil ikke blive tilbudt for de følgende sprog
translations-settings-never-translate-sites-description = Oversættelse vil ikke blive tilbudt for de følgende websteder
translations-settings-languages-column =
    .label = Sprog
translations-settings-remove-language-button =
    .label = Fjern sprog
    .accesskey = F
translations-settings-remove-all-languages-button =
    .label = Fjern alle sprog
    .accesskey = a
translations-settings-sites-column =
    .label = Websteder
translations-settings-remove-site-button =
    .label = Fjern websted
    .accesskey = j
translations-settings-remove-all-sites-button =
    .label = Fjern alle websteder
    .accesskey = e
translations-settings-close-dialog =
    .buttonlabelaccept = Luk
    .buttonaccesskeyaccept = L
