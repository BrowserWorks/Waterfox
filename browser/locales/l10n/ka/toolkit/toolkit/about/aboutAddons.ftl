# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = დამატებების მმართველი
addons-page-title = დამატებების მმართველი

search-header =
    .placeholder = addons.mozilla.org საიტზე მოძიება
    .searchbuttonlabel = ძიება

search-header-shortcut =
    .key = f

list-empty-installed =
    .value = ამ სახის არცერთი დამატება არ გაქვთ დაყენებული

list-empty-available-updates =
    .value = განახლებები ვერ მოიძებნა

list-empty-recent-updates =
    .value = ბოლო დროს, არცერთი დამატება არ განგიახლებიათ.

list-empty-find-updates =
    .label = განახლებების შემოწმება

list-empty-button =
    .label = იხილეთ ვრცლად, დამატებების შესახებ

help-button = დამატებების მხარდაჭერა
sidebar-help-button-title =
    .title = დამატებების მხარდაჭერა

preferences =
    { PLATFORM() ->
        [windows] { -brand-short-name } პარამეტრები
       *[other] { -brand-short-name } პარამეტრები
    }
sidebar-preferences-button-title =
    .title =
        { PLATFORM() ->
            [windows] { -brand-short-name } პარამეტრები
           *[other] { -brand-short-name } პარამეტრები
        }

show-unsigned-extensions-button =
    .label = ზოგიერთი გაფართოება ვერ გადამოწმდა

show-all-extensions-button =
    .label = ყველა გაფართოების ჩვენება

cmd-show-details =
    .label = დამატებითი ინფორმაციის ჩვენება
    .accesskey = მ

cmd-find-updates =
    .label = განახლებების პოვნა
    .accesskey = პ

cmd-preferences =
    .label =
        { PLATFORM() ->
            [windows] პარამეტრები
           *[other] მითითებები
        }
    .accesskey =
        { PLATFORM() ->
            [windows] პ
           *[other] თ
        }

cmd-enable-theme =
    .label = თემის მორგება
    .accesskey = გ

cmd-disable-theme =
    .label = თემის მორგების შეჩერება
    .accesskey = გ

cmd-install-addon =
    .label = ჩადგმა
    .accesskey = ი

cmd-contribute =
    .label = შემოწირულობა
    .accesskey = წ
    .tooltiptext = შეიტანეთ წვლილი ამ დამატების შემუშავებაში

detail-version =
    .label = ვერსია

detail-last-updated =
    .label = ბოლო განახლება

detail-contributions-description = ამ დამატების შემქმნელი, პროგრამის მომავალი განვითარებისთვის, გთხოვთ მხარდაჭერას, მცირეოდენი შემოწირულობის სახით.

detail-contributions-button = შემოწირულობა
    .title = დამატების შემუშავებისთვის შემოწირულობის გაღება
    .accesskey = წ

detail-update-type =
    .value = თვითგანახლებები

detail-update-default =
    .label = ნაგულისხმევი
    .tooltiptext = განახლებების ავტომატურად დაყენება, თუ ნაგულისხმევადაა მითითებული.

detail-update-automatic =
    .label = ჩართვა
    .tooltiptext = განახლებების ავტომატურად დაყენება

detail-update-manual =
    .label = გამორთვა
    .tooltiptext = არ დაყენდეს განახლებები ავტომატურად

# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = პირად ფანჯრებში გაშვება

# Some add-ons may elect to not run in private windows by setting incognito: not_allowed in the manifest.  This
# cannot be overridden by the user.
detail-private-disallowed-label = არაა დაშვებული პირად ფანჯრებში
detail-private-disallowed-description2 = ეს გაფართოება არ გაეშვება პირადი თვალიერებისას. <a data-l10n-name="learn-more">ვრცლად</a>

# Some special add-ons are privileged, run in private windows automatically, and this permission can't be revoked
detail-private-required-label = საჭიროებს პირად ფანჯრებთან წვდომას
detail-private-required-description2 = ამ გაფართოებას ექნება წვდომა თქვენს მოქმედებებზე ინტერნეტში, პირადი თვალიერებისას. <a data-l10n-name="learn-more">ვრცლად</a>

