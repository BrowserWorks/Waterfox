# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Strings for the upgrade dialog that can be displayed on major version change.


## New changes screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-new-title = Säg hej till nya { -brand-short-name }
upgrade-dialog-new-subtitle = Designad för att snabbt ta dig dit du vill
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline
# style to be automatically added to the text inside it. { -brand-short-name }
# should stay inside the span.
upgrade-dialog-new-alt-subtitle = Börja med att göra <span data-l10n-name="zap">{ -brand-short-name }</span> tillgänglig med ett klick
upgrade-dialog-new-item-menu-title = Strömlinjeformat verktygsfält och menyer
upgrade-dialog-new-item-menu-description = Prioritera de viktiga sakerna så att du hittar vad du behöver.
upgrade-dialog-new-item-tabs-title = Moderna flikar
upgrade-dialog-new-item-tabs-description = Innehåller tydlig information, hjälper dig att fokusera och är lätta att flytta runt.
upgrade-dialog-new-item-icons-title = Fräscha ikoner och tydligare meddelanden
upgrade-dialog-new-item-icons-description = Hitta rätt med en lättare touch.
upgrade-dialog-new-primary-primary-button = Gör { -brand-short-name } till min primära webbläsare
    .title = Ställer in { -brand-short-name } som standardwebbläsare och fäster den i aktivitetsfältet
upgrade-dialog-new-primary-default-button = Gör { -brand-short-name } till min standardwebbläsare
upgrade-dialog-new-primary-pin-button = Fäst { -brand-short-name } i mitt aktivitetsfält
upgrade-dialog-new-primary-pin-alt-button = Fäst till aktivitetsfältet
upgrade-dialog-new-primary-theme-button = Välj ett tema
upgrade-dialog-new-secondary-button = Inte nu
# This string is only shown on Windows 7, where we intentionally suppress the
# theme selection screen.
upgrade-dialog-new-primary-win7-button = Okej, jag förstår!

## Pin Firefox screen
##
## These title, subtitle and button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-pin-title =
    { PLATFORM() ->
        [macos] Behåll { -brand-short-name } i Dock
       *[other] Fäst { -brand-short-name } i aktivitetsfältet
    }
# The English macOS string avoids repeating "Keep" a third time, so if your
# translations don't repeat anyway, the same string can be used cross-platform.
upgrade-dialog-pin-subtitle =
    { PLATFORM() ->
        [macos] Få enkel åtkomst till det modernaste { -brand-short-name } hittills.
       *[other] Ha den senaste { -brand-short-name } nära till hands.
    }
upgrade-dialog-pin-primary-button =
    { PLATFORM() ->
        [macos] Behåll i Dock
       *[other] Fäst till aktivitetsfältet
    }
upgrade-dialog-pin-secondary-button = Inte nu

## Default browser screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-default-title = Gör { -brand-short-name } till din standardwebbläsare?
upgrade-dialog-default-subtitle = Få hastighet, säkerhet och integritet varje gång du surfar.
upgrade-dialog-default-primary-button = Ange som standardwebbläsare
# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-default-title-2 = Gör { -brand-short-name } till din standardwebbläsare
upgrade-dialog-default-subtitle-2 = Sätt hastighet, säkerhet och integritet på autopilot.
upgrade-dialog-default-primary-button-2 = Gör till standardwebbläsare
upgrade-dialog-default-secondary-button = Inte nu

## Theme selection screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-theme-title =
    Få en ren start
    med ett uppdaterat tema
# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-theme-title-2 = Få en ren start med ett nytt tema
upgrade-dialog-theme-system = Systemtema
    .title = Följ operativsystemets tema för knappar, menyer och fönster
upgrade-dialog-theme-light = Ljust
    .title = Använd ett ljust tema för knappar, menyer och fönster
upgrade-dialog-theme-dark = Mörkt
    .title = Använd ett mörkt tema för knappar, menyer och fönster
upgrade-dialog-theme-alpenglow = Alpenglow
    .title = Använd ett dynamiskt, färgglatt tema för knappar, menyer och fönster
upgrade-dialog-theme-keep = Behåll tidigare
    .title = Använd temat som du hade installerat innan du uppdaterade { -brand-short-name }
upgrade-dialog-theme-primary-button = Spara tema
upgrade-dialog-theme-secondary-button = Inte nu
