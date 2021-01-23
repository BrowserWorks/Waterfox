# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Thunderbird installations
## all at once. This is traditionally done through the Windows Group Policy
## feature, but the system also supports other forms of deployment.
## These are short descriptions for individual policies, to be displayed
## in the documentation section in about:policies.

policy-3rdparty = Սահմանեք այն քաղաքականությունները, որոնցում WebExtensions- ը կարող է մուտք ունենալ chrome.storage.managed- ի միջոցով:

policy-AppAutoUpdate = Միացնել կամ անջատել ծրագրի ինքնաբար թարմացումը:

policy-AppUpdateURL = Սահմանեք հատուկ ծրագրի թարմացման URL:

policy-Authentication = Կազմաձևեք ինտեգրված վավերացումը` դրան աջակցող կայքերի համար:

policy-BlockAboutAddons = Արգելափակել մատչումը Հավելումների կառավարին (about:addons):

policy-BlockAboutConfig = Արգելափակել մատչումը about:config էջին:

policy-BlockAboutProfiles = Արգելափակել մատչումը about:profiles էջին:

policy-BlockAboutSupport = Արգելափակել մատչումը about:support էջին:

policy-CaptivePortal = Միացնել կամ անջատել գրավող կայէջի աջակցումը:

policy-CertificatesDescription = Ավելացրեք վկայագրեր կամ օգտագործեք ներկառուցվածները:

policy-Cookies = Թույլատրել կամ մերժել կայքերը՝ կայելով cookie-ները:

policy-DisabledCiphers = Անջատել ծածկագրերը:

policy-DefaultDownloadDirectory = Սահմանեք բեռնման լռելյայն գրացուցակը:

policy-DisableAppUpdate = Կանխել { -brand-short-name } –ի թարմացումը:

policy-DisableDefaultClientAgent = Կանխեք զննարկչի կանխադրված գործակալին՝ որևէ գործողություն ձեռնարկելուց: Կիրառելի է միայն Windows-ի համար: Այլ հարթակները գործակալ չունեն:

policy-DisableDeveloperTools = Արգելափակել մատչումը Ծրագրավորողի գործիքներին:

policy-DisableFeedbackCommands = Անջատել հրահանգները `«Օգնության» ընտրացանկից հետադարձ կապ ուղարկելու համար (Ներկայացրեք հետադարձ կապը և զեկուցեք խաբուսիկ կայքի մասին):

policy-DisableForgetButton = Կանխել մուտքը Մոռացման կոճակի:

policy-DisableFormHistory = Չհիշել որոնումները և ձևերը պատմությունից:

policy-DisableMasterPasswordCreation = Եթե ճշմարիտ է, հատուկ գաղտնաբառ հնարավոր չէ ստեղծել:

policy-DisablePasswordReveal = Թույլ մի տվեք, որ գաղտնաբառերը բացահայտվեն պահված մուտքերում։

policy-DisableProfileImport = Անջատել ընտրացանկի հրամանը՝ այլ ծրագրից տվյալներ ներմուծելու համար:

policy-DisableSafeMode = Անջատել գործառույթը` անվտանգ աշխատակերպում վերագործարկելու համար: Նշում. Անվտանգ աշխատակերպ մուտք գործելու Shift ստեղնը կարող է անջատվել միայն Windows- ում `օգտագործելով Խմբային քաղաքականություն:

policy-DisableSecurityBypass = Կանխել օգտատիրոջը` շրջանցելով անվտանգության որոշ նախազգուշացումներ:

policy-DisableSystemAddonUpdate = Կանխել { -brand-short-name } համակարգի լրացումների տեղաակայումը և թարմեցումը:

policy-DisableTelemetry = Անջատել հեռաչափությունը:

policy-DisplayMenuBar = Ցուցադրել ցանկագոտին լռելյայն:

policy-DNSOverHTTPS = Կազմաձևել DNS- ը HTTPS- ի վերաբերյալ:

policy-DontCheckDefaultClient = Անջատել ստուգումը երբ գործարկում է լռելյայն հաճախորդ։

policy-DownloadDirectory = Կարգավորել և փակել բեռնման գրացուցակը:

# “lock” means that the user won’t be able to change this setting
policy-EnableTrackingProtection = Միացնել կամ անջատել բովանդակության արգելափակումը և կամայականորեն կողպել այն:

# “lock” means that the user won’t be able to change this setting
policy-EncryptedMediaExtensions = Միացնել կամ անջատել գաղտնագրված մեդիա ընդլայնումները և լրացուցիչ կողպել այն:

# A “locked” extension can’t be disabled or removed by the user. This policy
# takes 3 keys (“Install”, ”Uninstall”, ”Locked”), you can either keep them in
# English or translate them as verbs.
policy-Extensions = Տեղակայել, տեղահանել կամ կողպել ընդարձակումները: Տեղադրման տարբերակը վերցնում է URL- ները կամ ուղիները որպես ընտրանք: Տեղահանման և արգելափակման ընտրանքները վերցնում են երկարացման նույնականացումներից:

policy-ExtensionSettings = Կառավարել ընդլայնման տեղադրման բոլոր կողմերը:

policy-ExtensionUpdate = Միացնել կամ անջատել ինքնուրույն ընդլայնման թարմացումները:

policy-HardwareAcceleration = Եթե կեղծ է, անջատել սարքաշարի արագացումը:

policy-InstallAddonsPermission = Թույլատրել որոշ կայքերի տեղադրել հավելումներ:

policy-LegacyProfiles = Անջատել այն առանձնահատկությունը, որն ամրացնում է առանձին հատկագիր յուրաքանչյուր տեղադրման համար:

## Do not translate "SameSite", it's the name of a cookie attribute.

policy-LegacySameSiteCookieBehaviorEnabled = Միացնել սկզբնադիր ժառանգության SameSite թխուկ վարքի կարգավորումը:

policy-LegacySameSiteCookieBehaviorEnabledForDomainList = Վերադարձեք օրինական SameSite-ի վարքին՝ նշված կայքերում թխուկների համար:

##

policy-LocalFileLinks = Թույլատրել հատուկ կայքերին կապվել տեղական նիշքերի հետ:

policy-NetworkPrediction = Միացնում կամ անջատում է ցանցի կանխատսումը (DNS նախաընթերցում)։

policy-OfferToSaveLogins = Հարկադրեք կարգավորումը, որպեսզի թույլատրեք { -brand-short-name }-ին հիշել պահպանված մուտքագրումները և գաղտնաբառերը: Թե՛ իրական, և թե՛ կեղծ արժեքներն ընդունելի են:

policy-OfferToSaveLoginsDefault = Սահմանեք սկզբնադիր արժեք, որը թույլ կտա { -brand-short-name }-ին առաջարկել հիշել պահպանված մուտքագրումները և գաղտնաբառերը: Թե՛ իրական, և թե՛ կեղծ արժեքներն ընդունելի են:

policy-OverrideFirstRunPage = Անցկացրեք առաջին գործարկման էջը: Կայեք այս քաղաքականությունը դատարկի, եթե ցանկանում եք անջատել առաջին աշխատեցման էջը:

policy-OverridePostUpdatePage = Վերագրեք «Ի՞նչն է նոր» էջը թարմացումից: Եթե ցանկանում եք անջատել  թարմացումը՝ կայեք այս քաղաքականությունը դատարկի:

policy-PasswordManagerEnabled = Միացրեք գաղտնաբառերի պահպանումը գաղտնաբառի կառավարիչում:

# PDF.js and PDF should not be translated
policy-PDFjs = Անջատեք կամ կազմաձևեք PDF.js-ը, ներկառուցված PDF դիտակը { -brand-short-name }-ում:

policy-Permissions2 = Կարգավորեք թույլտվությունները խցիկի, խոսափողի, գտնվելու վայրի, ծանուցումների և ինքնանվագարկման համար:

policy-Preferences = Սահմանեք և կողպեք արժեքը նախընտրությունների ենթակազմի համար։

policy-PromptForDownloadLocation = Ներբեռնելու ժամանակ հարցրեք, թե որտեղ պահել նիշքերը:

policy-Proxy = Կազմաձևել միջնորդի կարգավորումները:

policy-RequestedLocales = Սահմանել հարցված տեղայնացումները նախընտրությունների կարգով հավելվածների համար։

policy-SanitizeOnShutdown2 = Մաքրել ուղղորդման տվյալները անջատման ժամանակ:

policy-SearchEngines = Կարգավորել որոնիչի կարգավորումները: Այս քաղաքականությունը հասանելի է միայն Ընդլայնված աջակցության թողարկման (ESR) տարբերակում:

policy-SearchSuggestEnabled = Միացնել կամ անջատել որոնման առաջարկները:

# For more information, see https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/PKCS11/Module_Installation
policy-SecurityDevices = Տեղադրել PKCS #11 մոդուլները:

policy-SSLVersionMax = Սահմանել SSL առավելագույն տարբերակը:

policy-SSLVersionMin = Սահմանել SSL- ի նվազագույն տարբերակը:

policy-SupportMenu = Օգնության ընտրացանկին ավելացնել անհատական աջակցության ընտրացանկ:

policy-UserMessaging = Չցուցադրե՛լ օգտվողին որոշակի հաղորդագրություններ:

# “format” refers to the format used for the value of this policy.
policy-WebsiteFilter = Արգելափակել կայքեր այցելելուց: Տեսեք փաստաթղթերը` լրացուցիչ մանրամասների վերաբերյալ ձևաչափի վերաբերյալ:
