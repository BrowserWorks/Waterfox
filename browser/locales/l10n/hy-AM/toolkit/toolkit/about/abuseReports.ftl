# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Localized string used as the dialog window title.
# "Report" is a noun in this case, "Report for AddonName".
#
# Variables:
#   $addon-name (string) - Name of the add-on being reported
abuse-report-dialog-title = Զեկույցել { $addon-name }֊ի համար

abuse-report-title-extension = Զեկուցեք այս ընդլայնման մասին { -vendor-short-name }-ին
abuse-report-title-theme = Զեկուցեք այս հիմնապատկերի մասին { -vendor-short-name }-ին
abuse-report-subtitle = Ի՞նչումն է խնդիրը։

# Variables:
#   $author-name (string) - Name of the add-on author
abuse-report-addon-authored-by = <a data-l10n-name="author-name">{ $author-name }</a>-ի կողմից

abuse-report-learnmore =
    Վստահ չե՞ք որ խնդիրը ընտրեք։
    <a data-l10n-name="learnmore-link">Իմանալ ավելին ընդլայնումները և հիմնապատկերները մասին զեկուցելիս</a>

abuse-report-submit-description = Նկարագրեք խնդիրը (ըստ ցանկության)
abuse-report-textarea =
    .placeholder = Եթե մենք ունենք առանձնահատկություններ մեզ համար ավելի հեշտ է խնդիրը լուծել։ Նկարագրեք ինչ եք փորձում։ Շնորհակալություն վեբը աշխտունակ պահելուն օգնելու համար։
abuse-report-submit-note =
    Նշում․ Մի ներառեք անձնական տվյալներ (օրինակ՝ անուն, էլ֊փոստի հասցե, հեռախոսահամար, ֆիզիկական հասցեն)։
    { -vendor-short-name } պահում է այս զեկույցների մշտական գրառումը։

## Panel buttons.

abuse-report-cancel-button = Չեղարկել
abuse-report-next-button = Հաջորդը
abuse-report-goback-button = Գնալ հետ
abuse-report-submit-button = Հաստատել

## Message bars descriptions.


## Variables:
##   $addon-name (string) - Name of the add-on

abuse-report-messagebar-aborted = <span data-l10n-name="addon-name">{ $addon-name }</span>-ի մասին զեկույցը չեղարկվել է։
abuse-report-messagebar-submitting = Ուղարկվում է զեկույց <span data-l10n-name="addon-name">{ $addon-name }</span>-ի համար։
abuse-report-messagebar-submitted = Շնորհակալություն զեկույցը ուղակելու համար։ Ցանկանու՞մ եք հեռացնել <span data-l10n-name="addon-name">{ $addon-name }</span>-ը։
abuse-report-messagebar-submitted-noremove = Շնորհակալություն զեկույցը ուղակելու համար։
abuse-report-messagebar-removed-extension = Շնորհակալություն զեկույցը ուղակելու համար։ Դուք հեռացրել եք <span data-l10n-name="addon-name">{ $addon-name }</span>-ի ընդլայնումը։
abuse-report-messagebar-removed-theme = Շնորհակալություն զեկույցն ուղարկելու համար։ Դուք հեռացրել եք <span data-l10n-name="addon-name">{ $addon-name }</span>-ի հիմնապատկերը։
abuse-report-messagebar-error = <span data-l10n-name="addon-name">{ $addon-name }</span>-ի համար զեկույց ուղարկելիս սխալ տեղի ունեցավ։
abuse-report-messagebar-error-recent-submit = <span data-l10n-name="addon-name">{ $addon-name }</span>-ի համար զեկույցը չի ուղարկվել, որովհետև վերջերս այլ զեկույց է հաստատվել։

## Message bars actions.

abuse-report-messagebar-action-remove-extension = Այո, հեռացրեք այն
abuse-report-messagebar-action-keep-extension = Ոչ, ես կպահեմ դա
abuse-report-messagebar-action-remove-theme = Այո, հեռացրեք այն
abuse-report-messagebar-action-keep-theme = Ոչ, ես կպահեմ դա
abuse-report-messagebar-action-retry = Կրկնել
abuse-report-messagebar-action-cancel = Չեղարկել

## Abuse report reasons (optionally paired with related examples and/or suggestions)

abuse-report-damage-reason-v2 = Դա վնասեց իմ համակարգչը կամ իմ տվյալները
abuse-report-damage-example = Օրինակ՝ ներածված վնասագիր կամ գողացված տվյալներ

abuse-report-spam-reason-v2 = Այն պարունակում է աղբ կամ ներածում է անցանկալի գովազդ
abuse-report-spam-example = Օրինակ՝ կայքերում ներածել գովազդներ

abuse-report-settings-reason-v2 = Այն փոխեց իմ որոնման միջոցը, տնէջը կամ նոր ներդիրը առանց ինձ տեղեկացնելու կամ հարցնելու
abuse-report-settings-suggestions = Նախքան ընդլայնման մասին զեկույց ուղարկելը, կարող եք փորձել փոխել Ձեր կարգավորումները․
abuse-report-settings-suggestions-search = Փոխել Ձեր լռելյայն որոնման կարգավորումները
abuse-report-settings-suggestions-homepage = Փոխել Ձեր տնէջը և նոր ներդիրը

abuse-report-deceptive-reason-v2 = Այն պնդում է, որ դա ինչ-որ բան չէ
abuse-report-deceptive-example = Օրինակ՝ ապակողմնորոշիչ նկարագրություն և պատկեր

abuse-report-broken-reason-extension-v2 = Չի աշխատում, կոտրում կայքեր կամ դանդաղեցնում։ { -brand-product-name }-ը
abuse-report-broken-reason-theme-v2 = Այն չի աշխատում կամ չի ընդհատում զննարկչի ցուցադրումը
abuse-report-broken-example = Օրինակ․ հատկությունները դանդաղ են, դժվար է օգտագործել կամ չեն աշխատում; կայքերի մասերը չեն բեռնվի կամ արտասովոր տեսք կունենան
abuse-report-broken-suggestions-extension =
    Թվում է, թե դուք սխալ եք հայտնաբերել: Բացի այստեղ զեկույց ներկայացնելուց՝ լավագույն միջոցը
    գործառության խնդրի լուծման համար, կապ հաստատելն է ընդլայնման մշակողի հետ:
    <a data-l10n-name="support-link">Այցելել ընդլայնման կայքէջ</a>՝ մշակողի տեղեկությունները ստանալու համար:
abuse-report-broken-suggestions-theme =
    Թվում է, թե դուք սխալ եք հայտնաբերել: Բացի այստեղ զեկույց ներկայացնելուց՝ լավագույն միջոցը
    գործառության խնդրի լուծման համար, կապ հաստատելն է ընդլայնման մշակողի հետ:
    <a data-l10n-name="support-link">Այցելել ձևավորման կայքէջ</a>՝ մշակողի տեղեկությունները ստանալու համար:

abuse-report-policy-reason-v2 = Այն պարունակում է ապօրինի, բռնի կամ ատելի բովանդակություն:
abuse-report-policy-suggestions =
    Նշում․Հեղինակային իրավունքի և ապրանքային նշանի խախտման պահանջները պետք է ներկայացվեն առանձին։
    <a data-l10n-name="report-infringement-link"> օգտագործեք այս հրահանգները </a>
    զեկուցել մի խնդրի մասին։

abuse-report-unwanted-reason-v2 = Ես երբեք դա չեմ ցանկացել և չգիտեմ, թե ինչպես ազատվել դրանից:
abuse-report-unwanted-example = Օրինակ․Հայտը տեղադրեց առանց իմ թույլտվության

abuse-report-other-reason = Այլ բան

