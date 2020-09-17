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
    .data-title-private = { -brand-full-name } (একান্ত ব্রাউজিং)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (একান্ত ব্রাউজিং)
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
    .data-title-private = { -brand-full-name } - (একান্ত ব্রাউজিং)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (একান্ত ব্রাউজিং)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = সাইটের তথ্য দেখাও

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = ইনস্টল বার্তা প্যানেল খুলুন
urlbar-web-notification-anchor =
    .tooltiptext = এই সাইটটি থেকে আপনি নোটিফিকেশন গ্রহণ করতে পারবেন কিনা তা পরিবর্তন করুন
urlbar-midi-notification-anchor =
    .tooltiptext = MIDI প্যানেল খুলুন
urlbar-eme-notification-anchor =
    .tooltiptext = DRM সফটওয়্যারের ব্যবহার নিয়ন্ত্রণ করুন
urlbar-web-authn-anchor =
    .tooltiptext = Web Authentication প্যানেল খুলুন
urlbar-canvas-notification-anchor =
    .tooltiptext = ক্যানভাস এক্সট্রাকশন অনুমোদন ব্যবস্থাপনা
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = সাইটটির সাথে আপনার মাইক্রোফোন শেয়ার নিয়ন্ত্রণ করুন
urlbar-default-notification-anchor =
    .tooltiptext = বার্তা প্যানেল খুলুন
urlbar-geolocation-notification-anchor =
    .tooltiptext = অবস্থান অনুরোধ প্যানেল খুলুন
urlbar-xr-notification-anchor =
    .tooltiptext = ভার্চুয়াল রিয়েলিটি অনুমোদন প্যানেলে যান
urlbar-storage-access-anchor =
    .tooltiptext = ব্রাউজিং কার্যকলাপ অনুমতি প্যানেল খুলুন
urlbar-translate-notification-anchor =
    .tooltiptext = এই পাতাটি অনুবাদ করুন
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = সাইটটির সাথে আপনার উইন্ডোজ কিংবা স্ক্রিন শেয়ার নিয়ন্ত্রণ করুন
urlbar-indexed-db-notification-anchor =
    .tooltiptext = অফলাইন স্টোরেজ বার্তা প্যানেল খুলুন
urlbar-password-notification-anchor =
    .tooltiptext = পাসওয়ার্ড সংরক্ষণ বার্তা প্যানেল খুলুন
urlbar-translated-notification-anchor =
    .tooltiptext = পাতার অনুবাদ নিয়ন্ত্রণ করুন
urlbar-plugins-notification-anchor =
    .tooltiptext = প্লাগ-ইন ব্যবহার পরিচালনা করুন
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = সাইটটির সাথে আপনার ক্যামেরা এবং/কিংবা মাইক্রোফোন শেয়ার নিয়ন্ত্রণ করুন
urlbar-autoplay-notification-anchor =
    .tooltiptext = অটোপ্লে প্যানেল খুলুন
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = পার্সিস্টেন্ট স্টোরেজে ডাটা স্টোর করুন
urlbar-addons-notification-anchor =
    .tooltiptext = অ্যাড-অন ইনস্টলেশন বার্তা প্যানেল খুলুন
urlbar-tip-help-icon =
    .title = সাহায্য নিন
urlbar-search-tips-confirm = ঠিক আছে, বুঝতে পেরেছি
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = পরামর্শ:

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = কম লিখে, বেশি অনুসন্ধান ফলাফল পান: ঠিকানাবার থেকেই { $engineName } খুঁজুন।

## Local search mode indicator labels in the urlbar


##

urlbar-geolocation-blocked =
    .tooltiptext = আপনি এই ওয়েবসাইটের জন্য অবস্থানগত তথ্য ব্লক করেছেন
urlbar-web-notifications-blocked =
    .tooltiptext = আপনি এই ওয়েব সাইটের জন্য ঘোষণা ব্লক করেছেন।
