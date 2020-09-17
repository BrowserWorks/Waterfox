# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

title-label = عن الملحقات

installed-plugins-label = الملحقات المنصّبة
no-plugins-are-installed-label = لا يوجد ملحقات منصّبة

deprecation-description = أهناك ما تفتقده؟ بعض الملحقات لم تعد مدعومة. <a data-l10n-name="deprecation-link">اطّلع على المزيد.</a>

## The information of plugins
##
## Variables:
##   $pluginLibraries: the plugin library
##   $pluginFullPath: path of the plugin
##   $version: version of the plugin

file-dd = <span data-l10n-name="file">الملف:</span> { $pluginLibraries }
path-dd = <span data-l10n-name="path">المسار:</span> { $pluginFullPath }
version-dd = <span data-l10n-name="version">الإصدارة:</span> { $version }

## These strings describe the state of plugins
##
## Variables:
##   $blockListState: show some special state of the plugin, such as blocked, outdated

state-dd-enabled = <span data-l10n-name="state">الحالة:</span> مفعّل
state-dd-enabled-block-list-state = <span data-l10n-name="state">الحالة:</span> مفعّل ({ $blockListState })
state-dd-Disabled = <span data-l10n-name="state">الحالة:</span> معطّل
state-dd-Disabled-block-list-state = <span data-l10n-name="state">الحالة:</span> معطّل ({ $blockListState })

mime-type-label = نوع MIME
description-label = الوصف
suffixes-label = اللواحق
