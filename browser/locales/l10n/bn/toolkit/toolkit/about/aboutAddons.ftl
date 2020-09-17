# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = অ্যাড-অন ব্যবস্থাপক

addons-page-title = অ্যাড-অন ব্যবস্থাপক

search-header =
    .placeholder = addons.mozilla.org এ অনুসন্ধান করুন
    .searchbuttonlabel = অনুসন্ধান

search-header-shortcut =
    .key = f

list-empty-installed =
    .value = আপনার এই ধরণের কোনো অ্যাড-অন ইনস্টল করা নেই

list-empty-available-updates =
    .value = কোনো হালনাগাদ পাওয়া যায়নি

list-empty-recent-updates =
    .value = আপনি সাম্প্রতিক সময়ে কোনো অ্যাড-অন হালনাগাদ করেননি

list-empty-find-updates =
    .label = হালনাগাদের জন্য পরীক্ষা

list-empty-button =
    .label = অ্যাড-অন সম্পর্কে আরও শিখুন

help-button = অ্যাড-অন সহযোগীতা

sidebar-help-button-title =
    .title = অ্যাড-অন সহযোগীতা

preferences =
    { PLATFORM() ->
        [windows] { -brand-short-name } অপশন
       *[other] { -brand-short-name } পছন্দসমূহ
    }

sidebar-preferences-button-title =
    .title =
        { PLATFORM() ->
            [windows] { -brand-short-name } অপশন
           *[other] { -brand-short-name } পছন্দসমূহ
        }

show-unsigned-extensions-button =
    .label = কিছু এক্সটেনশন ভ্যারিফাই করা হয়নি

show-all-extensions-button =
    .label = সব এক্সটেনশন দেখাও

cmd-show-details =
    .label = আরও তথ্য প্রদর্শন করা হবে S
    .accesskey = S

cmd-find-updates =
    .label = হালনাগাদ অনুসন্ধান
    .accesskey = F

cmd-preferences =
    .label =
        { PLATFORM() ->
            [windows] অপশন
           *[other] পছন্দসমূহ
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] P
        }

cmd-enable-theme =
    .label = থীম যোগ W
    .accesskey = W

cmd-disable-theme =
    .label = থীম যোগ বন্ধ W
    .accesskey = W

cmd-install-addon =
    .label = ইনস্টল করুন I
    .accesskey = I

cmd-contribute =
    .label = অবদান রাখুন C
    .accesskey = C
    .tooltiptext = অ্যাড-অন উন্নয়নে অবদান রাখুন

detail-version =
    .label = সংস্করণ

detail-last-updated =
    .label = সর্বশেষ হালনাগাদ

detail-contributions-description = এ অ্যাড-অন ডেভেলপার বলে যে, আপনি আপনার যে কোনো ছোট অবদান দিয়েও এই অ্যাড-অনের উন্নয়নে সহায়তা করতে পারেন।

detail-contributions-button = অবদান রাখুন
    .title = এই অ্যাড-অনের বিকাশে অবদান রাখুন
    .accesskey = C

detail-update-type =
    .value = স্বয়ংক্রিয় হালনাগাদ

detail-update-default =
    .label = ডিফল্ট
    .tooltiptext = ডিফল্ট হলেই কেবল স্বয়ংক্রিয়ভাবে হালনাগাদ ইনস্টল করা হবে

detail-update-automatic =
    .label = সচল
    .tooltiptext = স্বয়ংক্রিয়ভাবে হালনাগাদ ইনস্টল করা হবে

detail-update-manual =
    .label = বন্ধ
    .tooltiptext = স্বয়ংক্রিয়ভাবে হালনাগাদ ইনস্টল করা হবে না

# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = ব্যক্তিগত উইন্ডোতে রান করুন

# Some add-ons may elect to not run in private windows by setting incognito: not_allowed in the manifest.  This
# cannot be overridden by the user.
detail-private-disallowed-label = ব্যক্তিগত উইন্ডোতে অনুমোদিত নয়

detail-private-disallowed-description2 = ব্যক্তিগত ব্রাউজিং এর সময় এই এক্সটেনশন কাজ করবেনা।<a data-l10n-name="learn-more"> আরও জানুন </a>

# Some special add-ons are privileged, run in private windows automatically, and this permission can't be revoked
detail-private-required-label = ব্যক্তিগত উইন্ডোতে প্রবেশ প্রয়োজন

