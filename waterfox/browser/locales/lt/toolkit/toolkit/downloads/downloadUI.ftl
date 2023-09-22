# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

download-ui-confirm-title = Visų atsiuntimų atsisakymas

## Variables:
##   $downloadsCount (Number): The current downloads count.

download-ui-confirm-quit-cancel-downloads =
    { $downloadsCount ->
        [1] Jei baigsite darbą dabar, tai tuo pačiu atsisakysite vieno failo atsiuntimo. Ar tikrai baigti darbą?
       *[other] Jei baigsite darbą dabar, tai tuo pačiu atsisakysite { $downloadsCount } failų atsiuntimo. Ar tikrai baigti darbą?
    }
download-ui-confirm-quit-cancel-downloads-mac =
    { $downloadsCount ->
        [1] Jei baigsite darbą dabar, tai tuo pačiu atsisakysite vieno failo atsiuntimo. Ar tikrai baigti darbą?
       *[other] Jei baigsite darbą dabar, tai tuo pačiu atsisakysite { $downloadsCount } failų atsiuntimo. Ar tikrai baigti darbą?
    }
download-ui-dont-quit-button =
    { PLATFORM() ->
        [mac] Tęsti darbą
       *[other] Tęsti darbą
    }

download-ui-confirm-offline-cancel-downloads =
    { $downloadsCount ->
        [1] Jei atsijungsite nuo tinklo dabar, tai tuo pačiu atsisakysite vieno failo atsiuntimo. Ar tikrai atsijungti nuo tinklo?
       *[other] Jei atsijungsite nuo tinklo dabar, tai tuo pačiu atsisakysite { $downloadsCount } failų atsiuntimo. Ar tikrai atsijungti nuo tinklo?
    }
download-ui-dont-go-offline-button = Neatsijungti nuo tinklo

download-ui-confirm-leave-private-browsing-windows-cancel-downloads =
    { $downloadsCount ->
        [1] Jei dabar užversite visus privačiojo naršymo langus, bus nutrauktas vienas siuntimas. Ar tikrai norite nutraukti privačiojo naršymo seansą?
       *[other] Jei dabar užversite visus privačiojo naršymo langus, bus nutraukti (-a) { $downloadsCount } siuntimai (-ų). Ar tikrai norite nutraukti privačiojo naršymo seansą?
    }
download-ui-dont-leave-private-browsing-button = Tęsti privatųjį naršymą

download-ui-cancel-downloads-ok =
    { $downloadsCount ->
        [1] Atsisakyti 1 atsiuntimo
       *[other] Atsisakyti { $downloadsCount } atsiuntimų
    }

##

download-ui-file-executable-security-warning-title = Vykdomojo failo atvėrimas
# Variables:
#   $executable (String): The executable file to be opened.
download-ui-file-executable-security-warning = „{ $executable }“ yra vykdomasis failas. Tokiuose failuose gali būti virusų ir kitų kenkėjiškų programų, kurios gali pažeisti kompiuteryje laikomus duomenis. Būkite atsargūs atverdami šio tipo failus. Ar tikrai paleisti „{ $executable }“?
