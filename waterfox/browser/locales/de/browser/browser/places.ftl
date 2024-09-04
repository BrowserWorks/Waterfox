# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this file,
# You can obtain one at http://mozilla.org/MPL/2.0/.

places-open =
    .label = Öffnen
    .accesskey = Ö
places-open-in-tab =
    .label = In neuem Tab öffnen
    .accesskey = T
places-open-in-container-tab =
    .label = In neuem Tab in Umgebung öffnen
    .accesskey = U
places-open-all-bookmarks =
    .label = Alle Lesezeichen öffnen
    .accesskey = z
places-open-all-in-tabs =
    .label = Alle in Tabs öffnen
    .accesskey = ö
places-open-in-window =
    .label = In neuem Fenster öffnen
    .accesskey = F
places-open-in-private-window =
    .label = In neuem privaten Fenster öffnen
    .accesskey = p

places-empty-bookmarks-folder =
    .label = (Leer)

places-add-bookmark =
    .label = Lesezeichen hinzufügen…
    .accesskey = L
places-add-folder-contextmenu =
    .label = Ordner hinzufügen…
    .accesskey = O
places-add-folder =
    .label = Ordner hinzufügen…
    .accesskey = O
places-add-separator =
    .label = Trennlinie hinzufügen
    .accesskey = r

places-view =
    .label = Sortieren
    .accesskey = o
places-by-date =
    .label = Nach Datum
    .accesskey = D
places-by-site =
    .label = Nach Website
    .accesskey = S
places-by-most-visited =
    .label = Nach meistbesucht
    .accesskey = m
places-by-last-visited =
    .label = Nach zuletzt besucht
    .accesskey = z
places-by-day-and-site =
    .label = Nach Datum und Website
    .accesskey = h

places-history-search =
    .placeholder = Chronik durchsuchen
places-history =
    .aria-label = Chronik
places-bookmarks-search =
    .placeholder = Lesezeichen durchsuchen

places-delete-domain-data =
    .label = Gesamte Website vergessen
    .accesskey = v
places-sortby-name =
    .label = Nach Name sortieren
    .accesskey = r
# places-edit-bookmark and places-edit-generic will show one or the other and can have the same access key.
places-edit-bookmark =
    .label = Lesezeichen bearbeiten…
    .accesskey = b
places-edit-generic =
    .label = Bearbeiten…
    .accesskey = B
places-edit-folder2 =
    .label = Ordner bearbeiten…
    .accesskey = b
places-delete-folder =
    .label =
        { $count ->
            [1] Ordner löschen
           *[other] Ordner löschen
        }
    .accesskey = s
# Variables:
#   $count (number) - The number of pages selected for removal.
places-delete-page =
    .label =
        { $count ->
            [1] Seite entfernen
           *[other] Seiten entfernen
        }
    .accesskey = e

# Managed bookmarks are created by an administrator and cannot be changed by the user.
managed-bookmarks =
    .label = Verwaltete Lesezeichen
# This label is used when a managed bookmarks folder doesn't have a name.
managed-bookmarks-subfolder =
    .label = Unterordner

# This label is used for the "Other Bookmarks" folder that appears in the bookmarks toolbar.
other-bookmarks-folder =
    .label = Weitere Lesezeichen

places-show-in-folder =
    .label = In Ordner anzeigen
    .accesskey = O

# Variables:
# $count (number) - The number of elements being selected for removal.
places-delete-bookmark =
    .label =
        { $count ->
            [1] Lesezeichen löschen
           *[other] Lesezeichen löschen
        }
    .accesskey = s

# Variables:
#   $count (number) - The number of bookmarks being added.
places-create-bookmark =
    .label =
        { $count ->
            [1] Lesezeichen für Seiten hinzufügen…
           *[other] Lesezeichen für Seiten hinzufügen…
        }
    .accesskey = L

places-untag-bookmark =
    .label = Schlagwort entfernen
    .accesskey = e

places-manage-bookmarks =
    .label = Lesezeichen verwalten
    .accesskey = v

places-forget-about-this-site-confirmation-title = Diese Website vergessen

# Variables:
# $hostOrBaseDomain (string) - The base domain (or host in case there is no base domain) for which data is being removed
places-forget-about-this-site-confirmation-msg = Diese Aktion entfernt Daten, die sich auf { $hostOrBaseDomain } beziehen, einschließlich Chronik, Cookies, Cache und Inhaltseinstellungen. Zugehörige Lesezeichen und Passwörter werden nicht entfernt. Sind Sie sicher, dass Sie fortfahren möchten?