detail-private-required-description2 = ব্যক্তিগত ব্রাউজিং করার সময় এই এক্সটেনশন আপনার অনলাইন কর্মকান্ড সম্পর্কে জানতে পারে। <a data-l10n-name="learn-more"> আরও জানুন </a>

detail-private-browsing-on =
    .label = অনুমতি দিন
    .tooltiptext = ব্যক্তিগত ব্রাউজিং সক্রিয় করুন

detail-private-browsing-off =
    .label = অনুমতি দিবেন না
    .tooltiptext = ব্যক্তিগত ব্রাউজিং নিষ্ক্রিয় করুন

detail-home =
    .label = নীড়পাতা

detail-home-value =
    .value = { detail-home.label }

detail-repository =
    .label = অ্যাড-অন প্রোফাইল

detail-repository-value =
    .value = { detail-repository.label }

detail-check-for-updates =
    .label = হালনাগাদের জন্য পরীক্ষা
    .accesskey = f
    .tooltiptext = এই অ্যাড-অনের জন্য হালনাগাদ পরীক্ষা

detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] অপশন
           *[other] পছন্দসমূহ
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] P
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] এই অ্যাড-অন এর অপশন পরিবর্তন করুন
           *[other] এই অ্যাড-অন এর পছন্দসমূহ পরিবর্তন করুন
        }

detail-rating =
    .value = রেটিং

addon-restart-now =
    .label = এখন পুনরায় শুরু করুন

disabled-unsigned-heading =
    .value = কিছু অ্যাড-অন নিস্ক্রিয় করা হয়েছে

disabled-unsigned-description = নিম্নলিখিত অ্যাড-অনসমূহ { -brand-short-name } ব্যবহারের জন্য যাচাই করা হয় নি। আপনি যা করতে পারেন <label data-l10n-name="find-addons">প্রতিস্থাপন খুঁজুন</label> অথবা ডেভেলপার কে জিজ্ঞাসা করুন যাচাই করার জন্য

disabled-unsigned-learn-more = আপনাকে অনলাইনে নিরাপদ রাখতে সাহায্য করতে আমাদের প্রচেষ্টা সম্পর্কে আরও জানুন.

disabled-unsigned-devinfo = পড়ার অবিরত করতে পারেন যাচাই তাদের অ্যাড টার্ন পেতে আগ্রহী ডেভেলপারদের আমাদের <label data-l10n-name="learn-more">ম্যানুয়াল</label>।

plugin-deprecation-description = কোন কিছু পাওয়া যাচ্ছে না? কোন কোন প্লাগইন { -brand-short-name } আর সমর্থন করে না। <label data-l10n-name="learn-more">আরও জানুন।</label>

legacy-warning-show-legacy = সব পুরাতন এক্সটেনশন দেখাও

legacy-extensions =
    .value = লিগ্যাসি এক্সটেনশন

legacy-extensions-description = এই এক্সটেনশন বর্তমান { -brand-short-name } মান পূরণ করে না তাই তাদের নিষ্ক্রিয় করা হয়েছে। <label data-l10n-name="legacy-learn-more">অ্যাড-অন এ পরিবর্তন সম্পর্কে আরও জানুন</label>

addon-category-discover = সুপারিশসমূহ
addon-category-discover-title =
    .title = সুপারিশসমূহ
addon-category-extension = এক্সটেনশন
addon-category-extension-title =
    .title = এক্সটেনশন
addon-category-theme = থিম
addon-category-theme-title =
    .title = থিম
addon-category-plugin = প্লাগইন
addon-category-plugin-title =
    .title = প্লাগইন
addon-category-dictionary = অভিধান সমূহ
addon-category-dictionary-title =
    .title = অভিধান সমূহ
addon-category-locale = ভাষা
addon-category-locale-title =
    .title = ভাষা
addon-category-available-updates = বিদ্যমান হালনাগাদ
addon-category-available-updates-title =
    .title = বিদ্যমান হালনাগাদ
addon-category-recent-updates = সাম্প্রতিক হালনাগাদ
addon-category-recent-updates-title =
    .title = সাম্প্রতিক হালনাগাদ

## These are global warnings

