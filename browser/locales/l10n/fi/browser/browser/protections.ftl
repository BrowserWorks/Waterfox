# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $count (Number) - Number of tracking events blocked.
graph-week-summary =
    { $count ->
        [one] { -brand-short-name } esti  { $count } seuraimen viime viikon aikana
       *[other] { -brand-short-name } esti { $count } seurainta viime viikon aikana
    }

# Variables:
#   $count (Number) - Number of tracking events blocked.
#   $earliestDate (Number) - Unix timestamp in ms, representing a date. The
# earliest date recorded in the database.
graph-total-tracker-summary =
    { $count ->
        [one] <b>{ $count }</b> seurain estetty { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") } lähtien
       *[other] <b>{ $count }</b> seurainta estetty { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") } lähtien
    }

# Text displayed instead of the graph when in Private Mode
graph-private-window = { -brand-short-name } jatkaa seuraimien estämistä yksityisissä ikkunoissa, mutta ei pidä kirjaa siitä, mitä on estetty.
# Weekly summary of the graph when the graph is empty in Private Mode
graph-week-summary-private-window = Seuraimet, jotka { -brand-short-name } esti tällä viikolla

protection-report-webpage-title = Suojausten yhteenveto
protection-report-page-content-title = Suojausten yhteenveto
# This message shows when all privacy protections are turned off, which is why we use the word "can", Firefox is able to protect your privacy, but it is currently not.
protection-report-page-summary = { -brand-short-name } voi suojata yksityisyyttäsi kulisseissa, kun selaat verkkoa. Tämä on yhteenveto näistä suojauksista, joihin kuuluu työkaluja, joiden avulla voit hallita turvallisuuttasi verkossa.
# This message shows when at least some protections are turned on, we are more assertive compared to the message above, Firefox is actively protecting you.
protection-report-page-summary-default = { -brand-short-name } suojaa yksityisyyttäsi kulisseissa, kun selaat verkkoa. Tämä on henkilökohtainen yhteenveto näistä suojauksista, joihin kuuluu työkaluja, joiden avulla voit hallita turvallisuuttasi verkossa.

protection-report-settings-link = Hallitse tietosuojan ja turvallisuuden asetuksia

etp-card-title-always = Tehostettu seurannan suojaus: Aina päällä
etp-card-title-custom-not-blocking = Tehostettu seurannan suojaus: POIS PÄÄLTÄ
etp-card-content-description = { -brand-short-name } estää automaattisesti yrityksiä seuraamasta sinua salaa ympäri verkkoa.
protection-report-etp-card-content-custom-not-blocking = Kaikki suojaukset ovat pois päältä. Valitse estettävät seuraimet { -brand-short-name }-suojausasetuksista.
protection-report-manage-protections = Hallitse asetuksia

# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = Tänään

# This string is used to describe the graph for screenreader users.
graph-legend-description = Kuvaaja sisältäen jokaisen tällä viikolla estetyn seuraintyypin määrän.

social-tab-title = Sosiaalisen median seuraimet
social-tab-contant = Sosiaaliset verkot asettavat seuraimia muille verkkosivuille, ja niiden avulla sinua sekä tekemisiäsi voidaan seurata verkossa. Tämä mahdollistaa sosiaalisen median yhtiöiden kerätä sinusta enemmän tietoa kuin mitä itse jaat sosiaalisen median profiileissa. <a data-l10n-name="learn-more-link">Lue lisää</a>

cookie-tab-title = Sivustorajat ylittävät seurainevästeet
cookie-tab-content = Nämä evästeet seuraavat eri sivustoilla ja keräävät tietoja tekemisistäsi verkossa. Ne on asetettu kolmansien osapuolten, kuten mainostajien ja analytiikkayhtiöiden, toimesta. <a data-l10n-name="learn-more-link">Lue lisää</a>

tracker-tab-title = Seurantaan tarkoitettu sisältö
tracker-tab-description = Verkkosivustot saattavat ladata ulkoisia mainoksia, videoita ja muuta seurantakoodin sisältävää sisältöä. Seurantaan tarkoitetun sisällön estämällä voit nopeuttaa sivujen latautumista, mutta jotkin painikkeet, lomakkeet ja kirjautumiskentät eivät välttämättä toimi. <a data-l10n-name="learn-more-link">Lue lisää</a>

fingerprinter-tab-title = Yksilöijät
fingerprinter-tab-content = Yksilöijät keräävät asetustietoja selaimestasi sekä tietokoneestasi ja luovat näiden tietojen avulla profiilin sinusta. Tätä digitaalista sormenjälkeä hyödyntämällä sinua voidaan seurata eri verkkosivustojen välillä. <a data-l10n-name="learn-more-link">Lue lisää</a>

cryptominer-tab-title = Kryptolouhijat
cryptominer-tab-content = Kryptolouhijat käyttävät tietokoneesi laskentatehoa digitaalisen rahan louhintaan. Kryptolouhintaan tarkoitetut komentosarjat kuluttavat tietokoneen akkua, hidastavat tietokonetta ja voivat vaikuttaa sähkölaskun loppusummaan. <a data-l10n-name="learn-more-link">Lue lisää</a>

protections-close-button2 =
    .aria-label = Sulje
    .title = Sulje
  
mobile-app-title = Estä mainosseuraimia useammilla laitteilla
mobile-app-card-content = Käytä mobiiliselainta, jossa on sisäänrakennettu suojaus mainosseurantaa vastaan.
mobile-app-links = { -brand-product-name }-selain <a data-l10n-name="android-mobile-inline-link">Androidille</a> ja <a data-l10n-name="ios-mobile-inline-link">iOS:lle</a>

lockwise-title = Lopeta salasanojen unohtaminen
lockwise-title-logged-in2 = Salasanojen hallinta
lockwise-header-content = { -lockwise-brand-name } tallentaa salasanasi turvallisesti selaimeesi.
lockwise-header-content-logged-in = Tallenna salasanasi turvallisesti ja synkronoi ne eri laitteiden välillä.
protection-report-save-passwords-button = Tallenna salasanat
    .title = Tallenna salasanat { -lockwise-brand-short-name }en
protection-report-manage-passwords-button = Hallitse salasanoja
    .title = Hallitse salasanoja { -lockwise-brand-short-name }ssa
lockwise-mobile-app-title = Ota salasanasi mukaan kaikkialle
lockwise-no-logins-card-content = Käytä { -brand-short-name }-selaimeen tallennettuja salasanoja missä tahansa laitteessa.
lockwise-app-links = { -lockwise-brand-name } <a data-l10n-name="lockwise-android-inline-link">Androidille</a> ja <a data-l10n-name="lockwise-ios-inline-link">iOS:lle</a>

# Variables:
# $count (Number) - Number of passwords exposed in data breaches.
lockwise-scanned-text-breached-logins =
    { $count ->
        [one] 1 salasana on saattanut paljastua tietovuodossa.
       *[other] { $count } salasanaa on saattanut paljastua tietovuodossa.
    }

# While English doesn't use the number in the plural form, you can add $count to your language
# if needed for grammatical reasons.
# Variables:
# $count (Number) - Number of passwords stored in Lockwise.
lockwise-scanned-text-no-breached-logins =
    { $count ->
        [one] 1 salasana talletetaan turvallisesti.
       *[other] Salasanasi talletetaan turvallisesti.
    }
lockwise-how-it-works-link = Kuinka se toimii

turn-on-sync = Ota { -sync-brand-short-name } käyttöön…
    .title = Siirry synkronointiasetuksiin

monitor-title = Ota tietovuodot tarkkailuun
monitor-link = Kuinka se toimii
monitor-header-content-no-account = Tutustu { -monitor-brand-name }iin nähdäksesi onko tietojasi paljastunut tunnetuissa tietovuodoissa, ja vastaanota hälytys jos tietojasi paljastuu uusissa vuodoissa.
monitor-header-content-signed-in = { -monitor-brand-name } varoittaa sinua, jos tietosi paljastuvat tunnetussa tietovuodossa.
monitor-sign-up-link = Tilaa vuotohälytykset
    .title = Tilaa vuotohälytykset { -monitor-brand-name }-palvelussa
auto-scan = Automaattisesti tarkistettu tänään

monitor-emails-tooltip =
    .title = Tarkista seurattavat sähköpostiosoitteet { -monitor-brand-short-name }-palvelusta
monitor-breaches-tooltip =
    .title = Katso tunnetut tietovuodot { -monitor-brand-short-name }-palvelusta
monitor-passwords-tooltip =
    .title = Katso paljastuneet salasanat { -monitor-brand-short-name }-palvelusta

# This string is displayed after a large numeral that indicates the total number
# of email addresses being monitored. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-monitored-emails =
    { $count ->
        [one] Tarkkailtava sähköpostiosoite
       *[other] Tarkkailtavaa sähköpostiosoitetta
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-known-breaches-found =
    { $count ->
        [one] Tunnettu tietovuoto on paljastanut tietojasi
       *[other] Tunnettua tietovuotoa on paljastanut tietojasi
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-known-breaches-resolved =
    { $count ->
        [one] Tunnettu tietovuoto merkitty selvitetyksi
       *[other] Tunnettua tietovuotoa merkitty selvitetyksi
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-exposed-passwords-found =
    { $count ->
        [one] Salasana paljastunut kaikissa vuodoissa
       *[other] Salasanaa paljastunut kaikissa vuodoissa
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-exposed-passwords-resolved =
    { $count ->
        [one] Salasana paljastunut selvittämättömissä vuodoissa
       *[other] Salasanaa paljastunut selvittämättömissä vuodoissa
    }

monitor-no-breaches-title = Hyviä uutisia!
monitor-no-breaches-description = Ei tunnettuja tietovuotoja. Saat tiedon, jos tilanne muuttuu.
monitor-view-report-link = Näytä raportti
    .title = Selvitä vuodot { -monitor-brand-short-name }-palvelussa
monitor-breaches-unresolved-title = Selvitä tietovuodot
monitor-breaches-unresolved-description = Voit merkitä tietovuodon selvitetyksi, kun olet katsonut vuodon tiedot ja tehnyt tarvittavan tietojesi suojaamiseksi.
monitor-manage-breaches-link = Hallitse vuotoja
    .title = Hallitse vuotoja { -monitor-brand-short-name }-palvelussa
monitor-breaches-resolved-title = Hienoa! Olet selvittänyt kaikki tunnetut tietovuodot.
monitor-breaches-resolved-description = Jos sähköpostiosoitteesi ilmenee uusissa vuodoissa, ilmoitamme siitä sinulle.

# Variables:
# $numBreachesResolved (Number) - Number of breaches marked as resolved by the user on Monitor.
# $numBreaches (Number) - Number of breaches in which a user's data was involved, detected by Monitor.
monitor-partial-breaches-title =
    { $numBreaches ->
       *[other] { $numBreachesResolved }/{ $numBreaches } tietovuotoa on merkitty selvitetyksi
    }

# Variables:
# $percentageResolved (Number) - Percentage of breaches marked as resolved by a user on Monitor.
monitor-partial-breaches-percentage = { $percentageResolved } % valmiina

monitor-partial-breaches-motivation-title-start = Hieno alku!
monitor-partial-breaches-motivation-title-middle = Jatka samoin!
monitor-partial-breaches-motivation-title-end = Melkein valmista! Jatka samoin.
monitor-partial-breaches-motivation-description = Selvitä loput vuodoista { -monitor-brand-short-name }-palvelussa.
monitor-resolve-breaches-link = Selvitä vuodot
    .title = Selvitä vuodot { -monitor-brand-short-name }-palvelussa

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

bar-tooltip-social =
    .title = Sosiaalisen median seuraimet
    .aria-label =
        { $count ->
            [one] { $count } sosiaalisen median seurain ({ $percentage } %)
           *[other] { $count } sosiaalisen median seurainta ({ $percentage } %)
        }
bar-tooltip-cookie =
    .title = Sivustorajat ylittävät evästeet
    .aria-label =
        { $count ->
            [one] { $count } sivustorajat ylittävä eväste ({ $percentage } %)
           *[other] { $count } sivustorajat ylittävää evästettä ({ $percentage } %)
        }
bar-tooltip-tracker =
    .title = Seurantaan tarkoitettu sisältö
    .aria-label =
        { $count ->
            [one] { $count } seurantaan tarkoitettu sisältö ({ $percentage } %)
           *[other] { $count } seurantaan tarkoitettu sisältöä ({ $percentage } %)
        }
bar-tooltip-fingerprinter =
    .title = Yksilöijät
    .aria-label =
        { $count ->
            [one] { $count } yksilöijä ({ $percentage } %)
           *[other] { $count } yksilöijää ({ $percentage } %)
        }
bar-tooltip-cryptominer =
    .title = Kryptolouhijat
    .aria-label =
        { $count ->
            [one] { $count } kryptolouhija ({ $percentage } %)
           *[other] { $count } kryptolouhijaa ({ $percentage } %)
        }
