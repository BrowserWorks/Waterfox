# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = Amsidef anagrawan

system-integration-dialog =
    .buttonlabelaccept = Sbadu-t d  amezwer
    .buttonlabelcancel = Zgel amsidef
    .buttonlabelcancel2 = Sefsex

default-client-intro = &Seqdec { -brand-short-name } d amsaɣ amezwer i:

unset-default-tooltip = Ur tezmireḍ ara ad tekkseḍ { -brand-short-name } d amsaɣ-inek amezwer deg { -brand-short-name }. Akken ad tarreḍ asnas nniḍen d amezwer, yessefk ad tferneḍ deg tnaka n 'Sbadu-t d amezwer'

checkbox-email-label =
    .label = Imayl
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = Igrawen n isalen
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = Isuddam RSS
    .tooltiptext = { unset-default-tooltip }

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
system-search-engine-name =
    { PLATFORM() ->
        [macos] Amfeṛṛaz
        [windows] Anadi n isfulay
       *[other] { "" }
    }

system-search-integration-label =
    .label = Sireg { system-search-engine-name } akken ad d-nadiḍ iznan
    .accesskey = d

check-on-startup-label =
    .label = Selkam yal tikelt asenqed agi di tnekra n { -brand-short-name }
    .accesskey = i
