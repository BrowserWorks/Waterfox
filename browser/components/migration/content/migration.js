/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

const kIMig = Ci.nsIBrowserProfileMigrator;
const kIPStartup = Ci.nsIProfileStartup;

const { Services } = ChromeUtils.import("resource://gre/modules/Services.jsm");
const { MigrationUtils } = ChromeUtils.import(
  "resource:///modules/MigrationUtils.jsm"
);

var MigrationWizard = {
  /* exported MigrationWizard */
  _source: "", // Source Profile Migrator ContractID suffix
  _itemsFlags: kIMig.ALL, // Selected Import Data Sources (16-bit bitfield)
  _selectedProfile: null, // Selected Profile name to import from
  _wiz: null,
  _migrator: null,
  _autoMigrate: null,

  init() {
    let os = Services.obs;
    os.addObserver(this, "Migration:Started");
    os.addObserver(this, "Migration:ItemBeforeMigrate");
    os.addObserver(this, "Migration:ItemAfterMigrate");
    os.addObserver(this, "Migration:ItemError");
    os.addObserver(this, "Migration:Ended");

    this._wiz = document.querySelector("wizard");

    let args = window.arguments;
    let entryPointId = args[0] || MigrationUtils.MIGRATION_ENTRYPOINT_UNKNOWN;
    Services.telemetry
      .getHistogramById("FX_MIGRATION_ENTRY_POINT")
      .add(entryPointId);
    this.isInitialMigration =
      entryPointId == MigrationUtils.MIGRATION_ENTRYPOINT_FIRSTRUN;

    {
      // Record that the uninstaller requested a profile refresh
      let env = Cc["@mozilla.org/process/environment;1"].getService(
        Ci.nsIEnvironment
      );
      if (env.get("MOZ_UNINSTALLER_PROFILE_REFRESH")) {
        env.set("MOZ_UNINSTALLER_PROFILE_REFRESH", "");
        Services.telemetry.scalarSet(
          "migration.uninstaller_profile_refresh",
          true
        );
      }
    }

    if (args.length == 2) {
      this._source = args[1];
    } else if (args.length > 2) {
      this._source = args[1];
      this._migrator = args[2] instanceof kIMig ? args[2] : null;
      this._autoMigrate = args[3].QueryInterface(kIPStartup);
      this._skipImportSourcePage = args[4];
      if (this._migrator && args[5]) {
        let sourceProfiles = this.spinResolve(
          this._migrator.getSourceProfiles()
        );
        this._selectedProfile = sourceProfiles.find(
          profile => profile.id == args[5]
        );
      }

      if (this._autoMigrate) {
        // Show the "nothing" option in the automigrate case to provide an
        // easily identifiable way to avoid migration and create a new profile.
        document.getElementById("nothing").hidden = false;
      }
    }

    document.addEventListener("wizardcancel", function() {
      MigrationWizard.onWizardCancel();
    });

    document
      .getElementById("selectProfile")
      .addEventListener("pageshow", function() {
        MigrationWizard.onSelectProfilePageShow();
      });
    document
      .getElementById("importItems")
      .addEventListener("pageshow", function() {
        MigrationWizard.onImportItemsPageShow();
      });
    document
      .getElementById("migrating")
      .addEventListener("pageshow", function() {
        MigrationWizard.onMigratingPageShow();
      });
    document.getElementById("done").addEventListener("pageshow", function() {
      MigrationWizard.onDonePageShow();
    });

    document
      .getElementById("selectProfile")
      .addEventListener("pagerewound", function() {
        MigrationWizard.onSelectProfilePageRewound();
      });
    document
      .getElementById("importItems")
      .addEventListener("pagerewound", function() {
        MigrationWizard.onImportItemsPageRewound();
      });

    document
      .getElementById("selectProfile")
      .addEventListener("pageadvanced", function() {
        MigrationWizard.onSelectProfilePageAdvanced();
      });
    document
      .getElementById("importItems")
      .addEventListener("pageadvanced", function() {
        MigrationWizard.onImportItemsPageAdvanced();
      });
    document
      .getElementById("importSource")
      .addEventListener("pageadvanced", function(e) {
        MigrationWizard.onImportSourcePageAdvanced(e);
      });

    this.onImportSourcePageShow();
  },

  uninit() {
    var os = Services.obs;
    os.removeObserver(this, "Migration:Started");
    os.removeObserver(this, "Migration:ItemBeforeMigrate");
    os.removeObserver(this, "Migration:ItemAfterMigrate");
    os.removeObserver(this, "Migration:ItemError");
    os.removeObserver(this, "Migration:Ended");
    MigrationUtils.finishMigration();
  },

  spinResolve(promise) {
    let canAdvance = this._wiz.canAdvance;
    let canRewind = this._wiz.canRewind;
    this._wiz.canAdvance = false;
    this._wiz.canRewind = false;
    let result = MigrationUtils.spinResolve(promise);
    this._wiz.canAdvance = canAdvance;
    this._wiz.canRewind = canRewind;
    return result;
  },

  onWizardCancel() {
    MigrationUtils.forceExitSpinResolve();
    return true;
  },

  // 1 - Import Source
  onImportSourcePageShow() {
    // Show warning message to close the selected browser when needed
    let toggleCloseBrowserWarning = () => {
      let visibility = "hidden";
      if (group.selectedItem.id != "nothing") {
        let migrator = this.spinResolve(
          MigrationUtils.getMigrator(group.selectedItem.id)
        );
        visibility = migrator.sourceLocked ? "visible" : "hidden";
      }
      document.getElementById(
        "closeSourceBrowser"
      ).style.visibility = visibility;
    };
    this._wiz.canRewind = false;

    var selectedMigrator = null;
    this._availableMigrators = [];

    // Figure out what source apps are are available to import from:
    var group = document.getElementById("importSourceGroup");
    debugger;
    for (var i = 0; i < group.childNodes.length; ++i) {
      var migratorKey = group.childNodes[i].id;
      if (migratorKey != "nothing") {
        var migrator = this.spinResolve(
          MigrationUtils.getMigrator(migratorKey)
        );
        if (migrator) {
          // Save this as the first selectable item, if we don't already have
          // one, or if it is the migrator that was passed to us.
          if (!selectedMigrator || this._source == migratorKey) {
            selectedMigrator = group.childNodes[i];
          }
          this._availableMigrators.push([migratorKey, migrator]);
        } else {
          // Hide this option
          group.childNodes[i].hidden = true;
        }
      }
    }
    if (this.isInitialMigration) {
      Services.telemetry
        .getHistogramById("FX_STARTUP_MIGRATION_BROWSER_COUNT")
        .add(this._availableMigrators.length);
      let defaultBrowser = MigrationUtils.getMigratorKeyForDefaultBrowser();
      // This will record 0 for unknown default browser IDs.
      defaultBrowser = MigrationUtils.getSourceIdForTelemetry(defaultBrowser);
      Services.telemetry
        .getHistogramById("FX_STARTUP_MIGRATION_EXISTING_DEFAULT_BROWSER")
        .add(defaultBrowser);
    }

    group.addEventListener("command", toggleCloseBrowserWarning);

    if (selectedMigrator) {
      group.selectedItem = selectedMigrator;
      toggleCloseBrowserWarning();
    } else {
      // We didn't find a migrator, notify the user
      document.getElementById("noSources").hidden = false;

      this._wiz.canAdvance = false;

      document.getElementById("importAll").hidden = true;
    }

    // Advance to the next page if the caller told us to.
    if (this._migrator && this._skipImportSourcePage) {
      this._wiz.advance();
      this._wiz.canRewind = false;
    }
  },

  onImportSourcePageAdvanced(event) {
    var newSource = document.getElementById("importSourceGroup").selectedItem
      .id;

    if (newSource == "nothing") {
      // Need to do telemetry here because we're closing the dialog before we get to
      // do actual migration. For actual migration, this doesn't happen until after
      // migration takes place.
      Services.telemetry
        .getHistogramById("FX_MIGRATION_SOURCE_BROWSER")
        .add(MigrationUtils.getSourceIdForTelemetry("nothing"));
      this._wiz.cancel();
      event.preventDefault();
    }

    if (!this._migrator || newSource != this._source) {
      // Create the migrator for the selected source.
      this._migrator = this.spinResolve(MigrationUtils.getMigrator(newSource));

      this._itemsFlags = kIMig.ALL;
      this._selectedProfile = null;
    }
    this._source = newSource;

    // check for more than one source profile
    var sourceProfiles = this.spinResolve(this._migrator.getSourceProfiles());
    if (this._skipImportSourcePage) {
      this._wiz.currentPage.next = "migrating";
    } else if (sourceProfiles && sourceProfiles.length > 1) {
      this._wiz.currentPage.next = "selectProfile";
    } else {
      if (this._autoMigrate) {
        this._wiz.currentPage.next = "migrating";
      } else {
        this._wiz.currentPage.next = "importItems";
      }

      if (sourceProfiles && sourceProfiles.length == 1) {
        this._selectedProfile = sourceProfiles[0];
      } else {
        this._selectedProfile = null;
      }
    }
  },

  // 2 - [Profile Selection]
  onSelectProfilePageShow() {
    // Disabling this for now, since we ask about import sources in automigration
    // too and don't want to disable the back button
    // if (this._autoMigrate)
    //   document.documentElement.getButton("back").disabled = true;

    var profiles = document.getElementById("profiles");
    while (profiles.hasChildNodes()) {
      profiles.firstChild.remove();
    }

    // Note that this block is still reached even if the user chose 'From File'
    // and we canceled the dialog.  When that happens, _migrator will be null.
    if (this._migrator) {
      var sourceProfiles = this.spinResolve(this._migrator.getSourceProfiles());

      for (let profile of sourceProfiles) {
        var item = document.createXULElement("radio");
        item.id = profile.id;
        item.setAttribute("label", profile.name);
        profiles.appendChild(item);
      }
    }

    profiles.selectedItem = this._selectedProfile
      ? document.getElementById(this._selectedProfile.id)
      : profiles.firstChild;
  },

  onSelectProfilePageRewound() {
    var profiles = document.getElementById("profiles");
    let sourceProfiles = this.spinResolve(this._migrator.getSourceProfiles());
    this._selectedProfile =
      sourceProfiles.find(profile => profile.id == profiles.selectedItem.id) ||
      null;
  },

  onSelectProfilePageAdvanced() {
    var profiles = document.getElementById("profiles");
    let sourceProfiles = this.spinResolve(this._migrator.getSourceProfiles());
    this._selectedProfile =
      sourceProfiles.find(profile => profile.id == profiles.selectedItem.id) ||
      null;

    // If we're automigrating or just doing bookmarks don't show the item selection page
    if (this._autoMigrate) {
      this._wiz.currentPage.next = "migrating";
    }
  },

  // 3 - ImportItems
  onImportItemsPageShow() {
    var dataSources = document.getElementById("dataSources");
    while (dataSources.hasChildNodes()) {
      dataSources.firstChild.remove();
    }

    var items = this.spinResolve(
      this._migrator.getMigrateData(this._selectedProfile, this._autoMigrate)
    );
    for (var i = 0; i < 16; ++i) {
      var itemID = (items >> i) & 0x1 ? Math.pow(2, i) : 0;
      if (itemID > 0) {
        var checkbox = document.createXULElement("checkbox");
        checkbox.id = itemID;
        checkbox.setAttribute(
          "label",
          MigrationUtils.getLocalizedString(itemID + "_" + this._source)
        );
        dataSources.appendChild(checkbox);
        if (!this._itemsFlags || this._itemsFlags & itemID) {
          checkbox.checked = true;
        }
      }
    }
  },

  onImportItemsPageRewound() {
    this._wiz.canAdvance = true;
    this.onImportItemsPageAdvanced();
  },

  onImportItemsPageAdvanced() {
    var dataSources = document.getElementById("dataSources");
    this._itemsFlags = 0;
    for (var i = 0; i < dataSources.childNodes.length; ++i) {
      var checkbox = dataSources.childNodes[i];
      if (checkbox.localName == "checkbox" && checkbox.checked) {
        this._itemsFlags |= parseInt(checkbox.id);
      }
    }
  },

  onImportItemCommand() {
    var items = document.getElementById("dataSources");
    var checkboxes = items.getElementsByTagName("checkbox");

    var oneChecked = false;
    for (var i = 0; i < checkboxes.length; ++i) {
      if (checkboxes[i].checked) {
        oneChecked = true;
        break;
      }
    }

    this._wiz.canAdvance = oneChecked;
  },

  // 4 - Migrating
  onMigratingPageShow() {
    this._wiz.getButton("cancel").disabled = true;
    this._wiz.canRewind = false;
    this._wiz.canAdvance = false;

    // When automigrating, show all of the data that can be received from this source.
    if (this._autoMigrate) {
      this._itemsFlags = this.spinResolve(
        this._migrator.getMigrateData(this._selectedProfile, this._autoMigrate)
      );
    }

    this._listItems("migratingItems");
    setTimeout(() => this.onMigratingMigrate(), 0);
  },

  async onMigratingMigrate() {
    await this._migrator.migrate(
      this._itemsFlags,
      this._autoMigrate,
      this._selectedProfile
    );

    Services.telemetry
      .getHistogramById("FX_MIGRATION_SOURCE_BROWSER")
      .add(MigrationUtils.getSourceIdForTelemetry(this._source));
    if (!this._autoMigrate) {
      let hist = Services.telemetry.getKeyedHistogramById("FX_MIGRATION_USAGE");
      let exp = 0;
      let items = this._itemsFlags;
      while (items) {
        if (items & 1) {
          hist.add(this._source, exp);
        }
        items = items >> 1;
        exp++;
      }
    }
  },

  _listItems(aID) {
    var items = document.getElementById(aID);
    while (items.hasChildNodes()) {
      items.firstChild.remove();
    }

    var itemID;
    for (var i = 0; i < 16; ++i) {
      itemID = (this._itemsFlags >> i) & 0x1 ? Math.pow(2, i) : 0;
      if (itemID > 0) {
        var label = document.createXULElement("label");
        label.id = itemID + "_migrated";
        try {
          label.setAttribute(
            "value",
            MigrationUtils.getLocalizedString(itemID + "_" + this._source)
          );
          items.appendChild(label);
        } catch (e) {
          // if the block above throws, we've enumerated all the import data types we
          // currently support and are now just wasting time, break.
          break;
        }
      }
    }
  },

  observe(aSubject, aTopic, aData) {
    var label;
    switch (aTopic) {
      case "Migration:Started":
        break;
      case "Migration:ItemBeforeMigrate":
        label = document.getElementById(aData + "_migrated");
        if (label) {
          label.setAttribute("style", "font-weight: bold");
        }
        break;
      case "Migration:ItemAfterMigrate":
        label = document.getElementById(aData + "_migrated");
        if (label) {
          label.removeAttribute("style");
        }
        break;
      case "Migration:Ended":
        if (this.isInitialMigration) {
          // Ensure errors in reporting data recency do not affect the rest of the migration.
          try {
            this.reportDataRecencyTelemetry();
          } catch (ex) {
            Cu.reportError(ex);
          }
        }
        if (this._autoMigrate) {
          // We're done now.
          this._wiz.canAdvance = true;
          this._wiz.advance();

          setTimeout(close, 5000);
        } else {
          this._wiz.canAdvance = true;
          var nextButton = this._wiz.getButton("next");
          nextButton.click();
        }
        break;
      case "Migration:ItemError":
        let type = "undefined";
        let numericType = parseInt(aData);
        switch (numericType) {
          case Ci.nsIBrowserProfileMigrator.SETTINGS:
            type = "settings";
            break;
          case Ci.nsIBrowserProfileMigrator.COOKIES:
            type = "cookies";
            break;
          case Ci.nsIBrowserProfileMigrator.HISTORY:
            type = "history";
            break;
          case Ci.nsIBrowserProfileMigrator.FORMDATA:
            type = "form data";
            break;
          case Ci.nsIBrowserProfileMigrator.PASSWORDS:
            type = "passwords";
            break;
          case Ci.nsIBrowserProfileMigrator.BOOKMARKS:
            type = "bookmarks";
            break;
          case Ci.nsIBrowserProfileMigrator.OTHERDATA:
            type = "misc. data";
            break;
        }
        Services.console.logStringMessage(
          "some " + type + " did not successfully migrate."
        );
        Services.telemetry
          .getKeyedHistogramById("FX_MIGRATION_ERRORS")
          .add(this._source, Math.log2(numericType));
        break;
    }
  },

  onDonePageShow() {
    this._wiz.getButton("cancel").disabled = true;
    this._wiz.canRewind = false;
    this._listItems("doneItems");
  },

  reportDataRecencyTelemetry() {
    let histogram = Services.telemetry.getKeyedHistogramById(
      "FX_STARTUP_MIGRATION_DATA_RECENCY"
    );
    let lastUsedPromises = [];
    for (let [key, migrator] of this._availableMigrators) {
      // No block-scoped let in for...of loop conditions, so get the source:
      let localKey = key;
      lastUsedPromises.push(
        migrator.getLastUsedDate().then(date => {
          const ONE_YEAR = 24 * 365;
          let diffInHours = Math.round((Date.now() - date) / (60 * 60 * 1000));
          if (diffInHours > ONE_YEAR) {
            diffInHours = ONE_YEAR;
          }
          histogram.add(localKey, diffInHours);
          return [localKey, diffInHours];
        })
      );
    }
    Promise.all(lastUsedPromises).then(migratorUsedTimeDiff => {
      // Sort low to high.
      migratorUsedTimeDiff.sort(
        ([keyA, diffA], [keyB, diffB]) => diffA - diffB
      ); /* eslint no-unused-vars: off */
      let usedMostRecentBrowser =
        migratorUsedTimeDiff.length &&
        this._source == migratorUsedTimeDiff[0][0];
      let usedRecentBrowser = Services.telemetry.getKeyedHistogramById(
        "FX_STARTUP_MIGRATION_USED_RECENT_BROWSER"
      );
      usedRecentBrowser.add(this._source, usedMostRecentBrowser);
    });
  },
};
