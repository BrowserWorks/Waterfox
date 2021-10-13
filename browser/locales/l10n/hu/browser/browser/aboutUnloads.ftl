# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Strings used in about:unloads, allowing users to manage the "tab unloading"
### feature.

about-unloads-page-title = Lapok kisöprése
about-unloads-intro-1 =
    A { -brand-short-name } rendelkezik egy olyan funkcióval, hogy
    automatikusan kisöpri a lapokat, hogy megakadályozza az alkalmazás
    összeomlását, ha kevés a rendszer elérhető memóriája. A következő
    kisöprendő lap több tulajdonság alapján lesz kiválasztva. Az oldal
    bemutatja, hogy a { -brand-short-name } miként priorizálja a lapokat,
    és mely lap lesz kisöpörve, ha aktiválódik a funkció.
about-unloads-intro-2 =
    A meglévő lapok a lenti táblázatban vannak megjelenítve, ugyanabban a
    sorrendben, ahogy a { -brand-short-name } kiválasztja a következő kisöprendő
    lapot. A folyamatazonosítók <strong>félkövérek</strong>, ha a lap felső
    keretét adják, és <em>dőltek</em>, ha a folyamaton több lap osztozik. Kézzel
    is kiválthatja a kisöprést, ha a lenti <em>Kisöprés</em> gombra kattint.
about-unloads-intro =
    A { -brand-short-name } rendelkezik egy olyan funkcióval, hogy
    automatikusan kisöpri a lapokat, hogy megakadályozza az alkalmazás
    összeomlását, ha kevés a rendszer elérhető memóriája. A következő
    kisöprendő lap több tulajdonság alapján lesz kiválasztva. Az oldal
    bemutatja, hogy a { -brand-short-name } miként priorizálja a lapokat,
    és mely lap lesz kisöpörve, ha aktiválódik a funkció. A lap kisöprése
    kézileg is aktiválható a lenti <em>Kisöprés</em> gombbal.
# The link points to a Waterfox documentation page, only available in English,
# with title "Tab Unloading"
about-unloads-learn-more =
    Lásd a <a data-l10n-name="doc-link">Lapkisöprés</a> leírást, hogy
    többet tudjon meg a funkcióról és erről a lapról.
about-unloads-last-updated = Legutóbb frissítve: { DATETIME($date, year: "numeric", month: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric", hour12: "false") }
about-unloads-button-unload = Kisöprés
    .title = A legmagasabb prioritású lap kisöprése
about-unloads-no-unloadable-tab = Nincsenek kisöpörhető lapok.
about-unloads-column-priority = Prioritás
about-unloads-column-host = Kiszolgáló
about-unloads-column-last-accessed = Utolsó hozzáférés
about-unloads-column-weight = Alapsúly
    .title = A lapok először ez alapján lesznek rendezve, ez pedig olyan speciális tulajdonságokból ered, mint például a hanglejátszás, WebRTC használat, stb.
about-unloads-column-sortweight = Másodlagos súly
    .title = Ha elérhető, akkor a lapok ez alapján lesznek sorrendezve az alapsúly után. Az érték a lap memóriahasználatából és a folyamatok számából adódik.
about-unloads-column-memory = Memória
    .title = A lap becsült memóriahasználata
about-unloads-column-processes = Folyamatazonosítók
    .title = A lap tartalmát biztosító folyamatok azonosítói
about-unloads-last-accessed = { DATETIME($date, year: "numeric", month: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric", hour12: "false") }
about-unloads-memory-in-mb = { NUMBER($mem, maxFractionalUnits: 2) } MB
about-unloads-memory-in-mb-tooltip =
    .title = { NUMBER($mem, maxFractionalUnits: 2) } MB
