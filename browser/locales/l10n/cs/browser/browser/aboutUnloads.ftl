# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Strings used in about:unloads, allowing users to manage the "tab unloading"
### feature.

about-unloads-page-title = Uvolňování panelů
about-unloads-intro-1 = { -brand-short-name } obsahuje funkci, která automaticky uvolní zdroje panelů z paměti, aby kvůli jejímu nedostatku nedošlo k pádu. Panel k uvolnění je vždy vybrán na základě několika kritérií. Tato stránka ukazuje, jakou dává { -brand-short-name } prioritou jednotlivým panelům a který bude případně uvolněn jako další.
about-unloads-intro-2 = V tabulce níže se zobrazují otevřené panely v pořadí podle toho, jak je bude { -brand-short-name } případně uvolňovat. Pokud v procesu běží panel na vrchu seznamu, je jeho ID zobrazeno <strong>tučně</strong>. Pokud je ID zobrazeno <em>kurzívou</em>, je proces sdílen mezi více panely. Uvolnění panelu můžete spustit ručně klepnutím na tlačítko <em>Uvolnit</em> níže.
about-unloads-intro = { -brand-short-name } obsahuje funkci, která automaticky uvolní zdroje panelů z paměti, aby kvůli jejímu nedostatku nedošlo k pádu. Panel k uvolnění je vždy vybrán na základě několika kritérií. Tato stránka ukazuje, jakou dává { -brand-short-name } prioritou jednotlivým panelům a který bude případně uvolněn jako další. Uvolnění panelu můžete spustit ručně klepnutím na tlačítko <em>Uvolnit</em> níže.
# The link points to a Waterfox documentation page, only available in English,
# with title "Tab Unloading"
about-unloads-learn-more = Podrobnosti o této funkci najdete v dokumentaci <a data-l10n-name="doc-link">Tab Unloading</a>.
about-unloads-last-updated = Poslední aktualizace: { DATETIME($date, year: "numeric", month: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric", hour12: "false") }
about-unloads-button-unload = Uvolnit
    .title = Uvolní panel s nejvyšší prioritou (na začátku seznamu)
about-unloads-no-unloadable-tab = Nejsou dostupné žádné panely k uvolnění.
about-unloads-column-priority = Priorita
about-unloads-column-host = Server
about-unloads-column-last-accessed = Poslední přístup
about-unloads-column-weight = Základní váha
    .title = Panely jsou seřazeny podle hodnoty, která je odvozena od toho, zda panel přehrává zvuk, používá WebRTC apod.
about-unloads-column-sortweight = Doplňková váha
    .title = Pokud je hodnota dostupná, jsou panely se stejnou základní vahou řazeny také podle doplňkové váhy. Ta je odvozena z množství využívané paměti a počtu procesů.
about-unloads-column-memory = Paměť
    .title = Odhadované využití paměti
about-unloads-column-processes = ID procesů
    .title = ID procesů, které se starají o obsah panelu
about-unloads-last-accessed = { DATETIME($date, year: "numeric", month: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric") }
about-unloads-memory-in-mb = { NUMBER($mem, maxFractionalUnits: 2) } MB
about-unloads-memory-in-mb-tooltip =
    .title = { NUMBER($mem, maxFractionalUnits: 2) } MB
