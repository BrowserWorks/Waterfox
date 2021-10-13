# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-masonry2 =
    .label = CSS: Masonry Layout
experimental-features-css-masonry-description = Aktiverer støtte for den eksperimentelle CSS Masonry Layout-funksjonen. Sjå denne <a data-l10n-name="explainer">forklaringa</a> for ei skildring av funksjonen på høgt nivå. For å gi tilbakemelding, kommenter <a data-l10n-name="w3c-issue">denne GitHub-saka</a> eller <a data-l10n-name="bug">denne feilrapporten</a>.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-cascade-layers =
    .label = CSS: Cascade Layers
experimental-features-css-cascade-layers-description = Aktiverer støtte for CSS Cascade Layers. Sjå <a data-l10n-name="spec">den mellombelse spesifikasjonen</a> for meir informasjon. Rapporter gjerne feil med denne funksjonen på <a data-l10n-name="bugzilla">bug 1699215</a>.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-gpu2 =
    .label = Web API: WebGPU
experimental-features-web-gpu-description2 = Denne nye API-en gir støtte på lågt nivå for  utrekning og grafisk attgiving ved å bruke <a data-l10n-name="wikipedia">grafikkprosessoren (GPU)</a> på eininga eller datamaskina til brukaren. <a data-l10n-name="spec">Spesifikasjonen</a> er enno under arbeid. Sjå <a data-l10n-name="bugzilla">bug 1602129</a> for meir informasjon.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-media-avif =
    .label = Media: AVIF
experimental-features-media-avif-description = Når denne funksjonen er slått på, støttar { -brand-short-name } AVIF-format (AV1). Dette er eit stillbildefilformat som utnyttar moglegheitene til AV1-videokomprimeringsalgoritmar for å redusere bildestørrelse. Sjå <a data-l10n-name="bugzilla">bug 1443863</a> for meir informasjon.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-media-jxl =
    .label = Media: JPEG XL
experimental-features-media-jxl-description = Med denne funksjonen aktivert støttar { -brand-short-name } formatet JPEG XL (JXL). Dette er eit forbetra bildefilformat som støttar tapsfri overgang frå tradisjonelle JPEG-filer. Sjå <a data-l10n-name="bugzilla">feilrapport 1539075</a> for meir informasjon.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-api-inputmode =
    .label = Web API: inputmode
# "inputmode" and "contenteditable" are technical terms and shouldn't be translated.
experimental-features-web-api-inputmode-description = Implementeringa vår av <a data-l10n-name="mdn-inputmode">inputmode</a> global attributt er oppdatert i samsvar med <a data-l10n-name="whatwg">WHATWG-spesifikasjonen</a>, men vi må enno gjere andre endringar, som å gjere det tilgjengeleg på redigerbart innhald. Sjå <a data-l10n-name="bugzilla">bug 1205133</a> for meir informasjon.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-constructable-stylesheets =
    .label = CSS: Constructable Stylesheets
experimental-features-css-constructable-stylesheets-description = Tillegginga av ein konstruktør til <a data-l10n-name="mdn-cssstylesheet">CSSStyleSheet</a>-grensesnittet i tillegg til ei rekkje relaterte endringar gjer det mogleg å lage nye stilsett direkte, utan å måtte leggje settet til HTML. Dette gjer det mykje enklare å lage gjenbruksstilsett for bruk med <a data-l10n-name="mdn-shadowdom">Shadow DOM</a>. Sjå <a data-l10n-name="bugzilla">bug 1520690</a> for meir informasjon.
experimental-features-devtools-color-scheme-simulation =
    .label = Utviklarverktøy: Simulering av fargeskjema
experimental-features-devtools-color-scheme-simulation-description = Legg til eit alternativ for å simulere ulike fargeskjema som lar deg teste <a data-l10n-name="mdn-preferscolorscheme">@prefers-color-schema</a>-mediespørjing. Ved å bruke denne mediespørjinga lar stilsettet ditt svare på om brukaren føretrekkjer eit lyst eller mørkt brukargrensesnitt. Denne funksjonen lar deg teste koden din utan å måtte endre innstillingar i nettlesaren (eller operativsystemet, dersom nettlesaren følgjer ei systemavhengig fargevalinnstilling). Sjå <a data-l10n-name="bugzilla1">bug 1550804</a> og <a data-l10n-name="bugzilla2">bug 1137699</a> for meir informasjon.
experimental-features-devtools-execution-context-selector =
    .label = Utviklarverktøy: Utføringskontektsveljar
experimental-features-devtools-execution-context-selector-description = Denne funksjonen viser ein knapp på kommandolinja til konsollen som lèt deg endre konteksten der uttrykket du skriv inn, skal køyrast. Sjå <a data-l10n-name="bugzilla1">bug 1605154</a> og <a data-l10n-name="bugzilla2">bug 1605153</a> for meir informasjon.
experimental-features-devtools-compatibility-panel =
    .label = Utviklarverktøy: Kompatibilitetspanel
