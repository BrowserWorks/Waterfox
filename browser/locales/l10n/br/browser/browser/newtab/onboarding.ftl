# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-learn-more = Gouzout hiroc'h
onboarding-button-label-get-started = Stagañ e-barzh

## Welcome modal dialog strings

onboarding-welcome-header = Donemat war { -brand-short-name }
onboarding-welcome-body = Ar merdeer a zo ganeoc'h.<br/>Dizoloit peurrest { -brand-product-name }.
onboarding-welcome-learn-more = Gouzout hiroc'h a-zivout ar spletoù.

onboarding-welcome-modal-get-body = Ar merdeer a zo ganeoc'h. <br/>Bremañ e c'hallit implij { -brand-product-name } en doare gwellañ.
onboarding-welcome-modal-supercharge-body = Gwarezit ho puhez prevez
onboarding-welcome-modal-privacy-body = Ar merdeer a zo ganeoc'h. Gwarezomp muioc'h ho puhez prevez.
onboarding-welcome-modal-family-learn-more = Gouzout hiroc'h a-zivout ar familh aozadoù { -brand-product-name }.
onboarding-welcome-form-header = Kregiñ amañ

onboarding-join-form-body = Enankit ho chomlec'h postel da gregiñ ganti.
onboarding-join-form-email =
    .placeholder = Chomlec'h postel
onboarding-join-form-email-error = Postel talvoudek azgoulennet
onboarding-join-form-legal = En ur genderc'hel ec'h asantit d'an <a data-l10n-name="terms">divizoù arver</a> ha d'ar <a data-l10n-name="privacy">reolenn a-fet buhez prevez</a>.
onboarding-join-form-continue = Kenderc'hel

# This message is followed by a link using onboarding-join-form-signin ("Sign In") as text.
onboarding-join-form-signin-label = Ur gont a zo ganeoc'h endeo?
# Text for link to submit the sign in form
onboarding-join-form-signin = Kennaskañ

onboarding-start-browsing-button-label = Stagañ da verdeiñ

onboarding-cards-dismiss =
    .title = Argas
    .aria-label = Argas

## Multistage 3-screen onboarding flow strings (about:welcome pages)

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

## Welcome full page string

onboarding-fullpage-welcome-subheader = Krogomp da zizoloiñ ar pezh a c'hallit ober.
onboarding-fullpage-form-email =
    .placeholder = Ho chomlec'h postel…

## Firefox Sync modal dialog strings.

onboarding-sync-welcome-header = Kemerit { -brand-product-name } ganeoc'h
onboarding-sync-welcome-content = Tizhit o sinedoù, roll-istor, gerioù-tremen hag arventennoù all war hon holl drevnadoù.
onboarding-sync-welcome-learn-more-link = Gouzout hiroc'h diwar-benn kontoù Firefox

onboarding-sync-form-input =
    .placeholder = Postel

onboarding-sync-form-continue-button = Kenderc'hel
onboarding-sync-form-skip-login-button = Tremen ar bazenn-mañ

## This is part of the line "Enter your email to continue to Firefox Sync"

onboarding-sync-form-header = Enankit ho chomlec'h postel
onboarding-sync-form-sub-header = evit kenderc'hel etrezek { -sync-brand-name }.


## These are individual benefit messages shown with an image, title and
## description.

onboarding-benefit-products-text = Bezit oberiant gant un hollad a ostilhoù a zouj ouzh ho puhez prevez war ho holl drevnadoù.

# "Personal Data Promise" is a concept that should be translated consistently
# across the product. It refers to a concept shown elsewhere to the user: "The
# Firefox Personal Data Promise is the way we honor your data in everything we
# make and do. We take less data. We keep it safe. And we make sure that we are
# transparent about how we use it."
onboarding-benefit-privacy-text = Holl ar pezh a reomp a zouj ouzh hon Gwarant a-fet Roadennoù Personel


onboarding-benefit-sync-title = { -sync-brand-short-name }
onboarding-benefit-sync-text = Kemerit ho sinedoù, gerioù-tremen, roll istor ha muioc'h c'hoazh e pep lec'h ma arverit { -brand-product-name }.

onboarding-benefit-monitor-title = { -monitor-brand-short-name }
onboarding-benefit-monitor-text = Bezit kelaouet pa vez ho titouroù personel en ur frailh roadennoù anavezet.

onboarding-benefit-lockwise-title = { -lockwise-brand-short-name }
onboarding-benefit-lockwise-text = Merit gerioù-tremen gwarezet hag hezoug.


## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

onboarding-tracking-protection-title2 = Gwarez a-enep d'an heuliañ
onboarding-tracking-protection-text2 = { -brand-short-name } a skoazell da herzel lec'hiennoù da heuliañ ac'hanoc'h enlinenn, evit ma vefe diaesoc'h d'ar bruderezh da heuliañ ac'hanoc'h er web.
onboarding-tracking-protection-button2 = Penaos ec'h a en-dro

