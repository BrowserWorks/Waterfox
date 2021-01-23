# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

config-window =
    .title = about:config

## Strings used to display a warning in about:config

# This text should be attention grabbing and playful
config-about-warning-title =
    .value = Huomio, vaarallinen sivu edessä!
config-about-warning-text = Tällä sivulla olevien asetusten muuttamisella voi olla vahingollisia vaikutuksia tämän ohjelman turvallisuuteen, vakauteen ja suorituskykyyn. Älä koske näihin asetuksiin ellet tiedä tarkalleen, mitä olet tekemässä.
config-about-warning-button =
    .label = Otan riskin!
config-about-warning-checkbox =
    .label = Näytä varoitus myös ensi kerralla

config-search-prefs =
    .value = Etsi:
    .accesskey = E

config-focus-search =
    .key = r

config-focus-search-2 =
    .key = f

## These strings are used for column headers

config-pref-column =
    .label = Asetuksen nimi
config-lock-column =
    .label = Tila
config-type-column =
    .label = Tyyppi
config-value-column =
    .label = Arvo

## These strings are used for tooltips

config-pref-column-header =
    .tooltip = Napsauta järjestääksesi
config-column-chooser =
    .tooltip = Valitse näkyvät sarakkeet

## These strings are used for the context menu

config-copy-pref =
    .key = C
    .label = Kopioi
    .accesskey = K

config-copy-name =
    .label = Kopioi nimi
    .accesskey = o

config-copy-value =
    .label = Kopioi arvo
    .accesskey = a

config-modify =
    .label = Muuta
    .accesskey = M

config-toggle =
    .label = Vaihda tilaa
    .accesskey = V

config-reset =
    .label = Palauta oletusarvo
    .accesskey = P

config-new =
    .label = Uusi
    .accesskey = U

config-string =
    .label = Merkkijono
    .accesskey = M

config-integer =
    .label = Kokonaisluku
    .accesskey = K

config-boolean =
    .label = Totuusarvo
    .accesskey = T

config-default = oletus
config-modified = muutettu
config-locked = lukittu

config-property-string = merkkijono
config-property-int = kokonaisluku
config-property-bool = totuusarvo

config-new-prompt = Kirjoita asetuksen nimi

config-nan-title = Virheellinen arvo
config-nan-text = Kirjoittamasi merkkijono ei ole numero.

# Variables:
#   $type (String): type of value (boolean, integer or string)
config-new-title = Uusi { $type }

# Variables:
#   $type (String): type of value (boolean, integer or string)
config-modify-title = Kirjoita { $type }
