# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-learn-more = Dalše informacije
onboarding-button-label-get-started = Prěnje kroki

## Welcome modal dialog strings

onboarding-welcome-header = Witajće k { -brand-short-name }
onboarding-welcome-body = Maće wobhladowak.<br/>Zeznajće so ze zbytkom { -brand-product-name }.
onboarding-welcome-learn-more = Dalše informacije wo lěpšinach.
onboarding-welcome-modal-get-body = Maće wobhladowak.<br/>Wućehńće najlěpše z { -brand-product-name }.
onboarding-welcome-modal-supercharge-body = Přećežće swój škit priwatnosće.
onboarding-welcome-modal-privacy-body = Maće wobhladowak. Přidajmy wjace škita priwatnosće.
onboarding-welcome-modal-family-learn-more = Zhońće wjace wo produktowej swójbje { -brand-product-name }.
onboarding-welcome-form-header = Tu započeć
onboarding-join-form-body = Zapodajće swoju e-mejlowu adresu, zo byšće započał.
onboarding-join-form-email =
    .placeholder = E-mejlowu adresu zapodać
onboarding-join-form-email-error = Płaćiwa e-mejlowa adresa trěbna
onboarding-join-form-legal = Hdyž pokročujeće, zwoliće do <a data-l10n-name="terms">wužiwanskich wuměnjenjow</a> a <a data-l10n-name="privacy">zdźělenki priwatnosće</a>.
onboarding-join-form-continue = Dale
# This message is followed by a link using onboarding-join-form-signin ("Sign In") as text.
onboarding-join-form-signin-label = Maće hižo konto?
# Text for link to submit the sign in form
onboarding-join-form-signin = Přizjewić
onboarding-start-browsing-button-label = Přehladowanje startować
onboarding-cards-dismiss =
    .title = Zaćisnyć
    .aria-label = Zaćisnyć

## Multistage 3-screen onboarding flow strings (about:welcome pages)

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-welcome-header = Witajće k <span data-l10n-name="zap">{ -brand-short-name }</span>
onboarding-multistage-welcome-subtitle = Spěšny, wěsty a priwatny wobhladowak, kotryž so wot powšitkownosći wužitneje organizacije podpěruje.
onboarding-multistage-welcome-primary-button-label = Konfigurowanje započeć
onboarding-multistage-welcome-secondary-button-label = Přizjewić
onboarding-multistage-welcome-secondary-button-text = Maće konto?
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "more" should stay inside the span.
onboarding-multistage-import-header = Importujće swoje hesła, zapołožki a <span data-l10n-name="zap">wjace</span>
onboarding-multistage-import-subtitle = Sće do toho druhi wobhladowak wužiwał? Je lochko, wšě do { -brand-short-name } přenjesć.
onboarding-multistage-import-primary-button-label = Import započeć
onboarding-multistage-import-secondary-button-label = Nic nětko
# Info displayed in the footer of import settings screen during onboarding flow.
# This supports welcome screen showing top sites imported from the user's default browser.
onboarding-import-sites-disclaimer =
    Sydła, kotrež su tu nalistowane, su so na tutym graće namakali.
    { -brand-short-name } daty z
    druheho wobhladowaka njeskładuje abo njesynchronizuje
    chibazo je importujeće.
# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = Prěnje kroki: wobrazowka { $current } z { $total }
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "look" should stay inside the span.
onboarding-multistage-theme-header = Wubjerće <span data-l10n-name="zap">napohlad</span>
onboarding-multistage-theme-subtitle = Personalizujće { -brand-short-name } z drastu.
onboarding-multistage-theme-primary-button-label = Drastu składować
onboarding-multistage-theme-secondary-button-label = Nic nětko
# Automatic theme uses operating system color settings
onboarding-multistage-theme-label-automatic = Awtomatiski
# System refers to the operating system
onboarding-multistage-theme-description-automatic = Systemowu drastu wužiwać
onboarding-multistage-theme-label-light = Swětły
onboarding-multistage-theme-label-dark = Ćmowy
# "Firefox Alpenglow" here is the name of the theme, and should be kept in English.
onboarding-multistage-theme-label-alpenglow = Firefox Alpenglow

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

