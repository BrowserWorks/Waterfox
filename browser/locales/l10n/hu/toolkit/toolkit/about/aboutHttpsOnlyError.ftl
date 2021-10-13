# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-httpsonly-title-alert = Csak HTTPS mód riasztás
about-httpsonly-title-connection-not-available = A biztonságos kapcsolat nem érhető el
about-httpsonly-title-site-not-available = Biztonságos webhely nem érhető el
# Variables:
#   $websiteUrl (String) - Url of the website that failed to load. Example: www.example.com
about-httpsonly-explanation-unavailable2 = Engedélyezte a Csak-HTTPS módot a fokozott biztonság érdekében, és a <em>{ $websiteUrl }</em> HTTPS verziója nem érhető el.
about-httpsonly-explanation-question = Mi okozhatja ezt?
about-httpsonly-explanation-nosupport = Valószínűleg a webhely egyszerűen nem támogatja a HTTPS-t.
about-httpsonly-explanation-risk = Az is lehet, hogy ezt egy támadó okozza. Ha úgy dönt, hogy meglátogatja a webhelyet, akkor ne adjon meg olyan érzékeny információt, mint a jelszó, e-mail-cím vagy a kártyaadatok.
about-httpsonly-explanation-continue = Ha folytatja, a Csak HTTPS mód ideglenesen ki lesz kapcsolva ennél a webhelynél.
about-httpsonly-button-continue-to-site = Tovább a HTTP oldalra
about-httpsonly-button-go-back = Ugrás vissza
about-httpsonly-link-learn-more = További tudnivalók…

## Suggestion Box that only shows up if a secure connection to www can be established
## Variables:
##   $websiteUrl (String) - Url of the website that can be securely loded with these alternatives. Example: example.com

about-httpsonly-suggestion-box-header = Lehetséges alternatíva
about-httpsonly-suggestion-box-www-text = Ez a <em>www.{ $websiteUrl }</em> biztonságos változata. Felkeresheti ezt az oldalt a <em>{ $websiteUrl }</em> helyett.
about-httpsonly-suggestion-box-www-button = Ugrás ide: www.{ $websiteUrl }
