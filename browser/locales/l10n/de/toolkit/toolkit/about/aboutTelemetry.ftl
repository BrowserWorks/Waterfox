# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = Datensatz auswählen:
about-telemetry-show-current-data = Datensatz in Aufzeichnung
about-telemetry-show-archived-ping-data = Archivierte Datensätze
about-telemetry-show-subsession-data = Untersitzungsdaten anzeigen
about-telemetry-choose-ping = Datensatz auswählen:
about-telemetry-archive-ping-type = Datensatz-Typ
about-telemetry-archive-ping-header = Datensatz
about-telemetry-option-group-today = Heute
about-telemetry-option-group-yesterday = Gestern
about-telemetry-option-group-older = Älter
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = Telemetrie-Daten
about-telemetry-current-store = Aktueller Speicher: 
about-telemetry-more-information = Weitere Informationen:
about-telemetry-firefox-data-doc = Die <a data-l10n-name="data-doc-link">Dokumentation von Waterfox-Daten</a> enthält Anleitungen zur Verwendung unserer Datenwerkzeuge.
about-telemetry-telemetry-client-doc = Die <a data-l10n-name="client-doc-link">Dokumentation des Telemetrie-Clients von Waterfox</a> enthält Definitionen von Konzepten, API-Dokumentationen und Erläuterungen zu den Daten.
about-telemetry-telemetry-dashboard = Die <a data-l10n-name="dashboard-link">Telemetrie-Übersicht</a> ermöglicht die Visualisierung der Daten, welche Waterfox mittels der Telemetrie empfängt.
about-telemetry-telemetry-probe-dictionary = Das <a data-l10n-name="probe-dictionary-link">Messgrößen-Wörterbuch</a> bietet Beschreibungen und Details zu den von Telemetrie gesammelten Daten.
about-telemetry-show-in-Waterfox-json-viewer = In JSON-Ansicht öffnen
about-telemetry-home-section = Einführung
about-telemetry-general-data-section = Allgemeine Daten
about-telemetry-environment-data-section = Umgebungsdaten
about-telemetry-session-info-section = Sitzungsinformationen
about-telemetry-scalar-section = Skalare
about-telemetry-keyed-scalar-section = Schlüsselgebundene Skalare
about-telemetry-histograms-section = Histogramme
about-telemetry-keyed-histogram-section = Schlüsselgebundene Histogramme
about-telemetry-events-section = Ereignisse
about-telemetry-simple-measurements-section = Einfache Messdaten
about-telemetry-slow-sql-section = Langsame SQL-Befehle
about-telemetry-addon-details-section = Add-on-Details
about-telemetry-captured-stacks-section = Aufgezeichnete Aufruflisten
about-telemetry-late-writes-section = Späte Schreibvorgänge
about-telemetry-raw-payload-section = Unformatiertes Datenpaket
about-telemetry-raw = Reines JSON
about-telemetry-full-sql-warning = HINWEIS: Das Debuggen langsamer SQL-Befehle ist aktiv. Es können vollständige SQL-Befehle weiter unten angezeigt werden, diese werden aber nicht durch die Telemetrie übertragen.
about-telemetry-fetch-stack-symbols = Funktionsname für Aufruflisten aufrufen
about-telemetry-hide-stack-symbols = Unformatierte Aufruflisten anzeigen
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] Daten über eine stabile Version
       *[prerelease] erweiterte Daten über eine Entwicklerversion
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] aktiviert
       *[disabled] deaktiviert
    }
# Example Output: 1 sample, average = 0, sum = 0
# Variables:
#   $sampleCount (Integer): amount of histogram samples
#   $prettyAverage (Integer): average of histogram samples
#   $sum (Integer): sum of histogram samples
about-telemetry-histogram-stats = 
    { $sampleCount ->
        [one] { $sampleCount } Messung, Durchschnitt = { $prettyAverage }, Summe = { $sum }
       *[other] { $sampleCount } Messungen, Durchschnitt = { $prettyAverage }, Summe = { $sum }
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Waterfox"
about-telemetry-page-subtitle = Diese Seite zeigt durch Telemetrie gesammelte Informationen über Performanz, Hardware, Benutzung und vom Benutzer gemachte Änderungen an. Diese Informationen werden an { $telemetryServerOwner } gesendet, um { -brand-full-name } zu verbessern.
about-telemetry-settings-explanation = Telemetrie sammelt { about-telemetry-data-type } und das Hochladen ist <a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a>.
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = Jede Information wird als "<a data-l10n-name="ping-link">Datensatz</a>" verpackt gesendet. Dies ist der Datensatz { $name }, { $timestamp }.
about-telemetry-data-details-current = Jede Information wird als "<a data-l10n-name="ping-link">Datensatz</a>" verpackt gesendet. Dies ist der aktuelle Datensatz.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = In { $selectedTitle } suchen
about-telemetry-filter-all-placeholder =
    .placeholder = In alle Abschnitten suchen
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = Übereinstimmungen für "{ $searchTerms }"
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = Keine Übereinstimmungen für "{ $currentSearchText }" in { $sectionName }
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = Keine Übereinstimmungen für "{ $searchTerms }" in allen Abschnitten
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = Keine Daten in "{ $sectionName }" vorhanden
# used as a tooltip for the “current” ping title in the sidebar
about-telemetry-current-data-sidebar = aktueller Datensatz
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = alle
# button label to copy the histogram
about-telemetry-histogram-copy = Kopieren
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = Langsame SQL-Befehle auf Haupt-Thread
about-telemetry-slow-sql-other = Langsame SQL-Befehle auf Hilfs-Thread
about-telemetry-slow-sql-hits = Aufrufe
about-telemetry-slow-sql-average = Durchschnittliche Zeit (ms)
about-telemetry-slow-sql-statement = Befehl
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = Add-on-ID
about-telemetry-addon-table-details = Details
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = Vom Typ { $addonProvider }
about-telemetry-keys-header = Eigenschaft
about-telemetry-names-header = Name
about-telemetry-values-header = Wert
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (Anzahl der Aufzeichnungen: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = Später Schreibvorgang { $lateWriteCount }
about-telemetry-stack-title = Aufrufliste:
about-telemetry-memory-map-title = Speichernutzung:
about-telemetry-error-fetching-symbols = Beim Abrufen der Symbole trat ein Fehler auf. Überprüfen Sie die Internetverbindung und versuchen Sie es erneut.
about-telemetry-time-stamp-header = Zeitstempel
about-telemetry-category-header = Kategorie
about-telemetry-method-header = Methode
about-telemetry-object-header = Objekt
about-telemetry-extra-header = Zusatz
about-telemetry-origin-section = Quellen-Telemetrie
about-telemetry-origin-origin = Quelle
about-telemetry-origin-count = Anzahl
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Waterfox"
about-telemetry-origins-explanation = Die <a data-l10n-name="origin-doc-link">Quellen-Telemetrie von Waterfox</a> kodiert Daten vor dem Senden, sodass { $telemetryServerOwner } etwas zählen aber nicht bestimmen kann, ob eine bestimmte { -brand-product-name }-Installation zu der Zählung beigetragen hat. <a data-l10n-name="prio-blog-link">Weitere Informationen</a>
# Variables:
#  $process (String): type of process in subsection headers ( e.g. "content", "parent" )
about-telemetry-process = { $process }-Prozess
