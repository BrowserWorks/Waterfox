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
experimental-features-css-cascade-layers =
    .label = CSS: Cascade Layers
experimental-features-css-cascade-layers-description = Aktiverar stöd för CSS Cascade Layers. Se <a data-l10n-name="spec">pågående specifikation</a> för mer information. Skapa buggar som blockerar <a data-l10n-name="bugzilla">bug 1699215</a> för buggar relaterade till den här funktionen.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-gpu2 =
    .label = Web API: WebGPU
experimental-features-web-gpu-description2 = Detta nya API ger lågnivå stöd för att utföra beräkningar och grafikrenderingar genom att använda <a data-l10n-name="wikipedia"> Grafikprocessor (GPU)</a> på användarens enhet eller dator. <a data-l10n-name="spec">Specifikationen är fortfarande under bearbetning. Se <a data-l10n-name="bugzilla">bugg 1602129</a> för mer detaljer.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-media-avif =
    .label = Media: AVIF
experimental-features-media-avif-description = Med den här funktionen aktiverad stöder { -brand-short-name } AVIF-format (AV1). Detta är ett stillbildsformat som utnyttjar funktionerna i AV1-videokomprimeringsalgoritmerna för att minska bildstorleken. Se <a data-l10n-name="bugzilla">bug 1443863</a> för mer detaljer.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-media-jxl =
    .label = Media: JPEG XL
experimental-features-media-jxl-description = Med den här funktionen aktiverad stöder { -brand-short-name } formatet JPEG XL (JXL). Detta är ett förbättrat bildfilformat som stöder förlustfri övergång från traditionella JPEG-filer. Se <a data-l10n-name="bugzilla">felrapport 1539075</a> för mer information.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-api-inputmode =
    .label = Web API: inputmode
# "inputmode" and "contenteditable" are technical terms and shouldn't be translated.
experimental-features-web-api-inputmode-description = Vår implementation av det globala attributet för <a data-l10n-name="mdn-inputmode">inmatningsläget</a> har uppdaterats enligt <a data-l10n-name="whatwg">WHATWG-specifikationen</a>, men vi behöver fortfarande göra andra ändringar, som att göra det tillgängligt på redigerbart innehåll. Se <a data-l10n-name="bugzilla">bugg 1205133</a> för mer detaljer.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-constructable-stylesheets =
    .label = CSS: Constructable Stylesheets
experimental-features-css-constructable-stylesheets-description = Tillägget av en konstruktör till <a data-l10n-name="mdn-cssstylesheet">CSSStyleSheet</a>-gränssnittet samt en serie relaterade förändringar gör det möjligt och bygga ny stiluppsättningar direkt utan att behöva lägga till uppsättningen i HTML. Detta gör det mycket enklare att bygga återanvändbara stiluppsättningar som kan användas med <a data-l10n-name="mdn-shadowdom">Shadow DOM</a>. Se <a data-l10n-name="bugzilla">bug1520690</a> för mer detaljer.
experimental-features-devtools-color-scheme-simulation =
    .label = Utvecklarverktyg: Simulering av färgschema
experimental-features-devtools-color-scheme-simulation-description = Lägger till ett alternativ för att simulera olika färgscheman så att du kan testa<a data-l10n-name="mdn-preferscolorscheme">@prefers-color-scheme</a> mediafrågor. Om du använder den här mediefrågan låter du din stilmall svara på om användaren föredrar ett ljust eller mörkt användargränssnitt. Med den här funktionen kan du testa din kod utan att behöva ändra inställningar i din webbläsare (eller operativsystem, om webbläsaren följer en systemomfattande färgschemainställning). Se <a data-l10n-name="bugzilla1">bug 1550804</a> och <a data-l10n-name="bugzilla2">bug 1137699</a> för mer detaljer.
experimental-features-devtools-execution-context-selector =
    .label = Utvecklarverktyg: Exekveringskontext väljare
experimental-features-devtools-execution-context-selector-description = Den här funktionen visar en knapp på konsolens kommandorad som låter dig ändra sammanhanget i vilket uttrycket du anger kommer att köras. Se <a data-l10n-name="bugzilla1"> bug 1605154</a> och <a data-l10n-name="bugzilla2"> bug 1605153</a> för mer detaljer.
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
# Win32k Lockdown
experimental-features-win32k-lockdown =
    .label = Win32k-låsning
experimental-features-win32k-lockdown-description = Inaktivera användning av Win32k API:er i webbläsarflikar. Ger en ökad säkerhet men kan för närvarande vara instabil. (Endast Windows)
# JS JIT Warp project
experimental-features-js-warp =
    .label = JavaScript JIT: Warp
experimental-features-js-warp-description = Aktivera Warp, ett projekt för att förbättra JavaScript-prestanda och minnesanvändning.
# Fission is the name of the feature and should not be translated.
experimental-features-fission =
    .label = Fission (webbplatsisolering)
experimental-features-fission-description = Fission (webbplatsisolering) är en experimentell funktion i { -brand-short-name } för att ge ytterligare ett försvar mot säkerhetsfel. Genom att isolera varje webbplats i en separat process gör Fission det svårare för skadliga webbplatser att få tillgång till information från andra sidor du besöker. Det här är en stor arkitektonisk förändring av { -brand-short-name } och vi uppskattar att du testar och rapporterar eventuella problem du kan stöta på. Mer information finns i denna <a data-l10n-name="wiki">wiki</a>.
# Support for having multiple Picture-in-Picture windows open simultaneously
experimental-features-multi-pip =
    .label = Stöd för flera bild-i-bild
experimental-features-multi-pip-description = Experimentellt stöd för att låta flera bild-i-bild-fönster vara öppna samtidigt.
# Search during IME
experimental-features-ime-search =
    .label = Adressfält: visa resultat under IME-komposition
experimental-features-ime-search-description = En IME (Input Method Editor) är ett verktyg som låter dig skriva in komplexa symboler, som de som används i östasiatiska eller indiska skriftspråk, med ett vanligt tangentbord. Om du aktiverar detta experiment hålls adressfältets panel öppen och visar sökresultat och förslag medan du använder IME för att mata in text. Observera att IME kan visa en panel som täcker resultat i adressfältet, därför föreslås denna inställning endast för IME som inte använder denna typ av panel.
