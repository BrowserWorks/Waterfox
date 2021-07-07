# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Aanbevolen extensie
cfr-doorhanger-feature-heading = Aanbevolen functie
cfr-doorhanger-pintab-heading = Probeer dit: Tabblad vastmaken

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Waarom zie ik dit?
cfr-doorhanger-extension-cancel-button = Niet nu
    .accesskey = N
cfr-doorhanger-extension-ok-button = Nu toevoegen
    .accesskey = t
cfr-doorhanger-pintab-ok-button = Dit tabblad vastmaken
    .accesskey = v
cfr-doorhanger-extension-manage-settings-button = Instellingen voor aanbevelingen beheren
    .accesskey = I
cfr-doorhanger-extension-never-show-recommendation = Deze aanbeveling niet tonen
    .accesskey = D
cfr-doorhanger-extension-learn-more-link = Meer info
# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = door { $name }
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = Aanbeveling
cfr-doorhanger-extension-notification2 = Aanbeveling
    .tooltiptext = Aanbeveling voor extensie
    .a11y-announcement = Aanbeveling voor extensie beschikbaar
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = Aanbeveling
    .tooltiptext = Aanbeveling voor functie
    .a11y-announcement = Aanbeveling voor functie beschikbaar

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
            [one] { $total } ster
           *[other] { $total } sterren
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [one] { $total } gebruiker
       *[other] { $total } gebruikers
    }
cfr-doorhanger-pintab-description = Makkelijke toegang tot uw meestgebruikte websites. Houd websites open in een tabblad (zelfs wanneer u herstart).

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = <b>Klik met de rechtermuisknop</b> op het tabblad dat u wilt vastmaken.
cfr-doorhanger-pintab-step2 = Selecteer <b>Tabblad vastmaken</b> vanuit het menu.
cfr-doorhanger-pintab-step3 = Als de website een update bevat, ziet u een blauwe stip op uw vastgemaakte tabblad.
cfr-doorhanger-pintab-animation-pause = Pauzeren
cfr-doorhanger-pintab-animation-resume = Hervatten

## Firefox Accounts Message

cfr-doorhanger-bookmark-fxa-header = Synchroniseer uw bladwijzers overal.
cfr-doorhanger-bookmark-fxa-body = Goed gevonden! Zorg er nu voor dat u niet zonder bladwijzers zit op uw mobiele apparaten. Ga van start met { -fxaccount-brand-name }.
cfr-doorhanger-bookmark-fxa-link-text = Bladwijzers nu synchroniseren…
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = Knop Sluiten
    .title = Sluiten

## Protections panel

cfr-protections-panel-header = Surf zonder te worden gevolgd
cfr-protections-panel-body = Houd uw gegevens voor uzelf. { -brand-short-name } beschermt u tegen veel van de meest voorkomende trackers die volgen wat u online doet.
cfr-protections-panel-link-text = Meer info

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = Nieuwe functie:
cfr-whatsnew-button =
    .label = Wat is er nieuw
    .tooltiptext = Wat is er nieuw
cfr-whatsnew-panel-header = Wat is er nieuw
cfr-whatsnew-release-notes-link-text = Uitgaveopmerkingen lezen
cfr-whatsnew-fx70-title = { -brand-short-name } vecht nu nog harder voor uw privacy
cfr-whatsnew-fx70-body =
    De nieuwste update verbetert de functie Bescherming tegen volgen en maakt het
    gemakkelijker dan ooit om veilige wachtwoorden voor elke website te maken.
cfr-whatsnew-tracking-protect-title = Bescherm uzelf tegen trackers
cfr-whatsnew-tracking-protect-body =
    { -brand-short-name } blokkeert veel gebruikelijke sociale en cross-site-trackers die
    volgen wat u online doet.
cfr-whatsnew-tracking-protect-link-text = Uw rapport bekijken
# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
        [one] Tracker geblokkeerd
       *[other] Trackers geblokkeerd
    }
