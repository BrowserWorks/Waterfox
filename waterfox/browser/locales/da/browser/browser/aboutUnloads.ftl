# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Strings used in about:unloads, allowing users to manage the "tab unloading"
### feature.

about-unloads-page-title = Nedlukning af faneblade
about-unloads-intro =
    { -brand-short-name } har en funktion, der automatisk lukker faneblade 
    ned for at forhindre programmet i at gå ned som følge af manglende 
    hukommelse, når system ikke har meget tilgængelig hukommelse. En 
    række kriterier bestemmer, hvilket faneblad, der lukkes ned først. Denne
    side viser, hvordan { -brand-short-name } prioriterer mellem faneblade, og 
    hvilket faneblad, der vil blive lukket ned, når nedlukning af faneblade udløses.
    Du kan udløse nedlukning af faneblade manuelt ved at klikke på knappen <em>Nedluk</em> nedenfor.

# The link points to a Waterfox documentation page, only available in English,
# with title "Tab Unloading"
about-unloads-learn-more =
    <a data-l10n-name="doc-link">Klik her</a> for at læse mere om
    funktionen og denne side.

about-unloads-last-updated = Senest opdateret: { DATETIME($date, year: "numeric", month: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric", hour12: "false") }
about-unloads-button-unload = Nedluk
    .title = Nedluk faneblad med den højeste prioritet
about-unloads-no-unloadable-tab = Der findes ingen faneblade, der kan lukkes ned.

about-unloads-column-priority = Prioritet
about-unloads-column-host = Vært
about-unloads-column-last-accessed = Senest tilgået
about-unloads-column-weight = Grundlæggende vægt
    .title = Faneblade sorteres først efter denne værdi, der udledes af nogle særlige attributter som afspilning af lyd, WebRTC osv.
about-unloads-column-sortweight = Sekundær vægt
    .title = Hvis de er tilgængelige, sorteres faneblade efter denne værdi efter at være blevet sorteret efter den primære vægt. Vægten udledes af fanebladets hukommelsesforbrug og antal processer.
about-unloads-column-memory = Hukommelse
    .title = Et faneblads anslåede hukommelsesforbrug
about-unloads-column-processes = Proces-ID
    .title = ID for processer, der er vært for fanebladets indhold

about-unloads-last-accessed = { DATETIME($date, year: "numeric", month: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric", hour12: "false") }
about-unloads-memory-in-mb = { NUMBER($mem, maxFractionalUnits: 2) } MB
about-unloads-memory-in-mb-tooltip =
    .title = { NUMBER($mem, maxFractionalUnits: 2) } MB
