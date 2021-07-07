# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Strings used in about:unloads, allowing users to manage the "tab unloading"
### feature.

about-unloads-page-title = 标签页卸载
about-unloads-intro-1 = { -brand-short-name } 提供自动卸载标签页的功能，以防止应用程序在系统可用内存较低时，因内存不足而崩溃。标签页的卸载顺序取决于多个属性。此页面显示的是 { -brand-short-name } 如何排序标签页的优先级，以及触发卸载时将卸载哪些标签页。
about-unloads-intro-2 = 打开的标签页已按 { -brand-short-name } 对其的卸载顺序显示如下。<strong>粗体</strong>显示的进程 ID 表示其在处理标签页的顶层框架；<em>斜体 </em>显示的标签页代表其进程在其他不同标签页间共享。您可以点击下方的<em>卸载 </em>按钮手动触发标签页卸载。
about-unloads-intro = { -brand-short-name } 提供自动卸载标签页的功能，以防止应用程序在系统可用内存较低时，因内存不足而崩溃。标签页的卸载次序取决于多个属性。此页面显示的是 { -brand-short-name } 如何排序标签页的优先级，以及触发卸载时将卸载哪些标签页。您可点击下方的<em>卸载</em>按钮手动触发此功能。
# The link points to a Waterfox documentation page, only available in English,
# with title "Tab Unloading"
about-unloads-learn-more = 欲详细了解此功能，请参阅 <a data-l10n-name="doc-link">Tab Unloading</a> 一文。
about-unloads-last-updated = 最后更新：{ DATETIME($date, year: "numeric", month: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric", hour12: "false") }
about-unloads-button-unload = 卸载
    .title = 卸载最高优先级的标签页
about-unloads-no-unloadable-tab = 无可卸载的标签页。
about-unloads-column-priority = 优先级
about-unloads-column-host = 主机
about-unloads-column-last-accessed = 最后访问
about-unloads-column-weight = 基础权重
    .title = 按标签页是否在播放声音、WebRTC 等特殊属性，得出该值排序标签页。
about-unloads-column-sortweight = 次要权重
    .title = 按基础权重排序标签页后，再根据标签页内存用量、进程数得出该值，二次排序。
about-unloads-column-memory = 内存
    .title = 标签页的内存估计用量
about-unloads-column-processes = 进程 ID
    .title = 处理标签页内容的进程 ID
about-unloads-last-accessed = { DATETIME($date, year: "numeric", month: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric", hour12: "false") }
about-unloads-memory-in-mb = { NUMBER($mem, maxFractionalUnits: 2) } MB
about-unloads-memory-in-mb-tooltip =
    .title = { NUMBER($mem, maxFractionalUnits: 2) } MB
