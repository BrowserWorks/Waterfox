# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

do-not-track-description = Ad yazen asɣal “ur sfuɣul ara” ɣer ismal web akken ad gzun belli ur tebɣiḍ ara asfuɣel
do-not-track-learn-more = Issin ugar
do-not-track-option-default-content-blocking-known =
    .label = Kan ticki { -brand-short-name } yettusbadu ɣer sewḥel ineḍfaṛen
do-not-track-option-always =
    .label = Yal tikkelt
pref-page-title =
    { PLATFORM() ->
        [windows] Iɣewwaṛen
       *[other] Ismenyifen
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
            [windows] Af deg iɣewwaṛen
           *[other] Af deg ismenyifen
        }
managed-notice = Iminig-ik tessefrak-it tuddsa-ik.
pane-general-title = Amatu
category-general =
    .tooltiptext = { pane-general-title }
pane-home-title = Asebter agejdan
category-home =
    .tooltiptext = { pane-home-title }
pane-search-title = Nadi
category-search =
    .tooltiptext = { pane-search-title }
pane-privacy-title = Tabaḍnit  & Taɣellist
category-privacy =
    .tooltiptext = { pane-privacy-title }
pane-sync-title2 = { -sync-brand-short-name }
category-sync2 =
    .tooltiptext = { pane-sync-title2 }
pane-experimental-title = { -brand-short-name } Tirma
category-experimental =
    .tooltiptext = { -brand-short-name } Tirma
pane-experimental-subtitle = Kemmel, maca ɣur-k.
pane-experimental-search-results-header = { -brand-short-name } Tirma: ddu kan s leεqel
pane-experimental-description = Abeddel n yismenyifen n twila leqqayen zemren ad ḥazen tamlellit neɣ taɣellist n { -brand-short-name }.
help-button-label = { -brand-short-name } Tallelt
addons-button-label = Isiɣzaf akked yisental
focus-search =
    .key = f
close-button =
    .aria-label = Mdel

## Browser Restart Dialog

feature-enable-requires-restart = issefk { -brand-short-name } ad yales tanekra akken ad irmed tamahilt.
feature-disable-requires-restart = Issefk { -brand-short-name } ad yales asenkar akken ad yettwakkes urmad n tmahilt-a.
should-restart-title = Ales asenker i { -brand-short-name }
should-restart-ok = Ales asenker { -brand-short-name } tura
cancel-no-restart-button = Sefsex
restart-later = Ales asenker ticki

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
extension-controlled-homepage-override = Azegrir, <img data-l10n-name="icon"/> { $name }, yesenqad asebter agejdan-inek.
# This string is shown to notify the user that their new tab page
# is being controlled by an extension.
extension-controlled-new-tab-url = Azegrir, <img data-l10n-name="icon"/> { $name }, yesenqad iccer n usebter-inek.
# This string is shown to notify the user that the password manager setting
# is being controlled by an extension
extension-controlled-password-saving = Asiɣzef, <img data-l10n-name="icon"/> { $name }, yessedday aɣewwaṛ-a.
# This string is shown to notify the user that their notifications permission
# is being controlled by an extension.
extension-controlled-web-notifications = Asiɣzef, <img data-l10n-name="icon"/>{ $name }, isenqad aɣewwar-agi.
# This string is shown to notify the user that the default search engine
# is being controlled by an extension.
extension-controlled-default-search = Yiwen n usiɣzef, <img data-l10n-name="icon"/> { $name }, isenker allal-ik n unadi amezwer.
# This string is shown to notify the user that Container Tabs
# are being enabled by an extension.
extension-controlled-privacy-containers = Yiwen n usiɣzef, <img data-l10n-name="icon"/> { $name }, iḥwaǧ agaliz n waccaren.
# This string is shown to notify the user that their content blocking "All Detected Trackers"
# preferences are being controlled by an extension.
extension-controlled-websites-content-blocking-all-trackers = Asiɣzef, <img data-l10n-name="icon"/>{ $name }, isenqad aɣewwar-agi.
# This string is shown to notify the user that their proxy configuration preferences
# are being controlled by an extension.
extension-controlled-proxy-config = Azegrir, <img data-l10n-name="icon"/> { $name }, isefrak amek { -brand-short-name } ad iqqen γer internet.
# This string is shown after the user disables an extension to notify the user
# how to enable an extension that they disabled.
#
# <img data-l10n-name="addons-icon"/> will be replaced with Add-ons icon
# <img data-l10n-name="menu-icon"/> will be replaced with Menu icon
extension-controlled-enable = Iwakken ad tremdeḍ asiɣzef ddu ɣer <img data-l10n-name="addons-icon"/> n yizegraren deg wumuɣ n <img data-l10n-name="menu-icon"/>.

## Preferences UI Search Results

search-results-header = Igmaḍ n unadi
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] Nesḥasef! Ulac igemaḍ deg iɣewwaṛen i "<span data-l10n-name="query"></span>".
       *[other] Nesḥasef! Ulac igmaḍ deg ismenyifen i "<span data-l10n-name="query"></span>"
    }
search-results-help-link = Tesriḍ tallelt? Rzu γer <a data-l10n-name="url">{ -brand-short-name } Tallelt</a>

## General Section

startup-header = Asenker
# { -brand-short-name } will be 'Firefox Developer Edition',
# since this setting is only exposed in Firefox Developer Edition
separate-profile-mode =
    .label = Sireg { -brand-short-name } d Firefox ad selkmen s wudem anmaway
use-firefox-sync = Taxbalut: Imaɣnuten yemgaraden ttusqedcen. Tzemreḍ ad tfaṛseḍ seg { -sync-brand-short-name } i beṭṭu n isefka-inek gar-asen.
get-started-not-logged-in = Qqen ɣer { -sync-brand-short-name }…
get-started-configured = Ldi ismenyifen n { -sync-brand-short-name }
always-check-default =
    .label = Senqed yal tikkelt ma yella { -brand-short-name } d iminig-ik amezwar
    .accesskey = S
is-default = { -brand-short-name } d iminig-inek amezwar
is-not-default = { -brand-short-name } mačči d iminig-inek amezwer
set-as-my-default-browser =
    .label = Sbadut d amezwar…
    .accesskey = G
startup-restore-previous-session =
    .label = Err-d tiɣimit izrin
    .accesskey = E
startup-restore-warn-on-quit =
    .label = Lɣu ticki tettefɣeḍ seg iminig
disable-extension =
    .label = Sens aseɣzif
