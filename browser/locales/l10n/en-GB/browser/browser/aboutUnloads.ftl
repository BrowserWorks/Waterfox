# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Strings used in about:unloads, allowing users to manage the "tab unloading"
### feature.

about-unloads-page-title = Tab Unloading
about-unloads-intro-1 =
    { -brand-short-name } has a feature that automatically unloads tabs
    to prevent the application from crashing due to insufficient memory
    when the system’s available memory is low. The next tab to be unloaded is
    chosen based on multiple attributes. This page shows how
    { -brand-short-name } prioritizes tabs and which tab will be unloaded
    when tab unloading is triggered.
about-unloads-intro-2 =
    Existing tabs are displayed in the table below in the same order used by
    { -brand-short-name } to choose the next tab to unload. Process IDs are
    displayed in <strong>bold</strong> when they are hosting the tab’s top
    frame, and in <em>italic</em> when the process is shared between different
    tabs. You can trigger tab unloading manually by clicking the <em>Unload</em>
    button below.
about-unloads-intro =
    { -brand-short-name } has a feature that automatically unloads tabs
    to prevent the application from crashing due to insufficient memory
    when the system’s available memory is low. The next tab to be unloaded is
    chosen based on multiple attributes. This page shows how
    { -brand-short-name } prioritises tabs and which tab will be unloaded
    when tab unloading is triggered. You can trigger tab unloading manually
    by clicking the <em>Unload</em> button below.
# The link points to a Waterfox documentation page, only available in English,
# with title "Tab Unloading"
about-unloads-learn-more =
    See <a data-l10n-name="doc-link">Tab Unloading</a> to learn more about
    the feature and this page.
about-unloads-last-updated = Last updated: { DATETIME($date, year: "numeric", month: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric", hour12: "false") }
about-unloads-button-unload = Unload
    .title = Unload tab with the highest priority
about-unloads-no-unloadable-tab = There are no unloadable tabs.
about-unloads-column-priority = Priority
about-unloads-column-host = Host
about-unloads-column-last-accessed = Last Accessed
about-unloads-column-weight = Base Weight
    .title = Tabs are first sorted by this value, which derives from some special attributes such as playing a sound, WebRTC, etc.
about-unloads-column-sortweight = Secondary Weight
    .title = If available, tabs are sorted by this value after being sorted by the base weight. The value derives from tab’s memory usage and the count of processes.
about-unloads-column-memory = Memory
    .title = Tab’s estimated memory usage
about-unloads-column-processes = Process IDs
    .title = IDs of the processes hosting tab’s content
about-unloads-last-accessed = { DATETIME($date, year: "numeric", month: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric", hour12: "false") }
about-unloads-memory-in-mb = { NUMBER($mem, maxFractionalUnits: 2) } MB
about-unloads-memory-in-mb-tooltip =
    .title = { NUMBER($mem, maxFractionalUnits: 2) } MB
