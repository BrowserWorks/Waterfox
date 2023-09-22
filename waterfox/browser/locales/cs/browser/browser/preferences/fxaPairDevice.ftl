# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

fxa-pair-device-dialog-sync2 =
    .style = min-width: 32em;

fxa-qrcode-pair-title =
    { -brand-product-name.case-status ->
        [with-cases] Synchronizujte { -brand-product-name(case: "acc") } se svým telefonem či tabletem.
       *[no-cases] Synchronizujte aplikaci { -brand-product-name } se svým telefonem či tabletem.
    }
fxa-qrcode-pair-step1 =
    { -brand-product-name.case-status ->
        [with-cases] 1. Otevřete { -brand-product-name(case: "acc") } na svém mobilním zařízení.
       *[no-cases] 1. Otevřete aplikaci { -brand-product-name } na svém mobilním zařízení.
    }

fxa-qrcode-pair-step2-signin = 2. Přejděte do nabídky (<img data-l10n-name="ios-menu-icon"/> v systému iOS nebo <img data-l10n-name="android-menu-icon"/> v systému Android) a klepněte na <strong>Synchronizace a ukládání dat</strong>

fxa-qrcode-pair-step3 = 3. Klepněte na <strong>Připraveno na skenování</strong> a podržte svůj telefon nad tímto kódem

fxa-qrcode-error-title = Párování se nezdařilo.

fxa-qrcode-error-body = Zkuste to znovu.