detail-private-browsing-on =
    .label = დაშვება
    .tooltiptext = ჩართვა პირადი თვალიერებისას

detail-private-browsing-off =
    .label = შეზღუდვა
    .tooltiptext = გამორთვა პირადი თვალიერებისას

detail-home =
    .label = მთავარი გვერდი

detail-home-value =
    .value = { detail-home.label }

detail-repository =
    .label = დამატების პროფილი

detail-repository-value =
    .value = { detail-repository.label }

detail-check-for-updates =
    .label = განახლებების შემოწმება
    .accesskey = ბ
    .tooltiptext = ამ დამატების შემოწმება განახლებაზე

detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] გამართვა
           *[other] გამართვა
        }
    .accesskey =
        { PLATFORM() ->
            [windows] გ
           *[other] რ
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] ამ დამატების პარამეტრების შეცვლა
           *[other] ამ დამატების პარამეტრების შეცვლა
        }

detail-rating =
    .value = შეფასება

addon-restart-now =
    .label = ხელახლა გაშვება

disabled-unsigned-heading =
    .value = ზოგიერთი დამატება გამორთულია

disabled-unsigned-description = ეს დამატებები დაუმოწმებელია და { -brand-short-name } ვერ გამოიყენებს. შეგიძლიათ <label data-l10n-name="find-addons">მონახოთ შემცვლელები</label> ან სთხოვოთ შემქმნელს მათი დამოწმება.

disabled-unsigned-learn-more = შეიტყვეთ მეტი ჩვენი ძალისხმევის შესახებ, ინტერნეტში თქვენი უსაფრთხოების დაცვისთვის.

disabled-unsigned-devinfo = შემმუშავებლებს, რომელთაც თავიანთი დამატებების დამოწმება სურთ, შეუძლიათ განაგრძონ ჩვენი <label data-l10n-name="learn-more">სახელმძღვანელოს კითხვა</label>.

plugin-deprecation-description = რამეს ვერ პოულობთ? { -brand-short-name } აღარ იძლევა ზოგიერთი მოდულის გამოყენების შესაძლებლობას. <label data-l10n-name="learn-more">იხილეთ ვრცლად.</label>

legacy-warning-show-legacy = მოძველებული გაფართოებების ჩვენება

legacy-extensions =
    .value = მოძველებული გაფართოებები

legacy-extensions-description = ეს გაფართოებები არ შეესაბამება მოთხოვნებს, რომელთაც { -brand-short-name } ადგენს და შესაბამისად ამორთულია. <label data-l10n-name="legacy-learn-more">ვრცლად, დამატებებთან დაკავშირებული ცვლილებების შესახებ</label>

private-browsing-description2 =
    { -brand-short-name } ცვლის გაფართოებების მუშაობას პირადი თვალიერებისას. ნებისმიერ ახლად დაყენებულ დამატებას
    { -brand-short-name } არ გაუშვებს ნაგულისხმევად პირად ფანჯრებში. მანამ, სანამ თავად არ დაუშვებთ პარამეტრებიდან,
    გაფართოება ვერ იმუშავებს პირადი თვალიერებისას და არ ექნება წვდომა თქვენს მოქმედებებზე, გვერდების მონახულებისას.
    ეს ცვლილებები ემსახურება თქვენი პირადი მონაცემების უსაფრთხოებას ინტერნეტში.
    <label data-l10n-name="private-browsing-learn-more">იხილეთ, როგორ იმართება გაფართოებების პარამეტრები.</label>

addon-category-discover = შემოთავაზებები
addon-category-discover-title =
    .title = შემოთავაზებები
addon-category-extension = გაფართოებები
addon-category-extension-title =
    .title = გაფართოებები
addon-category-theme = თემები
addon-category-theme-title =
    .title = თემები
addon-category-plugin = მოდულები
addon-category-plugin-title =
    .title = მოდულები
addon-category-dictionary = ლექსიკონები
addon-category-dictionary-title =
    .title = ლექსიკონები
addon-category-locale = ენები
addon-category-locale-title =
    .title = ენები
