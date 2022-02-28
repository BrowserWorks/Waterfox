<!-- Dynamic Theme preferences -->
  <groupbox id="dynamicThemeGroup" data-category="paneGeneral" hidden="true">
    <label>
      <html:h2 data-l10n-id="dynamic-theme-header" />
    </label>
    <radiogroup id="dynamicThemeRadioGroup">
      <radio value="1"
             data-l10n-id="dynamic-theme-dark"/>
      <radio value="0"
             data-l10n-id="dynamic-theme-light"/>
      <radio value="-1"
             data-l10n-id="dynamic-theme-auto"/>
    </radiogroup>
  </groupbox>

<!-- Restart Menu Item preferences -->
  <groupbox id="restartGroup" data-category="paneGeneral" hidden="true">
    <label>
      <html:h2 data-l10n-id="restart-header" />
    </label>
    <checkbox id="browser.restart_menu.showpanelmenubtn" data-l10n-id="restart-show-button"
      preference="browser.restart_menu.showpanelmenubtn" />
    <checkbox id="browser.restart_menu.purgecache" data-l10n-id="restart-purge-cache"
      preference="browser.restart_menu.purgecache" />
    <checkbox id="browser.restart_menu.requireconfirm" data-l10n-id="restart-require-confirmation"
      preference="browser.restart_menu.requireconfirm" />
  </groupbox>

  <!-- Status Bar preferences -->
  <groupbox id="statusBarGroup" data-category="paneGeneral" hidden="true">
    <label>
      <html:h2 data-l10n-id="statusbar-header" />
    </label>
    <vbox id="statusBarContainer">
      <checkbox id="showStatusBar" preference="browser.statusbar.enabled" data-l10n-id="statusbar-enabled" />
      <checkbox id="showStatusLinks" preference="browser.statusbar.appendStatusText" data-l10n-id="statusbar-show-links" />
      <checkbox id="contrastStatusText" preference="browser.statusbar.contrastText" data-l10n-id="statusbar-contrast-text" />
    </vbox>
  </groupbox>

  <!-- Bookmarks Toolbar Position preferences -->
<groupbox id="bookmarksBarPositionGroup"
          data-category="paneGeneral"
          hidden="true">
  <label><html:h2 data-l10n-id="bookmarks-bar-position-header"/></label>
    <radiogroup id="bookmarksBarPositionRadioGroup" preference="browser.bookmarks.toolbarposition">
      <radio value="top"
             data-l10n-id="bookmarks-position-top"/>
      <radio value="bottom"
             data-l10n-id="bookmarks-position-bottom"/>
    </radiogroup>
</groupbox>