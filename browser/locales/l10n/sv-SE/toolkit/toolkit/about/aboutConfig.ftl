# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

config-window =
    .title = about:config

## Strings used to display a warning in about:config

# This text should be attention grabbing and playful
config-about-warning-title =
    .value = Varning, farligt verktyg!
config-about-warning-text = Att ändra dessa avancerade inställningar kan skada programmets stabilitet, säkerhet och prestanda. Du bör endast fortsätta om du är säker på vad du gör.
config-about-warning-button =
    .label = Jag godtar risken!
config-about-warning-checkbox =
    .label = Visa denna varning nästa gång

config-search-prefs =
    .value = Sök:
    .accesskey = ö

config-focus-search =
    .key = r

config-focus-search-2 =
    .key = f

## These strings are used for column headers

config-pref-column =
    .label = Inställningsnamn
config-lock-column =
    .label = Status
config-type-column =
    .label = Typ
config-value-column =
    .label = Värde

## These strings are used for tooltips

config-pref-column-header =
    .tooltip = Klicka för att ordna
config-column-chooser =
    .tooltip = Klicka för att välja kolumner att visa

## These strings are used for the context menu

config-copy-pref =
    .key = C
    .label = Kopiera
    .accesskey = o

config-copy-name =
    .label = Kopiera namn
    .accesskey = K

config-copy-value =
    .label = Kopiera värde
    .accesskey = v

config-modify =
    .label = Modifiera
    .accesskey = M

config-toggle =
    .label = Växla
    .accesskey = x

config-reset =
    .label = Återställ
    .accesskey = Å

config-new =
    .label = Ny
    .accesskey = N

config-string =
    .label = Sträng
    .accesskey = S

config-integer =
    .label = Heltal
    .accesskey = H

config-boolean =
    .label = Boolesk
    .accesskey = B

config-default = standard
config-modified = ändrad
config-locked = låst

config-property-string = sträng
config-property-int = heltal
config-property-bool = boolesk

config-new-prompt = Ange namnet på inställningen

config-nan-title = Ogiltigt värde
config-nan-text = Texten som skrevs in är inte ett nummer.

# Variables:
#   $type (String): type of value (boolean, integer or string)
config-new-title = Ny { $type }-inställning

# Variables:
#   $type (String): type of value (boolean, integer or string)
config-modify-title = Ange { $type }-värdet
