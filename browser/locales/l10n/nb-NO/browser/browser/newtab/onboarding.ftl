# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-learn-more = Les mer
onboarding-button-label-get-started = Kom i gang

## Welcome modal dialog strings

onboarding-welcome-header = Velkommen til { -brand-short-name }
onboarding-welcome-body = Du har nettleseren.<br/>Møt resten av { -brand-product-name }.
onboarding-welcome-learn-more = Les mer om fordelene.
onboarding-welcome-modal-get-body = Du har nettleseren.<br/>Få mest mulig ut av { -brand-product-name }.
onboarding-welcome-modal-supercharge-body = Forsterk personvernbeskyttelsen din.
onboarding-welcome-modal-privacy-body = Du har nettleseren. La oss legge til mer personvernbeskyttelser.
onboarding-welcome-modal-family-learn-more = Les mer om { -brand-product-name }-familien av produkter.
onboarding-welcome-form-header = Start her
onboarding-join-form-body = Skriv inn e-postadressen din for å komme i gang.
onboarding-join-form-email =
    .placeholder = Skriv inn e-postadresse
onboarding-join-form-email-error = Gyldig e-postadresse kreves
onboarding-join-form-legal = Ved å fortsette aksepterer du våre <a data-l10n-name="terms">tjenestevilkår</a> og <a data-l10n-name="privacy">personvernbestemmelser</a>.
onboarding-join-form-continue = Fortsett
# This message is followed by a link using onboarding-join-form-signin ("Sign In") as text.
onboarding-join-form-signin-label = Har du allerede en konto?
# Text for link to submit the sign in form
onboarding-join-form-signin = Logg inn
onboarding-start-browsing-button-label = Start nettlesing
onboarding-cards-dismiss =
    .title = Avslå
    .aria-label = Avslå

## Multistage 3-screen onboarding flow strings (about:welcome pages)

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-welcome-header = Velkommen til <span data-l10n-name="zap">{ -brand-short-name }</span>
onboarding-multistage-welcome-subtitle = Den raske, trygge og private nettleseren som er støttet av en ideell organisasjon.
onboarding-multistage-welcome-primary-button-label = Start oppsett
onboarding-multistage-welcome-secondary-button-label = Logg inn
onboarding-multistage-welcome-secondary-button-text = Har du allerede en konto?
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "more" should stay inside the span.
onboarding-multistage-import-header = Importer passord, bokmerker og <span data-l10n-name="zap">mer</span>
onboarding-multistage-import-subtitle = Kommer du fra en annen nettleser? Det er enkelt å ta alt med til { -brand-short-name }.
onboarding-multistage-import-primary-button-label = Start import
onboarding-multistage-import-secondary-button-label = Ikke nå
# Info displayed in the footer of import settings screen during onboarding flow.
# This supports welcome screen showing top sites imported from the user's default browser.
onboarding-import-sites-disclaimer =
    Nettstedene som er oppført her ble funnet på denne enheten.
    { -brand-short-name } lagrer eller synkroniserer
    ikke data fra en annen nettleser med mindre du
    velger å importer den.
# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = Komme i gang: Skjermbilde { $current } av { $total }
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "look" should stay inside the span.
onboarding-multistage-theme-header = Velg et <span data-l10n-name="zap">utseende</span>
onboarding-multistage-theme-subtitle = Tilpass { -brand-short-name } med et tema.
onboarding-multistage-theme-primary-button-label = Lagre tema
onboarding-multistage-theme-secondary-button-label = Ikke nå
# Automatic theme uses operating system color settings
onboarding-multistage-theme-label-automatic = Automatisk
# System refers to the operating system
onboarding-multistage-theme-description-automatic = Bruk systemtema
onboarding-multistage-theme-label-light = Lyst
onboarding-multistage-theme-label-dark = Mørkt
# "Firefox Alpenglow" here is the name of the theme, and should be kept in English.
onboarding-multistage-theme-label-alpenglow = Firefox Alpenglow

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