tabs-group-header = Iccaren
ctrl-tab-recently-used-order =
    .label = Ctrl+Tab yessezray-d accaren n umizzwer yettwasqedcen melmi kan
    .accesskey = T
open-new-link-as-tabs =
    .label = Ldi iseɣwan deg iccaren deg umḍiq n isfuyla imaynuten
    .accesskey = L
warn-on-close-multiple-tabs =
    .label = Lɣu ticki medlen deqs n yiccaren
    .accesskey = u
warn-on-open-many-tabs =
    .label = Lɣu-id ticki ẓẓay { -brand-short-name } ma ldin ddeqs n yiccaren
    .accesskey = L
switch-links-to-new-tabs =
    .label = Ticki ad ldiɣ aseɣwen deg iccer amaynut, ddu ɣur-s imir
    .accesskey = T
show-tabs-in-taskbar =
    .label = Sken taskant n yiccaren deg ufeggag n twira n Windows
    .accesskey = S
browser-containers-enabled =
    .label = Rmed Iccaren imagbaren
    .accesskey = R
browser-containers-learn-more = Issin ugar
browser-containers-settings =
    .label = Iγewwaṛen…
    .accesskey = I
containers-disable-alert-title = Mdel akk iccaren imagbaren?
containers-disable-alert-desc =
    { $tabCount ->
        [one] Ma tekkseḍ iccaren imagbaren tura, iccer amagbar { $tabCount } ad yemdel. Tebɣiḍ ad tekkseḍ armad n yiccaren imagbaren?
       *[other] Ma tekkseḍ iccaren imagbaren tura, iccaren imagbaren { $tabCount } ad medlen. Tebɣiḍ ad tekkseḍ armad n yiccaren imagbaren?
    }
containers-disable-alert-ok-button =
    { $tabCount ->
        [one] Mdel  { $tabCount } iccer amagbar
       *[other] Mdel { $tabCount } iccaren imagbaren
    }
containers-disable-alert-cancel-button = Eǧǧ-it yermed
containers-remove-alert-title = Kkes amagbar-a?
# Variables:
#   $count (Number) - Number of tabs that will be closed.
containers-remove-alert-msg =
    { $count ->
        [one] Ma tekkseḍ amagbar-a tura, iccer amagbar { $count } ad ittwamdel. Tebɣiḍ ad tekkseḍ amagbar-a?
       *[other] Ma tekkseḍ amagbar-a tura, iccer amagbar { $count } ad ittwamdel. Tebɣiḍ ad tekkseḍ amagbar-a?
    }
containers-remove-ok-button = Kkes amagbar-a
containers-remove-cancel-button = Ur tekkes ara amagbar-a

## General Section - Language & Appearance

language-and-appearance-header = Tutlayt d urwes
fonts-and-colors-header = Tisefsiyin d yiniten
default-font = Tasefsit tamezwarut
    .accesskey = K
default-font-size = Teɣzi
    .accesskey = T
advanced-fonts =
    .label = Talqayt…
    .accesskey = l
colors-settings =
    .label = Initen…
    .accesskey = I
# Zoom is a noun, and the message is used as header for a group of options
preferences-zoom-header = Semɣeṛ/Semẓi
preferences-default-zoom = Zoom awurman
    .accesskey = Z
preferences-default-zoom-value =
    .label = { $percentage }%
preferences-zoom-text-only =
    .label = Zoom: Aḍris kan
    .accesskey = A
language-header = Tutlayt
choose-language-description = Fren tutlayt tebɣiḍ i uskan n isebtar
choose-button =
    .label = Fren…
    .accesskey = F
choose-browser-language-description = Fren tutlayin i uskan n wumuɣen, iznan, akk d ilɣa seg { -brand-short-name }.
manage-browser-languages-button =
    .label = Sbadu Wiyyaḍ...
    .accesskey = l
confirm-browser-language-change-description = Ales asenker i tikkelt-nniḍen { -brand-short-name } i isnifal-agi
confirm-browser-language-change-button = Seddu sakin alles tanekra
translate-web-pages =
    .label = Suqel agbur web
    .accesskey = S
# The <img> element is replaced by the logo of the provider
# used to provide machine translations for web pages.
translate-attribution = Tasuqilt sɣuṛ <img data-l10n-name="logo"/>
translate-exceptions =
    .label = Tisuraf…
    .accesskey = r
# Variables:
#    $localeName (string) - Localized name of the locale to be used.
use-system-locale =
    .label = Seqdec iɣewwaṛen n unagraw-ik n wammud i “{ $localeName }” akken  ad tmesleḍ izmaz, akuden, imḍanen, d yiktazalen.
check-user-spelling =
    .label = Senqed tira-iw ticki ttaruɣ
    .accesskey = q

## General Section - Files and Applications

files-and-applications-title = Ifuyla d isnasen
download-header = Isadaren
download-save-to =
    .label = Sekles ifuyla ɣer
    .accesskey = S
download-choose-folder =
    .label =
        { PLATFORM() ->
            [macos] Fren…
           *[other] Snirem…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] F
           *[other] u
        }
download-always-ask-where =
    .label = Suter yal tikkelt anida ara ttwakelsen ifuyla
    .accesskey = S
applications-header = Isnasen
applications-description = Fren amek ara yeddu { -brand-short-name } akked ifuyla i d-tessalayeḍ akked isnasen i tesseqdaceḍ mi ara tettinigeḍ.
applications-filter =
    .placeholder = Nadi tawsit n ifuyla neɣ isnasen
applications-type-column =
    .label = Tawsit n ugbur
    .accesskey = T
applications-action-column =
    .label = Tigawt
    .accesskey = i
# Variables:
#   $extension (String) - file extension (e.g .TXT)
applications-file-ending = Afaylu { $extension }
applications-action-save =
    .label = Sekles afaylu
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app =
    .label = Seqdec { $app-name }
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app-default =
    .label = Seqdec { $app-name } (s uwennez amezwaru)
applications-use-os-default =
    .label =
        { PLATFORM() ->
            [macos] Seqdec asnas amezwer n macOS
            [windows] Seqdec asnas amezwer n Windows
           *[other] Seqdec asnas amezwer n unagraw
        }
applications-use-other =
    .label = Seqdec wiyaḍ...
applications-select-helper = Seqdec asnas azɣaray
applications-manage-app =
    .label = Aglam leqqayen n usnas…
applications-always-ask =
    .label = Sutur yal tikelt
