# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-learn-more = Alamin
onboarding-button-label-get-started = Magsimula

## Welcome modal dialog strings

onboarding-welcome-header = Maligayang pagdating sa { -brand-short-name }
onboarding-welcome-body = Nakuha mo na ang browser.<br/>Kilalanin ang iba pang miyembro ng { -brand-product-name }.
onboarding-welcome-learn-more = Alamin ang mga benepisyo.
onboarding-welcome-modal-get-body = Nakuha mo na ang browser.<br/>Ngayon, sulitin mo naman ang { -brand-product-name }.
onboarding-welcome-modal-supercharge-body = Itodo natin ang proteksyon mo sa privacy.
onboarding-welcome-modal-privacy-body = Nakuha mo na ang browser. Dagdagan naman natin ngayon ang iyong privacy protection.
onboarding-welcome-modal-family-learn-more = Alamin ang tungkol sa mga produktong saklaw ng { -brand-product-name }.
onboarding-welcome-form-header = Magsimula Rito
onboarding-join-form-body = Ipasok ang iyong email address para magsimula.
onboarding-join-form-email =
    .placeholder = Ipasok ang email
onboarding-join-form-email-error = Kailangan ng maayos na email
onboarding-join-form-legal = Kapag nagpatuloy, ikaw ay sumasang-ayon sa <a data-l10n-name="terms">Terms of Service</a> at <a data-l10n-name="privacy">Privacy Notice</a>.
onboarding-join-form-continue = Magpatuloy
# This message is followed by a link using onboarding-join-form-signin ("Sign In") as text.
onboarding-join-form-signin-label = Mayroon nang account?
# Text for link to submit the sign in form
onboarding-join-form-signin = Mag-sign In
onboarding-start-browsing-button-label = Magsimulang Mag-browse
onboarding-cards-dismiss =
    .title = Paalisin
    .aria-label = Paalisin

## Multistage 3-screen onboarding flow strings (about:welcome pages)

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-welcome-header = Maligayang pagdating sa <span data-l10n-name="zap">{ -brand-short-name }</span>
onboarding-multistage-welcome-subtitle = Ang mabilis, ligtas, at pribadong browser na suportado ng isang non-profit.
onboarding-multistage-welcome-primary-button-label = Simulan ang Setup
onboarding-multistage-welcome-secondary-button-label = Mag-sign in
onboarding-multistage-welcome-secondary-button-text = May account na?
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "more" should stay inside the span.
onboarding-multistage-import-header = Mag-import ng iyong mga password, <br/>bookmark, at <span data-l10n-name="zap">marami pang iba</span>
onboarding-multistage-import-subtitle = Nanggaling sa ibang browser? Madaling dalhin lahat papuntang { -brand-short-name }.
onboarding-multistage-import-primary-button-label = Simulan ang Import
onboarding-multistage-import-secondary-button-label = Hindi sa ngayon
# Info displayed in the footer of import settings screen during onboarding flow.
# This supports welcome screen showing top sites imported from the user's default browser.
onboarding-import-sites-disclaimer = Ang mga site na nakalista rito ay natagpuan sa device na ito. Hindi nagse-save o nagsi-sync ng data ang { -brand-short-name } mula sa ibang browser maliban na lang kung pinili mong i-import ito.
# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = Pagsisimula: screen { $current } ng { $total }
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "look" should stay inside the span.
onboarding-multistage-theme-header = Pumili ng <span data-l10n-name="zap">itsura</span>
onboarding-multistage-theme-subtitle = Ipasadya mo ang { -brand-short-name } gamit ang isang tema.
onboarding-multistage-theme-primary-button-label = I-save ang Tema
onboarding-multistage-theme-secondary-button-label = Hindi sa ngayon
# Automatic theme uses operating system color settings
onboarding-multistage-theme-label-automatic = Kusa
# System refers to the operating system
onboarding-multistage-theme-description-automatic = Gamitin ang tema ng sistema
onboarding-multistage-theme-label-light = Maliwanag
onboarding-multistage-theme-label-dark = Madilim
# "Firefox Alpenglow" here is the name of the theme, and should be kept in English.
onboarding-multistage-theme-label-alpenglow = Firefox Alpenglow

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

