# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-masonry2 =
    .label = CSS: Masonry Layout
experimental-features-css-masonry-description = Aktiverer den eksperimentelle funktion med CSS Masonry-layout. Læs <a data-l10n-name="explainer">denne artikel</a> for at få et overblik over funktionen. Hvis du har feedback, så skriv gerne en kommentar på <a data-l10n-name="w3c-issue">dette issue på GitHub</a> eller på <a data-l10n-name="bug">denne bug</a>.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-gpu2 =
    .label = Web API: WebGPU
experimental-features-web-gpu-description2 = Denne nye API giver low-level understøttelse til at anvende a data-l10n-name="wikipedia">grafikprocessoren (GPU)</a> i brugerens enhed eller computer til at lave beregninger eller rendere grafik. <a data-l10n-name="spec">Specifikationen</a> er stadig ved at blive udarbejdet . Se flere detaljer på <a data-l10n-name="bugzilla">bug 1602129</a>.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-media-avif =
    .label = Media: AVIF
experimental-features-media-avif-description = Når denne funktion er slået til, understøtter { -brand-short-name } filformatet for AV1-billeder (AVIF). Formatet anvendes til statiske billeder og anvender algoritmerne bag AV1-video-komprimering til at reducere billedets filstørrelse. Se flere detaljer på <a data-l10n-name="bugzilla">bug 1443863</a>
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-api-inputmode =
    .label = Web API: inputmode
# "inputmode" and "contenteditable" are technical terms and shouldn't be translated.
experimental-features-web-api-inputmode-description = Vores implementering af den globale attribut <a data-l10n-name="mdn-inputmode">inputmode</a> er blevet opdateret i overensstemmelse med <a data-l10n-name="whatwg">WHATWG-specifikationen</a>. Men vi mangler stadig at ændre nogle ting, som fx at gøre attributten tilgængelig for redigerbart indhold. Se flere detaljer på <a data-l10n-name="bugzilla">bug 1205133</a>.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-api-link-preload =
    .label = Web API: <link rel="preload">
# Do not translate "rel", "preload" or "link" here, as they are all HTML spec
# values that do not get translated.
experimental-features-web-api-link-preload-description = Tanken bag <a data-l10n-name="rel">rel</a>-attributten med værdien <code>"preload"</code> på et <a data-l10n-name="link">&lt;link&gt;</a>-element er at forbedre ydelsen ved at lade dig hente ressourcer tidligere i en sides livscyklus. Dermed er ressourcerne tilgængelige tidligere, og det er mindre sandsynligt at de blokerer rendering af siden . Læs artiklen <a data-l10n-name="readmore">“Preloading content with <code>rel="preload"</code>”</a>, eller se flere detaljer på <a data-l10n-name="bugzilla">bug 1583604</a>.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-focus-visible =
    .label = CSS: Pseudo-class: :focus-visible
experimental-features-css-focus-visible-description = Tillader at CSS-regler for fokus kun anvendes på elementer som knapper og formular-elementer, når elementerne har fokus fra tastaturet (fx når tab-tasten anvendes til at flytte mellem elementer) - og ikke når fokus stammer fra musen eller andre pege-enheder. Se flere detaljer på <a data-l10n-name="bugzilla">bug 1617600</a>.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-api-beforeinput =
    .label = Web API: beforeinput Event
# The terms "beforeinput", "input", "textarea", and "contenteditable" are technical terms
# and shouldn't be translated.
experimental-features-web-api-beforeinput-description = Den globale event <a data-l10n-name="mdn-beforeinput">beforeinput</a> bliver aktiveret på elementerne <a data-l10n-name="mdn-input">&lt;input&gt;</a> og <a data-l10n-name="mdn-textarea">&lt;textarea&gt;</a> - eller ethvert element, hvis <a data-l10n-name="mdn-contenteditable">contenteditable</a>-attribut er aktiveret, umiddelbart før elementets værdi ændres. Eventen giver webapps mulighed for at tilsidesætte browserens standard-opførsel for interaktion fra brugeren. Fx kan webapps annullere brugerinput for specifikke tegn eller ændre opførslen for indsat tekst med styling til kun at indeholde godkendte styles.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-constructable-stylesheets =
    .label = CSS: Constructable Stylesheets
experimental-features-css-constructable-stylesheets-description = Tilføjelsen af en constructor til <a data-l10n-name="mdn-cssstylesheet">CSSStyleSheet</a>-brugerfladen samt en række relaterede ændringer gør det muligt at oprette nye stylesheets direkte uden at tilføje dem til HTML'en. Det gør det meget nemmere at oprette genbrugelige stylesheets til brug med <a data-l10n-name="mdn-shadowdom">Shadow DOM</a>. Se flere detaljer på <a data-l10n-name="bugzilla">bug 1520690</a>.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-media-session-api =
    .label = Web API: Media Session API
