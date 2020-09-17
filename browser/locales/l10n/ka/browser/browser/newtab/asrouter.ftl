# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = შემოთავაზებული გაფართოება
cfr-doorhanger-feature-heading = შემოთავაზებული შესაძლებლობა
cfr-doorhanger-pintab-heading = სცადეთ: ჩანართის მიმაგრება

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = რატომ ვხედავ ამას

cfr-doorhanger-extension-cancel-button = ახლა არა
    .accesskey = რ

cfr-doorhanger-extension-ok-button = დამატება ახლავე
    .accesskey = ხ
cfr-doorhanger-pintab-ok-button = ამ ჩანართის მიმაგრება
    .accesskey = გ

cfr-doorhanger-extension-manage-settings-button = შემოთავაზებების პარამეტრების მართვა
    .accesskey = შ

cfr-doorhanger-extension-never-show-recommendation = ამ შემოთავაზების ჩვენების შეწყვეტა
    .accesskey = წ

cfr-doorhanger-extension-learn-more-link = იხილეთ ვრცლად

# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = შემქმნელი: { $name }

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = შემოთავაზება
cfr-doorhanger-extension-notification2 = შემოთავაზება
    .tooltiptext = გაფართოების შემოთავაზება
    .a11y-announcement = ხელმისაწვდომია გაფართოების შემოთავაზება

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = შემოთავაზება
    .tooltiptext = შესაძლებლობის შემოთავაზება
    .a11y-announcement = ხელმისაწვდომია შესაძლებლობის შემოთავაზება

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
            [one] { $total } ვარსკვლავი
           *[other] { $total } ვარსკვლავი
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [one] { $total } მომხმარებელი
       *[other] { $total } მომხმარებელი
    }

cfr-doorhanger-pintab-description = მიიღეთ მარტივი წვდომა თქვენს ხშირად მონახულებულ საიტებთან. დატოვეთ საიტები ჩანართში გახსნილი (ხელახლა გაშვების დროსაც).

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = <b>მარჯვენა-წკაპი</b> მისამაგრებელ ჩანართზე.
cfr-doorhanger-pintab-step2 = აირჩიეთ <b>ჩანართის მიმაგრება</b> მენიუდან.
cfr-doorhanger-pintab-step3 = თუ საიტზე რამე განახლდება, ლურჯი წერტილი გამოჩნდება მიმაგრებულ ჩანართზე.

cfr-doorhanger-pintab-animation-pause = შეჩერება
cfr-doorhanger-pintab-animation-resume = გაგრძელება


## Firefox Accounts Message

cfr-doorhanger-bookmark-fxa-header = დაასინქრონეთ სანიშნები ყველგან.
cfr-doorhanger-bookmark-fxa-body = რაც მთავარია! ახლა უკვე არ დარჩებით სანიშნის გარეშე თქვენს მობილურ მოწყობილობებზე. გამოიყენეთ { -fxaccount-brand-name }.
cfr-doorhanger-bookmark-fxa-link-text = დაასინქრონეთ სანიშნები ახლავე...
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = დახურვის ღილაკი
    .title = დახურვა

## Protections panel

cfr-protections-panel-header = მოინახულეთ გვერდები მეთვალყურეების გარეშე
cfr-protections-panel-body = დატოვეთ თქვენი მონაცემები პირადი. { -brand-short-name } აგარიდებთ ცნობილი მეთვალყურეების უმეტესობას, რომლებიც თან დაგყვებათ ინტერნეტში.
cfr-protections-panel-link-text = ვრცლად

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = ახალი შესაძლებლობა:

cfr-whatsnew-button =
    .label = რა სიახლეებია
    .tooltiptext = რა სიახლეებია

cfr-whatsnew-panel-header = რა სიახლეებია

cfr-whatsnew-release-notes-link-text = იხილეთ გამოშვების შენიშვნები

cfr-whatsnew-fx70-title = { -brand-short-name } ახლა უფრო მტკიცედ იბრძვის თქვენი პირადი მონაცემების დასაცავად
cfr-whatsnew-fx70-body =
    ბოლო განახლების შედეგად, გაძლიერებულია თვალთვალისგან დაცვის შესაძლებლობა
    და მეტად გამარტივებულია ძლიერი პაროლების გამოყენება, თითოეული საიტისთვის.

