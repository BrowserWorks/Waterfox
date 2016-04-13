// VERSION 3.2.2
Modules.UTILS = true;

// PrivateBrowsing - Aid object for private browsing mode
// get autoStarted - returns (bool) pb permanentPrivateBrowsing
// get inPrivateBrowing - returns (bool) isWindowPrivate(window) for this window
// isPrivate(aWindow) - returns (bool) whether the provided window is private
//	aWindow - (chromeWindow) window to check if is in private mode
// addWatcher(aWatcher) - prepares aWatcher to be used as a PB handler
//	aWatcher - (object) to register as a pb observer,
//		expects methods (all optional):
//			init: called when object is applied as a private browsing mode watcher
//			autoStarted: called when private browsing is enabled when the add-on was started with the application
//			addonEnabled: called when private browsing is enabled when the add-on wasn't started with the application
//			addonDisabled: called when private browsing is enabled when the add-on is disabled without quitting the application
//			onQuit: called when application is shutdown
//		if it doesn't have an observe method it is created
// removeWatcher(aWatcher) - removes aWatcher from handling PB sessions
//	see addWatcher()
this.PrivateBrowsing = {
	get autoStarted () { return PrivateBrowsingUtils.permanentPrivateBrowsing; },
	get inPrivateBrowsing () { return this.isPrivate(window); },

	isPrivate: function(aWindow) {
		return PrivateBrowsingUtils.isWindowPrivate(aWindow);
	},

	prepare: function(aWatcher) {
		if(!aWatcher.observe) {
			aWatcher.observe = function(aSubject, aTopic, aData) {
				try {
					if(aTopic == "quit-application" && this.onQuit) {
						this.onQuit();
					}
				}
				// write errors in the console only after it has been cleared
				catch(ex) { aSync(function() { Cu.reportError(ex); }); }
			};
		}
		if(!aWatcher.init) { aWatcher.init = null; }
		if(!aWatcher.autoStarted) { aWatcher.autoStarted = null; }
		if(!aWatcher.addonEnabled) { aWatcher.addonEnabled = null; }
		if(!aWatcher.addonDisabled) { aWatcher.addonDisabled = null; }
		if(!aWatcher.onQuit) { aWatcher.onQuit = null; }
	},

	addWatcher: function(aWatcher) {
		this.prepare(aWatcher);
		Observers.add(aWatcher, "quit-application");

		if(aWatcher.init) {
			try { aWatcher.init(); }
			catch(ex) { aSync(function() { Cu.reportError(ex); }); }
		}

		if(this.inPrivateBrowsing) {
			if(aWatcher.addonEnabled && STARTED != APP_STARTUP) {
				try { aWatcher.addonEnabled(); }
				catch(ex) { aSync(function() { Cu.reportError(ex); }); }
			} else if(aWatcher.autoStarted) {
				try { aWatcher.autoStarted(); }
				catch(ex) { aSync(function() { Cu.reportError(ex); }); }
			}
		}
	},

	removeWatcher: function(aWatcher) {
		if(aWatcher.addonDisabled && this.inPrivateBrowsing && UNLOADED && UNLOADED != APP_SHUTDOWN) {
			try { aWatcher.addonDisabled(); }
			catch(ex) { aSync(function() { Cu.reportError(ex); }); }
		}

		Observers.remove(aWatcher, "quit-application");
	}
};
