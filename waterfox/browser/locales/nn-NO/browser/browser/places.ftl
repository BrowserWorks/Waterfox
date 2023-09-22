# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this file,
# You can obtain one at http://mozilla.org/MPL/2.0/.

places-open =
    .label = Opne
    .accesskey = O
places-open-in-tab =
    .label = Opne i ny fane
    .accesskey = O
places-open-in-container-tab =
    .label = Opne i ny innhaldsfane
    .accesskey = O
places-open-all-bookmarks =
    .label = Opne alle bokmerke
    .accesskey = O
places-open-all-in-tabs =
    .label = Opne alle i faner
    .accesskey = O
places-open-in-window =
    .label = Opne i nytt vindauge
    .accesskey = v
places-open-in-private-window =
    .label = Opne i nytt privat vindauge
    .accesskey = p

places-empty-bookmarks-folder =
    .label = (Tom)

places-add-bookmark =
    .label = Legg til bokmerke
    .accesskey = b
places-add-folder-contextmenu =
    .label = Legg til mappe
    .accesskey = m
places-add-folder =
    .label = Legg til mappe
    .accesskey = m
places-add-separator =
    .label = Legg til skiljelinje
    .accesskey = s

places-view =
    .label = Vis
    .accesskey = i
places-by-date =
    .label = Etter dato
    .accesskey = a
places-by-site =
    .label = Etter nettstad
    .accesskey = n
places-by-most-visited =
    .label = Etter mest besøkte
    .accesskey = m
places-by-last-visited =
    .label = Etter sist besøkt
    .accesskey = s
places-by-day-and-site =
    .label = Etter dato og nettstad
    .accesskey = d

places-history-search =
    .placeholder = Søkjehistorikk
places-history =
    .aria-label = Historikk
places-bookmarks-search =
    .placeholder = Søk i bokmerka

places-delete-domain-data =
    .label = Gløym denne nettstaden
    .accesskey = G
places-sortby-name =
    .label = Sorter etter namn
    .accesskey = r
# places-edit-bookmark and places-edit-generic will show one or the other and can have the same access key.
places-edit-bookmark =
    .label = Rediger bokmerke…
    .accesskey = R
places-edit-generic =
    .label = Rediger…
    .accesskey = R
places-edit-folder2 =
    .label = Rediger mappe…
    .accesskey = R
# Variables
#   $count (number) - Number of folders to delete
places-delete-folder =
    .label =
        { $count ->
            [1] Slett mappe
           *[other] Slett mapper
        }
    .accesskey = S
# Variables:
#   $count (number) - The number of pages selected for removal.
places-delete-page =
    .label =
        { $count ->
            [1] Slett sida
           *[other] Slett sider
        }
    .accesskey = S

# Managed bookmarks are created by an administrator and cannot be changed by the user.
managed-bookmarks =
    .label = Administrerte bokmerke
# This label is used when a managed bookmarks folder doesn't have a name.
managed-bookmarks-subfolder =
    .label = Undermappe

# This label is used for the "Other Bookmarks" folder that appears in the bookmarks toolbar.
other-bookmarks-folder =
    .label = Andre bokmerke

places-show-in-folder =
    .label = Vis i mappe
    .accesskey = V

# Variables:
# $count (number) - The number of elements being selected for removal.
places-delete-bookmark =
    .label =
        { $count ->
            [1] Slett bokmerke
           *[other] Slett bokmerke
        }
    .accesskey = S

# Variables:
#   $count (number) - The number of bookmarks being added.
places-create-bookmark =
    .label =
        { $count ->
            [1] Bokmerk side…
           *[other] Bokmerk sider…
        }
    .accesskey = B

places-untag-bookmark =
    .label = Fjern etikett
    .accesskey = F

places-manage-bookmarks =
    .label = Handsam bokmerke
    .accesskey = H

places-forget-about-this-site-confirmation-title = Gløymer denne nettstaden

# Variables:
# $hostOrBaseDomain (string) - The base domain (or host in case there is no base domain) for which data is being removed
places-forget-about-this-site-confirmation-msg = Denne handlinga fjernar data relatert til { $hostOrBaseDomain }, inkludert historikk, infokapslar, hurtigbuffer og innhalds-innstillingar. Relaterte bokmerke og passord vil ikke bli fjerna. Er du sikker på at du vil halde fram?