extensions-warning-safe-mode = নিরাপদ মোড এর সাহায্যে সব অ্যাড-অন নিস্ক্রিয়।
extensions-warning-check-compatibility = অ্যাড-অনের উপযুক্ততা পরীক্ষা নিস্ক্রিয়। আপনার অ্যাড-অন অনুপোযুক্ত হতে পারে।
extensions-warning-check-compatibility-button = সক্রিয়
    .title = অ্যাড-অনের উপযুক্ততা পরীক্ষা সক্রিয়
extensions-warning-update-security = অ্যাড-অন হালনাগাদকরন পরীক্ষা নিস্ক্রিয়। আপনি সম্ভবত হালনাগাদকরনের সাথে আপোষ করে নিয়েছেন।
extensions-warning-update-security-button = সক্রিয়
    .title = অ্যাড-অন হালনাগাদকরন নিরাপত্তা পরীক্ষা করা সক্রিয়


## Strings connected to add-on updates

addon-updates-check-for-updates = হালনাগাদের জন্য পরীক্ষা
    .accesskey = C
addon-updates-view-updates = সাম্প্রতিক হালনাগাদ দেখাও
    .accesskey = V

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = স্বয়ংক্রিয়ভাবে অ্যাড-অন হালনাগাদ
    .accesskey = A

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = সব অ্যাড-অন স্বয়ংক্রিয়ভাবে হালনাগাদ করার জন্য পুন:নির্ধারন করা হবে R
    .accesskey = R
addon-updates-reset-updates-to-manual = সব অ্যাড-অন নিজ হাতে হালনাগাদ করার জন্য পুন:নির্ধারন করা হবে R
    .accesskey = R

## Status messages displayed when updating add-ons

addon-updates-updating = অ্যাড-অন হালনাগাদ করা হচ্ছে
addon-updates-installed = আপনার সকল অ্যাড-অন হালনাগাদ করা হয়েছে।
addon-updates-none-found = কোনো হালনাগাদ পাওয়া যায়নি
addon-updates-manual-updates-found = বিদ্যমান হালনাগাদ প্রদর্শিত হবে

## Add-on install/debug strings for page options menu

addon-install-from-file = ফাইল থেকে অ্যাড-অন ইনস্টল… I
    .accesskey = I
addon-install-from-file-dialog-title = ইনস্টল করার জন্য অ্যাড-অন নির্বাচন
addon-install-from-file-filter-name = অ্যাড-অন
addon-open-about-debugging = অ্যাড-অন ডিবাগ
    .accesskey = b

## Extension shortcut management

# This is displayed in the page options menu
addon-manage-extensions-shortcuts = এক্সটেনশন এর শর্টকাট পরিচালনা করুন
    .accesskey = S

shortcuts-no-addons = আপনার কোনো এক্সটেনশন সক্রিয় নেই।
shortcuts-no-commands = উল্লেখিত এক্সটেনশনের শর্টকাট নেই:
shortcuts-input =
    .placeholder = একটি শর্টকাট টাইপ করুন

shortcuts-pageAction = পাতার কর্ম সক্রিয় করুন
shortcuts-sidebarAction = সাইডবার টগল করুন

shortcuts-modifier-mac = Ctrl, Alt, অথবা ⌘ যুক্ত করুন
shortcuts-modifier-other = Ctrl বা Alt যুক্ত করুন
shortcuts-invalid = অকার্যকর সমন্বয়
shortcuts-letter = একটি চিঠি লিখুন
shortcuts-system = { -brand-short-name } শর্টকাট ওভাররাইড করা যাবে না

# String displayed in warning label when there is a duplicate shortcut
shortcuts-duplicate = সদৃশ শর্টকাট

# String displayed when a keyboard shortcut is already assigned to more than one add-on
# Variables:
#   $shortcut (string) - Shortcut string for the add-on
shortcuts-duplicate-warning-message = { $shortcut } একাধিক ক্ষেত্রে শর্টকাট হিসাবে ব্যবহৃত হচ্ছে। সদৃশ শর্টকাটগুলি অপ্রত্যাশিত আচরণের কারণ হতে পারে।

# String displayed when a keyboard shortcut is already used by another add-on
# Variables:
#   $addon (string) - Name of the add-on
shortcuts-exists = { $addon } দ্বারা ইতিমধ্যে ব্যবহৃত

