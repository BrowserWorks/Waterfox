# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = პინგის მონაცემების წყარო:
about-telemetry-show-current-data = მიმდინარე მონაცემები
about-telemetry-show-archived-ping-data = პინგის დაარქივებული მონაცემები
about-telemetry-show-subsession-data = ქვესეანსის მონაცემების ჩვენება
about-telemetry-choose-ping = პინგის არჩევა:
about-telemetry-archive-ping-type = კავშირის დამოწმების სახეობა
about-telemetry-archive-ping-header = პინგი
about-telemetry-option-group-today = დღეს
about-telemetry-option-group-yesterday = გუშინ
about-telemetry-option-group-older = უფრო ძველი
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = გაზომვების მონაცემები
about-telemetry-current-store = მიმდინარე ოდენობა:
about-telemetry-more-information = მეტ ინფორმაციას ეძებთ?
about-telemetry-firefox-data-doc = <a data-l10n-name="data-doc-link">Firefox-ის მონაცემთა მასალები</a> შეიცავს მითითებებს, მონაცემთა ხელსაწყოებთან მუშაობის შესახებ.
about-telemetry-telemetry-client-doc = <a data-l10n-name="client-doc-link">Firefox-გაზომვების კლიენტის მასალები</a> შეიცავს განმარტებებს, კონცეფციას, API-დოკუმენტაციასა და მითითებებს, მონაცემების შესახებ.
about-telemetry-telemetry-dashboard = <a data-l10n-name="dashboard-link">გაზომვების გვერდი</a>, Mozilla-ს მიერ აღრიცხული მონაცემების ვიზუალურად წარმოდგენის საშუალებას იძლევა.
about-telemetry-telemetry-probe-dictionary = <a data-l10n-name="probe-dictionary-link">კვლევის ლექსიკონში</a> მოცემულია დაწვრილებითი ინფორმაცია და აღწერილობა გაზომვებით ჩატარებული კვლევების.
about-telemetry-show-in-Firefox-json-viewer = JSON მნახველში გახსნა
about-telemetry-home-section = მთავარი
about-telemetry-general-data-section = ზოგადი მონაცემები
about-telemetry-environment-data-section = გარემოს მონაცემები
about-telemetry-session-info-section = სეანსის მონაცემები
about-telemetry-scalar-section = სიდიდეები
about-telemetry-keyed-scalar-section = შიფრიანი სიდიდეები
about-telemetry-histograms-section = გრაფიკები
about-telemetry-keyed-histogram-section = შიფრიანი გრაფიკები
about-telemetry-events-section = მოვლენები
about-telemetry-simple-measurements-section = მარტივი განსაზღვრებები
about-telemetry-slow-sql-section = ნელი SQL-ბრძანებები
about-telemetry-addon-details-section = დამატების მონაცემები
about-telemetry-captured-stacks-section = დაფიქსირებული სტეკები
about-telemetry-late-writes-section = გვიანი ჩაწერები
about-telemetry-raw-payload-section = ნედლი დატვირთვა
about-telemetry-raw = ნედლი JSON
about-telemetry-full-sql-warning = შენიშვნა: ნელი SQL-ის გამართვა ჩართულია. შესაძლოა ქვემოთ სრული SQL-სტრიქონები გამოჩნდეს, მაგრამ ისინი არ აღირიცხება გაზომვებში.
about-telemetry-fetch-stack-symbols = ფუნქციების სახელების გადმოტანა სტეკებითვის
about-telemetry-hide-stack-symbols = სტეკების ნედლი მონაცემების ჩვენება
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] გამოშვების მონაცემები
       *[prerelease] გამოშვებამდელი მონაცემები
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] მიმდინარეობს
       *[disabled] შეჩერებულია
    }