applications-type-pdf = Portable Document Format (PDF)
# Variables:
#   $type (String) - the MIME type (e.g application/binary)
applications-type-pdf-with-type = { applications-type-pdf } ({ $type })
# Variables:
#   $type-description (String) - Description of the type (e.g "Portable Document Format")
#   $type (String) - the MIME type (e.g application/binary)
applications-type-description-with-type = { $type-description } ({ $type })
# Variables:
#   $extension (String) - file extension (e.g .TXT)
#   $type (String) - the MIME type (e.g application/binary)
applications-file-ending-with-type = { applications-file-ending } ({ $type })
# Variables:
#   $plugin-name (String) - Name of a plugin (e.g Adobe Flash)
applications-use-plugin-in =
    .label = Seqdec { $plugin-name } (deg { -brand-short-name })
applications-open-inapp =
    .label = Ldi deg { -brand-short-name }

## The strings in this group are used to populate
## selected label element based on the string from
## the selected menu item.

applications-use-plugin-in-label =
    .value = { applications-use-plugin-in.label }
applications-action-save-label =
    .value = { applications-action-save.label }
applications-use-app-label =
    .value = { applications-use-app.label }
applications-open-inapp-label =
    .value = { applications-open-inapp.label }
applications-always-ask-label =
    .value = { applications-always-ask.label }
applications-use-app-default-label =
    .value = { applications-use-app-default.label }
applications-use-other-label =
    .value = { applications-use-other.label }
applications-use-os-default-label =
    .value = { applications-use-os-default.label }

##

drm-content-header = Izerfan n usefrek n ugbur umḍin (DRM)
play-drm-content =
    .label = Γɣaṛ agbur ittwaḥerzen s DRM-
    .accesskey = Γ
play-drm-content-learn-more = Issin ugar
update-application-title = Ileqman n { -brand-short-name }
update-application-description = Ḥrez { -brand-short-name } yettwalqem i tmellit ifazen, arkad, akked tɣellist.
update-application-version = Lqem { $version } <a data-l10n-name="learn-more">D acu i d amaynut</a>
update-history =
    .label = Sken-d azray n ulqqem…
    .accesskey = S
update-application-allow-description = Sireg { -brand-short-name } akken ad
update-application-auto =
    .label = Sebded ileqman s wudem awurman (yelha)
    .accesskey = S
update-application-check-choose =
    .label = Ad inadi ileqman maca ad k-yeǧǧ ad tferneḍ asbeddi-nsen
    .accesskey = A
update-application-manual =
    .label = Werǧin ad tnadiḍ ileqman (mačči d ayen ilhan)
    .accesskey = W
update-application-warning-cross-user-setting = Aɣewwaṛ-a ad yeḍḍu ɣef yimiḍanen meṛṛa n Windows akked yimeɣna { -brand-short-name } i yesseqdacen asbeddi n { -brand-short-name }.
update-application-use-service =
    .label = Seqdec ameẓlu n ugilal i usebded n ileqman
    .accesskey = b
update-setting-write-failure-title = Tuccḍa deg usekles n yismenyifen n uleqqem
# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    { -brand-short-name } yemmuger-d tuccḍa ihi ur izmir ara ad isekles abeddel-a. Ẓeṛ d akken abeddel n usmenyif-a n uleqqem, yesra tasiregt n tira deg ufaylu ddaw-a. Kečč neɣ andbal n unagraw, tzemreḍ ahat ad tesseɣtiḍ tuccḍa s umuddun n tisrag ummid ɣer ufaylu-a i ugraw Users.
    
    Ur yezmir ad yaru deg ufaylu: { $path }
update-in-progress-title = Aleqqem itteddu
update-in-progress-message = Tebɣiḍ { -brand-short-name } ad ikemmel aleqqem-agi?
update-in-progress-ok-button = &Kkes
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Kemmel

## General Section - Performance

performance-title = Tamellit
performance-use-recommended-settings-checkbox =
    .label = Seqdec iɣewwaren n tmellit ihulen
    .accesskey = s
performance-use-recommended-settings-desc = Iɣewwaren-a wulmen i twila n warrum n uselkim-inek d unagraw n wammud.
performance-settings-learn-more = Issin ugar
performance-allow-hw-accel =
    .label = Seqdec tasɣiwelt tudlift n warrum ma tella
    .accesskey = q
performance-limit-content-process-option = Azal afellay n ukala n ugbur
    .accesskey = Y
performance-limit-content-process-enabled-desc = Ikalan n ugbur-nniḍen zemren ad qaεḍen ugar tamellit di lawan n useqdec n waṭas n waccaren, maca akka ad iseqdec aṭas n tkatut.
performance-limit-content-process-blocked-desc = Tzemreḍ kan ad tesnifleḍ amḍan n ugbur n ukala akked ugetakala { -brand-short-name }. <a data-l10n-name="learn-more">Issin amek ara tesneqdeḍ ma yella agetakala yermed</a>
# Variables:
#   $num - default value of the `dom.ipc.processCount` pref.
performance-default-content-process-count =
    .label = { $num } (amezwer)

## General Section - Browsing

browsing-title = Tunigin
browsing-use-autoscroll =
    .label = Seqdec adrurem awurman
    .accesskey = d
browsing-use-smooth-scrolling =
    .label = Seqdec adrurem aleggwaɣ
    .accesskey = e
browsing-use-onscreen-keyboard =
    .label = Sken anasiw amennalan ticki terra tmara
    .accesskey = n
browsing-use-cursor-navigation =
    .label = Seqdec yal tikkelt tiqeffalin n tunigin i tikli deg usebter
    .accesskey = S
browsing-search-on-start-typing =
    .label = Nadi aḍris ticki tebda tira
    .accesskey = N
browsing-picture-in-picture-toggle-enabled =
    .label = Rmeb asenqed i uslaɣ n uvidyu
    .accesskey = R
browsing-picture-in-picture-learn-more = Issin ugar
browsing-cfr-recommendations =
    .label = Welleh isizaf ticki tettiniged
    .accesskey = W
browsing-cfr-features =
    .label = Welleh ɣef timahilin n tunigin iteddun akka tura.
    .accesskey = W
browsing-cfr-recommendations-learn-more = Issin ugar

## General Section - Proxy

network-settings-title = Iɣewwaṛen n uẓeṭṭa
network-proxy-connection-description = Swel amek { -brand-short-name } ad iqqen γer internet.
network-proxy-connection-learn-more = Issin ugar
network-proxy-connection-settings =
    .label = Iɣewwaṛen…
    .accesskey = I

