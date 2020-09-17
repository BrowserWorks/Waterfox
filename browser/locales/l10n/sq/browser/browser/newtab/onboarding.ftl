# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-learn-more = Mësoni Më Tepër
onboarding-button-label-get-started = Fillojani

## Welcome modal dialog strings

onboarding-welcome-header = Mirë se vini te { -brand-short-name }
onboarding-welcome-body = E morët shfletuesin.<br/>Njihuni me pjesën tjetër të { -brand-product-name }.
onboarding-welcome-learn-more = Mësoni më tepër mbi përfitimet.
onboarding-welcome-modal-get-body = E keni shfletuesin.<br/>Tani përfitoni maksimumin prej { -brand-product-name }.
onboarding-welcome-modal-supercharge-body = Superngarkoni mbrojtjen e privatësisë tuaj.
onboarding-welcome-modal-privacy-body = E keni shfletuesin. Le të shtojmë më tepër mbrojtje privatësie.
onboarding-welcome-modal-family-learn-more = Mësoni rreth produkteve të familjes { -brand-product-name }.
onboarding-welcome-form-header = Fillojani Këtu
onboarding-join-form-body = Që t’ia filloni, jepni adresën tuaj email.
onboarding-join-form-email =
    .placeholder = Jepni email
onboarding-join-form-email-error = Lypset email i vlefshëm
onboarding-join-form-legal = Duke vazhduar, pajtoheni me <a data-l10n-name="terms">Kushte Shërbimi</a> dhe <a data-l10n-name="privacy">Shënim Privatësie</a>.
onboarding-join-form-continue = Vazhdo
# This message is followed by a link using onboarding-join-form-signin ("Sign In") as text.
onboarding-join-form-signin-label = Keni tashmë një llogari?
# Text for link to submit the sign in form
onboarding-join-form-signin = Hyni
onboarding-start-browsing-button-label = Filloni të Shfletoni
onboarding-cards-dismiss =
    .title = Hidhe tej
    .aria-label = Hidhe tej

## Multistage 3-screen onboarding flow strings (about:welcome pages)

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-welcome-header = Mirë se vini te <span data-l10n-name="zap">{ -brand-short-name }</span>
onboarding-multistage-welcome-subtitle = Shfletuesi i shpejtë, i parrezik dhe privat, që ka pas një ent jofitimprurës.
onboarding-multistage-welcome-primary-button-label = Filloni Ujdisjen
onboarding-multistage-welcome-secondary-button-label = Hyni
onboarding-multistage-welcome-secondary-button-text = Keni llogari?
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "more" should stay inside the span.
onboarding-multistage-import-header = Importoni fjalëkalimet tuaj, <br/>faqerojtësit, <span data-l10n-name="zap">etj</span>
onboarding-multistage-import-subtitle = Po vini prej një shfletuesi tjetër? Është e lehtë të sillet gjithçka te { -brand-short-name }.
onboarding-multistage-import-primary-button-label = Filloni Importimin
onboarding-multistage-import-secondary-button-label = Jo tani
# Info displayed in the footer of import settings screen during onboarding flow.
# This supports welcome screen showing top sites imported from the user's default browser.
onboarding-import-sites-disclaimer = Në këtë pajisje u gjetën sajtet e radhitur këtu. { -brand-short-name } nuk ruan apo njëkohëson të dhëna nga shfletues tjetër, veç në zgjedhëshi t’i importoni.
# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = Si t’ia fillohet: skena { $current } nga { $total }
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "look" should stay inside the span.
onboarding-multistage-theme-header = Zgjidhni një <span data-l10n-name="zap">pamje</span>
onboarding-multistage-theme-subtitle = Personalizojeni { -brand-short-name }-in me një temë.
onboarding-multistage-theme-primary-button-label = Ruaje Temën
onboarding-multistage-theme-secondary-button-label = Jo tani
# Automatic theme uses operating system color settings
onboarding-multistage-theme-label-automatic = Vetvetiu
# System refers to the operating system
onboarding-multistage-theme-description-automatic = Përdor temë sistemi
onboarding-multistage-theme-label-light = E çelët
onboarding-multistage-theme-label-dark = E errët
# "Firefox Alpenglow" here is the name of the theme, and should be kept in English.
onboarding-multistage-theme-label-alpenglow = Firefox Alpenglow

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

