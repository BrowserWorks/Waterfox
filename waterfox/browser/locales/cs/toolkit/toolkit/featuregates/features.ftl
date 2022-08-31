# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-masonry2 =
    .label = CSS: Masonry Layout
experimental-features-css-masonry-description = Zapne podporu experimentálního CSS Masonry Layoutu. Podrobnosti o této funkci najdete <a data-l10n-name="explainer">zde</a>. Zpětnou vazbu nám můžete napsat <a data-l10n-name="w3c-issue">zde na GitHubu</a> nebo <a data-l10n-name="bug">do tohoto bugu</a>.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-gpu2 =
    .label = Web API: WebGPU
experimental-features-web-gpu-description2 = Toto nové API poskytuje nízkoúrovňový přístup k provádění výpočtů a vykreslování grafiky pomocí <a data-l10n-name="wikipedia">grafického procesoru (GPU)</a> uživatelského zařízení. Jeho <a data-l10n-name="spec">specifikace</a> je stále rozpracovaná. Podrobnosti najdete v <a data-l10n-name="bugzilla">bugu 1602129</a>.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-media-jxl =
    .label = Média: JPEG XL
experimental-features-media-jxl-description =
    Zapne { -brand-short-name.gender ->
        [masculine] ve { -brand-short-name(case: "loc") }
        [feminine] v { -brand-short-name(case: "loc") }
        [neuter] v { -brand-short-name(case: "loc") }
       *[other] v aplikaci { -brand-short-name }
    } podporu pro formát JPEG XL (JXL). Toto je vylepšený formát obrazového souboru, který podporuje bezztrátový přechod z tradičních JPEG souborů. Podrobnosti najdete v <a data-l10n-name="bugzilla">bugu 1539075</a>.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-constructable-stylesheets =
    .label = CSS: Constructable Stylesheets
experimental-features-css-constructable-stylesheets-description = Přidá rozhraní konstruktoru <a data-l10n-name="mdn-cssstylesheet">CSSStyleSheet</a> a další související změny pro přímé vytváření kaskádových stylů bez nutnosti jejich přidávání do HTML. Díky tomu je mnohem snazší vytvářet přepoužitelné kaskádové styly pro <a data-l10n-name="mdn-shadowdom">Shadow DOM</a>. Podrobnosti najdete v <a data-l10n-name="bugzilla">bugu 1520690</a>.
experimental-features-devtools-compatibility-panel =
    .label = Nástroje pro vývojáře: panel kompatibility
experimental-features-devtools-compatibility-panel-description = Postranní panel průzkumníka stránky, kde uvidíte podrobnosti o kompatibilitě vaší aplikaci s různými prohlížeči. Podrobnosti najdete v <a data-l10n-name="bugzilla">bugu 1584464</a>.
# Do not translate 'SameSite', 'Lax' and 'None'.
experimental-features-cookie-samesite-lax-by-default2 =
    .label = Cookies: výchozí nastavení SameSite=Lax
experimental-features-cookie-samesite-lax-by-default2-description = Pokud není uveden žádný atribut „SameSite“, je s cookies nakládáno, jako by měly atribut „SameSite=Lax“. Pokud potřebují dnes běžné chování odpovídající „SameSite=None“, musí jej vývojáři explicitně vyžádat.
# Do not translate 'SameSite', 'Lax' and 'None'.
experimental-features-cookie-samesite-none-requires-secure2 =
    .label = Cookies: SameSite=None pouze s atributem secure
experimental-features-cookie-samesite-none-requires-secure2-description = Cookies s atributem „SameSite=None“ vyžadují také atribut secure.Tato funkce vyžaduje „Cookies: SameSite=None by default“.
# about:home should be kept in English, as it refers to the the URI for
# the internal default home page.
experimental-features-abouthome-startup-cache =
    .label = Mezipaměť about:home
experimental-features-abouthome-startup-cache-description = Obsah mezipaměti pro výchozí dokument about:home, bude připraven během spuštění. Její účel je zrychlit spouštění.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-cookie-samesite-schemeful =
    .label = Cookies: Schemeful SameSite
experimental-features-cookie-samesite-schemeful-description = Nakládá s cookies ze stejné domény, ale s různým schématem (např. http://example.com oproti https://example.com) jako s cross-site cookies. To zvyšuje bezpečnost, ale může potenciálně vést k rozbití některých funkcí.
# "Service Worker" is an API name and is usually not translated.
experimental-features-devtools-serviceworker-debugger-support =
    .label = Nástroje pro vývojáře: ladění service workerů
# "Service Worker" is an API name and is usually not translated.
experimental-features-devtools-serviceworker-debugger-support-description = Povolí experimentální podporu pro service workery v panelu laděni. Tato funkce může zpomalit nástroje pro vývojáře a zvýšit spotřebu paměti.
# WebRTC global mute toggle controls
experimental-features-webrtc-global-mute-toggles =
    .label = Globální přepínač ztlumení WebRTC
experimental-features-webrtc-global-mute-toggles-description = Přidá indikátor globálního ovládání WebRTC, pomocí kterého si můžete jako uživatel ztlumit mikrofon nebo odpojit kameru.
# JS JIT Warp project
experimental-features-js-warp =
    .label = JavaScript JIT: Warp
experimental-features-js-warp-description = Povolí projekt Warp, který má zlepšit výkon JavaScriptu a jeho využívání paměti.
# Search during IME
experimental-features-ime-search =
    .label = Adresní řádek: zobrazovat výsledky při použití IME
experimental-features-ime-search-description = IME (Input Method Editor) je nástroj pro zadávání komplexních symbolů, jako jsou znaky východoasijských nebo indických jazyků, pomocí běžné klávesnice. Po zapnutí tohoto experimentu bude panel adresního řádku zobrazovat výsledky vyhledávání a návrhy našeptávače i při použití IME pro zadávání textu. Protože IME může zakrýt výsledky adresního řádku, doporučujeme tuto předvolbu použít jen s IME, který toto nedělá.
# Text recognition for images
experimental-features-text-recognition =
    .label = Rozpoznávání textu
experimental-features-text-recognition-description = Povolí funkce pro rozpoznávání textu v obrázcích.