## Home Section

home-new-windows-tabs-header = Isfuyla d yiccaren imaynuten
home-new-windows-tabs-description2 = Fren ayen ara d-yettwaseknen ticki telḍiḍ asebter agejdan, ifuyla imaynuten neɣ accaren imaynuten.

## Home Section - Home Page Customization

home-homepage-mode-label = Asebter agejdan akked isfuyla imaynuten
home-newtabs-mode-label = Iccer amaynut
home-restore-defaults =
    .label = Err-d iɣewwaṛen imezwar
    .accesskey = R
# "Firefox" should be treated as a brand and kept in English,
# while "Home" and "(Default)" can be localized.
home-mode-choice-default =
    .label = Asebter agejdan n Firefox
home-mode-choice-custom =
    .label = URLs iganen...
home-mode-choice-blank =
    .label = Asebter ilem
home-homepage-custom-url =
    .placeholder = Senṭeḍ URL...
# This string has a special case for '1' and [other] (default). If necessary for
# your language, you can add {$tabCount} to your translations and use the
# standard CLDR forms, or only use the form for [other] if both strings should
# be identical.
use-current-pages =
    .label =
        { $tabCount ->
            [1] Asebter amiran
           *[other] Isebtar imiranen
        }
    .accesskey = s
choose-bookmark =
    .label = Ticraḍ n isebtar…
    .accesskey = T

## Home Section - Firefox Home Content Customization

home-prefs-content-header = Agbur agejdan Firefox
home-prefs-content-description = Fren agbur i tebɣiḍ deg ugdil agejdan Firefox.
home-prefs-search-header =
    .label = Anadi Web
home-prefs-topsites-header =
    .label = Ismal ifazen
home-prefs-topsites-description = Ismal i tettwaliḍ aṭas

## Variables:
##  $provider (String): Name of the corresponding content provider, e.g "Pocket".

home-prefs-recommended-by-header =
    .label = Iwelleh-it-id { $provider }
home-prefs-recommended-by-description-update = Agbur yelhan i yettwafen deg Web sɣur { $provider }

##

home-prefs-recommended-by-learn-more = Amek iteddu
home-prefs-recommended-by-option-sponsored-stories =
    .label = Tiqṣidin yettwarefden
home-prefs-highlights-header =
    .label = Asebrureq
home-prefs-highlights-description = Tafrant n yismal i teskelseḍ neɣ i twalaḍ
home-prefs-highlights-option-visited-pages =
    .label = isebtar yettwarzan
home-prefs-highlights-options-bookmarks =
    .label = Ticraḍ n isebtar
home-prefs-highlights-option-most-recent-download =
    .label = Isadaren imaynuten
home-prefs-highlights-option-saved-to-pocket =
    .label = Isebtar yettwaḥerzen ar { -pocket-brand-name }
# For the "Snippets" feature traditionally on about:home.
# Alternative translation options: "Small Note" or something that
# expresses the idea of "a small message, shortened from something else,
# and non-essential but also not entirely trivial and useless.
home-prefs-snippets-header =
    .label = Tiwzillin
home-prefs-snippets-description = Ileqman seg { -vendor-short-name } d { -brand-product-name }
home-prefs-sections-rows-option =
    .label =
        { $num ->
            [one] { $num } izirig
           *[other] { $num } izirigen
        }

## Search Section

search-bar-header = Afeggag n unadi
search-bar-hidden =
    .label = Seqdec afeggag n tansa akken ad tnadiḍ wa ad tinigeḍ
search-bar-shown =
    .label = Rnu afeggag n unadi deg ufeggag n ifecka
search-engine-default-header = Amsedday n unadi amezwer
search-engine-default-desc-2 = Wagi d amsedday-ik n unadi amezwer deg ufeggag n tensa akked ufeggag n unadi. Tzemreḍ ad t-tbeddleḍ melmi tebɣiḍ.
search-engine-default-private-desc-2 = Fren amsedday-nniḍen n unadi amezwer i yisfuyla n tunigin tusligt.
search-separate-default-engine =
    .label = Seqdec amsedday-a n unadi deg usfaylu n tunigin tusligt
    .accesskey = q
search-suggestions-header = Nadi isumar
search-suggestions-desc = Fren amek ara d-banen isumar deg yimseddayen n unadi.
search-suggestions-option =
    .label = Sken isumar n unadi
    .accesskey = S
search-show-suggestions-url-bar-option =
    .label = Sken isumar n unadi deg ugmuḍ n ufeggag n tansa
    .accesskey = u
# This string describes what the user will observe when the system
# prioritizes search suggestions over browsing history in the results
# that extend down from the address bar. In the original English string,
# "ahead" refers to location (appearing most proximate to), not time
# (appearing before).
search-show-suggestions-above-history-option =
    .label = Sken-d asumer n unadi uqbel azraynn tunigin deg ugemmuḍ deg ufeggag n tansa
search-show-suggestions-private-windows =
    .label = Sken isumar n unadi deg isfuyla n tunigin tusligin
suggestions-addressbar-settings-generic = Snifel ismenyifen i yisumar n ufeggag n tansa
search-suggestions-cant-show = Anadi n isumar ur d ittwaskan ara deg yigmaḍ n ufeggag n tansa acku tsewleḍ { -brand-short-name } akken ur iḥerrez ara azray.
search-one-click-header = Imseddayen n unadi ara tkecmeḍ s yiwen n usiti
search-one-click-desc = Fren imseddayen n unadi-nniḍen ad d-ibanen daw ufeggag n tansa akked ufeggag n unadi m'ara ad tebduḍ ad tsekcameḍ awal n tsarut.
search-choose-engine-column =
    .label = Amsedday n unadi
search-choose-keyword-column =
    .label = Awal tasarut
search-restore-default =
    .label = Err-d imseddayen n unadi amezwer
    .accesskey = E
search-remove-engine =
    .label = Kkes
    .accesskey = K
search-add-engine =
    .label = Rnu
    .accesskey = R
search-find-more-link = Aff ugar n yimseddayen n unadi
# This warning is displayed when the chosen keyword is already in use
# ('Duplicate' is an adjective)
search-keyword-warning-title = Sleg awal n tsarutt
# Variables:
#   $name (String) - Name of a search engine.
search-keyword-warning-engine = Tferneḍ awal n tsarutt i  yettusqedcen yakan sɣur "{ $name }".. Ma ulac aɣilif fren wayeḍ.
search-keyword-warning-bookmark = Tferneḍ awal n tsarutt i yettusqedcen yakan di tecreḍṭ n usebter. Ma ulac aɣilif fren wayeḍ.

