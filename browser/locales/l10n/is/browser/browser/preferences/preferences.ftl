# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

do-not-track-description = Senda vefsvæðum “Do Not Track” merki um að þú viljir ekki láta fylgjast með þér
do-not-track-learn-more = Fræðast meira
do-not-track-option-default-content-blocking-known =
    .label = Aðeins þegar { -brand-short-name } er stillt til að loka fyrir þekkta rekjara
do-not-track-option-always =
    .label = Alltaf

pref-page-title =
    { PLATFORM() ->
        [windows] Valkostir
       *[other] Valkostir
    }

# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-input-box =
    .style = width: 15.4em
    .placeholder =
        { PLATFORM() ->
            [windows] Leita í stillingum
           *[other] Leita í stillingum
        }

managed-notice = Vafra þínum er stjórnað af skipulagsheild þinni.

pane-general-title = Almennt
category-general =
    .tooltiptext = { pane-general-title }

pane-home-title = Heim
category-home =
    .tooltiptext = { pane-home-title }

pane-search-title = Leita
category-search =
    .tooltiptext = { pane-search-title }

pane-privacy-title = Friðhelgi og öruggi
category-privacy =
    .tooltiptext = { pane-privacy-title }

pane-sync-title2 = { -sync-brand-short-name }
category-sync2 =
    .tooltiptext = { pane-sync-title2 }

help-button-label = { -brand-short-name } Stuðningur
addons-button-label = Viðbætur & þemu

focus-search =
    .key = f

close-button =
    .aria-label = Loka

## Browser Restart Dialog

feature-enable-requires-restart = { -brand-short-name } þarf að endurræsa til að virkja þennan eiginleika.
feature-disable-requires-restart = { -brand-short-name } þarf að endurræsa til að taka þennan eiginleika af.
should-restart-title = Endurræsa { -brand-short-name }
should-restart-ok = Endurræsa { -brand-short-name } núna
cancel-no-restart-button = Hætta við
restart-later = Endurræsa seinna

## Extension Control Notifications
##
## These strings are used to inform the user
## about changes made by extensions to browser settings.
##
## <img data-l10n-name="icon"/> is going to be replaced by the extension icon.
##
## Variables:
##   $name (String): name of the extension

# This string is shown to notify the user that their home page
# is being controlled by an extension.
extension-controlled-homepage-override = Viðbót, <img data-l10n-name="icon"/> { $name }, stjórnar þinni heimasíðu.

# This string is shown to notify the user that their new tab page
# is being controlled by an extension.
extension-controlled-new-tab-url = Viðbót, <img data-l10n-name="icon"/> { $name }, stjórnar nýju flipa síðunni þinni.

# This string is shown to notify the user that their notifications permission
# is being controlled by an extension.
extension-controlled-web-notifications = Viðbót, <img data-l10n-name="icon"/> { $name }, stjórnar þessari stillingu.

# This string is shown to notify the user that the default search engine
# is being controlled by an extension.
extension-controlled-default-search = Viðbót, <img data-l10n-name="icon"/> { $name }, hefur breytt sjálfgefinni leitarvél.

# This string is shown to notify the user that Container Tabs
# are being enabled by an extension.
extension-controlled-privacy-containers = Viðbót, <img data-l10n-name="icon"/> { $name }, þarfnast inihalds flipa.

# This string is shown to notify the user that their content blocking "All Detected Trackers"
# preferences are being controlled by an extension.
extension-controlled-websites-content-blocking-all-trackers = Viðbót, <img data-l10n-name="icon"/> { $name }, stjórnar þessari stillingu.

# This string is shown to notify the user that their proxy configuration preferences
# are being controlled by an extension.
extension-controlled-proxy-config = Viðbót, <img data-l10n-name="icon"/> { $name }, er að stjórna hvernig { -brand-short-name } tengist við Internetið.

# This string is shown after the user disables an extension to notify the user
# how to enable an extension that they disabled.
#
# <img data-l10n-name="addons-icon"/> will be replaced with Add-ons icon
# <img data-l10n-name="menu-icon"/> will be replaced with Menu icon
extension-controlled-enable = Til að virkja viðbót farðu þá í <img data-l10n-name="addons-icon"/> viðbætur í <img data-l10n-name="menu-icon"/> valmyndinni.

## Preferences UI Search Results

search-results-header = Leitarniðurstöður

# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] Því miður! Engar niðurstöður eru til fyrir stillingar fyrir “<span data-l10n-name="query"></span>”.
       *[other] Því miður! Engar niðurstöður eru til fyrir stillingar fyrir “<span data-l10n-name="query"></span>”.
    }

search-results-help-link = Vantar þig hjálp? Kíktu á <a data-l10n-name="url">{ -brand-short-name } hjálp</a>

## General Section

