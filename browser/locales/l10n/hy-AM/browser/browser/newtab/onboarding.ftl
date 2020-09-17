# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-learn-more = Իմանալ ավելին
onboarding-button-label-get-started = Սկսել

## Welcome modal dialog strings

onboarding-welcome-header = Բարի գալուստ { -brand-short-name }
onboarding-welcome-body = Դուք ունեք զննարկիչ: <br/> Ծանոթացեք { -brand-product-name } -ի մնացած մասի հետ:
onboarding-welcome-learn-more = Իմացեք ավելին առավելությունների մասին:
onboarding-welcome-modal-get-body = Դուք ունեք զննարկիչը։<br/>Հիմա ստացեք առավելագույնը { -brand-product-name }-ից։
onboarding-welcome-modal-supercharge-body = Գերազանցեք ձեր գաղտնիության պաշտպանությունը։
onboarding-welcome-modal-privacy-body = Դուք ունեք զննարկիչ։ եկեք ավելացնենք ավելի շատ գաղտնիության պաշտպանություն։
onboarding-welcome-modal-family-learn-more = Իմացեք { -brand-product-name } ապրանքների ընտանիքի մասին։
onboarding-welcome-form-header = Սկսեք այստեղ

onboarding-join-form-body = Սկսելու համար մուտքագրեք ձեր էլ. Փոստի հասցեն:
onboarding-join-form-email =
    .placeholder = Մուտքագրեք էլ․ փոստ
onboarding-join-form-email-error = Անհրաժեշտ է վավեր էլ․ փոստ
onboarding-join-form-legal = Շարունակելով, դուք համաձայնվում եք <a data-l10n-name="terms"> Ծառայությունների մատուցման պայմանների </a> և <a data-l10n-name="privacy"> Գաղտնիության ծանուցման </a> հետ:
onboarding-join-form-continue = Շարունակել

# This message is followed by a link using onboarding-join-form-signin ("Sign In") as text.
onboarding-join-form-signin-label = Արդեն ունե՞ք հաշիվ։
# Text for link to submit the sign in form
onboarding-join-form-signin = Մուտք գործել

onboarding-start-browsing-button-label = Սկսել դիտարկումը
onboarding-cards-dismiss =
    .title = Բաց թողնել
    .aria-label = Բաց թողնել

## Multistage 3-screen onboarding flow strings (about:welcome pages)

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-welcome-header = Բարի գալուստ <span data-l10n-name="zap">{ -brand-short-name }</span>

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

## Welcome full page string

onboarding-fullpage-welcome-subheader = Եկեք սկսենք ուսումնասիրել այն ամենը, ինչ կարող եք անել։
onboarding-fullpage-form-email =
    .placeholder = Ձեր էլ֊փոստի հասցեն…

## Firefox Sync modal dialog strings.

onboarding-sync-welcome-header = Վերցրեք { -brand-product-name } ձեզ հետ
onboarding-sync-welcome-content = Ստացեք ձեր էջանիծերը, պատմությունը, գաղտնաբառերը և այլ կարգավորումներ ձեր բոլոր սարքերում:
onboarding-sync-welcome-learn-more-link = Իմանալ ավելին Firefox Հաշիվների մասին

onboarding-sync-form-input =
    .placeholder = Էլ. փոստ

onboarding-sync-form-continue-button = Շարունակել
onboarding-sync-form-skip-login-button = Բաց թողնել այս քայլը

## This is part of the line "Enter your email to continue to Firefox Sync"

onboarding-sync-form-header = Մուտքագրեք ձեր էլ․ փոստը
onboarding-sync-form-sub-header = շարունակել { -sync-brand-name }


## These are individual benefit messages shown with an image, title and
## description.

onboarding-benefit-products-text = Ավարտեք գործերը օգտագործելով  գործիքաընտանիքները, որոնք հարգում են Ձեր գաղտնիությունը սարքերում։

# "Personal Data Promise" is a concept that should be translated consistently
# across the product. It refers to a concept shown elsewhere to the user: "The
# Firefox Personal Data Promise is the way we honor your data in everything we
# make and do. We take less data. We keep it safe. And we make sure that we are
# transparent about how we use it."
onboarding-benefit-privacy-text = Այն ամենը, ինչ մենք անում ենք, հարգում է մեր անձնական տվյալների խոստումը. Քիչ վերցրեք: Ապահով պահեք: Ոչ մի գաղտնիք:

onboarding-benefit-sync-title = { -sync-brand-short-name }
onboarding-benefit-sync-text = Վերցրեք ձեր էջանիշները, գաղտնաբառերը, պատմությունը և ավելին, որտեղ օգտագործում եք { -brand-product-name }։

onboarding-benefit-monitor-title = { -monitor-brand-short-name }
onboarding-benefit-monitor-text = Տեղեկացեք, երբ ձեր անձնական տեղեկությունները հայտնի տվյալների խախտման մեջ են։

onboarding-benefit-lockwise-title = { -lockwise-brand-short-name }
onboarding-benefit-lockwise-text = Կառավարեք գաղտնաբառերը, որոնք պաշտպանված և շարժական են։


## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

onboarding-tracking-protection-title2 = Պաշտպանություն հետևելուց
onboarding-tracking-protection-text2 = { -brand-short-name }-ը օգնում է դադարեցնել կայքերի կողմից ձեր առցանց հետագծումը, ինչը բարդեցնում է գովազդների կողմից Ձեզ հետևելը։
onboarding-tracking-protection-button2 = Ինչպես է դա աշխատում