## Containers Section

containers-back-button =
    .aria-label =
        { PLATFORM() ->
            [windows] Uɣal ɣer iɣewwaṛen
           *[other] Uɣal ɣer ismenyifen
        }
containers-header = Iccaren imagbaren
containers-add-button =
    .label = Rnu amagbar-nniḍen
    .accesskey = R
containers-new-tab-check =
    .label = Fren amagbar i yal iccer amaynut
    .accesskey = F
containers-preferences-button =
    .label = Ismenyifen
containers-remove-button =
    .label = Kkes

## Firefox Account - Signed out. Note that "Sync" and "Firefox Account" are now
## more discrete ("signed in" no longer means "and sync is connected").

sync-signedout-caption = Awi web-inek yid-k
sync-signedout-description = Semtawi ticraḍ-inek n yisebtar, azray, accaren, awalen uffiren, izegrar, akked yismenyifen d yibenkan-inek akk.
sync-signedout-account-signin2 =
    .label = Qqen ɣer { -sync-brand-short-name }…
    .accesskey = Q
# This message contains two links and two icon images.
#   `<img data-l10n-name="android-icon"/>` - Android logo icon
#   `<a data-l10n-name="android-link">` - Link to Android Download
#   `<img data-l10n-name="ios-icon">` - iOS logo icon
#   `<a data-l10n-name="ios-link">` - Link to iOS Download
#
# They can be moved within the sentence as needed to adapt
# to your language, but should not be changed or translated.
sync-mobile-promo = Sider Firefox i <img data-l10n-name="android-icon"/> <a data-l10n-name="android-link">Android</a> neɣ <img data-l10n-name="ios-icon"/> <a data-l10n-name="ios-link">iOs</a> akken ad temtawiḍ d yibenkan-ik aziraz.

## Firefox Account - Signed in

sync-profile-picture =
    .tooltiptext = Beddel tugna n umaɣnu
sync-sign-out =
    .label = Ffeɣ…
    .accesskey = F
sync-manage-account = Sefrek amiḍan
    .accesskey = m
sync-signedin-unverified = { $email } ur ittusenqed ara.
sync-signedin-login-failure = Ma ulac aɣilif sesteb akken ad tkecmeḍ { $email }
sync-resend-verification =
    .label = Ales tuzna n usentem
    .accesskey = d
sync-remove-account =
    .label = Kkes amiḍan
    .accesskey = R
sync-sign-in =
    .label = Qqen
    .accesskey = Q

## Sync section - enabling or disabling sync.

prefs-syncing-on = Amtawi: IRMED
prefs-syncing-off = Amtawi: INSA
prefs-sync-setup =
    .label = Sbadu { -sync-brand-short-name }...
    .accesskey = S
prefs-sync-offer-setup-label = Mtawi ticraḍ-ik n yisebtar, azray, iccaren, awalen uffiren, izegrar akked ismenyifen gar yibenkan-ik.
prefs-sync-now =
    .labelnotsyncing = Mtawi tura
    .accesskeynotsyncing = T
    .labelsyncing = Amtawi…

## The list of things currently syncing.

sync-currently-syncing-heading = Iferdisen-a mtawin akka tura:
sync-currently-syncing-bookmarks = Ticraḍ n yisebtar
sync-currently-syncing-history = Azray
sync-currently-syncing-tabs = Ldi iccaren
sync-currently-syncing-logins-passwords = Inekcam d wawalen uffiren
sync-currently-syncing-addresses = Tansiwin
sync-currently-syncing-creditcards = Tikarḍiwin n usmad
sync-currently-syncing-addons = Izegrar
sync-currently-syncing-prefs =
    { PLATFORM() ->
        [windows] Iɣewwaṛen
       *[other] Ismenyifen
    }
sync-change-options =
    .label = Snifel…
    .accesskey = f

## The "Choose what to sync" dialog.

sync-choose-what-to-sync-dialog =
    .title = Fren iferdisen ara yemtawin
    .style = width: 38em; min-height: 35em;
    .buttonlabelaccept = Sekles ibeddilen
    .buttonaccesskeyaccept = b
    .buttonlabelextra2 = Se déconnecter…
    .buttonaccesskeyextra2 = S
sync-engine-bookmarks =
    .label = Ticraḍ n yisebtar
    .accesskey = c
sync-engine-history =
    .label = Azray
    .accesskey = A
sync-engine-tabs =
    .label = Ldi accaren
    .tooltiptext = Tabdart n wayen akka yeldin deg yibenkan akk yemtawan
    .accesskey = T
sync-engine-logins-passwords =
    .label = Inekcam d wawalen uffiren
    .tooltiptext = Ismawen n yiseqdacen akked wawalen uffiren i teskelseḍ
    .accesskey = I
sync-engine-addresses =
    .label = Tansiwin
    .tooltiptext = Tansiwin n lpusṭa i teskelseḍ (aselkim kan)
    .accesskey = w
sync-engine-creditcards =
    .label = Tikarḍiwin n usmad
    .tooltiptext = Ismawen, imḍanen akked yizemziyen ifaten (aselkim kan)
    .accesskey = G
sync-engine-addons =
    .label = Izegrar
    .tooltiptext = Iseɣzaf akked yisental i Firefox n uselkim
    .accesskey = z
sync-engine-prefs =
    .label =
        { PLATFORM() ->
            [windows] Iγewwaren
           *[other] Ismenyifen
        }
    .tooltiptext = Amatu, tabaḍnit, akked yiɣewwaren n tɣellist ttubeddlen
    .accesskey = y

## The device name controls.

sync-device-name-header = Isem n yibenk
sync-device-name-change =
    .label = Beddel isem n yibenk…
    .accesskey = q
sync-device-name-cancel =
    .label = Sefsex
    .accesskey = x
sync-device-name-save =
    .label = Sekles
    .accesskey = l
sync-connect-another-device = Qqen ibenk-nniḍen

## Privacy Section

privacy-header = Tabaḍnit n iminig

## Privacy Section - Logins and Passwords

# The search keyword isn't shown to users but is used to find relevant settings in about:preferences.
pane-privacy-logins-and-passwords-header = Inekcam & wawalen uffiren
    .searchkeywords = { -lockwise-brand-short-name }
