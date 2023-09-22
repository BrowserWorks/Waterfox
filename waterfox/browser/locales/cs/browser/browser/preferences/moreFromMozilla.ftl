# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These strings are used in the about:preferences moreFromBrowserWorks page

more-from-moz-title =
    { -vendor-short-name.case-status ->
        [with-cases] Více od { -vendor-short-name(case: "gen") }
       *[no-cases] Více od společnosti { -vendor-short-name }
    }
more-from-moz-category =
    .tooltiptext =
        { -vendor-short-name.case-status ->
            [with-cases] Více od { -vendor-short-name(case: "gen") }
           *[no-cases] Více od společnosti { -vendor-short-name }
        }

more-from-moz-subtitle =
    { -vendor-short-name.case-status ->
        [with-cases] Podívejte se na další produkty od { -vendor-short-name(case: "gen") }, které podporují zdravý internet.
       *[no-cases] Podívejte se na další produkty od společnosti { -vendor-short-name }, které podporují zdravý internet.
    }

more-from-moz-firefox-mobile-title = { -brand-product-name } pro mobily
more-from-moz-firefox-mobile-description = Mobilní prohlížeč, který klade důraz na vaše soukromí.

more-from-moz-mozilla-vpn-title = { -mozilla-vpn-brand-name }
more-from-moz-mozilla-vpn-description = Objevte přidanou vrstvu anonymního prohlížení a ochrany.

more-from-moz-qr-code-box-firefox-mobile-title = Pro stažení do svého mobilního zařízení namiřte fotoaparát na QR kód. Poté klepněte na adresu odkazu, která se objeví.
more-from-moz-qr-code-box-firefox-mobile-button = Nebo si nechte odkaz do mobilu poslat e-mailem
more-from-moz-qr-code-firefox-mobile-img =
    .alt =
        { -brand-product-name.case-status ->
            [with-cases] QR kód pro stažení { -brand-product-name(case: "gen") } pro mobily
           *[no-cases] QR kód pro stažení aplikace { -brand-product-name } pro mobily
        }

more-from-moz-button-mozilla-vpn-2 = Získat VPN

more-from-moz-learn-more-link = Zjistit více

## These strings are for the Waterfox Relay card in about:preferences moreFromBrowserWorks page

more-from-moz-firefox-relay-title = { -relay-brand-name }
more-from-moz-firefox-relay-description = Chraňte svou e-mailovou schránku a svou identitu pomocí bezplatného maskování e-mailů.
more-from-moz-firefox-relay-button = Získejte { -relay-brand-short-name(case: "acc") }
