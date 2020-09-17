# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-learn-more = Argibide gehiago
onboarding-button-label-get-started = Hasi erabiltzen

## Welcome modal dialog strings

onboarding-welcome-header = Ongi etorri { -brand-short-name }(e)ra
onboarding-welcome-body = Nabigatzailea duzu.<br/>Ezagutu gainerako { -brand-product-name } produktuen familia.
onboarding-welcome-learn-more = Abantailei buruzko argibide gehiago.
onboarding-welcome-modal-get-body = Nabigatzailea duzu.<br/>Orain atera zukua { -brand-product-name } familiari.
onboarding-welcome-modal-supercharge-body = Hobetu zure pribatutasunaren babesa.
onboarding-welcome-modal-privacy-body = Nabigatzailea badaukazu. Babes dezagun gehiago pribatutasuna.
onboarding-welcome-modal-family-learn-more = Ezagutu { -brand-product-name } produktuen familia osoa.
onboarding-welcome-form-header = Hasi hemen

onboarding-join-form-body = Hasteko, idatzi zure helbide elektronikoa.
onboarding-join-form-email =
    .placeholder = Idatzi helbide elektronikoa
onboarding-join-form-email-error = Baliozko helbide elektronikoa behar da
onboarding-join-form-legal = Jarraituz gero, <a data-l10n-name="terms">zerbitzuaren baldintzak</a>eta <a data-l10n-name="privacy">pribatutasun-oharra</a> onartzen dituzu.
onboarding-join-form-continue = Jarraitu

# This message is followed by a link using onboarding-join-form-signin ("Sign In") as text.
onboarding-join-form-signin-label = Dagoeneko baduzu kontua?
# Text for link to submit the sign in form
onboarding-join-form-signin = Hasi saioa

onboarding-start-browsing-button-label = Hasi nabigatzen
onboarding-cards-dismiss =
    .title = Baztertu
    .aria-label = Baztertu

## Multistage 3-screen onboarding flow strings (about:welcome pages)

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-welcome-header = Ongi etorri <span data-l10n-name="zap">{ -brand-short-name }</span>(e)ra

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

## Welcome full page string

onboarding-fullpage-welcome-subheader = Has gaitezen arakatzen egin dezakezun guztia.
onboarding-fullpage-form-email =
    .placeholder = Zure helbide elektronikoa…

## Firefox Sync modal dialog strings.

onboarding-sync-welcome-header = Eraman { -brand-product-name } aldean
onboarding-sync-welcome-content = Izan laster-markak, historia, pasahitzak eta beste ezarpenak eskura zure gailu guztietan.
onboarding-sync-welcome-learn-more-link = Firefox kontuei buruzko argibide gehiago

onboarding-sync-form-input =
    .placeholder = Helbide elektronikoa

onboarding-sync-form-continue-button = Jarraitu
onboarding-sync-form-skip-login-button = Saltatu urrats hau

## This is part of the line "Enter your email to continue to Firefox Sync"

onboarding-sync-form-header = Idatzi zure helbide elektronikoa
onboarding-sync-form-sub-header = { -sync-brand-name }-ekin jarraitzeko.


## These are individual benefit messages shown with an image, title and
## description.

onboarding-benefit-products-text = Burutu atazak zure gailuen artean pribatutasuna errespetatzen duen tresnen familiarekin.

# "Personal Data Promise" is a concept that should be translated consistently
# across the product. It refers to a concept shown elsewhere to the user: "The
# Firefox Personal Data Promise is the way we honor your data in everything we
# make and do. We take less data. We keep it safe. And we make sure that we are
# transparent about how we use it."
onboarding-benefit-privacy-text = Egiten dugun guztia gure Datu Pertsonalen Zin-egitearekin bat dator: Gutxiago hartu. Seguru mantendu. Sekreturik ez.

onboarding-benefit-sync-title = { -sync-brand-short-name }
onboarding-benefit-sync-text = Eraman zure laster-markak, pasahitzak, historia, eta gehiago { -brand-product-name } erabiltzen duzun toki guztietara.

onboarding-benefit-monitor-title = { -monitor-brand-short-name }
onboarding-benefit-monitor-text = Jaso jakinarazpenak zure informazio pertsonala datu-urratze ezagun batean badago.

onboarding-benefit-lockwise-title = { -lockwise-brand-short-name }
onboarding-benefit-lockwise-text = Kudeatu pasahitzak, babespean eta eramangarri.


## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

