# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

account-provisioner-tab-title = Få en ny e-postadress från en tjänsteleverantör
provisioner-searching-icon =
    .alt = Söker…
account-provisioner-title = Skapa en ny e-postadress
account-provisioner-description = Använd våra betrodda partners för att få en ny privat och säker e-postadress.
account-provisioner-start-help = De söktermer som används skickas till { -vendor-short-name } (<a data-l10n-name="mozilla-privacy-link">sekretesspolicy</a>) och e-postleverantörer från tredje part <strong>mailfence.com</strong> (<a data-l10n-name="mailfence-privacy-link">sekretesspolicy</a>, <a data-l10n-name="mailfence-tou-link">användningsvillkor</a >) och <strong>gandi.net</strong> (<a data-l10n-name="gandi-privacy-link">sekretesspolicy</a>, <a data-l10n-name="gandi-tou-link">Användarvillkor</a>) för att hitta tillgängliga e-postadresser.
account-provisioner-mail-account-title = Köp en ny e-postadress
account-provisioner-mail-account-description = Thunderbird samarbetade med <a data-l10n-name="mailfence-home-link">Mailfence</a> för att erbjuda dig en ny privat och säker e-postadress. Vi anser att alla ska ha en säker e-postadress.
account-provisioner-domain-title = Köp en e-postadress och en egen domän
account-provisioner-domain-description = Thunderbird samarbetade med <a data-l10n-name="gandi-home-link">Gandi</a> för att erbjuda dig en anpassad domän. Detta låter dig använda vilken adress som helst på den domänen.

## Forms

account-provisioner-mail-input =
    .placeholder = Ditt namn, smeknamn eller annan sökterm
account-provisioner-domain-input =
    .placeholder = Ditt namn, smeknamn eller annan sökterm
account-provisioner-search-button = Sök
account-provisioner-button-cancel = Avbryt
account-provisioner-button-existing = Använd ett befintligt e-postkonto
account-provisioner-button-back = Gå tillbaka

## Notifications

account-provisioner-fetching-provisioners = Hämtar leverantörer…
account-provisioner-connection-issues = Det går inte att kommunicera med våra registreringsservrar. Kontrollera din anslutning.
account-provisioner-searching-email = Söker efter tillgängliga e-postkonton…
account-provisioner-searching-domain = Söker efter tillgängliga domäner…
account-provisioner-searching-error = Det gick inte att hitta några adresser att föreslå. Prova att ändra söktermerna.

## Illustrations

account-provisioner-step1-image =
    .title = Välj vilket konto du vill skapa

## Search results

# Variables:
# $count (Number) - The number of domains found during search.
account-provisioner-results-title =
    { $count ->
        [one] En tillgänglig adress hittades för:
       *[other] { $count } tillgängliga adresser hittades för:
    }
account-provisioner-mail-results-caption = Du kan försöka söka efter smeknamn eller någon annan term för att hitta fler e-postadresser.
account-provisioner-domain-results-caption = Du kan försöka söka efter smeknamn eller någon annan term för att hitta fler domäner.
account-provisioner-free-account = Gratis
account-provision-price-per-year = { $price } per år
account-provisioner-all-results-button = Visa alla resultat