# Tooltip displayed on hover of automatic theme
onboarding-multistage-theme-tooltip-automatic =
    .title =
        Arv utseendet fra operativsystemet
        for knapper, menyer og vinduer.
    .aria-label = { onboarding-multistage-theme-tooltip-automatic.title }
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light =
    .title =
        Bruk et lyst utseende for knapper,
        menyer og vinduer.
    .aria-label = { onboarding-multistage-theme-tooltip-light.title }
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark =
    .title =
        Bruk et mørkt utseende for knapper,
        menyer og vinduer.
    .aria-label = { onboarding-multistage-theme-tooltip-dark.title }
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow =
    .title =
        Bruk et fargerikt utseende for knapper,
        menyer og vinduer.
    .aria-label = { onboarding-multistage-theme-tooltip-alpenglow.title }
# Tooltip displayed on hover of automatic theme
onboarding-multistage-theme-tooltip-automatic-2 =
    .title =
        Arv utseendet fra operativsystemet
        for knapper, menyer og vinduer.
# Input description for automatic theme
onboarding-multistage-theme-description-automatic-2 =
    .aria-description =
        Arv utseendet fra operativsystemet
        for knapper, menyer og vinduer.
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light-2 =
    .title =
        Bruk et lyst utseende for knapper,
        menyer og vinduer.
# Input description for light theme
onboarding-multistage-theme-description-light =
    .aria-description =
        Bruk et lyst utseende for knapper,
        menyer og vinduer.
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark-2 =
    .title =
        Bruk et mørkt utseende for knapper,
        menyer og vinduer.
# Input description for dark theme
onboarding-multistage-theme-description-dark =
    .aria-description =
        Bruk et mørkt utseende for knapper,
        menyer og vinduer.
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow-2 =
    .title =
        Bruk et fargerikt utseende for knapper,
        menyer og vinduer.
# Input description for Alpenglow theme
onboarding-multistage-theme-description-alpenglow =
    .aria-description =
        Bruk et fargerikt utseende for knapper,
        menyer og vinduer.

## Welcome full page string

onboarding-fullpage-welcome-subheader = La oss starte å utforske alt du kan gjøre.
onboarding-fullpage-form-email =
    .placeholder = Din e-postadresse…

## Firefox Sync modal dialog strings.

onboarding-sync-welcome-header = Ta med deg { -brand-product-name }
onboarding-sync-welcome-content = Få dine bokmerker, historikk, passord, og andre innstillinger på alle enhetene dine.
onboarding-sync-welcome-learn-more-link = Les mer om Firefox-konto
onboarding-sync-form-input =
    .placeholder = E-post
onboarding-sync-form-continue-button = Fortsett
onboarding-sync-form-skip-login-button = Hopp over dette trinnet

## This is part of the line "Enter your email to continue to Firefox Sync"

onboarding-sync-form-header = Skriv inn e-postadressen din
onboarding-sync-form-sub-header = for å fortsette til { -sync-brand-name }.

## These are individual benefit messages shown with an image, title and
## description.

onboarding-benefit-products-text = Få ting gjort med en familie av verktøy som respekterer personvernet ditt på alle dine enheter.
# "Personal Data Promise" is a concept that should be translated consistently
# across the product. It refers to a concept shown elsewhere to the user: "The
# Firefox Personal Data Promise is the way we honor your data in everything we
# make and do. We take less data. We keep it safe. And we make sure that we are
# transparent about how we use it."
onboarding-benefit-privacy-text = Vi overholder vår lovnad om private data i alt vi gjør: Samle inn mindre. Oppbevar det sikkert. Ingen hemmeligheter.
onboarding-benefit-sync-title = { -sync-brand-short-name }
onboarding-benefit-sync-text = Ta med bokmerker, passord, historikk og mer overalt hvor du bruker { -brand-product-name }.
onboarding-benefit-monitor-title = { -monitor-brand-short-name }
onboarding-benefit-monitor-text = Bli varslet når din personlige informasjon er i en kjent datalekkasje.
onboarding-benefit-lockwise-title = { -lockwise-brand-short-name }
onboarding-benefit-lockwise-text = Behandle passordene dine som du kan ta med overalt.

## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

