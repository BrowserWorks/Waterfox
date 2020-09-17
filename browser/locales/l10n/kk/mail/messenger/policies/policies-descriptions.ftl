# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Thunderbird installations
## all at once. This is traditionally done through the Windows Group Policy
## feature, but the system also supports other forms of deployment.
## These are short descriptions for individual policies, to be displayed
## in the documentation section in about:policies.

policy-3rdparty = WebExtensions chrome.storage.managed арқылы қатынай алатын саясаттарды орнатыңыз.

policy-AppAutoUpdate = Қолданбаны автожаңартуды іске қосу немесе сөндіру.

policy-AppUpdateURL = Қолданбаны жаңартудың таңдауыңызша URL-ын орнату.

policy-Authentication = Құрамдас аутентификациясын қолдайтын веб-сайттары үшін оны баптау.

policy-BlockAboutAddons = Қосымшалар басқарушысына (about:addons) қатынауды бұғаттау.

policy-BlockAboutConfig = about:config парағына қатынауды бұғаттау.

policy-BlockAboutProfiles = about:profiles парағына қатынауды бұғаттау.

policy-BlockAboutSupport = about:support парағына қатынауды бұғаттау.

policy-CaptivePortal = Ұстайтын портаға қолдауды іске қосу немесе сөндіру.

policy-CertificatesDescription = Сертификаттарды қосу немесе құрамындағы сертификаттарды пайдалану.

policy-Cookies = Веб-сайттарға cookies файлдарын орнатуды рұқсат ету немесе тыйым салу.

policy-DisabledCiphers = Шифрлерді сөндіру.

policy-DefaultDownloadDirectory = Негізгі жүктеп алулар бумасын орнату.

policy-DisableAppUpdate = { -brand-short-name } үшін жаңартылуға тыйым салу.

policy-DisableDefaultClientAgent = Үнсіз келісім бойынша клиент агентіне ешбір әрекетті таңдауға жол бермейді. Тек Windows үшін қолданылады; басқа платформаларда агент жоқ.

policy-DisableDeveloperTools = Әзірлеуші құралдарына қатынауды бұғаттау.

policy-DisableFeedbackCommands = Көмек мәзірінен кері байланысты жіберу командаларын сөндіру (Кері байланыс хабарламасын жіберу және Фишингті сайт туралы хабарлау).

policy-DisableForgetButton = Ұмыту батырмасына қатынауды бұғаттау.

policy-DisableFormHistory = Іздеу және формалар тарихын сақтамау.

policy-DisableMasterPasswordCreation = Мәні true болса, мастер-парольді орнату мүмкін болмайды.

policy-DisablePasswordReveal = Сақталған логиндерде парольдердің ашылуына жол бермеу.

policy-DisableProfileImport = Басқа қолданбадан деректерді импорттау мәзір командасын сөндіру.

policy-DisableSafeMode = Қауіпсіз режимде қайта іске қосылу мүмкіндігін сөндіру. Ескерту: Қауіпсіз режиміне өту үшін Shift пернесін Windows-та тек Топтық Саясат көмегімен сөндіруге болады.

policy-DisableSecurityBypass = Пайдаланушыға кейбір қауіпсіздік ескертулерді аттап кетуге рұқсат етпеу.

policy-DisableSystemAddonUpdate = { -brand-short-name } үшін жүйелік қосымшаларды орнатуға және жаңартуға тыйым салу.

policy-DisableTelemetry = Телеметрияны сөндіру.

policy-DisplayMenuBar = Мәзір жолағын үнсіз келісім бойынша көрсету.

policy-DNSOverHTTPS = HTTPS арқылы DNS баптау.

policy-DontCheckDefaultClient = Іске қосылғанда негізгі клиент екеніне тексеруді сөндіру.

policy-DownloadDirectory = Жүктеп алулар бумасын орнату және бұғаттау.

# “lock” means that the user won’t be able to change this setting
policy-EnableTrackingProtection = Құраманы бұғаттауды іске қосу немесе сөндіру, және қосымша түрде оны бекіту.

# “lock” means that the user won’t be able to change this setting
policy-EncryptedMediaExtensions = Шифрленген медиа кеңейтулерін іске қосу немесе сөндіру, және қосымша түрде оны бекіту.

