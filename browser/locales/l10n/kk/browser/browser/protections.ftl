# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $count (Number) - Number of tracking events blocked.
graph-week-summary =
    { $count ->
       *[other] { -brand-short-name } соңғы аптада { $count } трекерді бұғаттады
    }

# Variables:
#   $count (Number) - Number of tracking events blocked.
#   $earliestDate (Number) - Unix timestamp in ms, representing a date. The
# earliest date recorded in the database.
graph-total-tracker-summary =
    { $count ->
       *[other] { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") } кейін <b>{ $count }</b> трекер бұғатталды
    }

# Text displayed instead of the graph when in Private Mode
graph-private-window = { -brand-short-name } жекелік терезелерінде трекерлерді бұғаттауды жалғастырады, бірақ, не бұғатталғанын жазып отырмайды.
# Weekly summary of the graph when the graph is empty in Private Mode
graph-week-summary-private-window = Бұл аптада { -brand-short-name } бұғаттаған трекерлер

protection-report-webpage-title = Қорғаныс панелі
protection-report-page-content-title = Қорғаныс панелі
# This message shows when all privacy protections are turned off, which is why we use the word "can", Firefox is able to protect your privacy, but it is currently not.
protection-report-page-summary = { -brand-short-name } сіз шолу кезінде сіздің жекелігіңізді білдіртпей қорғай алады. Бұл қорғаныс туралы, оның ішінде сіздің онлайн қауіпсіздігіңізді бақылауға арналған құралдардың жеке жиынтығы.
# This message shows when at least some protections are turned on, we are more assertive compared to the message above, Firefox is actively protecting you.
protection-report-page-summary-default = { -brand-short-name } сіз шолу кезінде сіздің жекелігіңізді білдіртпей қорғайды. Бұл қорғаныс туралы, оның ішінде сіздің онлайн қауіпсіздігіңізді бақылауға арналған құралдардың жеке жиынтығы.

protection-report-settings-link = Жекелік және қауіпсіздік баптауларын басқару

etp-card-title-always = Бақылаудан кеңейтілген қорғаныс: Әрқашан іске қосылған
etp-card-title-custom-not-blocking = Бақылаудан кеңейтілген қорғаныс: СӨНДІРІЛГЕН
etp-card-content-description = { -brand-short-name } компанияларды интернетте сізді жасырын түрде бақылауын автоматты түрде тоқтатады.
protection-report-etp-card-content-custom-not-blocking = Барлық қорғаныс қазіргі уақытта сөндірілген. { -brand-short-name } қорғаныс баптауларын өзгерту арқылы қай трекерлерді бұғаттау керектігін таңдаңыз.
protection-report-manage-protections = Баптауларды басқару

# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = Бүгін

# This string is used to describe the graph for screenreader users.
graph-legend-description = Осы аптада бұғатталған трекерлердің әр түрінің жалпы санын көрсететін график.

social-tab-title = Әлеуметтік желілер трекерлері
social-tab-contant = Әлеуметтік желілер басқа веб-сайттарға сіз желіде не жасайтынын, қарайтынын және көретінін бақылау үшін трекерлерді орнатады. Бұл әлеуметтік желі компанияларына сіз әлеуметтік желі профилінде қалдырған ақпараттан бөлек сіз туралы көбірек білуге мүмкін етеді. <a data-l10n-name="learn-more-link">Көбірек білу</a>

cookie-tab-title = Сайтаралық бақылайтын cookie файлдары
cookie-tab-content = Бұл cookie файлдары Интернетте не істегеніңіз туралы мәліметтер жинау үшін сайттан сайтқа соңыңыздан еріп жүреді. Оларды жарнама берушілер мен аналитикалық компаниялар сияқты үшінші тараптар орнатады. Сайтаралық бақылайтын cookie файлдарын бұғаттау сіздің айналаңыздағы жарнама санын азайтады. <a data-l10n-name="learn-more-link">Көбірек білу</a>

tracker-tab-title = Бақылайтын құрама
tracker-tab-description = Веб-сайттар бақылау кодымен сыртқы жарнама, видео және басқа құраманы жүктей алады. Бақылайтын құраманы бұғаттау сайттардың жылдамдау жүктелуіне көмектеседі, бірақ, кейбір батырмалар, формалар және кіру өрістері жасамауы мүмкін. <a data-l10n-name="learn-more-link">Көбірек білу</a>

fingerprinter-tab-title = Цифрлық баспаны жинаушылар
fingerprinter-tab-content = Цифрлық баспаны жинаушылар сіздің профиліңізді жасау үшін браузер мен компьютерден параметрлерді жинайды. Бұл цифрлық саусақ ізін қолдана отырып, олар сізді әртүрлі веб-сайттар бойынша қадағалай алады. <a data-l10n-name="learn-more-link">Көбірек білу</a>

cryptominer-tab-title = Криптомайнерлер
cryptominer-tab-content = Криптомайнерлер жүйеңіздің есептеу қуатын цифрлық валютаны алу үшін қолданады. Криптомайнерлік скрипттер батареяны отырғызып, компьютерді тежейді және қуат шығындарын көбейтеді. <a data-l10n-name="learn-more-link">Көбірек білу</a>

protections-close-button2 =
    .aria-label = Жабу
    .title = Жабу
  
mobile-app-title = Көбірек құрылғылар арасында жарнама трекерлерін бұғаттаңыз
mobile-app-card-content = Құрамында жарнамалық трекерлерден қорғанысы бар мобильді браузерді қолданыңыз.
mobile-app-links = <a data-l10n-name="android-mobile-inline-link">Android</a> және <a data-l10n-name="ios-mobile-inline-link">iOS</a> үшін { -brand-product-name } браузері.

lockwise-title = Парольдерді енді ешқашан ұмытпаңыз
lockwise-title-logged-in2 = Парольдерді басқару
lockwise-header-content = { -lockwise-brand-name } парольдеріңізді браузерде қауіпсіз түрде сақтайды.
lockwise-header-content-logged-in = Парольдеріңізді барлық құрылғыларыңызда қауіпсіз түрде сақтау және синхрондау.
protection-report-save-passwords-button = Парольдерді сақтау
    .title = Парольдерді { -lockwise-brand-short-name } ішінде сақтау
protection-report-manage-passwords-button = Парольдерді басқару
    .title = Парольдерді { -lockwise-brand-short-name } ішінде басқару
lockwise-mobile-app-title = Парольдеріңізді өзіңізбен бірге алып жүріңіз
lockwise-no-logins-card-content = { -brand-short-name } ішінде сақталған парольдерді кез келген құрылғыда қолданыңыз.
lockwise-app-links = <a data-l10n-name="lockwise-android-inline-link">Android</a> және <a data-l10n-name="lockwise-ios-inline-link">iOS</a> үшін { -lockwise-brand-name }

# Variables:
# $count (Number) - Number of passwords exposed in data breaches.
lockwise-scanned-text-breached-logins =
    { $count ->
       *[other] { $count } пароль деректердің бұзылуында болуы мүмкін.
    }

# While English doesn't use the number in the plural form, you can add $count to your language
# if needed for grammatical reasons.
# Variables:
# $count (Number) - Number of passwords stored in Lockwise.
lockwise-scanned-text-no-breached-logins =
    { $count ->
       *[other] Сіздің парольдеріңіз сенімді сақталуда.
    }
lockwise-how-it-works-link = Ол қалай жұмыс істейді

turn-on-sync = { -sync-brand-short-name } іске қосу…
    .title = Синхрондау баптауларына өту

monitor-title = Деректердің ұрлануын бақылау
monitor-link = Бұл қалай жұмыс істейді
monitor-header-content-no-account = Белгілі бір деректердің бұзылуына қатысқаныңызды және жаңа бұзушылықтар туралы ескертулер алу үшін { -monitor-brand-name } тексеріңіз.
monitor-header-content-signed-in = { -monitor-brand-name } сіздің ақпаратыңыз белгілі деректерді бұзуда табылса, сізге ескертеді.
monitor-sign-up-link = Бұзушылық туралы ескертулерге жазылу
    .title = Бұзушылық туралы ескертулерге { -monitor-brand-name } арқылы жазылу
auto-scan = Бүгін автоматты түрде сканерленді

monitor-emails-tooltip =
    .title = { -monitor-brand-short-name } адресінен бақыланатын эл. пошта адрестерін қарау
monitor-breaches-tooltip =
    .title = { -monitor-brand-short-name } адресінен белгілі деректер бұзушылықтарын қарау
monitor-passwords-tooltip =
    .title = { -monitor-brand-short-name } адресінен ашылған парольдерді қарау

# This string is displayed after a large numeral that indicates the total number
# of email addresses being monitored. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-monitored-emails =
    { $count ->
       *[other] Бақыланатын эл. пошта адрестері
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-known-breaches-found =
    { $count ->
       *[other] Ішінен сіздің ақпаратыңыз табылған белгілі деректерді бұзушылықтары
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-known-breaches-resolved =
    { $count ->
       *[other] Шешілген деп белгіленген белгілі деректер бұзушылықтары
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-exposed-passwords-found =
    { $count ->
       *[other] Барлық бұзушылықтардан ашылған парольдер
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-exposed-passwords-resolved =
    { $count ->
       *[other] Шешілмеген бұзушылықтарда ашылған парольдер
    }

monitor-no-breaches-title = Жақсы жаңалық!
monitor-no-breaches-description = Сізде белгілі бұзушылықтар жоқ. Егер бұл өзгерсе, біз сізге хабарлаймыз.
monitor-view-report-link = Есептемені қарау
    .title = { -monitor-brand-short-name } ішінде бұзушылықтарды шешу
monitor-breaches-unresolved-title = Деерктер бұзушылықтарын шешу
monitor-breaches-unresolved-description = Бұзушылық туралы егжей-тегжейлі мәліметтерді қарап шыққаннан кейін және ақпаратты қорғау үшін шаралар қабылдағаннан кейін сіз бұзушылықтарды шешілген ретінде белгілей аласыз.
monitor-manage-breaches-link = Бұзушылықтарды басқару
    .title = Бұзушылықтарды { -monitor-brand-short-name } арқылы басқару
monitor-breaches-resolved-title = Тамаша! Сіз барлық белгілі бұзушылықтарды шешіп алдыңыз.
monitor-breaches-resolved-description = Егер сіздің электронды поштаңыз қандай да бір жаңа бұзушылықтарда пайда болса, біз сізге хабарлаймыз.

# Variables:
# $numBreachesResolved (Number) - Number of breaches marked as resolved by the user on Monitor.
# $numBreaches (Number) - Number of breaches in which a user's data was involved, detected by Monitor.
monitor-partial-breaches-title =
    { $numBreaches ->
       *[other] { $numBreaches } ішінен { $numBreachesResolved } деректер бұзушылығы шешілді
    }

# Variables:
# $percentageResolved (Number) - Percentage of breaches marked as resolved by a user on Monitor.
monitor-partial-breaches-percentage = { $percentageResolved }% дайын

monitor-partial-breaches-motivation-title-start = Керемет бастама!
monitor-partial-breaches-motivation-title-middle = Жалғастырыңыз!
monitor-partial-breaches-motivation-title-end = Бітуге сәл қалды! Жалғастырыңыз.
monitor-partial-breaches-motivation-description = Деректер бұзушылықтардың қалғанын { -monitor-brand-short-name } арқылы шешіңіз.
monitor-resolve-breaches-link = Деректер бұзушылықтарын шешу
    .title = Деректер бұзушылықтарын { -monitor-brand-short-name } арқылы шешу

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

bar-tooltip-social =
    .title = Әлеуметтік желілер трекерлері
    .aria-label =
        { $count ->
           *[other] { $count } әлеуметтік желілер трекері ({ $percentage }%)
        }
bar-tooltip-cookie =
    .title = Сайтаралық бақылайтын cookie файлдары
    .aria-label =
        { $count ->
           *[other] { $count } сайтаралық бақылайтын cookie файл ({ $percentage }%)
        }
bar-tooltip-tracker =
    .title = Бақылайтын құрама
    .aria-label =
        { $count ->
           *[other] { $count } бақылайтын құрама ({ $percentage }%)
        }
bar-tooltip-fingerprinter =
    .title = Баспаны жинаушылар
    .aria-label =
        { $count ->
           *[other] { $count } баспаны жинаушы ({ $percentage }%)
        }
bar-tooltip-cryptominer =
    .title = Криптомайнерлер
    .aria-label =
        { $count ->
           *[other] { $count } криптомайнер ({ $percentage }%)
        }
