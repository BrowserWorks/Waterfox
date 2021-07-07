# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

troubleshoot-mode-window =
    .title = { -brand-short-name } hibaelhárítási mód
    .style = width: 37em;
troubleshoot-mode-description = A problémák diagnosztizálásához használja a { -brand-short-name } hibaelhárítási módját. Kiegészítői és testreszabásai ideiglenesen letiltásra kerülnek.
troubleshoot-mode-description2 = A változtatások némelyikét vagy mindegyikét állandóvá teheti:
troubleshoot-mode-disable-addons =
    .label = Minden kiegészítő letiltása
    .accesskey = l
troubleshoot-mode-reset-toolbars =
    .label = Eszköztárak és vezérlőelemek alaphelyzetbe állítása
    .accesskey = E
troubleshoot-mode-change-and-restart =
    .label = Változtatások végrehajtása és újraindítás
    .accesskey = v
troubleshoot-mode-continue =
    .label = Folytatás a hibaelhárítási módban
    .accesskey = F
troubleshoot-mode-quit =
    .label =
        { PLATFORM() ->
            [windows] Kilépés
           *[other] Kilépés
        }
    .accesskey =
        { PLATFORM() ->
            [windows] K
           *[other] K
        }
