# This Source Code Form is subject to the terms of the Mozilla Public
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
experimental-features-media-avif =
    .label = Media: AVIF
experimental-features-media-avif-description = Med den här funktionen aktiverad stöder { -brand-short-name } AVIF-format (AV1). Detta är ett stillbildsformat som utnyttjar funktionerna i AV1-videokomprimeringsalgoritmerna för att minska bildstorleken. Se <a data-l10n-name="bugzilla">bug 1443863</a> för mer detaljer.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-api-inputmode =
    .label = Web API: inputmode
# "inputmode" and "contenteditable" are technical terms and shouldn't be translated.
experimental-features-web-api-inputmode-description = Vår implementation av det globala attributet för <a data-l10n-name="mdn-inputmode">inmatningsläget</a> har uppdaterats enligt <a data-l10n-name="whatwg">WHATWG-specifikationen</a>, men vi behöver fortfarande göra andra ändringar, som att göra det tillgängligt på redigerbart innehåll. Se <a data-l10n-name="bugzilla">bugg 1205133</a> för mer detaljer.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-api-link-preload =
    .label = Web API: <link rel="preload">
# Do not translate "rel", "preload" or "link" here, as they are all HTML spec
# values that do not get translated.
experimental-features-web-api-link-preload-description = Tanken bakom <a data-l10n-name="rel">rel</a>-attributet med värdet <code>"preload"</code> på ett <a data-l10n-name="link">&lt;link&gt;</a>-element är hjälpa till att förbättra prestanda så att du kan hämta resurser tidigare i en sidas livscykel. Därmed är resurserna tillgängliga tidigare, og det är mindre sannolikt att de blockerar renderingen av sidan . Läs <a data-l10n-name="readmore">“Preloading content with <code>rel="preload"</code>”</a>, eller se bugg <a data-l10n-name="bugzilla">bug 1583604</a> för mer detaljer.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-focus-visible =
    .label = CSS: Pseudo-class: :focus-visible
experimental-features-css-focus-visible-description = Tillåter att fokusstilar tillämpas på element som knappar och formkontroller, endast när de är fokuserade med hjälp av tangentbordet (t.ex. vid flikar mellan element), och inte när de är fokuserade med en mus eller annat pekdon. Se <a data-l10n-name="bugzilla">bug 1617600</a> för mer detaljer.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-api-beforeinput =
    .label = Web API: beforeinput Event
# The terms "beforeinput", "input", "textarea", and "contenteditable" are technical terms
# and shouldn't be translated.
experimental-features-web-api-beforeinput-description = Den globala <a data-l10n-name="mdn-beforeinput">beforeinput</a> händelsen avfyras på ett <a data-l10n-name="mdn-input">&lt;input&gt;</a> och <a data-l10n-name="mdn-textarea">&lt;textarea&gt;</a> element, eller något element vars <a data-l10n-name="mdn-contenteditable">redigerbart innehåll attribut är aktiverat, omedelbart före elementets värde ändras. Händelsen tillåter webbappar att åsidosätta webbläsarens standardbeteende för användarinteraktion t.ex. webbappar kan avbryta användarinmatning för specifika tecken endast eller kan tvinga inklistrad formaterad text att endast använda godkända stilar.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-constructable-stylesheets =
    .label = CSS: Constructable Stylesheets
experimental-features-css-constructable-stylesheets-description = Tillägget av en konstruktör till <a data-l10n-name="mdn-cssstylesheet">CSSStyleSheet</a>-gränssnittet samt en serie relaterade förändringar gör det möjligt och bygga ny stiluppsättningar direkt utan att behöva lägga till uppsättningen i HTML. Detta gör det mycket enklare att bygga återanvändbara stiluppsättningar som kan användas med <a data-l10n-name="mdn-shadowdom">Shadow DOM</a>. Se <a data-l10n-name="bugzilla">bug1520690</a> för mer detaljer.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-media-session-api =
    .label = Web API: Media Session API
experimental-features-media-session-api-description = Hela { -brand-short-name } implementationen av Media sessionen APIn är för närvarande experimentell.  APIn används för att konfigurera hanteringen av media relaterade notifikationer, för att hantera händelser och data som är användbara för att presentera ett användargränssnitt för att hantera media uppspelning, och för att tillhanda ha media meta-data filer. <a data-l10n-name="bugzilla">bug 1112032</a> innehåller fler detaljer.

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

experimental-features-print-preview-tab-modal =
    .label = Omkonstruktion av förhandsgranska
experimental-features-print-preview-tab-modal-description = Introducerar den omkonstruerade förhandsgranskning och gör förhandsgranskning tillgänglig på macOS. Detta introducerar potentiellt fel och inkluderar inte alla utskrifts-relaterade inställningar. För att komma åt alla utskrifts-relaterade inställningar, välj “Skriv ut genom att använda systemdialogen...” från Utskrifts-panelen.

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

# Desktop zooming experiment
experimental-features-graphics-desktop-zooming =
    .label = Grafik: Smidig nypzoom
experimental-features-graphics-desktop-zooming-description = Aktivera stöd för smidig nypzoomning på pekskärmar och precision touchpads.
