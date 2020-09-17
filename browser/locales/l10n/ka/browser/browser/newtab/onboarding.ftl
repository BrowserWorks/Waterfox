# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-learn-more = იხილეთ ვრცლად
onboarding-button-label-get-started = დაწყება

## Welcome modal dialog strings

onboarding-welcome-header = მოგესალმებათ { -brand-short-name }
onboarding-welcome-body = ბრაუზერი უკვე თქვენია.<br/>გაიცანით უკეთ { -brand-product-name }.
onboarding-welcome-learn-more = იხილეთ, უპირატესობების შესახებ.
onboarding-welcome-modal-get-body = ბრაუზერი უკვე გაქვთ.<br/>ახლა კი იხილეთ, როგორ გამოიყენოთ უკეთ { -brand-product-name }.
onboarding-welcome-modal-supercharge-body = გააძლიერეთ პირადულობის დაცვა.
onboarding-welcome-modal-privacy-body = ბრაუზერი უკვე გაქვთ. ახლა კი გაუუმჯობესეთ პირადულობის უსაფრთხოება.
onboarding-welcome-modal-family-learn-more = გაეცანით { -brand-product-name } პროდუქტების ოჯახს
onboarding-welcome-form-header = დაიწყეთ აქედან
onboarding-join-form-body = შეიყვანეთ თქვენი ელფოსტა დასაწყებად.
onboarding-join-form-email =
    .placeholder = ელფოსტის მითითება
onboarding-join-form-email-error = აუცილებელია მართებული ელფოსტა
onboarding-join-form-legal = თუ განაგრძობთ, თქვენ ეთანხმებით <a data-l10n-name="terms">მომსახურების პირობებსა</a> და <a data-l10n-name="privacy">პირადი მონაცემების დაცვის განაცხადს</a>.
onboarding-join-form-continue = გაგრძელება
# This message is followed by a link using onboarding-join-form-signin ("Sign In") as text.
onboarding-join-form-signin-label = უკვე გაქვთ ანგარიში?
# Text for link to submit the sign in form
onboarding-join-form-signin = შესვლა
onboarding-start-browsing-button-label = დაიწყეთ მოგზაურობა ინტერნეტში
onboarding-cards-dismiss =
    .title = დამალვა
    .aria-label = დამალვა

## Multistage 3-screen onboarding flow strings (about:welcome pages)

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-welcome-header = მოგესალმებათ <span data-l10n-name="zap">{ -brand-short-name }</span>
onboarding-multistage-welcome-subtitle = სწრაფი, უსაფრთხო და პირადი ბრაუზერი, არამომგებიანი დაწესებულებისგან.
onboarding-multistage-welcome-primary-button-label = დაიწყეთ გამართვა
onboarding-multistage-welcome-secondary-button-label = შესვლა
onboarding-multistage-welcome-secondary-button-text = გაქვთ ანგარიში?
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "more" should stay inside the span.
onboarding-multistage-import-header = გადმოწერეთ თქვენი პაროლები, სანიშნები და <span data-l10n-name="zap">სხვა</span>
onboarding-multistage-import-subtitle = სხვა ბრაუზერიდან მოდიხართ? მარტივად გადმოიტანს ყველაფერს { -brand-short-name }.
onboarding-multistage-import-primary-button-label = გადმოტანის დაწყება
onboarding-multistage-import-secondary-button-label = ახლა არა
# Info displayed in the footer of import settings screen during onboarding flow.
# This supports welcome screen showing top sites imported from the user's default browser.
onboarding-import-sites-disclaimer = აქ აღნუსხული საიტები ნაპოვნია ამ მოწყობილობაზე. { -brand-short-name } არ შეინახავს ან დაასინქრონებს მონაცემებს სხვა ბრაუზერიდან, სანამ თავად არ მიუთითებთ, გადმოტანას.
# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = დაწყება: ეკრანი { $current }, სულ { $total }
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "look" should stay inside the span.
onboarding-multistage-theme-header = აირჩიეთ <span data-l10n-name="zap">იერსახე</span>
onboarding-multistage-theme-subtitle = მოირგეთ { -brand-short-name } თემებით.
onboarding-multistage-theme-primary-button-label = თემის შენახვა
onboarding-multistage-theme-secondary-button-label = ახლა არა
# Automatic theme uses operating system color settings
onboarding-multistage-theme-label-automatic = ავტომატური
# System refers to the operating system
onboarding-multistage-theme-description-automatic = სისტემის იერსახის გამოყენება
onboarding-multistage-theme-label-light = ნათელი
onboarding-multistage-theme-label-dark = მუქი
# "Firefox Alpenglow" here is the name of the theme, and should be kept in English.
onboarding-multistage-theme-label-alpenglow = Firefox Alpenglow

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

