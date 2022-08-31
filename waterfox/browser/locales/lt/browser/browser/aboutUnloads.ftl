# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Strings used in about:unloads, allowing users to manage the "tab unloading"
### feature.

about-unloads-page-title = Kortelių užmigdymas
about-unloads-intro =
    „{ -brand-short-name }“ turi funkciją, kuri automatiškai užmigdo korteles,
    siekiant išvengti programos užstrigimo dėl neužtenkančios kompiuterio atminties.
    Kita kortelė užmigdymui yra parenkama pagal keletą atributų. Šis tinklalapis rodo,
    kaip „{ -brand-short-name }“ prioritetizuoja korteles, ir kurios kortelės būtų
    užmigdytos suveikus šiai funkcijai. Korteles užmigdyti galite ir patys,
    spustelėdami žemiau esantį mygtuką <em>Užmigdyti</em>.

# The link points to a Waterfox documentation page, only available in English,
# with title "Tab Unloading"
about-unloads-learn-more = Paskaitykite apie <a data-l10n-name="doc-link">kortelių užmigdymą</a>, norėdami sužinoti daugiau apie šią funkciją.

about-unloads-last-updated = Paskiausiai atnaujinta: { DATETIME($date, year: "numeric", month: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric", hour12: "false") }
about-unloads-button-unload = Užmigdyti
    .title = Užmigdyti kortelę su didžiausiu prioritetu
about-unloads-no-unloadable-tab = Nėra kortelių, kurias būtų galima užmigdyti.

about-unloads-column-priority = Prioritetas
about-unloads-column-host = Serveris
about-unloads-column-last-accessed = Paskiausiai naudota
about-unloads-column-weight = Bazinis svoris
    .title = Kortelės iš pradžių surūšiuojamos pagal šią reikšmė, kuri gaunama iš dalies specialių atributų, kaip grojamas garsas, „WebRTC“, ir pan.
about-unloads-column-sortweight = Antrinis svoris
    .title = Jei yra, kortelės surūšiuojamos pagali šią reikšmę po bazinio svorio. Reikšmė gaunama iš kortelės atminties sunaudojimo, ir procesų kiekio.
about-unloads-column-memory = Atmintis
    .title = Kortelės numatomas atminties sunaudojimas
about-unloads-column-processes = Procesų ID
    .title = Procesų, kuriuose veikia kortelės turinys, ID

about-unloads-last-accessed = { DATETIME($date, year: "numeric", month: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric", hour12: "false") }
about-unloads-memory-in-mb = { NUMBER($mem, maxFractionalUnits: 2) } MB
about-unloads-memory-in-mb-tooltip =
    .title = { NUMBER($mem, maxFractionalUnits: 2) } MB