startup-header = Ræsing

# { -brand-short-name } will be 'Firefox Developer Edition',
# since this setting is only exposed in Firefox Developer Edition
separate-profile-mode =
    .label = Leyfa { -brand-short-name } og Firefox að keyra á sama tíma
use-firefox-sync = Ábending: Þetta notar aðskilda reikninga. Notaðu { -sync-brand-short-name } til að deila gögnum á milli þeirra.
get-started-not-logged-in = Skráðu þig inn í { -sync-brand-short-name }…
get-started-configured = Opna { -sync-brand-short-name } stillingar

always-check-default =
    .label = Alltaf athuga hvort { -brand-short-name } sé sjálfgefin vafri
    .accesskey = l

is-default = { -brand-short-name } er núna sjálfgefinn vafri
is-not-default = { -brand-short-name } er ekki sjálfgefinn vafri

set-as-my-default-browser =
    .label = Gera sjálfgefið…
    .accesskey = s

startup-restore-previous-session =
    .label = Sækja fyrri vafralotu
    .accesskey = s

startup-restore-warn-on-quit =
    .label = Vara við þegar vafra er lokað

disable-extension =
    .label = Slökkva á viðbót

tabs-group-header = Flipar

ctrl-tab-recently-used-order =
    .label = Ctrl+Tab skiptir á milli flipa í notkunarröð
    .accesskey = T

open-new-link-as-tabs =
    .label = Opna tengla sem flipa í staðinn fyrir nýja glugga
    .accesskey = g

warn-on-close-multiple-tabs =
    .label = Vara við þegar ég loka mörgum flipum
    .accesskey = m

warn-on-open-many-tabs =
    .label = Vara við ef opnun á mörgum flipum gæti hægt á { -brand-short-name }
    .accesskey = o

switch-links-to-new-tabs =
    .label = Þegar ég opna tengil í nýjum flipa, skipta strax yfir á hann
    .accesskey = s

show-tabs-in-taskbar =
    .label = Sýna flipasýnishorn í Windows verkslánni
    .accesskey = k

browser-containers-enabled =
    .label = Virkja innihalds flipa
    .accesskey = n

browser-containers-learn-more = Fræðast meira

browser-containers-settings =
    .label = Stillingar…
    .accesskey = i

containers-disable-alert-title = Loka öllum innihaldsflipum?
containers-disable-alert-desc =
    { $tabCount ->
        [one] Ef þú gerir innihaldsflipa óvirka, verður { $tabCount } innihaldsflipa lokað. Ertu viss um að þú viljir gera innihaldsflipa óvirka?
       *[other] Ef þú gerir innihaldsflipa óvirka, verður { $tabCount } innihaldsflipum lokað. Ertu viss um að þú viljir gera innihaldsflipa óvirka?
    }

containers-disable-alert-ok-button =
    { $tabCount ->
        [one] Loka { $tabCount } innihaldsflipa
       *[other] Loka { $tabCount } innihaldsflipum
    }
containers-disable-alert-cancel-button = Nota áfram

containers-remove-alert-title = Fjarlægja innihaldsflipa?

# Variables:
#   $count (Number) - Number of tabs that will be closed.
containers-remove-alert-msg =
    { $count ->
        [one] Ef þú fjarlægir innihaldsflipa, verður { $count } innihaldsflipa lokað. Ertu viss um að þú viljir fjarlægja innihaldsflipa?
       *[other] Ef þú fjarlægir innihaldsflipa, verður { $count } innihaldsflipum lokað. Ertu viss um að þú viljir fjarlægja innihaldsflipa?
    }

containers-remove-ok-button = Fjarlægja innihaldsflipa
containers-remove-cancel-button = Ekki fjarlægja innihaldsflipa


## General Section - Language & Appearance

language-and-appearance-header = Tungumál og útlit

fonts-and-colors-header = Letur og litir

default-font = Sjálfgefinn leturgerð
    .accesskey = ð
default-font-size = Stærð
    .accesskey = S

advanced-fonts =
    .label = Frekari stillingar…
    .accesskey = a

colors-settings =
    .label = Litir…
    .accesskey = L

language-header = Tungumál

choose-language-description = Veldu þau tungumál sem hafa forgang við birtingu vefsíðu

choose-button =
    .label = Velja…
    .accesskey = V

choose-browser-language-description = Veldu tungumálin til að nota til að birta valmyndir, skilaboð og tilkynningar frá { -brand-short-name }.
manage-browser-languages-button =
    .label = Stilltu valkosti...
    .accesskey = l
confirm-browser-language-change-description = Endurræstu { -brand-short-name } til að staðfesta þessar breytingar
confirm-browser-language-change-button = Staðfesta og endurræsa

translate-web-pages =
    .label = Þýða innihald vefsíðu
    .accesskey = Þ