onboarding-data-sync-title = Kemerit hoc'h arventennoù ganeoc'h
# "Sync" is short for synchronize.
onboarding-data-sync-text2 = Goubredit ho sinedoù, gerioù-tremen ha muioc'h c'hoazh e pep lec'h ma arverit { -brand-product-name }.
onboarding-data-sync-button2 = Kennaskañ da { -sync-brand-short-name }

onboarding-firefox-monitor-title = Bezit kelaouet eus ar beradurioù
onboarding-firefox-monitor-text2 = { -monitor-brand-name } a sell mard eo bet diskuilhet ho chomlec'h postel en ur beradur roadennoù ha kelaouiñ a raio ac'hanoc'h ma vo graet en dazont.
onboarding-firefox-monitor-button = Koumanantiñ d'ar galvoù-diwall

onboarding-browse-privately-title = Merdeiñ prevez
onboarding-browse-privately-text = Gant ar merdeiñ prevez e vo skarzhet ho roll istor klask ha merdeiñ evit ma chomfe kuzh diouzh an neb a rafe gant an urzhiataer.
onboarding-browse-privately-button = Digeriñ ur prenestr prevez

onboarding-firefox-send-title = Mirit ho restroù rannet prevez
onboarding-firefox-send-text2 = Pellgasit ho restroù da { -send-brand-name } evit rannañ anezho gant un enrinegañ penn-ouzh-penn hag un ere a ziamzero ent emgefreek.
onboarding-firefox-send-button = Esaeit { -send-brand-name }

onboarding-mobile-phone-title = Tapit { -brand-product-name } war hoc'h iPhone
onboarding-mobile-phone-text = Pellgargit { -brand-product-name } evit iOS pe Android ha goubredit ho roadennoù a-druz ho holl drevnadoù.
# "Mobile" is short for mobile/cellular phone, "Browser" is short for web
# browser.
onboarding-mobile-phone-button = Pellgargañ ar merdeer hezoug

onboarding-send-tabs-title = Kasit ivinelloù deoc'h ho-unan
# "Send Tabs" refers to "Send Tab to Device" feature that appears when opening a
# tab's context menu.
onboarding-send-tabs-text2 = Gallout a rit rannañ pajennoù etre ho trevnadoù hep kaout da eilañ pe kuitaat ar merdeer.
onboarding-send-tabs-button = Kregiñ da gas ivinelloù

onboarding-pocket-anywhere-title = Lennit ha selaouit e pep lec'h
onboarding-pocket-anywhere-text2 = Enrollit ho tanvez karetañ ezlinenn gant an arload { -pocket-brand-name } ha lennit, selaouit pe sellit pa 'z eo ar gwellañ evidoc'h.
onboarding-pocket-anywhere-button = Esaeit { -pocket-brand-name }

onboarding-lockwise-strong-passwords-title = Krouiñ ha kadaviñ gerioù-tremen kreñv
onboarding-lockwise-strong-passwords-text = { -lockwise-brand-name } a sav gerioù-tremen kreñv war ar prim hag a enroll anezho holl en ul lec'h nemetken.
onboarding-lockwise-strong-passwords-button = Merit ho kerioù-tremen

onboarding-facebook-container-title = Lakait bevennoù da Facebook
onboarding-facebook-container-text2 = { -facebook-container-brand-name } a skoazell ac'hanoc'h da virout hoc'h aelad distag eus ar peurrest, evit ma vefe diaesoc'h da Facebook da dizhout ac'hanoc'h gant bruderezh.
onboarding-facebook-container-button = Ouzhpennañ an askouezh


onboarding-import-browser-settings-title = Enporzhit ho sinedoù, ho kerioù-tremen ha muioc'h c'hoazh
onboarding-import-browser-settings-text = Splujit e-barzh — degasit ho lec'hiennoù hag arventennoù Chrome ganeoc'h.
onboarding-import-browser-settings-button = Enporzhiañ roadennoù Chrome

onboarding-personal-data-promise-title = Savet evit gwareziñ ho puhez prevez
onboarding-personal-data-promise-text = { -brand-product-name } a zouh ouzh ho roadennoù en ur gemer nebeutoc'h anezho, en ur wareziñ anezho hag ur vezañ sklaer war an doare d'o implij.
onboarding-personal-data-promise-button = Lennit hon karta engouestl

## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = Dispar, { -brand-short-name } a zo ganeoc'h

# <icon></icon> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-header = Staliomp <icon></icon><b>{ $addon-name }</b> bremañ.
return-to-amo-extension-button = Ouzhpennañ an askouezh
return-to-amo-get-started-button = Krogit gant { -brand-short-name }
