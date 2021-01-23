# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

title-label = પ્લગ-ઇન વિશે

installed-plugins-label = સ્થાપિત થયેલ પ્લગઇન
no-plugins-are-installed-label = સ્થાપિત થયેલ પ્લગઇન મળ્યા નથી

deprecation-description = કંઈક ખૂટે છે? કેટલાક પ્લગિન્સ હવે સપોર્ટેડ નથી. <a data-l10n-name="deprecation-link">વધુ શીખો.</a>

## The information of plugins
##
## Variables:
##   $pluginLibraries: the plugin library
##   $pluginFullPath: path of the plugin
##   $version: version of the plugin

file-dd = <span data-l10n-name="file">ફાઇલ:</span> { $pluginLibraries }
path-dd = <span data-l10n-name="path">પાથ:</span> { $pluginFullPath }
version-dd = <span data-l10n-name="version">આવૃત્તિ:</span> { $version }

## These strings describe the state of plugins
##
## Variables:
##   $blockListState: show some special state of the plugin, such as blocked, outdated

state-dd-enabled = <span data-l10n-name="state">સ્થિતિ:</span> સક્રિય
state-dd-enabled-block-list-state = <span data-l10n-name="state">સ્થિતિ:</span> સક્રિય ({ $blockListState })
state-dd-Disabled = <span data-l10n-name="state">સ્થિતિ:</span> નિષ્ક્રિય
state-dd-Disabled-block-list-state = <span data-l10n-name="state">સ્થિતિ:</span> નિષ્ક્રિય ({ $blockListState })

mime-type-label = MIME પ્રકાર
description-label = વર્ણન
suffixes-label = પ્રત્યય
