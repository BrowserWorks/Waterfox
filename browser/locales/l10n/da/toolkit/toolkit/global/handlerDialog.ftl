# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Please keep the emphasis around the hostname and scheme (ie the
# `<strong>` HTML tags). Please also keep the hostname as close to the start
# of the sentence as your language's grammar allows.
#
# Variables:
#  $host - the hostname that is initiating the request
#  $scheme - the type of link that's being opened.
handler-dialog-host = <strong>{ $host }</strong> vil åbne et <strong>{ $scheme }</strong>-link.

## Permission Dialog
## Variables:
##  $host - the hostname that is initiating the request
##  $scheme - the type of link that's being opened.
##  $appName - Name of the application that will be opened.

permission-dialog-description = Tillad dette websted at åbne { $scheme }-linket?
permission-dialog-description-file = Tillad denne fil at åbne { $scheme }-linket?
permission-dialog-description-host = Tillad { $host } at åbne { $scheme }-linket?
permission-dialog-description-app = Tillad dette websted at åbne { $scheme }-linket med { $appName }?
permission-dialog-description-host-app = Tillad { $host } at åbne { $scheme }-linket med { $appName }?
permission-dialog-description-file-app = Tillad denne fil at åbne { $scheme }-linket med { $appName }?

## Please keep the emphasis around the hostname and scheme (ie the
## `<strong>` HTML tags). Please also keep the hostname as close to the start
## of the sentence as your language's grammar allows.

permission-dialog-remember = Tillad altid <strong>{ $host }</strong> at åbne <strong>{ $scheme }</strong>-links
permission-dialog-remember-file = Tillad altid denne fil at åbne <strong>{ $scheme }</strong>-links

##

permission-dialog-btn-open-link =
    .label = Åbn links
    .accessKey = b
permission-dialog-btn-choose-app =
    .label = Vælg program
    .accessKey = p
permission-dialog-unset-description = Du skal vælge et program.
permission-dialog-set-change-app-link = Vælg et andet program.

## Chooser dialog
## Variables:
##  $scheme - the type of link that's being opened.

chooser-window =
    .title = Vælg program
    .style = min-width: 26em; min-height: 26em;
chooser-dialog =
    .buttonlabelaccept = Åbn link
    .buttonaccesskeyaccept = b
chooser-dialog-description = Vælg et program til at åbne { $scheme }-linket med.
# Please keep the emphasis around the scheme (ie the `<strong>` HTML tags).
chooser-dialog-remember = Brug altid dette program til at åbne <strong>{ $scheme }</strong>-links
chooser-dialog-remember-extra =
    { PLATFORM() ->
        [windows] Dette kan ændres i indstillingerne i { -brand-short-name }.
       *[other] Dette kan ændres i indstillingerne i { -brand-short-name }.
    }
choose-other-app-description = Vælg et andet program
choose-app-btn =
    .label = Vælg…
    .accessKey = V
choose-other-app-window-title = Vælg andet program…
# Displayed under the name of a protocol handler in the Launch Application dialog.
choose-dialog-privatebrowsing-disabled = Deaktiveret i private vinduer