# Tooltip displayed on hover of automatic theme
onboarding-multistage-theme-tooltip-automatic =
    .title =
        საოპერაციო სისტემის გაფორმების გადმოტანა
        ღილაკებზე, მენიუებსა და ფანჯრებზე.
    .aria-label = { onboarding-multistage-theme-tooltip-automatic.title }
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light =
    .title =
        ნათელი გაფორმების გამოყენება ღილაკებზე,
        მენიუებსა და ფანჯრებზე.
    .aria-label = { onboarding-multistage-theme-tooltip-light.title }
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark =
    .title =
        მუქი გაფორმების გამოყენება ღილაკებზე,
        მენიუებსა და ფანჯრებზე.
    .aria-label = { onboarding-multistage-theme-tooltip-dark.title }
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow =
    .title =
        ფერადი გაფორმების გამოყენება ღილაკებზე,
        მენიუებსა და ფანჯრებზე.
    .aria-label = { onboarding-multistage-theme-tooltip-alpenglow.title }
# Tooltip displayed on hover of automatic theme
onboarding-multistage-theme-tooltip-automatic-2 =
    .title =
        საოპერაციო სისტემის გაფორმების გადმოტანა
        ღილაკებზე, მენიუებსა და ფანჯრებზე.
# Input description for automatic theme
onboarding-multistage-theme-description-automatic-2 =
    .aria-description =
        საოპერაციო სისტემის გაფორმების გადმოტანა
        ღილაკებზე, მენიუებსა და ფანჯრებზე.
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light-2 =
    .title =
        ნათელი გაფორმების გამოყენება ღილაკებზე,
        მენიუებსა და ფანჯრებზე.
# Input description for light theme
onboarding-multistage-theme-description-light =
    .aria-description =
        ნათელი გაფორმების გამოყენება ღილაკებზე,
        მენიუებსა და ფანჯრებზე.
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark-2 =
    .title =
        მუქი გაფორმების გამოყენება ღილაკებზე,
        მენიუებსა და ფანჯრებზე.
# Input description for dark theme
onboarding-multistage-theme-description-dark =
    .aria-description =
        მუქი გაფორმების გამოყენება ღილაკებზე,
        მენიუებსა და ფანჯრებზე.
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow-2 =
    .title =
        ფერადი გაფორმების გამოყენება ღილაკებზე,
        მენიუებსა და ფანჯრებზე.
# Input description for Alpenglow theme
onboarding-multistage-theme-description-alpenglow =
    .aria-description =
        ფერადი გაფორმების გამოყენება ღილაკებზე,
        მენიუებსა და ფანჯრებზე.

## Welcome full page string

onboarding-fullpage-welcome-subheader = იხილეთ ყველაფერი, რისი გაკეთება შეგიძლიათ.
onboarding-fullpage-form-email =
    .placeholder = თქვენი ელფოსტის მისამართი…

## Firefox Sync modal dialog strings.

