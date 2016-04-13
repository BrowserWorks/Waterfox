// VERSION 1.2.6

this.migrate = {
	migratorBackstage: null,

	init: function() {
		this.migratePrefs();

		if(Services.vc.compare(Services.appinfo.version, "45.0a1") >= 0) {
			this.skipTabGroupsMigrator();
		}
	},

	uninit: function() {
		if(this.migratorBackstage) {
			this.migratorBackstage.TabGroupsMigrator = this.migratorBackstage._TabGroupsMigrator;
			delete this.migratorBackstage._TabGroupsMigrator;
		}
	},

	migratePrefs: function() {
		if(!Prefs.migratedPrefs) {
			if(Services.prefs.prefHasUserValue('browser.panorama.animate_zoom')) {
				Prefs.animateZoom = Services.prefs.getBoolPref('browser.panorama.animate_zoom');
			}
			if(Services.prefs.prefHasUserValue('browser.panorama.session_restore_enabled_once')) {
				Prefs.pageAutoChanged = Services.prefs.getBoolPref('browser.panorama.session_restore_enabled_once');
			}
			Prefs.migratedPrefs = true;
		}
	},

	// we need to wait until at least one window is finished loading, so that CustomizableUI knows what it's doing
	migrateWidget: function() {
		// try to place our widget in the same place where the native widget used to be
		if(!Prefs.migratedWidget) {
			for(let area of CustomizableUI.areas) {
				try {
					let ids = CustomizableUI.getWidgetIdsInArea(area);
					let position = ids.indexOf("tabview-button");
					if(position != -1) {
						CustomizableUI.addWidgetToArea(objName+'-tabview-button', area, position);
						break;
					}
				}
				catch(ex) { Cu.reportError(ex); }
			}
			Prefs.migratedWidget = true;
		}
	},

	skipTabGroupsMigrator: function() {
		try {
			this.migratorBackstage = Cu.import("resource:///modules/TabGroupsMigrator.jsm", {});
		}
		catch(ex) {
			// this will fail until bug 1221050 lands
			return;
		}

		this.migratorBackstage._TabGroupsMigrator = this.migratorBackstage.TabGroupsMigrator;
		this.migratorBackstage.TabGroupsMigrator = {
			// no-op the migration, we'll just keep using the same data in the add-on anyway
			migrate: function() {}
		};
	},

	onLoad: function(aWindow) {
		// we can use our add-on even in builds with Tab View still present, we just have to properly deinitialize it
		if(aWindow.TabView) {
			aWindow.TabView.uninit();
			aWindow.TabView._deck = null;

			if(aWindow.gTaskbarTabGroup) {
				aWindow.gTaskbarTabGroup.win.removeEventListener("tabviewshown", aWindow.gTaskbarTabGroup);
				aWindow.gTaskbarTabGroup.win.removeEventListener("tabviewhidden", aWindow.gTaskbarTabGroup);
			}

			aWindow._TabView = aWindow.TabView;
		}

		// compatibility shim, for other add-ons to interact with this object more closely to the original if needed
		aWindow.TabView = aWindow[objName].TabView;

		Modules.load('keysets');
	},

	onUnload: function(aWindow) {
		if(UNLOADED) {
			Modules.unload('keysets');
		}

		if(aWindow._TabView) {
			aWindow.TabView = aWindow._TabView;
			delete aWindow._TabView;

			aWindow.TabView.init();

			if(aWindow.gTaskbarTabGroup) {
				aWindow.gTaskbarTabGroup.win.addEventListener("tabviewshown", aWindow.gTaskbarTabGroup);
				aWindow.gTaskbarTabGroup.win.addEventListener("tabviewhidden", aWindow.gTaskbarTabGroup);
			}
		}
		else {
			delete aWindow.TabView;
		}
	}
};

Modules.LOADMODULE = function() {
	// disables native TabView command and hides native menus and buttons and stuff through CSS.
	// can be removed in Firefox 45 (once bug 1222490 lands)
	if(Services.vc.compare(Services.appinfo.version, "45.0a1") < 0) {
		Overlays.overlayURI('chrome://browser/content/browser.xul', 'migrate', migrate);
	}

	migrate.init();
};

Modules.UNLOADMODULE = function() {
	migrate.uninit();

	if(Services.vc.compare(Services.appinfo.version, "45.0a1") < 0) {
		Overlays.removeOverlayURI('chrome://browser/content/browser.xul', 'migrate');
	}
};
