# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

privatebrowsingpage-open-private-window-label = Privát ablak megnyitása
    .accesskey = P
about-private-browsing-search-placeholder = Keresés a weben
about-private-browsing-info-title = Jelenleg privát ablakban van
about-private-browsing-search-btn =
    .title = Keresés a weben
# Variables
#  $engine (String): the name of the user's default search engine
about-private-browsing-handoff =
    .title = Keressen a(z) { $engine } keresővel vagy adjon meg egy címet
about-private-browsing-handoff-no-engine =
    .title = Keressen, vagy adjon meg címet
# Variables
#  $engine (String): the name of the user's default search engine
about-private-browsing-handoff-text = Keressen a(z) { $engine } keresővel vagy adjon meg egy címet
about-private-browsing-handoff-text-no-engine = Keressen, vagy adjon meg címet
about-private-browsing-not-private = Jelenleg nem privát ablakot használ.
about-private-browsing-info-description-private-window = Privát ablak: a { -brand-short-name } törli a keresési és böngészési előzményeket, amikor bezárja az összes privát ablakot. Ez nem teszi névtelenné.
about-private-browsing-info-description-simplified = A { -brand-short-name } törli a keresési és böngészési előzményeket, amikor bezárja az összes privát ablakot, de ez nem teszi névtelenné.
about-private-browsing-learn-more-link = További tudnivalók
about-private-browsing-hide-activity = Rejtse el tevékenységét és tartózkodási helyét, bárhol is böngésszen
about-private-browsing-get-privacy = Szerezzen adatvédelmet, bárhol is böngésszen
about-private-browsing-hide-activity-1 = Rejtse el a böngészési tevékenységét és a tartózkodási helyét a { -mozilla-vpn-brand-name } használatával. Egy kattintással biztonságos kapcsolatot hozhat létre, még nyilvános Wi-Fin is.
about-private-browsing-prominent-cta = Maradjon privát a { -mozilla-vpn-brand-name } használatával
about-private-browsing-focus-promo-cta = A { -focus-brand-name } letöltése
about-private-browsing-focus-promo-header = { -focus-brand-name }: Privát böngészés útközben
about-private-browsing-focus-promo-text = A dedikált privát mobilböngésző alkalmazásunk minden alkalommal törli az előzményeket és a sütiket.

## The following strings will be used for experiments in Fx99 and Fx100

about-private-browsing-focus-promo-header-b = Vigye a privát böngészést a telefonjára
about-private-browsing-focus-promo-text-b = Használja a { -focus-brand-name }t azokhoz a privát keresésekhez, amelyeket nem szeretné, hogy a fő mobilböngészője lásson.
about-private-browsing-focus-promo-header-c = Magasabb szintű adatvédelem mobilon
about-private-browsing-focus-promo-text-c = A { -focus-brand-name } minden egyes alkalommal törli az előzményeket, miközben blokkolja a reklámokat és a követőket.
# This string is the title for the banner for search engine selection
# in a private window.
# Variables:
#   $engineName (String) - The engine name that will currently be used for the private window.
about-private-browsing-search-banner-title = A(z) { $engineName } az alapértelmezett keresőszolgáltatás a privát ablakokban
about-private-browsing-search-banner-description =
    { PLATFORM() ->
        [windows] Másik keresőszolgáltatás kiválasztásához ugorjon a <a data-l10n-name="link-options">Beállításokhoz</a>
       *[other] Másik keresőszolgáltatás kiválasztásához ugorjon a <a data-l10n-name="link-options">Beállításokhoz</a>
    }
about-private-browsing-search-banner-close-button =
    .aria-label = Bezárás
about-private-browsing-promo-close-button =
    .title = Bezárás

## Strings used in a “pin promotion” message, which prompts users to pin a private window

about-private-browsing-pin-promo-header = A privát böngészés szabadsága egyetlen kattintással
about-private-browsing-pin-promo-link-text =
    { PLATFORM() ->
        [macos] Dokkban tartás
       *[other] Rögzítés a tálcára
    }
about-private-browsing-pin-promo-title = Nincsenek mentett sütik vagy előzmények, közvetlenül az asztaláról. Böngésszen úgy, mintha senki sem nézné.
