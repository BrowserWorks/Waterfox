# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Localized string used as the dialog window title (a new behavior locked
# behind the "extensions.abuseReport.openDialog" preference).
# "Report" is a noun in this case, "Report for AddonName".
#
# Variables:
#   $addon-name (string) - Name of the add-on being reported
abuse-report-dialog-title = A(z) { $addon-name } jelentése

abuse-report-title-extension = A kiegészítő jelentése a { -vendor-short-name } felé
abuse-report-title-theme = A téma jelentése a { -vendor-short-name } felé
abuse-report-subtitle = Mi a probléma?

# Variables:
#   $author-name (string) - Name of the add-on author
abuse-report-addon-authored-by = szerző: <a data-l10n-name="author-name">{ $author-name }</a>

abuse-report-learnmore =
    Nem tudja, hogy melyik problémát válassza ki?
    <a data-l10n-name="learnmore-link">További információk a bővítmények és témák jelentéséről</a>

abuse-report-submit-description = Írja le a problémát (nem kötelező)
abuse-report-textarea =
    .placeholder = Könnyebb megoldanunk egy problémát, ha vannak konkrétumok. Írja le, hogy mit tapasztal. Köszönjük, hogy segít minket abban, hogy a web egészséges maradjon.
abuse-report-submit-note = Megjegyzés: Ne írjon bele személyes információkat (mint nevek, e-mail címek, telefonszámok és valós címek). A { -vendor-short-name } véglegesen rögzíti ezeket a jelentéseket.

## Panel buttons.

abuse-report-cancel-button = Mégse
abuse-report-next-button = Tovább
abuse-report-goback-button = Ugrás vissza
abuse-report-submit-button = Elküldés

## Message bars descriptions.


## Variables:
##   $addon-name (string) - Name of the add-on

abuse-report-messagebar-aborted = A(z) <span data-l10n-name="addon-name">{ $addon-name }</span> bejelentése megszakítva.
abuse-report-messagebar-submitting = Jelentés küldésre erről: <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-submitted = Köszönjük a bejelentést. Eltávolítja a(z) <span data-l10n-name="addon-name">{ $addon-name }</span> kiegészítőt?
abuse-report-messagebar-submitted-noremove = Köszönjük a bejelentést.
abuse-report-messagebar-removed-extension = Köszönjük a bejelentést. Eltávolította a(z) <span data-l10n-name="addon-name">{ $addon-name }</span> kiegészítőt.
abuse-report-messagebar-removed-theme = Köszönjük a bejelentést. Eltávolította a(z) <span data-l10n-name="addon-name">{ $addon-name }</span> témát.
abuse-report-messagebar-error = Hiba történt a(z) <span data-l10n-name="addon-name">{ $addon-name }</span> kiegészítő jelentésének beküldésekor.
abuse-report-messagebar-error-recent-submit = A(z) <span data-l10n-name="addon-name">{ $addon-name }</span> kiegészítő jelentése nem lett elküldve, mert a közelmúltban már benyújtott egy másik jelentést.

## Message bars actions.

abuse-report-messagebar-action-remove-extension = Igen, távolítsa el
abuse-report-messagebar-action-keep-extension = Nem, megtartom
abuse-report-messagebar-action-remove-theme = Igen, távolítsa el
abuse-report-messagebar-action-keep-theme = Nem, megtartom
abuse-report-messagebar-action-retry = Újra
abuse-report-messagebar-action-cancel = Mégse

## Abuse report reasons (optionally paired with related examples and/or suggestions)

abuse-report-damage-reason-v2 = Megrongálta a számítógépemet, vagy az adataim biztonsága sérült
abuse-report-damage-example = Példa: kártékony szoftvert telepített vagy adatokat lopott

abuse-report-spam-reason-v2 = Spamet tartalmaz vagy nem kívánt hirdetéseket szúr be
abuse-report-spam-example = Példa: Hirdetések beszúrása weboldalakba

abuse-report-settings-reason-v2 = Módosította a keresőszolgáltatásomat, kezdőlapomat vagy az új lap oldalamat a tájékoztatásom vagy megkérdezésem nélkül
abuse-report-settings-suggestions = A kiegészítő bejelentése előtt megpróbálhatja megváltoztatni a beállításait:
abuse-report-settings-suggestions-search = Módosítja az alapértelmezett keresési beállításokat
abuse-report-settings-suggestions-homepage = Módosítja a kezdőlapot vagy az új lap oldalt

abuse-report-deceptive-reason-v2 = Másnak állítja magát, mint ami
abuse-report-deceptive-example = Példa: Félrevezető leírás vagy képek

abuse-report-broken-reason-extension-v2 = Nem működik, hibákat okoz weblapokon vagy lassítja a { -brand-product-name } működését
abuse-report-broken-reason-theme-v2 = Nem működik, vagy hibákat okoz a böngésző megjelenítésében
abuse-report-broken-example = Példa: A funkciók lassúak, nehezen használhatóak vagy nem működnek; a weboldalak egyes részei nem töltődnek be vagy szokatlanul néznek ki
abuse-report-broken-suggestions-extension =
    Úgy néz ki, hogy egy hibát azonosított. Az itt beküldött jelentés mellett a legjobb módszer a probléma
    megoldásának az, hogy kapcsolatba lép a kiegészítő fejlesztőjével.
    <a data-l10n-name="support-link">Keresse fel a kiegészítő weboldalát</a> a fejlesztő információinak megtekintéséhez.
abuse-report-broken-suggestions-theme =
    Úgy néz ki, hogy egy hibát azonosított. Az itt beküldött jelentés mellett a legjobb módszer a probléma
    megoldásának az, hogy kapcsolatba lép a téma fejlesztőjével.
    <a data-l10n-name="support-link">Keresse fel a téma weboldalát</a> a fejlesztő információinak megtekintéséhez.

abuse-report-policy-reason-v2 = Gyűlölködő, erőszakos vagy illegális tartalom van benne
abuse-report-policy-suggestions =
    Megjegyzés: A szerzői jogi és védjegyekkel kapcsolatos problémákat egy külön folyamatban kell jelenteni.
    <a data-l10n-name="report-infringement-link">Használja ezeket az utasításokat</a> a
    probléma bejelentéséhez.

abuse-report-unwanted-reason-v2 = Soha nem akartam, és nem tudom, hogyan lehet megszabadulni tőle
abuse-report-unwanted-example = Példa: Egy alkalmazás az engedélyem nélkül települt

abuse-report-other-reason = Valami más