# Tooltip displayed on hover of automatic theme
onboarding-multistage-theme-tooltip-automatic =
    .title =
        Napohlad z wašeho dźěłoweho
        systema za tłóčatka, menije a wokna zdźědźić.
    .aria-label = { onboarding-multistage-theme-tooltip-automatic.title }
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light =
    .title =
        Swětły napohlad za tłóčatka,
        menije a wokna.
    .aria-label = { onboarding-multistage-theme-tooltip-light.title }
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark =
    .title =
        Ćmowy napohlad za tłóčatka,
        menije a wokna.
    .aria-label = { onboarding-multistage-theme-tooltip-dark.title }
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow =
    .title =
        Barbny napohlad za tłóčatka,
        menije a wokna.
    .aria-label = { onboarding-multistage-theme-tooltip-alpenglow.title }
# Tooltip displayed on hover of automatic theme
onboarding-multistage-theme-tooltip-automatic-2 =
    .title =
        Napohlad z wašeho dźěłoweho
        systema za tłóčatka, menije a wokna zdźědźić.
# Input description for automatic theme
onboarding-multistage-theme-description-automatic-2 =
    .aria-description =
        Napohlad z wašeho dźěłoweho
        systema za tłóčatka, menije a wokna zdźědźić.
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light-2 =
    .title =
        Swětły napohlad za tłóčatka,
        menije a wokna.
# Input description for light theme
onboarding-multistage-theme-description-light =
    .aria-description =
        Swětły napohlad za tłóčatka,
        menije a wokna.
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark-2 =
    .title =
        Ćmowy napohlad za tłóčatka,
        menije a wokna.
# Input description for dark theme
onboarding-multistage-theme-description-dark =
    .aria-description =
        Ćmowy napohlad za tłóčatka,
        menije a wokna.
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow-2 =
    .title =
        Barbny napohlad za tłóčatka,
        menije a wokna.
# Input description for Alpenglow theme
onboarding-multistage-theme-description-alpenglow =
    .aria-description =
        Barbny napohlad za tłóčatka,
        menije a wokna.

## Welcome full page string

onboarding-fullpage-welcome-subheader = Započńmy wšitko wuslědźić, štož móžeće činić.
onboarding-fullpage-form-email =
    .placeholder = Waša e-mejlowa adresa…

## Firefox Sync modal dialog strings.

onboarding-sync-welcome-header = Wzmiće { -brand-product-name } sobu
onboarding-sync-welcome-content = Wzmiće swoje zapołožki, historiju, hesła a druhe nastajenja na wšěch wašich gratach sobu.
onboarding-sync-welcome-learn-more-link = Zhońće wjace wo Firefox Accounts
onboarding-sync-form-input =
    .placeholder = E-mejl
onboarding-sync-form-continue-button = Pokročować
onboarding-sync-form-skip-login-button = Tutón krok přeskočić

## This is part of the line "Enter your email to continue to Firefox Sync"

onboarding-sync-form-header = Zapodajće swoju e-mejlowu adresu,
onboarding-sync-form-sub-header = zo byšće z { -sync-brand-name } pokročował.

## These are individual benefit messages shown with an image, title and
## description.

onboarding-benefit-products-text = Sčińće wěcy z nastrojemi, kotrež wašu priwatnosć na wšěch gratach respektuja.
# "Personal Data Promise" is a concept that should be translated consistently
# across the product. It refers to a concept shown elsewhere to the user: "The
# Firefox Personal Data Promise is the way we honor your data in everything we
# make and do. We take less data. We keep it safe. And we make sure that we are
# transparent about how we use it."
onboarding-benefit-privacy-text = Wšitko, štož činimy, naše slubjenje za wosobinske daty spjelnja: Mjenje zběrać. Wěsće sładować. Žane potajnstwa.
onboarding-benefit-sync-title = { -sync-brand-short-name }
onboarding-benefit-sync-text = Wzmiće swoje zapołožki, hesła, historiju a wjace wšudźe sobu, hdźež { -brand-product-name } wužiwaće.
onboarding-benefit-monitor-title = { -monitor-brand-short-name }
onboarding-benefit-monitor-text = Dóstańće zdźělenki, hdyž waše wosobinske informacije su w znatej datowej dźěrje.
onboarding-benefit-lockwise-title = { -lockwise-brand-short-name }
onboarding-benefit-lockwise-text = Rjadujće hesła, kotrež su škitane a portabelne.

## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