onboarding-data-sync-title = Վերցրեք ձեր կարգավորումները ձեզ հետ
# "Sync" is short for synchronize.
onboarding-data-sync-text2 = Համաժամեցրեք ձեր էջանիշները, գաղտնաբառերը և ավելին, որտեղ դուք օգտագործում եք { -brand-product-name }։
onboarding-data-sync-button2 = Մուտք գործել { -sync-brand-short-name }

onboarding-firefox-monitor-title = Զգուշացեք տվյալների խախտումների մասին
onboarding-firefox-monitor-text2 = { -monitor-brand-name } վերահսկում է, եթե ձեր էլ֊փոտը հայտնվել է հայտնի տվյալների խախտմամբ և ահազանգում է ձեզ, եթե այն հայտնվում է նոր խախտմամբ։
onboarding-firefox-monitor-button = Գրանցվեք զգուշացման համար

onboarding-browse-privately-title = Զննարկչի գաղտնիություն
onboarding-browse-privately-text = Գաղտնի զննարկումը մաքրում է ձեր որոնման և զննարկման պատմությունը` յուրաքանչյուրից օգտատիրոջից գաղտնի պահելու համար։
onboarding-browse-privately-button = Բացել գաղտնի պատուհան

onboarding-firefox-send-title = Ձեր Տարածած ֆայլերը պահեք Գաղտնի։
onboarding-firefox-send-text2 = Վերբեռնեք Ձեր նիշքերը { -send-brand-name } դրանք վերջապես ծածկագրելու և ինքնաբերաբար ավարտվող հղման հետ համօգտագործելու համար։
onboarding-firefox-send-button = Փորձեք { -send-brand-name }

onboarding-mobile-phone-title = Ունեցեք { -brand-product-name }-ը Ձեր հեռախոսում
onboarding-mobile-phone-text = Ներբեռնեք { -brand-product-name }-ը iOS- ի կամ Android- ի համար և համաժամեցրեք Ձեր տվյալները սարքերում։
# "Mobile" is short for mobile/cellular phone, "Browser" is short for web
# browser.
onboarding-mobile-phone-button = Ներբեռնել բջջային զննարկիչ

onboarding-send-tabs-title = Անմիջապես ինքներդ ուղարկեք Ձեզ ներդիրները
# "Send Tabs" refers to "Send Tab to Device" feature that appears when opening a
# tab's context menu.
onboarding-send-tabs-text2 = Հեշտությամբ տարածեք էջերը Ձեր սարքերի միջև առանց հղումները պատճենելու կամ զննարկիչը լքելու։
onboarding-send-tabs-button = Սկսեք օգտագործել ներդիրների ուղարկումը

onboarding-pocket-anywhere-title = Ամեն դեպքում կարդալ և լսել
onboarding-pocket-anywhere-text2 = Պահպանեք Ձեր նախընտրած բովանդակությունն անցանց ռեժիմով՝ { -pocket-brand-name } ծրագրով և կարդացեք, լսեք և դիտեք, երբ դա ձեր համար հարմար է։
onboarding-pocket-anywhere-button = Փորձեք { -pocket-brand-name }

onboarding-lockwise-strong-passwords-title = Ստեղծեք և պահեք լավ գաղտնաբառեր
onboarding-lockwise-strong-passwords-text = { -lockwise-brand-name }-ը միանգամից ստեղծում է լավ գաղտնաբառեր և պահում դրանք մեկ տեղում։
onboarding-lockwise-strong-passwords-button = Ձեր մուտքանունների կառավարում։

onboarding-facebook-container-title = Սահմանեք սահմաններ Facebook-ի հետ
onboarding-facebook-container-text2 = { -facebook-container-brand-name } ձեր հատկագիրը զերծ է պահում մնացած ամեն ինչից, ավելի դժվար է դարձնում Facebook-ի համար ձեզ գովազդով թիրախավորելը։
onboarding-facebook-container-button = Ավելացնել ընդլայնում

onboarding-import-browser-settings-title = Ներածեք Ձեր էջանիշերը, գաղտնաբառերը և ավելին
onboarding-import-browser-settings-text = Սուզվեք աջ — հեշտությամբ բերեք ձեր Chrome կայքերն ու պարամետրերը ձեզ հետ:
onboarding-import-browser-settings-button = Ներածել Chrome-ի տվյալները

onboarding-personal-data-promise-title = Անձնական է իր ձևավորմամբ
onboarding-personal-data-promise-text = { -brand-product-name }-ը վերաբերվում է ձեր տվյալներին հարգանքով՝ վերցնելով ավելի քիչ, պաշտպանելով այն և անկեղղծ լինելով, թե ինչպես ենք մենք օգտագործում այն:
onboarding-personal-data-promise-button = Կարդացեք մեր Խոստումը

## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = Հիանալի է, դուք ստացել եք { -brand-short-name }-ը

# <icon></icon> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-header = Այժմ ստացեք ձեր <icon></icon><b>{ $addon-name }-ը:</b></b>
return-to-amo-extension-button = Ավելացնել ընդլայնում
return-to-amo-get-started-button = Սկսեք { -brand-short-name }-ից
