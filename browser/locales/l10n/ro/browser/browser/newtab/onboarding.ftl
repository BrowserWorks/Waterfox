# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-learn-more = Află mai multe
onboarding-button-label-get-started = Începe

## Welcome modal dialog strings

onboarding-welcome-header = Bine ai venit la { -brand-short-name }
onboarding-welcome-body = Ai browserul. <br/>Vezi și ce altceva mai oferă { -brand-product-name }.
onboarding-welcome-learn-more = Află mai multe despre beneficii.
onboarding-welcome-modal-get-body = Ai browserul. <br/>Acum poți beneficia la maxim de { -brand-product-name }.
onboarding-welcome-modal-supercharge-body = Protecția confidențialității la cote maxime.
onboarding-welcome-modal-privacy-body = Ai browserul. Să adăugăm un plus de protecție a vieții private.
onboarding-welcome-modal-family-learn-more = Află despre familia de produse { -brand-product-name }.
onboarding-welcome-form-header = Începe de aici
onboarding-join-form-body = Introdu adresa de e-mail ca să începi.
onboarding-join-form-email =
    .placeholder = Introdu adresa de e-mail.
onboarding-join-form-email-error = Este necesară o adresă de e-mail validă
onboarding-join-form-legal = Continuând, ești de acord cu <a data-l10n-name="terms">Termenii de utilizare a serviciilor</a> și <a data-l10n-name="privacy">Notificarea privind confidențialitatea</a>.
onboarding-join-form-continue = Continuă
# This message is followed by a link using onboarding-join-form-signin ("Sign In") as text.
onboarding-join-form-signin-label = Ai deja un cont?
# Text for link to submit the sign in form
onboarding-join-form-signin = Autentificare
onboarding-start-browsing-button-label = Începe să navighezi
onboarding-cards-dismiss =
    .title = Înlătură
    .aria-label = Înlătură

## Multistage 3-screen onboarding flow strings (about:welcome pages)

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-welcome-header = Bine ai venit la <span data-l10n-name="zap">{ -brand-short-name }</span>
onboarding-multistage-welcome-subtitle = Browserul rapid, sigur și privat susținut de o organizație nonprofit.
onboarding-multistage-welcome-primary-button-label = Începe configurarea
onboarding-multistage-welcome-secondary-button-label = Autentifică-te
onboarding-multistage-welcome-secondary-button-text = Ai un cont?
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "more" should stay inside the span.
onboarding-multistage-import-header = Importă-ți parolele, <br/>marcajele și <span data-l10n-name="zap">altele</span>
onboarding-multistage-import-subtitle = Foloseai alt browser? Poți aduce toate datele de acolo în { -brand-short-name }.
onboarding-multistage-import-primary-button-label = Începe importul
onboarding-multistage-import-secondary-button-label = Nu acum
# Info displayed in the footer of import settings screen during onboarding flow.
# This supports welcome screen showing top sites imported from the user's default browser.
onboarding-import-sites-disclaimer = Site-urile enumerate aici au fost găsite pe acest dispozitiv. { -brand-short-name } nu salvează sau nu sincronizează date de pe alte browsere decât dacă tu alegi să le imporți.
# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = Pentru început: ecran { $current } din { $total }
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "look" should stay inside the span.
onboarding-multistage-theme-header = Alege un <span data-l10n-name="zap">aspect</span>
onboarding-multistage-theme-subtitle = Personalizează { -brand-short-name } cu o temă.
onboarding-multistage-theme-primary-button-label = Salvează tema
onboarding-multistage-theme-secondary-button-label = Nu acum
# Automatic theme uses operating system color settings
onboarding-multistage-theme-label-automatic = Automat
# System refers to the operating system
onboarding-multistage-theme-description-automatic = Folosește tema sistemului
onboarding-multistage-theme-label-light = Luminoasă
onboarding-multistage-theme-label-dark = Întunecată
# "Firefox Alpenglow" here is the name of the theme, and should be kept in English.
onboarding-multistage-theme-label-alpenglow = Firefox Alpenglow

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

