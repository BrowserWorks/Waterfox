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
    .data-title-private = { -brand-full-name } (პირადი ფანჯარა)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (პირადი ფანჯარა)
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
    .data-title-private = { -brand-full-name } - (პირადი ფანჯარა)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (პირადი ფანჯარა)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = საიტის ინფორმაციის ჩვენება

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = ჩადგმის შეტყობინების არის გახსნა
urlbar-web-notification-anchor =
    .tooltiptext = აირჩიეთ მიიღოთ თუ არა შეტყობინებები ამ საიტისგან
urlbar-midi-notification-anchor =
    .tooltiptext = MIDI დაფის გახსნა
urlbar-eme-notification-anchor =
    .tooltiptext = DRM პროგრამის გამოყენების მართვა
urlbar-web-authn-anchor =
    .tooltiptext = ვებსაიტებზე შესვლის არე
urlbar-canvas-notification-anchor =
    .tooltiptext = გრაფიკის გამოსახვის მონაცემებზე წვდომის უფლებების მართვა
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = საიტისთვის თქვენი მიკროფონის გაზიარების მართვა
urlbar-default-notification-anchor =
    .tooltiptext = შეტყობინებების არე
urlbar-geolocation-notification-anchor =
    .tooltiptext = მდებარეობის მოთხოვნის არე
urlbar-xr-notification-anchor =
    .tooltiptext = წარმოსახვითი სინამდვილის ნებართვების არე
urlbar-storage-access-anchor =
    .tooltiptext = დათვალიერების მოქმედებების ნებართვების არის გახსნა
urlbar-translate-notification-anchor =
    .tooltiptext = გვერდის თარგმნა
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = საიტისთვის თქვენი ფანჯრების ან ეკრანის გაზიარების მართვა
urlbar-indexed-db-notification-anchor =
    .tooltiptext = კავშირგარეშე საცავის შეტყობინების არის გახსნა
urlbar-password-notification-anchor =
    .tooltiptext = პაროლის შენახვის შეტყობინების არის გახსნა
urlbar-translated-notification-anchor =
    .tooltiptext = გვერდის თარგმნის მართვა
urlbar-plugins-notification-anchor =
    .tooltiptext = გამოყენებული მოდულების მართვა
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = საიტისთვის თქვენი კამერის და/ან მიკროფონის გაზიარების მართვა
urlbar-autoplay-notification-anchor =
    .tooltiptext = თვითგაშვების სამართავის გახსნა
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = მონაცემების შენახვა მუდმივ მეხსიერებაზე
urlbar-addons-notification-anchor =
    .tooltiptext = დამატების ჩადგმის შეტყობინების არის გახსნა
urlbar-tip-help-icon =
    .title = დახმარების მიღება
urlbar-search-tips-confirm = კარგი, გასაგებია
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = რჩევა:

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = აკრიფეთ ნაკლები, მონახეთ მეტი: გამოიყენეთ { $engineName } საძიებოდ პირდაპირ მისამართების ველიდან.
urlbar-search-tips-redirect-2 = დაიწყეთ ძიება და შემოთავაზებებს მოგაწვდით { $engineName } ან იხილავთ დათვალიერების ისტორიიდან.

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = სანიშნეები
urlbar-search-mode-tabs = ჩანართები
urlbar-search-mode-history = ისტორია

##

urlbar-geolocation-blocked =
    .tooltiptext = ამ საიტისთვის თქვენს მდებარეობაზე წვდომა შეზღუდული გაქვთ.
urlbar-xr-blocked =
    .tooltiptext = ამ საიტისთვის წარმოსახვითი სინამდვილის თქვენს მოწყობილობაზე წვდომა შეზღუდული გაქვთ.
urlbar-web-notifications-blocked =
    .tooltiptext = ამ საიტისთვის შეტყობინებების ჩვენების უფლება შეზღუდული გაქვთ.
urlbar-camera-blocked =
    .tooltiptext = ამ საიტისთვის თქვენი კამერის გამოყენების უფლება შეზღუდული გაქვთ.
urlbar-microphone-blocked =
    .tooltiptext = ამ საიტისთვის თქვენი მიკროფონის გამოყენების უფლება შეზღუდული გაქვთ.
urlbar-screen-blocked =
    .tooltiptext = ამ საიტისთვის თქვენი ეკრანის გაზიარების უფლება შეზღუდული გაქვთ.
