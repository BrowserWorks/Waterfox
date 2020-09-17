# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

blocklist-window =
    .title = Блоктізімдер
    .style = width: 55em

blocklist-description = { -brand-short-name } онлайн трекерлерді блоктау үшін қолданатын тізімді таңдаңыз. Тізімдерді <a data-l10n-name="disconnect-link" title="Disconnect">Disconnect</a> қызметі ұсынған.
blocklist-close-key =
    .key = w

blocklist-treehead-list =
    .label = Тізім

blocklist-button-cancel =
    .label = Бас тарту
    .accesskey = а

blocklist-button-ok =
    .label = Өзгерістерді сақтау
    .accesskey = с

# This template constructs the name of the block list in the block lists dialog.
# It combines the list name and description.
# e.g. "Standard (Recommended). This list does a pretty good job."
#
# Variables:
#   $listName {string, "Standard (Recommended)."} - List name.
#   $description {string, "This list does a pretty good job."} - Description of the list.
blocklist-item-list-template = { $listName } { $description }

blocklist-item-moz-std-listName = 1-ші деңгейлі бұғаттау тізімі (Ұсынылады).
blocklist-item-moz-std-description = Азырақ вебсайттар сынуы үшін, кейбір трекерлерді рұқсат етеді.
blocklist-item-moz-full-listName = 2-ші деңгейлі бұғаттау тізімі.
blocklist-item-moz-full-description = Барлық анықталған трекерлерді бұғаттайды. Кейбір веб-сайттар немесе құрама дұрыс жүктелмеуі мүмкін.