# Tooltip displayed on hover of automatic theme
onboarding-multistage-theme-tooltip-automatic =
    .title =
        Preia aspectul butoanelor, meniurilor și
        ferestrelor din sistemul de operare.
    .aria-label = { onboarding-multistage-theme-tooltip-automatic.title }
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light =
    .title =
        Folosește un aspect luminos pentru
        butoane, meniuri și ferestre.
    .aria-label = { onboarding-multistage-theme-tooltip-light.title }
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark =
    .title =
        Folosește un aspect întunecat pentru
        butoane, meniuri și ferestre.
    .aria-label = { onboarding-multistage-theme-tooltip-dark.title }
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow =
    .title =
        Folosește un aspect colorat
        pentru butoane, meniuri și ferestre.
    .aria-label = { onboarding-multistage-theme-tooltip-alpenglow.title }
# Tooltip displayed on hover of automatic theme
onboarding-multistage-theme-tooltip-automatic-2 =
    .title =
        Preia aspectul butoanelor, meniurilor și
        ferestrelor din sistemul de operare.
# Input description for automatic theme
onboarding-multistage-theme-description-automatic-2 =
    .aria-description =
        Preia aspectul butoanelor, meniurilor și
        ferestrelor din sistemul de operare.
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light-2 =
    .title =
        Folosește un aspect luminos pentru
        butoane, meniuri și ferestre.
# Input description for light theme
onboarding-multistage-theme-description-light =
    .aria-description =
        Folosește un aspect luminos pentru
        butoane, meniuri și ferestre.
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark-2 =
    .title =
        Folosește un aspect întunecat pentru
        butoane, meniuri și ferestre.
# Input description for dark theme
onboarding-multistage-theme-description-dark =
    .aria-description =
        Folosește un aspect întunecat pentru
        butoane, meniuri și ferestre.
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow-2 =
    .title =
        Folosește un aspect colorat
        pentru butoane, meniuri și ferestre.
# Input description for Alpenglow theme
onboarding-multistage-theme-description-alpenglow =
    .aria-description =
        Folosește un aspect colorat
        pentru butoane, meniuri și ferestre.

## Welcome full page string

onboarding-fullpage-welcome-subheader = Să explorăm tot ce poți face.
onboarding-fullpage-form-email =
    .placeholder = Adresa ta de e-mail...

## Firefox Sync modal dialog strings.

onboarding-sync-welcome-header = Ia { -brand-product-name } cu tine
onboarding-sync-welcome-content = Ia marcajele, istoricul, parolele și alte setări cu tine pe toate dispozitivele.
onboarding-sync-welcome-learn-more-link = Află mai multe despre Conturi Firefox
onboarding-sync-form-input =
    .placeholder = E-mail
onboarding-sync-form-continue-button = Continuă
onboarding-sync-form-skip-login-button = Omite acest pas

## This is part of the line "Enter your email to continue to Firefox Sync"

onboarding-sync-form-header = Introdu e-mailul tău
onboarding-sync-form-sub-header = pentru a continua la { -sync-brand-name }.

## These are individual benefit messages shown with an image, title and
## description.

onboarding-benefit-products-text = Fii mai productiv(ă) cu o familie de unelte care îți respectă intimitatea pe toate dispozitivele.
# "Personal Data Promise" is a concept that should be translated consistently
# across the product. It refers to a concept shown elsewhere to the user: "The
# Firefox Personal Data Promise is the way we honor your data in everything we
# make and do. We take less data. We keep it safe. And we make sure that we are
# transparent about how we use it."
onboarding-benefit-privacy-text = Ne ținem de promisiunea noastră privind datele cu caracter personal prin tot ceea ce facem: Luăm mai puține informații. Le păstrăm în siguranță. Fără secrete.
onboarding-benefit-sync-title = { -sync-brand-short-name }
onboarding-benefit-sync-text = Ia-ți cu tine marcajele, parolele, istoricul și multe altele oriunde folosești { -brand-product-name }.
onboarding-benefit-monitor-title = { -monitor-brand-short-name }
onboarding-benefit-monitor-text = Primește notificări când informațiile tale cu caracter personal sunt implicate într-o încălcare cunoscută a securității datelor.
onboarding-benefit-lockwise-title = { -lockwise-brand-short-name }
onboarding-benefit-lockwise-text = Gestionarea parolelor protejate și portabile.

## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

