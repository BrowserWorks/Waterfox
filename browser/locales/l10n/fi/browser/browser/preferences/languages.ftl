# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

webpage-languages-window =
    .title = Verkkosivujen kieliasetukset
    .style = width: 40em

languages-close-key =
    .key = w

languages-description = Sivuista on joskus useammankielisiä versioita. Järjestä kielet niin, että ensimmäisenä on mieluiten lukemasi kieli

languages-customize-spoof-english =
    .label = Pyydä englanninkieliset versiot verkkosivuista yksityisyyden vuoksi

languages-customize-moveup =
    .label = Siirrä ylös
    .accesskey = y

languages-customize-movedown =
    .label = Siirrä alas
    .accesskey = a

languages-customize-remove =
    .label = Poista
    .accesskey = P

languages-customize-select-language =
    .placeholder = Valitse lisättävä kieli…

languages-customize-add =
    .label = Lisää
    .accesskey = L

# The pattern used to generate strings presented to the user in the
# locale selection list.
#
# Example:
#   Icelandic [is]
#   Spanish (Chile) [es-CL]
#
# Variables:
#   $locale (String) - A name of the locale (for example: "Icelandic", "Spanish (Chile)")
#   $code (String) - Locale code of the locale (for example: "is", "es-CL")
languages-code-format =
    .label = { $locale }  [{ $code }]

languages-active-code-format =
    .value = { languages-code-format.label }

browser-languages-window =
    .title = { -brand-short-name }in kieliasetukset
    .style = width: 40em

browser-languages-description = { -brand-short-name } käyttää ensimmäistä kieltä oletuksena ja muita kieliä tarvittaessa, alla olevassa järjestyksessä.

browser-languages-search = Etsi lisää kieliä…

browser-languages-searching =
    .label = Etsitään kieliä…

browser-languages-downloading =
    .label = Ladataan…

browser-languages-select-language =
    .label = Valitse lisättävä kieli…
    .placeholder = Valitse lisättävä kieli…

browser-languages-installed-label = Asennetut kielet
browser-languages-available-label = Saatavilla olevat kielet

browser-languages-error = { -brand-short-name } ei voi päivittää kieliä juuri nyt. Varmista, että yhteys internetiin toimii tai yritä uudestaan.