urlbar-persistent-storage-blocked =
    .tooltiptext = ამ საიტისთვის, მუდმივ მეხსიერებასთან წვდომა შეზღუდული გაქვთ.
urlbar-popup-blocked =
    .tooltiptext = ამ საიტზე, ამომხტომი ფანჯრები შეზღუდული გაქვთ.
urlbar-autoplay-media-blocked =
    .tooltiptext = ამ საიტისთვის მედიაფაილების თვითგაშვების უფლება შეზღუდული გაქვთ.
urlbar-canvas-blocked =
    .tooltiptext = ამ საიტისთვის, გრაფიკის გამოსახვის მონაცემებზე წვდომის უფლება შეზღუდული გაქვთ.
urlbar-midi-blocked =
    .tooltiptext = ამ საიტისთვის MIDI წვდომის უფლება შეზღუდული გაქვთ.
urlbar-install-blocked =
    .tooltiptext = ამ საიტისთვის დამატების ჩადგმის უფლება შეზღუდული გაქვთ.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = სანიშნის ჩასწორება ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = გვერდის ჩანიშვნა ({ $shortcut })

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = მისამართების ველში დამატება
page-action-manage-extension =
    .label = გაფართოების მართვა…
page-action-remove-from-urlbar =
    .label = მისამართების ველიდან მოცილება
page-action-remove-extension =
    .label = გაფართოების მოცილება

## Auto-hide Context Menu

full-screen-autohide =
    .label = ხელსაწყოთა ზოლების დამალვა
    .accesskey = დ
full-screen-exit =
    .label = სრულეკრანიანი რეჟიმიდან გამოსვლა
    .accesskey = ს

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of one-click search engines in
# the Urlbar and searchbar.
search-one-offs-with-title = მოსაძიებლად, შეგიძლიათ გამოიყენოთ:
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = ძიების პარამეტრების შეცვლა
search-one-offs-change-settings-compact-button =
    .tooltiptext = ძიების პარამეტრების შეცვლა
search-one-offs-context-open-new-tab =
    .label = ძიება ახალ ჩანართში
    .accesskey = ნ
search-one-offs-context-set-as-default =
    .label = ნაგულისხმევ საძიებოდ დაყენება
    .accesskey = გ
search-one-offs-context-set-as-default-private =
    .label = ნაგულისხმევ საძიებოდ დაყენება პირად ფანჯრებში
    .accesskey = პ
# Search engine one-off buttons with an @alias shortcut/keyword.
# Variables:
#  $engineName (String): The name of the engine.
#  $alias (String): The @alias shortcut/keyword.
search-one-offs-engine-with-alias =
    .tooltiptext = { $engineName } ({ $alias })

## Local search mode one-off buttons
## Variables:
##  $restrict (String): The restriction token corresponding to the search mode.
##    Restriction tokens are special characters users can type in the urlbar to
##    restrict their searches to certain sources (e.g., "*" to search only
##    bookmarks).

search-one-offs-bookmarks =
    .tooltiptext = სანიშნები ({ $restrict })
search-one-offs-tabs =
    .tooltiptext = ჩანართები ({ $restrict })
search-one-offs-history =
    .tooltiptext = ისტორია ({ $restrict })

## Bookmark Panel

bookmark-panel-show-editor-checkbox =
    .label = ჩასწორების შესაძლებლობა შენახვისას
    .accesskey = ჩ
bookmark-panel-done-button =
    .label = მზადაა
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

identity-connection-not-secure = დაუცველი კავშირი
identity-connection-secure = კავშირი დაცულია
identity-connection-internal = { -brand-short-name } – უსაფრთხო გვერდი.
identity-connection-file = ეს გვერდი თქვენს კომპიუტერში ინახება.
identity-extension-page = ეს გვერდი გახსნილია გაფართოების მიერ.
identity-active-blocked = { -brand-short-name } ზღუდავს გვერდის დაუცველ ნაწილებს.
identity-custom-root = კავშირი დამოწმებულია სერტიფიკატის გამომშვების მიერ, რომელიც უცნობია Mozilla-სთვის.
identity-passive-loaded = ამ გვერდის გარკვეული ნაწილი დაუცველია (მაგალითად სურათები).
identity-active-loaded = ამ გვერდზე დაცვა გამორთული გაქვთ.
identity-weak-encryption = ეს გვერდი სუსტ დაშიფვრას იყენებს.
identity-insecure-login-forms = ამ გვერდზე შეყვანილი ანგარიშის მონაცემები შესაძლოა მოიპარონ.
identity-permissions =
    .value = ნებართვები