# Example Output: 1 sample, average = 0, sum = 0
# Variables:
#   $sampleCount (Integer): amount of histogram samples
#   $prettyAverage (Integer): average of histogram samples
#   $sum (Integer): sum of histogram samples
about-telemetry-histogram-stats =
    { $sampleCount ->
        [one] { $sampleCount } სინჯი, საშუალო = { $prettyAverage }, ჯამი = { $sum }
       *[other] { $sampleCount } სინჯი, საშუალო = { $prettyAverage }, ჯამი = { $sum }
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = ამ გვერდზე ნაჩვენებია გაზომვების მიერ შეგროვებული ინფორმაცია წარმადობის, აპარატურის, პროგრამის გამოყენებისა და შერჩეული პარამეტრების შესახებ, რომელიც იგზავნება { $telemetryServerOwner }-ში, რომ გავაუმჯობესოთ { -brand-full-name }.
about-telemetry-settings-explanation = გაზომვებით აღირიცხება { about-telemetry-data-type }, რომელთა ატვირთვაც <a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a>.
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = მონაცემების ცალკეული ნაწილები იკვრება და იგზავნება „<a data-l10n-name="ping-link">პინგებად</a>“. თქვენ ნახულობთ { $name }, { $timestamp } პინგს.
about-telemetry-data-details-current = მონაცემების ცალკეული ნაწილები იკვრება და იგზავნება „<a data-l10n-name="ping-link">პინგებად</a>“. თქვენ ნახულობთ მიმდინარე მონაცემებს.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = { $selectedTitle }-ით ძებნა
about-telemetry-filter-all-placeholder =
    .placeholder = ყველა განყოფილებაში ძიება
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = შედეგები ფრაზისთვის „{ $searchTerms }“
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = ვწუხვართ! შედეგები ფრაზისთვის „{ $currentSearchText }“ არ მოიძებნა არეში { $sectionName }
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = ვწუხვართ! არცერთ განყოფილებაში არ მოიძებნა შედეგები ფრაზისთვის „{ $searchTerms }“
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = ვწუხვართ! მონაცემები „{ $sectionName }“ განყოფილებაში, ამჟამად არაა ხელმისაწვდომი
# used as a tooltip for the “current” ping title in the sidebar
about-telemetry-current-data-sidebar = მიმდინარე მონაცემები
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = ყველა
# button label to copy the histogram
about-telemetry-histogram-copy = ასლი
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = ნელი SQL-ბრძანებები მთავარ ნაკადში
about-telemetry-slow-sql-other = ნელი SQL-ბრძანებები დამხმარე ნაკადებში
about-telemetry-slow-sql-hits = რაოდ.
about-telemetry-slow-sql-average = საშ. დრო (მწმ)
about-telemetry-slow-sql-statement = ბრძანებები
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = დამატების იდენტიფიკატორი
about-telemetry-addon-table-details = ვრცლად
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = { $addonProvider } მომწოდებელი
about-telemetry-keys-header = მახასიათებელი
about-telemetry-names-header = სახელი
about-telemetry-values-header = მნიშვნელობა
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (დაფიქსირების რაოდენობა: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = ბოლო ჩანაწერი #{ $lateWriteCount }
about-telemetry-stack-title = სტეკი:
about-telemetry-memory-map-title = მეხსიერების რუკა:
about-telemetry-error-fetching-symbols = სიმბოლოების ამორჩევისას მოხდა შეცდომა. შეამოწმეთ თქვენი ინტერნეტთან კავშირი და სცადეთ ხელახლა.
about-telemetry-time-stamp-header = დროის ნიშნული
about-telemetry-category-header = კატეგორია
about-telemetry-method-header = მეთოდი
about-telemetry-object-header = ობიექტი
about-telemetry-extra-header = დამატებით
about-telemetry-origin-section = წყაროს გაზომვები
about-telemetry-origin-origin = წარმომავლობა
about-telemetry-origin-count = რაოდენობა
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-origins-explanation = <a data-l10n-name="origin-doc-link">Firefox-ის წყაროს გაზომვები</a> შიფრავს მონაცემებს გადაგზავნამდე, შესაბამისად { $telemetryServerOwner } შეძლებს მათ აღრიცხვას, თუმცა არ ეცოდინება რომელი { -brand-product-name } აწვდის საჭირო მონაცემებს. (<a data-l10n-name="prio-blog-link">ვრცლად</a>)
# Variables:
#  $process (String): type of process in subsection headers ( e.g. "content", "parent" )
about-telemetry-process = { $process } ამოცანა
