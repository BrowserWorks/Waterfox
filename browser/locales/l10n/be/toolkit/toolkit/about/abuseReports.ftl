# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Localized string used as the dialog window title (a new behavior locked
# behind the "extensions.abuseReport.openDialog" preference).
# "Report" is a noun in this case, "Report for AddonName".
#
# Variables:
#   $addon-name (string) - Name of the add-on being reported
abuse-report-dialog-title = Паведаміць пра { $addon-name }

abuse-report-title-extension = Паведаміць пра гэта пашырэнне ў { -vendor-short-name }
abuse-report-title-theme = Паведаміць пра гэту тэму ў { -vendor-short-name }
abuse-report-subtitle = У чым праблема?

# Variables:
#   $author-name (string) - Name of the add-on author
abuse-report-addon-authored-by = ад <a data-l10n-name="author-name">{ $author-name }</a>

abuse-report-learnmore =
    Няўпэўнены, якую праблему выбраць?
    <a data-l10n-name="learnmore-link">Даведацца больш аб паведамленні пра пашырэнні і тэмы</a>

abuse-report-submit-description = Апішыце праблему (неабавязкова)
abuse-report-textarea =
    .placeholder = Нам лягчэй вырашыць праблему, калі нам вядомы падрабязнасці. Калі ласка, апішыце, што здарылася. Дзякуем, што дапамагаеце падтрымліваць здароўе сеціва.
abuse-report-submit-note =
    Заўвага. Не ўключайце асабістую інфармацыю (напрыклад, імя, адрас электроннай пошты, нумар тэлефона, фізічны адрас).
    { -vendor-short-name } трымае сталыя запісы гэтых справаздач.

## Panel buttons.

abuse-report-cancel-button = Скасаваць
abuse-report-next-button = Далей
abuse-report-goback-button = Вярнуцца
abuse-report-submit-button = Даслаць

## Message bars descriptions.


## Variables:
##   $addon-name (string) - Name of the add-on

abuse-report-messagebar-aborted = Справаздача аб <span data-l10n-name="addon-name">{ $addon-name }</span> скасавана.
abuse-report-messagebar-submitting = Адпраўляецца паведамленне пра <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-submitted = Дзякуем за прадстаўленую справаздачу. Хочаце выдаліць <span data-l10n-name="addon-name">{ $addon-name }</span>?
abuse-report-messagebar-submitted-noremove = Дзякуем за прадстаўленую справаздачу.
abuse-report-messagebar-removed-extension = Дзякуй за прадстаўленую справаздачу. Вы выдалілі пашырэнне <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-removed-theme = Дзякуй за прадстаўленую справаздачу. Вы выдалілі <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error = Памылка пры адпраўцы справаздачы для <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error-recent-submit = Справаздача пра <span data-l10n-name="addon-name">{ $addon-name }</span> не адпраўлена, бо нядаўна была пададзена яшчэ адна справаздача.

## Message bars actions.

abuse-report-messagebar-action-remove-extension = Так, выдаліць
abuse-report-messagebar-action-keep-extension = Не, пакінуць яго
abuse-report-messagebar-action-remove-theme = Так, выдаліць
abuse-report-messagebar-action-keep-theme = Не, пакінуць яе
abuse-report-messagebar-action-retry = Паўтарыць
abuse-report-messagebar-action-cancel = Скасаваць

## Abuse report reasons (optionally paired with related examples and/or suggestions)

abuse-report-damage-reason-v2 = Пашкодзіла мой камп'ютар або кампраметавала мае дадзеныя
abuse-report-damage-example = Прыклад: Укаранёна шкодная праграма або скрадзены дадзеныя

abuse-report-spam-reason-v2 = Утрымлівае спам або ўстаўляе непажаданую рэкламу
abuse-report-spam-example = Прыклад: устаўлены аб'явы на вэб-старонках

abuse-report-settings-reason-v2 = Змяніла маю пошукавую сістэму, хатнюю старонку або новую картку, не інфармуючы і не спытаўшы мяне
abuse-report-settings-suggestions = Перш чым паведаміць аб пашырэнні, вы можаце паспрабаваць змяніць параметры:
abuse-report-settings-suggestions-search = Змяніць прадвызначаныя налады пошуку
abuse-report-settings-suggestions-homepage = Змяніць хатнюю старонку і новую картку

abuse-report-deceptive-reason-v2 = Выдае сябе за тое, чым не з'яўляецца
abuse-report-deceptive-example = Прыклад: Апісанне або выява ўводзіць у зман

abuse-report-broken-reason-extension-v2 = Не працуе, псуе вэб-сайты або запавольвае { -brand-product-name }
abuse-report-broken-reason-theme-v2 = Не працуе або парушае адлюстраванне браўзера
abuse-report-broken-example = Прыклад: функцыі марудныя, цяжкія ў выкарыстанні або не працуюць; часткі сайтаў не загружаюцца ці выглядаюць незвычайна
abuse-report-broken-suggestions-extension =
    Падобна на тое, што вы выявілі памылку. Акрамя прадстаўлення справаздачы тут, лепшы спосаб
    вырашыць праблему з функцыянальнасцю - звярнуцца да распрацоўшчыка пашырэння.
    <a data-l10n-name="support-link">Наведайце вэб-сайт пашырэння</a> для звестак пра распрацоўніка.
abuse-report-broken-suggestions-theme =
    Падобна на тое, што вы выявілі памылку. Акрамя прадстаўлення справаздачы тут, лепшы спосаб
    вырашыць праблему з функцыянальнасцю - звязацца з распрацоўшчыкам тэмы.
    <a data-l10n-name="support-link">Наведайце вэб-сайт тэмы</a> для звестак пра распрацоўніка.

abuse-report-policy-reason-v2 = Змяшчае ненавісны, жорсткі ці незаконны змест
abuse-report-policy-suggestions =
    Заўвага. Аб праблемах аўтарскага права і таварных знакаў неабходна паведамляць у асобным працэсе.
    <a data-l10n-name="report-infringement-link">Выкарыстоўвайце гэтыя інструкцыі</a> каб
    паведаміць пра праблему.

abuse-report-unwanted-reason-v2 = Ніколі не хацеў гэтага і не ведаю, як гэтага пазбавіцца
abuse-report-unwanted-example = Прыклад: праграма усталявала гэта без майго дазволу

abuse-report-other-reason = Нешта іншае

