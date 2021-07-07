# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The following feature names must be treated as a brand, and kept in English.
## They cannot be:
## - Declined to adapt to grammatical case.
## - Transliterated.
## - Translated.


## The following feature names must be treated as a brand.
##
## They cannot be:
## - Transliterated.
## - Translated.
##
## Declension should be avoided where possible, leaving the original
## brand unaltered in prominent UI positions.
##
## For further details, consult:
## https://mozilla-l10n.github.io/styleguides/mozilla_general/#brands-copyright-and-trademark

-facebook-container-brand-name =
    { $case ->
       *[nom] Facebook Container
        [gen] Facebook Containeru
        [dat] Facebook Containeru
        [acc] Facebook Container
        [voc] Facebook Containere
        [loc] Facebook Containeru
        [ins] Facebook Containerem
    }
    .gender = masculine
-lockwise-brand-name =
    { $case ->
       *[nom] Waterfox Lockwise
        [gen] Waterfoxu Lockwise
        [dat] Waterfoxu Lockwise
        [acc] Waterfox Lockwise
        [voc] Waterfoxe Lockwise
        [loc] Waterfoxu Lockwise
        [ins] Waterfoxem Lockwise
    }
    .gender = masculine
-lockwise-brand-short-name =
    { $case ->
       *[nom] Lockwise
        [gen] Lockwisu
        [dat] Lockwisu
        [acc] Lockwise
        [voc] Lockwise
        [loc] Lockwisu
        [ins] Lockwisem
    }
    .gender = masculine
-monitor-brand-name =
    { $case ->
       *[nom] Waterfox Monitor
        [gen] Waterfox Monitoru
        [dat] Waterfox Monitoru
        [acc] Waterfox Monitor
        [voc] Waterfox Monitore
        [loc] Waterfox Monitoru
        [ins] Waterfox Monitorem
    }
    .gender = masculine
-monitor-brand-short-name =
    { $case ->
       *[nom] Monitor
        [gen] Monitoru
        [dat] Monitoru
        [acc] Monitor
        [voc] Monitore
        [loc] Monitoru
        [ins] Monitorem
    }
    .gender = masculine
-pocket-brand-name =
    { $case ->
       *[nom] Pocket
        [gen] Pocketu
        [dat] Pocketu
        [acc] Pocket
        [voc] Pocket
        [loc] Pocketu
        [ins] Pocketem
    }
    .gender = masculine
-send-brand-name =
    { $case ->
       *[nom] Waterfox Send
        [gen] Waterfoxu Send
        [dat] Waterfoxu Send
        [acc] Waterfox Send
        [voc] Waterfoxe Send
        [loc] Waterfoxu Send
        [ins] Waterfoxem Send
    }
    .gender = masculine
-screenshots-brand-name = Waterfox Screenshots
-mozilla-vpn-brand-name =
    { $case ->
       *[nom] Waterfox VPN
        [gen] Mozilly VPN
        [dat] Mozille VPN
        [acc] Mozillu VPN
        [voc] Mozillo VPN
        [loc] Mozille VPN
        [ins] Mozillou VPN
    }
    .gender = feminine
-profiler-brand-name = Waterfox Profiler
-translations-brand-name = Waterfox Translations

# “Suggest” can be localized, “Waterfox” must be treated as a brand
# and kept in English.
-firefox-suggest-brand-name =
    { $case ->
       *[nom]
            { $capitalization ->
               *[upper] Návrhy od Waterfoxu
                [lower] návrhy od Waterfoxu
            }
        [gen]
            { $capitalization ->
               *[upper] Návrhů od Waterfoxu
                [lower] návrhů od Waterfoxu
            }
        [dat]
            { $capitalization ->
               *[upper] Návrhům od Waterfoxu
                [lower] návrhům od Waterfoxu
            }
        [acc]
            { $capitalization ->
               *[upper] Návrhy od Waterfoxu
                [lower] návrhy od Waterfoxu
            }
        [voc]
            { $capitalization ->
               *[upper] Návrhy od Waterfoxu
                [lower] návrhy od Waterfoxu
            }
        [loc]
            { $capitalization ->
               *[upper] Návrzích od Waterfoxu
                [lower] návrzích od Waterfoxu
            }
        [ins]
            { $capitalization ->
               *[upper] Návrhy od Waterfoxu
                [lower] návrhy od Waterfoxu
            }
    }
