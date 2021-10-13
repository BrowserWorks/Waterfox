# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Strings used in about:unloads, allowing users to manage the "tab unloading"
### feature.

about-unloads-page-title = Tabs entladen
about-unloads-intro-1 =
    { -brand-short-name } enthält eine Funktion zum automatischen Entladen von Tabs,
    um zu verhindern, dass die Anwendung aufgrund von unzureichendem Speicher abstürzt,
    wenn der verfügbare Speicher des Systems knapp ist. Der nächste zu entladende Tab wird
    basierend auf mehreren Eigenschaften ausgewählt. Diese Seite zeigt, wie
    { -brand-short-name } Tabs priorisiert und welche Tabs entladen werden,
    wenn die Tab-Entladung ausgelöst wird.
about-unloads-intro-2 =
    Bestehende Tabs werden in der folgenden Tabelle in derselben Reihenfolge angezeigt,
    in der sie von { -brand-short-name } werden, um den nächsten Tab zum Entladen auszuwählen.
    Prozess-IDs werden in <strong>fett</strong> angezeigt, wenn sie den obersten Frame des Tabs
    enthalten, und in <em>kursiv</em>, wenn der Prozess zwischen verschiedenen Tabs geteilt wird.
    Sie können das Entladen des Tabs manuell auslösen, indem Sie unten auf die Schaltfläche
    <em>Entladen</em> klicken.
about-unloads-intro =
    { -brand-short-name } enthält eine Funktion zum automatischen Entladen von Tabs,
    um zu verhindern, dass die Anwendung aufgrund von unzureichendem Speicher abstürzt,
    wenn der verfügbare Speicher des Systems knapp ist. Der nächste zu entladende Tab wird
    basierend auf mehreren Eigenschaften ausgewählt. Diese Seite zeigt, wie
    { -brand-short-name } Tabs priorisiert und welche Tabs entladen werden,
    wenn die Tab-Entladung ausgelöst wird. Sie können das Entladen von Tabs manuell
    auslösen, indem Sie unten auf die <em>Entladen</em>-Schaltfläche klicken.
# The link points to a Waterfox documentation page, only available in English,
# with title "Tab Unloading"
about-unloads-learn-more =
    Siehe<a data-l10n-name="doc-link">Tabs entladen</a>, um mehr über
    diese Funktion und diese Seite zu erfahren.
about-unloads-last-updated = Zuletzt aktualisiert: { DATETIME($date, year: "numeric", month: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric", hour12: "false") }
about-unloads-button-unload = Entladen
    .title = Den Tab mit der höchsten Priorität entladen
about-unloads-no-unloadable-tab = Es gibt keine Tabs, die entladen werden können.
about-unloads-column-priority = Priorität
about-unloads-column-host = Host
about-unloads-column-last-accessed = Zuletzt zugegriffen
about-unloads-column-weight = Basisgewicht
    .title = Tabs werden zuerst nach diesem Wert sortiert, welcher sich aus besonderen Eigenschaften ableitet, z.B. ob der Tab Sound abspielt, WebRTC nutzt usw.
about-unloads-column-sortweight = Sekundärgewicht
    .title = Wenn verfügbar, werden Tabs nach diesem Wert sortiert, nachdem sie nach dem Basisgewicht sortiert wurden. Der Wert leitet sich vom Speicherverbrauch und der Anzahl Prozesse des Tabs ab.
about-unloads-column-memory = Arbeitsspeicher
    .title = Geschätzter Arbeitsspeicherverbrauch des Tabs
about-unloads-column-processes = Prozess-IDs
    .title = IDs der Prozesse, die den Tab-Inhalt enthalten
about-unloads-last-accessed = { DATETIME($date, year: "numeric", month: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric", hour12: "false") }
about-unloads-memory-in-mb = { NUMBER($mem, maxFractionalUnits: 2) } MB
about-unloads-memory-in-mb-tooltip =
    .title = { NUMBER($mem, maxFractionalUnits: 2) } MB
