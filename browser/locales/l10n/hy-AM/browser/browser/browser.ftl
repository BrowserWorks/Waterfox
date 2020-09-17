# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The main browser window's title

# These are the default window titles everywhere except macOS. The first two
# attributes are used when the web content opened has no title:
#
# default - "Mozilla Firefox"
# private - "Mozilla Firefox (Private Browsing)"
#
# The last two are for use when there *is* a content title.
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } (Գաղտնի Դիտարկում)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (Գաղտնի Դիտարկում)
# These are the default window titles on macOS. The first two are for use when
# there is no content title:
#
# "default" - "Mozilla Firefox"
# "private" - "Mozilla Firefox - (Private Browsing)"
#
# The last two are for use when there *is* a content title.
# Do not use the brand name in the last two attributes, as we do on non-macOS.
#
# Also note the other subtle difference here: we use a `-` to separate the
# brand name from `(Private Browsing)`, which does not happen on other OSes.
#
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window-mac =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } - (Գաղտնի Դիտարկում)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (Գաղտնի Դիտարկում)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = Դիտել կայքի տեղեկությունը

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = Բացել տեղադրել հաղորդագրության վահանակը
urlbar-web-notification-anchor =
    .tooltiptext = Փոխել, թե արդյոք կարող եք կայքից ստանալ ծանուցումներ
urlbar-midi-notification-anchor =
    .tooltiptext = Բացել MIDI վահանակը
urlbar-eme-notification-anchor =
    .tooltiptext = Կառավարել DRM ծրագրաշարի օգտագործումը
urlbar-web-authn-anchor =
    .tooltiptext = Բացել վեբ իսկորոշման փեղկը
urlbar-canvas-notification-anchor =
    .tooltiptext = Կառավարել canvas դուրս բերման թույլտվությունները
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = Կառավարել ձեր բարձրախոսի համօգտագործումը այս կայքի հետ
urlbar-default-notification-anchor =
    .tooltiptext = Բացել հաղորդագրության վահանակը
urlbar-geolocation-notification-anchor =
    .tooltiptext = Բացել տեղադրության հարցման վահանակը
urlbar-xr-notification-anchor =
    .tooltiptext = Բացեք թվացյալ իրականության թույլտվության վահանակը
urlbar-storage-access-anchor =
    .tooltiptext = Բացեք զննող գործունեության թույլտվության վահանակը
urlbar-translate-notification-anchor =
    .tooltiptext = Թարգմանել այս էջը
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Կառավարել պատուհանների կամ էկրանի համօգտագործումը այս կայքի հետ
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Բացել անցանց պահեստի հաղորդագրության վահանակը
urlbar-password-notification-anchor =
    .tooltiptext = Բացել պահպանված գաղտնաբառի հաղորդագրության վահանակը
urlbar-translated-notification-anchor =
    .tooltiptext = Կառավարել էջի թարգմանությունը
urlbar-plugins-notification-anchor =
    .tooltiptext = Կառավարել բաղադրիչների օգտագործումը
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Կառավարել խցիկի և/կամ բարձրախոսի համօգտագործումը այս կայքի հետ
urlbar-autoplay-notification-anchor =
    .tooltiptext = Բացեք ինքնաշխատ վահանակը
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Պահել տվյալները Մշտական պահեստում
urlbar-addons-notification-anchor =
    .tooltiptext = Բացել հավելման տեղադրման հաղորդագրության վահանակը
urlbar-tip-help-icon =
    .title = Ստանալ օգնություն
urlbar-search-tips-confirm = Հասկանալի է։
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = Հուշում.

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Մուտքագրեք քիչ, գտեք շատ. որոնեք { $engineName }-ում անմիջապես հասցեի գոտուց:
urlbar-search-tips-redirect-2 = Սկսեք ձեր որոնումը այստեղ՝ տեսնելու ամար { $engineName }-ի առաջարկները և դիտարկումների ձեր պատմությունը:

## Local search mode indicator labels in the urlbar


##

urlbar-geolocation-blocked =
    .tooltiptext = Դուք արգելափակել եք տեղադրության տեղեկությունը այս կայքի համար:
urlbar-xr-blocked =
    .tooltiptext = Դուք արգելափակել եք թվացյալ իրականության սարքի մատչումը այս կայքի համար։
urlbar-web-notifications-blocked =
    .tooltiptext = Դուք արգելափակել եք ծանուցումները այս կայքի համար:
urlbar-camera-blocked =
    .tooltiptext = Դուք արգելափակել եք ձեր տեսախցիկը այս կայքի համար:
urlbar-microphone-blocked =
    .tooltiptext = Դուք արգելափակել եք բարձրախոսը այս կայքի համար:
urlbar-screen-blocked =
    .tooltiptext = Դուք արգելափակել եք այս կայքը՝ ձեր էկրանի համօգտագործելուց:
urlbar-persistent-storage-blocked =
    .tooltiptext = Դուք արգելափակել եք մշտական պահեստը այս կայքի համար:
urlbar-popup-blocked =
    .tooltiptext = Դուք ունեք արգելափակված ելնող պատուհաններ այս կայքում:
urlbar-autoplay-media-blocked =
    .tooltiptext = Դուք այս կայքի համար արգելափակել եք ինքնանվագարկվող ձայնային մեդիան։
urlbar-canvas-blocked =
    .tooltiptext = Դուք արգելափակել եք canvas տվյալների դուրս բերումը այս կայքի համար:
urlbar-midi-blocked =
    .tooltiptext = Դուք արգելափակել եք MIDI մատչումը այս կայքին:
urlbar-install-blocked =
    .tooltiptext = Դուք այս կայքի համար արգելափակել եք հավելասարքի բեռնումը։
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = Խմբագրել այս էջանիշը ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = Էջանշել այս էջը ({ $shortcut })

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = Ավելացնել Հասցեագոտում
page-action-manage-extension =
    .label = Կառավարել ընդլայնումը...
page-action-remove-from-urlbar =
    .label = ՀԵռացնել Հասցեագոտուց
page-action-remove-extension =
    .label = Հեռացնել ընդլայնումը

## Auto-hide Context Menu

full-screen-autohide =
    .label = Թաքցնել Գործիքագոտիները
    .accesskey = Թ
full-screen-exit =
    .label = Դուրս գալ Լիաէկրան վիճակից
    .accesskey = Լ

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of one-click search engines in
# the Urlbar and searchbar.
search-one-offs-with-title = Այս անգամ որոնել հետևյալի հետ.
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = Փոխել որոնման կարգավորումները
search-one-offs-change-settings-compact-button =
    .tooltiptext = Փոխել որոնման կարգավորումները
search-one-offs-context-open-new-tab =
    .label = Որոնել Նոր Ներդիրում
    .accesskey = Ն
search-one-offs-context-set-as-default =
    .label = Հաստատել որպես հիմնական Որոնիչ
    .accesskey = հ
search-one-offs-context-set-as-default-private =
    .label = Սահմանել որպես լռելյայն որոնման միջոց անձնական պատուհանների համար
    .accesskey = P

## Local search mode one-off buttons
## Variables:
##  $restrict (String): The restriction token corresponding to the search mode.
##    Restriction tokens are special characters users can type in the urlbar to
##    restrict their searches to certain sources (e.g., "*" to search only
##    bookmarks).


## Bookmark Panel

bookmark-panel-show-editor-checkbox =
    .label = Ցուցադրել խմբագրիչում, երբ պահպանվում է
    .accesskey = S
bookmark-panel-done-button =
    .label = Պատրաստ է
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