cfr-whatsnew-tracking-blocked-subtitle = Sinds { DATETIME($earliestDate, month: "long", year: "numeric") }
cfr-whatsnew-tracking-blocked-link-text = Rapport bekijken
cfr-whatsnew-lockwise-backup-title = Maak een back-up van uw wachtwoorden
cfr-whatsnew-lockwise-backup-body = Maak nu veilige wachtwoorden die u overal waar u zich aanmeldt kunt benaderen.
cfr-whatsnew-lockwise-backup-link-text = Back-ups inschakelen
cfr-whatsnew-lockwise-take-title = Neem uw wachtwoorden mee
cfr-whatsnew-lockwise-take-body =
    Met de mobiele app { -lockwise-brand-short-name } heeft u overal veilig
    toegang tot uw wachtwoorden.
cfr-whatsnew-lockwise-take-link-text = App downloaden

## Search Bar

cfr-whatsnew-searchbar-title = Typ minder, vind meer met de adresbalk
cfr-whatsnew-searchbar-body-topsites = Selecteer nu eenvoudigweg de adresbalk en een vak zal uitbreiden met snelkoppelingen naar uw topwebsites.

## Search bar

cfr-whatsnew-searchbar-icon-alt-text = Vergrootglaspictogram

## Picture-in-Picture

cfr-whatsnew-pip-header = Bekijk video’s terwijl u surft
cfr-whatsnew-pip-body = Picture-in-picture zet een video in een zwevend venster, zodat u kunt kijken terwijl u op andere tabbladen werkt.
cfr-whatsnew-pip-cta = Meer info

## Permission Prompt

cfr-whatsnew-permission-prompt-header = Minder vervelende pop-ups van websites
cfr-whatsnew-permission-prompt-body = { -brand-shorter-name } verhindert nu dat websites u automatisch vragen of ze u pop-upberichten mogen sturen.
cfr-whatsnew-permission-prompt-cta = Meer info

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header =
    { $fingerprinterCount ->
        [one] Fingerprinter geblokkeerd
       *[other] Fingerprinters geblokkeerd
    }
cfr-whatsnew-fingerprinter-counter-body = { -brand-shorter-name } blokkeert veel fingerprinters, die stiekem informatie over uw apparaat en handelingen verzamelen om een advertentieprofiel van u te maken.
# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = Fingerprinters
cfr-whatsnew-fingerprinter-counter-body-alt = { -brand-shorter-name } kan fingerprinters, die stiekem informatie over uw apparaat en handelingen verzamelen om een advertentieprofiel van u te maken, blokkeren.

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = Deze bladwijzer op uw telefoon ontvangen
cfr-doorhanger-sync-bookmarks-body = Neem uw bladwijzers, wachtwoorden, geschiedenis en meer mee naar overal waar u bent aangemeld bij { -brand-product-name }.
cfr-doorhanger-sync-bookmarks-ok-button = { -sync-brand-short-name } inschakelen
    .accesskey = i

## Login Sync

cfr-doorhanger-sync-logins-header = Verlies nooit meer een wachtwoord
cfr-doorhanger-sync-logins-body = Bewaar en synchroniseer uw wachtwoorden veilig op al uw apparaten.
cfr-doorhanger-sync-logins-ok-button = { -sync-brand-short-name } inschakelen
    .accesskey = i

## Send Tab

cfr-doorhanger-send-tab-header = Dit onderweg lezen
cfr-doorhanger-send-tab-recipe-header = Dit recept meenemen naar de keuken
cfr-doorhanger-send-tab-body = Met Send Tab kunt u eenvoudig deze koppeling met uw telefoon delen, of waar u ook maar bent aangemeld bij { -brand-product-name }.
cfr-doorhanger-send-tab-ok-button = Send Tab proberen
    .accesskey = p

## Firefox Send

cfr-doorhanger-firefox-send-header = Dit pdf-document veilig delen
cfr-doorhanger-firefox-send-body = Houd uw gevoelige documenten weg bij nieuwsgierige blikken met end-to-end-versleuteling en een koppeling die verdwijnt als u klaar bent.
cfr-doorhanger-firefox-send-ok-button = { -send-brand-name } proberen
    .accesskey = p

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = Beschermingen bekijken
    .accesskey = B
cfr-doorhanger-socialtracking-close-button = Sluiten
    .accesskey = S
cfr-doorhanger-socialtracking-dont-show-again = Dit soort berichten niet meer tonen
    .accesskey = D
