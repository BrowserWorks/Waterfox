# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $count (Number) - Number of tracking events blocked.
graph-week-summary =
    { $count ->
        [one] { -brand-short-name } blockerade { $count } spårare senaste veckan
       *[other] { -brand-short-name } blockerade { $count } spårare senaste veckan
    }

# Variables:
#   $count (Number) - Number of tracking events blocked.
#   $earliestDate (Number) - Unix timestamp in ms, representing a date. The
# earliest date recorded in the database.
graph-total-tracker-summary =
    { $count ->
        [one] <b>{ $count }</b> spårare blockerad sedan { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
       *[other] <b>{ $count }</b> spårare blockerade sedan { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
    }

# Text displayed instead of the graph when in Private Mode
graph-private-window = { -brand-short-name } fortsätter att blockera spårare i privata fönster, men sparar inte vad som blockerades.
# Weekly summary of the graph when the graph is empty in Private Mode
graph-week-summary-private-window = Spårare { -brand-short-name } blockerade den här veckan

protection-report-webpage-title = Säkerhetsöversikt
protection-report-page-content-title = Säkerhetsöversikt
# This message shows when all privacy protections are turned off, which is why we use the word "can", Waterfox is able to protect your privacy, but it is currently not.
protection-report-page-summary = { -brand-short-name } kan skydda din integritet bakom kulisserna medan du surfar. Detta är en personlig sammanfattning av dessa skydd, inklusive verktyg för att ta kontroll över din online-säkerhet.
# This message shows when at least some protections are turned on, we are more assertive compared to the message above, Waterfox is actively protecting you.
protection-report-page-summary-default = { -brand-short-name } skyddar din integritet bakom kulisserna medan du surfar. Detta är en personlig sammanfattning av dessa skydd, inklusive verktyg för att ta kontroll över din online-säkerhet.

protection-report-settings-link = Hantera dina integritets och säkerhetsinställningar

etp-card-title-always = Förbättrat spårningsskydd: Alltid på
etp-card-title-custom-not-blocking = Förbättrat spårningsskydd: Av
etp-card-content-description = { -brand-short-name } stoppar automatiskt företag från att i hemlighet följa dig på nätet.
protection-report-etp-card-content-custom-not-blocking = Alla skydd är för närvarande avstängda. Välj vilka spårare som ska blockeras genom att hantera dina { -brand-short-name }-skyddsinställningar.
protection-report-manage-protections = Hantera inställningar

# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = Idag

# This string is used to describe the graph for screenreader users.
graph-legend-description = Ett diagram som innehåller det totala antalet för varje typ av spårare som blockerats denna vecka.

social-tab-title = Social media-spårare
social-tab-contant = Sociala nätverk placerar spårare på andra webbplatser för att följa vad du gör, ser och tittar på online. Detta gör att sociala medieföretag kan lära sig mer om dig utöver vad du delar i dina sociala medieprofiler. <a data-l10n-name="learn-more-link">Läs mer</a>

cookie-tab-title = Globala spårningskakor
cookie-tab-content = Dessa kakor följer dig från webbplats till webbplats för att samla in data om vad du gör online. De ställs in av tredje part som annonsörer och analysföretag. Om du blockerar globala spårningskakor minskar antalet annonser som följer dig runt. <a data-l10n-name="learn-more-link">Läs mer</a>

tracker-tab-title = Spårningsinnehåll
tracker-tab-description = Webbplatser kan ladda externa annonser, videor och annat innehåll som innehåller spårningskod. Blockering av spårningsinnehåll kan hjälpa webbplatser att ladda snabbare, men vissa knappar, formulär och inloggningsfält kanske inte fungerar. <a data-l10n-name="learn-more-link">Läs mer</a>

fingerprinter-tab-title = Fingeravtrycksspårare
fingerprinter-tab-content = Fingeravtrycksspårare samlar inställningar från din webbläsare och dator för att skapa en profil av dig. Med det här digitala fingeravtrycket kan de spåra dig på olika webbplatser. <a data-l10n-name="learn-more-link">Läs mer</a>

cryptominer-tab-title = Kryptogrävare
cryptominer-tab-content = Kryptogrävare använder ditt systems datakraft för att utvinna digitala pengar. Kryptogrävar-skript tömmer ditt batteri, slöar ner din dator och kan öka energiräkningen. <a data-l10n-name="learn-more-link">Läs mer</a>

protections-close-button2 =
    .aria-label = Stäng
    .title = Stäng
  
mobile-app-title = Blockera annonsspårare på fler enheter
mobile-app-card-content = Använd den mobila webbläsaren med inbyggt skydd mot annonsspårning.
mobile-app-links = { -brand-product-name } webbläsare för <a data-l10n-name="android-mobile-inline-link">Android</a> och <a data-l10n-name="ios-mobile-inline-link">iOS</a>

lockwise-title = Glöm aldrig ett lösenord igen
lockwise-title-logged-in2 = Lösenordshantering
lockwise-header-content = { -lockwise-brand-name } lagrar dina lösenord på ett säkert sätt i din webbläsare.
lockwise-header-content-logged-in = Lagra och synkronisera dina lösenord på ett säkert sätt mellan alla dina enheter.
protection-report-save-passwords-button = Spara lösenord
    .title = Spara lösenord i { -lockwise-brand-short-name }
protection-report-manage-passwords-button = Hantera lösenord
    .title = Hantera lösenord i { -lockwise-brand-short-name }
lockwise-mobile-app-title = Ta med dina lösenord överallt
lockwise-no-logins-card-content = Använd lösenord som är sparade i { -brand-short-name } på vilken enhet som helst.
lockwise-app-links = { -lockwise-brand-name } för <a data-l10n-name="lockwise-android-inline-link">Android</a> och <a data-l10n-name="lockwise-ios-inline-link">iOS</a>

# Variables:
# $count (Number) - Number of passwords exposed in data breaches.
lockwise-scanned-text-breached-logins =
    { $count ->
        [one] 1 lösenord kan ha blivit exponerade vid ett dataintrång.
       *[other] { $count } lösenord kan ha blivit exponerade vid ett dataintrång.
    }

# While English doesn't use the number in the plural form, you can add $count to your language
# if needed for grammatical reasons.
# Variables:
# $count (Number) - Number of passwords stored in Lockwise.
lockwise-scanned-text-no-breached-logins =
    { $count ->
        [one] 1 lösenord lagras säkert.
       *[other] Dina lösenord lagras säkert.
    }
lockwise-how-it-works-link = Hur det fungerar

monitor-title = Håll koll på dataintrång
monitor-link = Hur fungerar det
monitor-header-content-no-account = Kontrollera { -monitor-brand-name } för att se om du har varit en del av ett känt dataintrång och få varningar om nya intrång.
monitor-header-content-signed-in = { -monitor-brand-name } varnar dig om din information har dykt upp i ett känt dataintrång.
monitor-sign-up-link = Registrera dig för intrångsvarningar
    .title = Registrera dig för intrångsvarningar på { -monitor-brand-name }
auto-scan = Skannas automatiskt idag

monitor-emails-tooltip =
    .title = Visa övervakade e-postadresser på { -monitor-brand-short-name }
monitor-breaches-tooltip =
    .title = Visa kända dataintrång på { -monitor-brand-short-name }
monitor-passwords-tooltip =
    .title = Visa exponerade lösenord på { -monitor-brand-short-name }

# This string is displayed after a large numeral that indicates the total number
# of email addresses being monitored. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-monitored-emails =
    { $count ->
        [one] E-postadress som övervakas
       *[other] E-postadresser som övervakas
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-known-breaches-found =
    { $count ->
        [one] Känt dataintrång har avslöjat din information
       *[other] Kända dataintrång har avslöjat din information
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-known-breaches-resolved =
    { $count ->
        [one] Känt dataintrång markerat som löst
       *[other] Kända dataintrång markerade som lösta
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-exposed-passwords-found =
    { $count ->
        [one] Lösenord exponerade i alla intrång
       *[other] Lösenord exponerades i alla intrång
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-exposed-passwords-resolved =
    { $count ->
        [one] Lösenord exponerat i olösta intrång
       *[other] Lösenord exponerade i olösta intrång
    }

monitor-no-breaches-title = Goda nyheter!
monitor-no-breaches-description = Du har inga kända intrång. Om det ändras, kommer vi att meddela dig.
monitor-view-report-link = Visa rapport
    .title = Lös intrång på { -monitor-brand-short-name }
monitor-breaches-unresolved-title = Lös dina intrång
monitor-breaches-unresolved-description = Efter att ha granskat information om intrånget och vidtagit åtgärder för att skydda din information kan du markera intrången som lösta.
monitor-manage-breaches-link = Hantera intrång
    .title = Hantera intrång på { -monitor-brand-short-name }
monitor-breaches-resolved-title = Trevligt! Du har löst alla kända intrång.
monitor-breaches-resolved-description = Om din e-postadress dyker upp i några nya kända intrång, kommer vi att meddela dig.

# Variables:
# $numBreachesResolved (Number) - Number of breaches marked as resolved by the user on Monitor.
# $numBreaches (Number) - Number of breaches in which a user's data was involved, detected by Monitor.
monitor-partial-breaches-title =
    { $numBreaches ->
        [one] { $numBreachesResolved } av { $numBreaches } intrång markerade som lösta
       *[other] { $numBreachesResolved } av { $numBreaches } intrång markerade som lösta
    }

# Variables:
# $percentageResolved (Number) - Percentage of breaches marked as resolved by a user on Monitor.
monitor-partial-breaches-percentage = { $percentageResolved }% färdig

monitor-partial-breaches-motivation-title-start = Bra start!
monitor-partial-breaches-motivation-title-middle = Fortsätt så!
monitor-partial-breaches-motivation-title-end = Nästan klar! Fortsätt så.
monitor-partial-breaches-motivation-description = Lös resten av dina intrång på { -monitor-brand-short-name }.
monitor-resolve-breaches-link = Lös intrång
    .title = Lös intrång på { -monitor-brand-short-name }

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

bar-tooltip-social =
    .title = Sociala media-spårare
    .aria-label =
        { $count ->
            [one] { $count } social media-spårare ({ $percentage }%)
           *[other] { $count } sociala media-spårare ({ $percentage }%)
        }
bar-tooltip-cookie =
    .title = Globala spårningskakor
    .aria-label =
        { $count ->
            [one] { $count } global spårningskaka ({ $percentage }%)
           *[other] { $count } globala spårningskakor ({ $percentage }%)
        }
bar-tooltip-tracker =
    .title = Spårningsinnehåll
    .aria-label =
        { $count ->
            [one] { $count } spårningsinnehåll ({ $percentage }%)
           *[other] { $count } spårningsinnehåll ({ $percentage }%)
        }
bar-tooltip-fingerprinter =
    .title = Fingeravtrycksspårare
    .aria-label =
        { $count ->
            [one] { $count } Fingeravtrycksspårare ({ $percentage }%)
           *[other] { $count } Fingeravtrycksspårare ({ $percentage }%)
        }
bar-tooltip-cryptominer =
    .title = Kryptogrävare
    .aria-label =
        { $count ->
            [one] { $count } kryptogrävare ({ $percentage }%)
           *[other] { $count } kryptogrävare ({ $percentage }%)
        }
