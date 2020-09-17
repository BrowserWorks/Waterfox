# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-learn-more = Rohkem teavet
onboarding-button-label-get-started = Tee algust

## Welcome modal dialog strings

onboarding-welcome-header = Tere tulemast { -brand-short-name }i
onboarding-welcome-body = Sul on nüüd brauser olemas.<br/>Tutvu ülejäänud { -brand-product-name }iga.
onboarding-welcome-learn-more = Rohkem teavet eeliste kohta.

onboarding-welcome-modal-get-body = Sul on nüüd brauser olemas.<br/>On aeg { -brand-product-name }ist viimast võtta.
onboarding-welcome-modal-supercharge-body = On aeg privaatsuse kaitse uuele tasemele viia.
onboarding-welcome-modal-privacy-body = Sul on brauser olemas. Nüüd lisame sellele veel täiustatuma privaatsuse kaitse.
onboarding-welcome-modal-family-learn-more = Rohkem teavet { -brand-product-name }i perekonna toodete kohta.
onboarding-welcome-form-header = Alusta siit

onboarding-join-form-body = Alustamiseks sisesta oma e-posti aadress.
onboarding-join-form-email =
    .placeholder = Sisesta e-posti aadress
onboarding-join-form-email-error = E-posti aadress peab olema korrektne
onboarding-join-form-legal = Jätkates nõustud <a data-l10n-name="terms">teenusetingimuste</a> ja <a data-l10n-name="privacy">privaatsuspoliitikaga</a>.
onboarding-join-form-continue = Jätka

onboarding-start-browsing-button-label = Alusta veebilehitsemist

onboarding-cards-dismiss =
    .title = Peida
    .aria-label = Peida

## Multistage 3-screen onboarding flow strings (about:welcome pages)

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

## Welcome full page string

## Firefox Sync modal dialog strings.

onboarding-sync-welcome-header = Võta { -brand-product-name } endaga kaasa
onboarding-sync-welcome-content = Kasuta järjehoidjaid, ajalugu, paroole ja muid sätteid kõigil enda seadmetel.
onboarding-sync-welcome-learn-more-link = Rohkem teavet Firefoxi kontost

onboarding-sync-form-input =
    .placeholder = E-post

onboarding-sync-form-continue-button = Jätka
onboarding-sync-form-skip-login-button = Jäta see samm vahele

## This is part of the line "Enter your email to continue to Firefox Sync"

onboarding-sync-form-header = Sisesta enda e-posti aadress
onboarding-sync-form-sub-header = { -sync-brand-name }iga jätkamiseks


## These are individual benefit messages shown with an image, title and
## description.

onboarding-benefit-products-text = Aja kõik asjad korda meie Mozilla tööriistadega, mis hindavad sinu privaatsust kõigis sinu seadmetes.

# "Personal Data Promise" is a concept that should be translated consistently
# across the product. It refers to a concept shown elsewhere to the user: "The
# Firefox Personal Data Promise is the way we honor your data in everything we
# make and do. We take less data. We keep it safe. And we make sure that we are
# transparent about how we use it."
onboarding-benefit-privacy-text = Kõik, mida me teeme, austab meie antud isiklike andmete lubadust: küsime vähem andmeid, hoiame neid turvaliselt, käitleme neid läbipaistvalt.


onboarding-benefit-sync-title = { -sync-brand-short-name }
onboarding-benefit-sync-text = Võta oma järjehoidjad, paroolid, ajalugu ja muu kaasa kõikjale, kus kasutad { -brand-product-name }i.

onboarding-benefit-monitor-title = { -monitor-brand-short-name }
onboarding-benefit-monitor-text = Saa teavitatud, kui sinu isiklikud andmed tulevad mõne teadaoleva andmelekke käigus avalikuks.

onboarding-benefit-lockwise-title = { -lockwise-brand-short-name }
onboarding-benefit-lockwise-text = Halda paroole kaitstult ja kaasaskantavalt.


## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

onboarding-tracking-protection-title2 = Jälitamisvastane kaitse
onboarding-tracking-protection-text2 = { -brand-short-name } aitab takistada sinu tegevuse jälitamist internetis, tehes reklaamidel sinu järgimise võrgus keerulisemaks.
onboarding-tracking-protection-button2 = Kuidas see töötab?

onboarding-data-sync-title = Võta oma sätted endaga kaasa
# "Sync" is short for synchronize.
onboarding-data-sync-text2 = Sünkroniseeri oma järjehoidjad, paroolid ja muud asjad igal pool, kus kasutad { -brand-product-name }i.
onboarding-data-sync-button2 = Logi { -sync-brand-short-name }i sisse

onboarding-firefox-monitor-title = Hoia end kursis andmeleketega
onboarding-firefox-monitor-button = Telli hoiatused

onboarding-browse-privately-title = Lehitse veebi privaatselt
onboarding-browse-privately-text = Privaatse veebilehitsemise lõpetamisel kustutatakse otsingu ja lehitsemise ajalugu, et hoida sinu tegevus teiste arvuti kasutajate eest salajas.
onboarding-browse-privately-button = Ava privaatne aken

onboarding-firefox-send-title = Hoia oma jagatud failid privaatsena
onboarding-firefox-send-text2 = Et jagada oma faile krüptitult ja automaatselt aeguva lingi abil, laadi need üles teenusesse { -send-brand-name }.
onboarding-firefox-send-button = Proovi teenust { -send-brand-name }

onboarding-mobile-phone-title = Hangi { -brand-product-name } oma telefonile
onboarding-mobile-phone-text = Laadi alla { -brand-product-name } iOSile või Androidile ja sünkroniseeri oma andmed kõigi seadmete vahel.
# "Mobile" is short for mobile/cellular phone, "Browser" is short for web
# browser.
onboarding-mobile-phone-button = Laadi alla mobiilne brauser

onboarding-send-tabs-title = Saada seadmete vahel kaarte kohe
onboarding-send-tabs-button = Alusta kaartide seadmete vahel saatmisega

onboarding-pocket-anywhere-title = Loe ja kuula kõikjal
onboarding-pocket-anywhere-text2 = Salvesta oma lemmik sisu rakendusega { -pocket-brand-name }, et saaksid seda lugeda, kuulata või vaadata sulle mugaval ajal, kas või ilma internetita.
onboarding-pocket-anywhere-button = Proovi { -pocket-brand-name }it

onboarding-facebook-container-title = Määra Facebookile piirid
onboarding-facebook-container-text2 = { -facebook-container-brand-name } hoiab sinu profiili eraldi kõigest muust, tehes Facebookil sulle suunatud reklaamide kuvamise keerulisemaks.
onboarding-facebook-container-button = Paigalda laiendus


## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = Tore, sul on nüüd { -brand-short-name }!

# <icon></icon> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-header = Hangime sulle nüüd ka laienduse <icon></icon><b>{ $addon-name }</b>.
return-to-amo-extension-button = Paigalda laiendus
return-to-amo-get-started-button = Tee algust { -brand-short-name }iga
