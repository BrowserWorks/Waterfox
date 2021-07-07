# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

permissions-window =
    .title = Undantag
    .style = width: 45em

permissions-close-key =
    .key = w

permissions-address = Webbplatsens adress
    .accesskey = d

permissions-block =
    .label = Blockera
    .accesskey = B

permissions-session =
    .label = Tillåt för sessionen
    .accesskey = s

permissions-allow =
    .label = Tillåt
    .accesskey = å

permissions-button-off =
    .label = Stäng av
    .accesskey = a

permissions-button-off-temporarily =
    .label = Stäng av tillfälligt
    .accesskey = t

permissions-site-name =
    .label = Webbplats

permissions-status =
    .label = Status

permissions-remove =
    .label = Ta bort webbplats
    .accesskey = T

permissions-remove-all =
    .label = Ta bort alla webbplatser
    .accesskey = a

permission-dialog =
    .buttonlabelaccept = Spara ändringar
    .buttonaccesskeyaccept = S

permissions-autoplay-menu = Standard för alla webbplatser:

permissions-searchbox =
    .placeholder = Sök webbplats

permissions-capabilities-autoplay-allow =
    .label = Tillåt ljud och video
permissions-capabilities-autoplay-block =
    .label = Blockera ljud
permissions-capabilities-autoplay-blockall =
    .label = Blockera ljud och video

permissions-capabilities-allow =
    .label = Tillåt
permissions-capabilities-block =
    .label = Blockera
permissions-capabilities-prompt =
    .label = Fråga alltid

permissions-capabilities-listitem-allow =
    .value = Tillåt
permissions-capabilities-listitem-block =
    .value = Blockera
permissions-capabilities-listitem-allow-session =
    .value = Tillåten för session

permissions-capabilities-listitem-off =
    .value = Av
permissions-capabilities-listitem-off-temporarily =
    .value = Tillfälligt av

## Invalid Hostname Dialog

permissions-invalid-uri-title = Ogiltigt värdnamn
permissions-invalid-uri-label = Skriv in ett giltigt värdnamn

## Exceptions - Tracking Protection

permissions-exceptions-etp-window =
    .title = Undantag för förbättrat spårningsskydd
    .style = { permissions-window.style }
permissions-exceptions-etp-desc = Du har inaktiverat skydd på dessa webbplatser.

## Exceptions - Cookies

permissions-exceptions-cookie-window =
    .title = Undantag - Kakor och webbplatsdata
    .style = { permissions-window.style }
permissions-exceptions-cookie-desc = Du kan ange vilka webbplatser som alltid eller aldrig får använda kakor och webbplatsdata.  Skriv den exakta adressen till den webbplats du vill hantera och klicka sedan på Blockera, Tillåt för sessionen eller Tillåt.

## Exceptions - HTTPS-Only Mode

permissions-exceptions-https-only-window =
    .title = Undantag - Endast HTTPS-läge
    .style = { permissions-window.style }
permissions-exceptions-https-only-desc = Du kan inaktivera Endast HTTPS-läge för specifika webbplatser. { -brand-short-name } försöker inte uppgradera anslutningen för att säkra HTTPS för dessa webbplatser. Undantag gäller inte privata fönster.

## Exceptions - Pop-ups

permissions-exceptions-popup-window =
    .title = Tillåtna webbplatser - popup-fönster
    .style = { permissions-window.style }
permissions-exceptions-popup-desc = Du kan ange vilka webbplatser som får öppna popup-fönster. Skriv in adressen till platsen du vill godkänna och klicka på Tillåt.

## Exceptions - Saved Logins

permissions-exceptions-saved-logins-window =
    .title = Undantag - Sparade inloggningar
    .style = { permissions-window.style }
permissions-exceptions-saved-logins-desc = Inloggningar för följande webbplatser kommer inte att sparas

## Exceptions - Add-ons

permissions-exceptions-addons-window =
    .title = Tillåtna webbplatser - Installation av tillägg
    .style = { permissions-window.style }
permissions-exceptions-addons-desc = Du kan ange vilka webbplatser som får installera tillägg. Skriv in adressen till platsen du vill godkänna och klicka på Tillåt.

