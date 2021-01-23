# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-masonry2 =
    .label = CSS: Masonry Layout
experimental-features-css-masonry-description = Aktiverer støtte for den eksperimentelle CSS Masonry Layout-funksjonen. Se denne <a data-l10n-name="explainer">forklaringen</a> for en beskrivelse av funksjonen på høyt nivå. For å gi tilbakemelding, kommenter <a data-l10n-name="w3c-issue">denne GitHub-saken</a> eller <a data-l10n-name="bug">denne feilrapporten</a>.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-gpu2 =
    .label = Web API: WebGPU
experimental-features-web-gpu-description2 = Denne nye API-en gir støtte på lavt nivå for å utføre beregning og grafisk gjengivelse ved å bruke <a data-l10n-name="wikipedia">grafikkprosessoren (GPU)</a> på brukerens enhet eller datamaskin. <a data-l10n-name="spec">Spesifikasjonen</a> er fremdeles under arbeid. Se <a data-l10n-name="bugzilla">bug 1602129</a> for mer informasjon.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-media-avif =
    .label = Media: AVIF
experimental-features-media-avif-description = Når denne funksjonen er aktivert, støtter { -brand-short-name } AVIF-format (AV1). Dette er et stillbildefilformat som utnytter mulighetene til AV1-videokomprimeringsalgoritmer for å redusere bildestørrelse. Se <a data-l10n-name="bugzilla">bug 1443863</a> for mer informasjon.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-api-inputmode =
    .label = Web API: inputmode
# "inputmode" and "contenteditable" are technical terms and shouldn't be translated.
experimental-features-web-api-inputmode-description = Vår implementering av <a data-l10n-name="mdn-inputmode">inputmode</a> global attributt er oppdatert i henhold til <a data-l10n-name="whatwg">WHATWG-spesifikasjonen</a>, men vi må fortsatt gjøre andre endringer, som å gjøre det tilgjengelig på redigerbart innhold. Se <a data-l10n-name="bugzilla">bug 1205133</a> for mer informasjon.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-api-link-preload =
    .label = Web API: <link rel="preload">
# Do not translate "rel", "preload" or "link" here, as they are all HTML spec
# values that do not get translated.
experimental-features-web-api-link-preload-description = <a data-l10n-name="rel">rel</a>-attributtet med verdien <code>«preload»</code> på et <a data-l10n-name="link">&lt;link&gt;</a>-elementet er ment å bidra til å gi ytelsesgevinster ved å la deg laste ned ressurser tidligere i livssyklusen for sidene, sikre at de er tilgjengelige tidligere og at det er mindre sannsynlig at det blokkerer sidegjengivelse. Les <a data-l10n-name="readmore">«Preloading content with <code>rel="preload"</code>»</a> eller se <a data-l10n-name="bugzilla">bug 1583604</a> for mer informasjon.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-focus-visible =
    .label = CSS: Pseudo-class: :focus-visible
experimental-features-css-focus-visible-description = Tillater at focus-stiler blir bukte på elementer som knapper og skjemakontroller, bare når de er fokuserte ved hjelp av tastaturet (f.eks. når du bruker tabulator-tasten for å hoppe mellom elementer), og ikke når de er fokusert ved hjelp av en mus eller annen pekeenhet. Se <a data-l10n-name="bugzilla">bug 1617600</a> for mer informasjon.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-api-beforeinput =
    .label = Web API: beforeinput Event
# The terms "beforeinput", "input", "textarea", and "contenteditable" are technical terms
# and shouldn't be translated.
experimental-features-web-api-beforeinput-description = Den globale <a data-l10n-name="mdn-beforeinput">beforeinput</a>-hendelsen blir avfyrt på <a data-l10n-name="mdn-input">&lt;input&gt;</a>- og <a data-l10n-name="mdn-textarea">&lt;textarea&gt;</a>-elementer, eller et hvilket som helst element hvis <a data-l10n-name="mdn-contenteditable">contenteditable</a>-attributtet er aktivert, rett før elementets verdi endres. Hendelsen gjør at nettapper kan overstyre nettleserens standardatferd for brukerinteraksjon, for eksempel kan nettapper avbryte brukerinndata bare for spesifikke tegn eller kan endre innliming av stylet tekst bare med godkjente stiler.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-constructable-stylesheets =
    .label = CSS: Constructable Stylesheets
experimental-features-css-constructable-stylesheets-description = Tilleggingen av en konstruktør til <a data-l10n-name="mdn-cssstylesheet">CSSStyleSheet</a>-grensesnittet samt en rekke relaterte endringer gjør det mulig å lage nye stilsett direkte uten å måtte legge settet til HTML. Dette gjør det mye enklere å lage gjenbrukbare stilsett for bruk med <a data-l10n-name="mdn-shadowdom">Shadow DOM</a>. Se <a data-l10n-name="bugzilla">bug 1520690</a> for mer informasjon.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-media-session-api =
    .label = Web API: Media Session API
