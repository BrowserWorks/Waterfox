# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

webpage-languages-window =
    .title = Jazyk webových stránek
    .style = width: 40em

languages-close-key =
    .key = w

languages-description = Webové stránky jsou někdy k dispozici v několika jazycích. Zvolte jazyky v takovém pořadí, v jakém se mají používat pro zobrazování webových stránek

languages-customize-spoof-english =
    .label = Požadovat anglické verze webových stránek pro vyšší úroveň soukromí

languages-customize-moveup =
    .label = Posunout výše
    .accesskey = u

languages-customize-movedown =
    .label = Posunout níže
    .accesskey = n

languages-customize-remove =
    .label = Odebrat
    .accesskey = r

languages-customize-select-language =
    .placeholder = Zvolte jazyk…

languages-customize-add =
    .label = Přidat
    .accesskey = a

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
    .label = { $locale } [{ $code }]

languages-active-code-format =
    .value = { languages-code-format.label }

browser-languages-window =
    .title =
        Jazyk { -brand-short-name.gender ->
            [masculine] { -brand-short-name(case: "gen") }
            [feminine] { -brand-short-name(case: "gen") }
            [neuter] { -brand-short-name(case: "gen") }
           *[other] aplikace { -brand-short-name }
        }
    .style = width: 40em

browser-languages-description = { -brand-short-name } zobrazí své uživatelské rozhraní v prvním vybraném jazyce. Ostatní použije jen pokud bude potřeba, a to ve vybraném pořadí.

browser-languages-search = Najít další jazyky…

browser-languages-searching =
    .label = Hledání jazyků…

browser-languages-downloading =
    .label = Stahování…

browser-languages-select-language =
    .label = Zvolte jazyk, který chcete přidat…
    .placeholder = Zvolte jazyk, který chcete přidat…

browser-languages-installed-label = Nainstalované jazyky
browser-languages-available-label = Dostupné jazyky

browser-languages-error = { -brand-short-name } nyní nemůže aktualizovat seznam jazyků. Zkontrolujte internetové připojení a zkuste to znovu.
