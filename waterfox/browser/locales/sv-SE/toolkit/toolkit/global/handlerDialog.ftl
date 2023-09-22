# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Permission Dialog
## Variables:
##  $host - the hostname that is initiating the request
##  $scheme - the type of link that's being opened.
##  $appName - Name of the application that will be opened.


## Permission Dialog
## Variables:
##  $host - the hostname that is initiating the request
##  $scheme - the type of link that's being opened.
##  $appName - Name of the application that will be opened.
##  $extension - Name of extension that initiated the request

## Permission Dialog
## Variables:
##  $host (string) - The hostname that is initiating the request
##  $scheme (string) - The type of link that's being opened.
##  $appName (string) - Name of the application that will be opened.
##  $extension (string) - Name of extension that initiated the request

permission-dialog-description = Tillåt att den här webbplatsen öppnar länken { $scheme }?

permission-dialog-description-file = Tillåt den här filen att öppna länken { $scheme }?

permission-dialog-description-host = Tillåt { $host } att öppna länken { $scheme }?

permission-dialog-description-extension = Tillåt tillägget { $extension } att öppna { $scheme }-länken?

permission-dialog-description-app = Tillåt den här webbplatsen att öppna länken { $scheme } med { $appName }?

permission-dialog-description-host-app = Tillåt { $host } att öppna länken { $scheme } med { $appName }?

permission-dialog-description-file-app = Tillåt att den här filen öppnar länken { $scheme } med { $appName }?

permission-dialog-description-extension-app = Tillåt tillägget { $extension } att öppna { $scheme }-länken med { $appName }?

## Please keep the emphasis around the hostname and scheme (ie the
## `<strong>` HTML tags). Please also keep the hostname as close to the start
## of the sentence as your language's grammar allows.

## Please keep the emphasis around the hostname and scheme (ie the
## `<strong>` HTML tags). Please also keep the hostname as close to the start
## of the sentence as your language's grammar allows.
## Variables:
##  $host (string) - The hostname that is initiating the request
##  $scheme (string) - The type of link that's being opened.

permission-dialog-remember = Tillåt alltid <strong>{ $host }</strong> att öppna <strong>{ $scheme }</strong>-länkar

permission-dialog-remember-file = Tillåt alltid den här filen att öppna <strong>{ $scheme }</strong>-länkar

permission-dialog-remember-extension = Tillåt alltid detta tillägg att öppna <strong>{ $scheme }</strong>-länkar

##

permission-dialog-btn-open-link =
    .label = Öppna länk
    .accessKey = n

permission-dialog-btn-choose-app =
    .label = Välj applikation
    .accessKey = V

permission-dialog-unset-description = Du måste välja en applikation.

permission-dialog-set-change-app-link = Välj en annan applikation.

## Chooser dialog
## Variables:
##  $scheme - the type of link that's being opened.

## Chooser dialog
## Variables:
##  $scheme (string) - The type of link that's being opened.

chooser-window =
    .title = Välj Applikation
    .style = min-width: 26em; min-height: 26em;

chooser-dialog =
    .buttonlabelaccept = Öppna länk
    .buttonaccesskeyaccept = n

chooser-dialog-description = Välj en applikation för att öppna länken { $scheme }.

# Please keep the emphasis around the scheme (ie the `<strong>` HTML tags).
chooser-dialog-remember = Använd alltid den här applikationen för att öppna <strong>{ $scheme }</strong>-länkar

chooser-dialog-remember-extra =
    { PLATFORM() ->
        [windows] Detta kan ändras i inställningarna för { -brand-short-name }.
       *[other] Detta kan ändras i inställningarna för { -brand-short-name }.
    }

choose-other-app-description = Välj andra program
choose-app-btn =
    .label = Välj…
    .accessKey = V
choose-other-app-window-title = Annat program…

# Displayed under the name of a protocol handler in the Launch Application dialog.
choose-dialog-privatebrowsing-disabled = Inaktiverad i privata fönster
