# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this file,
# You can obtain one at http://mozilla.org/MPL/2.0/.

places-open =
    .label = Atverti
    .accesskey = A
places-open-in-tab =
    .label = Atverti naujoje kortelėje
    .accesskey = j
places-open-all-bookmarks =
    .label = Atverti visas korteles
    .accesskey = v
places-open-all-in-tabs =
    .label = Atverti kortelėse
    .accesskey = A
places-open-in-window =
    .label = Atverti naujame lange
    .accesskey = n
places-open-in-private-window =
    .label = Atverti naujoje privačiojoje kortele
    .accesskey = p
places-add-bookmark =
    .label = Įtraukti adresą…
    .accesskey = r
places-add-folder-contextmenu =
    .label = Įtraukti aplanką…
    .accesskey = l
places-add-folder =
    .label = Įtraukti aplanką…
    .accesskey = k
places-add-separator =
    .label = Įtraukti skirtuką
    .accesskey = s
places-view =
    .label = Rodyti
    .accesskey = o
places-by-date =
    .label = pagal datą
    .accesskey = d
places-by-site =
    .label = pagal svetainę
    .accesskey = s
places-by-most-visited =
    .label = pagal lankymo dažnumą
    .accesskey = ž
places-by-last-visited =
    .label = pagal lankymo datą
    .accesskey = l
places-by-day-and-site =
    .label = pagal datą ir svetainę
    .accesskey = t
places-history-search =
    .placeholder = Ieškoti žurnale
places-history =
    .aria-label = Žurnalas
places-bookmarks-search =
    .placeholder = Ieškoti adresyne
places-delete-domain-data =
    .label = Užmiršti viską apie šią svetainę
    .accesskey = U
places-sortby-name =
    .label = Rikiuoti pagal pavadinimą
    .accesskey = R
# places-edit-bookmark and places-edit-generic will show one or the other and can have the same access key.
places-edit-bookmark =
    .label = Redaguoti adresyno įrašą…
    .accesskey = y
places-edit-generic =
    .label = Keisti…
    .accesskey = i
places-edit-folder =
    .label = Pervardyti aplanką…
    .accesskey = e
places-remove-folder =
    .label =
        { $count ->
            [1] Pašalinti aplanką
            [one] Pašalinti aplanką
            [few] Pašalinti aplankus
           *[other] Pašalinti aplankų
        }
    .accesskey = n
places-edit-folder2 =
    .label = Redaguoti aplanką…
    .accesskey = e
places-delete-folder =
    .label =
        { $count ->
            [1] Pašalinti aplanką
            [one] Pašalinti aplanką
            [few] Pašalinti aplankus
           *[other] Pašalinti aplankus
        }
    .accesskey = P
# Managed bookmarks are created by an administrator and cannot be changed by the user.
managed-bookmarks =
    .label = Tvarkomas adresynas
# This label is used when a managed bookmarks folder doesn't have a name.
managed-bookmarks-subfolder =
    .label = Poaplankis
# This label is used for the "Other Bookmarks" folder that appears in the bookmarks toolbar.
other-bookmarks-folder =
    .label = Kiti adresyno įrašai
# Variables:
# $count (number) - The number of elements being selected for removal.
places-remove-bookmark =
    .label =
        { $count ->
            [1] Pašalinti įrašą
            [one] Pašalinti įrašą
            [few] Pašalinti įrašus
           *[other] Pašalinti įrašų
        }
    .accesskey = l
# Variables:
# $count (number) - The number of elements being selected for removal.
places-delete-bookmark =
    .label =
        { $count ->
            [1] Pašalinti įrašą
            [one] Pašalinti įrašą
            [few] Pašalinti įrašus
           *[other] Pašalinti įrašus
        }
    .accesskey = P
places-manage-bookmarks =
    .label = Tvarkyti adresyną
    .accesskey = T
places-forget-about-this-site-confirmation-title = Užmiršti apie šią svetainę
# Variables:
# $hostOrBaseDomain (string) - The base domain (or host in case there is no base domain) for which data is being removed
places-forget-about-this-site-confirmation-message = Šis veiksmas pašalins visus su { $hostOrBaseDomain } susijusius duomenis, įskaitant istoriją, slaptažodžius, slapukus, podėlį ir turinio nuostatas. Ar tikrai norite tęsti?
places-forget-about-this-site-forget = Pamiršti
places-library =
    .title = Archyvas
    .style = width:700px; height:500px;
places-organize-button =
    .label = Tvarkyti
    .tooltiptext = Tvarkyti adresyną
    .accesskey = T
places-organize-button-mac =
    .label = Tvarkyti
    .tooltiptext = Tvarkyti adresyną
places-file-close =
    .label = Užverti
    .accesskey = U
places-cmd-close =
    .key = w
places-view-button =
    .label = Rodymas
    .tooltiptext = Keisti rodymą
    .accesskey = R
places-view-button-mac =
    .label = Rodymas
    .tooltiptext = Keisti rodymą
places-view-menu-columns =
    .label = Rodomi stulpeliai
    .accesskey = s
places-view-menu-sort =
    .label = Rikiavimas
    .accesskey = R
places-view-sort-unsorted =
    .label = Nerikiuoti
    .accesskey = N
places-view-sort-ascending =
    .label = Pagal abėcėlę
    .accesskey = a
places-view-sort-descending =
    .label = Atvirkščiai
    .accesskey = v
places-maintenance-button =
    .label = Importas ir atsarginės kopijos
    .tooltiptext = Importuoti adresyną arba kurti jo atsarginę kopiją
    .accesskey = I
places-maintenance-button-mac =
    .label = Importas ir atsarginės kopijos
    .tooltiptext = Importuoti adresyną arba kurti jo atsarginę kopiją
places-cmd-backup =
    .label = Kurti atsarginę kopiją…
    .accesskey = K
places-cmd-restore =
    .label = Atkurti
    .accesskey = A
places-cmd-restore-from-file =
    .label = Pasirinkite failą…
    .accesskey = f
places-import-bookmarks-from-html =
    .label = Importuoti adresyną iš HTML failo…
    .accesskey = I
places-export-bookmarks-to-html =
    .label = Eksportuoti adresyną į HTML failą…
    .accesskey = E
places-import-other-browser =
    .label = Importuoti duomenis iš kitos naršyklės…
    .accesskey = m
places-view-sort-col-name =
    .label = Pavadinimas
places-view-sort-col-tags =
    .label = Gairės
places-view-sort-col-url =
    .label = Adresas
places-view-sort-col-most-recent-visit =
    .label = Paskiausiai lankytasi
places-view-sort-col-visit-count =
    .label = Aplankymų kiekis
places-view-sort-col-date-added =
    .label = Įtrauktas
places-view-sort-col-last-modified =
    .label = Atnaujintas
places-cmd-find-key =
    .key = f
places-back-button =
    .tooltiptext = Eiti atgal
places-forward-button =
    .tooltiptext = Eiti pirmyn
places-details-pane-select-an-item-description = Pažymėkite objektą, kurio savybes norite peržiūrėti ar redaguoti
