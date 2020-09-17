# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-learn-more = Tetamäx Ch'aqa' Chik
onboarding-button-label-get-started = Titikirisäx

## Welcome modal dialog strings

onboarding-welcome-header = Ütz apetik pa { -brand-short-name }
onboarding-welcome-body = K'o awik'in ri okik'amaya'l.<br/>Tawetamaj ri ch'aqa' chik taq { -brand-product-name }.
onboarding-welcome-learn-more = Tawetamaj ch'aqa' chik pa ruwi' ri taq rutzil.
onboarding-welcome-modal-get-body = K'o chik awik'in ri okik'amaya'l.<br/>Tawetamaj ütz rusamajixik { -brand-product-name }.
onboarding-welcome-modal-supercharge-body = Taya' ralal ri ruchajixik awichinanem.
onboarding-welcome-modal-privacy-body = K'o chik awik'in ri okik'amaya'l. Tatz'aqatisaj ch'aqa' chik ta ruchajixik ichinanem.
onboarding-welcome-modal-family-learn-more = Tawetamaj chi rij ri { -brand-product-name } ach'alal taq tikojil.
onboarding-welcome-form-header = Wawe' Tatikirisaj
onboarding-join-form-body = Richin natikirisaj, tatz'ib'aj ri rochochib'al ataqoya'l.
onboarding-join-form-email =
    .placeholder = Titz'ib'äx taqoya'l
onboarding-join-form-email-error = Ütz taqoya'l najowäx
onboarding-join-form-legal = Pa rub'eyal, rat nawojqaj ri <a data-l10n-name="terms">Rojqanem Samaj</a> chuqa' <a data-l10n-name="privacy">Rutzijol Ichinanem</a>.
onboarding-join-form-continue = Titikïr chik el
# This message is followed by a link using onboarding-join-form-signin ("Sign In") as text.
onboarding-join-form-signin-label = ¿La k'o chik jun rub'i' ataqoya'l?
# Text for link to submit the sign in form
onboarding-join-form-signin = Titikirisäx Molojri'ïl
onboarding-start-browsing-button-label = Tichap Okem Pa K'amaya'l
onboarding-cards-dismiss =
    .title = Tichup ruwäch
    .aria-label = Tichup ruwäch

## Multistage 3-screen onboarding flow strings (about:welcome pages)

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-welcome-header = Ütz apetik pa <span data-l10n-name = "zap"> { -brand-short-name } </span>
onboarding-multistage-welcome-subtitle = Ri aninäq, jikïl chuqa' ichinan okik'amaya'l temen ruma jun moloj majun ch'akoj rojqan.
onboarding-multistage-welcome-primary-button-label = Tichap Runuk'ulem
onboarding-multistage-welcome-secondary-button-label = Titikirisäx molojri'ïl
onboarding-multistage-welcome-secondary-button-text = ¿La k'o jun rub'i' ataqoya'l?
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "more" should stay inside the span.
onboarding-multistage-import-header = Ke'ajik'a' ewan taq atzij, <br/>taq yaketal, chuqa' <span data-l10n-name="zap">ch'aqa' chik</span>
onboarding-multistage-import-subtitle = ¿La atpetenäq pa jun chik okik'amaya'l? Man k'ayew ta nak'waj ronojel pa { -brand-short-name }.
onboarding-multistage-import-primary-button-label = Titikirisäx Jik'oj
onboarding-multistage-import-secondary-button-label = Wakami mani
# Info displayed in the footer of import settings screen during onboarding flow.
# This supports welcome screen showing top sites imported from the user's default browser.
onboarding-import-sites-disclaimer = Xe'ilitäj re taq ruxaq pa re okisab'äl re'. Ri { -brand-short-name } man yeruyäk ta ni xa ta yeruxïm taq kitzij juley taq okik'amaya'l, xa xe we nacha' chi ye'ajïk'.
# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = Nab'ey taq xak: ruwäch { $current } ri { $total }
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "look" should stay inside the span.
onboarding-multistage-theme-header = Tacha' jun <span data-l10n-name="zap">rub'anikil</span>
onboarding-multistage-theme-subtitle = Tawichinaj { -brand-short-name } rik'in jun wachinel.
onboarding-multistage-theme-primary-button-label = Tiyak Wachinel
onboarding-multistage-theme-secondary-button-label = Wakami mani
# Automatic theme uses operating system color settings
onboarding-multistage-theme-label-automatic = Yonil
# System refers to the operating system
onboarding-multistage-theme-description-automatic = Tokisäx ruwachinel q'inoj
onboarding-multistage-theme-label-light = Saqsöj
onboarding-multistage-theme-label-dark = Q'eqq'öj
# "Firefox Alpenglow" here is the name of the theme, and should be kept in English.
onboarding-multistage-theme-label-alpenglow = Firefox Alpenglow

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