# The <img> element is replaced by the logo of the provider
# used to provide machine translations for web pages.
translate-attribution = Þýtt af <img data-l10n-name="logo"/>

translate-exceptions =
    .label = Undanþágur…
    .accesskey = U

check-user-spelling =
    .label = Athuga stafsetningu um leið og texti er sleginn inn
    .accesskey = t

## General Section - Files and Applications

files-and-applications-title = Skrár og forrit

download-header = Niðurhal

download-save-to =
    .label = Vista skrár yfir á
    .accesskey = V

download-choose-folder =
    .label =
        { PLATFORM() ->
            [macos] Velja…
           *[other] Velja…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] e
           *[other] e
        }

download-always-ask-where =
    .label = Alltaf spyrja hvert á að vista skrár
    .accesskey = A

applications-header = Forrit

applications-description = Veldu hvernig { -brand-short-name } meðhöndlar skrár sem þú halar niður frá vefnum eða forritum þegar þú ert að vafra.

applications-filter =
    .placeholder = Leita að skráargerðum og forritum

applications-type-column =
    .label = Efnistegund
    .accesskey = t

applications-action-column =
    .label = Aðgerð
    .accesskey = A

# Variables:
#   $extension (String) - file extension (e.g .TXT)
applications-file-ending = { $extension } skrá
applications-action-save =
    .label = Vista skrá

# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app =
    .label = Nota { $app-name }

# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app-default =
    .label = Nota { $app-name } (sjálfgefið)

applications-use-other =
    .label = Nota annað…
applications-select-helper = Veldu hjálparforrit

applications-manage-app =
    .label = Forritsupplýsingar…
applications-always-ask =
    .label = Spyrja alltaf
applications-type-pdf = Portable Document Format (PDF)

# Variables:
#   $type (String) - the MIME type (e.g application/binary)
applications-type-pdf-with-type = { applications-type-pdf } ({ $type })

# Variables:
#   $type-description (String) - Description of the type (e.g "Portable Document Format")
#   $type (String) - the MIME type (e.g application/binary)
applications-type-description-with-type = { $type-description } ({ $type })

# Variables:
#   $plugin-name (String) - Name of a plugin (e.g Adobe Flash)
applications-use-plugin-in =
    .label = Nota { $plugin-name } (í { -brand-short-name })

## The strings in this group are used to populate
## selected label element based on the string from
## the selected menu item.

applications-use-plugin-in-label =
    .value = { applications-use-plugin-in.label }

applications-action-save-label =
    .value = { applications-action-save.label }

applications-use-app-label =
    .value = { applications-use-app.label }

applications-always-ask-label =
    .value = { applications-always-ask.label }

applications-use-app-default-label =
    .value = { applications-use-app-default.label }

applications-use-other-label =
    .value = { applications-use-other.label }

##

drm-content-header = Digital Rights Management (DRM) efni

play-drm-content =
    .label = Spila efni sem notar DRM
    .accesskey = p

play-drm-content-learn-more = Vita meira

update-application-title = { -brand-short-name } uppfærslur

update-application-description = Viðhalda { -brand-short-name } uppfærðum fyrir bestu afköst, stöðugleika og öryggi.

update-application-version = Útgáfa { $version } <a data-l10n-name="learn-more">Hvað er nýtt</a>

update-history =
    .label = Sýna uppfærslusögu…
    .accesskey = p

update-application-allow-description = Leyfa { -brand-short-name } að

update-application-auto =
    .label = Setja sjálfvirkt inn uppfærslur (mælt með)
    .accesskey = a

update-application-check-choose =
    .label = Athuga með uppfærslur, en leyfa mér að velja hvenær á að setja þær upp
    .accesskey = t

update-application-manual =
    .label = Aldrei athuga með uppfærslur (ekki mælt með)
    .accesskey = l

update-application-warning-cross-user-setting = Þessi stilling mun eiga við alla Windows reikninga og { -brand-short-name } notendur sem nota þessa uppsetningu af { -brand-short-name }.

update-application-use-service =
    .label = Nota bakgrunnsþjónustu til að setja inn uppfærslur
    .accesskey = b

update-setting-write-failure-title = Ekki tókst að vista uppfærða valkosti

update-in-progress-title = Uppfærsla í vinnslu

update-in-progress-message = Viltu að { -brand-short-name } framkvæmi þessa uppfærslu?

update-in-progress-ok-button = &Henda
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Halda áfram

## General Section - Performance

performance-title = Afköst

performance-use-recommended-settings-checkbox =
    .label = Nota afkastastillingar sem er mælt með
    .accesskey = N

performance-use-recommended-settings-desc = Þessar stillingar eru sérsniðnar fyrir þinn vélbúnað og stýrikerfi.