# Checkbox to control whether UI is shown to users to save or fill logins/passwords.
forms-ask-to-save-logins =
    .label = Suter akken ad teskelseḍ inekcam d wawalen uffiren i yismal web
    .accesskey = s
forms-exceptions =
    .label = Tisuraf…
    .accesskey = r
forms-generate-passwords =
    .label = Sumer daɣen rnu awalen uffiren iǧehden
    .accesskey = S
forms-breach-alerts =
    .label = Sken ilɣa i wawalen uffiren n yismal i teɛna trewla n yisefka
    .accesskey = k
forms-breach-alerts-learn-more-link = Issin ugar
# Checkbox which controls filling saved logins into fields automatically when they appear, in some cases without user interaction.
forms-fill-logins-and-passwords =
    .label = Ččar inekcam d wawalen uffiren s wudem awurman
    .accesskey = i
forms-saved-logins =
    .label = Inekcumen yettwakelsen…
    .accesskey = e
forms-master-pw-use =
    .label = Seqdec awal uffir agejdan
    .accesskey = S
forms-primary-pw-use =
    .label = Seqdec awal uffir agejdan
    .accesskey = U
forms-primary-pw-learn-more-link = Issin ugar
# This string uses the former name of the Primary Password feature
# ("Master Password" in English) so that the preferences can be found
# when searching for the old name. The accesskey is unused.
forms-master-pw-change =
    .label = Snifel awal uffir agejdan…
    .accesskey = a
forms-master-pw-fips-title = Aql-ak deg uskar FIPS . FIPS yesra awal uffir agejdan arilem.
forms-primary-pw-change =
    .label = Beddel awal uffir…
    .accesskey = P
# Leave this message empty if the translation for "Primary Password" matches
# "Master Password" in your language. If you're editing the FTL file directly,
# use { "" } as the value.
forms-primary-pw-former-name = { "" }
forms-primary-pw-fips-title = Aql-ak·akem akka tura deg uskar FIPS . FIPS yesra awal uffir agejdan arilem.
forms-master-pw-fips-desc = Asnifel n wawal uffir agejdan ur yeddi ara

## OS Authentication dialog

# This message can be seen by trying to add a Master Password.
master-password-os-auth-dialog-message-win = Akken ad ternuḍ awal-inek uffir agejdan, sekcem inekcam-inek n tuqqna n Windows. Ayagi ad iεiwen deg ummesten n tɣellist n yimiḍanen-inek.
# This message can be seen by trying to add a Master Password.
# The macOS strings are preceded by the operating system with "Firefox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
master-password-os-auth-dialog-message-macosx = Rnu awal uffir agejdan
# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Akken ad ternuḍ awal-inek·inem uffir agejdan, sekcem inekcam-inek·inem n tuqqna n Windows. Ayagi ad yeḍmen aḥraz n tɣellist n yimiḍanen-inek·inem.
# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Firefox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = rnu awal uffir agejdan
master-password-os-auth-dialog-caption = { -brand-full-name }

## Privacy Section - History

history-header = Azray
# This label is followed, on the same line, by a dropdown list of options
# (Remember history, etc.).
# In English it visually creates a full sentence, e.g.
# "Firefox will" + "Remember history".
#
# If this doesn't work for your language, you can translate this message:
#   - Simply as "Firefox", moving the verb into each option.
#     This will result in "Firefox" + "Will remember history", etc.
#   - As a stand-alone message, for example "Firefox history settings:".
history-remember-label = { -brand-short-name } ad
    .accesskey = l
history-remember-option-all =
    .label = Ḥrez azray
history-remember-option-never =
    .label = Ur ḥerrez ara azray
history-remember-option-custom =
    .label = Seqdec iɣewwaṛen udmawanen i umazray-a
history-remember-description = { -brand-short-name } ad yeḥrez isefka n tunigin, izedman, tiferkiyin d umezruy n unadi.
history-dontremember-description = { -brand-short-name } ad isseqdec iɣewwaṛen n tunigin tusligt, u diɣen ur iḥerrez ara azray n tunigin-inek.
history-private-browsing-permanent =
    .label = Seqdec yal ass askar n tunigin tusligt
    .accesskey = g
history-remember-browser-option =
    .label = Cfu ɣef umezruy n tunigin d izdamen
    .accesskey = C
history-remember-search-option =
    .label = Ḥrez azray n unadi d tferkit
    .accesskey = u
history-clear-on-close-option =
    .label = Sfeḍ azray ticki tmedleḍ { -brand-short-name }
    .accesskey = r
history-clear-on-close-settings =
    .label = Iɣewwaṛen…
    .accesskey = I
history-clear-button =
    .label = Sfeḍ azray…
    .accesskey = s

## Privacy Section - Site Data

sitedata-header = Inagan n tuqna akked isefka n usmel
sitedata-total-size-calculating = Asiḍen n teɣzi n yisefka akked tuɣzi n tuffirt…
# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
sitedata-total-size = Tskelseḍ inagan n tuqqna, isefka n usmel, daɣen tuffirt tesseqdac akka tura { $value } { $unit } seg adeg n tallunt n tkatut n uḍebsi.
sitedata-learn-more = Lmed ugar
sitedata-delete-on-close =
    .label = Mdel inagan n tuqqna akk d isefka n usmel ticki { -brand-short-name } yettwamdel
    .accesskey = i
sitedata-delete-on-close-private-browsing = Deg uskar n tinigin tusligt timezgit, inagan n tuqqna akked isefka n usmel ad ttwasefḍen yal tikkelt ticki yemdel { -brand-short-name }.
sitedata-allow-cookies-option =
    .label = Qbel inagan n tuqqna d yisefka n usmel
    .accesskey = Q
sitedata-disallow-cookies-option =
    .label = Sewḥel inagan n tuqna akked isefka n usmel
    .accesskey = S
# This label means 'type of content that is blocked', and is followed by a drop-down list with content types below.
# The list items are the strings named sitedata-block-*-option*.
sitedata-block-desc = Tawsit tewḥel
    .accesskey = T
sitedata-option-block-cross-site-trackers =
    .label = Ineḍfaṛen gar yismal
sitedata-option-block-cross-site-and-social-media-trackers =
    .label = Ineḍfaṛen gar yismal akked iẓeḍwa inmettiyen
sitedata-option-block-cross-site-and-social-media-trackers-plus-isolate =
    .label = Ineḍfaren gar yismal d wid n yiẓeḍwa inmettiyen d uɛzal n yinagan n tuqqna i d-yeqqimen
