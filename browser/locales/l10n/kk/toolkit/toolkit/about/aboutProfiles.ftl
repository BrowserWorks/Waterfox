# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = Профильдер туралы
profiles-subtitle = Бұл бет сізге профильдерді басқаруға көмектеседі. Әр профильде басқалардан бөлек шолу тарихы, бетбелгілер, баптаулар және қосымшалар бар.
profiles-create = Жаңа профильді жасау
profiles-restart-title = Қайта қосу
profiles-restart-in-safe-mode = Сөндірілген қосымшалармен қайта қосу…
profiles-restart-normal = Қалыпты қайта қосу…
profiles-conflict = { -brand-product-name } басқа нұсқасы профильдерге өзгерістер жасады. Көбірек өзгерістерді жасау алдында, { -brand-short-name } қайта іске қосу керек.
profiles-flush-fail-title = Өзгерістер сақталмады
profiles-flush-conflict = { profiles-conflict }
profiles-flush-failed = Күтпеген қате өзгерістерді сақтауға жол бермеді.
profiles-flush-restart-button = { -brand-short-name } қайта іске қосу

# Variables:
#   $name (String) - Name of the profile
profiles-name = Профиль: { $name }
profiles-is-default = Бастапқы профиль
profiles-rootdir = Түбірлік бумасы

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = Жергілікті бума
profiles-current-profile = Бұл профиль қолданыста болып тұр, сондықтан, оны өшіру мүмкін емес.
profiles-in-use-profile = Бұл профильді басқа қолданып тұр, сондықтан оны өшіру мүмкін емес.

profiles-rename = Атын өзгерту
profiles-remove = Өшіру
profiles-set-as-default = Бастапқы ретінде орнату
profiles-launch-profile = Профильді жаңа браузерде жөнелту

profiles-cannot-set-as-default-title = Бастапқы ретінде орнату мүмкін емес
profiles-cannot-set-as-default-message = { -brand-short-name } үшін үнсіз келісім профилін өзгерту мүмкін емес

profiles-yes = иә
profiles-no = жоқ

profiles-rename-profile-title = Профиль атын ауыстыру
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = { $name } профильдің атын ауыстыру:

profiles-invalid-profile-name-title = Профильдің аты қате
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = "{ $name }" профиль аты жарамсыз.

profiles-delete-profile-title = Профильді өшіру
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    Профильді өшіру оны қолжетерлік профильдер тізімінен өшіреді, және бұны қайтаруға болмайды.
    Оған қоса сіз профиль файлдарын өшіре аласыз, оның ішніде сіздің баптаулар, сертификаттар және басқа да пайдаланушыға қатысты мәліметтер бар. Бұл мүмкіндік қолдану салдарынан "{ $dir }" бумасы өшіріледі және бұны қайтаруға болмайды.
    Профиль файлдарын өшіруді қалайсыз ба?
profiles-delete-files = Файлдарды өшіру
profiles-dont-delete-files = Файлдарды өшірмеу

profiles-delete-profile-failed-title = Қате
profiles-delete-profile-failed-message = Бұл профильді өшіру талабы кезінде қате орын алды.


profiles-opendir =
    { PLATFORM() ->
        [macos] Finder ішінен көрсету
        [windows] Буманы ашу
       *[other] Буманы ашу
    }
