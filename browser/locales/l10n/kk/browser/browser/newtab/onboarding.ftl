# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-learn-more = Көбірек білу
onboarding-button-label-get-started = Бастау

## Welcome modal dialog strings

onboarding-welcome-header = { -brand-short-name } өніміне қош келдіңіз
onboarding-welcome-body = Браузеріңіз бар.<br/>{ -brand-product-name } қалған бөлігімен танысыңыз.
onboarding-welcome-learn-more = Артықшылықтары туралы көбірек біліңіз.
onboarding-welcome-modal-get-body = Браузеріңіз бар.<br/>Енді { -brand-product-name } максималды мәнін алыңыз.
onboarding-welcome-modal-supercharge-body = Құпиялылықты қорғаңыз.
onboarding-welcome-modal-privacy-body = Браузеріңіз бар. Көбірек жекелік қорғанысты қосайық.
onboarding-welcome-modal-family-learn-more = { -brand-product-name } өнімдер отбасы туралы көбірек біліңіз.
onboarding-welcome-form-header = Осы жерден бастаңыз
onboarding-join-form-body = Бастау үшін, эл. пошта адресіңізді енгізіңіз.
onboarding-join-form-email =
    .placeholder = Эл. поштаны енгізіңіз
onboarding-join-form-email-error = Жарамды эл. пошта адресі керек
onboarding-join-form-legal = Жалғастыру арқылы сіз <a data-l10n-name="terms">Қызмет көрсету шарттары</a> және <a data-l10n-name="privacy">Жекелік ескертуі</a> шарттарымен келісесіз.
onboarding-join-form-continue = Жалғастыру
# This message is followed by a link using onboarding-join-form-signin ("Sign In") as text.
onboarding-join-form-signin-label = Тіркелгіңіз бар ма?
# Text for link to submit the sign in form
onboarding-join-form-signin = Кіру
onboarding-start-browsing-button-label = Шолуды бастау
onboarding-cards-dismiss =
    .title = Тайдыру
    .aria-label = Тайдыру

## Multistage 3-screen onboarding flow strings (about:welcome pages)

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-welcome-header = <span data-l10n-name="zap">{ -brand-short-name }</span> ішіне қош келдіңіз
onboarding-multistage-welcome-subtitle = Коммерциялық емес ұйымы қолдайтын жылдам, қауіпсіз және жеке браузер.
onboarding-multistage-welcome-primary-button-label = Баптауды бастау
onboarding-multistage-welcome-secondary-button-label = Кіру
onboarding-multistage-welcome-secondary-button-text = Тіркелгіңіз бар ма?
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "more" should stay inside the span.
onboarding-multistage-import-header = Парольдер, бетбелгілер және <br/><span data-l10n-name="zap">көптеген басқаны</span> импорттаңыз
onboarding-multistage-import-subtitle = Басқа браузерден келдіңіз бе? { -brand-short-name } ішіне барлығын әкелу оп-оңай.
onboarding-multistage-import-primary-button-label = Импорттауды бастау
onboarding-multistage-import-secondary-button-label = Қазір емес
# Info displayed in the footer of import settings screen during onboarding flow.
# This supports welcome screen showing top sites imported from the user's default browser.
onboarding-import-sites-disclaimer = Бұл сайттар осы құрылғыдан табылды. { -brand-short-name } деректерді басқа браузерден деректерді сіз оларды импорттағанша дейін синхрондамайды.
# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = Жұмысты бастау: экран { $current }, барлығы { $total }
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "look" should stay inside the span.
onboarding-multistage-theme-header = <span data-l10n-name="zap">Сыртқы түрін</span> таңдаңыз
onboarding-multistage-theme-subtitle = { -brand-short-name } өнімін тема көмегімен жеке қылыңыз.
onboarding-multistage-theme-primary-button-label = Теманы сақтау
onboarding-multistage-theme-secondary-button-label = Қазір емес
# Automatic theme uses operating system color settings
onboarding-multistage-theme-label-automatic = Автоматты түрде
# System refers to the operating system
onboarding-multistage-theme-description-automatic = Жүйелік теманы қолдану
onboarding-multistage-theme-label-light = Ашық түсті
onboarding-multistage-theme-label-dark = Күңгірт түсті
# "Firefox Alpenglow" here is the name of the theme, and should be kept in English.
onboarding-multistage-theme-label-alpenglow = Firefox Alpenglow

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

