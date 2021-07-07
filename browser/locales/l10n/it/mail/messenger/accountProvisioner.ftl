# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

account-provisioner-tab-title = Ottieni un nuovo indirizzo email da un fornitore di servizi
provisioner-searching-icon =
    .alt = Ricerca in corso…
account-provisioner-title = Crea un nuovo indirizzo email
account-provisioner-description = Utilizza i nostri partner di fiducia per ottenere un nuovo indirizzo email privato e sicuro.
account-provisioner-start-help = I termini di ricerca utilizzati vengono inviati a { -vendor-short-name } (<a data-l10n-name="mozilla-privacy-link">Informativa sulla privacy</a>) e ai provider di posta elettronica di terze parti <strong>mailfence.com</strong> (<a data-l10n-name="mailfence-privacy-link">Informativa sulla privacy</a>, <a data-l10n-name="mailfence-tou-link">Termini di utilizzo</a>) e <strong>gandi.net</strong> (<a data-l10n-name="gandi-privacy-link">Informativa sulla privacy</a>, <a data-l10n-name="gandi-tou-link">Termini di utilizzo</a>) per trovare gli indirizzi email disponibili.
account-provisioner-mail-account-title = Compra un nuovo indirizzo email
account-provisioner-mail-account-description = Thunderbird collabora con <a data-l10n-name="mailfence-home-link">Mailfence</a> per offrirti un nuovo servizio di posta elettronica privato e sicuro, perché riteniamo che tutti abbiano diritto ad un servizio sicuro.
account-provisioner-domain-title = Compra un indirizzo email con dominio personalizzato
account-provisioner-domain-description = Thunderbird collabora con <a data-l10n-name="gandi-home-link">Gandi</a> per offrirti un dominio personalizzato: ciò ti consente di utilizzare qualsiasi indirizzo su quel dominio.

## Forms

account-provisioner-mail-input =
    .placeholder = Il tuo nome, soprannome o altro termine di ricerca
account-provisioner-domain-input =
    .placeholder = Il tuo nome, soprannome o altro termine di ricerca
account-provisioner-search-button = Cerca
account-provisioner-button-cancel = Annulla
account-provisioner-button-existing = Utilizza un account di posta elettronica esistente
account-provisioner-button-back = Torna indietro

## Notifications

account-provisioner-fetching-provisioners = Recupero fornitori in corso…
account-provisioner-connection-issues = Impossibile comunicare con i nostri server di autenticazione. Controllare la connessione.
account-provisioner-searching-email = Ricerca account di posta elettronica disponibili…
account-provisioner-searching-domain = Ricerca domini disponibili…
account-provisioner-searching-error = Impossibile trovare indirizzi da suggerire. Prova a cambiare i termini di ricerca.

## Illustrations

account-provisioner-step1-image =
    .title = Scegli quale account creare

## Search results

# Variables:
# $count (Number) - The number of domains found during search.
account-provisioner-results-title =
    { $count ->
        [one] Trovato un indirizzo disponibile per:
       *[other] Trovati { $count } indirizzi disponibili per:
    }
account-provisioner-mail-results-caption = È possibile cercare soprannomi o altri termini per trovare più indirizzi di posta.
account-provisioner-domain-results-caption = È possibile cercare soprannomi o altri termini per trovare più domini.
account-provisioner-free-account = Gratuito
account-provision-price-per-year = { $price } all’anno
account-provisioner-all-results-button = Visualizza tutti i risultati