experimental-features-media-session-api-description = Implementeringen af Media Session API i { -brand-short-name } er i øjeblikket eksperimentel. API'en bruges til at tilpasse håndteringen af medie-relaterede notifikationer, til at håndtere events og data, der er nyttige ved præsentation af brugerflader til at håndtere afspilning af medier, samt til at få fat i metadata fra mediefiler. Se flere detaljer på <a data-l10n-name="bugzilla">bug 1112032</a>.
experimental-features-devtools-color-scheme-simulation =
    .label = Udviklerværktøj: Simulering af farveskemaer
experimental-features-devtools-color-scheme-simulation-description = Giver dig mulighed for at simulere forskellige farveskemaer, så du kan teste <a data-l10n-name="mdn-preferscolorscheme">@prefers-color-scheme</a> media queries.  Ved at bruge denne media query kan dit stylesheet reagere på, om brugeren foretrækker en lys eller en mørk brugerflade. Du kan bruge funktionen til at teste din kode uden at ændre indstillingerne i din browser (eller dit operativsystem, hvis browseren følger operativsystemets farveskema). Se flere detaljer på <a data-l10n-name="bugzilla1">bug 1550804</a> og <a data-l10n-name="bugzilla2">bug 1137699</a>.
experimental-features-devtools-execution-context-selector =
    .label = Udviklerværktøj: Vælg kontekst for eksekvering
experimental-features-devtools-execution-context-selector-description = Denne funktion tilføjer en knap i konsollens kommandolinje, der lader dig ændre den kontekst, som dit indtastede udtryk bliver eksekveret i. Se flere detaljer på <a data-l10n-name="bugzilla1">bug 1605154</a> og <a data-l10n-name="bugzilla2">bug 1605153</a>.
experimental-features-devtools-compatibility-panel =
    .label = Udviklerværktøj: Kompatibilitetspanel
experimental-features-devtools-compatibility-panel-description = Et sidepanel for side-inspektøren, der viser dig information om din apps kompatibilitet på tværs af browsere. Se flere detaljer på <a data-l10n-name="bugzilla">bug 1584464</a>.
# Do not translate 'SameSite', 'Lax' and 'None'.
experimental-features-cookie-samesite-lax-by-default2 =
    .label = Cookies: SameSite=Lax som standard
experimental-features-cookie-samesite-lax-by-default2-description = Behandl som standard cookies som "SameSite=Lax", hvis der ikke er angivet nogen "SameSite"-attribut. Udviklere skal tilvælge fortsat ubegrænset brug ved eksplicit at angive "SameSite=None".
# Do not translate 'SameSite', 'Lax' and 'None'.
experimental-features-cookie-samesite-none-requires-secure2 =
    .label = Cookies: SameSite=None kræver attributten "secure"
experimental-features-cookie-samesite-none-requires-secure2-description = Cookies med attributten "SameSite=None" kræver attributten "secure". Denne funktion kræver "Cookies: SameSite=Lax som standard".
# about:home should be kept in English, as it refers to the the URI for
# the internal default home page.
experimental-features-abouthome-startup-cache =
    .label = Start-cache for about:home
experimental-features-abouthome-startup-cache-description = Cache for det første about:home-dokument, der indlæses som standard ved opstart. Formålet med cachen er at gøre opstarten hurtigere.
experimental-features-print-preview-tab-modal =
    .label = Redesign af forhåndsvisning
experimental-features-print-preview-tab-modal-description = Forhåndsvisning af udskrifter er redesignet - og er nu tilgængelig til macOS. Dette kan medføre nogle fejl og inkluderer ikke alle indstillinger relateret til udskrifter. Vælg "Udskriv ved brug af system-dialogen…" fra udskriftspanelet.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-cookie-samesite-schemeful =
    .label = Cookies: Schemeful SameSite
experimental-features-cookie-samesite-schemeful-description = Behandl cookies fra det samme domæne, men med forskellige schemes (fx http://eksempel.dk/ og https://eksempel.dk/) som cross-site i stedet for same-site. Det forbedrer sikkerheden, men kan medføre fejl.
# "Service Worker" is an API name and is usually not translated.
experimental-features-devtools-serviceworker-debugger-support =
    .label = Udviklerværktøj: Debugging af service-workers
# "Service Worker" is an API name and is usually not translated.
experimental-features-devtools-serviceworker-debugger-support-description = Aktiverer eksperimentel understøttelse af service-workers i Debugger-panelet. Funktion kan gøre udviklerværktøj langsommere og øge hukommelsesforbruget.
# Desktop zooming experiment
experimental-features-graphics-desktop-zooming =
    .label = Grafik: Jævn knibe-zoom
experimental-features-graphics-desktop-zooming-description = Understøtter jævn knibe-zoom på touchskærme og præcisions-touchpads.
