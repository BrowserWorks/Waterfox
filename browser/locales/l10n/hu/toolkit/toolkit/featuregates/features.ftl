# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-masonry2 =
    .label = CSS: Masonry Layout
experimental-features-css-masonry-description = Engedélyezi a kísérleti CSS Masonry Layout funkció támogatását. A funkció magas szintű leírásához lásd a <a data-l10n-name="explainer">magyarázót</a>. Visszajelzés küldéséhez szóljon hozzá <a data-l10n-name="w3c-issue">ehhez a GitHub jegyhez</a> vagy <a data-l10n-name="bug">ehhez a hibajegyhez</a>.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-gpu2 =
    .label = Web API: WebGPU
experimental-features-web-gpu-description2 = Ez az új API alacsony szintű támogatást nyújt a felhasználó eszközének vagy számítógépének <a data-l10n-name="wikipedia">grafikus processzorát (GPU)</a> használó számításokhoz és grafikus megjelenítéshez. A <a data-l10n-name="spec">specifikáció</a> még mindig folyamatban van. További részletekért lásd az <a data-l10n-name="bugzilla">1602129-es számú jegyet</a>.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-media-avif =
    .label = Media: AVIF
experimental-features-media-avif-description = A funkció engedélyezésével a { -brand-short-name } támogatja az AV1 (AVIF) képfájl-formátumot. Ez egy olyan állókép-formátum, ami az AV1 videotömörítési algoritmusokat használja a képméret csökkentése érdekében. További részletekért lásd az <a data-l10n-name="bugzilla">1443863-as számú jegyet</a>.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-api-inputmode =
    .label = Web API: inputmode
# "inputmode" and "contenteditable" are technical terms and shouldn't be translated.
experimental-features-web-api-inputmode-description = Az <a data-l10n-name="mdn-inputmode">inputmode</a> globális attribútum implementációját frissítettük <a data-l10n-name="whatwg">a WHATWG-specifikáció</a> alapján, de még más változásokra is szükség lesz, mint például az elérhetővé tételéhez „contenteditable” típusú tartalom esetén. További részletek az <a data-l10n-name="bugzilla">1205133-as számú hibában</a> találhatók.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-api-link-preload =
    .label = Web API: <link rel="preload">
# Do not translate "rel", "preload" or "link" here, as they are all HTML spec
# values that do not get translated.
experimental-features-web-api-link-preload-description = A <a data-l10n-name="link">&lt;link&gt;</a> elemen lévő, <code>"preload"</code> értékű <a data-l10n-name="rel">rel</a> attribútum arra szolgál, hogy teljesítménybeli javulást nyújtson azáltal, hogy az erőforrásokat hamarabb letölthesse az oldal életciklusában, biztosítva hogy korábban elérhetők legyenek, és kevésbe legyen valószínű, hogy blokkolják a lap megjelenítését. További részletekért olvassa el a <a data-l10n-name="readmore">„Preloading content with <code>rel="preload"</code>”</a> című leírást vagy lásd a <a data-l10n-name="bugzilla">1583604-es számú jegyet</a>.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-focus-visible =
    .label = CSS: Pseudo-class: :focus-visible
experimental-features-css-focus-visible-description = Lehetővé teszi, hogy a fókuszstílusok csak akkor legyenek alkalmazva az olyan elemeken, mint a gombok és űrlapvezérlők, amikor billentyűzettel kerülnek fókuszba (például tabulátorral történő váltáskor), de egér és más mutatóeszközökkel nem. További részletekért lásd a <a data-l10n-name="bugzilla">1617600-as számú hibát</a>.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-api-beforeinput =
    .label = Web API: beforeinput Event
# The terms "beforeinput", "input", "textarea", and "contenteditable" are technical terms
# and shouldn't be translated.
experimental-features-web-api-beforeinput-description = A globális <a data-l10n-name="mdn-beforeinput">beforeinput</a> esemény <a data-l10n-name="mdn-input">&lt;input&gt;</a> és <a data-l10n-name="mdn-textarea">&lt;textarea&gt;</a> elemeken tüzel, vagy bármilyen olyan elemen, amelyen engedélyezett a <a data-l10n-name="mdn-contenteditable">contenteditable</a> attribútum. Ez közvetlenül az elem értékének megváltozása előtt történik. Az esemény lehetővé teszi a webalkalmazásoknak, hogy felülírják a böngésző alapértelmezett viselkedését a felhasználói interakcióknál, például a webalkalmazások megszakíthatják a felhasználói bemenetet bizonyos karakterek esetén, vagy módosíthatják a beillesztett szöveg stílusát, a megengedett stílusoknak megfelelően.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-constructable-stylesheets =
    .label = CSS: Constructable Stylesheets
experimental-features-css-constructable-stylesheets-description = A <a data-l10n-name="mdn-cssstylesheet">CSSStyleSheet</a> interfész konstruktorának hozzáadása, valamint a kapcsolódó módosítások lehetővé teszik az új stíluslapok létrehozását, anélkül hogy hozzá kellene tennie a lapot HTML-hez. Ez sokkal könnyebbé teszi az újrahasznosítható stíluslapok készítését a <a data-l10n-name="mdn-shadowdom">Shadow DOM-mal</a> történő használathoz. További részletekért lásd az <a data-l10n-name="bugzilla">1520690-es számú jegyet</a>

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-media-session-api =
    .label = Web API: Media Session API
