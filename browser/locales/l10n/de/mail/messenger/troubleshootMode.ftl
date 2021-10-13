# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

troubleshoot-mode-window =
    .title = { -brand-short-name } - Fehlerbehebungsmodus
    .style = width: 37em;

troubleshoot-mode-description = Nutzen Sie den Fehlerbehebungsmodus von { -brand-short-name }, um Probleme zu diagnostizieren. Ihre Erweiterungen und Anpassungen werden vorübergehend deaktiviert.

troubleshoot-mode-description2 = Sie können alle oder einige dieser Änderungen auch dauerhaft beibehalten:

troubleshoot-mode-disable-addons =
    .label = Alle Add-ons deaktivieren
    .accesskey = d

troubleshoot-mode-reset-toolbars =
    .label = Alle Symbolleisten zurücksetzen
    .accesskey = S

troubleshoot-mode-change-and-restart =
    .label = Änderungen ausführen und neu starten
    .accesskey = n

troubleshoot-mode-continue =
    .label = Im Abgesicherten Modus weiterarbeiten
    .accesskey = m

troubleshoot-mode-quit =
    .label =
        { PLATFORM() ->
            [windows] Beenden
           *[other] Beenden
        }
    .accesskey =
        { PLATFORM() ->
            [windows] B
           *[other] B
        }
