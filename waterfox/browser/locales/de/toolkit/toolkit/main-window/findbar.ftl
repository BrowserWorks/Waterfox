# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### This file contains the entities needed to use the Find Bar.

findbar-next =
    .tooltiptext = Das nächste Vorkommen des Ausdrucks suchen
findbar-previous =
    .tooltiptext = Das vorherige Vorkommen des Ausdrucks suchen

findbar-find-button-close =
    .tooltiptext = Suchleiste schließen

findbar-highlight-all2 =
    .label = Alle hervorheben
    .accesskey =
        { PLATFORM() ->
            [macos] v
           *[other] v
        }
    .tooltiptext = Jedes Vorkommen des Ausdrucks im Text hervorheben

findbar-case-sensitive =
    .label = Groß-/Kleinschreibung
    .accesskey = G
    .tooltiptext = Bei der Suche zwischen Groß- und Kleinschreibung unterscheiden

findbar-match-diacritics =
    .label = Akzente
    .accesskey = z
    .tooltiptext = Bei der Suche zwischen akzentuierten (é) und nicht-akzentuierten (e) Buchstaben unterscheiden

findbar-entire-word =
    .label = Ganze Wörter
    .accesskey = W
    .tooltiptext = Nur nach vollständig übereinstimmenden Wörtern suchen

findbar-not-found = Ausdruck nicht gefunden

findbar-wrapped-to-top = Das Seitenende wurde erreicht, Suche vom Seitenanfang fortgesetzt
findbar-wrapped-to-bottom = Der Seitenanfang wurde erreicht, Suche vom Seitenende fortgesetzt

findbar-normal-find =
    .placeholder = Seite durchsuchen
findbar-fast-find =
    .placeholder = Suchen
findbar-fast-find-links =
    .placeholder = Suchen (nur Links)

findbar-case-sensitive-status =
    .value = (Groß-/Kleinschreibung)
findbar-match-diacritics-status =
    .value = (Akzentzeichen berücksichtigen)
findbar-entire-word-status =
    .value = (Nur ganze Wörter)

# Variables:
#   $current (Number): Index of the currently selected match
#   $total (Number): Total count of matches
findbar-found-matches =
    .value =
        { $total ->
            [one] { $current } von { $total } Übereinstimmung
           *[other] { $current } von { $total } Übereinstimmungen
        }

# Variables:
#   $limit (Number): Total count of matches allowed before counting stops
findbar-found-matches-count-limit =
    .value =
        { $limit ->
            [one] Mehr als { $limit } Übereinstimmung
           *[other] Mehr als { $limit } Übereinstimmungen
        }