onboarding-tracking-protection-title2 = Beskyttelse mot sporing
onboarding-tracking-protection-text2 = { -brand-short-name } bidrar til å stoppe nettsteder fra å spore deg på nettet, noe som gjør det vanskeligere for reklame å spore aktivitetene dine på nettet.
onboarding-tracking-protection-button2 = Hvordan det virker
onboarding-data-sync-title = Ta med deg innstillingene dine
# "Sync" is short for synchronize.
onboarding-data-sync-text2 = Synkroniser dine bokmerker, passord og mer overalt hvor du bruker { -brand-product-name }.
onboarding-data-sync-button2 = Logg inn på { -sync-brand-short-name }
onboarding-firefox-monitor-title = Vær oppmerksom på datalekkasjer
onboarding-firefox-monitor-text2 = { -monitor-brand-name } overvåker om e-postenadressen din har dukket opp i kjente datalekkasjer og varsler deg om det vises i en ny lekkasje.
onboarding-firefox-monitor-button = Registrer deg for varslinger
onboarding-browse-privately-title = Surf privat
onboarding-browse-privately-text = Privat nettlesing fjerner din søke- og nettlesingshistorikk for å holde den hemmelig fra andre som bruker din datamaskin.
onboarding-browse-privately-button = Åpne et privat vindu
onboarding-firefox-send-title = Hold de delte filene dine privat
onboarding-firefox-send-text2 = Last opp filene dine til { -send-brand-name } for å dele dem med ende-til-ende-kryptering og en lenke som automatisk utløper.
onboarding-firefox-send-button = Prøv { -send-brand-name }
onboarding-mobile-phone-title = Last ned { -brand-product-name } til telefonen din
onboarding-mobile-phone-text = Last ned { -brand-product-name } for iOS eller Android og synkroniser dine data mellom enheter.
# "Mobile" is short for mobile/cellular phone, "Browser" is short for web
# browser.
onboarding-mobile-phone-button = Last ned mobilnettleser
onboarding-send-tabs-title = Send øyeblikkelig faner til deg selv
# "Send Tabs" refers to "Send Tab to Device" feature that appears when opening a
# tab's context menu.
onboarding-send-tabs-text2 = Del sider enkelt mellom enhetene dine uten å måtte kopiere lenker eller forlate nettleseren.
onboarding-send-tabs-button = Begynn å bruke send fane
onboarding-pocket-anywhere-title = Les og lytt hvor som helst
onboarding-pocket-anywhere-text2 = Lagre favorittinnholdet ditt frakoblet med { -pocket-brand-name }-appen. Så kan du lese, lytte og se når det passer deg.
onboarding-pocket-anywhere-button = Prøv { -pocket-brand-name }
onboarding-lockwise-strong-passwords-title = Opprett og lagre sterke passord
onboarding-lockwise-strong-passwords-text = { -lockwise-brand-name } oppretter sterke passord på stedet og lagrer dem alle på ett sted.
onboarding-lockwise-strong-passwords-button = Behandle dine innlogginger
onboarding-facebook-container-title = Sett grenser for Facebook
onboarding-facebook-container-text2 = { -facebook-container-brand-name } holder din profil skilt unna alt annet, som gjør det vanskeligere for Facebook å målrette annonser mot deg.
onboarding-facebook-container-button = Legg til utvidelsen
onboarding-import-browser-settings-title = Importer dine bokmerker, passord og mer
onboarding-import-browser-settings-text = Kom raskt i gang—ta enkelt med deg Chrome-nettsteder og -innstillinger.
onboarding-import-browser-settings-button = Importer Chrome-data
onboarding-personal-data-promise-title = Designet for personvern
onboarding-personal-data-promise-text = { -brand-product-name } behandler dine data med respekt ved å ta mindre av dem, beskytte dem og være tydelig på hvordan vi bruker dem.
onboarding-personal-data-promise-button = Les løftet vårt

## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = Bra, du har { -brand-short-name }
# <icon></icon> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-header = La oss nå hente <icon></icon><b>{ $addon-name }</b>.
return-to-amo-extension-button = Legg til utvidelsen
return-to-amo-get-started-button = Kom i gang med { -brand-short-name }
