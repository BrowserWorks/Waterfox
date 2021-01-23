# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

title-label = প্লাগইন পরিচিতি

installed-plugins-label = ইন্সটলকৃত প্লাগইন
no-plugins-are-installed-label = কোনো ইন্সটলকৃত প্লাগইন পাওয়া যায়নি

deprecation-description = কোন কিছু পাওয়া যাচ্ছে না? কোন কোন প্লাগইন আর সমর্থন করে না। <a data-l10n-name="deprecation-link">আরও জানুন।</a>

## The information of plugins
##
## Variables:
##   $pluginLibraries: the plugin library
##   $pluginFullPath: path of the plugin
##   $version: version of the plugin

file-dd = <span data-l10n-name="file">ফাইল:</span> { $pluginLibraries }
path-dd = <span data-l10n-name="path">পাথ:</span> { $pluginFullPath }
version-dd = <span data-l10n-name="version">সংস্করণ:</span> { $version }

## These strings describe the state of plugins
##
## Variables:
##   $blockListState: show some special state of the plugin, such as blocked, outdated

state-dd-enabled = <span data-l10n-name="state">অবস্থা:</span> সক্রিয়
state-dd-enabled-block-list-state = <span data-l10n-name="state">অবস্থা:</span> সক্রিয় ({ $blockListState })
state-dd-Disabled = <span data-l10n-name="state">অবস্থা:</span> নিষ্ক্রিয়
state-dd-Disabled-block-list-state = <span data-l10n-name="state">অবস্থা:</span> নিষ্ক্রিয় ({ $blockListState })

mime-type-label = MIME ধরন
description-label = বিবরণ
suffixes-label = সাফিক্স