experimental-features-devtools-compatibility-panel-description = Eit sidepanel for Page Inspector som viser deg informasjon om kompatibilitetsstatusen til appen på tvers av nettlesarar. Sjå <a data-l10n-name="bugzilla">bug 1584464</a> for meir informasjon.
# Do not translate 'SameSite', 'Lax' and 'None'.
experimental-features-cookie-samesite-lax-by-default2 =
    .label = Infokapsel: SameSite=Lax som standard
experimental-features-cookie-samesite-lax-by-default2-description = Handter infokapslar som «SameSite=Lax» som standard dersom ingen «SameSite»-attributt er spesifisert. Utviklarar kan framleis velje uavgrensa bruk ved å eksplisitt bruke «SameSite=None».
# Do not translate 'SameSite', 'Lax' and 'None'.
experimental-features-cookie-samesite-none-requires-secure2 =
    .label = Infokapsel: SameSite=None krev secure-attributt
experimental-features-cookie-samesite-none-requires-secure2-description = Infokapslar med «SameSite=None»-attributt krev secure-attributt. Denne funksjonen krev «Infokapsel: SameSite=Lax som standard».
# about:home should be kept in English, as it refers to the the URI for
# the internal default home page.
experimental-features-abouthome-startup-cache =
    .label = about:home oppstartshurtigbuffer
experimental-features-abouthome-startup-cache-description = Ein hurtigbuffer for det første about:home-dokumentet som er lasta som standard ved oppstart. Føremålet med hurtigbufferen er å forbetre oppstartytinga.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-cookie-samesite-schemeful =
    .label = Infokapslar: Schemeful SameSite
experimental-features-cookie-samesite-schemeful-description = Handsam informasjonskapslar frå same domene, men med ulike skjema (t.d. http://example.com og https://example.com) som fleire nettstadar i staden for same nettstad. Betrar sikkerheita, men introduserer potensielt brot.
# "Service Worker" is an API name and is usually not translated.
experimental-features-devtools-serviceworker-debugger-support =
    .label = Utviklarverktøy: Feilsøking av Service Worker
# "Service Worker" is an API name and is usually not translated.
experimental-features-devtools-serviceworker-debugger-support-description = Aktiverer eksperimentell støtte for Service Workers i feilsøkingspanelet. Denne funksjonen kan gjere utviklerverktøyet treg og auke minneforbruket.
# WebRTC global mute toggle controls
experimental-features-webrtc-global-mute-toggles =
    .label = Global WebRTC dempekontroll
experimental-features-webrtc-global-mute-toggles-description = Legg til kontrollar i WebRTCs globale delingsvarsel som brukarar kan nytte til å globalt dempe eigen mikrofon og eigne kamerakjelder.
# Win32k Lockdown
experimental-features-win32k-lockdown =
    .label = Win32k-låsing
experimental-features-win32k-lockdown-description = Deaktiver bruk av Win32k API-ar i nettlesarfaner. Gir auka sikkerheit, men kan for tida vere ustabil eller utsett for feil. (Berre Windows)
# JS JIT Warp project
experimental-features-js-warp =
    .label = JavaScript JIT: Warp
experimental-features-js-warp-description = Slå på Warp, eit prosjekt for å forbetre JavaScript-ytelse og minnebruk.
# Fission is the name of the feature and should not be translated.
experimental-features-fission =
    .label = Fission (nettstadisolering)
experimental-features-fission-description = Fission (nettstadisolering) er ein eksperimentell funksjon i { -brand-short-name } for å gi eit ekstra forsvarslag mot sikkerheitsfeil. Ved å isolere kvar nettstad i ein eigen prosess, gjer Fission det vanskelegare for vondsinna nettstadar å få tilgang til informasjon frå andre sider du besøkjer. Dette er ei stor arkitektonisk endring i { -brand-short-name }, og vi set pris på at du testar og rapporterer eventuelle problem du kan støyte på. For meir informasjon, sjå <a data-l10n-name="wiki">wiki-en</a>.
# Support for having multiple Picture-in-Picture windows open simultaneously
experimental-features-multi-pip =
    .label = Støtte for fleire bilde-i-bilde (PiP)
experimental-features-multi-pip-description = Eksperimentell støtte for å opne fleire bilde-i-bilde (PiP) vindauge samstundes.
# Search during IME
experimental-features-ime-search =
    .label = Adresselinja: Vis resultat under IME-samansetjing
experimental-features-ime-search-description = Ein IME (Input Method Editor) er eit verktøy som lar deg skrive inn komplekse symbol, til dømes dei som vert brukte i austasiatiske eller Indiske skriftspråk, ved hjelp av eit standardtastatur. Aktivering av dette eksperimentet held adresselinjepanelet ope, viser søkjeresultat og forslag mens du brukar IME til å leggje inn tekst. Merk at IME kan vise eit panel som dekkjer resultata i adresselinja, og derfor er denne preferansen berre tilrådd for IME som ikkje brukar denne typen panel.
