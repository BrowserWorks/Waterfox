# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


preferences-title =
    .title =
        { PLATFORM() ->
            [windows] Opsies
           *[other] Voorkeure
        }

pane-compose-title = Opstelling
category-compose =
    .tooltiptext = Opstelling

## OS Authentication dialog


## General Tab

general-legend = { -brand-short-name } se beginbladsy

start-page-label =
    .label = Wanneer { -brand-short-name } laat loop word, wys die beginbladsy in die boodskaparea
    .accesskey = W

location-label =
    .value = Ligging:
    .accesskey = i
restore-default-label =
    .label = Laai verstek terug
    .accesskey = L

new-message-arrival = Wanneer nuwe boodskappe arriveer:
mail-play-button =
    .label = Speel
    .accesskey = S

animated-alert-label =
    .label = Wys 'n waarskuwing
    .accesskey = W
customize-alert-label =
    .label = Doelmaak…
    .accesskey = D

mail-custom-sound-label =
    .label = Gebruik die volgende klanklêer
    .accesskey = G
mail-browse-sound-button =
    .label = Blaai…
    .accesskey = B

enable-gloda-search-label =
    .label = Aktiveer globale soektog en indekseerder
    .accesskey = A

system-integration-legend = Stelselintegrasie
always-check-default =
    .label = Kontroleer altyd aan begin of { -brand-short-name } die verstek-poskliënt is
    .accesskey = K

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windowssoektog
       *[other] { "" }
    }

search-integration-label =
    .label = Laat { search-engine-name } toe om boodskappe te deursoek
    .accesskey = b

config-editor-button =
    .label = Opstelling-redigeerder…
    .accesskey = O

return-receipts-description = Bepaal hoe { -brand-short-name } antwoordstrokies hanteer
return-receipts-button =
    .label = Antwoordstrokies…
    .accesskey = A

update-history-button =
    .label = Wys bywerkgeskiedenis
    .accesskey = W

networking-legend = Verbinding
proxy-config-description = Stel op hoe { -brand-short-name } aan die internet koppel

network-settings-button =
    .label = Opstelling…
    .accesskey = O

offline-legend = Aflyn
offline-settings = Stel aflynopstelling op

offline-settings-button =
    .label = Aflyn…
    .accesskey = A

diskspace-legend = Skyfspasie

## Note: The entities use-cache-before and use-cache-after appear on a single
## line in preferences as follows:
## use-cache-before [ textbox for cache size in MB ] use-cache-after

use-cache-before =
    .value = Gebruik tot
    .accesskey = G

use-cache-after = MG spasie vir die kasgeheue

##

clear-cache-button =
    .label = Maak nou skoon
    .accesskey = M

default-font-label =
    .value = Verstekfont:
    .accesskey = V

font-options-button =
    .label = Gevorderd…
    .accesskey = G

display-width-legend = Skoonteks-boodskappe

display-text-label = Wanneer aangehaalde teks in skoonteks boodskappe gewys word:

style-label =
    .value = Styl:
    .accesskey = y

regular-style-item =
    .label = Gewoon
bold-style-item =
    .label = Vet
italic-style-item =
    .label = Skuins
bold-italic-style-item =
    .label = Vet skuinsdruk

size-label =
    .value = Grootte:
    .accesskey = G

regular-size-item =
    .label = Gewoon
bigger-size-item =
    .label = Groter
smaller-size-item =
    .label = Kleiner

search-input =
    .placeholder = Soek

type-column-label =
    .label = Inhoudsoort
    .accesskey = s

action-column-label =
    .label = Aksie
    .accesskey = A

save-to-label =
    .label = Stoor lêers na
    .accesskey = S

choose-folder-label =
    .label =
        { PLATFORM() ->
            [macos] Kies…
           *[other] Blaai…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] K
           *[other] B
        }

always-ask-label =
    .label = Vra my altyd waar om lêers te stoor
    .accesskey = V


display-tags-text = Merkers kan gebruik word om u boodskappe te kategoriseer en te prioritiseer.

delete-tag-button =
    .label = Skrap
    .accesskey = S

auto-mark-as-read =
    .label = Merk boodskappe outomaties as gelees
    .accesskey = M

mark-read-no-delay =
    .label = Dadelik wanneer vertoon
    .accesskey = w

## Note: This will concatenate to "After displaying for [___] seconds",
## using (mark-read-delay) and a number (seconds-label).

mark-read-delay =
    .label = Na vertoon is vir
    .accesskey = v

seconds-label = sekondes

##

open-msg-label =
    .value = Open boodskappe in:

open-msg-tab =
    .label = 'n Nuwe oortjie
    .accesskey = o

open-msg-window =
    .label = 'n Nuwe boodskapvenster
    .accesskey = N