cfr-whatsnew-tracking-protect-title = თავი დაიცავით მეთვალყურეებისგან
cfr-whatsnew-tracking-protect-body =
    { -brand-short-name } ზღუდავს ცნობილი სოციალური ქსელებისა და საიტთაშორისი
    მეთვალყურეების უმეტესობას, რომლებიც თან დაგყვებათ ინტერნეტში.
cfr-whatsnew-tracking-protect-link-text = იხილეთ თქვენი ანგარიში

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
        [one] მეთვალყურე შეიზღუდა
       *[other] მეთვალყურე შეიზღუდა
    }
cfr-whatsnew-tracking-blocked-subtitle = თარიღიდან { DATETIME($earliestDate, month: "long", year: "numeric") }
cfr-whatsnew-tracking-blocked-link-text = ანგარიშის ნახვა

cfr-whatsnew-lockwise-backup-title = დაამარქაფეთ პაროლები
cfr-whatsnew-lockwise-backup-body = ახლა კი შექმენით პაროლები, რომლებთან წვდომაც ნებისმიერი ადგილიდან შეგეძლებათ, ანგარიშის საშუალებით.
cfr-whatsnew-lockwise-backup-link-text = მარქაფის ჩართვა

cfr-whatsnew-lockwise-take-title = თან წაიყოლეთ თქვენი პაროლები
cfr-whatsnew-lockwise-take-body =
    { -lockwise-brand-short-name }-აპლიკაცია მობილურისთვის, საშუალებას მოგცემთ
    უსაფრთხოდ დაამარქაფოთ პაროლები, ნებისმიერ ადგილიდან.
cfr-whatsnew-lockwise-take-link-text = გადმოწერა

## Search Bar

cfr-whatsnew-searchbar-title = აკრიფეთ ნაკლები, მოიძიეთ მეტი მისამართების ველიდან
cfr-whatsnew-searchbar-body-topsites = ახლა, უბრალოდ გადადით მისამართების ველში და გამოჩნდება თქვენი რჩეული საიტების ბმულები.
cfr-whatsnew-searchbar-icon-alt-text = გამადიდებელი შუშის ხატულა

## Picture-in-Picture

cfr-whatsnew-pip-header = უყურეთ ვიდეოებს გვერდების თვალიერებისას
cfr-whatsnew-pip-body = ეკრანი-ეკრანში გამოიტანს ვიდეოს ფანჯრის ზემოთ, ასე რომ შეგეძლებათ განაგრძოთ სხვა ჩანართებზე გადასვლა.
cfr-whatsnew-pip-cta = ვრცლად

## Permission Prompt

cfr-whatsnew-permission-prompt-header = ნაკლები გამაღიზიანებელი ამომხტომი ფანჯარა
cfr-whatsnew-permission-prompt-body = { -brand-shorter-name } ახლა უკვე უზღუდავს საიტებს, ამომხტომი შეტყობინებების ჩვენების მოთხოვნას.
cfr-whatsnew-permission-prompt-cta = ვრცლად

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header =
    { $fingerprinterCount ->
        [one] ამომცნობი შეიზღუდა
       *[other] ამომცნობი შეიზღუდა
    }
cfr-whatsnew-fingerprinter-counter-body = { -brand-shorter-name } ზღუდავს მომხმარებლის ამომცნობ საშუალებებს, რომლებიც ჩუმად აგროვებს ინფორმაციას თქვენს მოწყობილობასა და მოქმედებებზე, დახასიათების შესადგენად სარეკლამოებისთვის.

# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = მომხმარებლის ამომცნობები
cfr-whatsnew-fingerprinter-counter-body-alt = { -brand-shorter-name } გთავაზობთ მომხმარებლის ამომცნობი საშუალებების შეზღუდვას, რომლებიც ჩუმად აგროვებს ინფორმაციას თქვენს მოწყობილობასა და მოქმედებებზე, დახასიათების შესადგენად სარეკლამოებისთვის.

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = მიიღეთ ეს სანიშნი თქვენს ტელეფონზე
cfr-doorhanger-sync-bookmarks-body = თან წაიყოლეთ თქვენი სანიშნები, პაროლები, ისტორია და ა. შ. ყველგან, სადაც გიყენიათ { -brand-product-name }.
cfr-doorhanger-sync-bookmarks-ok-button = ჩართეთ { -sync-brand-short-name }
    .accesskey = ჩ