# Tooltip displayed on hover of automatic theme
onboarding-multistage-theme-tooltip-automatic =
    .title =
        Gayahin ang itsura ng iyong operating
        system para sa mga button, menu, at mga window.
    .aria-label = { onboarding-multistage-theme-tooltip-automatic.title }
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light =
    .title =
        Gumamit ng maliwanag na itsura para sa mga button,
        menu, at mga window.
    .aria-label = { onboarding-multistage-theme-tooltip-light.title }
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark =
    .title =
        Gumamit ng madilim na itsura para sa mga button,
        menu, at mga window.
    .aria-label = { onboarding-multistage-theme-tooltip-dark.title }
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow =
    .title =
        Gumamit ng makulay na itsura para sa mga button,
        menu, at mga window.
    .aria-label = { onboarding-multistage-theme-tooltip-alpenglow.title }
# Tooltip displayed on hover of automatic theme
onboarding-multistage-theme-tooltip-automatic-2 =
    .title =
        Gayahin ang itsura ng iyong operating
        system para sa mga button, menu, at mga window.
# Input description for automatic theme
onboarding-multistage-theme-description-automatic-2 =
    .aria-description =
        Gayahin ang itsura ng iyong operating
        system para sa mga button, menu, at mga window.
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light-2 =
    .title =
        Gumamit ng maliwanag na itsura para sa mga button,
        menu, at mga window.
# Input description for light theme
onboarding-multistage-theme-description-light =
    .aria-description =
        Gumamit ng maliwanag na itsura para sa mga button,
        menu, at mga window.
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark-2 =
    .title =
        Gumamit ng madilim na itsura para sa mga button,
        menu, at mga window.
# Input description for dark theme
onboarding-multistage-theme-description-dark =
    .aria-description =
        Gumamit ng madilim na itsura para sa mga button,
        menu, at mga window.
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow-2 =
    .title =
        Gumamit ng makulay na itsura para sa mga button,
        menu, at mga window.
# Input description for Alpenglow theme
onboarding-multistage-theme-description-alpenglow =
    .aria-description =
        Gumamit ng makulay na itsura para sa mga button,
        menu, at mga window.

## Welcome full page string

onboarding-fullpage-welcome-subheader = Simulan natin alamin ang lahat ng magagawa mo
onboarding-fullpage-form-email =
    .placeholder = Ang iyong email address...

## Firefox Sync modal dialog strings.

onboarding-sync-welcome-header = Isama ang { -brand-product-name } saan man
onboarding-sync-welcome-content = Kunin ang mga bookmark, kasaysayan, mga password at iba pang mga setting sa lahat ng iyong mga device.
onboarding-sync-welcome-learn-more-link = Alamin ang tungkol sa Firefox Accounts
onboarding-sync-form-input =
    .placeholder = Email
onboarding-sync-form-continue-button = Magpatuloy
onboarding-sync-form-skip-login-button = Laktawan ang hakbang na ito

## This is part of the line "Enter your email to continue to Firefox Sync"

onboarding-sync-form-header = Ilagay ang iyong email
onboarding-sync-form-sub-header = para magpatuloy sa { -sync-brand-name }

## These are individual benefit messages shown with an image, title and
## description.

onboarding-benefit-products-text = Tapusin ang mga bagay-bagay sa pamamagitan ng mga gamit na gumagalang sa iyong privacy sa lahat ng iyong mga device.
# "Personal Data Promise" is a concept that should be translated consistently
# across the product. It refers to a concept shown elsewhere to the user: "The
# Firefox Personal Data Promise is the way we honor your data in everything we
# make and do. We take less data. We keep it safe. And we make sure that we are
# transparent about how we use it."
onboarding-benefit-privacy-text = Lahat ng aming ginagawa ay umaayon sa aming Pangako sa Personal na Data: Kaunti lang ang kunin. Pangalagaan ito. Walang mga sikreto.
onboarding-benefit-sync-title = { -sync-brand-short-name }
onboarding-benefit-sync-text = Dalhin mo kahit saan ang iyong mga bookmark, password, kasaysayan at marami pa gamit ang { -brand-product-name }.
onboarding-benefit-monitor-title = { -monitor-brand-short-name }
onboarding-benefit-monitor-text = Abisuhan ka kapag natagpuan ang iyong personal na impormasyon sa isang data breach.
onboarding-benefit-lockwise-title = { -lockwise-brand-short-name }
onboarding-benefit-lockwise-text = I-manage ang mga password na protektado at portable.

## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