open-msg-ex-window =
    .label = 'n Bestaande boodskapvenster
    .accesskey = B

condensed-addresses-label =
    .label = Wys net vertoonnaam vir mense in my adresboek
    .accesskey = W

## Compose Tab

forward-label =
    .value = Stuur boodskappe aan:
    .accesskey = S

inline-label =
    .label = Inlyn

as-attachment-label =
    .label = As aanhegsel

extension-label =
    .label = voeg uitbreiding by lêernaam
    .accesskey = u

## Note: This will concatenate to "Auto Save every [___] minutes",
## using (auto-save-label) and a number (auto-save-end).

auto-save-label =
    .label = Outostoor elke
    .accesskey = O

auto-save-end = minute

##

warn-on-send-accel-key =
    .label = Bevestig wanneer sleutelbordkortpad gebruik word om boodskap te stuur
    .accesskey = B

spellcheck-label =
    .label = Toets spelling voor versending
    .accesskey = s

spellcheck-inline-label =
    .label = Gaan spelling na terwyl u tik
    .accesskey = E

language-popup-label =
    .value = Taal:
    .accesskey = T

download-dictionaries-link = Laai nog woordeboeke af

font-label =
    .value = Font:
    .accesskey = n

font-color-label =
    .value = Tekskleur:
    .accesskey = T

bg-color-label =
    .value = Agtergrondkleur:
    .accesskey = A

restore-html-label =
    .label = Laai verstek terug
    .accesskey = L

format-description = Stel teksformaatgedrag op

send-options-label =
    .label = Stuuropsies…
    .accesskey = S

autocomplete-description = Wanneer boodskappe geskryf word, soek resultate in:

ab-label =
    .label = Plaaslike adresboeke
    .accesskey = P

directories-label =
    .label = Gidsbediener:
    .accesskey = G

directories-none-label =
    .none = Geen

edit-directories-label =
    .label = Wysig gidse…
    .accesskey = W

email-picker-label =
    .label = Voeg uitgaande e-posadresse outomaties by my:
    .accesskey = V

attachment-label =
    .label = Kontroleer vir vermiste aanhegsels
    .accesskey = v

attachment-options-label =
    .label = Sleutelwoorde…
    .accesskey = S


## Privacy Tab

web-content = Webinhoud

keep-label =
    .value = Hou tot:
    .accesskey = H

keep-expire =
    .label = hulle verval
keep-close =
    .label = ek { -brand-short-name } afsluit
keep-ask =
    .label = vra elke keer

cookies-button =
    .label = Wys koekies…
    .accesskey = W

passwords-description = { -brand-short-name } kan wagwoorde vir al jou rekeninge onthou.

passwords-button =
    .label = Gestoorde wagwoorde…
    .accesskey = G

master-password-description = 'n Meesterwagwoord beskerm al u wagwoorde, maar u moet dit een keer per sessie intik.

master-password-label =
    .label = Gebruik 'n meesterwagwoord
    .accesskey = G

master-password-button =
    .label = Wysig meesterwagwoord…
    .accesskey = W


junk-description = Verstel die verstek gemorspos-opstelling. Rekeningspesifieke gemorspos-opstelling kan gedoen word by die rekeningopstelling.

junk-label =
    .label = Wanneer ek boodskappe as gemors merk:
    .accesskey = W

junk-delete-label =
    .label = Skrap hulle
    .accesskey = S

junk-read-label =
    .label = Merk boodskappe wat as gemors beskou word, as gemerk
    .accesskey = M

junk-log-button =
    .label = Wys staaflêer
    .accesskey = W

reset-junk-button =
    .label = Stel opleidingsdata terug
    .accesskey = S

phishing-description = { -brand-short-name } kan boodskappe analiseer vir verdagte e-posswendelary deur uit te kyk vir algemene tegnieke om mens om die bos te lei.

phishing-label =
    .label = Vertel my as die boodskap wat ek lees, dalk 'n e-posswendel is
    .accesskey = V

certificate-description = Wanneer 'n bediener my persoonlike sertifikaat aanvra:

certificate-ask =
    .label = Vra my elke keer
    .accesskey = A

## Chat Tab


## Note: idle-label is displayed first, then there's a field where the user
## can enter a number, and itemTime is displayed at the end of the line.
## The translations of the idle-label and idle-time-label parts don't have
## to mean the exact same thing as in English; please try instead to
## translate the whole sentence.


##

chat-play-button =
    .label = Speel
    .accesskey = S

chat-custom-sound-label =
    .label = Gebruik die volgende klanklêer
    .accesskey = G

chat-browse-sound-button =
    .label = Blaai…
    .accesskey = B

## Preferences UI Search Results