onboarding-tracking-protection-title2 = Jarraipenaren babesa
onboarding-tracking-protection-text2 = Webguneek zure lineako jardueraren jarraipena ez egitera laguntzen du { -brand-short-name }(e)k, horretarako zailagoa eginez iragarkiei webean zehar zu jarraitzea.
onboarding-tracking-protection-button2 = Nola dabilen

onboarding-data-sync-title = Eraman aldean zure ezarpenak
# "Sync" is short for synchronize.
onboarding-data-sync-text2 = Sinkronizatu zure laster-markak, pasahitzak eta gehiago { -brand-product-name } erabiltzen duzun toki guztietan.
onboarding-data-sync-button2 = Hasi sioa { -sync-brand-short-name }(e)n

onboarding-firefox-monitor-title = Erne ibili datuen urradudari
onboarding-firefox-monitor-text2 = { -monitor-brand-name }(e)k zure helbide elektronikoa monitorizatzen du datuen urradura ezagun batean agertuko balitz abisatzeko.
onboarding-firefox-monitor-button = Eman izena abisuak jasotzeko

onboarding-browse-privately-title = Nabigatu modu pribatuan
onboarding-browse-privately-text = Nabigatze pribatuak zure bilaketa- eta nabigatze-historia garbitzen ditu zure ordenagailua darabilen jendearengandik sekretu mantentzeko.
onboarding-browse-privately-button = Ireki leiho pribatua

onboarding-firefox-send-title = Mantendu pribatu partekatutako fitxategiak
onboarding-firefox-send-text2 = Igo zure fitxategiak { -send-brand-name } zerbitzura muturretik muturrerako zifratzearekin eta automatikoki iraungitzen den lotura batekin partekatzeko.
onboarding-firefox-send-button = Probatu { -send-brand-name }

onboarding-mobile-phone-title = Eskuratu { -brand-product-name } zure telefonoan
onboarding-mobile-phone-text = Deskargatu { -brand-product-name } iOS eta Androiderako eta sinkronizatu zure datuak gailuen artean.
# "Mobile" is short for mobile/cellular phone, "Browser" is short for web
# browser.
onboarding-mobile-phone-button = Deskargatu mugikorrerako nabigatzailea

onboarding-send-tabs-title = Bidali fitxak di-da zure buruari
# "Send Tabs" refers to "Send Tab to Device" feature that appears when opening a
# tab's context menu.
onboarding-send-tabs-text2 = Partekatu orriak modu errazean zure gailuen artean, horretarako loturak kopiatu eta itsatsi edo nabigatzailea uzteko beharrik gabe.
onboarding-send-tabs-button = Hasi fitxak bidaltzeko eginbidea erabiltzen

onboarding-pocket-anywhere-title = Irakurri eta entzun edonon
onboarding-pocket-anywhere-text2 = Gorde zure gogoko edukia { -pocket-brand-name } aplikazioarekin lineaz kanpo eta ondoen datorkizunean irakurri, entzun eta ikusteko.
onboarding-pocket-anywhere-button = Probatu { -pocket-brand-name }

onboarding-lockwise-strong-passwords-title = Sortu eta biltegiratu pasahitz sendoak
onboarding-lockwise-strong-passwords-text = { -lockwise-brand-name }(e)k pasahitz sendoak istantean sortu eta denak toki bakarrean gordetzen ditu.
onboarding-lockwise-strong-passwords-button = Kudeatu zure saio-hasierak

onboarding-facebook-container-title = Ezarri mugak Facebookekin
onboarding-facebook-container-text2 = { -facebook-container-brand-name } erabilita zure profila gainontzeko guztitik bereiziko da eta Facebooki zailagoa egingo zaio haien iragarkien jomugan zu izatea.
onboarding-facebook-container-button = Gehitu hedapena

onboarding-import-browser-settings-title = Inportatu zure laster-markak, pasahitzak eta gehiago
onboarding-import-browser-settings-text = Murgildu zuzenean — ekarri zurekin Chrome-ko gune eta ezarpenak.
onboarding-import-browser-settings-button = Inportatu Chrome-ko datuak

onboarding-personal-data-promise-title = Pribatua diseinuz
onboarding-personal-data-promise-text = { -brand-product-name }(e)k zure datuak errespetuz tratatzen ditu, hauek babestuz eta argi azalduz nola erabiltzen ditugun.
onboarding-personal-data-promise-button = Irakurri gure hitza

## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = Oso ondo, { -brand-short-name } darabilzu

# <icon></icon> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-header = Orain eskura dezagun zuretzat <icon></icon><b>{ $addon-name }</b>.
return-to-amo-extension-button = Gehitu hedapena
return-to-amo-get-started-button = Hasi { -brand-short-name } erabiltzen
