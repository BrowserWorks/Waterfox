# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

profiledowngrade-window =
    .title = Uruchomiono starszą wersję programu { -brand-product-name }
    .style = width: 490px;

profiledowngrade-window-create =
    .label = Utwórz nowy profil

profiledowngrade-sync = Używanie starszej wersji programu { -brand-product-name } może uszkodzić zakładki i historię przeglądania już zachowaną w istniejącym profilu programu { -brand-product-name }. Aby chronić swoje dane, utwórz nowy profil dla tej instalacji programu { -brand-short-name }. Zawsze można zalogować się na { -fxaccount-brand-name(case: "loc", capitalization: "lower") }, aby synchronizować zakładki i historię przeglądania między profilami.
profiledowngrade-nosync = Używanie starszej wersji programu { -brand-product-name } może uszkodzić zakładki i historię przeglądania już zachowaną w istniejącym profilu programu { -brand-product-name }. Aby chronić swoje dane, utwórz nowy profil dla tej instalacji programu { -brand-short-name }.

profiledowngrade-quit =
    .label =
        { PLATFORM() ->
            [windows] Zakończ
           *[other] Zakończ
        }
