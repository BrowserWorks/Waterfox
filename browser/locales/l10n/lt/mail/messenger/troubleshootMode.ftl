# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

troubleshoot-mode-window =
    .title = „{ -brand-short-name }“ trikčių šalinimo režimas
    .style = width: 37em;

troubleshoot-mode-description = Jei kyla problemų, panaudokite „{ -brand-short-name }“ trikčių šalinimo režimą. Įdiegti priedai ir tinkinimai bus laikinai išjungti.

troubleshoot-mode-description2 = Visus ar dalį pakeitimų galite pasilikti:

troubleshoot-mode-disable-addons =
    .label = Išjungti visus priedus
    .accesskey = I

troubleshoot-mode-reset-toolbars =
    .label = Atstatyti priemonių juostų ir valdiklių numatytąsias būsenas
    .accesskey = A

troubleshoot-mode-change-and-restart =
    .label = Pakeisti ir paleisti iš naujo
    .accesskey = P

troubleshoot-mode-continue =
    .label = Tęsti trikčių šalinimo režimu
    .accesskey = T

troubleshoot-mode-quit =
    .label =
        { PLATFORM() ->
            [windows] Baigti darbą
           *[other] Baigti darbą
        }
    .accesskey =
        { PLATFORM() ->
            [windows] x
           *[other] Q
        }
