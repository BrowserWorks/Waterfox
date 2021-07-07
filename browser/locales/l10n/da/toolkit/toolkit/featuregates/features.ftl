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
experimental-features-media-jxl =
    .label = Media: JPEG XL
experimental-features-media-jxl-description = Når denne funktion er slået til understøtter { -brand-short-name } formatet JPEG XL (JXL). Dette er et forbedret billedfil-format, der understøtter tabsfri overgang fra traditionelle JPEG-filer. Se flere detaljer på <a data-l10n-name="bugzilla">bug 1539075</a>.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-api-inputmode =
    .label = Web API: inputmode
# "inputmode" and "contenteditable" are technical terms and shouldn't be translated.
experimental-features-web-api-inputmode-description = Vores implementering af den globale attribut <a data-l10n-name="mdn-inputmode">inputmode</a> er blevet opdateret i overensstemmelse med <a data-l10n-name="whatwg">WHATWG-specifikationen</a>. Men vi mangler stadig at ændre nogle ting, som fx at gøre attributten tilgængelig for redigerbart indhold. Se flere detaljer på <a data-l10n-name="bugzilla">bug 1205133</a>.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-constructable-stylesheets =
    .label = CSS: Constructable Stylesheets
experimental-features-css-constructable-stylesheets-description = Tilføjelsen af en constructor til <a data-l10n-name="mdn-cssstylesheet">CSSStyleSheet</a>-brugerfladen samt en række relaterede ændringer gør det muligt at oprette nye stylesheets direkte uden at tilføje dem til HTML'en. Det gør det meget nemmere at oprette genbrugelige stylesheets til brug med <a data-l10n-name="mdn-shadowdom">Shadow DOM</a>. Se flere detaljer på <a data-l10n-name="bugzilla">bug 1520690</a>.
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
# WebRTC global mute toggle controls
experimental-features-webrtc-global-mute-toggles =
    .label = Slå lyd fra/til globalt for WebRTC
experimental-features-webrtc-global-mute-toggles-description = Føj knapper til den globale dele-indikator for WebRTC, sådan at brugeren kan slå lyden fra på deres mikrofon og kamera-feeds overalt.
# Win32k Lockdown
experimental-features-win32k-lockdown =
    .label = Win32k Lockdown
experimental-features-win32k-lockdown-description = Deaktiverer brugen af Win32k API'er i browser-faneblade. Giver bedre sikkerhed, men kan være ustabil eller fejlbehæftet i øjeblik. (Kun til Windows)
# JS JIT Warp project
experimental-features-js-warp =
    .label = JavaScript JIT: Warp
experimental-features-js-warp-description = Aktiver Warp, et projekt hvis formål er at forbedre ydelse og hukommelsesforbrug ved brug af JavaScript.
# Fission is the name of the feature and should not be translated.
experimental-features-fission =
    .label = Fission (isolation af websteder)
experimental-features-fission-description = Fission (isolation af websteder) er en eksperimentel funktion i { -brand-short-name }, der giver et ekstra lag fa beskyttelse mod sikkerhedsfejl. Ved at isolere hvert websted i en separat proces gør Fission det sværere for ondsindede websteder at få adgang til information fra andre sider, du besøger. Fission udgør en grundlæggende ændring i { -brand-short-name }' arkitektur - og vi sætter stor pris på, at du vil hjælpe os med at teste funktionen og indrapportere eventuelle fejl, du støder på. Læs mere på <a data-l10n-name="wiki">wiki'en</a>.
# Support for having multiple Picture-in-Picture windows open simultaneously
experimental-features-multi-pip =
    .label = Understøttelse af flere billede-i-billede
experimental-features-multi-pip-description = Eksperimentel understøttelse for, at flere videoer kan vises som billede-i-billede på samme tid.
experimental-features-http3 =
    .label = HTTP/3-protokol
experimental-features-http3-description = Eksperimentel understøttelse for HTTP/3-protokollen.
# Search during IME
experimental-features-ime-search =
    .label = Adressefelt: Vis resulter under IME-komponering
experimental-features-ime-search-description = En IME (Input Method Editor) er et værktøj, der lader dig indtaste komplekse symboler med et almindeligt tastatur, fx symboler fra øst-asiatiske og indiske skriftsprog. Ved aktivering af dette eksperiment holdes adressefeltet åbent med søgeresultater og forslag, når du bruger IME til at indtaste tekst. Bemærk, at IME kan vise et panel, der dækker for resultaterne i adressefeltet. Derfor foreslås denne indstilling kun for IME, der ikke anvender denne type af panel.
