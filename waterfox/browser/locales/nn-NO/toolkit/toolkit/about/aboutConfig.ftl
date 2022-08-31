# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

config-window =
    .title = about:config

## Strings used to display a warning in about:config

# This text should be attention grabbing and playful
config-about-warning-title =
    .value = Hald fram med varsemd. Du kan bryte garantien!
config-about-warning-text = Dersom du endrar disse avanserte innstillingane kan det verka negativt på tryggleik, stabilitet og yting i dette programmet. Hald fram berre dersom du veit kva du gjer.
config-about-warning-button =
    .label = Eg tek risikoen!
config-about-warning-checkbox =
    .label = Vis denne åtvaringa neste gong òg

config-search-prefs =
    .value = Søk:
    .accesskey = S

config-focus-search =
    .key = r

config-focus-search-2 =
    .key = f

## These strings are used for column headers

config-pref-column =
    .label = Innstiling
config-lock-column =
    .label = Status
config-type-column =
    .label = Type
config-value-column =
    .label = Verdi

## These strings are used for tooltips

config-pref-column-header =
    .tooltip = Trykk her for å sortere
config-column-chooser =
    .tooltip = Trykk her for å velja kolonner som skal visast

## These strings are used for the context menu

config-copy-pref =
    .key = C
    .label = Kopier
    .accesskey = K

config-copy-name =
    .label = Kopier namn
    .accesskey = o

config-copy-value =
    .label = Kopier verdi
    .accesskey = v

config-modify =
    .label = Endra
    .accesskey = E

config-toggle =
    .label = Slå av/på
    .accesskey = a

config-reset =
    .label = Standard
    .accesskey = S

config-new =
    .label = Ny
    .accesskey = N

config-string =
    .label = Streng
    .accesskey = S

config-integer =
    .label = Heiltal
    .accesskey = H

config-boolean =
    .label = Boolsk
    .accesskey = B

config-default = standard
config-modified = endra
config-locked = låst

config-property-string = streng
config-property-int = tal
config-property-bool = boolsk

config-new-prompt = Skriv inn namnet på innstilling

config-nan-title = Ugyldig verdi
config-nan-text = Teksten du skreiv inn er ikkje eit tal

# Variables:
#   $type (String): type of value (boolean, integer or string)
config-new-title = Ny { $type } verdi

# Variables:
#   $type (String): type of value (boolean, integer or string)
config-modify-title = Skriv inn { $type } verdi
