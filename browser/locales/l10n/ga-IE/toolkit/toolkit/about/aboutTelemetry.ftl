# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = Foinse sonraí pingithe:
about-telemetry-show-archived-ping-data = Sonraí pingithe sa chartlann
about-telemetry-show-subsession-data = Taispeáin sonraí fosheisiúin
about-telemetry-choose-ping = Roghnaigh ping:
about-telemetry-archive-ping-type = Cineál na Pinge
about-telemetry-archive-ping-header = Ping
about-telemetry-option-group-today = Inniu
about-telemetry-option-group-yesterday = Inné
about-telemetry-option-group-older = Níos Sine
about-telemetry-page-title = Sonraí Telemetry
about-telemetry-general-data-section = Sonraí Ginearálta
about-telemetry-environment-data-section = Sonraí Timpeallachta
about-telemetry-session-info-section = Faisnéis an tSeisiúin
about-telemetry-scalar-section = Scálaigh
about-telemetry-keyed-scalar-section = Scálaigh Eochraithe
about-telemetry-histograms-section = Histeagraim
about-telemetry-keyed-histogram-section = Histeagraim Eochraithe
about-telemetry-events-section = Teagmhais
about-telemetry-simple-measurements-section = Tomhais Shimplí
about-telemetry-slow-sql-section = Ráitis Mhalla SQL
about-telemetry-addon-details-section = Mionsonraí an Bhreiseáin
about-telemetry-captured-stacks-section = Cruacha Gafa
about-telemetry-late-writes-section = Scríobh Déanach
about-telemetry-raw = JSON amh
about-telemetry-full-sql-warning = Nod: Tá dífhabhtú mall SQL ar siúl. D'fhéadfadh go mbeadh teaghráin iomlána SQL á dtaispeáint thíos, ach ní sheolfar chuig Telemetry iad.
about-telemetry-fetch-stack-symbols = Faigh ainmneacha na bhfeidhmeanna leis an gcruach a thaispeáint
about-telemetry-hide-stack-symbols = Taispeáin amhshonraí na cruaiche
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = Taispeánann an leathanach seo faisnéis maidir le feidhmíocht, crua-earraí, úsáid, agus saincheapadh a bhailigh Telemetry. Seoltar an fhaisnéis seo chuig { $telemetryServerOwner } chun cabhrú linn { -brand-full-name } a fheabhsú.
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = Seoltar gach píosa eolais cuachta in “<a data-l10n-name="ping-link">pingeacha</a>”. Tá tú ag breathnú ar phing { $name }, { $timestamp }.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = Aimsigh in { $selectedTitle }
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = uile
# button label to copy the histogram
about-telemetry-histogram-copy = Cóipeáil
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = Ráitis Mhalla SQL ar an bPríomhshnáithe
about-telemetry-slow-sql-other = Ráitis Mhalla SQL ar Shnáithe Cúntacha
about-telemetry-slow-sql-hits = Amais
about-telemetry-slow-sql-average = Meán-am (ms)
about-telemetry-slow-sql-statement = Ráiteas
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = Aitheantas an Bhreiseáin
about-telemetry-addon-table-details = Mionsonraí
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = { $addonProvider }: Soláthraí
about-telemetry-keys-header = Airí
about-telemetry-names-header = Ainm
about-telemetry-values-header = Luach
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (gafa { $capturedStacksCount } uair)
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = Scríobh Déanach #{ $lateWriteCount }
about-telemetry-stack-title = Cruach:
about-telemetry-memory-map-title = Mapa cuimhne:
about-telemetry-error-fetching-symbols = Tharla earráid agus siombailí á bhfáil. Bí cinnte go bhfuil tú ceangailte leis an Idirlíon agus bain triail eile as.
about-telemetry-time-stamp-header = stampa ama
about-telemetry-category-header = catagóir
about-telemetry-method-header = modh
about-telemetry-object-header = réad
about-telemetry-extra-header = breis