addon-category-available-updates = ხელმისწვდომი განახლებები
addon-category-available-updates-title =
    .title = ხელმისწვდომი განახლებები
addon-category-recent-updates = ბოლო განახლებები
addon-category-recent-updates-title =
    .title = ბოლო განახლებები

## These are global warnings

extensions-warning-safe-mode = ყველა დამატება გამორთულია უსაფრთხო რეჟიმის მიერ.
extensions-warning-check-compatibility = დამატებების თავსებადობის შემოწმება გამორთულია. შესაძლოა არათავსებადი დამატებები გქონდეთ.
extensions-warning-check-compatibility-button = ჩართვა
    .title = დამატებების თავსებადობის შემოწმების ჩართვა
extensions-warning-update-security = დამატების განახლების უსაფრთხოების შემოწმება გამორთულია. განახლებამ შესაძლოა ზიანი მოგაყენოთ.
extensions-warning-update-security-button = ჩართვა
    .title = დამატებების განახლების უსაფრთხოების შემოწმების ჩართვა


## Strings connected to add-on updates

addon-updates-check-for-updates = განახლებების შემოწმება
    .accesskey = შ
addon-updates-view-updates = ბოლო განახლებების ნახვა
    .accesskey = ბ

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = დამატებების თვითგანახლება
    .accesskey = ვ

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = ყველა დამატების, ავტომატურ განახლებაზე დაბრუნება
    .accesskey = დ
addon-updates-reset-updates-to-manual = ყველა დამატებაზე, ხელით განახლების მითითება
    .accesskey = ხ

## Status messages displayed when updating add-ons

addon-updates-updating = დამატებების განახლება
addon-updates-installed = დამატებები განახლებულია.
addon-updates-none-found = განახლებები ვერ მოიძებნა
addon-updates-manual-updates-found = ხელმისაწვდომი განახლებების ნახვა

## Add-on install/debug strings for page options menu

addon-install-from-file = დამატების დაყენება ფაილის მეშვეობით…
    .accesskey = ფ
addon-install-from-file-dialog-title = დამატებების შერჩევა დასაყენებლად
addon-install-from-file-filter-name = დამატებები
addon-open-about-debugging = დამატებების გამართვა
    .accesskey = გ

## Extension shortcut management

# This is displayed in the page options menu
addon-manage-extensions-shortcuts = გაფართოებების ღილაკების მართვა
    .accesskey = ღ

shortcuts-no-addons = არცერთი გაფართოება არ გაქვთ ჩართული.
shortcuts-no-commands = სწრაფი ღილაკები არ აქვს შემდეგ გაფართოებებს:
shortcuts-input =
    .placeholder = სწრაფი ღილაკის აკრეფა

shortcuts-browserAction2 = ხელსაწყოთა ზოლზე ღილაკის ამოქმედება
shortcuts-pageAction = გვერდზე მოქმედების ჩართვა
shortcuts-sidebarAction = გვერდითა ზოლის გამოჩენა/დამალვა

shortcuts-modifier-mac = გამოყენებული იყოს Ctrl, Alt, ან ⌘
shortcuts-modifier-other = გამოყენებული იყოს Ctrl ან Alt
shortcuts-invalid = არასწორი შერჩევა
shortcuts-letter = აკრიფეთ ასონიშანი
shortcuts-system = ვერ გადაეწერება სწრაფ ღილაკს, რომელსაც { -brand-short-name } იყენებს

# String displayed in warning label when there is a duplicate shortcut
shortcuts-duplicate = განმეორებული მალსახმობი

# String displayed when a keyboard shortcut is already assigned to more than one add-on
# Variables:
#   $shortcut (string) - Shortcut string for the add-on
shortcuts-duplicate-warning-message = { $shortcut } მალსახმობის სახით გამოიყენება ერთზე მეტ შემთხვევაში. განმეორებულმა მალსახმობებმა, შესაძლოა მოულოდნელი შედეგები წარმოშვას.

# String displayed when a keyboard shortcut is already used by another add-on
# Variables:
#   $addon (string) - Name of the add-on
shortcuts-exists = უკვე იყენებს { $addon }