# Tooltip displayed on hover of automatic theme
onboarding-multistage-theme-tooltip-automatic =
    .title =
        Tichinäx kan ri rutzub'al samajel
        aq'inoj pa taq pitz'b'äl, taq k'utsamaj chuqa' taq ruwi'.
    .aria-label = { onboarding-multistage-theme-tooltip-automatic.title }
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light =
    .title =
        Tokisäx jun saqsöj tzub'al pa taq pitz'b'äl,
        taq k'utsamaj chuqa' pa taq ruwi'.
    .aria-label = { onboarding-multistage-theme-tooltip-light.title }
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark =
    .title =
        Tokisäx jun q'equm tzub'al pa taq pitz'b'äl,
        taq k'utsamaj chuqa' pa taq ruwi'.
    .aria-label = { onboarding-multistage-theme-tooltip-dark.title }
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow =
    .title =
        Tokisäx jeb'ejöj tzub'al pa taq pitz'b'äl,
        taq k'utsamaj chuqa' pa taq ruwi'.
    .aria-label = { onboarding-multistage-theme-tooltip-alpenglow.title }
# Tooltip displayed on hover of automatic theme
onboarding-multistage-theme-tooltip-automatic-2 =
    .title =
        Tichinäx kan ri rutzub'al samajel
        aq'inoj pa taq pitz'b'äl, taq k'utsamaj chuqa' taq ruwi'.
# Input description for automatic theme
onboarding-multistage-theme-description-automatic-2 =
    .aria-description =
        Tichinäx kan ri rutzub'al samajel
        aq'inoj pa taq pitz'b'äl, taq k'utsamaj chuqa' taq ruwi'.
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light-2 =
    .title =
        Tokisäx jun saqsöj tzub'al pa taq pitz'b'äl,
        taq k'utsamaj chuqa' pa taq ruwi'.
# Input description for light theme
onboarding-multistage-theme-description-light =
    .aria-description =
        Tokisäx jun saqsöj tzub'al pa taq pitz'b'äl,
        taq k'utsamaj chuqa' pa taq ruwi'.
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark-2 =
    .title =
        Tokisäx jun q'equm tzub'al pa taq pitz'b'äl,
        taq k'utsamaj chuqa' pa taq ruwi'.
# Input description for dark theme
onboarding-multistage-theme-description-dark =
    .aria-description =
        Tokisäx jun q'equm tzub'al pa taq pitz'b'äl,
        taq k'utsamaj chuqa' pa taq ruwi'.
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow-2 =
    .title =
        Tokisäx jeb'ejöj tzub'al pa taq pitz'b'äl,
        taq k'utsamaj chuqa' pa taq ruwi'.
# Input description for Alpenglow theme
onboarding-multistage-theme-description-alpenglow =
    .aria-description =
        Tokisäx jeb'ejöj tzub'al pa taq pitz'b'äl,
        taq k'utsamaj chuqa' pa taq ruwi'.

## Welcome full page string

onboarding-fullpage-welcome-subheader = Tiqachapa' rutz'etik ronojel ri yatikïr nab'än.
onboarding-fullpage-form-email =
    .placeholder = Rochochib'al ataqoya'l…

## Firefox Sync modal dialog strings.

