# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Strings used in about:unloads, allowing users to manage the "tab unloading"
### feature.

about-unloads-page-title = Frigör flik
about-unloads-intro-1 =
    { -brand-short-name } har en funktion som automatiskt tömmer flikar
    för att förhindra att applikationen kraschar på grund av otillräckligt minne
    när systemets andel ledigt minne är lågt. Denna sida visar hur
    { -brand-short-name } prioriterar flikar och vilken flik som kommer att tömmas
    när frigörande av flikar behövs.
about-unloads-intro-2 =
    Befintliga flikar visas i tabellen nedan i samma ordning som används av
    { -brand-short-name } för att välja nästa flik att tömma. Process-ID
    visas med <strong>fetstil</strong> när de är värd för flikens huvud-
    ram och i <em>kursiv</em> när processen delas mellan flera flikar.
    Du kan starta frigörande av flikar manuellt genom att klicka på knappen
    <em>Frigör</em> nedan.
about-unloads-intro =
    { -brand-short-name } har en funktion som automatiskt frigör flikar
    för att förhindra att programmet kraschar på grund av otillräckligt minne
    när systemets lediga minne är lågt. Nästa flik som ska frigöras väljs baserat
    på flera attribut. Den här sidan visar hur { -brand-short-name } prioriterar
    flikar och vilken flik som kommer att frigöras. Du kan manuellt frigöra en
    flik genom att klicka på knappen <em>Frigör</em> nedan.
# The link points to a Waterfox documentation page, only available in English,
# with title "Tab Unloading"
about-unloads-learn-more =
    Se <a data-l10n-name="doc-link">Frigör flik</a> om du vill veta mer om
    funktionen och den här sidan.
about-unloads-last-updated = Senast uppdaterad: { DATETIME($date, year: "numeric", month: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric", hour12: "false") }
about-unloads-button-unload = Frigör
    .title = Frigör fliken med högsta prioritet
about-unloads-no-unloadable-tab = Det finns inga flikar att frigöra.
about-unloads-column-priority = Prioritet
about-unloads-column-host = Värd
about-unloads-column-last-accessed = Senaste åtkomst
about-unloads-column-weight = Basvikt
    .title = Flikar sorteras först efter detta värde, vilket härrör från några speciella attribut som att spela upp ett ljud, WebRTC, etc.
about-unloads-column-sortweight = Sekundär vikt
    .title = Om de är tillgängliga sorteras flikarna efter detta värde efter att de har sorterats efter basvikten. Värdet härrör från flikens minnesanvändning och antalet processer.
about-unloads-column-memory = Minne
    .title = Flikens beräknade minnesanvändning
about-unloads-column-processes = Process-ID
    .title = ID för processerna som är värd för flikens innehåll
about-unloads-last-accessed = { DATETIME($date, year: "numeric", month: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric", hour12: "false") }
about-unloads-memory-in-mb = { NUMBER($mem, maxFractionalUnits: 2) } MB
about-unloads-memory-in-mb-tooltip =
    .title = { NUMBER($mem, maxFractionalUnits: 2) } MB