sitedata-option-block-unvisited =
    .label = Inagan n tuqqna seg ismal web ur yettwarzan ara
sitedata-option-block-all-third-party =
    .label = Akk inagan n tuqqna n wis kraḍ (zemren ad rẓen isaml web)
sitedata-option-block-all =
    .label = Akk inagan n tuqqna (ad rẓen isaml web)
sitedata-clear =
    .label = Sfeḍ isefka…
    .accesskey = l
sitedata-settings =
    .label = Sefrek isefka…
    .accesskey = M
sitedata-cookies-permissions =
    .label = Sefrek tisirag...
    .accesskey = s
sitedata-cookies-exceptions =
    .label = Sefrek tisuraf…
    .accesskey = x

## Privacy Section - Address Bar

addressbar-header = Afeggag n tansa
addressbar-suggest = Ticki tesqedceḍ afeggag n tansa, sumer
addressbar-locbar-history-option =
    .label = Azray n tunigin
    .accesskey = M
addressbar-locbar-bookmarks-option =
    .label = Ticraḍ n isebtar
    .accesskey = T
addressbar-locbar-openpage-option =
    .label = Iccaren yeldin
    .accesskey = I
addressbar-locbar-topsites-option =
    .label = Ismal ufrinen
    .accesskey = T
addressbar-suggestions-settings = Snifel ismenyifen i yisumar n umsedday n unadi

## Privacy Section - Content Blocking

content-blocking-enhanced-tracking-protection = Ammesten yettwaseǧhed mgal aḍfaṛ
content-blocking-section-top-level-description = Ineḍfaṛen ad k-ḍefṛen srid akken ad leqḍen talɣut ɣef tnumi-ik n tunigin akked wayen tḥemmleḍ. { -brand-short-name } ad yessewḥel ddeqs n yineḍfaṛen-a akked yir iskripten.
content-blocking-learn-more = Issin ugar

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

# "Standard" in this case is an adjective, meaning "default" or "normal".
enhanced-tracking-protection-setting-standard =
    .label = Tizeɣt
    .accesskey = z
enhanced-tracking-protection-setting-strict =
    .label = Uḥris
    .accesskey = ḥ
enhanced-tracking-protection-setting-custom =
    .label = Udmawan
    .accesskey = d

##

content-blocking-etp-standard-desc = Yerked gar ummesten akked tmellit. ISebtar ad d-alin s wudem amagnu.
content-blocking-etp-strict-desc = Ammesten yettwaseǧhed, maca kra n yismal akked ugbur yemzer ur teddun ara akken iwata.
content-blocking-etp-custom-desc = Fren ineḍfaṛen akked iskripten ara tesweḥleḍ.
content-blocking-private-windows = Agbur yettwaseqdec i uḍfaṛ deg yisfuyla n tunigin tuligt
content-blocking-cross-site-tracking-cookies = Inagan n tuqqna i uḍfaṛ gar yismal
content-blocking-cross-site-tracking-cookies-plus-isolate = Inagan n tuqqna n uḍfar gar yismal d uɛzal n yinagan n tuqqna i d-yeqqimen
content-blocking-social-media-trackers = Ineḍfaṛen n iẓeḍwa inmettiyen
content-blocking-all-cookies = Inagan n tuqqna meṛṛa
content-blocking-unvisited-cookies = Inagan n tuqqna n yismal ur yettwarzan ara
content-blocking-all-windows-tracking-content = Agbur yettwaseqdec i uḍfaṛ deg yisfuyla meṛṛa
content-blocking-all-third-party-cookies = Akk inagan n tuqqna n wis kraḍ
content-blocking-cryptominers = Ikripṭuminaren
content-blocking-fingerprinters = Idsilen umḍinen
content-blocking-warning-title = Aqeṛṛu d afella!
content-blocking-and-isolating-etp-warning-description = Asewḥel n yineḍfaren d uɛzal n yinagan n tuqqna yezmer ad iḥaz tamahilt n kra n yismal. Smiren asebter s yineḍfaren akken ad d-yali ugbur meṛṛa.
content-blocking-warning-learn-how = Issin amek
content-blocking-reload-description = Yessefk ad talseḍ asali n yiccaren-ik akken ad ddun ibeddilen-a.
content-blocking-reload-tabs-button =
    .label = Smiren akk accaren
    .accesskey = S
content-blocking-tracking-content-label =
    .label = Agbur n uḍfaṛ
    .accesskey = A
content-blocking-tracking-protection-option-all-windows =
    .label = Deg akk isufyla
    .accesskey = a
content-blocking-option-private =
    .label = Deg isfuyla usligen kan
    .accesskey = u
content-blocking-tracking-protection-change-block-list = Snifel tabdart n usewḥel
content-blocking-cookies-label =
    .label = Inagan n tuqqna
    .accesskey = I
content-blocking-expand-section =
    .tooltiptext = Ugar n telɣut
# Cryptomining refers to using scripts on websites that can use a computer’s resources to mine cryptocurrency without a user’s knowledge.
content-blocking-cryptominers-label =
    .label = Ikripṭuminaren
    .accesskey = k
# Browser fingerprinting is a method of tracking users by the configuration and settings information (their "digital fingerprint")
# that is visible to websites they browse, rather than traditional tracking methods such as IP addresses and unique cookies.
content-blocking-fingerprinters-label =
    .label = Idsilen umḍinen
    .accesskey = I

## Privacy Section - Tracking

tracking-manage-exceptions =
    .label = Sefrek tisuraf
    .accesskey = t

## Privacy Section - Permissions

permissions-header = Tisirag
permissions-location = Adig
permissions-location-settings =
    .label = Iɣewwaṛen…
    .accesskey = z
permissions-xr = Tilawt tuhlist
permissions-xr-settings =
    .label = Iɣewwaṛen
    .accesskey = I
permissions-camera = Takamiṛat
permissions-camera-settings =
    .label = Iɣewwaṛen…
    .accesskey = d
permissions-microphone = Asawaḍ
permissions-microphone-settings =
    .label = Iɣewwaṛen…
    .accesskey = x
permissions-notification = Ilγa
permissions-notification-settings =
    .label = Iɣewwaṛen…
    .accesskey = b
permissions-notification-link = Issin ugar
permissions-notification-pause =
    .label = Saḥbes ilγa arma yekker { -brand-short-name }
    .accesskey = n
