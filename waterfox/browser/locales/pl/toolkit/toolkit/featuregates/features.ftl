# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-masonry2 =
    .label = CSS: układ typu „Masonry”
experimental-features-css-masonry-description = Włącza obsługę eksperymentalnego układu CSS typu „Masonry”. Ta <a data-l10n-name="explainer">strona</a> zawiera jego ogólny opis. W <a data-l10n-name="w3c-issue">tym zgłoszeniu w serwisie GitHub</a> lub <a data-l10n-name="bug">tym błędzie</a> można dodać komentarz na jego temat.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-gpu2 =
    .label = API internetowe: WebGPU
experimental-features-web-gpu-description2 = To nowe API dostarcza niskopoziomową obsługę wykonywania obliczeń i renderowania grafiki za pomocą <a data-l10n-name="wikipedia">procesora graficznego (GPU)</a> urządzenia lub komputera użytkownika. <a data-l10n-name="spec">Specyfikacja</a> jest nadal w trakcie przygotowywania. <a data-l10n-name="bugzilla">Zgłoszenie 1602129</a> zawiera więcej informacji.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-media-jxl =
    .label = Multimedia: JPEG XL
experimental-features-media-jxl-description = Po włączeniu tej funkcji { -brand-short-name } obsługuje format obrazów JPEG XL (JXL). Jest to ulepszony format obrazów obsługujący bezstratne przejście z tradycyjnych plików JPEG. <a data-l10n-name="bugzilla">Zgłoszenie 1539075</a> zawiera więcej informacji.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-constructable-stylesheets =
    .label = CSS: arkusze stylów za pomocą konstruktora
experimental-features-css-constructable-stylesheets-description = Dodanie konstruktora do interfejsu <a data-l10n-name="mdn-cssstylesheet">CSSStyleSheet</a>, a także szereg powiązanych zmian umożliwia bezpośrednie tworzenie nowych arkuszy stylów bez konieczności dodawania arkusza do kodu HTML. Znacznie ułatwia to tworzenie arkuszy stylów wielokrotnego użytku do użycia za pomocą <a data-l10n-name="mdn-shadowdom">Shadow DOM</a>. <a data-l10n-name="bugzilla">Zgłoszenie 1520690</a> zawiera więcej informacji.
experimental-features-devtools-compatibility-panel =
    .label = Narzędzia dla programistów: panel zgodności
experimental-features-devtools-compatibility-panel-description = Panel boczny inspektora stron, wyświetlający informacje o stanie zgodności aplikacji z różnymi przeglądarkami. <a data-l10n-name="bugzilla">Zgłoszenie 1584464</a> zawiera więcej informacji.
# Do not translate 'SameSite', 'Lax' and 'None'.
experimental-features-cookie-samesite-lax-by-default2 =
    .label = Ciasteczka: „SameSite=Lax” jest domyślne
experimental-features-cookie-samesite-lax-by-default2-description = Domyślnie traktuje ciasteczka jako „SameSite=Lax”, jeśli nie określono żadnego atrybutu „SameSite”. Deweloperzy muszą wyrazić zgodę na obecne status quo nieograniczonego użytkowania, bezpośrednio ustawiając „SameSite=None”.
# Do not translate 'SameSite', 'Lax' and 'None'.
experimental-features-cookie-samesite-none-requires-secure2 =
    .label = Ciasteczka: „SameSite=None” wymaga atrybutu bezpieczeństwa
experimental-features-cookie-samesite-none-requires-secure2-description = Ciasteczka z atrybutem „SameSite=None” wymagają atrybutu bezpieczeństwa. Ta funkcja wymaga włączenia „Ciasteczka: »SameSite=Lax« jest domyślne”.
# about:home should be kept in English, as it refers to the the URI for
# the internal default home page.
experimental-features-abouthome-startup-cache =
    .label = Pamięć podręczna uruchamiania about:home
experimental-features-abouthome-startup-cache-description = Pamięć podręczna dla początkowego dokumentu about:home, który jest domyślnie wczytywany podczas uruchamiania. Celem tej pamięci podręcznej jest przyspieszenie uruchamiania.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-cookie-samesite-schemeful =
    .label = Ciasteczka: SameSite typu „Schemeful”
experimental-features-cookie-samesite-schemeful-description = Traktuje ciasteczka z tej samej domeny, ale o różnych protokołach (np. http://example.com i https://example.com) jako ciasteczka między witrynami, zamiast z tej samej witryny. Zwiększa bezpieczeństwo, ale potencjalnie zakłóca działanie witryn.
# "Service Worker" is an API name and is usually not translated.
experimental-features-devtools-serviceworker-debugger-support =
    .label = Narzędzia dla programistów: debugowanie wątków usługowych
# "Service Worker" is an API name and is usually not translated.
experimental-features-devtools-serviceworker-debugger-support-description = Włącza eksperymentalną obsługę wątków usługowych w panelu debugera. Ta funkcja może spowolnić narzędzia dla programistów i zwiększyć zużycie pamięci.
# WebRTC global mute toggle controls
experimental-features-webrtc-global-mute-toggles =
    .label = Przełączniki globalnego wyciszania WebRTC
experimental-features-webrtc-global-mute-toggles-description = Dodaje elementy sterujące do globalnego wskaźnika udostępniania WebRTC umożliwiające użytkownikom globalne wyciszanie transmisji dźwięku z mikrofonu i obrazu z kamery.
# JS JIT Warp project
experimental-features-js-warp =
    .label = JavaScript JIT: Warp
experimental-features-js-warp-description = Włącza Warp, projekt mający na celu zwiększenie wydajności JavaScriptu i zmniejszenie zużycia pamięci.
# Search during IME
experimental-features-ime-search =
    .label = Pasek adresu: wyświetlanie wyników podczas edycji IME
experimental-features-ime-search-description = IME (edytor metody wprowadzania) to narzędzie umożliwiające wpisywanie złożonych symboli, na przykład tych używanych w językach wschodnioazjatyckich czy indyjskich, za pomocą standardowej klawiatury. Włączenie tego eksperymentu spowoduje, że panel paska adresu pozostanie otwarty, pokazując wyniki wyszukiwania i podpowiedzi, kiedy używane jest IME do wpisywania tekstu. Zauważ, że IME może wyświetlać panel zakrywający wyniki paska adresu, dlatego też ta preferencja jest proponowana tylko w przypadku IME, które nie korzystają z tego typu panelu.
# Text recognition for images
experimental-features-text-recognition =
    .label = Rozpoznawanie tekstu
experimental-features-text-recognition-description = Włącza funkcje rozpoznawania tekstu na obrazach.