## Site Permissions - Autoplay

permissions-site-autoplay-window =
    .title = Inställningar - Automatisk uppspelning
    .style = { permissions-window.style }
permissions-site-autoplay-desc = Du kan hantera de webbplatser som inte följer dina standardinställningar för automatisk uppspelning här.

## Site Permissions - Notifications

permissions-site-notification-window =
    .title = Inställningar - Behörigheter för aviseringar
    .style = { permissions-window.style }
permissions-site-notification-desc = Följande webbplatser har begärt att skicka meddelanden. Du kan ange vilka webbplatser som får skicka aviseringar. Du kan också blockera nya förfrågningar om att tillåta meddelanden.
permissions-site-notification-disable-label =
    .label = Blockera nya förfrågningar om att tillåta meddelanden
permissions-site-notification-disable-desc = Detta kommer att förhindra att webbplatser som inte listas ovan från att begära tillstånd att skicka meddelanden. Blockering av meddelanden kan störa vissa webbplatsfunktioner.

## Site Permissions - Location

permissions-site-location-window =
    .title = Inställningar - Behörigheter för plats
    .style = { permissions-window.style }
permissions-site-location-desc = Följande webbplatser har begärt att komma åt din position. Du kan ange vilka webbplatser som får komma åt din position. Du kan också blockera nya förfrågningar om att få tillgång till din position.
permissions-site-location-disable-label =
    .label = Blockera nya förfrågningar om att få tillgång till din position
permissions-site-location-disable-desc = Detta kommer att förhindra att webbplatser som inte listas ovan från att begära tillstånd att komma åt din position. Om du blockerar åtkomst till din position kan det störa vissa webbplatsfunktioner.

## Site Permissions - Virtual Reality

permissions-site-xr-window =
    .title = Inställningar - Rättigheter för virtuell verklighet
    .style = { permissions-window.style }
permissions-site-xr-desc = Följande webbplatser har begärt att få tillgång till dina enheter för virtuell verklighet. Du kan ange vilka webbplatser som får åtkomst till dina enheter för virtuell verklighet. Du kan också blockera nya förfrågningar som ber om åtkomst till dina enheter för virtuell verklighet.
permissions-site-xr-disable-label =
    .label = Blockera nya förfrågningar som ber om åtkomst till dina enheter för virtuell verklighet
permissions-site-xr-disable-desc = Detta förhindrar alla webbplatser som inte listas ovan från att begära tillåtelse att få tillgång till dina enheter för virtuell verklighet. Om du blockerar åtkomst till dina enheter för virtuell verklighet kan vissa webbplatsfunktioner sluta att fungera.

## Site Permissions - Camera

permissions-site-camera-window =
    .title = Inställningar - Behörigheter för kamera
    .style = { permissions-window.style }
permissions-site-camera-desc = Följande webbplatser har begärt att du ska komma åt din kamera. Du kan ange vilka webbplatser som får komma åt din kamera. Du kan också blockera nya förfrågningar om att komma åt din kamera.
permissions-site-camera-disable-label =
    .label = Blockera nya förfrågningar om att få tillgång till din kamera
permissions-site-camera-disable-desc = Detta kommer att förhindra att webbplatser som inte listas ovan från att begära tillstånd att komma åt din kamera. Att blockera åtkomst till din kamera kan störa vissa webbplatsfunktioner.

## Site Permissions - Microphone

permissions-site-microphone-window =
    .title = Inställningar - Behörigheter för mikrofon
    .style = { permissions-window.style }
permissions-site-microphone-desc = Följande webbplatser har begärt att du ska komma åt din mikrofon. Du kan ange vilka webbplatser som får komma åt din mikrofon. Du kan också blockera nya förfrågningar om att komma åt din mikrofon.
permissions-site-microphone-disable-label =
    .label = Blockera nya förfrågningar om att få tillgång till din mikrofon
permissions-site-microphone-disable-desc = Detta kommer att förhindra att webbplatser som inte listas ovan från att begära tillstånd att komma åt din mikrofon. Om du blockerar åtkomst till din mikrofon kan det störa vissa webbplatsfunktioner.
