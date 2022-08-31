# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

title-label = Apie papildinius

installed-plugins-label = Įdiegti papildiniai
no-plugins-are-installed-label = Nėra įdiegtų papildinių

deprecation-description = Kažko trūksta? Kai kurie papildiniai daugiau nepalaikomi. <a data-l10n-name="deprecation-link">Sužinoti daugiau.</a>

## The information of plugins
##
## Variables:
##   $pluginLibraries: the plugin library
##   $pluginFullPath: path of the plugin
##   $version: version of the plugin

file-dd = <span data-l10n-name="file">Failas:</span> { $pluginLibraries }
path-dd = <span data-l10n-name="path">Kelias:</span> { $pluginFullPath }
version-dd = <span data-l10n-name="version">Laida:</span> { $version }

## These strings describe the state of plugins
##
## Variables:
##   $blockListState: show some special state of the plugin, such as blocked, outdated

state-dd-enabled = <span data-l10n-name="state">Būsena:</span> įjungtas
state-dd-enabled-block-list-state = <span data-l10n-name="state">Būsena:</span> įjungtas ({ $blockListState })
state-dd-Disabled = <span data-l10n-name="state">Būsena:</span> išjungtas
state-dd-Disabled-block-list-state = <span data-l10n-name="state">Būsena:</span> išjungtas ({ $blockListState })

mime-type-label = MIME tipas
description-label = Aprašas
suffixes-label = Prievardžiai

## Gecko Media Plugins (GMPs)

plugins-gmp-license-info = licencijos informacija
plugins-gmp-privacy-info = Privatumo informacija

plugins-openh264-name = „OpenH264“ vaizdo kodekas, sukurtas „Cisco Systems, Inc.“
plugins-openh264-description = Šis papildinys yra automatiškai įdiegiamas norint laikytis „WebRTC“ specifikacijos ir įgalinti „WebRTC“ skambučius su įrenginiais, kurie reikalauja H.264 vaizdo kodeko. Apsilankykite http://www.openh264.org/ norėdami peržiūrėti pirminį kodeko kodą ir sužinoti daugiau apie jo realizavimą.

plugins-widevine-name = „Google Inc.“ teikiamas „Widevine“ turinio dešifravimo modulis (CDM).
plugins-widevine-description = Šis papildinys leidžia atkurti užšifruotą turinį, laikantis „Encrypted Media Extensions“ specifikacijos. Užšifruotą turinį svetainės dažniausiai naudoja norėdamos apsisaugoti nuo mokamo turinio kopijavimo. Aplankykite https://www.w3.org/TR/encrypted-media/ norėdami sužinoti daugiau apie „Encrypted Media Extensions“.