# Tooltip displayed on hover of automatic theme
onboarding-multistage-theme-tooltip-automatic =
    .title = Përdorni të njëjtën pamje me sistemin operativ për butona, menu dhe dritare.
    .aria-label = { onboarding-multistage-theme-tooltip-automatic.title }
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light =
    .title = Përdorni një pamje të çelët për butona, menu dhe dritare.
    .aria-label = { onboarding-multistage-theme-tooltip-light.title }
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark =
    .title =
        Përdorni një pamje të errët për butona, menu dhe dritare.
        menus, and windows.
    .aria-label = { onboarding-multistage-theme-tooltip-dark.title }
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow =
    .title = Përdorni një pamje plot ngjyra për butona, menu dhe dritare.
    .aria-label = { onboarding-multistage-theme-tooltip-alpenglow.title }
# Tooltip displayed on hover of automatic theme
onboarding-multistage-theme-tooltip-automatic-2 =
    .title = Përdorni të njëjtën pamje me sistemin operativ për butona, menu dhe dritare.
# Input description for automatic theme
onboarding-multistage-theme-description-automatic-2 =
    .aria-description = Përdorni të njëjtën pamje me sistemin operativ për butona, menu dhe dritare.
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light-2 =
    .title = Përdorni një pamje të çelët për butona, menu dhe dritare.
# Input description for light theme
onboarding-multistage-theme-description-light =
    .aria-description = Përdorni një pamje të çelët për butona, menu dhe dritare.
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark-2 =
    .title =
        Përdorni një pamje të errët për butona, menu dhe dritare.
        menus, and windows.
# Input description for dark theme
onboarding-multistage-theme-description-dark =
    .aria-description =
        Përdorni një pamje të errët për butona, menu dhe dritare.
        menus, and windows.
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow-2 =
    .title = Përdorni një pamje plot ngjyra për butona, menu dhe dritare.
# Input description for Alpenglow theme
onboarding-multistage-theme-description-alpenglow =
    .aria-description = Përdorni një pamje plot ngjyra për butona, menu dhe dritare.

## Welcome full page string

onboarding-fullpage-welcome-subheader = Le të fillojmë eksplorimin e gjithçkaje që mund të bëni.
onboarding-fullpage-form-email =
    .placeholder = Adresa juaj email…

## Firefox Sync modal dialog strings.

onboarding-sync-welcome-header = Merreni { -brand-product-name }-in me Vete
onboarding-sync-welcome-content = Merrni në krejt pajisjet tuaja faqerojtësit, historikun, fjalëkalimet dhe të tjera rregullime tuajat.
onboarding-sync-welcome-learn-more-link = Mësoni më tepër rreth Llogarive Firefox
onboarding-sync-form-input =
    .placeholder = Email
onboarding-sync-form-continue-button = Vazhdo
onboarding-sync-form-skip-login-button = Anashkalojeni këtë hap

## This is part of the line "Enter your email to continue to Firefox Sync"

onboarding-sync-form-header = Jepni email-in tuaj
onboarding-sync-form-sub-header = që të vazhdoni te { -sync-brand-name }

## These are individual benefit messages shown with an image, title and
## description.

onboarding-benefit-products-text = Mbaroni punë me një familje mjetesh që respektojnë privatësinë tuaj nëpër pajisjet tuaja.
# "Personal Data Promise" is a concept that should be translated consistently
# across the product. It refers to a concept shown elsewhere to the user: "The
# Firefox Personal Data Promise is the way we honor your data in everything we
# make and do. We take less data. We keep it safe. And we make sure that we are
# transparent about how we use it."
onboarding-benefit-privacy-text = Gjithçka bëjmë pajtohet me Premtimin tonë Mbi të Dhënat Personale: Grumbullim sa më pak. Mbajtje e parrezik. Pa të fshehta.
onboarding-benefit-sync-title = { -sync-brand-short-name }
onboarding-benefit-sync-text = Merrni me vete faqerojtësit tuaj, fjalëkalimet, historikun, etj, kudo ku përdorni { -brand-product-name }-in.
onboarding-benefit-monitor-title = { -monitor-brand-short-name }
onboarding-benefit-monitor-text = Njoftohuni kur të dhënat tuaja personale shfaqen në një cenim të ditur të dhënash.
onboarding-benefit-lockwise-title = { -lockwise-brand-short-name }
onboarding-benefit-lockwise-text = Administroni fjalëkalime që janë të mbrojtur dhe të bartshëm.

## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