identity-connection-not-secure = Կապակցումը ապահով չէ
identity-connection-secure = Կապակցումը ապահով է
identity-connection-internal = Սա անվտանգ { -brand-short-name } էջ է:
identity-connection-file = Այս էջը գտնվում է համակարգչում
identity-extension-page = Այս էջը բեռնվել է ընդլայնումից:
identity-active-blocked = { -brand-short-name }-ը արգելափակել է այս էջի մասերը, քանի որ դրանք անվտանգ չեն:
identity-custom-root = Կապակցումը հաստատվել է վկայագրի թողարկողի կողմից, որը ճանաչված չէ Mozilla֊ի կողմից։
identity-passive-loaded = Այս էջի մասերը անվտանգ չեն (օր.՝ պատկերները):
identity-active-loaded = Դուք անջատել եք պաշտպանությունը այս էջում:
identity-weak-encryption = Այս էջը օգտագործում է աղքատ գաղտնագրում:
identity-insecure-login-forms = Այս էջից մուտքագրումները վտանգված են:
identity-permissions =
    .value = Արտոնություններ
identity-permissions-reload-hint = Անհրաժեշտ կլինի թարմացնել էջը, որ կիրառվեն փոփոխությունները։
identity-permissions-empty = Դուք չեք արտոնել այս կայքին որևէ հատուկ թույլտվություն:
identity-clear-site-data =
    .label = Ջնջել նշոցիկների և կայքի տվյալները…
identity-connection-not-secure-security-view = Ձեր կապը այս կայքի հետ ապահով չէ։
identity-connection-verified = Ձեր կապը այս կայքի հետ ապահով է։
identity-ev-owner-label = Վկայագիրը թողարկվել է՝
identity-description-custom-root = Mozilla֊ն չի ճանաչում այս վկայագրի թողարկողին։ Այն հնարավոր է ավելացվել է Ձեր գործավարական համակարգից կամ վարիչի կողմից։ <label data-l10n-name="link">Իմանալ ավելին</label>
identity-remove-cert-exception =
    .label = Հեռացնել բացառությունը
    .accesskey = Հ
identity-description-insecure = Ձեր կապակցումը այս կայքին գաղտնի չէ: Ուղկարկված տեղեկությունները կարող են դիտվել ուրիշների կողմից (գաղտնաբառերը, հաղորդագրությունները, քարտային տվյալները և այլն):
identity-description-insecure-login-forms = Մուտքգործման տեղեկությունը, որ մուտքագրել եք այս էջում, անվտանգ չէ և կարող է վտանգվել:
identity-description-weak-cipher-intro = Ձեր կապակցումը այս կայքին օգտագործում է աղքատ գաղտնագրում և այն գաղտնի չէ:
identity-description-weak-cipher-risk = Այլ անձինք կարող են դիտել ձեր տեղեկատվությունը կամ փոփոխել կայքի ժառանգորդին:
identity-description-active-blocked = { -brand-short-name }-ը արգելափակել է այս էջի մասերը, որոնք անվտանգ չեն: <label data-l10n-name="link">Իմանալ ավելին</label>
identity-description-passive-loaded = Ձեր կապակցումը գատնի չէ և կայք ուղարկված տեղեկատվությունը կարող է դիտվել ուրիշների կողմից:
identity-description-passive-loaded-insecure = Այս կայքը պարունակում է բովանդակություն, որն անվտանգ չէ (օր.՝ պատկերներ): <label data-l10n-name="link">Իմանալ ավելին</label>
identity-description-passive-loaded-mixed = Չնայած { -brand-short-name }-ը արգելափակել է որոշ բովանդակություն՝ այս էջում դեռ կա ոչ անվտանգ բովանդակություն (օր.՝ պատկերներ): <label data-l10n-name="link">Իմանալ ավելին</label>
identity-description-active-loaded = Այս կայքը պարունակում է բովանդակություն, որն անվտանգ չէ (օր.՝ գրվածքներ) և ձեր կապակցումը գաղտնի չէ:
identity-description-active-loaded-insecure = Կայք ուղարկված տեղեկատվությունը կարող է դիտվել ուրիշների կողմից (գաղտնաբառերը, հաղորդագրությունները, քարտային տվյալները և այլն):
identity-learn-more =
    .value = Իմանալ ավելին