cfr-doorhanger-socialtracking-heading = { -brand-short-name } heeft verhinderd dat een sociaal netwerk u hier volgt
cfr-doorhanger-socialtracking-description = Uw privacy is belangrijk. { -brand-short-name } blokkeert nu veelgebruikte sociale-mediatrackers en beperkt zo, hoeveel gegevens ze kunnen verzamelen over wat u online doet.
cfr-doorhanger-fingerprinters-heading = { -brand-short-name } heeft een fingerprinter op deze pagina geblokkeerd
cfr-doorhanger-fingerprinters-description = Uw privacy is belangrijk. { -brand-short-name } blokkeert nu fingerprinters, die stukjes uniek identificeerbare informatie over uw apparaat verzamelen om u te volgen.
cfr-doorhanger-cryptominers-heading = { -brand-short-name } heeft een cryptominer op deze pagina geblokkeerd
cfr-doorhanger-cryptominers-description = Uw privacy is belangrijk. { -brand-short-name } blokkeert nu cryptominers, die de rekenkracht van uw systeem gebruiken om digitale valuta te minen.

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    { $blockedCount ->
        [one] { -brand-short-name } heeft <b>{ $blockedCount }</b> tracker geblokkeerd sinds { $date }!
       *[other] { -brand-short-name } heeft meer dan <b>{ $blockedCount }</b> trackers geblokkeerd sinds { $date }!
    }
# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (Datetime) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading2 =
    { $blockedCount ->
        [one] { -brand-short-name } heeft sinds { DATETIME($date, month: "long", year: "numeric") } b>{ $blockedCount }</b> tracker geblokkeerd!
       *[other] { -brand-short-name } heeft sinds { DATETIME($date, month: "long", year: "numeric") } meer dan <b>{ $blockedCount }</b> trackers geblokkeerd!
    }
cfr-doorhanger-milestone-ok-button = Alles bekijken
    .accesskey = A

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = Maak eenvoudig veilige wachtwoorden
cfr-whatsnew-lockwise-body = Het is moeilijk om voor elke account unieke, veilige wachtwoorden te bedenken. Selecteer bij het maken van een wachtwoord het wachtwoordveld om een veilig, aangemaakt wachtwoord van { -brand-shorter-name } te gebruiken.
cfr-whatsnew-lockwise-icon-alt = { -lockwise-brand-short-name }-pictogram

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = Ontvang meldingen over kwetsbare wachtwoorden
cfr-whatsnew-passwords-body = Hackers weten dat mensen dezelfde wachtwoorden hergebruiken. Als u hetzelfde wachtwoord op meerdere websites hebt gebruikt en een van die sites getroffen is door een datalek, dan ziet u een melding in { -lockwise-brand-short-name } om uw wachtwoord op die websites te wijzigen.
cfr-whatsnew-passwords-icon-alt = Sleutelpictogram voor kwetsbaar wachtwoord

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-header = Maak picture-in-picture schermvullend
cfr-whatsnew-pip-fullscreen-body = Wanneer u een video in een zwevend scherm plaatst, kunt u daar nu op dubbelklikken om het schermvullend te maken.
cfr-whatsnew-pip-fullscreen-icon-alt = Pictogram Picture-in-Picture

## Protections Dashboard message

cfr-doorhanger-milestone-close-button = Sluiten
    .accesskey = S

## What’s New Panel Content for Firefox 76
## Protections Dashboard message

cfr-whatsnew-protections-header = Beschermingen in een oogopslag
cfr-whatsnew-protections-body = Het Beveiligingsdashboard bevat samenvattingen over datalekken en wachtwoordbeheer. U kunt nu volgen hoeveel datalekken u hebt opgelost en bekijken of uw opgeslagen wachtwoorden mogelijk zijn getroffen door een datalek.
cfr-whatsnew-protections-cta-link = Beveiligingsdashboard bekijken
cfr-whatsnew-protections-icon-alt = Schildpictogram

## Better PDF message

cfr-whatsnew-better-pdf-header = Betere PDF-ervaring
cfr-whatsnew-better-pdf-body = PDF-documenten worden nu rechtstreeks geopend in { -brand-short-name }, waardoor uw werk binnen handbereik blijft.

## DOH Message

