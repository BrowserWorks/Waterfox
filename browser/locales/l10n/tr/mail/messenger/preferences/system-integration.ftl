# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = Sistem tümleştirmesi

system-integration-dialog =
    .buttonlabelaccept = Varsayılan olarak ayarla
    .buttonlabelcancel = Tümleştirmeyi geç
    .buttonlabelcancel2 = İptal

default-client-intro = { -brand-short-name } aşağıdakiler için varsayılan istemcim olsun:

unset-default-tooltip = { -brand-short-name } içinden varsayılan istemciyi { -brand-short-name } dışında bir istemci yapamazsınız. Başka bir uygulamayı varsayılan yapmak için o uygulamanın 'Varsayılan olarak ayarla' komutunu kullanmalısınız.

checkbox-email-label =
    .label = E-posta
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = Haber grupları
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = Beslemeler
    .tooltiptext = { unset-default-tooltip }

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
system-search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windows Araması
       *[other] { "" }
    }

system-search-integration-label =
    .label = { system-search-engine-name } uygulamasının iletileri aramasına izin ver
    .accesskey = s

check-on-startup-label =
    .label = { -brand-short-name } her açıldığında bu denetimi yap
    .accesskey = d
