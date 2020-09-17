# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-learn-more = Ɓeydu humpito
onboarding-button-label-get-started = Fuɗɗo

## Welcome modal dialog strings

onboarding-welcome-header = A jaɓɓaama e { -brand-short-name }
onboarding-welcome-body = A heɓii wanngorde ndee.<br/>Ƴeew ko heddii koo e { -brand-product-name }.
onboarding-welcome-learn-more = Ɓeydu humpito baɗte ɓure ɗee.

onboarding-welcome-modal-get-body = A heɓii wanngorde ndee.<br/>Jooni noon heɓ ko ɓuri yuɓɓude e { -brand-product-name }.
onboarding-welcome-modal-supercharge-body = Ɓeydu ndeenka suturo maa.
onboarding-welcome-modal-privacy-body = A heɓii wanngorde ndee. Ɓeyden ndeenka suturo heewka.
onboarding-welcome-modal-family-learn-more = Humpito baɗte { -brand-product-name } topirɗe ciirol gootol.
onboarding-welcome-form-header = Fuɗɗo ɗoo

onboarding-join-form-body = Naat-nu ñiiɓirde iimeel maa ngam fuɗɗaade.
onboarding-join-form-email =
    .placeholder = Naatnu iimeel
onboarding-join-form-email-error = Iimeel moƴƴo ena waɗɗii
onboarding-join-form-legal = So a waɗii ɗum, firti ko a jaɓii <a data-l10n-name="terms">Laabi Carwol</a> e <a data-l10n-name="privacy">Tintinol Suturo</a>.
onboarding-join-form-continue = Jokku

# This message is followed by a link using onboarding-join-form-signin ("Sign In") as text.
onboarding-join-form-signin-label = Aɗa jogii konte kisa?
# Text for link to submit the sign in form
onboarding-join-form-signin = Seŋo

onboarding-start-browsing-button-label = Fuɗɗo wanngaade

onboarding-cards-dismiss =
    .title = Salo
    .aria-label = Salo

## Multistage 3-screen onboarding flow strings (about:welcome pages)

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

## Welcome full page string

onboarding-fullpage-welcome-subheader = Puɗɗo-ɗen yiylaade kala ko mbaawɗaa waɗde.
onboarding-fullpage-form-email =
    .placeholder = Ñiiɓirde iimeel maa…

## Firefox Sync modal dialog strings.

onboarding-sync-welcome-header = Nawor { -brand-product-name }
onboarding-sync-welcome-content = Heɓ maantore maa, aslol maa, finndeeji maa kam e teelte goɗɗe e kaɓirɗi maa fof.
onboarding-sync-welcome-learn-more-link = Ɓeydu humpito baɗte Konte Firefox

onboarding-sync-form-input =
    .placeholder = Iimeel

onboarding-sync-form-continue-button = Jokku
onboarding-sync-form-skip-login-button = Diw ngal daawal

## This is part of the line "Enter your email to continue to Firefox Sync"

onboarding-sync-form-header = Naatnu iimeel maa
onboarding-sync-form-sub-header = ngam jokkude to { -sync-brand-name }


## These are individual benefit messages shown with an image, title and
## description.


onboarding-benefit-sync-title = { -sync-brand-short-name }
onboarding-benefit-sync-text = Naw maantore mma, pinle maa, aslol maa e goɗɗe kala ɗo kuutoriɗaa { -brand-product-name }.

onboarding-benefit-monitor-title = { -monitor-brand-short-name }
onboarding-benefit-monitor-text = Heɓ tintine so humpito maa heeriingo ina woni e ciigol keɓe ngol anndaaka.

onboarding-benefit-lockwise-title = { -lockwise-brand-short-name }
onboarding-benefit-lockwise-text = Toppito pinle deenaaɗe etee naworteeɗe.


## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

onboarding-tracking-protection-title2 = Ndeenka e dewindol
onboarding-tracking-protection-text2 = { -brand-short-name } ina walla haɗde lowe geese rewindaade ma e ceŋogol, saɗtinana ɓaŋŋine rewde e maa e geese ɗee.
onboarding-tracking-protection-button2 = Hol no ɗum gollortoo

onboarding-data-sync-title = Nawor teelte maa
# "Sync" is short for synchronize.
onboarding-data-sync-text2 = Yahdin maantore maa, pinle maa, e goɗɗe kala ɗo kuutoriɗaa { -brand-product-name }.
onboarding-data-sync-button2 = Seŋo e { -sync-brand-short-name }

onboarding-firefox-monitor-title = Waɗ-tu hakkille e ciygol keɓe
onboarding-firefox-monitor-button = Winndito ngam jeertine

onboarding-browse-privately-title = Wanngo e suturo
onboarding-browse-privately-text = Banngogol suturo ina momta njiilaw maa e aslol banngogol maa ngam suuɗ-de ɗum kala neɗɗo kuutortooɗo ordinateer maa.
onboarding-browse-privately-button = Uddit Henorde Suuriinde

onboarding-firefox-send-button = Eto { -send-brand-name }

onboarding-mobile-phone-title = Heɓ { -brand-product-name } e cinndel maa
onboarding-mobile-phone-text = Aawto { -brand-product-name } ngam iOS walla Android etee yahdin keɓe maa e kaɓirɗe.
# "Mobile" is short for mobile/cellular phone, "Browser" is short for web
# browser.
onboarding-mobile-phone-button = Aawto wanngorde cinndel

onboarding-send-tabs-title = Neldu hoore maa tabbe ko aldaa e hebaade

onboarding-pocket-anywhere-title = Tar e heɗo kala ɗo ngonɗaa
onboarding-pocket-anywhere-text2 = Danndu loowdi maa katojinɗaa e jaaɓnirgal{ -pocket-brand-name } ngal e tar, heɗo, etee ndaar kala nde ɗum hawran-maa.
onboarding-pocket-anywhere-button = Eto { -pocket-brand-name }

onboarding-lockwise-strong-passwords-title = Sos e mooftu pinle maa tekkuɗe
onboarding-lockwise-strong-passwords-text = { -lockwise-brand-name } ina sosa pinle tekkuɗe e darnde etee moofta kanje fof e nokku gooto.
onboarding-lockwise-strong-passwords-button = Toppito ceŋorɗe maa

onboarding-facebook-container-title = Waɗ keeri e Facebook
onboarding-facebook-container-text2 = { -facebook-container-brand-name }waɗat heftinirde maa seertunde e huunde woɗnde kala, saɗtinana Faacebook joopaade ma e ɓaŋŋine.
onboarding-facebook-container-button = Ɓeydu timmitere ndee


onboarding-import-browser-settings-title = Jiggo maantore maa, pinle maa, e goɗɗe
onboarding-import-browser-settings-button = Jiggo keɓe Chrome

onboarding-personal-data-promise-button = Tar Aadi amen

## Message strings belonging to the Return to AMO flow

return-to-amo-extension-button = Ɓeydu timmitere ndee
