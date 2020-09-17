# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-learn-more = Nong ngec mapol
onboarding-button-label-get-started = Caki

## Welcome modal dialog strings

onboarding-welcome-header = Wajoli i { -brand-short-name }
onboarding-welcome-body = Dong itye ki layeny.<br/>Rwatte ki jami mukene me { -brand-product-name }.
onboarding-welcome-learn-more = Nong ngec mapol ikom ber ne.

onboarding-welcome-modal-get-body = Dong itye ki layeny.<br/>Dong nong mapol ki i { -brand-product-name }.
onboarding-welcome-modal-privacy-body = Dong itye ki layeny. Wek wamed gwoke me mung mapol.
onboarding-welcome-modal-family-learn-more = Nong ngec mapol ikom dul jami me { -brand-product-name }.
onboarding-welcome-form-header = Cak Ki Kany

onboarding-join-form-body = Ket kanonge ni me email me cako.
onboarding-join-form-email =
    .placeholder = Ket email
onboarding-join-form-email-error = Email ma tye atir mite
onboarding-join-form-legal = Mede, nyuto ni iyee <a data-l10n-name="terms">Cik me Tic</a> ki <a data-l10n-name="privacy">Cik me Mung</a>.
onboarding-join-form-continue = Mede

# This message is followed by a link using onboarding-join-form-signin ("Sign In") as text.
onboarding-join-form-signin-label = Dong itye ki akaunt?
# Text for link to submit the sign in form
onboarding-join-form-signin = Dony Iyie

onboarding-start-browsing-button-label = Cak yeny

onboarding-cards-dismiss =
    .title = Kwer
    .aria-label = Kwer

## Multistage 3-screen onboarding flow strings (about:welcome pages)

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

## Welcome full page string

onboarding-fullpage-welcome-subheader = Wa cak neno jami weng ma itwero timo.
onboarding-fullpage-form-email =
    .placeholder = Kanonge ni me email…

## Firefox Sync modal dialog strings.

onboarding-sync-welcome-header = Wot ki { -brand-product-name }
onboarding-sync-welcome-content = Nong alamabuk mamegi, gin mukato, mung me donyo ki ter mukene i nyonyo ni weng.
onboarding-sync-welcome-learn-more-link = Nong ngec mapol ikom Akaunt me Firefox

onboarding-sync-form-input =
    .placeholder = Email

onboarding-sync-form-continue-button = Mede
onboarding-sync-form-skip-login-button = Kal citep man

## This is part of the line "Enter your email to continue to Firefox Sync"

onboarding-sync-form-header = Ket email mamegi
onboarding-sync-form-sub-header = me mede i { -sync-brand-name }


## These are individual benefit messages shown with an image, title and
## description.

onboarding-benefit-products-text = Tim jami ki dul pa gitic ma woro mung mamegi i nyonyo weng mamegi.


onboarding-benefit-sync-title = { -sync-brand-short-name }
onboarding-benefit-sync-text = Cwal alamabuk mamegi, mung me donyo, gin mukato ki mapol ka weng ma itiyo ki { -brand-product-name }.

onboarding-benefit-monitor-title = { -monitor-brand-short-name }

onboarding-benefit-lockwise-title = { -lockwise-brand-short-name }


## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

onboarding-tracking-protection-title2 = Gwokke ikom lubo kor
onboarding-tracking-protection-text2 = { -brand-short-name } konyo me juko kakube ikom lubo kori iwiyamo, weko bedo tek tutwal ki kwena cato wil me lubo kori i kakube.
onboarding-tracking-protection-button2 = Kit ma tiyo kwede

onboarding-data-sync-title = Wot ki ter mamegi
# "Sync" is short for synchronize.
onboarding-data-sync-text2 = Rib alamabuk mamegi, mung me donyo, ki mapol ka weng ma i tiyo ki { -brand-product-name }.
onboarding-data-sync-button2 = Dony iyie { -sync-brand-short-name }

onboarding-browse-privately-title = Yeny i mung
onboarding-browse-privately-text = Yeny i mung jwayo yeny ki gin mukato me yeny mamegi me gwoko ne i mung ki bot ngat mo keken ma tiyo ki kompiuta ni.
onboarding-browse-privately-button = Yab dirica me mung

onboarding-firefox-send-title = Gwok Pwail Mamegi ma Inywako I Mung
onboarding-firefox-send-button = Tem { -send-brand-name }

onboarding-mobile-phone-title = Nong { -brand-product-name } i Cim mamegi
onboarding-mobile-phone-text = GAm { -brand-product-name } pi iOS onyo Android ka i rib data mamegi i nyonyo weng.

# "Send Tabs" refers to "Send Tab to Device" feature that appears when opening a
# tab's context menu.
onboarding-send-tabs-text2 = Nywak iyoo mayot potbukke ikin nyonyo mamegi labongo mite me loko kakube onyo weko layeny.
onboarding-send-tabs-button = Cak tic ki Send Tabs

onboarding-pocket-anywhere-title = Kwan ki Winy Ka mo keken
onboarding-pocket-anywhere-button = Tem { -pocket-brand-name }

onboarding-lockwise-strong-passwords-button = Lo Donyo iyie Mamegi

onboarding-facebook-container-button = Med Lamed


onboarding-import-browser-settings-title = Kel ki woko Alamabuk Mamegi, Mung me donyo, ki Mapol
onboarding-import-browser-settings-button = Kel ki woko Data me Chrome

onboarding-personal-data-promise-button = Kwan Cikke wa

## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = Ber matek, itye ki { -brand-short-name }

# <icon></icon> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-header = Kombedi dong wek wanongi <icon></icon><b>{ $addon-name }.</b>
return-to-amo-extension-button = Med Lamed
return-to-amo-get-started-button = Cak ki { -brand-short-name }