shortcuts-card-expand-button =
    { $numberToShow ->
       *[other] გამოჩნდეს { $numberToShow } კიდევ
    }

shortcuts-card-collapse-button = ნაკლების ჩვენება

header-back-button =
    .title = უკან გადასვლა

## Recommended add-ons page

# Explanatory introduction to the list of recommended add-ons. The action word
# ("recommends") in the final sentence is a link to external documentation.
discopane-intro =
    გაფართოებები, ერთგვარი პროგრამებია ბრაუზერისთვის, რომლებიც საშუალებას გაძლევთ
    დაიცვათ პაროლები, ჩამოტვირთოთ ვიდეოები, მოიძიოთ საყიდლები, შეზღუდოთ
    მომაბეზრებელი რეკლამები, შეცვალოთ ბრაუზერის იერსახე და კიდევ უამრავი რამ.
    ეს პატარა პროგრამული ნაწილები ხშირ შემთხვევაში შექმნილია ცალკეული მხარის მიერ.
    აქ შეგიძლია იხილით ისინი, რომელთაც { -brand-product-name } <a data-l10n-name="learn-more-trigger">გირჩევთ</a>
    მეტი უსაფრთხოებისთვის, წარმადობისა და შესაძლებლობებისთვის.

# Notice to make user aware that the recommendations are personalized.
discopane-notice-recommendations =
    შემოთავაზებების ნაწილი არის მორგებული თქვენზე. ისინი ეფუძნება თქვენ მიერ
    დაყენებულ სხვა გაფართოებებს, პროფილის პარამეტრებსა და გამოყენების სტატისტიკას.
discopane-notice-learn-more = ვრცლად

privacy-policy = პირადულობის დებულება

# Refers to the author of an add-on, shown below the name of the add-on.
# Variables:
#   $author (string) - The name of the add-on developer.
created-by-author = შემქმნელი <a data-l10n-name="author">{ $author }</a>
# Shows the number of daily users of the add-on.
# Variables:
#   $dailyUsers (number) - The number of daily users.
user-count = მომხმარებელი: { $dailyUsers }
install-extension-button = დაემატოს { -brand-product-name }
install-theme-button = თემის ჩადგმა
# The label of the button that appears after installing an add-on. Upon click,
# the detailed add-on view is opened, from where the add-on can be managed.
manage-addon-button = მართვა
find-more-addons = სხვა დამატებების მოძიება

# This is a label for the button to open the "more options" menu, it is only
# used for screen readers.
addon-options-button =
    .aria-label = დამატებითი პარამეტრები

## Add-on actions

report-addon-button = საჩივარი
remove-addon-button = მოცილება
# The link will always be shown after the other text.
remove-addon-disabled-button = ვერ მოცილდება <a data-l10n-name="link">რატომ?</a>
disable-addon-button = ამორთვა
enable-addon-button = ჩართვა
# This is used for the toggle on the extension card, it's a checkbox and this
# is always its label.
extension-enable-addon-button-label =
    .aria-label = ჩართვა
preferences-addon-button =
    { PLATFORM() ->
        [windows] პარამეტრები
       *[other] პარამეტრები
    }
details-addon-button = ვრცლად
release-notes-addon-button = გამოშვების მონაცემები
permissions-addon-button = ნებართვები

extension-enabled-heading = ჩართულია
extension-disabled-heading = ამორთულია

theme-enabled-heading = ჩართულია
theme-disabled-heading = ამორთულია

plugin-enabled-heading = ჩართულია
plugin-disabled-heading = ამორთულია

dictionary-enabled-heading = ჩართულია
dictionary-disabled-heading = ამორთულია

locale-enabled-heading = ჩართულია
locale-disabled-heading = ამორთულია

ask-to-activate-button = ნებართვა გასაშვებად
always-activate-button = ყოველთვის გაეშვას
never-activate-button = არასდროს გაეშვას

addon-detail-author-label = შემქმნელი
addon-detail-version-label = ვერსია
addon-detail-last-updated-label = ბოლო განახლება
addon-detail-homepage-label = მთავარი გვერდი
addon-detail-rating-label = შეფასება