onboarding-sync-welcome-header = Tak'waj ri { -brand-product-name } Awik'in
onboarding-sync-welcome-content = Ke'ak'waj ri taq yaketal, natab'äl, ewan taq tzij chuqa' ch'aqa' chik taq nuk'ulem pa ronojel taq awokisaxel.
onboarding-sync-welcome-learn-more-link = Tawetamaj ch'aqa' chik pa ruwi' ri Firefox Taqoya'l
onboarding-sync-form-input =
    .placeholder = Taqoya'l
onboarding-sync-form-continue-button = Titikïr chik el
onboarding-sync-form-skip-login-button = Tixakalüx re jun ruxak re'

## This is part of the line "Enter your email to continue to Firefox Sync"

onboarding-sync-form-header = Tatz'ib'aj ataqoya'l
onboarding-sync-form-sub-header = richin yatok pa { -sync-brand-name }.

## These are individual benefit messages shown with an image, title and
## description.

onboarding-benefit-products-text = Kasamäj rik'in jun molaj samajib'äl, ri nukamelaj ri awichinanem pa ronojel awokisab'al.
# "Personal Data Promise" is a concept that should be translated consistently
# across the product. It refers to a concept shown elsewhere to the user: "The
# Firefox Personal Data Promise is the way we honor your data in everything we
# make and do. We take less data. We keep it safe. And we make sure that we are
# transparent about how we use it."
onboarding-benefit-privacy-text = Ronojel ri niqab'än, nukamelaj ri Rusujik Tzij chi rij Qatzij: Jub'a' etamab'äl nuk'äm. Nujikib'a'. Majun ewäl ta.
onboarding-benefit-sync-title = { -sync-brand-short-name }
onboarding-benefit-sync-text = Ke'ak'waj ri taq ayaketal, ewan taq atzij, natab'äl chuqa' ch'aqa' chik xab'akuchi' nawokisaj ri { -brand-product-name }.
onboarding-benefit-monitor-title = { -monitor-brand-short-name }
onboarding-benefit-monitor-text = Tak'ulu' rutzijol toq ri awetamab'al xtz'iläx rutzij.
onboarding-benefit-lockwise-title = { -lockwise-brand-short-name }
onboarding-benefit-lockwise-text = Ke'anuk'samajij ri ewan taq atzij, ri yechajïx chuqa' ek'axel.

## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

