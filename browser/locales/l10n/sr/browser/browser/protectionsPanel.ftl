# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

protections-panel-sendreportview-error = Дошло је до грешке приликом слања извештаја. Покушајте поново касније.

# A link shown when ETP is disabled for a site. Opens the breakage report subview when clicked.
protections-panel-sitefixedsendreport-label = Страница је поправљена? Пошаљите извештај

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

protections-popup-footer-protection-label-strict = Строго
    .label = Строго
protections-popup-footer-protection-label-custom = Прилагођено
    .label = Прилагођено
protections-popup-footer-protection-label-standard = Стандардно
    .label = Стандардно

##

# The text a screen reader speaks when focused on the info button.
protections-panel-etp-more-info =
    .aria-label = Више података о побољшаној заштити од праћења

protections-panel-etp-on-header = Побољшана заштита од праћења је УКЉУЧЕНА на овој страници
protections-panel-etp-off-header = Побољшана заштита од праћења је ИСКЉУЧЕНА на овој страници

# The link to be clicked to open the sub-panel view
protections-panel-site-not-working = Страница не ради?

# The heading/title of the sub-panel view
protections-panel-site-not-working-view =
    .title = Страница не ради?

## The "Allowed" header also includes a "Why?" link that, when hovered, shows
## a tooltip explaining why these items were not blocked in the page.

protections-panel-not-blocking-why-label = Зашто?
protections-panel-not-blocking-why-etp-on-tooltip = Блокирање ових ставки може узроковати да елементи на одређеним веб страницама постану неисправни. Неки тастери, обрасци и поља за пријаву можда неће правилно радити без програма за праћење.
protections-panel-not-blocking-why-etp-off-tooltip = Сви програми за праћење на овој веб страници су учитани јер је заштита приватности искључена.

##

protections-panel-no-trackers-found = { -brand-short-name } није уочио познате пратиоце на овој страници.

protections-panel-content-blocking-tracking-protection = Садржаји који прате

protections-panel-content-blocking-socialblock = Пратиоци с друштвених мрежа
protections-panel-content-blocking-cryptominers-label = Крипто-рудари
protections-panel-content-blocking-fingerprinters-label = Хватачи отиска

## In the protections panel, Content Blocking category items are in three sections:
##   "Blocked" for categories being blocked in the current page,
##   "Allowed" for categories detected but not blocked in the current page, and
##   "None Detected" for categories not detected in the current page.
##   These strings are used in the header labels of each of these sections.

protections-panel-blocking-label = Блокирано
protections-panel-not-blocking-label = Дозвољено
protections-panel-not-found-label = Нису уочени

##

protections-panel-settings-label = Подешавања заштите
# This should match the "appmenuitem-protection-dashboard-title" string in browser/appmenu.ftl.
protections-panel-protectionsdashboard-label = Сигурносна командна табла

## In the Site Not Working? view, we suggest turning off protections if
## the user is experiencing issues with any of a variety of functionality.

# The header of the list
protections-panel-site-not-working-view-header = Искључите заштиту ако имате проблеме са ставкама:

# The list items, shown in a <ul>
protections-panel-site-not-working-view-issue-list-login-fields = Поља за пријаву
protections-panel-site-not-working-view-issue-list-forms = Обрасци
protections-panel-site-not-working-view-issue-list-payments = Плаћања
protections-panel-site-not-working-view-issue-list-comments = Коментари
protections-panel-site-not-working-view-issue-list-videos = Видео записи

protections-panel-site-not-working-view-send-report = Пошаљите извештај

##

protections-panel-cross-site-tracking-cookies = Ови колачићи вас прате с једне странице на другу ради прикупљања података о ономе шта радите на мрежи. Основале су их треће стране, попут оглашивача и аналитичких компанија.
protections-panel-cryptominers = Рудари криптовалута користе енергију вашег рачунара за ископавање дигиталне валуте. На тај начин троше енергију рачунара, успоравају перформансе система и повећавају ваш рачун за струју.
protections-panel-fingerprinters = Идентификатори отисака прстију прикупљају подешавања вашег прегледача и рачунара како би створили ваш профил. Помоћу овог дигиталног отиска прста вас могу пратити преко различитих веб страница.
protections-panel-tracking-content = Веб странице могу учитавати вањске огласе, видео записе и други садржај који садржи код за праћење. Блокирање садржаја за праћење може убрзати учитавање страница, али неки тастери, обрасци и поља за пријаву можда неће радити исправно.
protections-panel-social-media-trackers = Друштвене мреже постављају софтвер за праћење на друге веб странице како би пратили шта радите, читате или гледате на мрежи. То друштвеним мрежама омогућава да о вама сазна много више од онога што делите на својим профилима.

protections-panel-content-blocking-manage-settings =
    .label = Управљајте подешавањима заштите
    .accesskey = М

protections-panel-content-blocking-breakage-report-view =
    .title = Пријавите неисправан сајт
protections-panel-content-blocking-breakage-report-view-description = Блокирање неких софтвера за праћење може изазвати проблеме на појединим веб страницама. Пријављивањем оваквих проблема можете помоћи { -brand-short-name } да пружи боље искуство свима. Слање повратних података шаље Mozilla-и адресу веб странице и податке о прегледачу. <label data-l10n-name="learn-more">Сазнајте више</label>
protections-panel-content-blocking-breakage-report-view-collection-url = URL
protections-panel-content-blocking-breakage-report-view-collection-url-label =
    .aria-label = URL
protections-panel-content-blocking-breakage-report-view-collection-comments = Опционално: опишите проблем
protections-panel-content-blocking-breakage-report-view-collection-comments-label =
    .aria-label = Опционално: опишите проблем
protections-panel-content-blocking-breakage-report-view-cancel =
    .label = Откажи
protections-panel-content-blocking-breakage-report-view-send-report =
    .label = Пошаљи извештај