experimental-features-media-session-api-description = Hele { -brand-short-name } sin implementeringen av Media Session API-et er foreløpig eksperimentell. Denne API-en brukes til å tilpasse håndteringen av medierelaterte varsler, for å administrere hendelser og data som er nyttige for å presentere et brukergrensesnitt for å administrere medieavspilling, og for å skaffe metadata for mediefiler. Se <a data-l10n-name="bugzilla">bug 1112032</a> for mer informasjon.
experimental-features-devtools-color-scheme-simulation =
    .label = Utviklerverktøy: Simulering av fargeskjema
experimental-features-devtools-color-scheme-simulation-description = Legger til et alternativ for å simulere forskjellige fargeskjemaer som lar deg teste <a data-l10n-name="mdn-preferscolorscheme">@prefers-color-schema</a>-mediespørring. Ved å bruke denne mediespørringen lar stilsettet ditt svare på om brukeren foretrekker et lyst eller mørkt brukergrensesnitt. Denne funksjonen lar deg teste koden din uten å måtte endre innstillinger i nettleseren (eller operativsystemet, hvis nettleseren følger en systemavhengig fargevalginnstilling). Se <a data-l10n-name="bugzilla1">bug 1550804</a> og <a data-l10n-name="bugzilla2">bug 1137699</a> for mer informasjon.
experimental-features-devtools-execution-context-selector =
    .label = Utviklerverktøy: Utførelseskontektsvelger
experimental-features-devtools-execution-context-selector-description = Denne funksjonen viser en knapp på konsollens kommandolinje som lar deg endre konteksten der uttrykket du skriver inn, skal kjøres. Se <a data-l10n-name="bugzilla1">bug 1605154</a> og <a data-l10n-name="bugzilla2">bug 1605153</a> for mer informasjon.
experimental-features-devtools-compatibility-panel =
    .label = Utviklerverktøy: Kompatibilitetspanel
experimental-features-devtools-compatibility-panel-description = Et sidepanel for Page Inspector som viser deg informasjon om appens kompatibilitetsstatus på tvers av nettlesere. Se <a data-l10n-name="bugzilla">bug 1584464</a> for mer informasjon.
# Do not translate 'SameSite', 'Lax' and 'None'.
experimental-features-cookie-samesite-lax-by-default2 =
    .label = Infokapsel: SameSite=Lax som standard
experimental-features-cookie-samesite-lax-by-default2-description = Behandle infokapsler som «SameSite=Lax» som standard hvis ingen «SameSite»-attributt er spesifisert. Utviklere kan velge fortsatt ubegrenset bruk ved å eksplisitt bruke «SameSite=None».
# Do not translate 'SameSite', 'Lax' and 'None'.
experimental-features-cookie-samesite-none-requires-secure2 =
    .label = Infokapsel: SameSite=None krever secure-attributt
experimental-features-cookie-samesite-none-requires-secure2-description = Infokapsler med «SameSite=None»-attributt krever secure-attributt. Denne funksjonen krever «Infokapsel: SameSite=Lax som standard».
# about:home should be kept in English, as it refers to the the URI for
# the internal default home page.
experimental-features-abouthome-startup-cache =
    .label = about:home oppstartshurtigbuffer
experimental-features-abouthome-startup-cache-description = Et hurtigbuffer for det første about:home-dokument som er lastet som standard ved oppstart. Hensikten med hurtigbufferet er å forbedre oppstartsytelsen.
experimental-features-print-preview-tab-modal =
    .label = Redesign av forhåndsvisning
experimental-features-print-preview-tab-modal-description = Introduserer den redesignede forhåndsvisning av utskrifter og gjør forhåndsvisning av utskrift tilgjengelig på macOS. Dette introduserer potensielle feil og inkluderer ikke alle utskriftsrelaterte innstillinger. For å få tilgang til alle utskriftsrelaterte innstillinger, velg «Skriv ut ved hjelp av systemdialogvinduet…» fra utskriftspanelet.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-cookie-samesite-schemeful =
    .label = Cookies: Schemeful SameSite
experimental-features-cookie-samesite-schemeful-description = Behandle informasjonskapsler fra samme domene, men med forskjellige skjemaer (f.eks. http://example.com og https://example.com) som flere nettsteder i stedet for samme nettsted. Forbedrer sikkerheten, men introduserer potensielt brudd.
# "Service Worker" is an API name and is usually not translated.
experimental-features-devtools-serviceworker-debugger-support =
    .label = Utviklerverktøy: Feilsøking av Service Worker
# "Service Worker" is an API name and is usually not translated.
experimental-features-devtools-serviceworker-debugger-support-description = Aktiverer eksperimentell støtte for Service Workers i feilsøkingspanelet. Denne funksjonen kan gjøre utviklerverktøyet treg og øke minneforbruket.
# Desktop zooming experiment
experimental-features-graphics-desktop-zooming =
    .label = Grafikk: Jevn knipeskalering
experimental-features-graphics-desktop-zooming-description = Aktiver støtte for jevn knipeskalering med berøringsskjermer og presisjonsstyreplate.