identity-disable-mixed-content-blocking =
    .label = Անջատել պաշտպանությունը
    .accesskey = Ա
identity-enable-mixed-content-blocking =
    .label = Միացնել պաշտպանություն
    .accesskey = Մ
identity-more-info-link-text =
    .label = Մանրամասն

## Window controls

browser-window-minimize-button =
    .tooltiptext = Փոքրացնել
browser-window-maximize-button =
    .tooltiptext = Առավելացնել
browser-window-restore-down-button =
    .tooltiptext = Վերականգնել ներքև
browser-window-close-button =
    .tooltiptext = Փակել

## WebRTC Pop-up notifications

popup-select-camera =
    .value = Մուտք տեսախցիկին.
    .accesskey = C
popup-select-microphone =
    .value = Մուտք խոսափողին.
    .accesskey = Մ
popup-all-windows-shared = Էկրանի բոլոր տեսանելի պատուհանները կտարածվեն:
popup-screen-sharing-not-now =
    .label = Ոչ հիմա
    .accesskey = w
popup-screen-sharing-never =
    .label = Երբեք չթույլատրել
    .accesskey = N
popup-silence-notifications-checkbox = Համօգտագործելիս անջատել ծանուցումները { -brand-short-name }-ից
popup-silence-notifications-checkbox-warning = { -brand-short-name }-ը չի ցուցադրի ծանուցումները համօգտագործելիս:

## WebRTC window or screen share tab switch warning

sharing-warning-window = Դուք համօգտագործում եք { -brand-short-name }-ը: Այլ մարդիկ կարող են տեսնել, երբ անցնում եք նոր ներդիրին:
sharing-warning-screen = Դուք համօգտագործում եք ամբողջ էկրանը: Այլ մարդիկ կարող են տեսնել, երբ անցնում եք նոր ներդիրին:
sharing-warning-proceed-to-tab =
    .label = Շարունակել ներդիրում
sharing-warning-disable-for-session =
    .label = Անջ. պաշտպանությունը ա/շրջանի համար

## DevTools F12 popup

enable-devtools-popup-description = F12 դյուրանցումը օգտագործելու համար առաջին հերթին բացեք DevTools-ը Վեբ մշակողի ցանկի միջոցով:

## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = Մուտքագրեք կայքի հասցե կամ որոնում
urlbar-placeholder =
    .placeholder = Մուտքագրեք կայքի հասցե կամ որոնում
urlbar-remote-control-notification-anchor =
    .tooltiptext = Դիտարկել հեռակա կառավարմամբ
urlbar-permissions-granted =
    .tooltiptext = Դուք տրամադրել եք այս կայքէջին լրացուցիչ թույլտվություններ:
urlbar-switch-to-tab =
    .value = Անցնել ներդիրի՝
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Ընդլայնում՝
urlbar-go-button =
    .tooltiptext = Գնալ Հասցեի Տողում նշված հասցեով
urlbar-page-action-button =
    .tooltiptext = Էջի գործույթները
urlbar-pocket-button =
    .tooltiptext = Պահպանել { -pocket-brand-name }-ում

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> այժմ լիաէկրան է
fullscreen-warning-no-domain = Փաստաթուղթը այժմ լիաէկրան է
fullscreen-exit-button = Դուրս գալ Լիաէկրանից (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = Դուրս գալ Լիաէկրանից (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> ղեկավարում է ձեր ցուցիչը: Սեղմեք Esc՝ ղեկավարումը հետ վերադարձնելու համար:
pointerlock-warning-no-domain = Այս փաստաթուղթը ղեկավարում է ձեր ցուցիչը: Սեղմեք Esc՝ ղեկավարումը հետ վերադարձնելու համար:
