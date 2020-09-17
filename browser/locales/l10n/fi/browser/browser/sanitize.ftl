# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = Historiatietojen poistamisen asetukset
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = Poista historiatietoja
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = Poista kaikki historiatiedot
    .style = width: 34em

clear-data-settings-label = Kun { -brand-short-name } suljetaan, seuraavat tiedot poistetaan:

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = Poistettava aika:{ " " }
    .accesskey = P

clear-time-duration-value-last-hour =
    .label = Viimeinen tunti

clear-time-duration-value-last-2-hours =
    .label = Viimeiset 2 tuntia

clear-time-duration-value-last-4-hours =
    .label = Viimeiset 4 tuntia

clear-time-duration-value-today =
    .label = Tämä päivä

clear-time-duration-value-everything =
    .label = Kaikki

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Historiatiedot

item-history-and-downloads =
    .label = Sivu- ja lataushistoria
    .accesskey = S

item-cookies =
    .label = Evästeet
    .accesskey = E

item-active-logins =
    .label = Aktiiviset kirjautumiset
    .accesskey = k

item-cache =
    .label = Väliaikaistiedostot
    .accesskey = V

item-form-search-history =
    .label = Lomake- ja hakuhistoria
    .accesskey = L

data-section-label = Muut tiedot

item-site-preferences =
    .label = Sivustoasetukset
    .accesskey = S

item-offline-apps =
    .label = Yhteydettömän tilan tiedot
    .accesskey = Y

sanitize-everything-undo-warning = Tätä toimintoa ei voi peruuttaa.

window-close =
    .key = w

sanitize-button-ok =
    .label = Poista tiedot

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = Poistetaan

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = Kaikki historiatiedot poistetaan.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Kaikki valitut tiedot poistetaan.
