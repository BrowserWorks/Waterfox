# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $count (Number) - Number of tracking events blocked.
graph-week-summary =
    { $count ->
        [one] ამ დღეებში { $count } მეთვალყურეა აღმოჩენილი, რომელსაც ზღუდავს { -brand-short-name }
       *[other] ამ დღეებში { $count } მეთვალყურეა აღმოჩენილი, რომელთაც ზღუდავს { -brand-short-name }
    }

# Variables:
#   $count (Number) - Number of tracking events blocked.
#   $earliestDate (Number) - Unix timestamp in ms, representing a date. The
# earliest date recorded in the database.
graph-total-tracker-summary =
    { $count ->
        [one] <b>{ $count }</b> მეთვალყურეა შეზღუდული თარიღიდან { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
       *[other] <b>{ $count }</b> მეთვალყურეა შეზღუდული თარიღიდან { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
    }

# Text displayed instead of the graph when in Private Mode
graph-private-window = { -brand-short-name } განაგრძობს მეთვალყურეების შეზღუდვას პირად ჩანართებში, თუმცა არ აღრიცხავს, რა შეიზღუდა.
# Weekly summary of the graph when the graph is empty in Private Mode
graph-week-summary-private-window = მეთვალყურეები, რომელთაც ზღუდავდა { -brand-short-name } ამ კვირაში

protection-report-webpage-title = დაცვის მაჩვენებლები
protection-report-page-content-title = დაცვის მაჩვენებლები
# This message shows when all privacy protections are turned off, which is why we use the word "can", Firefox is able to protect your privacy, but it is currently not.
protection-report-page-summary = { -brand-short-name } იცავს თქვენს უსაფრთხოებას შეუმჩნევლად, გვერდების თვალიერებისას. აქ იხილავთ თქვენთვის განკუთვნილ დაცვის მაჩვენებლებსა და საშუალებებს, რომლებითაც შეძლებთ საკუთარი ინტერნეტცხოვრების მართვის სადავეების ხელში აღებას.
# This message shows when at least some protections are turned on, we are more assertive compared to the message above, Firefox is actively protecting you.
protection-report-page-summary-default = { -brand-short-name } იცავს თქვენს უსაფრთხოებას შეუმჩნევლად, გვერდების თვალიერებისას. აქ იხილავთ თქვენთვის განკუთვნილ დაცვის მაჩვენებლებსა და საშუალებებს, რომლებითაც შეძლებთ საკუთარი ინტერნეტცხოვრების მართვის სადავეების ხელში აღებას.

protection-report-settings-link = პირადულობისა და უსართხოების პარამეტრები

etp-card-title-always = თვალთვალისგან გაძლიერებული დაცვა: მუდმივად ჩართულია
etp-card-title-custom-not-blocking = თვალთვალისგან გაძლიერებული დაცვა: გამორთულია
etp-card-content-description = { -brand-short-name } ავტომატურად უზღუდავს კომპანიებს, თქვენს მოქმედებებზე ფარულად თვალის მიდევნების საშუალებას ვებსივრცეში.
protection-report-etp-card-content-custom-not-blocking = დაცვა სრულად გამორთულია ამჟამად. უსაფრთხოების პარამეტრებიდან შეარჩიეთ მეთვალყურეები, რომელთაც შეზღუდავს { -brand-short-name }.
protection-report-manage-protections = პარამეტრების მართვა

# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = დღეს

# This string is used to describe the graph for screenreader users.
graph-legend-description = გამოსახულებაზე მოცემულია თითოეული სახის მეთვალყურის რაოდენობა ჯამურად, რომლებიც ამ კვირაში შეიზღუდა.

social-tab-title = სოციალური ქსელის მეთვალყურეები
social-tab-contant = სოციალური ქსელები ათავსებს მეთვალყურეებს სხვა საიტებზე, რომ თვალი გადევნონ ინტერნეტში. ეს საშუალებას აძლევს მათ მფლობელ დაწესებულებებს, იმაზე მეტი რამ შეიტყონ თქვენ შესახებ, ვიდრე ამ სოციალურ ქსელში გაქვთ გაზიარებული. <a data-l10n-name="learn-more-link">ვრცლად</a>

cookie-tab-title = საიტთაშორისი მეთვალყურე ფუნთუშები
cookie-tab-content = ეს ფუნთუშები თან დაგყვებათ საიტებზე და აგროვებს მონაცემებს, თუ რას აკეთებთ ინტერნეტში. მათ იყენებს გარეშე მხარეები, სარეკლამო და კვლევითი დაწესებულებები. საიტთაშორისი მეთვალყურე ფუნთუშების შეზღუდვა, ამცირებს თვალის მდევნელ რეკლამებს თქვენ გარშემო. <a data-l10n-name="learn-more-link">ვრცლად</a>

tracker-tab-title = თვალის მდევნელი შიგთავსი
tracker-tab-description = საიტები, ზოგჯერ გარე ბმულებიდან ტვირთავს თვალის სადევნებელი კოდის შემცველ მასალას. მათი შეზღუდვით, საიტი უფრო სწრაფად ჩაიტვირთება, თუმცა ღილაკებმა, ანგარიშისა და სხვა შესავსებმა ველებმა, შეიძლება აღარ იმუშაოს. <a data-l10n-name="learn-more-link">ვრცლად</a>

fingerprinter-tab-title = მომხმარებლის ამომცნობები
fingerprinter-tab-content = მომხმარებლის ამომცნობები აგროვებს ბრაუზერისა და კომპიუტერის მონაცემებს, თქვენი დახასიათების შესადგენად. ამის შედეგად კი თქვენი სხვებისგან გამორჩევაა შესაძლებელი, სხვადასხვა საიტებზე. <a data-l10n-name="learn-more-link">ვრცლად</a>

cryptominer-tab-title = კრიპტოვალუტის გამომმუშავებლები
cryptominer-tab-content = კრიპტოვალუტის გამომმუშავებლები სარგებლობს თქვენი სისტემის გამოთვლის სიმძლავრით ციფრული ფულის მოსაპოვებლად. ამგვარი კოდები ასუსტებს ბატარეას, ანელებს კომპიუტერს და ზრდის დენის დანახარჯს. <a data-l10n-name="learn-more-link">ვრცლად</a>

protections-close-button2 =
    .aria-label = დახურვა
    .title = დახურვა
  
mobile-app-title = შეზღუდეთ სარეკლამო მეთვალყურეები მეტ მოწყობილობაზე
mobile-app-card-content = გამოიყენეთ მობილური ბრაუზერი ჩაშენებული დაცვით, სარეკლამო მეთვალყურეებისგან.
mobile-app-links = { -brand-product-name } ბრაუზერი <a data-l10n-name="android-mobile-inline-link">Android-სა</a> და <a data-l10n-name="ios-mobile-inline-link">iOS-ზე</a>

lockwise-title = აღარასდროს დაკარგავთ პაროლებს
lockwise-title-logged-in2 = პაროლების მართვა
lockwise-header-content = { -lockwise-brand-name } უსაფრთხოდ შეინახავს თქვენს პაროლებს ბრაუზერში.
lockwise-header-content-logged-in = პაროლების უსაფრთხო შენახვა და გაზიარება ყველა თქვენს მოწყობილობაზე.
protection-report-save-passwords-button = პაროლების შენახვა
    .title = პაროლებს შესანახად გამოიყენეთ { -lockwise-brand-short-name }
protection-report-manage-passwords-button = პაროლების მართვა
    .title = პაროლების სამართავად გამოიყენეთ { -lockwise-brand-short-name }
lockwise-mobile-app-title = თან წაიყოლეთ პაროლები ყველგან
lockwise-no-logins-card-content = თქვენს პაროლებს შეინახავს { -brand-short-name } ნებისმიერ მოწყობილობაზე.
lockwise-app-links = { -lockwise-brand-name }<a data-l10n-name="lockwise-android-inline-link">Android-სა</a> და <a data-l10n-name="lockwise-ios-inline-link">iOS-ზე</a>

# Variables:
# $count (Number) - Number of passwords exposed in data breaches.
lockwise-scanned-text-breached-logins =
    { $count ->
        [one] 1 პაროლი, შესაძლოა გამჟღავნებულიყო მიტაცებისას.
       *[other] { $count } პაროლი, შესაძლოა გამჟღავნებულიყო მიტაცებისას.
    }

# While English doesn't use the number in the plural form, you can add $count to your language
# if needed for grammatical reasons.
# Variables:
# $count (Number) - Number of passwords stored in Lockwise.
lockwise-scanned-text-no-breached-logins =
    { $count ->
        [one] თქვენი 1 პაროლი ინახება უსაფრთხოდ.
       *[other] თქვენი პაროლები ინახება უსაფრთხოდ
    }
lockwise-how-it-works-link = როგორ მუშაობს

turn-on-sync = ჩართეთ { -sync-brand-short-name }…
    .title = იხილეთ სინქრონიზაციის პარამეტრები

monitor-title = თვალი ადევნეთ მონაცემების მიტაცების შემთხვევებს
monitor-link = როგორ მუშაობს
monitor-header-content-no-account = გამოცადეთ { -monitor-brand-name } და ნახეთ, თქვენი ინფორმაცია აღმოჩენილია თუ არა ცნობილ მიტაცებულ მონაცემებს შორის და მიიღეთ შეტყობინებები, ახალი შემთხვევების შესახებ.
monitor-header-content-signed-in = { -monitor-brand-name } გაცნობებთ, თუ თქვენი ინფორმაცია ცნობილ მიტაცებულ მონაცემებში აღმოჩნდება.
monitor-sign-up-link = გამოიწერეთ ცნობები, მონაცემების მიტაცებებზე
    .title = გამოიწერეთ { -monitor-brand-name } ცნობები, მონაცემების მიტაცებებზე
auto-scan = ავტომატურად გადამოწმებული დღეს

monitor-emails-tooltip =
    .title = ელფოსტებზე, რომლებიც მოწმდება იხილეთ { -monitor-brand-short-name }
monitor-breaches-tooltip =
    .title = ცნობილი მიტაცებების შესახებ, იხილეთ { -monitor-brand-short-name }
monitor-passwords-tooltip =
    .title = გამჟღავნებული პაროლების შესახებ, იხილეთ { -monitor-brand-short-name }

# This string is displayed after a large numeral that indicates the total number
# of email addresses being monitored. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-monitored-emails =
    { $count ->
        [one] ელფოსტის მისამართი ზედამხედველობის ქვეშაა
       *[other] ელფოსტის მისამართია ზედამხედველობის ქვეშ
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-known-breaches-found =
    { $count ->
        [one] ცნობილ მიტაცებულ მონაცემებშია აღმოჩენილი თქვენი ინფორმაცია
       *[other] ცნობილ მიტაცებულ მონაცემებშია აღმოჩენილი თქვენი ინფორმაცია
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-known-breaches-resolved =
    { $count ->
        [one] მონაცემთა ცნობილი მიტაცება, აღნიშნულია გამოსწორებულად
       *[other] მონაცემთა ცნობილი მიტაცება, აღნიშნულია გამოსწორებულად
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-exposed-passwords-found =
    { $count ->
        [one] პაროლია გამჟღავნებული, მონაცემების მიტაცების შემთხვევების შედეგად
       *[other] პაროლია გამჟღავნებული, მონაცემების მიტაცების შემთხვევების შედეგად
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-exposed-passwords-resolved =
    { $count ->
        [one] პაროლია მიტაცებული, რომელიც გამოსასწორებელია
       *[other] პაროლია მიტაცებული, რომელიც გამოსასწორებელია
    }

monitor-no-breaches-title = მშვენიერი ამბავი!
monitor-no-breaches-description = თქვენი მონაცემები არაა მიტაცებული. თუ რამე შეიცვლება, გაცნობებთ.
monitor-view-report-link = ანგარიშის ნახვა
    .title = გამოასწორეთ მიტაცებული მონაცემები – { -monitor-brand-short-name }
monitor-breaches-unresolved-title = გამოასწორეთ მიტაცებული მონაცემები
monitor-breaches-unresolved-description = მიტაცების დაწვრილებით გაცნობითა და ინფორმაციის დასაცავად გადადგმული ნაბიჯების შედეგად, შეგიძლიათ აღნიშნოთ, რომ გამოსწორებულია.
monitor-manage-breaches-link = მიტაცებული მონაცემების მართვა
    .title = მიტაცებული მონაცემების მართვა – { -monitor-brand-short-name }
monitor-breaches-resolved-title = მშვენიერია! ყველა მიტაცებული მონაცემი გამოსწორებულია.
monitor-breaches-resolved-description = თუ თქვენი ელფოსტა აღმოჩნდება ახალ მიტაცებებში, გაცნობებთ.

# Variables:
# $numBreachesResolved (Number) - Number of breaches marked as resolved by the user on Monitor.
# $numBreaches (Number) - Number of breaches in which a user's data was involved, detected by Monitor.
monitor-partial-breaches-title =
    { $numBreaches ->
        [one] { $numBreachesResolved } მიტაცება { $numBreaches }-იდან აღნიშნულია გამოსწორებულად
       *[other] { $numBreachesResolved } მიტაცება { $numBreaches }-იდან აღნიშნულია გამოსწორებულად
    }

# Variables:
# $percentageResolved (Number) - Percentage of breaches marked as resolved by a user on Monitor.
monitor-partial-breaches-percentage = { $percentageResolved }% შესრულებულია

monitor-partial-breaches-motivation-title-start = დასაწყისისთვის მშვენიერია!
monitor-partial-breaches-motivation-title-middle = ასე განაგრძეთ!
monitor-partial-breaches-motivation-title-end = თითქმის მზადაა! განაგრძეთ.
monitor-partial-breaches-motivation-description = გამოასწორეთ დარჩენილი მიტაცებული მონაცემები – { -monitor-brand-short-name }.
monitor-resolve-breaches-link = მიტაცებული მონაცემების გამოსწორება
    .title = მიტაცებული მონაცემების გამოსწორება – { -monitor-brand-short-name }

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

bar-tooltip-social =
    .title = სოციალური ქსელის მეთვალყურეები
    .aria-label =
        { $count ->
            [one] სოციალური ქსელის { $count } მეთვალყურე ({ $percentage }%)
           *[other] სოციალური ქსელის { $count } მეთვალყურე ({ $percentage }%)
        }
bar-tooltip-cookie =
    .title = საიტთაშორისი მეთვალყურე ფუნთუშები
    .aria-label =
        { $count ->
            [one] { $count } საიტთაშორისი მეთვალყურე ფუნთუშა ({ $percentage }%)
           *[other] { $count } საიტთაშორისი მეთვალყურე ფუნთუშა ({ $percentage }%)
        }
bar-tooltip-tracker =
    .title = თვალის მდევნელი შიგთავსი
    .aria-label =
        { $count ->
            [one] { $count } თვალის მდევნელი შიგთავსი ({ $percentage }%)
           *[other] { $count } თვალის მდევნელი შიგთავსი ({ $percentage }%)
        }
bar-tooltip-fingerprinter =
    .title = მომხმარებლის ამომცნობები
    .aria-label =
        { $count ->
            [one] მომხმარებლის { $count } ამომცნობი ({ $percentage }%)
           *[other] მომხმარებლის { $count } ამომცნობი ({ $percentage }%)
        }
bar-tooltip-cryptominer =
    .title = კრიპტოვალუტის გამომმუშავებლები
    .aria-label =
        { $count ->
            [one] კრიპტოვალუტის { $count } გამომმუშავებელი ({ $percentage }%)
           *[other] კრიპტოვალუტის { $count } გამომმუშავებელი ({ $percentage }%)
        }
