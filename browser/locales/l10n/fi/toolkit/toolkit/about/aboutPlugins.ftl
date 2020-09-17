# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

title-label = Tietoja liitännäisistä

installed-plugins-label = Asennetut liitännäiset
no-plugins-are-installed-label = Ei löytynyt yhtään asennettua liitännäistä

deprecation-description = Puuttuuko jotain? Joitain liitännäisiä ei enää tueta. <a data-l10n-name="deprecation-link">Lue lisää.</a>

## The information of plugins
##
## Variables:
##   $pluginLibraries: the plugin library
##   $pluginFullPath: path of the plugin
##   $version: version of the plugin

file-dd = <span data-l10n-name="file">Tiedosto:</span> { $pluginLibraries }
path-dd = <span data-l10n-name="path">Polku:</span> { $pluginFullPath }
version-dd = <span data-l10n-name="version">Versio:</span> { $version }

## These strings describe the state of plugins
##
## Variables:
##   $blockListState: show some special state of the plugin, such as blocked, outdated

state-dd-enabled = <span data-l10n-name="state">Tila:</span> Käytössä
state-dd-enabled-block-list-state = <span data-l10n-name="state">Tila:</span> Käytössä ({ $blockListState })
state-dd-Disabled = <span data-l10n-name="state">Tila:</span> Pois käytöstä
state-dd-Disabled-block-list-state = <span data-l10n-name="state">Tila:</span> Pois käytöstä ({ $blockListState })

mime-type-label = MIME-tyyppi
description-label = Kuvaus
suffixes-label = Päätteet
