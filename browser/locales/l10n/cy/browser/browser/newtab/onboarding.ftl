# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-learn-more = Dysgu Rhagor
onboarding-button-label-get-started = Cychwyn Arni

## Welcome modal dialog strings

onboarding-welcome-header = Croeso i { -brand-short-name }
onboarding-welcome-body = Mae'r porwr gyda chi. <br/> Dyma weddill { -brand-product-name }.
onboarding-welcome-learn-more = Dysgu rhagor am y buddiannau.
onboarding-welcome-modal-get-body = Mae'r porwr gennych. <br/>Nawr, manteisiwch i'r eithaf ar { -brand-product-name }.
onboarding-welcome-modal-supercharge-body = Cryfhewch eich diogelwch preifatrwydd.
onboarding-welcome-modal-privacy-body = Mae'r porwr gennych chi. Gadewch i ni ychwanegu mwy o ddiogelwch preifatrwydd.
onboarding-welcome-modal-family-learn-more = Dysgu am deulu cynnyrch { -brand-product-name }.
onboarding-welcome-form-header = Cychwynnwch Yma
onboarding-join-form-body = Rhowch eich cyfeiriad e-bost i ddechrau.
onboarding-join-form-email =
    .placeholder = Rhowch e-bost
onboarding-join-form-email-error = Mae angen e-bost dilys
onboarding-join-form-legal = Drwy barhau, rydych yn cytuno i'r <a data-l10n-name="terms">>Amodau Gwasanaeth</a> a'r <a data-l10n-name="privacy">Hysbysiad Preifatrwydd</a>.
onboarding-join-form-continue = Parhau
# This message is followed by a link using onboarding-join-form-signin ("Sign In") as text.
onboarding-join-form-signin-label = A oes gennych chi gyfrif yn barod?
# Text for link to submit the sign in form
onboarding-join-form-signin = Mewngofnodi
onboarding-start-browsing-button-label = Cychwyn Pori
onboarding-cards-dismiss =
    .title = Cau
    .aria-label = Cau

## Multistage 3-screen onboarding flow strings (about:welcome pages)

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-welcome-header = Croeso i <span data-l10n-name="zap">{ -brand-short-name }</span>
onboarding-multistage-welcome-subtitle = Y porwr cyflym, diogel a phreifat sydd â chefnogaeth corff dim-er-elw.
onboarding-multistage-welcome-primary-button-label = Cychwyn Gosod
onboarding-multistage-welcome-secondary-button-label = Mewngofnodi
onboarding-multistage-welcome-secondary-button-text = Oes gennych chi gyfrif?
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "more" should stay inside the span.
onboarding-multistage-import-header = Mewnforiwch eich cyfrineiriau, nodau tudalen, a <span data-l10n-name="zap">mwy</span>
onboarding-multistage-import-subtitle = Yn dod o borwr arall? Mae'n hawdd dod â phopeth gyda chi  i { -brand-short-name }.
onboarding-multistage-import-primary-button-label = Cychwyn Mewnforio
onboarding-multistage-import-secondary-button-label = Nid nawr
# Info displayed in the footer of import settings screen during onboarding flow.
# This supports welcome screen showing top sites imported from the user's default browser.
onboarding-import-sites-disclaimer = Cafwyd hyd i'r gwefannau hyn ar y ddyfais hon. Nid yw { -brand-short-name } yn cadw nac yn cydweddu data o borwr arall oni bai eich bod yn dewis ei fewnforio.
# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = Cychwyn arni: sgrin { $current } o { $total }
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "look" should stay inside the span.
onboarding-multistage-theme-header = Dewiswch <span data-l10n-name = "zap">olwg</span>
onboarding-multistage-theme-subtitle = Personoli { -brand-short-name } gyda thema.
onboarding-multistage-theme-primary-button-label = Cadw Thema
onboarding-multistage-theme-secondary-button-label = Nid nawr
# Automatic theme uses operating system color settings
onboarding-multistage-theme-label-automatic = Awtomatig
# System refers to the operating system
onboarding-multistage-theme-description-automatic = Defnyddio thema'r system
onboarding-multistage-theme-label-light = Golau
onboarding-multistage-theme-label-dark = Tywyll
# "Firefox Alpenglow" here is the name of the theme, and should be kept in English.
onboarding-multistage-theme-label-alpenglow = Firefox Alpenglow

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

