# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Headers used in the webextension permissions dialog,
## See https://bug1308309.bmoattachments.org/attachment.cgi?id=8814612
## for an example of the full dialog.
## Note: This string will be used as raw markup. Avoid characters like <, >, &
## Variables:
##   $extension (String): replaced with the localized name of the extension.

webext-perms-header = Hozzáadja: { $extension }?
webext-perms-header-with-perms = Hozzáadja a(z) { $extension } kiegészítőt? A következőkhöz lesz engedélye:
webext-perms-header-unsigned = Hozzáadja a(z) { $extension } kiegészítőt? A kiegészítő nem ellenőrzött. A kártékony kiegészítők ellophatják a személyes adatait, vagy veszélyeztethetik a számítógépét. Csak akkor adja hozzá ezt a kiegészítőt, ha megbízik a forrásban.
webext-perms-header-unsigned-with-perms = Hozzáadja a(z) { $extension } kiegészítőt? A kiegészítő nem ellenőrzött. A kártékony kiegészítők ellophatják a személyes adatait, vagy veszélyeztethetik a számítógépét. Csak akkor adja hozzá ezt a kiegészítőt, ha megbízik a forrásban. A kiegészítőnek a következőkhöz lesz engedélye:
webext-perms-sideload-header = { $extension } hozzáadva
webext-perms-optional-perms-header = A(z) { $extension } további engedélyeket igényel.

##

webext-perms-add =
    .label = Hozzáadás
    .accesskey = H
webext-perms-cancel =
    .label = Mégse
    .accesskey = M

webext-perms-sideload-text = A számítógépre telepített másik program olyan kiegészítőt telepített, amely hatással lehet a böngészőre. Ellenőrizze a kiegészítő engedélykéréseit, és válassza az Engedélyezést vagy a Mégse lehetőséget (a letiltva hagyáshoz).
webext-perms-sideload-text-no-perms = A számítógépre telepített másik program olyan kiegészítőt telepített, amely hatással lehet a böngészőre. Válassza az Engedélyezést vagy a Mégse lehetőséget (a letiltva hagyáshoz).
webext-perms-sideload-enable =
    .label = Engedélyezés
    .accesskey = E
webext-perms-sideload-cancel =
    .label = Mégse
    .accesskey = M

# Variables:
#   $extension (String): replaced with the localized name of the extension.
webext-perms-update-text = A(z) { $extension } frissítésre került. Jóvá kell hagynia az új engedélyeket, mielőtt a frissített verzió települ. A „Mégse” megtartja a kiegészítő jelenlegi verzióját. A kiegészítőnek a következőkhöz lesz engedélye:
webext-perms-update-accept =
    .label = Frissítés
    .accesskey = F

webext-perms-optional-perms-list-intro = Ezeket szeretné:
webext-perms-optional-perms-allow =
    .label = Engedélyezés
    .accesskey = E
webext-perms-optional-perms-deny =
    .label = Tiltás
    .accesskey = T

webext-perms-host-description-all-urls = Az adatai elérése az összes webhelyhez

# Variables:
#   $domain (String): will be replaced by the DNS domain for which a webextension is requesting access (e.g., mozilla.org)
webext-perms-host-description-wildcard = Az adatai elérése a(z) { $domain } tartományban lévő lapokhoz

# Variables:
#   $domainCount (Number): Integer indicating the number of additional
#     hosts for which this webextension is requesting permission.
webext-perms-host-description-too-many-wildcards =
    { $domainCount ->
        [one] Az adatai elérése { $domainCount } másik tartományhoz
       *[other] Az adatai elérése { $domainCount } másik tartományhoz
    }
# Variables:
#   $domain (String): will be replaced by the DNS host name for which a webextension is requesting access (e.g., www.mozilla.org)
webext-perms-host-description-one-site = Az adatai elérése itt: { $domain }

# Variables:
#   $domainCount (Number): Integer indicating the number of additional
#     hosts for which this webextension is requesting permission.
webext-perms-host-description-too-many-sites =
    { $domainCount ->
        [one] Az adatai elérése még { $domainCount } oldalon
       *[other] Az adatai elérése még { $domainCount } oldalon
    }

## Headers used in the webextension permissions dialog for synthetic add-ons.
## The part of the string describing what privileges the extension gives should be consistent
## with the value of webext-site-perms-description-gated-perms-{sitePermission}.
## Note, this string will be used as raw markup. Avoid characters like <, >, &
## Variables:
##   $hostname (String): the hostname of the site the add-on is being installed from.

webext-site-perms-header-with-gated-perms-midi = Ez a kiegészítő hozzáférést biztosít a(z) { $hostname } számára a MIDI-eszközeihez.
webext-site-perms-header-with-gated-perms-midi-sysex = Ez a kiegészítő hozzáférést biztosít a(z) { $hostname } számára a MIDI-eszközeihez (SysEx támogatással).

##

# This string is used as description in the webextension permissions dialog for synthetic add-ons.
# Note, the empty line is used to create a line break between the two sections.
# Note, this string will be used as raw markup. Avoid characters like <, >, &
webext-site-perms-description-gated-perms-midi =
    Ezek általában bővíthető eszközök, például hangszintetizátorok, de előfordulhatnak a számítógépbe építve is.
    
    A weboldalak általában nem érhetnek el MIDI-eszközöket. A nem megfelelő használatuk kárt okozhat, vagy veszélyeztetheti a biztonságot.

## Headers used in the webextension permissions dialog.
## Note: This string will be used as raw markup. Avoid characters like <, >, &
## Variables:
##   $extension (String): replaced with the localized name of the extension being installed.
##   $hostname (String): will be replaced by the DNS host name for which a webextension enables permissions.

webext-site-perms-header-with-perms = Hozzáadja a(z) { $extension } kiegészítőt? Ez a kiegészítő a következő lehetőségeket biztosítja a(z) { $hostname } számára:
webext-site-perms-header-unsigned-with-perms = Hozzáadja a(z) { $extension } kiegészítőt? A kiegészítő nem ellenőrzött. A kártékony kiegészítők ellophatják a személyes adatait, vagy veszélyeztethetik a számítógépét. Csak akkor adja hozzá ezt a kiegészítőt, ha megbízik a forrásban. A kiegészítő a következő lehetőségeket biztosítja a(z) { $hostname } számára:

## These should remain in sync with permissions.NAME.label in sitePermissions.properties

webext-site-perms-midi = MIDI eszközök elérése
webext-site-perms-midi-sysex = MIDI eszközök elérése SysEx támogatással