onboarding-tracking-protection-title2 = Protecție împotriva urmăririi
onboarding-tracking-protection-text2 = { -brand-short-name } te ajută să oprești site-urile să te mai urmărească online, făcând mai dificilă pentru reclame urmărirea ta pe web.
onboarding-tracking-protection-button2 = Cum funcționează
onboarding-data-sync-title = Ia-ți cu tine setările
# "Sync" is short for synchronize.
onboarding-data-sync-text2 = Sincronizează-ți marcajele, parolele și multe altele oriunde folosești { -brand-product-name }.
onboarding-data-sync-button2 = Autentifică-te în { -sync-brand-short-name }
onboarding-firefox-monitor-title = Rămâi la curent cu încălcările securității datelor
onboarding-firefox-monitor-text2 = { -monitor-brand-name } monitorizează dacă adresa ta de e-mail a apărut într-o încălcare cunoscută a securității datelor și te alertează dacă apare într-o încălcare nouă.
onboarding-firefox-monitor-button = Înregistrează-te pentru alerte
onboarding-browse-privately-title = Navighează privat
onboarding-browse-privately-text = Navigarea privată îți șterge căutările și istoricul de navigare pentru a le păstra secrete față de oricine altcineva folosește calculatorul.
onboarding-browse-privately-button = Deschide o fereastră privată
onboarding-firefox-send-title = Ține-ți private fișierele partajate
onboarding-firefox-send-text2 = Încarcă fișiere în { -send-brand-name } pentru a le partaja folosind criptare capăt-la-capăt și un link care expiră automat.
onboarding-firefox-send-button = Încearcă { -send-brand-name }
onboarding-mobile-phone-title = Instalează { -brand-product-name } pe telefon
onboarding-mobile-phone-text = Descarcă { -brand-product-name } pentru iOS sau pentru Android și sincronizează-ți datele pe dispozitive.
# "Mobile" is short for mobile/cellular phone, "Browser" is short for web
# browser.
onboarding-mobile-phone-button = Descarcă browserul pentru dispozitive mobile
onboarding-send-tabs-title = Trimite-ți instant file
# "Send Tabs" refers to "Send Tab to Device" feature that appears when opening a
# tab's context menu.
onboarding-send-tabs-text2 = Partajare ușoară a paginilor între dispozitive fără copiere de linkuri sau ieșiri din browser.
onboarding-send-tabs-button = Începe să folosești Send Tabs
onboarding-pocket-anywhere-title = Citești și asculți oriunde
onboarding-pocket-anywhere-text2 = Salvează-ți conținuturile preferate offline cu aplicația { -pocket-brand-name } și le citești, asculți și vezi oricând îți convine.
onboarding-pocket-anywhere-button = Încearcă { -pocket-brand-name }
onboarding-lockwise-strong-passwords-title = Creare și stocare de parole puternice
onboarding-lockwise-strong-passwords-text = { -lockwise-brand-name } creează pe loc parole puternice și le salvează pe toate într-un singur loc.
onboarding-lockwise-strong-passwords-button = Gestionarea datelor de autentificare
onboarding-facebook-container-title = Setează limite cu Facebook
onboarding-facebook-container-text2 = { -facebook-container-brand-name } îți păstrează profilul separat de orice altceva, făcând mai dificil pentru Facebook să îți dea reclame țintite.
onboarding-facebook-container-button = Adaugă extensia
onboarding-import-browser-settings-title = Import de marcaje, parole și multe altele
onboarding-import-browser-settings-text = Intră direct—iei ușor cu tine site-urile și setările din Chrome.
onboarding-import-browser-settings-button = Import de date din Chrome
onboarding-personal-data-promise-title = Privat din proiectare
onboarding-personal-data-promise-text = { -brand-product-name } îți tratează datele cu respect, colectându-le într-o mai mică măsură, protejându-le și declarând clar cum sunt le folosim.
onboarding-personal-data-promise-button = Citește-ne Promisiunea

## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = Perfect, ai { -brand-short-name }
# <icon></icon> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-header = Acum, să obținem și <icon></icon><b>{ $addon-name }.</b>
return-to-amo-extension-button = Adaugă extensia
return-to-amo-get-started-button = Începe cu { -brand-short-name }
