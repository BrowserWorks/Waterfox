# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

config-window =
    .title = about:config

## Strings used to display a warning in about:config

# This text should be attention grabbing and playful
config-about-warning-title =
    .value = Hier endet möglicherweise die Gewährleistung!
config-about-warning-text = Änderungen der Standardwerte dieser erweiterten Einstellungen können gefährlich für Stabilität, Sicherheit und Geschwindigkeit dieser Anwendung sein. Sie sollten nur fortfahren, wenn Sie genau wissen, was Sie tun.
config-about-warning-button =
    .label = Ich bin mir der Gefahren bewusst!
config-about-warning-checkbox =
    .label = Diese Meldung beim nächsten Mal anzeigen

config-search-prefs =
    .value = Suchen:
    .accesskey = S

config-focus-search =
    .key = r

config-focus-search-2 =
    .key = f

## These strings are used for column headers

config-pref-column =
    .label = Einstellungsname
config-lock-column =
    .label = Status
config-type-column =
    .label = Typ
config-value-column =
    .label = Wert

## These strings are used for tooltips

config-pref-column-header =
    .tooltip = Klicken zum Sortieren
config-column-chooser =
    .tooltip = Klicken Sie, um die anzuzeigenden Spalten auszuwählen

## These strings are used for the context menu

config-copy-pref =
    .key = C
    .label = Kopieren
    .accesskey = K

config-copy-name =
    .label = Namen kopieren
    .accesskey = o

config-copy-value =
    .label = Wert kopieren
    .accesskey = W

config-modify =
    .label = Bearbeiten
    .accesskey = e

config-toggle =
    .label = Umschalten
    .accesskey = U

config-reset =
    .label = Zurücksetzen
    .accesskey = r

config-new =
    .label = Neu
    .accesskey = N

config-string =
    .label = String
    .accesskey = S

config-integer =
    .label = Integer
    .accesskey = I

config-boolean =
    .label = Boolean
    .accesskey = B

config-default = Standard
config-modified = geändert
config-locked = gesperrt

config-property-string = string
config-property-int = integer
config-property-bool = boolean

config-new-prompt = Geben Sie den Eigenschaftsnamen ein

config-nan-title = Ungültiger Wert
config-nan-text = Der Text, den Sie eingegeben haben, ist keine Zahl.

# Variables:
#   $type (String): type of value (boolean, integer or string)
config-new-title = Neuer { $type }-Wert

# Variables:
#   $type (String): type of value (boolean, integer or string)
config-modify-title = Geben Sie einen { $type }-Wert ein
