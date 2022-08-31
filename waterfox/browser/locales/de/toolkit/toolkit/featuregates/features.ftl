# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-masonry2 =
    .label = CSS: Masonry Layout
experimental-features-css-masonry-description = Aktiviert die Unterstützung für die experimentelle CSS-Mauerwerk-Darstellung. Weitere Informationen zu den Grundlagen dieser Funktion sind in <a data-l10n-name="explainer">dieser Erläuterung</a> zu finden. Rückmeldung kann per Kommentar  <a data-l10n-name="w3c-issue">in diesem Github Issue</a> oder <a data-l10n-name="bug">in diesem Bug</a> gegeben werden.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-gpu2 =
    .label = Web API: WebGPU
experimental-features-web-gpu-description2 = Diese neue API bietet eine Low-Level-Unterstützung für die Durchführung von Berechnungen und Grafikdarstellung mit der <a data-l10n-name="wikipedia">Graphics Processing Unit (GPU)</a> des Geräts oder Computers des Benutzers. Die <a data-l10n-name="spec">Spezifikation</a> ist noch in Arbeit. Weitere Informationen erhalten Sie im <a data-l10n-name="bugzilla">Bug 1602129</a>.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-media-jxl =
    .label = Media: JPEG XL
experimental-features-media-jxl-description = Wenn diese Funktion aktiviert ist, unterstützt { -brand-short-name } das JPEG-XL-Format (JXL). Dies ist ein erweitertes Bilddateiformat, das einen verlustfreien Übergang von traditionellen JPEG-Dateien unterstützt. Weitere Informationen erhalten Sie im <a data-l10n-name="bugzilla">Bug 1539075</a>.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-constructable-stylesheets =
    .label = CSS: Constructable Stylesheets
experimental-features-css-constructable-stylesheets-description = Durch das Hinzufügen eines Konstruktors zur <a data-l10n-name="mdn-cssstylesheet">CSSStyleSheet</a>-Schnittstelle sowie einer Vielzahl damit zusammenhängender Änderungen können direkt neue Stylesheets erstellt werden, ohne dass das Sheet dem HTML hinzugefügt werden muss. Das macht es viel einfacher, wiederverwendbare Stylesheets für den Einsatz mit <a data-l10n-name="mdn-shadowdom">Shadow DOM</a> zu erstellen. Weitere Informationen erhalten Sie im <a data-l10n-name="bugzilla">Bug 1520690</a>.
experimental-features-devtools-compatibility-panel =
    .label = Entwicklerwerkzeuge: Kompatibilitäts-Ansicht
experimental-features-devtools-compatibility-panel-description = Eine Seitenleiste für den Seiteninspektor, die Informationen zur Kompatibilität Ihrer App in verschiedenen Browsern anzeigt. Weitere Informationen erhalten Sie im <a data-l10n-name="bugzilla">Bug 1584464</a>.
# Do not translate 'SameSite', 'Lax' and 'None'.
experimental-features-cookie-samesite-lax-by-default2 =
    .label = Cookies: SameSite=Lax standardmäßig
experimental-features-cookie-samesite-lax-by-default2-description = Cookies werden standardmäßig als "SameSite=Lax" behandelt, wenn kein "SameSite"-Attribut angegeben ist. Entwickler können den aktuellen Status quo der uneingeschränkten Nutzung verwenden, indem sie explizit "SameSite=None" festlegen.
# Do not translate 'SameSite', 'Lax' and 'None'.
experimental-features-cookie-samesite-none-requires-secure2 =
    .label = Cookies: SameSite=None erfordert "secure"-Attribut
experimental-features-cookie-samesite-none-requires-secure2-description = Cookies mit dem Attribut "SameSite=None" erfordern das "secure"-Attribut. Diese Funktion erfordert "Cookies: SameSite=Lax standardmäßig".
# about:home should be kept in English, as it refers to the the URI for
# the internal default home page.
experimental-features-abouthome-startup-cache =
    .label = about:home-Start-Cache
experimental-features-abouthome-startup-cache-description = Ein Cache für das anfängliche about:home-Dokument, das beim Start standardmäßig geladen wird. Der Zweck des Caches besteht darin, die Startleistung zu verbessern.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-cookie-samesite-schemeful =
    .label = Cookies: Schemeful SameSite
experimental-features-cookie-samesite-schemeful-description = Cookies aus derselben Domain, aber mit verschiedenen Schemata (z. B. http://example.com und https://example.com) werden als seitenübergreifende Cookies statt innerhalb einer Website behandelt. Verbessert die Sicherheit, führt aber potenziell zu Problemen.
# "Service Worker" is an API name and is usually not translated.
experimental-features-devtools-serviceworker-debugger-support =
    .label = Entwicklerwerkzeuge: Service-Worker-Debugging
# "Service Worker" is an API name and is usually not translated.
experimental-features-devtools-serviceworker-debugger-support-description = Aktiviert die experimentelle Unterstützung für Service-Worker in der Debugger-Ansicht. Diese Funktion kann die Entwicklerwerkzeuge verlangsamen und den Speicherverbrauch erhöhen.
# WebRTC global mute toggle controls
experimental-features-webrtc-global-mute-toggles =
    .label = Globale WebRTC-Stummschaltungs-Steuerung
experimental-features-webrtc-global-mute-toggles-description = Fügt dem globalen WebRTC-Teilen-Hinweis Steuerelemente hinzu, mit denen Benutzer ihre Mikrofone und Kameras für alle Tabs abschalten können.
# JS JIT Warp project
experimental-features-js-warp =
    .label = JavaScript JIT: Warp
experimental-features-js-warp-description = Warp aktivieren: ein Projekt zur Verbesserung der Leistung und des Speicherverbrauchs von JavaScript.
# Search during IME
experimental-features-ime-search =
    .label = Adressleiste: Ergebnisse während der IME-Komposition anzeigen
experimental-features-ime-search-description = Ein IME (Input Method Editor) ist ein Werkzeug, mit dem Sie komplexe Symbole, wie sie in ostasiatischen oder indischen Schriftsprachen verwendet werden, über eine Standardtastatur eingeben können. Durch Aktivieren dieses Experiments bleibt die Adressleisten-Ansicht geöffnet, wodurch Suchergebnisse und Vorschläge angezeigt werden, während IME zur Texteingabe verwendet wird. Beachten Sie, dass der IME möglicherweise ein Fenster anzeigt, das die Ergebnisse der Adressleiste verdeckt. Daher wird diese Einstellung nur für IME empfohlen, die diese Art von Fenster nicht verwenden.
# Text recognition for images
experimental-features-text-recognition =
    .label = Texterkennung
experimental-features-text-recognition-description = Funktionalität zur Erkennung von Text in Bildern aktivieren
