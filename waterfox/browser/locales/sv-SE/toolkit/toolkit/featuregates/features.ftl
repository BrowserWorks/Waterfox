# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-masonry2 =
    .label = CSS: Masonry Layout
experimental-features-css-masonry-description = Aktiverar stöd för den experimentella CSS Masonry Layout-funktionen. Se <a data-l10n-name="explainer">förklaring</a> för en beskrivning på hög nivå av funktionen. För att ge återkoppling kan du kommentera i <a data-l10n-name="w3c-issue">detta GitHub-problem</a> eller <a data-l10n-name="bug">denna bugg</a>.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-gpu2 =
    .label = Web API: WebGPU
experimental-features-web-gpu-description2 = Detta nya API ger lågnivå stöd för att utföra beräkningar och grafikrenderingar genom att använda <a data-l10n-name="wikipedia"> Grafikprocessor (GPU)</a> på användarens enhet eller dator. <a data-l10n-name="spec">Specifikationen är fortfarande under bearbetning. Se <a data-l10n-name="bugzilla">bugg 1602129</a> för mer detaljer.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-media-jxl =
    .label = Media: JPEG XL
experimental-features-media-jxl-description = Med den här funktionen aktiverad stöder { -brand-short-name } formatet JPEG XL (JXL). Detta är ett förbättrat bildfilformat som stöder förlustfri övergång från traditionella JPEG-filer. Se <a data-l10n-name="bugzilla">felrapport 1539075</a> för mer information.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-constructable-stylesheets =
    .label = CSS: Constructable Stylesheets
experimental-features-css-constructable-stylesheets-description = Tillägget av en konstruktör till <a data-l10n-name="mdn-cssstylesheet">CSSStyleSheet</a>-gränssnittet samt en serie relaterade förändringar gör det möjligt och bygga ny stiluppsättningar direkt utan att behöva lägga till uppsättningen i HTML. Detta gör det mycket enklare att bygga återanvändbara stiluppsättningar som kan användas med <a data-l10n-name="mdn-shadowdom">Shadow DOM</a>. Se <a data-l10n-name="bugzilla">bug1520690</a> för mer detaljer.
experimental-features-devtools-compatibility-panel =
    .label = Utvecklarverktyg: Kompatibilitetspanel
experimental-features-devtools-compatibility-panel-description = En sidopanel för Sidoinspektören som visar information om din apps kross-kompatibilitetsstatus för webbläsare. Se <a data-l10n-name="bugzilla"> bug 1584464</a> för mer detaljer.
# Do not translate 'SameSite', 'Lax' and 'None'.
experimental-features-cookie-samesite-lax-by-default2 =
    .label = Kakor: SameSite=Lax som standard
experimental-features-cookie-samesite-lax-by-default2-description = Behandla kakor som "SameSite=Lax" som standard om inget "SameSite"-attribut är specificerat. Utvecklare måste välja aktuell status för obegränsad användning genom att uttryckligen hävda “SameSite=None”.
# Do not translate 'SameSite', 'Lax' and 'None'.
experimental-features-cookie-samesite-none-requires-secure2 =
    .label = Kakor: SameSite=None kräver säkert attribut
experimental-features-cookie-samesite-none-requires-secure2-description = Kakor med "SameSite=None"-attribut kräver det säkra attributet. Denna funktion kräver “Kakor: SameSite=Lax som standard”.
# about:home should be kept in English, as it refers to the the URI for
# the internal default home page.
experimental-features-abouthome-startup-cache =
    .label = about:home startcache
experimental-features-abouthome-startup-cache-description = En cache för startdokumentet about:home som laddas som standard vid start. Syftet med cachen är att förbättra startprestanda.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-cookie-samesite-schemeful =
    .label = Kakor: Schemeful SameSite
experimental-features-cookie-samesite-schemeful-description = Behandla kakor från samma domän, men med olika scheman (t.ex. http://example.com och https://example.com) som flera webbplatser istället för samma webbplats. Förbättrar säkerheten, men kan göra att webbplatsen fungerar felaktigt.
# "Service Worker" is an API name and is usually not translated.
experimental-features-devtools-serviceworker-debugger-support =
    .label = Utvecklarverktyg: Felsökning av Service Worker
# "Service Worker" is an API name and is usually not translated.
experimental-features-devtools-serviceworker-debugger-support-description = Aktiverar experimentellt stöd för Service Workers i felsökningspanelen. Den här funktionen kan få utvecklarverktygen att gå långsammare och öka minnesförbrukningen.
# WebRTC global mute toggle controls
experimental-features-webrtc-global-mute-toggles =
    .label = Aktivera/inaktivera WebRTC:s globala mediekontroller
experimental-features-webrtc-global-mute-toggles-description = Lägg till kontroller i WebRTC:s globala delningsindikator som tillåter användare att stänga av mikrofonen och kameraflödena globalt.
# JS JIT Warp project
experimental-features-js-warp =
    .label = JavaScript JIT: Warp
experimental-features-js-warp-description = Aktivera Warp, ett projekt för att förbättra JavaScript-prestanda och minnesanvändning.
# Search during IME
experimental-features-ime-search =
    .label = Adressfält: visa resultat under IME-komposition
experimental-features-ime-search-description = En IME (Input Method Editor) är ett verktyg som låter dig skriva in komplexa symboler, som de som används i östasiatiska eller indiska skriftspråk, med ett vanligt tangentbord. Om du aktiverar detta experiment hålls adressfältets panel öppen och visar sökresultat och förslag medan du använder IME för att mata in text. Observera att IME kan visa en panel som täcker resultat i adressfältet, därför föreslås denna inställning endast för IME som inte använder denna typ av panel.
# Text recognition for images
experimental-features-text-recognition =
    .label = Textigenkänning
experimental-features-text-recognition-description = Aktivera funktioner för att känna igen text i bilder.
experimental-features-accessibility-cache =
    .label = Tillgänglighetscache
experimental-features-accessibility-cache-description = Cachar all tillgänglighetsinformation från alla dokument i huvudprocessen { -brand-short-name }. Detta förbättrar prestandan för skärmläsare och andra applikationer som använder tillgänglighets-API:er.