# Tooltip displayed on hover of automatic theme
onboarding-multistage-theme-tooltip-automatic =
    .title =
        Dilyn gwedd eich system weithredu
        ar gyfer botymau, dewislenni a ffenestri.
    .aria-label = { onboarding-multistage-theme-tooltip-automatic.title }
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light =
    .title =
        Defnyddio gwedd olau ar gyfer botymau,
        dewislenni, a ffenestri.
    .aria-label = { onboarding-multistage-theme-tooltip-light.title }
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark =
    .title =
        Defnyddio gwedd dywyll ar gyfer botymau,
        dewislenni, a ffenestri.
    .aria-label = { onboarding-multistage-theme-tooltip-dark.title }
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow =
    .title =
        Defnyddio gwedd liwgar ar gyfer botymau,
        dewislenni, a ffenestri.
    .aria-label = { onboarding-multistage-theme-tooltip-alpenglow.title }
# Tooltip displayed on hover of automatic theme
onboarding-multistage-theme-tooltip-automatic-2 =
    .title =
        Dilyn gwedd eich system weithredu
        ar gyfer botymau, dewislenni a ffenestri.
# Input description for automatic theme
onboarding-multistage-theme-description-automatic-2 =
    .aria-description =
        Dilyn gwedd eich system weithredu
        ar gyfer botymau, dewislenni a ffenestri.
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light-2 =
    .title =
        Defnyddio gwedd olau ar gyfer botymau,
        dewislenni, a ffenestri.
# Input description for light theme
onboarding-multistage-theme-description-light =
    .aria-description =
        Defnyddio gwedd olau ar gyfer botymau,
        dewislenni, a ffenestri.
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark-2 =
    .title =
        Defnyddio gwedd dywyll ar gyfer botymau,
        dewislenni, a ffenestri.
# Input description for dark theme
onboarding-multistage-theme-description-dark =
    .aria-description =
        Defnyddio gwedd dywyll ar gyfer botymau,
        dewislenni, a ffenestri.
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow-2 =
    .title =
        Defnyddio gwedd liwgar ar gyfer botymau,
        dewislenni, a ffenestri.
# Input description for Alpenglow theme
onboarding-multistage-theme-description-alpenglow =
    .aria-description =
        Defnyddio gwedd liwgar ar gyfer botymau,
        dewislenni, a ffenestri.

## Welcome full page string

onboarding-fullpage-welcome-subheader = Gadewch i ni ddechrau edrych ar bopeth y gallwch ei wneud.
onboarding-fullpage-form-email =
    .placeholder = Eich cyfeiriad e-bost…

## Firefox Sync modal dialog strings.

onboarding-sync-welcome-header = Mynd â { -brand-product-name } gyda Chi
onboarding-sync-welcome-content = Cael eich nodau tudalen, hanes, cyfrineiriau a gosodiadau eraill ar eich holl ddyfeisiau.
onboarding-sync-welcome-learn-more-link = Dysgu rhagor am Gyfrif Firefox
onboarding-sync-form-input =
    .placeholder = E-bost
onboarding-sync-form-continue-button = Parhau
onboarding-sync-form-skip-login-button = Hepgor y cam hwn

## This is part of the line "Enter your email to continue to Firefox Sync"

onboarding-sync-form-header = Rhowch eich e-bost
onboarding-sync-form-sub-header = ac ymlaen i { -sync-brand-name }

## These are individual benefit messages shown with an image, title and
## description.

onboarding-benefit-products-text = Gwnewch bethau gyda chasgliad o offer sy'n parchu eich preifatrwydd ar draws eich dyfeisiau.
# "Personal Data Promise" is a concept that should be translated consistently
# across the product. It refers to a concept shown elsewhere to the user: "The
# Firefox Personal Data Promise is the way we honor your data in everything we
# make and do. We take less data. We keep it safe. And we make sure that we are
# transparent about how we use it."
onboarding-benefit-privacy-text = Mae popeth rydym yn ei wneud yn cadw at ein Addewid ar Ddata Personol: Cymrwch lai. Cadwch ef yn ddiogel. Dim cyfrinachau.
onboarding-benefit-sync-title = { -sync-brand-short-name }
onboarding-benefit-sync-text = Cymerwch eich nodau tudalen, cyfrineiriau, hanes, a mwy ym mhobman rydych chi'n defnyddio { -brand-product-name }.
onboarding-benefit-monitor-title = { -monitor-brand-short-name }
onboarding-benefit-monitor-text = Cewch eich hysbysu pan fydd eich manylion personol mewn tor-data hysbys.
onboarding-benefit-lockwise-title = { -lockwise-brand-short-name }
onboarding-benefit-lockwise-text = Rheoli cyfrineiriau sy'n ddiogel ac yn gludadwy.

## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

