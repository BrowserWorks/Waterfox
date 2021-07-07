# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Strings used in about:unloads, allowing users to manage the "tab unloading"
### feature.

about-unloads-page-title = Tabbladen lossen
about-unloads-intro-1 =
    { -brand-short-name } heeft een functie die automatisch tabbladen lost
    om te voorkomen dat de toepassing crasht vanwege onvoldoende geheugen
    wanneer het beschikbare systeemgeheugen laag is. Het volgende tabblad dat moet wordt gelost wordt
    gekozen op basis van meerdere eigenschappen. Deze pagina laat zien hoe
    { -brand-short-name } prioriteit geeft aan tabbladen en welk tabblad wordt gelost
    wanneer het lossen van tabbladen wordt geactiveerd.
about-unloads-intro-2 =
    Bestaande tabbladen worden in de onderstaande tabel in dezelfde volgorde getoond als in
    { -brand-short-name } om het volgende te lossen tabblad te kiezen. Proces-ID’s worden
    getoond in <strong>vet</strong> wanneer ze het bovenste frame van het tabblad hosten,
    en in <em>cursief</em> wanneer het proces wordt gedeeld tussen verschillende
    tabbladen. U kunt het lossen van tabbladen handmatig activeren door hieronder op de knop
    <em>Lossen</em> te klikken.
about-unloads-intro =
    { -brand-short-name } heeft een functie die automatisch tabbladen lost
    om te voorkomen dat de toepassing crasht vanwege onvoldoende geheugen
    wanneer het beschikbare systeemgeheugen laag is. Het volgende tabblad dat moet wordt gelost wordt
    gekozen op basis van meerdere eigenschappen. Deze pagina laat zien hoe
    { -brand-short-name } prioriteit geeft aan tabbladen en welk tabblad wordt gelost
    wanneer het lossen van tabbladen wordt geactiveerd. U kunt handmatig het lossen van tabbladen
    activeren door hieronder op de knop <em>Lossen</em> te klikken.
# The link points to a Waterfox documentation page, only available in English,
# with title "Tab Unloading"
about-unloads-learn-more =
    Zie <a data-l10n-name="doc-link">Tabbladen lossen</a> voor meer info over
    de functie en deze pagina.
about-unloads-last-updated = Laatst bijgewerkt: { DATETIME($date, day: "numeric", month: "numeric", year: "numeric", hour: "numeric", minute: "numeric", second: "numeric", hour12: "false") }
about-unloads-button-unload = Lossen
    .title = Tabblad met de hoogste prioriteit lossen
about-unloads-no-unloadable-tab = Er zijn geen te lossen tabbladen.
about-unloads-column-priority = Prioriteit
about-unloads-column-host = Host
about-unloads-column-last-accessed = Laatst benaderd
about-unloads-column-weight = Basisgewicht
    .title = Tabbladen worden allereerst op deze waarde gesorteerd, die wordt afgeleid van enkele speciale eigenschappen, zoals geluid afspelen, WebRTC, enz.
about-unloads-column-sortweight = Secundair gewicht
    .title = Indien beschikbaar worden tabbladen op deze waarde gesorteerd, nadat ze op het basisgewicht zijn gesorteerd. De waarde wordt afgeleid van het geheugengebruik van het tabblad en het aantal processen.
about-unloads-column-memory = Geheugen
    .title = Het geschatte geheugengebruik van het tabblad
about-unloads-column-processes = Proces-ID’s
    .title = ID’s van de processen die de inhoud van het tabblad hosten
about-unloads-last-accessed = { DATETIME($date, day: "numeric", month: "numeric", year: "numeric", hour: "numeric", minute: "numeric", second: "numeric", hour12: "false") }
about-unloads-memory-in-mb = { NUMBER($mem, maxFractionalUnits: 2) } MB
about-unloads-memory-in-mb-tooltip =
    .title = { NUMBER($mem, maxFractionalUnits: 2) } MB
