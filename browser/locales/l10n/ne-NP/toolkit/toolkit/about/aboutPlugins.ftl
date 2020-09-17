# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

title-label = प्लगइनहरूका बारेमा

installed-plugins-label = स्थापित प्लगइनहरू
no-plugins-are-installed-label = कुनै पनि स्थापित गरिएका प्लगइनहरू भेटिएन

deprecation-description = केही छुट्यो कि? केही प्लगइनहरू अब समर्थित छैनन्। <a data-l10n-name="deprecation-link">अझ जान्नुहोस्।</a>

## The information of plugins
##
## Variables:
##   $pluginLibraries: the plugin library
##   $pluginFullPath: path of the plugin
##   $version: version of the plugin

file-dd = <span data-l10n-name="file">फाइल:</span> { $pluginLibraries }
path-dd = <span data-l10n-name="path">मार्ग:</span> { $pluginFullPath }
version-dd = <span data-l10n-name="version">संस्करण:</span> { $version }

## These strings describe the state of plugins
##
## Variables:
##   $blockListState: show some special state of the plugin, such as blocked, outdated

state-dd-enabled = <span data-l10n-name="state">स्थिति:</span> सक्षम पारिएको
state-dd-enabled-block-list-state = <span data-l10n-name="state">स्थिति:</span> सक्षम पारिएको ({ $blockListState })
state-dd-Disabled = <span data-l10n-name="state">स्थिति:</span> अक्षम पारिएको
state-dd-Disabled-block-list-state = <span data-l10n-name="state">स्थिति:</span> अक्षम पारिएको ({ $blockListState })

mime-type-label = माइम प्रकार
description-label = वर्णन
suffixes-label = प्रत्ययहरू
