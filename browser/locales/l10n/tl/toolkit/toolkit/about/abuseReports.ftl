# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Localized string used as the dialog window title (a new behavior locked
# behind the "extensions.abuseReport.openDialog" preference).
# "Report" is a noun in this case, "Report for AddonName".
#
# Variables:
#   $addon-name (string) - Name of the add-on being reported
abuse-report-dialog-title = Ulat para sa { $addon-name }

abuse-report-title-extension = Isumbong Itong Extension sa { -vendor-short-name }
abuse-report-title-theme = Isumbong Itong Tema sa { -vendor-short-name }
abuse-report-subtitle = Ano ang problema?

# Variables:
#   $author-name (string) - Name of the add-on author
abuse-report-addon-authored-by = ni <a data-l10n-name="author-name">{ $author-name }</a>

abuse-report-learnmore = Hindi sigurado aling issue ang pipiliin? <a data-l10n-name="learnmore-link">Alamin ang tungkol sa pagsumbong sa mga extension at tema</a>

abuse-report-submit-description = Ilarawan ang problema (opsyonal)
abuse-report-textarea =
    .placeholder = Mas madali para sa amin matugunan ang problema kung mayroong mga detalye. Pakilarawan kung ano ang iyong nararanasan. Salamat sa pagtulong para mapanatiling maayos ang web.
abuse-report-submit-note = Tandaan: Huwag magsama ng personal na impormasyon (gaya ng pangalan, email address, telepono, tirahan). Nagtatago ang { -vendor-short-name } ng permanenteng record ng mga ulat na ito.

## Panel buttons.

abuse-report-cancel-button = Kanselahin
abuse-report-next-button = Susunod
abuse-report-goback-button = Bumalik
abuse-report-submit-button = Ipadala

## Message bars descriptions.


## Variables:
##   $addon-name (string) - Name of the add-on

abuse-report-messagebar-aborted = Nakansela ang pag-ulat sa <span data-l10n-name="addon-name">{ $addon-name }</span>
abuse-report-messagebar-submitting = Ipinapadala ang ulat para sa <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-submitted = Salamat sa pagpasa ng ulat. Gusto mo bang tanggalin ang <span data-l10n-name="addon-name">{ $addon-name }</span>?
abuse-report-messagebar-submitted-noremove = Salamat sa pagpasa ng ulat.
abuse-report-messagebar-removed-extension = Salamat sa pagpasa ng ulat. Tinanggal mo na ang extension na <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-removed-theme = Salamat sa pagpasa ng ulat. Tinanggal mo na ang tema na <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error = Nagkaproblema sa pagpasa ng ulat para sa <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error-recent-submit = Ang ulat para sa <span data-l10n-name="addon-name">{ $addon-name }</span> ay hindi naipadala dahil may isa nang naipadala kamakailan lang.

## Message bars actions.

abuse-report-messagebar-action-remove-extension = Oo, Tanggalin Mo
abuse-report-messagebar-action-keep-extension = Huwag Nang Ituloy
abuse-report-messagebar-action-remove-theme = Oo, Tanggalin Mo
abuse-report-messagebar-action-keep-theme = Huwag Nang Ituloy
abuse-report-messagebar-action-retry = UlitinSubukan Muli
abuse-report-messagebar-action-cancel = Kanselahin

## Abuse report reasons (optionally paired with related examples and/or suggestions)

abuse-report-damage-reason-v2 = Nasira ang aking computer o na-kompromiso ang data ko
abuse-report-damage-example = Halimbawa: Nagpasok ng malware o nagnakaw ng data

abuse-report-spam-reason-v2 = Ito ay may lamang spam o di-kanais nais na advertising
abuse-report-spam-example = Halimbawa: Nagpapasok ng mga ad sa mga webpage

abuse-report-settings-reason-v2 = Binago ang aking search engine, homepage, o bagong tab na hindi nagsabi o nagpaalam
abuse-report-settings-suggestions = Bago isumbong ang extension, subukan mo munang baguhin ang iyong mga setting:
abuse-report-settings-suggestions-search = Baguhin ang iyong mga default search setting
abuse-report-settings-suggestions-homepage = Baguhin ang iyong homepage at bagong tab

abuse-report-deceptive-reason-v2 = Nagpapanggap
abuse-report-deceptive-example = Halimbawa: Mapanlinlang na pagkakalarawan

abuse-report-broken-reason-extension-v2 = Hindi gumagana, nasisira ang mga website, o bumabagal { -brand-product-name }
abuse-report-broken-reason-theme-v2 = Hindi gumana o sinira ang browser display
abuse-report-broken-example = Halimbawa: Mabagal ang feature, mahirap gamitin, o hindi gumagana; may mga parte ng website na hindi magpapakita o kakaiba ang itsura
abuse-report-broken-suggestions-extension = Mukhang nakahanap ka ng bug. Bukod sa pag-ulat nito, ang pinakamagandang paraan para maayos ang isyu ay direktang tawagan ang developer ng extension. <a data-l10n-name="support-link">Bisitahin ang website ng extension</a> para makuha ang impormasyon patungkol sa developer.
abuse-report-broken-suggestions-theme = Mukhang nakahanap ka ng bug. Bukod sa pag-ulat nito, ang pinakamagandang paraan para maayos ang isyu ay direktang tawagan ang developer ng tema. <a data-l10n-name="support-link">Bisitahin ang website ng tema</a> para makuha ang impormasyon patungkol sa developer.

abuse-report-policy-reason-v2 = May lamang galit, marahas, o illegal na nilalaman
abuse-report-policy-suggestions = Tandaan: Ang mga issue patungkol sa copyright at trademark ay dapat iulat sa hiwalay na proseso. <a data-l10n-name="report-infringement-link">Gamitin ang mga panutong ito</a> para maiulat ang problema.

abuse-report-unwanted-reason-v2 = Hindi ko ito nais at hindi alam kung paano mapupuksa ito
abuse-report-unwanted-example = Halimbawa: May application na nagkabit nito nang walang pahintulot.

abuse-report-other-reason = Iba pa