onboarding-tracking-protection-title2 = Chajinïk Chuwäch Ojqanem
onboarding-tracking-protection-text2 = { -brand-short-name } yatruto' richin yeruq'ät ri taq ajk'amaya'l ruxaq yatqojqaj pa k'amab'ey, ruma ri' toq k'ayew xtub'än chuwäch ri eltzijol richin yatorojqaj toq yatok pa k'amaya'l.
onboarding-tracking-protection-button2 = Achike Rub'eyal Nisamäj
onboarding-data-sync-title = Tak'waj Awik'in ri taq Anuk'ulem
# "Sync" is short for synchronize.
onboarding-data-sync-text2 = Ke'axima' ri taq ayaketal, ewan taq atzij chuqa' ch'aqa' chik xab'akuchi' nawokisaj ri { -brand-product-name }.
onboarding-data-sync-button2 = Titikirisäx molojri'ïl pa { -sync-brand-short-name }
onboarding-firefox-monitor-title = Ke'atz'eta' ri Kitzijol Kitz'ilanik Tzij
onboarding-firefox-monitor-text2 = { -monitor-brand-name } tanik'oj we ri rub'i' ataqoya'l k'o pa jun kitz'ilanik tzij etaman ruwäch chuqa' nuya' rutzijol we k'o pa jun k'ak'a' tz'ilanem.
onboarding-firefox-monitor-button = Tatz'ib'aj ab'i' richin ye'akül taq Rutzijol K'ayewal
onboarding-browse-privately-title = Richinanem Okik'amaya'l
onboarding-browse-privately-text = Ri Ichinan Okik'amaya'l nuyüj ri taq kanoxïk chuqa' ri runatab'al okem pa k'amaya'l richin chi ewäl chuwäch xab'achike winäq nrokisaj ri kematz'ib'.
onboarding-browse-privately-button = Tijaq jun Ichinan Tzuwäch
onboarding-firefox-send-title = Ke'awichinaj ri Komoni taq Ayakb'al
onboarding-firefox-send-text2 = Ke'ajotob'a' ri taq ayakb'al pa { -send-brand-name } richin ye'akomonij ronojel rik'in  ewan rusik'ixik chuqa' rik'in jun ximonel nik'is ruq'ijul.
onboarding-firefox-send-button = Titojtob'ëx { -send-brand-name }
onboarding-mobile-phone-title = Tik'ul { -brand-product-name } pan Awoyonib'al
onboarding-mobile-phone-text = Taqasaj { -brand-product-name } richin iOS o Android richin ye'axïm ri taq atzij pa ronojel taq awokisab'al.
# "Mobile" is short for mobile/cellular phone, "Browser" is short for web
# browser.
onboarding-mobile-phone-button = Taqasaj Oyonib'äl Okik'amaya'l
onboarding-send-tabs-title = Ke'ataqa' Anin taq Ruwi'
# "Send Tabs" refers to "Send Tab to Device" feature that appears when opening a
# tab's context menu.
onboarding-send-tabs-text2 = Anin ke'akomonij taq ruxaq pa taq awokisab'al, akuchi' man nawachib'ej ta taq ximonel o natz'apij ri okik'amaya'l.
onboarding-send-tabs-button = Tachapa' Rokisaxik Send Tabs
onboarding-pocket-anywhere-title = Tisik'is chuqa' Tak'axäx Xab'akuchi'
onboarding-pocket-anywhere-text2 = Tayaka' ri ajowab'äl rupam akuchi' majun okem pa k'amaya'l ruma ri { -pocket-brand-name } App chuqa' tasik'ij, tawak'axaj o tatz'eta' xab'akuchi' o toq nawajo'.
onboarding-pocket-anywhere-button = Titojtob'ëx { -pocket-brand-name }
onboarding-lockwise-strong-passwords-title = Titz'uk chuqa' Keyak Ütz taq Ewan Tzij
onboarding-lockwise-strong-passwords-text = { -lockwise-brand-name } yerutz'ük ütz ewan taq tzij pa ri b'anoj chuqa' yeruyäk pa jun k'ojlib'äl.
onboarding-lockwise-strong-passwords-button = Ke'anuk'samajij ri Rutikirib'al taq Amolojri'ïl
onboarding-facebook-container-title = Ke'anuk'samajij K'ulb'a't rik'in Facebook
onboarding-facebook-container-text2 = { -facebook-container-brand-name } nujäch ri rub'anikil awäch chi kiwäch ri ch'aqa' chik, akuchi' k'ayew nub'än chuwäch ri Facebook richin nuk'üt eltzijol chawäch.
onboarding-facebook-container-button = Titz'aqatisäx ri K'amal
onboarding-import-browser-settings-title = Ke'ajik'a' ri taq Ayaketal, Ewan taq Atzij Chuqa' Ch'aqa' chik
onboarding-import-browser-settings-text = Tanima' awi'—anin ke'ak'waj awik'in ri taq ruxaq chuqa' taq anuk'ulem richin Chrome.
onboarding-import-browser-settings-button = Ke'ajik'a' Taq Atzij Richin Chrome
onboarding-personal-data-promise-title = Ichinan ruma Wachib'enïk
onboarding-personal-data-promise-text = { -brand-product-name } yerukamelaj ri taq atzij rik'in jub'a' ok numöl, yeruchajij chuqa' nub'ij achike rub'eyal ye'okisäx.
onboarding-personal-data-promise-button = Tasik'ij ri Ruya'ik Qatzij

## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = Ütz ütz, awichinan { -brand-short-name }
# <icon></icon> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-header = Wakami niqatäq chawe <icon></icon><b>{ $addon-name }.</b>
return-to-amo-extension-button = Titz'aqatisäx ri K'amal
return-to-amo-get-started-button = Titikirisäx rik'in { -brand-short-name }