## Login Sync

cfr-doorhanger-sync-logins-header = აღარასდროს დაკარგავთ პაროლებს
cfr-doorhanger-sync-logins-body = შეინახეთ და დაასინქრონეთ უსაფრთხოდ თქვენი პაროლები ყველა თქვენს მოწყობილობაზე.
cfr-doorhanger-sync-logins-ok-button = ჩართეთ { -sync-brand-short-name }
    .accesskey = თ

## Send Tab

cfr-doorhanger-send-tab-header = წაიკითხეთ გზაში
cfr-doorhanger-send-tab-recipe-header = წაიღეთ ეს მომზადების წესი სამზარეულოში
cfr-doorhanger-send-tab-body = Send Tab საშუალებას გაძლევთ მარტივად გააზიაროთ ეს ბმული თქვენს ტელეფონზე ან ნებისმიერ მოწყობილობაზე, სადაც გიყენიათ { -brand-product-name }.
cfr-doorhanger-send-tab-ok-button = გამოცადეთ Send Tab
    .accesskey = ც

## Firefox Send

cfr-doorhanger-firefox-send-header = გააზიარეთ ეს PDF უსაფრთხოდ
cfr-doorhanger-firefox-send-body = დაიცავით თქვენი მნიშვნელოვანი მასალები ცნობისმოყვარეებისგან, გამჭოლი დაშიფვრითა და ბმულით, რომელიც თავისით გაქრება საქმის დასრულებისას.
cfr-doorhanger-firefox-send-ok-button = გამოცადეთ { -send-brand-name }
    .accesskey = ც

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = დაცვის შესახებ
    .accesskey = ც
cfr-doorhanger-socialtracking-close-button = დახურვა
    .accesskey = ხ
cfr-doorhanger-socialtracking-dont-show-again = მომავალში, აღარ გამოჩნდეს ასეთი შეტყობინება
    .accesskey = ღ
cfr-doorhanger-socialtracking-heading = { -brand-short-name } უზღუდავს სოციალური ქსელს თქვენს თვალთვალს
cfr-doorhanger-socialtracking-description = თქვენი პირადულობა მნიშვნელოვანია. { -brand-short-name } ახლა უკვე ზღუდავს ცნობილი სოციალური ქსელების მეთვალყურე საშუალებებს, უსაზღვრავს მათ ინტერნეტში თქვენ შესახებ შესაგროვებელი მონაცემების ოდენობას.
cfr-doorhanger-fingerprinters-heading = { -brand-short-name } ზღუდავს მომხმარებლის ამომცნობს ამ საიტზე
cfr-doorhanger-fingerprinters-description = თქვენი პირადულობა მნიშვნელოვანია. { -brand-short-name } ახლა უკვე ზღუდავს მომხმარებლის ამომცნობ საშუალებებს, რომელთაც შეუძლია თქვენი სხვებისგან გამორჩევა თვალის სადევნებლად, თქვენზე შეგროვებული მონაცემებით.
cfr-doorhanger-cryptominers-heading = { -brand-short-name } ზღუდავს კრიპტოვალუტის გამომმუშავებელს ამ საიტზე
cfr-doorhanger-cryptominers-description = თქვენი პირადულობა მნიშვნელოვანია. { -brand-short-name } ახლა უკვე ზღუდავს კრიპტოვალუტის გამომმუშავებელ საშუალებებს, რომლებიც იყენებს თქვენი სისტემის გამოთვლის სიმძლავრეს ციფრული ფულის მოსაპოვებლად.

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    { $blockedCount ->
        [one] { -brand-short-name } ზღუდავს <b>{ $blockedCount }</b>-ზე მეტ მეთვალყურეს თარიღიდან { $date }!
       *[other] { -brand-short-name } ზღუდავს <b>{ $blockedCount }</b>-ზე მეტ მეთვალყურეს თარიღიდან { $date }!
    }
cfr-doorhanger-milestone-ok-button = ყველას ნახვა
    .accesskey = ნ

