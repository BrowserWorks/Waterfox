# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-dns-over-https-url-resolver = Käytä palveluntarjoajaa
    .accesskey = K

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (oletus)
    .tooltiptext = Käytä oletusosoitetta nimipalvelukyselyjen tekemiseksi HTTPS:n yli

connection-dns-over-https-url-custom =
    .label = Mukautettu
    .accesskey = M
    .tooltiptext = Kirjoita ensisijainen osoite nimipalvelukyselyjen tekemiseksi HTTPS:n yli

connection-dns-over-https-custom-label = Mukautettu

connection-dialog-window =
    .title = Yhteysasetukset
    .style =
        { PLATFORM() ->
            [macos] width: 44em !important
           *[other] width: 49em !important
        }

connection-proxy-legend = Määritä välityspalvelinasetukset

proxy-type-no =
    .label = Ei välityspalvelinta
    .accesskey = E

proxy-type-wpad =
    .label = Automaattiset välityspalvelinasetukset
    .accesskey = A

proxy-type-system =
    .label = Käytä järjestelmän välityspalvelinasetuksia
    .accesskey = K

proxy-type-manual =
    .label = Aseta välityspalvelinasetukset käsin
    .accesskey = e

proxy-http-label =
    .value = HTTP-välityspalvelin:
    .accesskey = H

http-port-label =
    .value = Portti:
    .accesskey = P

proxy-http-sharing =
    .label = Käytä tätä välityspalvelinta myös HTTPS:lle
    .accesskey = v

proxy-https-label =
    .value = HTTPS-välityspalvelin:
    .accesskey = S

ssl-port-label =
    .value = Portti:
    .accesskey = t

proxy-socks-label =
    .value = SOCKS-palvelin:
    .accesskey = C

socks-port-label =
    .value = Portti:
    .accesskey = i

proxy-socks4-label =
    .label = SOCKS v4
    .accesskey = 4

proxy-socks5-label =
    .label = SOCKS v5
    .accesskey = 5

proxy-type-auto =
    .label = Nouda välityspalvelinasetukset osoitteesta:
    .accesskey = N

proxy-reload-label =
    .label = Päivitä
    .accesskey = ä

no-proxy-label =
    .value = Ei välitystä osoitteille:
    .accesskey = v

no-proxy-example = Esimerkiksi: 192.168.1.0/24, .mozilla.org, .fi

# Note: Do not translate localhost, 127.0.0.1 and ::1.
no-proxy-localhost-label = Yhteyksiä kohteisiin localhost, 127.0.0.1 ja ::1 ei koskaan ohjata välityspalvelimen kautta.

proxy-password-prompt =
    .label = Älä pyydä tunnistautumista, jos salasana on tallennettu
    .accesskey = p
    .tooltiptext = Tämä asetus kirjaa sinut automaattisesti välityspalvelimiin, jos olet tallentanut niiden kirjautumistiedot. Jos kirjautuminen epäonnistuu, sinua tiedotetaan asiasta.

proxy-remote-dns =
    .label = Välipalvelimen DNS käytettäessä SOCKS v5:tä
    .accesskey = D

proxy-enable-doh =
    .label = Käytä DNS:ää HTTPS:n välityksellä
    .accesskey = H