urlbar-camera-blocked =
    .tooltiptext = আপনি এই ওয়েব সাইটের জন্য আপনার ক্যামেরা ব্লক করেছেন।
urlbar-microphone-blocked =
    .tooltiptext = আপনি এই ওয়েব সাইটের জন্য আপনার মাইক্রোফোন ব্লক করেছেন
urlbar-screen-blocked =
    .tooltiptext = আপনি ওয়েবসাইটটিকে ব্লক করেছেন যেন আপনার স্ক্রিন শেয়ার না হয়
urlbar-persistent-storage-blocked =
    .tooltiptext = আপনি এই ওয়েব সাইটের জন্য পার্সিস্টেন্ট স্টোরেজ ব্লক করেছেন।
urlbar-popup-blocked =
    .tooltiptext = আপনি এই ওয়েবসাইটের জন্য পপ-আপ ব্লক করেছেন।
urlbar-autoplay-media-blocked =
    .tooltiptext = আপনি এই ওয়েবসাইটের সাউন্ড মিডিয়া অটোপ্লে ব্লক করেছেন।
urlbar-canvas-blocked =
    .tooltiptext = আপনি এই ওয়েবসাইটের জন্য ক্যানভাস ডেটা নিষ্কাশন অবরোধ করেছেন।
urlbar-midi-blocked =
    .tooltiptext = আপনি সাইটটির জন্য MIDI এর প্রবেশ ব্লক করেছেন।
urlbar-install-blocked =
    .tooltiptext = আপনি এই ওয়েবসাইটের জন্য অ্যাড-অন ইনস্টলেশন বন্ধ করেছেন।
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = এই বুকমার্কটি সম্পাদনা ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = পাতাটি বুকমার্ক করুন ({ $shortcut })

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = ঠিকানা বারে যোগ করুন
page-action-manage-extension =
    .label = এক্সটেনশন ব্যবস্থাপনা...
page-action-remove-from-urlbar =
    .label = ঠিকানা  বার থেকে অপসারণ করুন
page-action-remove-extension =
    .label = এক্সটেনশন অপসারণ করুন

## Auto-hide Context Menu

full-screen-autohide =
    .label = টুলবার আড়াল
    .accesskey = H
full-screen-exit =
    .label = পূর্ণ পর্দাজুড়ে প্রদর্শন মোড থেকে প্রস্থান
    .accesskey = F

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of one-click search engines in
# the Urlbar and searchbar.
search-one-offs-with-title = এবার এর সাথে অনুসন্ধান করুন:
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = অনুসন্ধান সেটিং বদল করুন
search-one-offs-change-settings-compact-button =
    .tooltiptext = অনুসন্ধান সেটিংস পরিবর্তন করুন
search-one-offs-context-open-new-tab =
    .label = নতুন ট্যাবে অনুসন্ধান
    .accesskey = T
search-one-offs-context-set-as-default =
    .label = ডিফল্ট অনুসন্ধান ইঞ্জিন হিসেবে সেট করুন
    .accesskey = D
search-one-offs-context-set-as-default-private =
    .label = ব্যক্তিগত উইন্ডোর জন্য ডিফল্ট অনুসন্ধান ইঞ্জিন হিসেবে সেট করুন
    .accesskey = P

## Local search mode one-off buttons
## Variables:
##  $restrict (String): The restriction token corresponding to the search mode.
##    Restriction tokens are special characters users can type in the urlbar to
##    restrict their searches to certain sources (e.g., "*" to search only
##    bookmarks).


## Bookmark Panel

bookmark-panel-show-editor-checkbox =
    .label = সংরক্ষণ করার সময় সম্পাদক দেখাও
    .accesskey = S
bookmark-panel-done-button =
    .label = সম্পন্ন
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