identity-permissions-reload-hint = ცვლილებების ასამოქმედებლად შესაძლოა გვერდის ხელახლა ჩატვირთვა დაგჭირდეთ.
identity-permissions-empty = ამ საიტისთვის განსაკუთრებული უფლებები არ მიგიციათ.
identity-clear-site-data =
    .label = საიტის ფაილებისა და მონაცემების წაშლა…
identity-connection-not-secure-security-view = თქვენი კავშირი ამ საიტთან არაა დაცული.
identity-connection-verified = თქვენ საიმედოდ ხართ დაკავშირებული ამ საიტთან.
identity-ev-owner-label = სერტიფიკატის მფლობელი:
identity-description-custom-root = Mozilla არ ცნობს ამ სერტიფიკატის გამცემს. იგი შეიძლება დამატებულია თქვენი საოპერაციო სისტემას ან მმართველი პირის მიერ. <label data-l10n-name="link">ვრცლად</label>
identity-remove-cert-exception =
    .label = გამონაკლისის წაშლა
    .accesskey = წ
identity-description-insecure = კავშირი ამ საიტთან დაუცველია. თქვენ მიერ გადაგზავნილი ინფორმაცია შესაძლოა სხვებმაც ნახონ (მაგალითად პაროლები, შეტყობინებები, საკრედიტო ბარათების ნომრები და ა. შ.).
identity-description-insecure-login-forms = ამ გვერდზე შეყვანილი ანგარიშის მონაცემები დაუცველია და შესაძლოა მოიპარონ.
identity-description-weak-cipher-intro = საიტთან კავშირი სუსტ დაშიფვრას იყენებს და დაუცველია.
identity-description-weak-cipher-risk = სხვებსაც შეუძლიათ თქვენი ინფორმაციის ნახვა ან ვებსაიტის ქცევის შეცვლა.
identity-description-active-blocked = { -brand-short-name } ზღუდავს გვერდის დაუცველ ნაწილებს. <label data-l10n-name="link">ვრცლად</label>
identity-description-passive-loaded = კავშირი დაუცველია და თქვენ მიერ ამ საიტთან გაზიარებული პირადი მონაცემები, შესაძლოა სხვებმაც ნახონ.
identity-description-passive-loaded-insecure = ეს ვებსაიტი შეიცავს შიგთავსს, რომელიც დაუცველია (მაგალითად სურათები). <label data-l10n-name="link">ვრცლად</label>
identity-description-passive-loaded-mixed = მიუხედავად იმისა, რომ { -brand-short-name } ზღუდავს გარკვეულ შიგთავსს, დაუცველი ნაწილი მაინც რჩება (მაგალითად სურათები). <label data-l10n-name="link">ვრცლად</label>
identity-description-active-loaded = საიტი შეიცავს შიგთავსს, რომელიც დაუცველია (როგორიცაა სკრიპტები) და მასთან კავშირი, ვერ უზრუნველყოფს პირადი მონაცემების უსაფრთხოებას.
identity-description-active-loaded-insecure = ინფორმაცია, რომელსაც ამ საიტს გაუზიარებთ შესაძლოა სხვებმაც ნახონ (მაგალითად პაროლები, შეტყობინებები, საკრედიტო ბარათები, ა. შ.).
identity-learn-more =
    .value = ვრცლად
identity-disable-mixed-content-blocking =
    .label = დაცვის გამორთვა დროებით
    .accesskey = დ
identity-enable-mixed-content-blocking =
    .label = დაცვის ჩართვა
    .accesskey = რ
identity-more-info-link-text =
    .label = ვრცლად

## Window controls

browser-window-minimize-button =
    .tooltiptext = ჩაკეცვა
browser-window-maximize-button =
    .tooltiptext = გაშლა
browser-window-restore-down-button =
    .tooltiptext = შემცირება
browser-window-close-button =
    .tooltiptext = დახურვა

## WebRTC Pop-up notifications

popup-select-camera =
    .value = გასაზიარებელი კამერა:
    .accesskey = კ