cfr-doorhanger-doh-body = Uw privacy is belangrijk. { -brand-short-name } leidt nu waar mogelijk uw DNS-verzoeken veilig naar een partnerservice om u te beschermen terwijl u surft.
cfr-doorhanger-doh-header = Veiligere, versleutelde DNS-lookups
cfr-doorhanger-doh-primary-button-2 = Oké
    .accesskey = O
cfr-doorhanger-doh-secondary-button = Uitschakelen
    .accesskey = U

## Fission Experiment Message

cfr-doorhanger-fission-body-approved = Uw privacy is belangrijk. { -brand-short-name } isoleert, of sandboxt, websites nu van elkaar, waardoor het voor hackers moeilijker wordt om wachtwoorden, creditcardnummers en andere gevoelige informatie te stelen.
cfr-doorhanger-fission-header = Website-isolatie
cfr-doorhanger-fission-primary-button = OK, begrepen
    .accesskey = O
cfr-doorhanger-fission-secondary-button = Meer info
    .accesskey = M

## What's new: Cookies message

cfr-whatsnew-clear-cookies-header = Automatische bescherming tegen stiekeme volgtactieken
cfr-whatsnew-clear-cookies-body = Sommige trackers leiden u door naar andere websites die in het geheim cookies plaatsen. { -brand-short-name } wist die cookies nu automatisch, zodat u niet kunt worden gevolgd.
cfr-whatsnew-clear-cookies-image-alt = Afbeelding Cookie geblokkeerd

## What's new: Media controls message

cfr-whatsnew-media-keys-header = Meer mediabediening
cfr-whatsnew-media-keys-body = Speel of pauzeer audio of video rechtstreeks vanaf uw toetsenbord of headset, waardoor het eenvoudig wordt om media vanuit een ander tabblad, programma of zelfs wanneer uw computer is vergrendeld te bedienen. U kunt met de toetsen voor vooruit en achteruit tussen tracks verspringen.
cfr-whatsnew-media-keys-button = Meer info

## What's new: Search shortcuts

cfr-whatsnew-search-shortcuts-header = Zoeksnelkoppelingen in de adresbalk
cfr-whatsnew-search-shortcuts-body = Wanneer u voortaan een zoekmachine of specifieke website in de adresbalk typt, verschijnt een blauwe snelkoppeling in de zoeksuggesties eronder. Selecteer die snelkoppeling om uw zoekopdracht rechtstreeks vanuit de zoekbalk te voltooien.

## What's new: Cookies protection

cfr-whatsnew-supercookies-header = Bescherming tegen kwaadaardige supercookies
cfr-whatsnew-supercookies-body = Websites kunnen stiekem een ‘supercookie’ aan uw browser koppelen, dat u op het internet kan volgen, zelfs nadat u uw cookies hebt gewist. { -brand-short-name } biedt nu krachtige bescherming tegen supercookies, zodat ze niet kunnen worden gebruikt om uw online activiteiten op verschillende websites te volgen.

## What's new: Better bookmarking

cfr-whatsnew-bookmarking-header = Beter bladwijzers maken
cfr-whatsnew-bookmarking-body = Het is gemakkelijker om uw favoriete websites bij te houden. { -brand-short-name } onthoudt nu uw voorkeurslocatie voor opgeslagen bladwijzers, toont de bladwijzerwerkbalk standaard op nieuwe tabbladen en geeft u eenvoudige toegang tot de rest van uw bladwijzers via een werkbalkmap.

## What's new: Cross-site cookie tracking

cfr-whatsnew-cross-site-tracking-header = Uitgebreide bescherming tegen volgen door cross-site-cookies
cfr-whatsnew-cross-site-tracking-body = U kunt zich nu aanmelden voor betere bescherming tegen volgen door cookies. { -brand-short-name } kan uw activiteiten en gegevens isoleren voor de website die u bezoekt, zodat in de browser opgeslagen informatie niet tussen websites wordt gedeeld.

## Full Video Support CFR message

cfr-doorhanger-video-support-body = Video’s op deze website worden mogelijk in deze versie van { -brand-short-name } niet correct afgespeeld. Werk { -brand-short-name } nu bij voor volledige video-ondersteuning.
cfr-doorhanger-video-support-header = Werk { -brand-short-name } bij om video af te spelen
cfr-doorhanger-video-support-primary-button = Nu bijwerken
    .accesskey = w