identity-connection-not-secure = সংযোগ নিরাপদ নয়
identity-connection-secure = সংযোগ সুরক্ষিত
identity-connection-internal = এটি একটি সুরক্ষিত { -brand-short-name } পাতা।
identity-connection-file = এই পাতা আপনার কম্পিউটারে জমা হয়েছে।
identity-extension-page = এই পাতাটি কোন এক্সটেনশন থেকে লোড হয়েছে।
identity-active-blocked = { -brand-short-name } নিরাপদ নয় তাই এই পাতার অংশ ব্লক করা হয়েছে।
identity-custom-root = Mozilla দ্বারা স্বীকৃত নয় এমন প্রশংসাপত্র জারিকারী দ্বারা সংযোগ যাচাই করা হয়েছে।
identity-passive-loaded = এই পাতার অংশগুলো নিরাপদ নয় (যেমন ছবি)।
identity-active-loaded = আপনি এই পাতায় সুরক্ষা বন্ধ করেছেন।
identity-weak-encryption = এই পাতা দুর্বল এনক্রিপশন ব্যবহার করে।
identity-insecure-login-forms = এই পাতায় লগইন করতে যে তথ্য দিয়েছেন তা চুরি হতে পারে।
identity-permissions =
    .value = অনুমোদন
identity-permissions-reload-hint = পরিবর্তনগুলি প্রয়োগ করার জন্য আপনাকে পাতাটি পুনরায় লোড করার প্রয়োজন হতে পারে।
identity-permissions-empty = আপনি এই সাইটের জন্য কোনো বিশেষ অনুমতি দেননি।
identity-clear-site-data =
    .label = কুকি এবং সাইট ডাটা পরিষ্কার করুন…
identity-connection-not-secure-security-view = এই সাইটে আপনার সংযোগ সুরক্ষিত নয়।
identity-connection-verified = আপনি সুরক্ষিতভাবে এই সাইটে সংযুক্ত হয়েছেন।
identity-ev-owner-label = সার্টিফিকেট দেওয়া হয়েছে:
identity-description-custom-root = Mozilla এই সার্টিফিকেট আনুমোদনকারীকে চিনতে পারছে না। এটি আপনার অপারেটিং সিস্টেম বা প্রশাসক দ্বারা যুক্ত করা হতে পারে। <label data-l10n-name="link">আরও জানুন</label>
identity-remove-cert-exception =
    .label = ব্যাতিক্রম সরিয়ে ফেলুন
    .accesskey = R
identity-description-insecure = এই সাইট এ আপনার সংযোগ ব্যক্তিগত নয়। আপনার জমা দেওয়া তথ্য অন্যদের দ্বারা দেখা যেতে পারে। (যেমন পাসওয়ার্ড, বার্তা, ক্রেডিট কার্ড ইত্যাদি)।
identity-description-insecure-login-forms = আপনি এই পাতায় লগইন করতে যে তথ্য দিয়েছেন তা নিরাপদ নয় এবং চুরিও হতে পারে।
identity-description-weak-cipher-intro = এই ওয়েবসাইটে আপনার সংযোগ দুর্বল এনক্রিপশন ব্যবহার করে এবং এটি ব্যক্তিগত নয়।
identity-description-weak-cipher-risk = যে কেউ আপনার দেয়া তথ্য দেখতে পারে বা ওয়েব সাইটের আচরন পরিবর্তন করতে পারে।
identity-description-active-blocked = { -brand-short-name } নিরাপদ নয় তাই এই পাতার কিছু অংশ ব্লক করা হয়েছে। <label data-l10n-name="link">আরও জানুন</label>
identity-description-passive-loaded = আপনার সংযোগটি ব্যক্তিগত নয় এবং এই সাইটে আপনার শেয়ার করা তথ্য অন্যদের দ্বারা দেখা যেতে পারে।
identity-description-passive-loaded-insecure = এই ওয়েবসাইটে এমন কিছু কন্টেন্ট রয়েছে যা নিরাপদ নয় (যেমন ছবি)। <label data-l10n-name="link">আরও জানুন</label>
identity-description-passive-loaded-mixed = যদিও { -brand-short-name } কিছু কন্টেন্ট প্রতিরোধ করেছে, তবুও পাতাটিতে এখনও কিছু কন্টেন্ট আছে যা নিরাপদ নয় (যেমন ছবি)। <label data-l10n-name="link">আরও জানুন</label>
identity-description-active-loaded = এই ওয়েবসাইটে যে বিষয়বস্তু রয়েছে তা নিরাপদ নয় (যেমন স্ক্রিপ্ট) এবং আপনার সংযোগটি ব্যক্তিগত নয়।
identity-description-active-loaded-insecure = আপনার এই সাইটে শেয়ার করা তথ্য অন্যরা দেখতে পারেন (যেমন পাসওয়ার্ড, বার্তা, ক্রেডিট কার্ড, ইত্যাদি।)।
identity-learn-more =
    .value = আরও জানুন