popup-select-microphone =
    .value = გასაზიარებელი მიკროფონი:
    .accesskey = მ
popup-all-windows-shared = ეკრანზე ნაჩვენები ყველა ფანჯარა გაზიარდება.
popup-screen-sharing-not-now =
    .label = ახლა არა
    .accesskey = ლ
popup-screen-sharing-never =
    .label = არასდროს დაიშვას
    .accesskey = ა
popup-silence-notifications-checkbox = შეჩერდეს შეტყობინებები, როცა { -brand-short-name } აზიარებს
popup-silence-notifications-checkbox-warning = { -brand-short-name } არ გამოაჩენს შეტყობინებებს მაშინ, როცა რამეს აზიარებთ.

## WebRTC window or screen share tab switch warning

sharing-warning-window = თქვენ გაზიარებული გაქვთ { -brand-short-name }. სხვები დაინახავენ, ახალ ჩანართზე რომ გადახვალთ.
sharing-warning-screen = თქვენ გაზიარებული გაქვთ მთლიანი ეკრანი. სხვები დაინახავენ, ახალ ჩანართზე რომ გადახვალთ.
sharing-warning-proceed-to-tab =
    .label = ჩანართზე გაგრძელება
sharing-warning-disable-for-session =
    .label = ამ სეანსზე გაზიარების დაცვის გამორთვა

## DevTools F12 popup

enable-devtools-popup-description = F12 მალსახმობის გამოსაყენებლად, ჯერ გახსენით DevTools, ვებშემუშავების მენიუდან.

## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = მოძებნეთ ან შეიყვანეთ მისამართი
# This placeholder is used when not in search mode and the user's default search
# engine is unknown.
urlbar-placeholder =
    .placeholder = მოძებნეთ ან შეიყვანეთ მისამართი
# This placeholder is used in search mode with search engines that search the
# entire web.
# Variables
#  $name (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-placeholder-search-mode-web-2 =
    .placeholder = ინტერნეტში ძიება
    .aria-label = { $name } ძიება
# This placeholder is used in search mode with search engines that search a
# specific site (e.g., Amazon).
# Variables
#  $name (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-placeholder-search-mode-other-engine =
    .placeholder = მიუთითეთ საძიებო ფრაზა
    .aria-label = ძიება { $name }
# This placeholder is used when searching bookmarks.
urlbar-placeholder-search-mode-other-bookmarks =
    .placeholder = მიუთითეთ საძიებო ფრაზა
    .aria-label = ძიება სანიშნებში
# This placeholder is used when searching history.
urlbar-placeholder-search-mode-other-history =
    .placeholder = მიუთითეთ საძიებო ფრაზა
    .aria-label = ძიება ისტორიაში
# This placeholder is used when searching open tabs.
urlbar-placeholder-search-mode-other-tabs =
    .placeholder = მიუთითეთ საძიებო ფრაზა
    .aria-label = ძიება ჩანართებში
# Variables
#  $name (String): the name of the user's default search engine
urlbar-placeholder-with-name =
    .placeholder = მოძებნეთ { $name } საძიებოთი ან შეიყვანეთ მისამართი
urlbar-remote-control-notification-anchor =
    .tooltiptext = ბრაუზერი იმყოფება დაშორებული მართვის ქვეშ
urlbar-permissions-granted =
    .tooltiptext = ამ საიტისთვის დამატებითი უფლებები გაქვთ მინიჭებული.
urlbar-switch-to-tab =
    .value = გადასვლა ჩანართზე:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = გაფართოება:
urlbar-go-button =
    .tooltiptext = მისამართზე გადასვლა
urlbar-page-action-button =
    .tooltiptext = ვებგვერდზე მოქმედებები
urlbar-pocket-button =
    .tooltiptext = { -pocket-brand-name }-ში შენახვა

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> სრულ ეკრანზეა
fullscreen-warning-no-domain = დოკუმენტი სრულ ეკრანზეა
fullscreen-exit-button = სრული ეკრანიდან გამოსვლა (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = სრული ეკრანიდან გამოსვლა (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> მართავს თქვენს მაჩვენებელს. მართვის დასაბრუნებლად დააჭირეთ Esc ღილაკს.
pointerlock-warning-no-domain = ეს დოკუმენტი მართავს თქვენს მაჩვენებელს. მართვის დასაბრუნებლად დააჭირეთ Esc ღილაკს.