performance-settings-learn-more = Fræðast meira

performance-allow-hw-accel =
    .label = Nota vélbúnaðarhröðun ef mögulegt
    .accesskey = b

performance-limit-content-process-option = Takmarka þræði fyrir efni
    .accesskey = þ

performance-limit-content-process-enabled-desc = Fleiri þræðir fyrir efni getur aukið afköst þegar verið er að nota marga flipa, en tekur upp meira minni.
performance-limit-content-process-blocked-desc = Aðeins er hægt að breyta fjölda efnisþráða með { -brand-short-name } sem inniheldur fjölgjörvavinnslu. <a data-l10n-name="learn-more">Sjáðu hvernig þú athugar hvort fjölgjörvavinnsla er virk</a>

# Variables:
#   $num - default value of the `dom.ipc.processCount` pref.
performance-default-content-process-count =
    .label = { $num } (sjálfgefið)

## General Section - Browsing

browsing-title = Leit

browsing-use-autoscroll =
    .label = Nota sjálfvirka skrunun
    .accesskey = o

browsing-use-smooth-scrolling =
    .label = Nota fíngerða skrunun
    .accesskey = f

browsing-use-onscreen-keyboard =
    .label = Sýna snertilyklaborð þegar það er nauðsynlegt
    .accesskey = k

browsing-use-cursor-navigation =
    .label = Alltaf nota örvalykla til að ferðast á síðum
    .accesskey = ö

browsing-search-on-start-typing =
    .label = Leita í texta þegar byrjað er að slá inn orð
    .accesskey = L

browsing-cfr-recommendations =
    .label = Viðbætur sem mælt er með til að vafra
    .accesskey = R
browsing-cfr-features =
    .label = Stinga uppá virkni er þú vafrar
    .accesskey = S

browsing-cfr-recommendations-learn-more = Fræðast meira

## General Section - Proxy

network-settings-title = Netstillingar

network-proxy-connection-description = Stilla hvernig { -brand-short-name } tengist við Internetið.

network-proxy-connection-learn-more = Fræðast meira

network-proxy-connection-settings =
    .label = Stillingar…
    .accesskey = S

## Home Section

home-new-windows-tabs-header = Nýir gluggar og flipar

home-new-windows-tabs-description2 = Veldu hvað þú sérð þegar þú opnar heimasíðuna þína, nýja glugga og nýja flipa.

## Home Section - Home Page Customization

home-homepage-mode-label = Heimasíða og nýjir gluggar

home-newtabs-mode-label = Nýir flipar

home-restore-defaults =
    .label = Endurheimta sjálfgildi
    .accesskey = r

# "Firefox" should be treated as a brand and kept in English,
# while "Home" and "(Default)" can be localized.
home-mode-choice-default =
    .label = Firefox Home (Sjálfgefið)

home-mode-choice-custom =
    .label = Sérsniðin URL…

home-mode-choice-blank =
    .label = Tóm síða

home-homepage-custom-url =
    .placeholder = Límdu URL…

# This string has a special case for '1' and [other] (default). If necessary for
# your language, you can add {$tabCount} to your translations and use the
# standard CLDR forms, or only use the form for [other] if both strings should
# be identical.
use-current-pages =
    .label =
        { $tabCount ->
            [1] Nota núverandi síðu
           *[other] Nota núverandi síður
        }
    .accesskey = o

choose-bookmark =
    .label = Nota bókamerki…
    .accesskey = b

## Home Section - Firefox Home Content Customization

home-prefs-content-header = Upphafssíða Firefox
home-prefs-content-description = Veldu hvaða efni þú vilt á Firefox heimaskjánum þínum.

home-prefs-search-header =
    .label = Vefleit
home-prefs-topsites-header =
    .label = Efstu vefsvæði
home-prefs-topsites-description = Mest heimsóttu vefsíður

## Variables:
##  $provider (String): Name of the corresponding content provider, e.g "Pocket".

# Variables:
#  $provider (String): Name of the corresponding content provider, e.g "Pocket".
home-prefs-recommended-by-header =
    .label = Með þessu mælir { $provider }
##

home-prefs-recommended-by-learn-more = Hvernig það virkar
home-prefs-recommended-by-option-sponsored-stories =
    .label = Kostaðar sögur

home-prefs-highlights-header =
    .label = Hápunktar
home-prefs-highlights-description = Úrval af vefsvæðum sem þú hefur vistað eða heimsótt
home-prefs-highlights-option-visited-pages =
    .label = Heimsóttar síður
home-prefs-highlights-options-bookmarks =
    .label = Bókamerki
home-prefs-highlights-option-most-recent-download =
    .label = Síðasta niðurhal
home-prefs-highlights-option-saved-to-pocket =
    .label = Síður vistaðar í { -pocket-brand-name }

