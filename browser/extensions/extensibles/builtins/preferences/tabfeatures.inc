  <!-- Tab Bar Position preferences -->
  <label><html:h2 data-l10n-id="tab-position-header"/></label>
  <vbox id="tabPositionSettingsContainer">
    <radiogroup id="tabPositionGroup" preference="browser.tabs.toolbarposition">
      <radio id="tabBarTopAbove" value="topabove" data-l10n-id="tab-bar-top-above"/>
      <radio id="tabBarTopBelow" value="topbelow" data-l10n-id="tab-bar-top-below"/>
      <radio id="tabBarBottomAbove" value="bottomabove" data-l10n-id="tab-bar-bottom-above"/>
      <radio id="tabBarBottomBelow" value="bottombelow" data-l10n-id="tab-bar-bottom-below"/>
    </radiogroup>
  </vbox>

  <!-- Tab Feature preferences -->
  <label><html:h2 data-l10n-id="tab-feature-header"/></label>
  <vbox id="tabContextMenuSettingsContainer">
    <checkbox id="duplicateTab" preference="browser.tabs.duplicateTab" data-l10n-id="show-duplicate-tab"/>
    <checkbox id="copyUrl" preference="browser.tabs.copyurl" data-l10n-id="show-copy-url"/>
    <checkbox id="copyActiveTab" preference="browser.tabs.activetab" data-l10n-id="enable-copy-active-tab"/>
    <checkbox id="copyAllUrls" preference="browser.tabs.copyallurls" data-l10n-id="show-copy-all-urls"/>
  </vbox>

<!-- Additional Tab preferences -->
<label><html:h2 data-l10n-id="tab-additional-header"/></label>
<vbox id="tabAdditionalSettingsContainer">
  <checkbox id="pinnedTabIconOnly" preference="browser.tabs.pinnedIconOnly" data-l10n-id="pinned-icon-only"/>
  <checkbox id="openNewTabAtEnd" preference="browser.tabs.insertAfterCurrent" data-l10n-id="insert-after-current"/>
  <checkbox id="openRelatedNewTabAtEnd" preference="browser.tabs.insertRelatedAfterCurrent" data-l10n-id="insert-related-after-current"/>
</vbox>