# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Localized string used as the dialog window title (a new behavior locked
# behind the "extensions.abuseReport.openDialog" preference).
# "Report" is a noun in this case, "Report for AddonName".
#
# Variables:
#   $addon-name (string) - Name of the add-on being reported
abuse-report-dialog-title = { $addon-name } үшін есептеме жасау

abuse-report-title-extension = Бұл кеңейту туралы { -vendor-short-name } адресіне шағым жасау
abuse-report-title-theme = Бұл тема туралы { -vendor-short-name } адресіне шағым жасау
abuse-report-subtitle = Мәселе қандай?

# Variables:
#   $author-name (string) - Name of the add-on author
abuse-report-addon-authored-by = <a data-l10n-name="author-name">{ $author-name }</a> жасаған

abuse-report-learnmore =
    Қай мәселені таңдауды білмей тұрсыз ба?
    <a data-l10n-name="learnmore-link">Кеңейтулер мен темаларға шағымдану туралы көбірек біліңіз</a>

abuse-report-submit-description = Мәселені сипаттаңыз (қосымша түрде)
abuse-report-textarea =
    .placeholder = Нақты ақпаратымыз бар кезде мәселені шешу оңайырақ болады. Кездестірген мәселені сипаттаңыз. Интернеттің денін сау ұстауға көмектескеніңіз үшін рахмет.
abuse-report-submit-note = Ескерту: Атыңыз, эл. пошта, телефон нөмірі, мекенжай сияқты жеке ақпаратты қоспаңыз. { -vendor-short-name } бұл шағымдардың тұрақты жазбасын сақтап отырады.

## Panel buttons.

abuse-report-cancel-button = Бас тарту
abuse-report-next-button = Келесі
abuse-report-goback-button = Артқа
abuse-report-submit-button = Жіберу

## Message bars descriptions.


## Variables:
##   $addon-name (string) - Name of the add-on

abuse-report-messagebar-aborted = <span data-l10n-name="addon-name">{ $addon-name }</span> нәрсесіне шағымнан бас тартылды.
abuse-report-messagebar-submitting = <span data-l10n-name="addon-name">{ $addon-name }</span> нәрсесіне шағым жіберілуде.
abuse-report-messagebar-submitted = Шағымды жібергеніңіз үшін рахмет. <span data-l10n-name="addon-name">{ $addon-name }</span> өшіруді қалайсыз ба?
abuse-report-messagebar-submitted-noremove = Шағымды жібергеніңіз үшін рахмет.
abuse-report-messagebar-removed-extension = Шағымды жібергеніңіз үшін рахмет. Сіз <span data-l10n-name="addon-name">{ $addon-name }</span> кеңейтуін өшірдіңіз.
abuse-report-messagebar-removed-theme = Шағымды жібергеніңіз үшін рахмет. Сіз <span data-l10n-name="addon-name">{ $addon-name }</span> темасын өшірдіңіз.
abuse-report-messagebar-error = <span data-l10n-name="addon-name">{ $addon-name }</span> нәрсесіне шағымды жіберу кезінде қате орын алды.
abuse-report-messagebar-error-recent-submit = <span data-l10n-name="addon-name">{ $addon-name }</span> нәрсесіне шағым жіберілмеді, өйткені басқа шағым жуырда жіберілген.

## Message bars actions.

abuse-report-messagebar-action-remove-extension = Иә, өшіру
abuse-report-messagebar-action-keep-extension = Жоқ, сақтап қалу
abuse-report-messagebar-action-remove-theme = Иә, өшіру
abuse-report-messagebar-action-keep-theme = Жоқ, сақтап қалу
abuse-report-messagebar-action-retry = Қайталау
abuse-report-messagebar-action-cancel = Бас тарту

## Abuse report reasons (optionally paired with related examples and/or suggestions)

abuse-report-damage-reason-v2 = Ол менің компьютерімді зақымдады немесе деректерімді ұрлады
abuse-report-damage-example = Мысалы: Зиянкес БҚ орнату немесе деректерді ұрлау

abuse-report-spam-reason-v2 = Оның құрамында спам бар немесе қаламаған жарнаманы кірістіреді
abuse-report-spam-example = Мысалы: Веб-парақтарда жарнаманы кірістіреді

abuse-report-settings-reason-v2 = Ол менің іздеу жүйесін, үй парағын немесе жаңа бетті маған хабарламай немесе сұрамай өзгертті
abuse-report-settings-suggestions = Кеңетуге шағым жіберу алдында, баптауларыңызды өзгертіп көруіңізге болады:
abuse-report-settings-suggestions-search = Бастапқы іздеу баптауларын өзгерту
abuse-report-settings-suggestions-homepage = Үй парағын және жаңа бетті өзгерту

abuse-report-deceptive-reason-v2 = Өз-өзін болмай тұрған нәрсе ретінде көрсетеді
abuse-report-deceptive-example = Мысалы: Алдамшы сипаттама немесе сурет

abuse-report-broken-reason-extension-v2 = Ол жұмыс істемейді, веб-сайттарды сындырады немесе { -brand-product-name } жұмысын тежейді
abuse-report-broken-reason-theme-v2 = Ол жұмыс жасамайды немесе браузер жұмысын бұзады
abuse-report-broken-example = Мысалы: Мүмкіндіктері баяу, қолдануға қиын, немесе тіпті жасмайды; веб-сайттар бөліктері жүктелмейді немесе сыртқы түрлері әдеттен тыс түрде
abuse-report-broken-suggestions-extension =
    Ақаулықты тапқан сияқтысыз. Осында шағымды жіберуге қоса, мүмкіндік мәселесін
    шешудің тиімді жолы - кеңейту әзірлеушісіне хабарласу.
    Әзірлеуші ақпаратын алу үшін, <a data-l10n-name="support-link">кеңейтудің веб-сайтын шолыңыз</a>.
abuse-report-broken-suggestions-theme =
    Ақаулықты тапқан сияқтысыз. Осында шағымды жіберуге қоса, мүмкіндік мәселесін
    шешудің тиімді жолы - теманың әзірлеушісіне хабарласу.
    Әзірлеуші ақпаратын алу үшін, <a data-l10n-name="support-link">теманың веб-сайтын шолыңыз</a>.

abuse-report-policy-reason-v2 = Оның құрамында жеккөрушілік, зорлық-зомбылық немесе заңсыз мазмұн бар
abuse-report-policy-suggestions =
    Ескерту: Авторлық құқықтар және сауда белгілерін бұзу мәселелері бөлек жіберілуі тиіс.
    Мәселені хабарлау үшін, <a data-l10n-name="report-infringement-link"> мына нұсқаманы қолданыңыз</a>.

abuse-report-unwanted-reason-v2 = Мен оны ешқашан қаламадым және одан қалай құтылуды білмеймін
abuse-report-unwanted-example = Мысалы: Оны қандай да бір қолданба менің рұқсатымсыз орнатты

abuse-report-other-reason = Басқа нәрсе

