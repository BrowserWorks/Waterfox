# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = Жүйелік интеграция

system-integration-dialog =
    .buttonlabelaccept = Бастапқы ретінде орнату
    .buttonlabelcancel = Интеграцияны аттап кету
    .buttonlabelcancel2 = Бас тарту

default-client-intro = { -brand-short-name } келесі үшін негізгі клиент ретінде қолдану:

unset-default-tooltip = { -brand-short-name } қолданбасын негізгі клиент емес етіп { -brand-short-name } ішінен орнату мүмкін емес. Басқа қолданбаны үнсіз келісім қолданбасы ретінде орнату үшін "Үнсіз келісім қолданбасы ретінде орнату" сұхбатын қолданыңыз.

checkbox-email-label =
    .label = Эл. пошта
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = Жаңалықтар топтары
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = Жаңалықтар таспалары
    .tooltiptext = { unset-default-tooltip }

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
system-search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windows іздеуі
       *[other] { "" }
    }

system-search-integration-label =
    .label = { system-search-engine-name } үшін хабарламалардан іздеуді рұқсат ету
    .accesskey = з

check-on-startup-label =
    .label = { -brand-short-name } іске қосылған кезде әрқашан да осыны тексеру
    .accesskey = ш