# For the "Snippets" feature traditionally on about:home.
# Alternative translation options: "Small Note" or something that
# expresses the idea of "a small message, shortened from something else,
# and non-essential but also not entirely trivial and useless.
home-prefs-snippets-header =
    .label = Bútar
home-prefs-snippets-description = Uppfærslur frá { -vendor-short-name } og { -brand-product-name }
home-prefs-sections-rows-option =
    .label =
        { $num ->
            [one] { $num } röð
           *[other] { $num } raðir
        }

## Search Section

search-bar-header = Leitarslá
search-bar-hidden =
    .label = Nota leitarslá til að leita og stýra
search-bar-shown =
    .label = Bæta við leitarslá í verkfæraslá

search-engine-default-header = Sjálfgefin leitarvél

search-suggestions-option =
    .label = Birta uppástungur fyrir leit
    .accesskey = s

search-show-suggestions-url-bar-option =
    .label = Sýna leitarábendingar sem niðurstöður í staðsetningarslá
    .accesskey = l

# This string describes what the user will observe when the system
# prioritizes search suggestions over browsing history in the results
# that extend down from the address bar. In the original English string,
# "ahead" refers to location (appearing most proximate to), not time
# (appearing before).
search-show-suggestions-above-history-option =
    .label = Sýna leitarábendingar fyrir framan leitarsögu í niðurstöðum staðsetningarsláar

search-suggestions-cant-show = Leitarábendingar verða ekki sýndar í staðsetningarslá þar sem þú hefur stillt { -brand-short-name } þannig að hann muni ekki neina leitarsögu.

search-one-click-header = Leitarvélar með einum smelli

search-one-click-desc = Veldu auka leitarvélar sem birtast hér fyrir neðan staðsetningarslá og leitarslá þegar þú byrjar að slá inn lykilorð.

search-choose-engine-column =
    .label = Leitarvél
search-choose-keyword-column =
    .label = Stikkorð

search-restore-default =
    .label = Endurheimta sjálfgefnar leitarvélar
    .accesskey = d

search-remove-engine =
    .label = Fjarlægja
    .accesskey = r

search-find-more-link = Finna fleiri leitarvélar

# This warning is displayed when the chosen keyword is already in use
# ('Duplicate' is an adjective)
search-keyword-warning-title = Stikkorð er þegar til
# Variables:
#   $name (String) - Name of a search engine.
search-keyword-warning-engine = Þú hefur valið stikkorð sem er þegar í notkun af “{ $name }”. Veldu eitthvað annað.
search-keyword-warning-bookmark = Þú hefur valið stikkorð sem er þegar í notkun af bókamerki. Veldu eitthvað annað.

## Containers Section

containers-header = Innihalds flipar
containers-add-button =
    .label = Bæta við nýjum innihaldsflipa
    .accesskey = a

containers-preferences-button =
    .label = Stillingar
containers-remove-button =
    .label = Fjarlægja

## Sync Section - Signed out


## Firefox Account - Signed out. Note that "Sync" and "Firefox Account" are now
## more discrete ("signed in" no longer means "and sync is connected").

sync-signedout-caption = Taktu vefinn með þér
sync-signedout-description = Samstilltu bókamerki, feril, flipa, lykilorð, viðbætur, og stillingará milli allra þinna tækja.

# This message contains two links and two icon images.
#   `<img data-l10n-name="android-icon"/>` - Android logo icon
#   `<a data-l10n-name="android-link">` - Link to Android Download
#   `<img data-l10n-name="ios-icon">` - iOS logo icon
#   `<a data-l10n-name="ios-link">` - Link to iOS Download
#
# They can be moved within the sentence as needed to adapt
# to your language, but should not be changed or translated.
sync-mobile-promo = Hala niður Firefox fyrir <img data-l10n-name="android-icon"/> <a data-l10n-name="android-link">Android</a> eða <img data-l10n-name="ios-icon"/> <a data-l10n-name="ios-link">iOS</a> til að samstilla með farsímanum.

## Sync Section - Signed in


## Firefox Account - Signed in

sync-profile-picture =
    .tooltiptext = Breyta notandamynd

sync-manage-account = Sýsla með aðgang
    .accesskey = S

sync-signedin-unverified = { $email } er ekki staðfestur.
sync-signedin-login-failure = Skráðu þig inn aftur til að tengjast aftur { $email }

sync-resend-verification =
    .label = Endursenda staðfestingu
    .accesskey = d

sync-remove-account =
    .label = Fjarlægja reikning
    .accesskey = R

sync-sign-in =
    .label = Innskráning
    .accesskey = g

## Sync section - enabling or disabling sync.


## The list of things currently syncing.


## The "Choose what to sync" dialog.

sync-engine-bookmarks =
    .label = Bókamerki
    .accesskey = m

