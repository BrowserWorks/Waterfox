# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = Systemowa integracija

system-integration-dialog =
    .buttonlabelaccept = Jako standard nastajić
    .buttonlabelcancel = Integraciju přeskročić
    .buttonlabelcancel2 = Přetorhnyć

default-client-intro = { -brand-short-name } jako standardny program wužiwać za:

unset-default-tooltip = Njeje móžno, znutřka { -brand-short-name } postajić, zo { -brand-short-name } hižo nima so jako standardny program wužiwać. Zo byšće druhe nałoženje k standardnemu programej činił, dyrbiće dialog 'Jako standard wužiwać' tutoho nałoženja wužiwać.

checkbox-email-label =
    .label = E-mejl
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = Diskusijne skupiny
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = Kanale
    .tooltiptext = { unset-default-tooltip }

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
system-search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windowsowe pytanje
       *[other] { "" }
    }

system-search-integration-label =
    .label = { system-search-engine-name } za pytanje powěsćow dowolić
    .accesskey = d

check-on-startup-label =
    .label = Tutu kontrolu přeco přewjesć, hdyž { -brand-short-name } startuje
    .accesskey = T