cfr-doorhanger-milestone-close-button = დახურვა
    .accesskey = ხ

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = მარტივად შექმენით უსაფრთხო პაროლები
cfr-whatsnew-lockwise-body = რთულია მოიფიქროთ განსხვავებული, დაცული პაროლი თითოეული ანგარიშისთვის. პაროლის შექმნისას, შესაბამისი ველის არჩევით შეძლებთ მიიღოთ უსაფრთხო პაროლი, რომელსაც თავად შეგიდგენთ { -brand-shorter-name }.
cfr-whatsnew-lockwise-icon-alt = { -lockwise-brand-short-name } ხატულა

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = მიიღეთ ცნობები დაუცველ პაროლებზე
cfr-whatsnew-passwords-body = ჰაკერებმა იციან, რომ ადამიანები იყენებენ ერთსა და იმავე პაროლებს. თუ თქვენ იყენებთ ერთ პაროლს რამდენიმე საიტზე და ერთ-ერთი მათგანი მაინც გახდება მონაცემების მიტაცების მსხვერპლი, { -lockwise-brand-short-name } გაცნობებთ რომ საჭირო იქნება ყველა ამ საიტზე პაროლის შეცვლა.
cfr-whatsnew-passwords-icon-alt = დაუცველი პაროლის ხატულა

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-header = გაშალეთ ეკრანი-ეკრანში სრულ ეკრანზე
cfr-whatsnew-pip-fullscreen-body = როცა ვიდეო ამოხტება ცალკე ფანჯარაში, მასზე ორჯერ დაწკაპებით შეძლებთ მთელ ეკრანზე გაშალოთ.
cfr-whatsnew-pip-fullscreen-icon-alt = ეკრანი-ეკრანში ხატულა

## Protections Dashboard message

cfr-whatsnew-protections-header = დაცვისთვის თვალის შევლება
cfr-whatsnew-protections-body = დაცვის მაჩვენებლების გვერდი შეიცავს შემაჯამებელ ცნობებს ანგარიშების მიტაცებებსა და პაროლების მართვაზე. შეგიძლიათ თვალი ადევნოთ, რამდენი გაქვთ გამოსწორებული და იხილოთ, თქვენი რომელიმე პაროლი გამჟღავნებულ მონაცემებში ხომ არ აღმოჩენილა.
cfr-whatsnew-protections-cta-link = დაცვის მაჩვენებლების ნახვა
cfr-whatsnew-protections-icon-alt = ფარის ნიშანი

## Better PDF message

cfr-whatsnew-better-pdf-header = PDF-თან მოხერხებული მუშაობა
cfr-whatsnew-better-pdf-body = PDF-დოკუმენტებს ახლა უკვე პირდაპირ გახსნის { -brand-short-name }, საჭირო მასალები კიდევ უფრო ახლოს გექნებათ.

## DOH Message

cfr-doorhanger-doh-body = თქვენი პირადულობა უმნიშვნელოვანესია. { -brand-short-name } ახლა უკვე უსაფრთხოდ გადაამისამართებს თქვენს DNS-მოთხოვნებს, როცა კი შესაძლებელი იქნება, პარტნიორი მომსახურების მეშვეობით, რომ გვერდების მონახულებისას მუდამ დაცული იყოთ.
cfr-doorhanger-doh-header = მეტად უსაფრთხო, დაშიფრული DNS-გარდაქმნები
cfr-doorhanger-doh-primary-button = კარგი, გასაგებია
    .accesskey = კ
cfr-doorhanger-doh-secondary-button = გამორთვა
    .accesskey = გ

## What's new: Cookies message

cfr-whatsnew-clear-cookies-header = თავისთავადი დაცვა თვალთვალის გაიძვერული საშუალებებისგან
cfr-whatsnew-clear-cookies-body = ზოგიერთი მეთვალყურე გამისამართებთ სხვა საიტებზე, რომლებიც ფარულად აყენებს ფუნთუშებს. { -brand-short-name } ახლა უკვე ავტომატურად მოაცილებს ამ ფუნთუშებს, თვალი რომ ვერ გადევნონ.
cfr-whatsnew-clear-cookies-image-alt = შეზღუდული ფუნთუშის ნიმუში