sync-engine-history =
    .label = Ferill
    .accesskey = r

sync-engine-tabs =
    .label = Opna flipa
    .tooltiptext = Listi yfir hvað er opið á öllum samstilltum tækjum
    .accesskey = f

sync-engine-addresses =
    .label = Vistföng
    .tooltiptext = Heimilisiföng sem þú hefur vistað (bara á borðtölvu)
    .accesskey = V

sync-engine-creditcards =
    .label = Greiðslukort
    .tooltiptext = Nöfn, númer og gildistími (aðeins á borðtölvu)
    .accesskey = G

sync-engine-addons =
    .label = Viðbætur
    .tooltiptext = Viðbætur og þema fyrir Firefox á borðtölvu
    .accesskey = æ

sync-engine-prefs =
    .label =
        { PLATFORM() ->
            [windows] Stillingar
           *[other] Valkostir
        }
    .tooltiptext = Almennt, friðhelgi, og öryggistillingar sem þú hefur breytt
    .accesskey = s

## The device name controls.

sync-device-name-header = Tækjanafn

sync-device-name-change =
    .label = Breyta nafni tækis…
    .accesskey = B

sync-device-name-cancel =
    .label = Hætta við
    .accesskey = H

sync-device-name-save =
    .label = Vista
    .accesskey = V

sync-connect-another-device = Tengja annað tæki

## Privacy Section

privacy-header = Friðhelgi vafra

## Privacy Section - Forms


## Privacy Section - Logins and Passwords

# The search keyword isn't shown to users but is used to find relevant settings in about:preferences.
pane-privacy-logins-and-passwords-header = Innskráning og lykilorð
    .searchkeywords = { -lockwise-brand-short-name }

# Checkbox to control whether UI is shown to users to save or fill logins/passwords.
forms-ask-to-save-logins =
    .label = Biðja um að vista innskráningar og lykilorð fyrir vefsíður
    .accesskey = r
forms-exceptions =
    .label = Undanþágur…
    .accesskey = n
forms-generate-passwords =
    .label = Leggja til og mynda sterk lykilorð
    .accesskey = u

forms-saved-logins =
    .label = Vistaðar innskráningar…
    .accesskey = V
forms-master-pw-use =
    .label = Nota aðallykilorð
    .accesskey = o
forms-master-pw-change =
    .label = Breyta aðallykilorði…
    .accesskey = B

forms-master-pw-fips-title = Þú ert núna í FIPS ham. FIPS má ekki hafa tómt aðallykilorð.

forms-master-pw-fips-desc = Gat ekki breytt lykilorði

## OS Authentication dialog


## Privacy Section - History

history-header = Ferill

# This label is followed, on the same line, by a dropdown list of options
# (Remember history, etc.).
# In English it visually creates a full sentence, e.g.
# "Firefox will" + "Remember history".
#
# If this doesn't work for your language, you can translate this message:
#   - Simply as "Firefox", moving the verb into each option.
#     This will result in "Firefox" + "Will remember history", etc.
#   - As a stand-alone message, for example "Firefox history settings:".
history-remember-label = { -brand-short-name } mun
    .accesskey = m

history-remember-option-all =
    .label = Geyma feril
history-remember-option-never =
    .label = Aldrei geyma feril
history-remember-option-custom =
    .label = Nota sérsniðnar stillingar fyrir feril

history-remember-description = { -brand-short-name } mun muna feril, niðurhöl, form innslátt og leitarsögu.
history-dontremember-description = { -brand-short-name } mun nota sömu stillingar og í huliðsstillingu, og geyma ekki vafraferil.

history-private-browsing-permanent =
    .label = Nota alltaf einkavöfrun
    .accesskey = k

history-remember-browser-option =
    .label = Muna vafra- og niðurhalsferil
    .accesskey = b

history-remember-search-option =
    .label = Muna leit og eyðublaðaferil
    .accesskey = f

history-clear-on-close-option =
    .label = Hreinsa feril þegar { -brand-short-name } hættir
    .accesskey = r

history-clear-on-close-settings =
    .label = Stillingar…
    .accesskey = t

history-clear-button =
    .label = Hreinsa feril…
    .accesskey = s

## Privacy Section - Site Data

sitedata-header = Smákökur og gögn vefsvæðis

sitedata-total-size-calculating = Reikna gagnastærð vefsvæðis og stærð skyndiminnis…

# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
sitedata-total-size = Geymdar smákökur, gögn fyrir vefsvæði og skyndiminni eru að nota { $value } { $unit } af diskplássi.

sitedata-learn-more = Fræðast meira

sitedata-delete-on-close =
    .label = Eyða vafrakökum og síðugögnum þegar { -brand-short-name } er lokað
    .accesskey = c

