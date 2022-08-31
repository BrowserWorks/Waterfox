# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

troubleshoot-mode-window =
    .title = { -brand-short-name } Felsökningsläge
    .style = width: 37em;

troubleshoot-mode-description = Använd { -brand-short-name } felsökningsläge för att diagnostisera problem. Dina tillägg och anpassningar kommer att inaktiveras tillfälligt.

troubleshoot-mode-description2 = Du kan göra några eller alla av dessa ändringar permanenta:

troubleshoot-mode-disable-addons =
    .label = Inaktivera alla tillägg
    .accesskey = n

troubleshoot-mode-reset-toolbars =
    .label = Återställ verktygsfält och kontroller
    .accesskey = t

troubleshoot-mode-change-and-restart =
    .label = Gör ändringar och starta om
    .accesskey = G

troubleshoot-mode-continue =
    .label = Fortsätt i felsökningsläge
    .accesskey = F

troubleshoot-mode-quit =
    .label =
        { PLATFORM() ->
            [windows] Avsluta
           *[other] Avsluta
        }
    .accesskey =
        { PLATFORM() ->
            [windows] A
           *[other] A
        }