identity-disable-mixed-content-blocking =
    .label = এখন সুরক্ষা নিষ্ক্রিয় করুন
    .accesskey = এ
identity-enable-mixed-content-blocking =
    .label = E ইমেইলের নিরাপত্তা
    .accesskey = E
identity-more-info-link-text =
    .label = আরও তথ্য

## Window controls

browser-window-minimize-button =
    .tooltiptext = ন্যূনতম বিস্তার
browser-window-maximize-button =
    .tooltiptext = বড় করুন
browser-window-close-button =
    .tooltiptext = বন্ধ

## WebRTC Pop-up notifications

popup-select-camera =
    .value = যেসকল ক্যামেরা শেয়ার করা হবে: C
    .accesskey = C
popup-select-microphone =
    .value = যেসকল মাইক্রোফোন শেয়ার করা হবে: M
    .accesskey = M
popup-all-windows-shared = আপনার স্ক্রিনের সব দৃশ্যমান উইন্ডো শেয়ার করা হবে।

## WebRTC window or screen share tab switch warning


## DevTools F12 popup

enable-devtools-popup-description = F12 শর্টকাট ব্যবহার করতে, প্রথমে ওয়েব ডেভেলপার মেনু থেকে DevTools খুলুন।

## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = অনুসন্ধান বা ঠিকানা দিন
urlbar-placeholder =
    .placeholder = অনুসন্ধান বা ঠিকানা দিন
urlbar-remote-control-notification-anchor =
    .tooltiptext = ব্রাউজার রিমোর্ট কন্ট্রোলের আওতায়
urlbar-permissions-granted =
    .tooltiptext = আপনি এই সাইটের জন্য বিশেষ অনুমতি দিয়েছেন।
urlbar-switch-to-tab =
    .value = ট্যাবে যান:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = এক্সটেনশন:
urlbar-go-button =
    .tooltiptext = ঠিকানার বারে উল্লেখিত পাতা প্রদর্শন করা হবে
urlbar-page-action-button =
    .tooltiptext = পাতা পদক্ষেপ
urlbar-pocket-button =
    .tooltiptext = { -pocket-brand-name } এ সংরক্ষণ করুন

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> এখন পূর্ণ পর্দায় রয়েছে
fullscreen-warning-no-domain = এই ডকুমেন্ট এখন পূর্ণ পর্দায় রয়েছে
fullscreen-exit-button = পূর্ণ পর্দা বন্ধ করুন (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = পূর্ণ পর্দা বন্ধ করুন (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> আপনার পয়েন্টারের নিয়ন্ত্রণ রয়েছে। পুনরায় নিয়ন্ত্রণ নিতে Esc চাপুন।
pointerlock-warning-no-domain = এই নথিতে পয়েন্টারের নিয়ন্ত্রণ রয়েছে। পুনরায় নিয়ন্ত্রণ নিতে Esc চাপুন।