sitedata-delete-on-close-private-browsing = Þegar einkavöfrun er alltaf virk, munu vefkökum og vefsvæðagögnum ávallt verða eytt þegar { -brand-short-name } er lokað.

sitedata-allow-cookies-option =
    .label = Samþykkja vefkökur og síðugögn
    .accesskey = A

sitedata-disallow-cookies-option =
    .label = Blokka vefkökur og síðugögn
    .accesskey = B

# This label means 'type of content that is blocked', and is followed by a drop-down list with content types below.
# The list items are the strings named sitedata-block-*-option*.
sitedata-block-desc = Tegund blokkuð
    .accesskey = T

sitedata-option-block-unvisited =
    .label = Vefkökur frá óheimsóttum vefsíðum
sitedata-option-block-all-third-party =
    .label = Allar vefkökur frá þriðja aðila (geta valdið því að vefsíður hrynji)
sitedata-option-block-all =
    .label = Allar vefkökur (munu valda því að vefsíður hrynji)

sitedata-clear =
    .label = Hreinsa gögn…
    .accesskey = ö

sitedata-settings =
    .label = Sýsla með gögn…
    .accesskey = M

sitedata-cookies-permissions =
    .label = Stjórna heimildum
    .accesskey = P

## Privacy Section - Address Bar

addressbar-header = Staðsetningarslá

addressbar-suggest = Þegar ég nota staðsetningarslá, stinga upp á:

addressbar-locbar-history-option =
    .label = Leitarsaga
    .accesskey = L
addressbar-locbar-bookmarks-option =
    .label = Bókamerki
    .accesskey = k
addressbar-locbar-openpage-option =
    .label = Opnir flipar
    .accesskey = O

addressbar-suggestions-settings = Breyta stillingum fyrir ábendingar leitarvéla

## Privacy Section - Content Blocking

content-blocking-learn-more = Læra meira

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

# "Standard" in this case is an adjective, meaning "default" or "normal".
enhanced-tracking-protection-setting-standard =
    .label = Staðlað
    .accesskey = d
enhanced-tracking-protection-setting-strict =
    .label = Strangt
    .accesskey = r
enhanced-tracking-protection-setting-custom =
    .label = Sérsniðið
    .accesskey = C

##

content-blocking-all-cookies = Allar vefkökur
content-blocking-unvisited-cookies = Vefkökur frá óheimsóttum vefsíðum
content-blocking-all-third-party-cookies = Allar vefkökur þriðja aðila
content-blocking-cryptominers = Rafmynt grafarar
content-blocking-fingerprinters = Fingraför

content-blocking-warning-title = Gættu þín!

content-blocking-reload-tabs-button =
    .label = Endurhlaða alla flipa
    .accesskey = E

content-blocking-tracking-protection-option-all-windows =
    .label = Í öllum gluggum
    .accesskey = A
content-blocking-option-private =
    .label = Bara í huliðsgluggum
    .accesskey = p
content-blocking-tracking-protection-change-block-list = Breyta blokkunarlista

content-blocking-cookies-label =
    .label = Smákökur
    .accesskey = S

content-blocking-expand-section =
    .tooltiptext = Nánari upplýsingar

# Cryptomining refers to using scripts on websites that can use a computer’s resources to mine cryptocurrency without a user’s knowledge.
content-blocking-cryptominers-label =
    .label = Rafmynt grafarar
    .accesskey = R

# Browser fingerprinting is a method of tracking users by the configuration and settings information (their "digital fingerprint")
# that is visible to websites they browse, rather than traditional tracking methods such as IP addresses and unique cookies.
content-blocking-fingerprinters-label =
    .label = Fingraför
    .accesskey = F

## Privacy Section - Tracking

tracking-manage-exceptions =
    .label = Stjórna undanþágum...
    .accesskey = x

## Privacy Section - Permissions

permissions-header = Heimildir

permissions-location = Staðsetning
permissions-location-settings =
    .label = Stillingar…
    .accesskey = l

permissions-camera = Myndavél
permissions-camera-settings =
    .label = Stillingar…
    .accesskey = M

permissions-microphone = Hljóðnemi
permissions-microphone-settings =
    .label = Stillingar…
    .accesskey = m

permissions-notification = Tilkynningar
permissions-notification-settings =
    .label = Stillingar…
    .accesskey = n
permissions-notification-link = Vita meira

permissions-notification-pause =
    .label = Stöðva tilkynningar þangað til { -brand-short-name } endurræsir
    .accesskey = n

permissions-autoplay = Sjálfvirk spilun

permissions-autoplay-settings =
    .label = Stillingar...
    .accesskey = S

permissions-block-popups =
    .label = Loka á sprettiglugga
    .accesskey = g

permissions-block-popups-exceptions =
    .label = Undanþágur…
    .accesskey = U