shortcuts-card-expand-button =
    { $numberToShow ->
        [one] আরও { $numberToShow } দেখাও
       *[other] আরও { $numberToShow } দেখাও
    }

shortcuts-card-collapse-button = কম দেখাও

header-back-button =
    .title = ফিরে যাও

## Recommended add-ons page

# Explanatory introduction to the list of recommended add-ons. The action word
# ("recommends") in the final sentence is a link to external documentation.
discopane-intro =
    এক্সটেনশন এবং থীমগুলি আপনার ব্রাউজারের অ্যাপের মত, এবং এদের মাধ্যমে আপনি 
    পাসওয়ার্ড সুরক্ষা, ভিডিও ডাউনলোড, ডিল খোঁজা, বিরক্তিকর অ্যাড ব্লক করা, ব্রাউজারের চেহারা 
    বদলসহ আরও অনেক কিছু করতে পারেন। এইসব ছোট ছোট সফটওয়্যার প্রোগ্রাম অনেক সময়
    তৃতীয় কারও দ্বারা তৈরি করা হয়। অসাধারণ নিরাপত্তা, কর্মক্ষমতা এবং কার্যকারিতার জন্য এখানে 
    { -brand-product-name } <a data-l10n-name="learn-more-trigger">সুপারিশ</a>।

# Notice to make user aware that the recommendations are personalized.
discopane-notice-recommendations =
    এর মধ্যে কিছু সুপারিশ পারসোনালাইজ সম্পর্কিত। এদের ভিত্তি অন্য
     যেসব এক্সটেনশন আপনি ইন্সটল করেছেন, আপনার প্রোফাইল পছন্দসমূহ এবং ব্যাবহারের পরিসংখ্যান।
discopane-notice-learn-more = আরও জানুন

privacy-policy = গোপনীয়তা নীতি

# Refers to the author of an add-on, shown below the name of the add-on.
# Variables:
#   $author (string) - The name of the add-on developer.
created-by-author = <a data-l10n-name="author">{ $author }</a> দ্বারা
# Shows the number of daily users of the add-on.
# Variables:
#   $dailyUsers (number) - The number of daily users.
user-count = ব্যবহারকারী: { $dailyUsers }
install-extension-button = { -brand-product-name } এ যোগ করুন
install-theme-button = থিম ইন্সটল করুন
# The label of the button that appears after installing an add-on. Upon click,
# the detailed add-on view is opened, from where the add-on can be managed.
manage-addon-button = পরিচালনা
find-more-addons = আরও অ্যাড-অন খুঁজুন

# This is a label for the button to open the "more options" menu, it is only
# used for screen readers.
addon-options-button =
    .aria-label = আরও অপশন

## Add-on actions

report-addon-button = রিপোর্ট
remove-addon-button = অপসারণ
# The link will always be shown after the other text.
remove-addon-disabled-button = সরানো যাবে না <a data-l10n-name="link">কেনো?</a>
disable-addon-button = নিষ্ক্রিয়
enable-addon-button = সক্রিয়
preferences-addon-button =
    { PLATFORM() ->
        [windows] বিকল্প
       *[other] পছন্দসমূহ
    }
details-addon-button = বিশদ বিবরণ
release-notes-addon-button = রিলিজ নোট
permissions-addon-button = অনুমতিসমূহ

extension-enabled-heading = সক্রিয়
extension-disabled-heading = নিষ্ক্রিয়

theme-enabled-heading = সক্রিয়
theme-disabled-heading = নিষ্ক্রিয়

plugin-enabled-heading = সক্রিয়
plugin-disabled-heading = নিষ্ক্রিয়

dictionary-enabled-heading = সক্রিয়
dictionary-disabled-heading = নিষ্ক্রিয়

locale-enabled-heading = সক্রিয়
locale-disabled-heading = নিষ্ক্রিয়

ask-to-activate-button = সক্রিয় করতে জিজ্ঞাসা করুন
always-activate-button = সর্বদা সক্রিয়
never-activate-button = কখনোই সক্রিয় নয়

addon-detail-author-label = লেখক
addon-detail-version-label = সংস্করণ
addon-detail-last-updated-label = সর্বশেষ হালনাগাদ
addon-detail-homepage-label = হোমপেজ
addon-detail-rating-label = রেটিং