places-forget-about-this-site-forget = Gløym

places-library3 =
    .title = Arkiv

places-organize-button =
    .label = Organiser
    .tooltiptext = Organiser bokmerka dine
    .accesskey = O

places-organize-button-mac =
    .label = Organiser
    .tooltiptext = Organiser bokmerka dine

places-file-close =
    .label = Lat att
    .accesskey = L

places-cmd-close =
    .key = w

places-view-button =
    .label = Vis
    .tooltiptext = Endre vising
    .accesskey = V

places-view-button-mac =
    .label = Vis
    .tooltiptext = Endre vising

places-view-menu-columns =
    .label = Vis kolonner
    .accesskey = V

places-view-menu-sort =
    .label = Sorter
    .accesskey = S

places-view-sort-unsorted =
    .label = Usortert
    .accesskey = U

places-view-sort-ascending =
    .label = Sorteringsrekkjefølgje A -> Å
    .accesskey = A

places-view-sort-descending =
    .label = Sorteringsrekkjefølgje Å -> A
    .accesskey = Å

places-maintenance-button =
    .label = Importer og sikkerheitskopier
    .tooltiptext = Importer og sikkerheitskopier bokmerka
    .accesskey = I

places-maintenance-button-mac =
    .label = Importer og sikkerheitskopier
    .tooltiptext = Importer og sikkerheitskopier bokmerka

places-cmd-backup =
    .label = Sikkerheitskopier…
    .accesskey = S

places-cmd-restore =
    .label = Bygg oppatt
    .accesskey = G

places-cmd-restore-from-file =
    .label = Vel fil…
    .accesskey = V

places-import-bookmarks-from-html =
    .label = Importer bokmerke frå HTML…
    .accesskey = I

places-export-bookmarks-to-html =
    .label = Eksporter bokmerke til HTML…
    .accesskey = E

places-import-other-browser =
    .label = Importer data frå ein annan nettlesar…
    .accesskey = a

places-view-sort-col-name =
    .label = Namn

places-view-sort-col-tags =
    .label = Etikettar

places-view-sort-col-url =
    .label = Adresse

places-view-sort-col-most-recent-visit =
    .label = Sist besøkt

places-view-sort-col-visit-count =
    .label = Tal på besøk

places-view-sort-col-date-added =
    .label = Lagt til

places-view-sort-col-last-modified =
    .label = Sist endra

places-view-sortby-name =
    .label = Sorter etter namn
    .accesskey = n
places-view-sortby-url =
    .label = Sorter etter plassering
    .accesskey = p
places-view-sortby-date =
    .label = Sorter etter sist besøkt
    .accesskey = B
places-view-sortby-visit-count =
    .label = Sorter etter besøkstal
    .accesskey = a
places-view-sortby-date-added =
    .label = Sorter etter lagt til
    .accesskey = l
places-view-sortby-last-modified =
    .label = Sorter etter sist oppdatert
    .accesskey = o
places-view-sortby-tags =
    .label = Sorter etter etikettar
    .accesskey = e

places-cmd-find-key =
    .key = f

places-back-button =
    .tooltiptext = Gå tilbake

places-forward-button =
    .tooltiptext = Gå fram

places-details-pane-select-an-item-description = Vel elementet du vil vise og redigere

places-details-pane-no-items =
    .value = Ingen element
# Variables:
#   $count (Number): number of items
places-details-pane-items-count =
    .value =
        { $count ->
            [one] Eitt element
           *[other] { $count } element
        }

## Strings used as a placeholder in the Library search field. For example,
## "Search History" stands for "Search through the browser's history".

places-search-bookmarks =
    .placeholder = Søk i bokmerke
places-search-history =
    .placeholder = Søk i historikk
places-search-downloads =
    .placeholder = Søk i nedlastingar

##

places-locked-prompt = Bokmerke- og historikksystemet vil ikkje fungere fordi ein av { -brand-short-name } sine filer er i bruk av eit anna program. Nokre sikkerheitsprogram kan skape dette problemet.