# Tooltip displayed on hover of automatic theme
onboarding-multistage-theme-tooltip-automatic =
    .title =
        Батырмалар, мәзірлер және терезелер үшін
        операциялық жүйенің сыртқы түрін мұралау.
    .aria-label = { onboarding-multistage-theme-tooltip-automatic.title }
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light =
    .title =
        Батырмалар, мәзірлер және терезелер үшін
        ашық түсті сыртқы түрін қолдану.
    .aria-label = { onboarding-multistage-theme-tooltip-light.title }
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark =
    .title =
        Батырмалар, мәзірлер және терезелер үшін
        күңгірт түсті сыртқы түрін қолдану.
    .aria-label = { onboarding-multistage-theme-tooltip-dark.title }
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow =
    .title =
        Батырмалар, мәзірлер және терезелер үшін
        түрлі түсті сыртқы түрін қолдану.
    .aria-label = { onboarding-multistage-theme-tooltip-alpenglow.title }
# Tooltip displayed on hover of automatic theme
onboarding-multistage-theme-tooltip-automatic-2 =
    .title =
        Батырмалар, мәзірлер және терезелер үшін
        операциялық жүйенің сыртқы түрін мұралау.
# Input description for automatic theme
onboarding-multistage-theme-description-automatic-2 =
    .aria-description =
        Батырмалар, мәзірлер және терезелер үшін
        операциялық жүйенің сыртқы түрін мұралау.
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light-2 =
    .title =
        Батырмалар, мәзірлер және терезелер үшін
        ашық түсті сыртқы түрін қолдану.
# Input description for light theme
onboarding-multistage-theme-description-light =
    .aria-description =
        Батырмалар, мәзірлер және терезелер үшін
        ашық түсті сыртқы түрін қолдану.
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark-2 =
    .title =
        Батырмалар, мәзірлер және терезелер үшін
        күңгірт түсті сыртқы түрін қолдану.
# Input description for dark theme
onboarding-multistage-theme-description-dark =
    .aria-description =
        Батырмалар, мәзірлер және терезелер үшін
        күңгірт түсті сыртқы түрін қолдану.
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow-2 =
    .title =
        Батырмалар, мәзірлер және терезелер үшін
        түрлі түсті сыртқы түрін қолдану.
# Input description for Alpenglow theme
onboarding-multistage-theme-description-alpenglow =
    .aria-description =
        Батырмалар, мәзірлер және терезелер үшін
        түрлі түсті сыртқы түрін қолдану.

## Welcome full page string

onboarding-fullpage-welcome-subheader = Қолыңыздан келетін барлығын зерттей бастайық.
onboarding-fullpage-form-email =
    .placeholder = Эл. пошта адресіңіз…

## Firefox Sync modal dialog strings.

onboarding-sync-welcome-header = { -brand-product-name }-ты өзіңізбен бірге алыңыз
onboarding-sync-welcome-content = Бетбелгілер, тарих, парольдер және т.б. баптауларды құрылғыларыңыздың барлығында алыңыз.
onboarding-sync-welcome-learn-more-link = Firefox тіркелгілері туралы көбірек білу
onboarding-sync-form-input =
    .placeholder = Эл. пошта
onboarding-sync-form-continue-button = Жалғастыру
onboarding-sync-form-skip-login-button = Бұл қадамды аттап кету

## This is part of the line "Enter your email to continue to Firefox Sync"

onboarding-sync-form-header = Эл. поштаны енгізіңіз
onboarding-sync-form-sub-header = { -sync-brand-name } жалғастыру үшін.

## These are individual benefit messages shown with an image, title and
## description.

onboarding-benefit-products-text = Құрылғыларыңыздағы жеке өміріңізді құрметтейтін құралдар отбасымен жұмыс жасаңыз.
# "Personal Data Promise" is a concept that should be translated consistently
# across the product. It refers to a concept shown elsewhere to the user: "The
# Firefox Personal Data Promise is the way we honor your data in everything we
# make and do. We take less data. We keep it safe. And we make sure that we are
# transparent about how we use it."
onboarding-benefit-privacy-text = Біз жасайтын барлық нәрсе біздің Жеке Деректер Уәдесіне сай: Азырақ алу. Оны қауіпсіз сақтау. Құпиясыз.
onboarding-benefit-sync-title = { -sync-brand-short-name }
onboarding-benefit-sync-text = { -brand-product-name } қолданатын барлық жерде бетбелгілер, парольдер және т.б. өзіңізбен бірге ұстаңыз.
onboarding-benefit-monitor-title = { -monitor-brand-short-name }
onboarding-benefit-monitor-text = Сіздің жеке ақпаратыңыз белгілі деректер ұрланған деректер ішінде болғанда хабарлама алу.
onboarding-benefit-lockwise-title = { -lockwise-brand-short-name }
onboarding-benefit-lockwise-text = Қорғалған және тасымалданатын парольдерді басқару.

## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