onboarding-sync-welcome-header = თან წაიყოლეთ { -brand-product-name }
onboarding-sync-welcome-content = მიიღეთ წვდომა თქვენს სანიშნებთან, ისტორიასთან, პაროლებსა და სხვა პარამეტრებთან, ყველა თქვენს მოწყობილობაზე.
onboarding-sync-welcome-learn-more-link = იხილეთ ვრცლად, Firefox-ანგარიშების შესახებ
onboarding-sync-form-input =
    .placeholder = ელფოსტა
onboarding-sync-form-continue-button = გაგრძელება
onboarding-sync-form-skip-login-button = გამოტოვება

## This is part of the line "Enter your email to continue to Firefox Sync"

onboarding-sync-form-header = შეიყვანეთ თქვენი ელფოსტა
onboarding-sync-form-sub-header = { -sync-brand-name }-ზე გადასასვლელად

## These are individual benefit messages shown with an image, title and
## description.

onboarding-benefit-products-text = იმუშავეთ შედეგიანად ხელსაწყოების ნაკრებით, რომელიც პატივს სცემს თქვენი პირადი მონაცემების ხელშეუხებლობას, ყველა თქვენს მოწყობილობაზე.
# "Personal Data Promise" is a concept that should be translated consistently
# across the product. It refers to a concept shown elsewhere to the user: "The
# Firefox Personal Data Promise is the way we honor your data in everything we
# make and do. We take less data. We keep it safe. And we make sure that we are
# transparent about how we use it."
onboarding-benefit-privacy-text = ყველაფერი რასაც ვსაქმიანობთ, ექვემდებარება პირადი მონაცემების დაცვის ჩვენს პირობას: ნაკლები აღრიცხვა. უსაფრთხო შენახვა. არანაირი საიდუმლოება.
onboarding-benefit-sync-title = { -sync-brand-short-name }
onboarding-benefit-sync-text = წაიყოლეთ თქვენი სანიშნები, პაროლები ისტორია და ა. შ. ყველგან, სადაც გიყენიათ { -brand-product-name }
onboarding-benefit-monitor-title = { -monitor-brand-short-name }
onboarding-benefit-monitor-text = შეიტყვეთ, თუ თქვენი ინფორმაცია ცნობილ მიტაცებულ მონაცემებში აღმოჩნდება.
onboarding-benefit-lockwise-title = { -lockwise-brand-short-name }
onboarding-benefit-lockwise-text = მართეთ და გადაიტანეთ პაროლები უსაფრთხოდ.

## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