places-forget-about-this-site-forget = Vergessen

places-library3 =
    .title = Bibliothek

places-organize-button =
    .label = Verwalten
    .tooltiptext = Lesezeichen verwalten
    .accesskey = V

places-organize-button-mac =
    .label = Verwalten
    .tooltiptext = Lesezeichen verwalten

places-file-close =
    .label = Schließen
    .accesskey = c

places-cmd-close =
    .key = w

places-view-button =
    .label = Ansichten
    .tooltiptext = Ansicht ändern
    .accesskey = A

places-view-button-mac =
    .label = Ansichten
    .tooltiptext = Ansicht ändern

places-view-menu-columns =
    .label = Spalten anzeigen
    .accesskey = p

places-view-menu-sort =
    .label = Sortieren
    .accesskey = s

places-view-sort-unsorted =
    .label = Unsortiert
    .accesskey = U

places-view-sort-ascending =
    .label = Aufsteigend
    .accesskey = A

places-view-sort-descending =
    .label = Absteigend
    .accesskey = b

places-maintenance-button =
    .label = Importieren und Sichern
    .tooltiptext = Lesezeichen importieren und sichern
    .accesskey = I

places-maintenance-button-mac =
    .label = Importieren und Sichern
    .tooltiptext = Lesezeichen importieren und sichern

places-cmd-backup =
    .label = Sichern…
    .accesskey = S

places-cmd-restore =
    .label = Wiederherstellen
    .accesskey = W

places-cmd-restore-from-file =
    .label = Datei wählen…
    .accesskey = D

places-import-bookmarks-from-html =
    .label = Lesezeichen von HTML importieren…
    .accesskey = L

places-export-bookmarks-to-html =
    .label = Lesezeichen nach HTML exportieren…
    .accesskey = n

places-import-other-browser =
    .label = Daten aus einem anderen Browser importieren…
    .accesskey = D

places-view-sort-col-name =
    .label = Name

places-view-sort-col-tags =
    .label = Schlagwörter

places-view-sort-col-url =
    .label = Adresse

places-view-sort-col-most-recent-visit =
    .label = Zuletzt besucht

places-view-sort-col-visit-count =
    .label = Meistbesucht

places-view-sort-col-date-added =
    .label = Hinzugefügt

places-view-sort-col-last-modified =
    .label = Zuletzt verändert

places-view-sortby-name =
    .label = Sortieren nach Name
    .accesskey = N
places-view-sortby-url =
    .label = Sortieren nach Adresse
    .accesskey = r
places-view-sortby-date =
    .label = Sortieren nach zuletzt besucht
    .accesskey = z
places-view-sortby-visit-count =
    .label = Sortieren nach meistbesucht
    .accesskey = o
places-view-sortby-date-added =
    .label = Sortieren nach hinzugefügt
    .accesskey = h
places-view-sortby-last-modified =
    .label = Sortieren nach zuletzt geändert
    .accesskey = d
places-view-sortby-tags =
    .label = Sortieren nach Schlagwörtern
    .accesskey = w

places-cmd-find-key =
    .key = f

places-back-button =
    .tooltiptext = Eine Seite zurück

places-forward-button =
    .tooltiptext = Eine Seite vor

places-details-pane-select-an-item-description = Wählen Sie einen Eintrag, um seine Eigenschaften zu sehen und zu bearbeiten

places-details-pane-no-items =
    .value = Keine Einträge
# Variables:
#   $count (Number): number of items
places-details-pane-items-count =
    .value =
        { $count ->
            [one] Ein Eintrag
           *[other] { $count } Einträge
        }

## Strings used as a placeholder in the Library search field. For example,
## "Search History" stands for "Search through the browser's history".

places-search-bookmarks =
    .placeholder = Lesezeichen durchsuchen
places-search-history =
    .placeholder = Chronik durchsuchen
places-search-downloads =
    .placeholder = Downloads durchsuchen

##

places-locked-prompt = Das Lesezeichen- und Chronik-System wird nicht funktionieren, da eine der Dateien von { -brand-short-name } von einer anderen Anwendung verwendet wird. Dieses Problem könnte von einer Sicherheitssoftware verursacht werden, beispielsweise von einem Virenscanner.