onboarding-tracking-protection-title2 = Бақылаудан қорғаныс
onboarding-tracking-protection-text2 = { -brand-short-name } веб-сайттарды сізді желіде бақылауды тоқтатуға көмектеседі, жарнамаға сізді интернетте артыңыздан еруді қиындатады.
onboarding-tracking-protection-button2 = Ол қалай жұмыс істейді
onboarding-data-sync-title = Баптауларыңызды өзіңізбен бірге алып жүріңіз
# "Sync" is short for synchronize.
onboarding-data-sync-text2 = { -brand-product-name } қолданатын барлық жерде бетбелгілер, парольдер және т.б. синхрондаңыз.
onboarding-data-sync-button2 = { -sync-brand-short-name } ішіне кіріңіз
onboarding-firefox-monitor-title = Деректердің жайылып кетулері туралы біліп отырыңыз
onboarding-firefox-monitor-text2 = { -monitor-brand-name } сіздің эл. пошта адресіңіз деректердің белгілі ұрлануында көрінгенін бақылап, табылған уақытта сізге хабарлайды.
onboarding-firefox-monitor-button = Хабарламаларға жазылу
onboarding-browse-privately-title = Жекелік түрде шолыңыз
onboarding-browse-privately-text = Жекелік шолу компьютеріңіздің қолданатын адамдардан құпия сақтау үшін сіздің іздеулер және шолу тарихыңыхжы өшіреді.
onboarding-browse-privately-button = Жекелік шолу терезесін ашу
onboarding-firefox-send-title = Ортақ пайдаланылатын файлдарыңызды жеке ұстаңыз
onboarding-firefox-send-text2 = Толық шифрлеу және автоматты түрде мерзімі аяқталатын сілтемемен бөлісу үшін, файлдарыңызды { -send-brand-name } көмегімен жүктеңіз.
onboarding-firefox-send-button = { -send-brand-name } қолданып көріңіз
onboarding-mobile-phone-title = { -brand-product-name } өз телефоныңыға алыңыз
onboarding-mobile-phone-text = iOS немесе Android үшін { -brand-product-name } жүктеп алып, деректеріңізді құрылғылар арасында синхрондаңыз.
# "Mobile" is short for mobile/cellular phone, "Browser" is short for web
# browser.
onboarding-mobile-phone-button = Мобильді браузерді жүктеп алу
onboarding-send-tabs-title = Браузер беттерін өзіңізге лезде жіберіңіз
# "Send Tabs" refers to "Send Tab to Device" feature that appears when opening a
# tab's context menu.
onboarding-send-tabs-text2 = Сілтемелерді көшірмей, немесе браузерден кетусіз-ақ беттермен жеңіл түрде бөлісіңіз.
onboarding-send-tabs-button = Беттерді жіберу мүмкіндігін қолдануды бастау
onboarding-pocket-anywhere-title = Кез келген жерде оқу және тыңдау
onboarding-pocket-anywhere-text2 = Таңдамалы мазмұнды оффлайн түрде { -pocket-brand-name } қолданбасымен сақтап, өзіңізге лайықты уақытта оқу, тыңдау немесе қарауға болады.
onboarding-pocket-anywhere-button = { -pocket-brand-name } қолданып көріңіз
onboarding-lockwise-strong-passwords-title = Қатаң парольдерді жасау және сақтау
onboarding-lockwise-strong-passwords-text = { -lockwise-brand-name } қатаң парольдерді лезде жасайды және олардың барлығын бір жерде сақтайды.
onboarding-lockwise-strong-passwords-button = Логиндеріңізді басқару
onboarding-facebook-container-title = Фейсбук үшін шекараларды орнатыңыз
onboarding-facebook-container-text2 = { -facebook-container-brand-name } профиліңізді басқа нәрседен бөлек ұстап, Фейсбук үшін сізге мақсатталған жарнаманы көрсетуге қиынырақ етеді.
onboarding-facebook-container-button = Кеңейтуді қосу
onboarding-import-browser-settings-title = Бетбелгілер, парольдерді және т.б. импорттау
onboarding-import-browser-settings-text = Тікелей кірісу — Chrome сайттары және баптауларын оңай көшіріп алыңыз.
onboarding-import-browser-settings-button = Chrome деректерін импорттау
onboarding-personal-data-promise-title = Дизайн бойынша жеке
onboarding-personal-data-promise-text = { -brand-product-name } сіздің деректеріңізді құрметпен өңдейді, олардан азырақ алып, қорғап, біз оларды қалай қолданатынымызды туралы тікелей хабарлайды.
onboarding-personal-data-promise-button = Біздің уәдемізді оқу

## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = Тамаша, сіз { -brand-short-name } орнаттыңыз
# <icon></icon> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-header = Енді <icon></icon><b>{ $addon-name }</b> орнатайық.
return-to-amo-extension-button = Кеңейтуді қосу
return-to-amo-get-started-button = { -brand-short-name } өнімімен жұмысты бастау