permissions-autoplay = Aseddu awurman
permissions-autoplay-settings =
    .label = Iɣewwaṛen
    .accesskey = t
permissions-block-popups =
    .label = Sewḥel isfuyla udhimen
    .accesskey = S
permissions-block-popups-exceptions =
    .label = Tisuraf…
    .accesskey = s
permissions-addon-install-warning =
    .label = Lɣu ticki ismal ttaɛraḍen ad sbedden izegrar
    .accesskey = B
permissions-addon-exceptions =
    .label = Tisuraf…
    .accesskey = s
permissions-a11y-privacy-checkbox =
    .label = Sewḥel imeẓla n unekcum ad kecmen γer iminig-inek
    .accesskey = a
permissions-a11y-privacy-link = Issin ugar

## Privacy Section - Data Collection

collection-header = Alqqaḍ d useqdec n isefka { -brand-short-name }
collection-description = Ad k-d-nefk afus akken ad tferneḍ aleqqwaḍ n wayen kan ilaqen i weqaεed n { -brand-short-name } i yal yiwen. Ad k-d-nsuter yal tikkelt tasiregt send ad nawi talɣut tudmawant.
collection-privacy-notice = Tasertit n tbaḍnit
collection-health-report-telemetry-disabled = Ur tezgiḍ teǧǧiḍ { -vendor-short-name } ad d-yelqeḍ isefka itiknikanen akked wid n temyigawt. Meṛṛa isefka yezrin ad ttwakksen deg 30 n wussan.
collection-health-report-telemetry-disabled-link = Issin ugar
collection-health-report =
    .label = Sireg { -brand-short-name } ad yazen isefka itiknikanen ɣer { -vendor-short-name }
    .accesskey = r
collection-health-report-link = Lmed ugar
collection-studies =
    .label = Sireg { -brand-short-name } ad yessebded sakin ad isenker tizrawin
collection-studies-link = Wali tizrawin n { -brand-short-name }
addon-recommendations =
    .label = Sireg { -brand-short-name } ad yeg iwellihen n usiɣzef udmawan
addon-recommendations-link = Issin ugar
# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = Aneqqis n isefka ur irmid ara i uswel-a n usefsu
collection-backlogged-crash-reports =
    .label = Sireg { -brand-short-name } akken ad yazen ineqqisen n uɣelluy deg ugilal
    .accesskey = c
collection-backlogged-crash-reports-link = Issin ugar

## Privacy Section - Security
##
## It is important that wording follows the guidelines outlined on this page:
## https://developers.google.com/safe-browsing/developers_guide_v2#AcceptableUsage

security-header = Taɣellist
security-browsing-protection = Ammesten mgal agbur n ukellex u d aseɣẓan n ddir
security-enable-safe-browsing =
    .label = Sewḥel yir agbur neɣ win iweɛṛen
    .accesskey = S
security-enable-safe-browsing-link = Issin ugar
security-block-downloads =
    .label = Sewḥel yir asider
    .accesskey = d
security-block-uncommon-software =
    .label = Lɣu-yid ɣef iseɣẓanen ur nelhi ara akked wid ur bɣiɣ ara
    .accesskey = ẓ

## Privacy Section - Certificates

certs-header = Iselkinen
certs-personal-label = Ticki aqeddac isuter aselkin-ik udmawan
certs-select-auto-option =
    .label = Fren yiwen s wudem awurman
    .accesskey = S
certs-select-ask-option =
    .label = Steqsi-yi-d yal tikkelt
    .accesskey = A
certs-enable-ocsp =
    .label = Suter iqeddacen imerrayen OCSP akken ad sentmen taneɣbalt n iselkinen
    .accesskey = S
certs-view =
    .label = Sken iselkinen…
    .accesskey = S
certs-devices =
    .label = Ibenkan n tɣellist…
    .accesskey = B
space-alert-learn-more-button =
    .label = Issin ugar
    .accesskey = g
space-alert-over-5gb-pref-button =
    .label =
        { PLATFORM() ->
            [windows] Ldi iɣewwaṛen
           *[other] Ldi Ismenyifen
        }
    .accesskey =
        { PLATFORM() ->
            [windows] i
           *[other] s
        }
space-alert-over-5gb-message =
    { PLATFORM() ->
        [windows] { -brand-short-name } iteddu ad iεeddi i tallunt n udebṣi. Igburen n usmel web ur d-ttbanen ara akken iwata. Tzemreḍ ad tsefḍeḍ isefka n usmel deg Iγewwaṛen-> Talqayt -> Isefka n usmel.
       *[other] { -brand-short-name } iteddu ad iεeddi i tallunt n udebṣi. Igburen n usmel web ur d-ttbanen ara akken iwata. Tzemreḍ ad tsefḍeḍ isefka n usmel deg Ismenyifen-> Talqayt -> Isefka n usmel.
    }
space-alert-under-5gb-ok-button =
    .label = IH awi-t-id
    .accesskey = H
space-alert-under-5gb-message = Amkan n udebṣi iteddu ad yaweḍ ar { -brand-short-name }. Igburen n usmel web ur d-ttbanen ara akken iwata.  Ddu ar "Issin ugar" akken ad tseggmeḍ aseqdec n udebṣi-ik akken tarmit n tunigin ad tuɣal tfaz.

## Privacy Section - HTTPS-Only

httpsonly-header = Askar HTTPS-Only
httpsonly-description = HTTPS yettmuddu-d tuqqna taɣelsant, yettwawgelhen gar { -brand-short-name } d yismal web wuɣur trezzuḍ. Amur meqqren n yismal web ssefraken HTTPS rnu ma yella asker HTTPS yermed, { -brand-short-name } ad ileqqem akk tuqqniwin ɣer HTTPS.
httpsonly-learn-more = Issin ugar
httpsonly-radio-enabled =
    .label = Rmed askar HTTPS-Only deg yisfuyla akk
httpsonly-radio-enabled-pbm =
    .label = Rmed askar HTTPS-Only deg yisfuyla usligen kan
httpsonly-radio-disabled =
    .label = Ur remmed ara askar HTTPS-Only

## The following strings are used in the Download section of settings

desktop-folder-name = Tanarit
downloads-folder-name = Isadaren
choose-download-folder-title = Fren akaram i usnifel:
# Variables:
#   $service-name (String) - Name of a cloud storage provider like Dropbox, Google Drive, etc...
save-files-to-cloud-storage =
    .label = Sekles ifuyla deg { $service-name }
