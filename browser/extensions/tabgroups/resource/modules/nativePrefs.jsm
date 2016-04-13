// VERSION 1.1.0

this.pageWatch = {
	TMP: false,
	listeners: new Set(),
	captureChanges: false,

	observe: function(aSubject, aTopic, aData) {
		this.shouldReset(aSubject, aTopic);
		this.callListeners(aSubject, aTopic, aData);
	},

	shouldReset: function(aSubject, aTopic) {
		switch(aSubject) {
			case "page":
				// the user changed this preference specifically, our backup is no longer valid
				if(!this.sessionRestoreEnabled) {
					Prefs.pageBackup = -1;
					this.stop();
					if(this.TMP && Prefs["sessions.manager"]) {
						this.start();
					}
				}
				break;

			case "sessions.onClose":
			case "sessions.onStart":
				// try to mimic from above as closely as possible
				if(!this.sessionRestoreEnabled) {
					Prefs.onCloseBackup = -1;
					Prefs.onStartBackup = -1;
					this.stop();
					if(!Prefs["sessions.manager"]) {
						this.start();
					}
				}
				break;

			case "sessions.manager":
				// we don't keep a backup for this, just check if we should start watching the other preferences
				this.start();
				break;
		}
	},

	callListeners: function(aSubject, aTopic, aData) {
		for(let l of this.listeners) {
			try {
				if(l.observe) {
					l.observe(aSubject, aTopic, aData);
				} else {
					l(aSubject, aTopic, aData);
				}
			}
			catch(ex) { Cu.reportError(ex); }
		}
	},

	register: function(aListener) {
		this.listeners.add(aListener);
	},

	unregister: function(aListener) {
		this.listeners.delete(aListener);
	},

	start: function() {
		this.captureChanges = (this.sessionRestoreEnabled && this.hasBackup);
	},

	stop: function() {
		this.captureChanges = false;
	},

	enableSessionRestore: function() {
		if(this.sessionRestoreEnabled) { return; }

		if(this.TMP && Prefs["sessions.manager"]) {
			Prefs.onCloseBackup = Prefs["sessions.onClose"];
			Prefs.onStartBackup = Prefs["sessions.onStart"];
			if(Prefs["sessions.onClose"] == 2) {
				Prefs["sessions.onClose"] = 0;
			}
			if(Prefs["sessions.onStart"] == 2) {
				Prefs["sessions.onStart"] = 0;
			}
		} else {
			Prefs.pageBackup = Prefs.page;
			Prefs.page = 3;
		}
		this.start();
	},

	get sessionRestoreEnabled() {
		if(this.TMP && Prefs["sessions.manager"]) {
			return Prefs["sessions.onClose"] != 2 && Prefs["sessions.onStart"] != 2;
		}
		return Prefs.page == 3;
	},

	get hasBackup() {
		if(this.TMP && Prefs["sessions.manager"]) {
			return Prefs.onCloseBackup != -1 && Prefs.onStartBackup != -1;
		}
		return Prefs.pageBackup != -1;
	},

	init: function() {
		Prefs.setDefaults({ pageBackup: -1 });
		Prefs.setDefaults({ page: 1 }, 'startup', 'browser');

		// Keep track of Tab Mix Plus session preferences as well
		AddonManager.getAddonByID('{dc572301-7619-498c-a57d-39143191b318}', (addon) => {
			if(addon && addon.isActive) {
				Prefs.setDefaults({
					onCloseBackup: -1,
					onStartBackup: -1
				});
				Prefs.setDefaults({
					["sessions.manager"]: true,
					["sessions.onClose"]: 0,
					["sessions.onStart"]: 2
				}, 'tabmix');
				Prefs.listen('sessions.manager', this);
				this.TMP = true;
			}
			this.finishInit();
		});
	},

	finishInit: function() {
		Prefs.listen('page', this);
		if(this.TMP) {
			Prefs.listen('sessions.onClose', this);
			Prefs.listen('sessions.onStart', this);
		}

		this.start();

		// nothing to do
		if(this.sessionRestoreEnabled || !this.hasBackup) { return; }

		// We have a backup, which means we have changed the preference, so make sure it stays changed!
		// (if the browser has been restarted in the meantime, it's probably too late to recover the previous session data already,
		// but this should never happen under normal circumstances)
		if(this.TMP && Prefs["sessions.manager"]) {
			if(Prefs["sessions.onClose"] == 2) {
				Prefs["sessions.onClose"] = 0;
			}
			if(Prefs["sessions.onStart"] == 2) {
				Prefs["sessions.onStart"] = 0;
			}
		} else {
			Prefs.page = 3;
		}
	},

	uninit: function() {
		this.stop();
		Prefs.unlisten('page', this);
		if(this.TMP) {
			Prefs.unlisten('sessions.onClose', this);
			Prefs.unlisten('sessions.onStart', this);
		}

		// is this even possible?
		if(!UNLOADED) { return; }

		// did we even change the pref ourselves?
		if(!this.hasBackup) { return; }

		// if the user has removed the add-on, we should restore the previous value if we changed it
		if(UNLOADED == ADDON_DISABLE || UNLOADED == ADDON_UNINSTALL) {
			if(this.TMP && Prefs["sessions.manager"]) {
				Prefs["sessions.onClose"] = Prefs.onCloseBackup;
				Prefs["sessions.onStart"] = Prefs.onStartBackup;
			} else {
				Prefs.page = Prefs.pageBackup;
			}
		}
	}
};

Modules.LOADMODULE = function() {
	pageWatch.init();
};

Modules.UNLOADMODULE = function() {
	pageWatch.uninit();
};
