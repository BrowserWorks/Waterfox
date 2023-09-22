# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

profiledowngrade-window2 =
    .title =
        { -brand-product-name.case-status ->
            [with-cases] Spustili jste starší verzi { -brand-product-name(case: "gen") }
           *[no-cases] Spustili jste starší verzi aplikace { -brand-product-name }
        }
    .style = min-width: 490px;
profiledowngrade-window-create =
    .label = Vytvořit nový profil
profiledowngrade-sync =
    { -brand-product-name.case-status ->
        [with-cases] Spuštěním starší verze { -brand-product-name(case: "gen") } může dojít k poškození záložek a historie prohlížení uložených v jeho stávajícím profilu. Pro ochranu vašich dat si prosím pro tuto instalaci { -brand-short-name(case: "gen") } vytvořte profil nový. Pro synchronizaci dat mezi oběma profily můžete použít { -fxaccount-brand-name(case: "acc", capitalization: "lower") }.
       *[no-cases] Spuštěním starší verze aplikace { -brand-product-name } může dojít k poškození záložek a historie prohlížení uložených v jeho stávajícím profilu. Pro ochranu vašich dat si prosím pro tuto instalaci aplikace { -brand-short-name } vytvořte profil nový. Pro synchronizaci dat mezi oběma profily můžete použít { -fxaccount-brand-name(case: "acc", capitalization: "lower") }.
    }
profiledowngrade-sync2 = Spuštěním starší verze aplikace { -brand-product-name } může dojít k poškození záložek a historie prohlížení uložených v jeho stávajícím profilu. Pro ochranu vašich dat si prosím pro tuto instalaci aplikace { -brand-short-name } vytvořte profil nový. Pro synchronizaci dat mezi oběma profily můžete použít { -brand-short-name(case: "acc", capitalization: "lower") }.
profiledowngrade-nosync =
    { -brand-product-name.case-status ->
        [with-cases] Spuštěním starší verze { -brand-product-name(case: "gen") } může dojít k poškození záložek a historie prohlížení uložených v jeho stávajícím profilu. Pro ochranu vašich dat si prosím pro tuto instalaci { -brand-short-name(case: "gen") } vytvořte profil nový.
       *[no-cases] Spuštěním starší verze aplikace { -brand-product-name } může dojít k poškození záložek a historie prohlížení uložených v jeho stávajícím profilu. Pro ochranu vašich dat si prosím pro tuto instalaci aplikace { -brand-short-name } vytvořte profil nový.
    }
profiledowngrade-quit =
    .label = Ukončit
