# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-httpsonly-insecure-title = Säker anslutning ej tillgänglig
# Variables:
#   $websiteUrl (String) - Url of the website that failed to load. Example: www.example.com
about-httpsonly-insecure-explanation-unavailable = Du surfar endast i HTTPS-läge och en säker HTTPS-version av <em>{ $websiteUrl }</em> är inte tillgänglig.
about-httpsonly-insecure-explanation-reasons = Webbplatsen stöder troligtvis inte HTTPS, men det är också möjligt att en angripare blockerar HTTPS-versionen.
about-httpsonly-insecure-explanation-exception = Även om säkerhetsrisken är låg, om du väljer att besöka HTTP-versionen av webbplatsen, bör du inte ange någon känslig information som lösenord, e-post eller kreditkortsuppgifter.
about-httpsonly-button-make-exception = Acceptera risken och fortsätt till webbplatsen
about-httpsonly-title-alert = Varning endast HTTPS-läge
about-httpsonly-title-connection-not-available = Säker anslutning inte tillgänglig
# Variables:
#   $websiteUrl (String) - Url of the website that failed to load. Example: www.example.com
about-httpsonly-explanation-unavailable2 = Du har aktiverat endast HTTPS-läge för förbättrad säkerhet och en HTTPS-version av <em>{ $websiteUrl }</em> finns inte tillgänglig.
about-httpsonly-explanation-question = Vad kan orsaka detta?
about-httpsonly-explanation-nosupport = Troligtvis stöder webbplatsen helt enkelt inte HTTPS.
about-httpsonly-explanation-risk = Det är också möjligt att en angripare är involverad. Om du väljer att besöka webbplatsen bör du inte ange någon känslig information som lösenord, e-post eller kreditkortsuppgifter.
about-httpsonly-explanation-continue = Om du fortsätter kommer endast HTTPS-läge att stängas av tillfälligt för den här webbplatsen.
about-httpsonly-button-continue-to-site = Fortsätt till HTTP-webbplatsen
about-httpsonly-button-go-back = Gå tillbaka
about-httpsonly-link-learn-more = Läs mer…

## Suggestion Box that only shows up if a secure connection to www can be established
## Variables:
##   $websiteUrl (String) - Url of the website that can be securely loded with these alternatives. Example: example.com

about-httpsonly-suggestion-box-header = Möjligt alternativ
about-httpsonly-suggestion-box-www-text = Det finns en säker version av <em>www.{ $websiteUrl }</em>. Du kan besöka den här sidan istället för <em>{ $websiteUrl }</em>.
about-httpsonly-suggestion-box-www-button = Gå till www.{ $websiteUrl }