# The average rating that the add-on has received.
# Variables:
#   $rating (number) - A number between 0 and 5. The translation should show at most one digit after the comma.
five-star-rating =
    .title = 5 এর ভেতর মান { NUMBER($rating, maximumFractionDigits: 1) }

# This string is used to show that an add-on is disabled.
# Variables:
#   $name (string) - The name of the add-on
addon-name-disabled = { $name } (নিষ্ক্রিয়)

# The number of reviews that an add-on has received on AMO.
# Variables:
#   $numberOfReviews (number) - The number of reviews received
addon-detail-reviews-link =
    { $numberOfReviews ->
        [one] { $numberOfReviews } পর্যালোচনা
       *[other] { $numberOfReviews } পর্যালোচনা
    }

## Pending uninstall message bar

# Variables:
#   $addon (string) - Name of the add-on
pending-uninstall-description = <span data-l10n-name="addon-name">{ $addon }</span> বাতিল করে দেয়া হয়েছে।
pending-uninstall-undo-button = পূর্বাবস্থায় ফিরে যান

addon-detail-updates-label = স্বয়ংক্রিয়ভাবে আপডেটের অনুমতি দিন
addon-detail-updates-radio-default = ডিফল্ট
addon-detail-updates-radio-on = সচল
addon-detail-updates-radio-off = বন্ধ
addon-detail-update-check-label = হালনাগাদ এর জন্য অনুসন্ধান করুন
install-update-button = হালনাগাদ

# This is the tooltip text for the private browsing badge in about:addons. The
# badge is the private browsing icon included next to the extension's name.
addon-badge-private-browsing-allowed2 =
    .title = ব্যক্তিগত উইন্ডোতে অনুমোদিত
    .aria-label = { addon-badge-private-browsing-allowed2.title }
addon-detail-private-browsing-help = অনুমতি পেলে, প্রাইভেট ব্রাউজ করার সময় এই এক্সটেনশনে আপনার অনলাইন কার্যতালিকা পাবে। <a data-l10n-name="learn-more">আরো জানুন</a>
addon-detail-private-browsing-allow = অনুমতি দাও
addon-detail-private-browsing-disallow = অনুমতি দিও না

# This is the tooltip text for the recommended badge for an extension in about:addons. The
# badge is a small icon displayed next to an extension when it is recommended on AMO.
addon-badge-recommended2 =
    .title = { -brand-product-name } কেবলমাত্র সেই সব এক্সটেনশনকে সুপারিশ করা হয় যা সুরক্ষা এবং কার্যক্ষমতার দিক দিয়ে আমাদের মানদণ্ড পূরণ করে
    .aria-label = { addon-badge-recommended2.title }

available-updates-heading = বিদ্যমান হালনাগাদ
recent-updates-heading = সাম্প্রতিক হালনাগাদ

release-notes-loading = লোডিং…
release-notes-error = দুঃখিত, রিলিজ নোট লোড করার সময় ত্রুটি হয়েছিল।

addon-permissions-empty = এই এক্সটেনশনের জন্য কোনো অনুমতির প্রয়োজন নেই

recommended-extensions-heading = প্রস্তাবিত এক্সটেনশনগুলি
recommended-themes-heading = প্রস্তাবিত থিমস

# A recommendation for the Firefox Color theme shown at the bottom of the theme
# list view. The "Firefox Color" name itself should not be translated.
recommended-theme-1 = সৃজনশীল মনে হচ্ছে? <a data-l10n-name="link">Firefox Color দিয়ে নিজের থিম তৈরি করুন।</a>

## Page headings

extension-heading = আপনার এক্সটেনশন ব্যবস্থাপনা
theme-heading = আপনার থিম ব্যবস্থাপনা
plugin-heading = আপনার প্লাগইন ব্যবস্থাপনা
dictionary-heading = আপনার অভিধান ব্যবস্থাপনা
locale-heading = আপনার ভাষা ব্যবস্থাপনা
updates-heading = আপনার হালনাগাদ পরিচালনা করুন
discover-heading = আপনার { -brand-short-name } নিজের মত করুন
shortcuts-heading = এক্সটেনশন শর্টকাট পরিচালনা করুন

addons-heading-search-input =
    .placeholder = addons.mozilla.org এ অনুসন্ধান করুন

addon-page-options-button =
    .title = সব অ্যাড-অন এর জন্য টুল