# A “locked” extension can’t be disabled or removed by the user. This policy
# takes 3 keys (“Install”, ”Uninstall”, ”Locked”), you can either keep them in
# English or translate them as verbs.
policy-Extensions = Кеңейтулерді орнату, өшіру немесе бекіту. Орнату опциясы параметрлер ретінде URL-дер немесе орналасуларды қабылдайды. Өшіру және Бекіту опциялары кеңейтулер ID-ін қабылдайды.

policy-ExtensionSettings = Кеңейту орнатылуының барлық жақтарын басқару.

policy-ExtensionUpdate = Кеңейтулерді автожаңартуды іске қосу немесе сөндіру.

policy-HardwareAcceleration = Мәні false болса, құрылғылық үдетуді сөндіру.

policy-InstallAddonsPermission = Кейбір веб-сайттарға қосымшаларды орнатуды рұқсат ету.

policy-LegacyProfiles = Әр орнату үшін бөлек профильді талап ететін мүмкіндікті сөндіру.

## Do not translate "SameSite", it's the name of a cookie attribute.

policy-LegacySameSiteCookieBehaviorEnabled = SameSite cookie үшін ескі әрекет баптауын іске қосу.

policy-LegacySameSiteCookieBehaviorEnabledForDomainList = Көрсетілген сайттарда SameSite cookie үшін ескі әрекет баптауына ауысу.

##

policy-LocalFileLinks = Арнайы веб-сайттарға жергілікті файлдарға сілтеуді рұқсат ету.

policy-NetworkPrediction = Желі болжамын іске қосу немесе сөндіру (DNS алдын-ала таңдау).

policy-OfferToSaveLogins = { -brand-short-name } үшін сақталған логиндер мен парольдерді ұсынуға рұқсат ету опциясын мәжбүрлету. Екі мәні де, true мен false, қабылданады.

policy-OfferToSaveLoginsDefault = { -brand-short-name } үшін сақталған логиндер және парольдерді есте сақтауды ұсынуды рұқсат етудің үнсіз келісім мәнін көрсетіңіз. Екі мән, true және false, қабылданады.

policy-OverrideFirstRunPage = Бірінші жөнелту парағын алмастыру. Бірінші жөнелту парағын сөндіру үшін, бұл саясатты бос қалдырыңыз.

policy-OverridePostUpdatePage = Жаңартылғаннан кейін "Не жаңалық" парағын алмастыру. Жаңартылғаннан кейінгі парақты сөндіру үшін, бұл саясатты бос қалдырыңыз.

policy-PasswordManagerEnabled = Парольдерді парольдер басқарушысында сақтауды іске қосу.

# PDF.js and PDF should not be translated
policy-PDFjs = PDF.js, { -brand-short-name } құрамындағы PDF шолушысын сөндіру немесе баптау.

policy-Permissions2 = Камера, микрофон, орналасулар, хабарламалар және автоойнату рұқсаттарын баптау.

policy-Preferences = Баптаулардың бір жиыны үшін мәндерін орнату және бұғаттау.

policy-PromptForDownloadLocation = Жүктеп алу кезінде файлдарды сақтау орны туралы сұрау.

policy-Proxy = Прокси баптауларын орнату.

policy-RequestedLocales = Таңдау ретімен қолданба үшін сұралатын локальдер тізімін орнату.

policy-SanitizeOnShutdown2 = Сөндірілген кезде навигация деректерін тазарту.

policy-SearchEngines = Іздеу жүйесі параметрлерін баптау. Бұл саясат тек ұзақ мерзімді қолдауы бар (ESR) нұсқасында қолжетерлік.

policy-SearchSuggestEnabled = Іздеу ұсыныстарын іске қосу немесе сөндіру.

# For more information, see https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/PKCS11/Module_Installation
policy-SecurityDevices = PKCS #11 модульдерін орнату.

policy-SSLVersionMax = Максималды SSL нұсқасын орнату.

policy-SSLVersionMin = Минималды SSL нұсқасын орнату.

policy-SupportMenu = Көмек мәзіріне таңдауыңызша қолдау көрсету мәзір элементін қосу.

policy-UserMessaging = Пайдаланушыға кейбір хабарламаларды көрсетпеу.

# “format” refers to the format used for the value of this policy.
policy-WebsiteFilter = Веб-сайттарды шолуға тыйым салу. Пішімі туралы көбірек білу үшін, құжаттаманы қараңыз.