onboarding-tracking-protection-title2 = Mbrojtje Nga Gjurmimi
onboarding-tracking-protection-text2 = { -brand-short-name } ndihmon të ndalet gjurmimi juaj në internet nga sajte, duke e bërë më të vështirë për reklamat t’ju ndjekin nëpër internet.
onboarding-tracking-protection-button2 = Si Funksionon
onboarding-data-sync-title = Merreni Me Vete Rregullimet Tuaja
# "Sync" is short for synchronize.
onboarding-data-sync-text2 = Njëkohësoni faqerojtësit tuaj, fjalëkalimet, etj, kudo ku përdorni { -brand-product-name }-in.
onboarding-data-sync-button2 = Hyni te { -sync-brand-short-name }-u
onboarding-firefox-monitor-title = Jini Në Dijeni të Cenimeve të të Dhënave
onboarding-firefox-monitor-text2 = { -monitor-brand-name } mbikëqyr se mos email-i juaj është parë në ndonjë cenim të ditur të dhënash dhe ju sinjalizon nëse shfaqet në një cenim të ri.
onboarding-firefox-monitor-button = Regjistrohuni për Sinjalizime
onboarding-browse-privately-title = Shfletoni Privatisht
onboarding-browse-privately-text = Shfletimi Privat e spastron historikun tuaj të kërkimeve dhe shfletimit, për ta mbajtur të fshehtë ndaj cilitdo që përdor kompjuterin tuaj.
onboarding-browse-privately-button = Hapni Dritare Private
onboarding-firefox-send-title = Mbajini Private Kartelat Që Shkëmbeni
onboarding-firefox-send-text2 = Ngarkojini kartelat tuaja te { -send-brand-name } që t’i ndani nën fshehtëzim skaj-më-skaj dhe një lidhjeje që skadon vetvetiu.
onboarding-firefox-send-button = Provoni { -send-brand-name }
onboarding-mobile-phone-title = Merreni { -brand-product-name } në Telefonin Tuaj
onboarding-mobile-phone-text = Shkarkoni { -brand-product-name } për iOS dhe Android njëkohësoni të dhënat tuaja nëpër pajisje.
# "Mobile" is short for mobile/cellular phone, "Browser" is short for web
# browser.
onboarding-mobile-phone-button = Shkarkoni Shfletuesin Për Celular
onboarding-send-tabs-title = Dërgojini Vetes Skeda Aty Për Aty
# "Send Tabs" refers to "Send Tab to Device" feature that appears when opening a
# tab's context menu.
onboarding-send-tabs-text2 = Ndani lehtësisht faqe mes pajisjeve tuaja pa u dashur të kopjoni lidhje apo të braktisni shfletuesin.
onboarding-send-tabs-button = Filloni të përdorni Dërgim Skedash
onboarding-pocket-anywhere-title = Lexoni dhe Dëgjoni Kudo
onboarding-pocket-anywhere-text2 = Ruani jashtë interneti lëndën tuaj të parapëlqyer, me aplikacionin  { -pocket-brand-name } dhe lexojeni, dëgjojeni apo shiheni kurdo që keni kohë.
onboarding-pocket-anywhere-button = Provojeni { -pocket-brand-name }-in
onboarding-lockwise-strong-passwords-title = Krijoni dhe Depozitoni Fjalëkalime të Fuqishëm
onboarding-lockwise-strong-passwords-text = { -lockwise-brand-name } krijon aty për aty fjalëkalime të fuqishëm dhe i ruan të tërë në një vend.
onboarding-lockwise-strong-passwords-button = Adminstroni Kredencialet tuaja të Hyrjeve
onboarding-facebook-container-title = Caktoni Caqe me Facebook-un
onboarding-facebook-container-text2 = { -facebook-container-brand-name } e mban profilin tuaj veçmas nga gjithçka tjetër, duke ia bërë të vështirë Facebook-ut profilizimin e reklamave për ju.
onboarding-facebook-container-button = Shtoje Zgjerimin
onboarding-import-browser-settings-title = Importoni Faqerojtësit Tuaj, Fjalëkalimet dhe Më Tepër
onboarding-import-browser-settings-text = Mos humbni kohë—merrini lehtësisht me vete sajtet tuaj nga Chrome dhe rregullimet për të.
onboarding-import-browser-settings-button = Importo të Dhëna Chrome
onboarding-personal-data-promise-title = I konceptuar Privat
onboarding-personal-data-promise-text = { -brand-product-name }-i i trajton të dhënat tuaja me respekt, duke marrë sa më pak prej tyre, duke i mbrojtur dhe duke shprehur qartë se si i përdorim.
onboarding-personal-data-promise-button = Lexoni Premtimin tonë

## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = Bukur, e morët { -brand-short-name }-in
# <icon></icon> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-header = Tani le të marrim për ju <icon></icon><b>{ $addon-name }.</b>
return-to-amo-extension-button = Shtoje Zgjerimin
return-to-amo-get-started-button = Fillojani me { -brand-short-name }