permissions-addon-install-warning =
    .label = Vara við þegar vefsvæði reynir að setja inn viðbætur
    .accesskey = V

permissions-addon-exceptions =
    .label = Undanþágur…
    .accesskey = U

permissions-a11y-privacy-checkbox =
    .label = Koma í veg fyrir að aðgengis þjónustur geti skoðað vafra
    .accesskey = a

permissions-a11y-privacy-link = Fræðast meira

## Privacy Section - Data Collection

collection-header = { -brand-short-name } Gagnasöfnun og notkun

collection-description = Við reynum alltaf að bjóða upp á valkvæmni og söfnum aðeins þeim upplýsingum sem við þurfum til að endurbæta { -brand-short-name } fyrir alla. Við spyrjum alltaf um leyfi áður en við söfnum persónulegum upplýsingum.
collection-privacy-notice = Meðferð persónuupplýsinga

collection-health-report =
    .label = Leyfa { -brand-short-name } að senda sjálkrafa tæknilegar og notkunar upplýsingar til { -vendor-short-name }
    .accesskey = r
collection-health-report-link = Fræðast meira

collection-studies =
    .label = Leyfa { -brand-short-name } að setja upp og keyra rannsóknir
collection-studies-link = Skoða rannsóknir frá { -brand-short-name }

addon-recommendations =
    .label = Leyfa { -brand-short-name } að gera sérsniðnar viðbótarviðbætur.
addon-recommendations-link = Fræðast meira

# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = Gagna skýrsla er óvirk í þessari útgáfu

collection-backlogged-crash-reports =
    .label = Leyfa { -brand-short-name } að senda hrunskýrslu í bakgrunni í þínu nafni
    .accesskey = ð
collection-backlogged-crash-reports-link = Fræðast meira

## Privacy Section - Security
##
## It is important that wording follows the guidelines outlined on this page:
## https://developers.google.com/safe-browsing/developers_guide_v2#AcceptableUsage

security-header = Öryggi

security-browsing-protection = Vörn gegn svika innihaldi og hættulegum hugbúnaði

security-enable-safe-browsing =
    .label = Loka á hættulegt og svindl efni
    .accesskey = L
security-enable-safe-browsing-link = Fræðast meira

security-block-downloads =
    .label = Loka á hættuleg niðurhöl
    .accesskey = ö

security-block-uncommon-software =
    .label = Vara mig við óvelkomnum og óþekktum hugbúnaði
    .accesskey = þ

## Privacy Section - Certificates

certs-header = Skilríki

certs-personal-label = Þegar netþjónn biður um mitt skilríki

certs-select-auto-option =
    .label = Velja eitt sjálfvirkt
    .accesskey = s

certs-select-ask-option =
    .label = Spyrja í hvert skipti
    .accesskey = S

certs-enable-ocsp =
    .label = Senda fyrirspurn á OCSP þjóna til að staðfesta hvort núverandi skírteini séu gild
    .accesskey = S

certs-view =
    .label = Skoða skilríki…
    .accesskey = S

certs-devices =
    .label = Öryggistæki…
    .accesskey = y

space-alert-learn-more-button =
    .label = Fræðast meira
    .accesskey = F

space-alert-over-5gb-pref-button =
    .label =
        { PLATFORM() ->
            [windows] Opna stillingar
           *[other] Opna stillingar
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] O
        }

space-alert-over-5gb-message =
    { PLATFORM() ->
        [windows] { -brand-short-name } er verða búið með diskaplássið. Hugsanlega birtist innihald vefsvæði ekki rétt. Þú getur hreinsað vistuð gögn í Valkostir > Friðhelgi og Öruggi > Smákökur og gögn vefsvæðis.
       *[other] { -brand-short-name } er verða búið með diskaplássið. Hugsanlega birtist innihald vefsvæðis ekki rétt. Þú getur hreinsað vistuð gögn í Valkostir > Friðhelgi og Öruggi > Smákökur og gögn vefsvæðis.
    }

space-alert-under-5gb-ok-button =
    .label = Í lagi, ég skil
    .accesskey = l

space-alert-under-5gb-message = { -brand-short-name } er verða búið með diskaplássið. Hugsanlega birtist innihald vefsvæði ekki rétt. Kíktu á “Fræðast meira” til að lagfæra disk notkun til að vafra betur.

## Privacy Section - HTTPS-Only

## The following strings are used in the Download section of settings

desktop-folder-name = Skjáborð
downloads-folder-name = Niðurhal
choose-download-folder-title = Veldu niðurhals möppu:

# Variables:
#   $service-name (String) - Name of a cloud storage provider like Dropbox, Google Drive, etc...
save-files-to-cloud-storage =
    .label = Vista skrár í { $service-name }