experimental-features-media-session-api-description = Jelenleg a Media Session API teljes implementációja kísérleti a { -brand-short-name }ban. Ezzel az API-val testreszabható a médiával kapcsolatos értesítések kezelése, kezelhetők az események és adatok, melyek hasznosak a lejátszáskezelő felhasználói felületek létrehozásához, és megszerezhetők vele a médiafájlok metaadatai. További részletékért lásd az <a data-l10n-name="bugzilla">1112032-es számú jegyet</a>.

experimental-features-devtools-color-scheme-simulation =
    .label = Fejlesztői eszközök: Színséma szimuláció
experimental-features-devtools-color-scheme-simulation-description = Hozzáadja azt a lehetőséget, hogy különböző színsémákat szimuláljon, hogy tesztelhesse a <a data-l10n-name="mdn-preferscolorscheme">@prefers-color-scheme</a> médialekérdezéseket. A médialekérdezés használatával válaszolhat a stíluslapja arra, hogy a felhasználó a világos vagy a sötét felhasználó felületet részesíti előnyben. A funkcióval úgy tesztelheti a kódját, hogy közben nem kell megváltoztatnia a böngészője beállítását (vagy az operációs rendszeréjét, ha a böngésző a rendszerszintű színséma-beállítást követi). További részletekért lásd az <a data-l10n-name="bugzilla1">1550804-es</a> és az <a data-l10n-name="bugzilla2">1137699-es</a> számú jegyet.

experimental-features-devtools-execution-context-selector =
    .label = Fejlesztői eszközök: Végrehajtásikörnyezet-választó
experimental-features-devtools-execution-context-selector-description = Ez a funkció megjelenít egy gombot a konzol parancssorán, amellyel módosíthatja azt a környezetet, amelyben a beírt kifejezés végrehajtásra kerül. További részletekért lásd az <a data-l10n-name="bugzilla1">1605154-es</a> és az <a data-l10n-name="bugzilla2">1605153-as</a> számú jegyeket.

experimental-features-devtools-compatibility-panel =
    .label = Fejlesztői eszközök: Kompatibilitási panel
experimental-features-devtools-compatibility-panel-description = Egy oldalsáv a Lapvizsgálóhoz, amely információkat jelenít meg az alkalmazás böngészők közti kompatibilitási állapotáról. További részletekért lásd az <a data-l10n-name="bugzilla">1584464-es számú jegyet</a>.

# Do not translate 'SameSite', 'Lax' and 'None'.
experimental-features-cookie-samesite-lax-by-default2 =
    .label = Cookies: SameSite=lax by default
experimental-features-cookie-samesite-lax-by-default2-description = A sütik „SameSite=Lax” beállítás szerinti kezelése, ha nincs megadva „SameSite” attribútum. A fejlesztőknek kifejezetten kérniük kell a jelenlegi korlátlan használatot a „SameSite=None” megadásával.

# Do not translate 'SameSite', 'Lax' and 'None'.
experimental-features-cookie-samesite-none-requires-secure2 =
    .label = Cookies: SameSite=None requires secure attribute
experimental-features-cookie-samesite-none-requires-secure2-description = A „SameSite=None” attribútummal rendelkező sütikhez szükséges a secure attribútum. A funkcióhoz szükséges a „Cookies: SameSite=Lax by default”.

# about:home should be kept in English, as it refers to the the URI for
# the internal default home page.
experimental-features-abouthome-startup-cache =
    .label = about:home indítási gyorsítótár
experimental-features-abouthome-startup-cache-description = Gyorsítótár a kezdeti about:home dokumentumhoz, amely alapértelmezés szerint betöltődik indításkor. A gyorsítótár célja az indítási teljesítmény javítása.

experimental-features-print-preview-tab-modal =
    .label = A nyomtatási kép újratervezése
experimental-features-print-preview-tab-modal-description = Új nyomtatási képet vezet be, és elérhetővé teszi a nyomtatási képen macOS-en is. Ez potenciálisan törést okoz, és nem tartalmaz minden nyomtatással kapcsolatos beállítást. A nyomtatással kapcsolatos beállítások eléréséhez válassza a „Nyomtatás a rendszer párbeszédablakával…” lehetőséget a Nyomtatás panelen.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-cookie-samesite-schemeful =
    .label = Cookies: Schemeful SameSite
experimental-features-cookie-samesite-schemeful-description = Az azonos domainból származó, de más sémájú (például http://example.com és https://example.com) webhelyek közöttiként kezelése azonos webhelyről származó helyett. Ez növeli a biztonságot, de hibákhoz is vezethet.

# "Service Worker" is an API name and is usually not translated.
experimental-features-devtools-serviceworker-debugger-support =
    .label = Fejlesztői eszközök: Hibakeresés a Service Workerekben
# "Service Worker" is an API name and is usually not translated.
experimental-features-devtools-serviceworker-debugger-support-description = Engedélyezi a Service Workerek kísérleti támogatását a fejlesztői eszközök Hibakeresés panelján. A funkció lelassíthatja a fejlesztői eszközöket, és növelheti a memóriafogyasztást.

# Desktop zooming experiment
experimental-features-graphics-desktop-zooming =
    .label = Grafika: sima nagyítás csípéssel
experimental-features-graphics-desktop-zooming-description = Engedélyezi a csípéssel történő sima nagyítást az érintőkijelzőkön és precíziós érintőtáblákon.