# Message for add-ons with a staged pending update.
install-postponed-message = ეს გაფართოება განახლდება, როცა { -brand-short-name } ხელახლა გაეშვება.
install-postponed-button = განახლება ახლავე

# The average rating that the add-on has received.
# Variables:
#   $rating (number) - A number between 0 and 5. The translation should show at most one digit after the comma.
five-star-rating =
    .title = { NUMBER($rating, maximumFractionDigits: 1) } შეფასება 5-იდან

# This string is used to show that an add-on is disabled.
# Variables:
#   $name (string) - The name of the add-on
addon-name-disabled = { $name } (გამორთული)

# The number of reviews that an add-on has received on AMO.
# Variables:
#   $numberOfReviews (number) - The number of reviews received
addon-detail-reviews-link =
    { $numberOfReviews ->
        [one] { $numberOfReviews } მიმოხილვა
       *[other] { $numberOfReviews } მიმოხილვა
    }

## Pending uninstall message bar

# Variables:
#   $addon (string) - Name of the add-on
pending-uninstall-description = <span data-l10n-name="addon-name">{ $addon }</span> მოცილებულია.
pending-uninstall-undo-button = დაბრუნება

addon-detail-updates-label = თვითგანახლებების დაშვება
addon-detail-updates-radio-default = ნაგულისხმევი
addon-detail-updates-radio-on = ჩართ.
addon-detail-updates-radio-off = გამორთ.
addon-detail-update-check-label = განახლებებზე შემოწმება
install-update-button = განახლება

# This is the tooltip text for the private browsing badge in about:addons. The
# badge is the private browsing icon included next to the extension's name.
addon-badge-private-browsing-allowed2 =
    .title = დაშვებულია პირად ფანჯრებში
    .aria-label = { addon-badge-private-browsing-allowed2.title }
addon-detail-private-browsing-help = დაშვების შემთხვევაში, გაფართოებას წვდომა ექნება თქვენს მოქმედებებზე პირად ფანჯრებში. <a data-l10n-name="learn-more">ვრცლად</a>
addon-detail-private-browsing-allow = დაშვება
addon-detail-private-browsing-disallow = აკრძალვა

# This is the tooltip text for the recommended badge for an extension in about:addons. The
# badge is a small icon displayed next to an extension when it is recommended on AMO.
addon-badge-recommended2 =
    .title = { -brand-product-name } მხოლოდ იმ გაფართოებებს გირჩევთ, რომლებიც აკმაყოფილებს უსაფრთხოებისა და წარმადობის მაღალ მოთხოვნებს.
    .aria-label = { addon-badge-recommended2.title }

available-updates-heading = ხელმისწვდომი განახლებები
recent-updates-heading = ბოლო განახლებები

release-notes-loading = იტვირთება...
release-notes-error = სამწუხაროდ, ვერსიის მონაცემების ჩვენებისას მოხდა შეცდომა.

addon-permissions-empty = გაფართოება არ ითხოვს რამე ნებართვას

recommended-extensions-heading = შემოთავაზებული გაფართოებები
recommended-themes-heading = შემოთავაზებული თემები

# A recommendation for the Firefox Color theme shown at the bottom of the theme
# list view. The "Firefox Color" name itself should not be translated.
recommended-theme-1 = შემოქმედებით უნარებს ფლობთ? <a data-l10n-name="link">ააწყვეთ საკუთარი გაფორმება Firefox Color-ით.</a>

## Page headings

extension-heading = გაფართოებების მართვა
theme-heading = თემების მართვა
plugin-heading = მოდულების მართვა
dictionary-heading = ლექსიკონების მართვა
locale-heading = ენების მართვა
updates-heading = განახლებების მართვა
discover-heading = მოირგეთ თქვენი { -brand-short-name }
shortcuts-heading = გაფართოებების ღილაკების მართვა

default-heading-search-label = სხვა დამატებების მოძიება
addons-heading-search-input =
    .placeholder = addons.mozilla.org საიტზე მოძიება

addon-page-options-button =
    .title = ხელსაწყოები ყველა დამატებისთვის
