# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

webext-perms-learn-more = További tudnivalók
# Variables:
#   $addonName (String): localized named of the extension that is asking to change the default search engine.
#   $currentEngine (String): name of the current search engine.
#   $newEngine (String): name of the new search engine.
webext-default-search-description = A(z) { $addonName } szeretné megváltoztatni az alapértelmezett keresőmotort erről: { $currentEngine }, erre: { $newEngine }. Ez így rendben van?
webext-default-search-yes =
    .label = Igen
    .accesskey = I
webext-default-search-no =
    .label = Nem
    .accesskey = N
# Variables:
#   $addonName (String): localized named of the extension that was just installed.
addon-post-install-message = A(z) { $addonName } hozzá lett adva.

## A modal confirmation dialog to allow an extension on quarantined domains.

# Variables:
#   $addonName (String): localized name of the extension.
webext-quarantine-confirmation-title = Futtatja a(z) { $addonName } kiegészítőt a korlátozott webhelyeken?
webext-quarantine-confirmation-line-1 = Az adatai védelme érdekében ez a kiegészítő nem engedélyezett ezen az oldalon.
webext-quarantine-confirmation-line-2 = Ha megbízik a kiegészítőben, akkor engedélyezze számára, hogy olvassa és módosítsa az adatait a { -vendor-short-name } által korlátozott webhelyeken.
webext-quarantine-confirmation-allow =
    .label = Engedélyezés
    .accesskey = E
webext-quarantine-confirmation-deny =
    .label = Tiltás
    .accesskey = T