onboarding-tracking-protection-title2 = Proteksyon mula sa Tracking
onboarding-tracking-protection-text2 = Nakatutulong ang { -brand-short-name } para pigilan ang mga website sa pag-track sa iyo online, at ginagawa nitong mas mahirap para sa mga ad na sundan ka kahit saan magpunta sa web.
onboarding-tracking-protection-button2 = Paano Gumagana
onboarding-data-sync-title = Dalhin Mo ang Iyong mga Setting
# "Sync" is short for synchronize.
onboarding-data-sync-text2 = I-sync ang iyong mga bookmark, password, atbp. sa mga lugar na gagamitan mo ng { -brand-product-name }.
onboarding-data-sync-button2 = Mag-sign-in sa { -sync-brand-short-name }
onboarding-firefox-monitor-title = Manatiling Alerto sa mga Data Breach
onboarding-firefox-monitor-text2 = { -monitor-brand-name } monitors if your email has appeared in a known data breach and alerts you if it appears in a new breach.
onboarding-firefox-monitor-button = Mag-sign up para sa mga Alert
onboarding-browse-privately-title = Mag-browse nang Pribado
onboarding-browse-privately-text = Inaalis ng Private Browsing ang bakas ng mga hinanap mo para hindi malaman ng ibang mga gumagamit ng iyong computer.
onboarding-browse-privately-button = Magbukas ng Private Window
onboarding-firefox-send-title = Panatilihing pribado ang iyong mga Shared File
onboarding-firefox-send-text2 = I-upload mo ang iyong mga file sa { -send-brand-name } para maipamahagi mo ito nang may end-to-end encryption at link na kusang mag-eexpire.
onboarding-firefox-send-button = Subukan ang { -send-brand-name }
onboarding-mobile-phone-title = Kunin ang { -brand-product-name } para sa Iyong Telepono
onboarding-mobile-phone-text = Mag-download ng { -brand-product-name } para sa iOS o Android at i-sync ang iyong data sa iba't-ibang mga device.
# "Mobile" is short for mobile/cellular phone, "Browser" is short for web
# browser.
onboarding-mobile-phone-button = Mag-download ng Mobile Browser
onboarding-send-tabs-title = Agarang Magpadala ng mga Tab sa Iyong Sarili
# "Send Tabs" refers to "Send Tab to Device" feature that appears when opening a
# tab's context menu.
onboarding-send-tabs-text2 = I-share ang pages sa mga device mo na hindi mo na kailangan kopyahin ang mga link, o umalis sa browser.
onboarding-send-tabs-button = Simulang gamitin ang Send Tabs
onboarding-pocket-anywhere-title = Basahin at Pakinggan Kahit Saan
onboarding-pocket-anywhere-text2 = I-save ang iyong mga paboritong content offline gamit ang { -pocket-brand-name } App at basahin, pakinggan, at panoorin kung kailan mo ito naiisin.
onboarding-pocket-anywhere-button = Subukan ang { -pocket-brand-name }
onboarding-lockwise-strong-passwords-title = Gumawa at Itago ang mga Strong Password
onboarding-lockwise-strong-passwords-text = Ang { -lockwise-brand-name } ay gumagawa ng mga strong password kaagad at itatago ang mga ito sa isang lugar.
onboarding-lockwise-strong-passwords-button = I-manage ang iyong mga Login
onboarding-facebook-container-title = Bigyang-hangganan ang Facebook
onboarding-facebook-container-text2 = Ihinihiwalay ng { -facebook-container-brand-name } ang iyong profile mula sa iba pang mga bagay, at ginagawang mas mahirap para sa Facebook na i-target ka ng mga ad.
onboarding-facebook-container-button = Idagdag ang Extension
onboarding-import-browser-settings-title = I-import ang iyong mga Bookmark, Password, at iba pa
onboarding-import-browser-settings-text = Sumabak agad — madali mong dalhin kasama mo ang iyong mga site at setting sa Chrome.
onboarding-import-browser-settings-button = i-Import ang Chrome Data
onboarding-personal-data-promise-title = Pribado sa pamamagitan ng Disenyo
onboarding-personal-data-promise-text = Binibigyang-respeto ng { -brand-product-name } ang iyong data sa pamamagitan ng pagkuha lang ng talagang kailangan, pagprotekta rito, at sa pagiging malinaw kung paano namin ito gagamitin.
onboarding-personal-data-promise-button = Basahin ang aming Pangako

## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = Mahusay, ngayon ay mayroon ka nang { -brand-short-name }
# <icon></icon> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-header = Ngayon kunin natin ang <icon></icon><b>{ $addon-name }</b>.
return-to-amo-extension-button = Idagdag ang Extension
return-to-amo-get-started-button = Simulan ang { -brand-short-name }