onboarding-tracking-protection-title2 = თვალთვალისგან დაცვა
onboarding-tracking-protection-text2 = { -brand-short-name } გეხმარებათ, აუკრძალოთ საიტებს თქვენი თვალთვალი ინტერნეტში, რაც ურთულებს რეკლამებს შესაძლებლობას, თვალი გადევნოთ ვებსივრცეში.
onboarding-tracking-protection-button2 = როგორ მუშაობს
onboarding-data-sync-title = წაიყოლეთ თქვენი პარამეტრები თან
# "Sync" is short for synchronize.
onboarding-data-sync-text2 = დაასინქრონეთ თქვენი სანიშნები, პაროლები და სხვა მონაცემები ყველგან, სადაც გიყენიათ { -brand-product-name }.
onboarding-data-sync-button2 = { -sync-brand-short-name } – შესვლა
onboarding-firefox-monitor-title = შეიტყვეთ, მონაცემების მიტაცების შესახებ
onboarding-firefox-monitor-text2 = { -monitor-brand-name } მუდმივად გადაამოწმებს, არის თუ არა თქვენი ელფოსტა ბოლოს მიტაცებულ მონაცემებს შორის და გაცნობებთ აღმოჩენის შემთხვევაში.
onboarding-firefox-monitor-button = გამოიწერეთ ცნობები
onboarding-browse-privately-title = მოინახულეთ გვერდები უსაფრთხოდ
onboarding-browse-privately-text = პირადი თვალიერების რეჟიმი ასუფთავებს თქვენ მიერ მოძიებულ და მონახულებულ გვერდებს და არ უმხელს მათ შესახებ, თქვენი კომპიუტერის სხვა მომხმარებლებს
onboarding-browse-privately-button = პირადი ფანჯრის გახსნა
onboarding-firefox-send-title = დატოვეთ გაზიარებული ფაილები საიდუმლოდ
onboarding-firefox-send-text2 = ატვირთეთ თქვენი ფაილები, { -send-brand-name } კი გააზიარებს გამჭოლი დაშიფვრითა და ბმულით, რომელიც თავისით გაუქმდება, ვადის ამოწურვისას.
onboarding-firefox-send-button = გამოცადეთ { -send-brand-name }
onboarding-mobile-phone-title = გადმოწერეთ { -brand-product-name } თქვენს ტელეფონზე
onboarding-mobile-phone-text = { -brand-product-name } ჩამოტვირთეთ iOS ან Android-სისტემისთვის და დაასინქრონეთ მონაცემები ყველა მოწყობილობაზე.
# "Mobile" is short for mobile/cellular phone, "Browser" is short for web
# browser.
onboarding-mobile-phone-button = ჩამოტვირთეთ მობილურზე
onboarding-send-tabs-title = მყისიერად გადააგზავნეთ ჩანართები
# "Send Tabs" refers to "Send Tab to Device" feature that appears when opening a
# tab's context menu.
onboarding-send-tabs-text2 = მარტივად გააზიარეთ გვერდები თქვენს მოწყობილობებზე ბმულების ასლების გადატანისა და ბრაუზერის დატოვების გარეშე.
onboarding-send-tabs-button = გამოიყენეთ Send Tabs
onboarding-pocket-anywhere-title = წაიკითხეთ და მოისმინეთ ნებისმიერ ადგილას
onboarding-pocket-anywhere-text2 = გადაინახეთ თქვენი რჩეული მასალები ხაზგარეშედ { -pocket-brand-name }-პროგრამით და წაიკითხეთ, მოისმინეთ ან უყურეთ ხელსაყრელ ადგილას.
onboarding-pocket-anywhere-button = სცადეთ { -pocket-brand-name }
onboarding-lockwise-strong-passwords-title = შექმენით და შეინახეთ ძლიერი პაროლები
onboarding-lockwise-strong-passwords-text = { -lockwise-brand-name } მყისიერად ქმნის ძლიერ პაროლებს და ერთად ინახავს.
onboarding-lockwise-strong-passwords-button = ანგარიშების მონაცემების მართვა
onboarding-facebook-container-title = შემოსაზღვრეთ Facebook
onboarding-facebook-container-text2 = { -facebook-container-brand-name } განაცალკევებს თქვენს პროფილს დანარჩენი გვერდებისგან, რაც გაურთულებს Facebook-ს თქვენთვის მიზნობრივი რეკლამების შერჩევას.
onboarding-facebook-container-button = გაფართოების დამატება
onboarding-import-browser-settings-title = გადმოიტანეთ თქვენი სანიშნები, პაროლები და ა. შ.
onboarding-import-browser-settings-text = დაიწყეთ ახლავე — მარტივად წამოიღეთ თქვენი საიტები და პარამეტრები Chrome-იდან.
onboarding-import-browser-settings-button = Chrome-მონაცემების გადმოტანა
onboarding-personal-data-promise-title = პირადულობისთვის შექმნილი
onboarding-personal-data-promise-text = { -brand-product-name } თქვენს მონაცემებს ეპყრობა პატივისცემით, აღრიცხავს ნაკლებს, იცავს მას და ნათლად ხნის, როგორ იყენებს.
onboarding-personal-data-promise-button = წაიკითხეთ ჩვენი პირობა

## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = მშვენიერია, თქვენ უკვე გაქვთ { -brand-short-name }
# <icon></icon> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-header = ახლა, მოდით დავამატოთ <icon></icon><b>{ $addon-name }</b>
return-to-amo-extension-button = გაფართოების დამატება
return-to-amo-get-started-button = შეგიძლიათ გამოიყენოთ { -brand-short-name }
