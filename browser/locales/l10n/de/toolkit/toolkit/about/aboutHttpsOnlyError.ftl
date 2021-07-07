# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-httpsonly-title-alert = Nur-HTTPS-Modus-Warnung
about-httpsonly-title-connection-not-available = Sichere Verbindung nicht verfügbar
about-httpsonly-title-site-not-available = Sichere Website nicht verfügbar
# Variables:
#   $websiteUrl (String) - Url of the website that failed to load. Example: www.example.com
about-httpsonly-explanation-unavailable2 = Sie haben den Nur-HTTPS-Modus für erhöhte Sicherheit aktiviert und es ist keine HTTPS-Version von <em>{ $websiteUrl }</em> verfügbar.
about-httpsonly-explanation-question = Was könnte die Ursache sein?
about-httpsonly-explanation-nosupport = Höchstwahrscheinlich unterstützt die Website HTTPS einfach nicht.
about-httpsonly-explanation-risk = Es ist auch möglich, dass ein Angreifer beteiligt ist. Falls Sie sich dafür entscheiden, die Website aufzurufen, sollten Sie nicht sensible Informationen wie Passwörter, E-Mail-Adressen oder Kreditkartendaten in diese eingeben.
about-httpsonly-explanation-continue = Wenn Sie fortfahren, wird der Nur-HTTPS-Modus für diese Website vorübergehend deaktiviert.
about-httpsonly-button-continue-to-site = Weiter zur HTTP-Website
about-httpsonly-button-go-back = Zurück
about-httpsonly-link-learn-more = Weitere Informationen…

## Suggestion Box that only shows up if a secure connection to www can be established
## Variables:
##   $websiteUrl (String) - Url of the website that can be securely loded with these alternatives. Example: example.com

about-httpsonly-suggestion-box-header = Mögliche Alternative
about-httpsonly-suggestion-box-www-text = Es gibt eine sichere Version von <em>www.{ $websiteUrl }</em>. Sie können diese Seite anstelle von <em>{ $websiteUrl }</em> besuchen.
about-httpsonly-suggestion-box-www-button = www.{ $websiteUrl } aufrufen