onboarding-tracking-protection-title2 = Diogelu Rhag Tracio
onboarding-tracking-protection-text2 = Mae { -brand-short-name } yn helpu i atal gwefannau rhag eich tracio ar-lein, gan ei gwneud yn anos i hysbysebion eich dilyn o gwmpas y we.
onboarding-tracking-protection-button2 = Sut mae'n Gweithio
onboarding-data-sync-title = Mynd â'ch Gosodiadau gyda Chi
# "Sync" is short for synchronize.
onboarding-data-sync-text2 = Cydweddwch eich nodau tudalen, cyfrineiriau, a mwy ym mhob man y byddwch yn defnyddio { -brand-product-name }.
onboarding-data-sync-button2 = Mewngofnodwch i { -sync-brand-short-name }
onboarding-firefox-monitor-title = Cadw'n effro i achosion o dor-data
onboarding-firefox-monitor-text2 = Mae { -monitor-brand-name } yn monitro os yw eich e-bost wedi ymddangos mewn tor-data ac yn eich rhybuddio os yw'n ymddangos mewn tor-data newydd.
onboarding-firefox-monitor-button = Cofrestru am Rhybuddion
onboarding-browse-privately-title = Pori'n Breifat
onboarding-browse-privately-text = Mae Pori Preifat yn clirio'ch hanes chwilio a phori er mwyn ei gadw'n gyfrinachol rhag unrhyw un sy'n defnyddio'ch cyfrifiadur.
onboarding-browse-privately-button = Agor Ffenestr Breifat
onboarding-firefox-send-title = Cadw eich Ffeiliau a Rennir yn breifat
onboarding-firefox-send-text2 = Llwythwch eich ffeiliau i fyny i { -send-brand-name } i'w rhannu gydag amgryptio o'r dechrau i'r diwedd a dolen sy'n dod i ben yn awtomatig.
onboarding-firefox-send-button = Rhoi cynnig ar { -send-brand-name }
onboarding-mobile-phone-title = Rhoi { -brand-product-name } ar Eich Ffôn
onboarding-mobile-phone-text = Llwythwch { -brand-product-name } i lawr ar gyfer iOS neu Android a chydweddu eich data ar draws dyfeisiau.
# "Mobile" is short for mobile/cellular phone, "Browser" is short for web
# browser.
onboarding-mobile-phone-button = Llwytho Porwr Symudol i lawr
onboarding-send-tabs-title = Anfon Tabiau Atoch Chi eich Hun
# "Send Tabs" refers to "Send Tab to Device" feature that appears when opening a
# tab's context menu.
onboarding-send-tabs-text2 = Rhannu tudalennau'n hawdd rhwng eich dyfeisiau heb orfod copïo dolenni na gadael y porwr.
onboarding-send-tabs-button = Cychwyn Defnyddio Anfon Tabiau
onboarding-pocket-anywhere-title = Darllen a Gwrando yn Unrhyw Le
onboarding-pocket-anywhere-text2 = Cadwch eich hoff gynnwys all-lein gyda'r Ap { -pocket-brand-name } a darllenwch, gwrandewch, a gwyliwch pryd bynnag y mae'n gyfleus i chi.
onboarding-pocket-anywhere-button = Rhoi cynnig ar { -pocket-brand-name }
onboarding-lockwise-strong-passwords-title = Creu a Chadw Cyfrineiriau Cryf
onboarding-lockwise-strong-passwords-text = Mae { -lockwise-brand-name } yn creu cyfrineiriau cryf yn y fan a'r lle ac yn cadw pob un ohonyn nhw mewn un man.
onboarding-lockwise-strong-passwords-button = Rheoli'ch Mewngofnodi
onboarding-facebook-container-title = Gosod Ffiniau i Facebook
onboarding-facebook-container-text2 = Mae { -facebook-container-brand-name } yn cadw eich proffil ar wahân i bopeth arall, gan ei gwneud yn anos i Facebook eich targedu chi gyda hysbysebion.
onboarding-facebook-container-button = Ychwanegu'r Estyniad
onboarding-import-browser-settings-title = Mewnforio Eich Nodau Tudalen, Cyfrineiriau, a Mwy
onboarding-import-browser-settings-text = Symud yn sydyn - mae'n hawdd dod â'ch gwefannau a'ch gosodiadau Chrome gyda chi.
onboarding-import-browser-settings-button = Mewnforio Data Chrome
onboarding-personal-data-promise-title = Preifat o Fwriad
onboarding-personal-data-promise-text = Mae { -brand-product-name } yn trin eich data â pharch trwy gymryd llai ohono, ei ddiogelu a bod yn glir ynglŷn â sut rydyn ni'n ei ddefnyddio.
onboarding-personal-data-promise-button = Darllenwch ein Addewid

## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = Gwych, mae gennych { -brand-short-name }
# <icon></icon> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-header = Nawr gadewch i ni gael <icon> </icon> <b> { $addon-name } </ B> i chi.
return-to-amo-extension-button = Ychwanegu'r Estyniad
return-to-amo-get-started-button = Cychwyn gyda { -brand-short-name }
