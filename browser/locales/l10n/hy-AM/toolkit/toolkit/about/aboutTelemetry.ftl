# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = Փինգ տվյալի աղբյուրին.
about-telemetry-show-current-data = Ներկայիս տվյալները
about-telemetry-show-archived-ping-data = Արխիվացված փինգի տվյալ
about-telemetry-show-subsession-data = Ցուցադրել տվյալի ենթաշրջանը
about-telemetry-choose-ping = Ընտրել փինգը.
about-telemetry-archive-ping-type = Պինգի տեսակ
about-telemetry-archive-ping-header = Փինգ
about-telemetry-option-group-today = Այսօր
about-telemetry-option-group-yesterday = Երեկ
about-telemetry-option-group-older = Հին
about-telemetry-previous-ping = «
about-telemetry-next-ping = »
about-telemetry-page-title = Telemetry-ի տվյալ
about-telemetry-current-store = Ընթացիկ խանութ.
about-telemetry-more-information = Լրացուցիչ տեղեկություննե՞ր են պետք:
about-telemetry-firefox-data-doc = <a data-l10n-name="data-doc-link"> Firefox-ի տվյալների փաստաթղթավորումը</a> պարունակում է ուղղորդներ` մեր տվյալների գործիքների հետ աշխատելու համար։
about-telemetry-telemetry-client-doc = <a data-l10n-name="client-doc-link">Firefox-ի հեռուսաչափության սպասառուի փաստաթղթավորումը</a> ներառում է հասկացուցումների սահմանումներ , API փաստաթղթավորում և տվյալների հղումներ։
about-telemetry-telemetry-dashboard = <a data-l10n-name="dashboard-link">Հեռուսաչափության կառավահանակը</a> թույլատրում է հեռուսաչափության միջոցով տեսնել Mozilla֊ի ստացված տվյալները։
about-telemetry-telemetry-probe-dictionary = <a data-l10n-name="probe-dictionary-link">Զննության բառարանը</a> մատակարարում է մանրամասնություններ և նկարագրություններ զննությունների համար, որոնք հավաքվել են հեռուսաչափության կողմից։
about-telemetry-show-in-Firefox-json-viewer = Բացել JSON դիտումում
about-telemetry-home-section = Տուն
about-telemetry-general-data-section =   Գլխավոր տվյալներ
about-telemetry-environment-data-section = Միջավայրի տվյալ
about-telemetry-session-info-section = Տեղեկություն աշխատաշրջանի մասին
about-telemetry-scalar-section = Կշեռքներ
about-telemetry-keyed-scalar-section = Բանալիացուած մենարժէք
about-telemetry-histograms-section = Գծապատկերներ
about-telemetry-keyed-histogram-section =   Ստեղնաշարային հիստոգրամներ
about-telemetry-events-section = Իրադարձություններ
about-telemetry-simple-measurements-section = Պարզ չափումներ
about-telemetry-slow-sql-section = Ցուցադրել SQL-ի առաջարկությունը
about-telemetry-addon-details-section = Հավելման մանրամասները
about-telemetry-captured-stacks-section = Կորզված շեղջեր
about-telemetry-late-writes-section = Հետագա գրումներ
about-telemetry-raw-payload-section = Անմշակ բեռ
about-telemetry-raw = JSON տող
about-telemetry-full-sql-warning = ՀԻՇԵՔ. Միացված է SQL-ի վրիպազերծման դանդաղ եղանակը։ Ստորև կարող են ցուցադրվել SQL ամբողջական տողեր, բայց դրանք չեն հաստատվի Telemetry-ում։
about-telemetry-fetch-stack-symbols = Ընտրել գործառույթի անունները՝ շեղջերի համար
about-telemetry-hide-stack-symbols = Ցուցադրել անմշակ շեղջի տվյալները
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] թողարկման տվյալ
       *[prerelease] նախաթողարկման տվյալ
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] միացված
       *[disabled] անջատված
    }
# Example Output: 1 sample, average = 0, sum = 0
# Variables:
#   $sampleCount (Integer): amount of histogram samples
#   $prettyAverage (Integer): average of histogram samples
#   $sum (Integer): sum of histogram samples
about-telemetry-histogram-stats =
    { $sampleCount ->
        [one] { $sampleCount } չափումներ, միջին = { $prettyAverage }, ընդհանուր = { $sum }
       *[other] { $sampleCount } չափումներ, միջին = { $prettyAverage }, ընդհանուր = { $sum }
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = Այս էջում ցուցադրվում են տեղեկություններ արտադրողականության, սարքակազմի ծրագրի օգտագործման և կարգավորումների մասին, որոնք հավաքվում են Telemetry-ի միջոցով։ Այս տեղեկությունները կուղարկվեն { $telemetryServerOwner }-ին՝ լավարկելու համար { -brand-full-name }-ը։
about-telemetry-settings-explanation = Telemetry-ին հավաքում է { about-telemetry-data-type } և վերբեռնումը <a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a> է:
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = Տեղեկատվության յուրաքանչյուր կտոր ուղարկվում է <a data-l10n-name="ping-link">pings</a>"-ի միջոցով: Դուք նայում եք ping { $name },{ $timestamp }։
about-telemetry-data-details-current = Տեղեկատվության յուրաքանչյուր կտոր ուղարկվում է “<a data-l10n-name="ping-link"> pings </a>" միջոցով: Դուք նայում եք ընթացիկ տվյալներին։
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = Որոնել { $selectedTitle }
about-telemetry-filter-all-placeholder =
    .placeholder = Գտնել բոլոր ընտրանքներում
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = “{ $searchTerms }”-ի արդյունքներ։
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = Կներեք, { $sectionName }-ում “{ $currentSearchText }”–ի համար ոչ մի արդյունք չկա:
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = Կներեք, “{ $searchTerms }”–ի համար ոչ մի հատվածում արդյունք չկա:
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = Կներեք, ներկայումս “{ $sectionName }”–ում հասանելի տվյալներ չկան:
# used as a tooltip for the “current” ping title in the sidebar
about-telemetry-current-data-sidebar = ընթացիկ տվյալներ
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = բոլորը
# button label to copy the histogram
about-telemetry-histogram-copy = Պատճենել
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = Ցուցադրել SQL առաջարկությունները հիմնական հանգույցում
about-telemetry-slow-sql-other = Ցուցադրել SQL առաջարկությունները օգնության հանգույցում
about-telemetry-slow-sql-hits = Հարցումներ
about-telemetry-slow-sql-average = Միջին ժ-ը (մվ)
about-telemetry-slow-sql-statement = Առաջարկություն
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = Հավելման ID-ին
about-telemetry-addon-table-details = Մանրամասներ
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = { $addonProvider } մատակարարը
about-telemetry-keys-header = Հատկությունը
about-telemetry-names-header = Անուն
about-telemetry-values-header = Արժեքը
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (քանակը. { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = Ուշ գրառում #{ $lateWriteCount }
about-telemetry-stack-title = Շեղջ.
about-telemetry-memory-map-title = Յիշողութեան քարտեզը.
about-telemetry-error-fetching-symbols = Նշանները բեռնելիս սխալ է գրանցվել։ Ստուգեք կապակցումը համացանցին և կրկին փորձեք։
about-telemetry-time-stamp-header = ժամադրոշմ
about-telemetry-category-header = անվանակարգ
about-telemetry-method-header = եղանակ
about-telemetry-object-header = օբյեկտ
about-telemetry-extra-header = հավելյալ
about-telemetry-origin-section = Հեռուստաչափության սկզաղբյուր
about-telemetry-origin-origin = Ծագում
about-telemetry-origin-count = Քանակ
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-origins-explanation = <a data-l10n-name="origin-doc-link"> Firefox-ի աղբյուրի հեռաչափությունը </a> կոդավորում է տվյալները ուղարկելուց առաջ, այնպես որ { $telemetryServerOwner } կարող է հաշվել իրերը, առանց իմանալու որևէ { -brand-product-name } մուտքագրման համար: Ավելին իմանալու համար <a data-l10n-name="prio-blog-link"> </a>)։
# Variables:
#  $process (String): type of process in subsection headers ( e.g. "content", "parent" )
about-telemetry-process = { $process } գործնթաց
