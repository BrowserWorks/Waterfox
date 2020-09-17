# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-learn-more = Barrachd fiosrachaidh
onboarding-button-label-get-started = Dèan toiseach tòiseachaidh

## Welcome modal dialog strings

onboarding-welcome-header = Fàilte gu { -brand-short-name }
onboarding-welcome-body = Tha am brabhsair agad.<br/>Thoir eòlas air a’ chòrr de { -brand-product-name }.
onboarding-welcome-learn-more = Barrachd fiosrachaidh mu na buannachdan.

onboarding-welcome-modal-get-body = Tha am brabhsair agad.<br/>Cuir { -brand-product-name } gu làn-fheum a-nis.
onboarding-welcome-modal-supercharge-body = Cuir spionnadh sna gleusan a dhìonas do phrìobhaideachd.
onboarding-welcome-modal-privacy-body = Tha am brabhsair agad. Cuireamaid fiù barrachd dìon prìobhaideachd ris.
onboarding-welcome-modal-family-learn-more = Fàs eòlach air a’ bhathar air fad aig { -brand-product-name }.
onboarding-welcome-form-header = Tòisich an-seo

onboarding-join-form-body = Cuir a-steach am post-d agad an-seo airson toiseach-tòiseachaidh.
onboarding-join-form-email =
    .placeholder = Cuir post-d a-steach
onboarding-join-form-email-error = Tha feum air post-d dligheach
onboarding-join-form-legal = Ma leanas tu air adhart, bidh thu ag aontachadh ri <a data-l10n-name="terms">teirmichean na seirbheise</a> agus <a data-l10n-name="privacy">aithris na prìobhaideachd</a>.
onboarding-join-form-continue = Air adhart

# This message is followed by a link using onboarding-join-form-signin ("Sign In") as text.
onboarding-join-form-signin-label = A bheil cunntas agad mu thràth?
# Text for link to submit the sign in form
onboarding-join-form-signin = Clàraich a-steach

onboarding-start-browsing-button-label = Tòisich air brabhsadh

onboarding-cards-dismiss =
    .title = Leig seachad
    .aria-label = Leig seachad

## Multistage 3-screen onboarding flow strings (about:welcome pages)

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

## Welcome full page string

onboarding-fullpage-welcome-subheader = Thoireamaid sùil air a h-uile rud as urrainn dhut dèanamh.
onboarding-fullpage-form-email =
    .placeholder = An seòladh puist-d agad…

## Firefox Sync modal dialog strings.

onboarding-sync-welcome-header = Thoir { -brand-product-name } leat
onboarding-sync-welcome-content = Faigh na comharran-lìn, an eachdraidh, na faclan-faire ’s roghainnean eile air na h-uidheaman air fad agad.
onboarding-sync-welcome-learn-more-link = Barrachd fiosrachaidh air cunntasan Firefox

onboarding-sync-form-input =
    .placeholder = Post-d

onboarding-sync-form-continue-button = Lean air adhart
onboarding-sync-form-skip-login-button = Leum seachad air seo

## This is part of the line "Enter your email to continue to Firefox Sync"

onboarding-sync-form-header = Cuir a-steach am post-d agad
onboarding-sync-form-sub-header = a leantainn air adhart gu { -sync-brand-name }


## These are individual benefit messages shown with an image, title and
## description.

onboarding-benefit-products-text = Falbh an ceann do ghnothaich le sreath de dh’innealan a dhìonas do phrìobhaideachd air feadh nan uidheaman agad.

# "Personal Data Promise" is a concept that should be translated consistently
# across the product. It refers to a concept shown elsewhere to the user: "The
# Firefox Personal Data Promise is the way we honor your data in everything we
# make and do. We take less data. We keep it safe. And we make sure that we are
# transparent about how we use it."
onboarding-benefit-privacy-text = Tha gach rud a nì sinn a’ gèilleadh ri ar gealladh a thaobh dàta pearsanta: Greim air nas lugha dheth. Cùm sàbhailte e. Làn-fhollaiseacheachd.


onboarding-benefit-sync-title = { -sync-brand-short-name }
onboarding-benefit-sync-text = Thoir leat na comharran-lìn, faclan-faire, an eachdraidh ’s mòran a bharrachd àite sam bith far an cleachd thu { -brand-product-name }.

onboarding-benefit-monitor-title = { -monitor-brand-short-name }
onboarding-benefit-monitor-text = Faigh brath nuair a chaidh am fiosrachadh pearsanta agad a leigeil air èalaidh an cois briseadh dàta.

onboarding-benefit-lockwise-title = { -lockwise-brand-short-name }
onboarding-benefit-lockwise-text = Stiùirich faclan-faire a tha fo dhìon agus as urrainn dhut a thoirt leat.


## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

onboarding-tracking-protection-title2 = Dìon o thracadh
onboarding-tracking-protection-text2 = Tha { -brand-short-name } gad dhìon o làraichean-lìn a tha airson do thracadh air loidhne agus nì sin nas dorra e do shanasachd a bhith gad leantainn mun cuairt air an lìon.
onboarding-tracking-protection-button2 = Mar a dh’obraicheas e

onboarding-data-sync-title = Thoir na roghainnean agad leat
# "Sync" is short for synchronize.
onboarding-data-sync-text2 = Sioncronaich na comharran-lìn, faclan-faire ’s mòran a bharrachd àite sam bith far an cleachd thu { -brand-product-name }.
onboarding-data-sync-button2 = Clàraich a-steach gu { -sync-brand-short-name }

onboarding-firefox-monitor-title = Bidh furachail a thaobh briseadh dàta
onboarding-firefox-monitor-text2 = Cumaidh { -monitor-brand-name } sùil airson a’ phuist-d agad ma nochd e ann am briseadh dàta roimhe agus cuiridh e brath thugad ma nochdas e ann am briseadh dàta ùr.
onboarding-firefox-monitor-button = Clàraich airson rabhaidhean

onboarding-browse-privately-title = Dèan brabhsadh prìobhaideach
onboarding-browse-privately-text = Falamhaichidh gleus a’ bhrabhsaidh phrìobhaidich na lorgas tu agus eachdraidh a’ bhrabhsaidh gus a chumail falaichte o dhaoine eile a chleachdas an coimpiutair agad.
onboarding-browse-privately-button = Fosgail uinneag phrìobhaideach

onboarding-firefox-send-title = Cùm na faidhlichean co-roinnte agad prìobhaideach
onboarding-firefox-send-text2 = Luchdaich suas na faidhlichean agad gu { -send-brand-name } is co-roinn iad le gleus crioptachaidh o cheann gu ceann agus ceangal air am falbh an ùine gu fèin-obrachail.


## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = Glan taghta, tha { -brand-short-name } agad

# <icon></icon> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-header = Faigheamaid <icon></icon><b>{ $addon-name }</b> dhut a-nis.
return-to-amo-extension-button = Cuir an leudachan ris
return-to-amo-get-started-button = Dèan toiseach-tòiseachaidh le { -brand-short-name }