onboarding-tracking-protection-title2 = Škit přećiwo slědowanju
onboarding-tracking-protection-text2 = { -brand-short-name } wam pomha, websydła při tym haćić, wam online slědować, zo by za wabjenje ćešo było, wam po webje slědować.
onboarding-tracking-protection-button2 = Kak funguje
onboarding-data-sync-title = Wzmiće swoje nastajenja sobu
# "Sync" is short for synchronize.
onboarding-data-sync-text2 = Synchronizujće swoje zapołožki, hesła a wjace wšudźe, hdźež { -brand-product-name } wužiwaće.
onboarding-data-sync-button2 = Pola { -sync-brand-short-name } přizjewić
onboarding-firefox-monitor-title = Dajće sej při datowych dźěrach warnować
onboarding-firefox-monitor-text2 = { -monitor-brand-name } dohladuje, hač je so waša e-mejlowa adresa hižo w znatej datowej dźěrje zjewiła a warnuje was, hdyž so w nowej dźěrje jewi.
onboarding-firefox-monitor-button = Za zdźělenki registrować
onboarding-browse-privately-title = Přehladowajće z priwatnosću
onboarding-browse-privately-text = Priwatny modus wašej pytansku a přehladowansku historiju zhaša, zo by jej před kóždym zatajił, kotryž waš ličak wužiwa.
onboarding-browse-privately-button = Priwatne wokno wočinić
onboarding-firefox-send-title = Dźeržće swoje dźělene dataje priwatne
onboarding-firefox-send-text2 = Nahrajće swoje dataje do { -send-brand-name }, zo byšće je ze zaklučowanjom kónc do kónca a z wotkazom, kotryž awtomatisce spadnje, dźělił.
onboarding-firefox-send-button = { -send-brand-name } wupruwować
onboarding-mobile-phone-title = Instalujće sej { -brand-product-name } na swojim telefonje
onboarding-mobile-phone-text = Sćehńće { -brand-product-name } za iOS abo Android a synchronizujće swoje daty přez graty.
# "Mobile" is short for mobile/cellular phone, "Browser" is short for web
# browser.
onboarding-mobile-phone-button = Mobilny wobhladowak sćahnyć
onboarding-send-tabs-title = Sćelće hnydom rajtarki
# "Send Tabs" refers to "Send Tab to Device" feature that appears when opening a
# tab's context menu.
onboarding-send-tabs-text2 = Dźělće lochko strony mjez wašimi gratami dźěli, bjeztoho zo byšće wotkazy kopěrował abo wobhladowak wopušćił.
onboarding-send-tabs-button = Wužiwajće Send Tabs
onboarding-pocket-anywhere-title = Čitajće a słuchajće wšudźe
onboarding-pocket-anywhere-text2 = Składujće swój najlubši wobsah offline z nałoženjom { -pocket-brand-name } a čitajće, słuchajće a wobhladajće, hdyžkuli so wam hodźi.
onboarding-pocket-anywhere-button = { -pocket-brand-name } wupruwować
onboarding-lockwise-strong-passwords-title = Mócne hesła wutworić a składować
onboarding-lockwise-strong-passwords-text = { -lockwise-brand-name } hnydom sylne hesła wutworja a składuje je na jednym městnje.
onboarding-lockwise-strong-passwords-button = Waše přizjewjenja rjadować
onboarding-facebook-container-title = Stajće hranicy za Facebook
onboarding-facebook-container-text2 = { -facebook-container-brand-name } waš profil dźěleny wot wšeho druheho dźerži. Tak je ćešo za Facebook, wam zaměrne wabjenje pokazać.
onboarding-facebook-container-button = Rozšěrjenje přidać
onboarding-import-browser-settings-title = Waše zapołožki, hesła a wjace importować
onboarding-import-browser-settings-text = Započńće hnydom - wzmiće swoje sydła Chrome a nastajenja sobu.
onboarding-import-browser-settings-button = Daty Chrome importować
onboarding-personal-data-promise-title = Priwatny po designje
onboarding-personal-data-promise-text = { -brand-product-name } z wašimi datami z respektom postupuje, zběra mjenje z nich, škita je a praji jasnje, kak my je wužiwamy.
onboarding-personal-data-promise-button = Čitajće naše slubjenje

## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = Wulkotnje, maće { -brand-short-name }
# <icon></icon> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-header = Wobstarajće sej nětko <icon></icon><b>{ $addon-name }.</b>
return-to-amo-extension-button = Rozšěrjenje přidać
return-to-amo-get-started-button = Prěnje kroki z { -brand-short-name }
