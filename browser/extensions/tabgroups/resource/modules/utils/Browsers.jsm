// VERSION 2.5.1
Modules.UTILS = true;

// Browsers - Aid object to track and perform tasks on all document browsers across the windows.
// callOnAll(aCallback, aURI, beforeComplete, onlyTabs) - goes through every opened browser (tabs and sidebar) and executes aCallback on it
//	Important note: this method will no-op in remote browsers (e10s, anything not about: or chrome://).
//	aCallback - (function(aBrowser)) to be called on aBrowser
//	(optional) aURI - (string) when defined, checks the documentURI property against the aURI value and only executes aCallback when true, defaults to null
//	(optional) beforeComplete - 	true calls aCallback immediatelly regardless of readyState, false fires aCallback when window loads if readyState != complete, defaults to false
//					see notes on Windows.register()
//	(optional) onlyTabs - (bool) true only executes aCallback on actual tabs, not sidebars or others, defaults to (bool) false
// callOnBrowser(aBrowser, aCallback, aURI, beforeComplete) - executes aCallback on a specific browser's content window; mostly for internal use by callOnAll().
//	aBrowser - (xul element) on which to execute aCallback
//	see callOnAll()
// register(aHandler, aTopic, aURI, beforeComplete) - registers aHandler to be notified of every aTopic
//	Important note: handlers will no-op in remote browsers (e10s).
//	aHandler - (function(aWindow)) handler to be fired. Or (nsiObserver object) with observe() method which will be passed aWindow and aTopic as its only two arguments.
//	aTopic - (string) "pageshow" or (string) "pagehide" or (string) "SidebarFocused" or (string) "SidebarUnloaded"
//	see callOnAll()
// unregister(aHandler, aTopic, aURI, beforeComplete) - unregisters aHandler from being notified of every aTopic
//	see register()
// watching(aHandler, aTopic, aURI, beforeComplete) -	returns (int) with corresponding watcher index in watchers[] if aHandler has been registered for aTopic,
//							returns (bool) false otherwise
//	see register()
this.Browsers = {
	watchers: [],

	// expects aCallback() and sets its this as the window
	callOnAll: function(aCallback, aURI, beforeComplete, onlyTabs) {
		var browserEnumerator = Services.wm.getEnumerator('navigator:browser');
		while(browserEnumerator.hasMoreElements()) {
			let aWindow = browserEnumerator.getNext();
			if(aWindow.gBrowser) {
				// Browser panels (tabs)
				for(let aBrowser of aWindow.gBrowser.browsers) {
					this.callOnBrowser(aBrowser, aCallback, aURI, beforeComplete);
				}
			}

			if(onlyTabs) { continue; }

			// Sidebars are browser elements too
			for(let sidebar of this.getSidebars(aWindow)) {
				this.callOnBrowser(sidebar, aCallback, aURI, beforeComplete);
			}
		}
	},

	callOnBrowser: function(aBrowser, aCallback, aURI, beforeComplete) {
		// safeguard
		if(!aBrowser) { return; }

		// e10s fix, we don't check remote tabs
		if(aBrowser.isRemoteBrowser) { return; }

		if(aBrowser && aBrowser.docShell && aBrowser.contentWindow
		&& (!aURI || aBrowser.contentDocument.documentURI.startsWith(aURI))) {
			callOnLoad(aBrowser.contentWindow, aCallback, beforeComplete);
		}
	},

	register: function(aHandler, aTopic, aURI, beforeComplete) {
		if(this.watching(aHandler, aTopic) === false) {
			this.watchers.push({
				handler: aHandler,
				topic: aTopic,
				uri: aURI || null,
				beforeComplete: beforeComplete || false
			});
		}
	},

	unregister: function(aHandler, aTopic, aURI, beforeComplete) {
		var i = this.watching(aHandler, aTopic, aURI, beforeComplete);
		if(i !== false) {
			this.watchers.splice(i, 1);
		}
	},

	watching: function(aHandler, aTopic, aURI, beforeComplete) {
		var uri = aURI || null;
		var before = beforeComplete || false;

		for(var i = 0; i < this.watchers.length; i++) {
			if(this.watchers[i].handler == aHandler
			&& this.watchers[i].topic == aTopic
			&& this.watchers[i].uri == uri
			&& this.watchers[i].beforeComplete == before) {
				return i;
			}
		}
		return false;
	},

	observe: function(aWindow, aTopic) {
		switch(aTopic) {
			case 'domwindowopened':
				callOnLoad(aWindow, () => {
					if(aWindow.gBrowser) {
						for(let tab of aWindow.gBrowser.mTabs) {
							this.handleEvent({ type: 'TabOpen', target: tab });
						}
						// The event can be TabOpen, TabClose, TabSelect, TabShow, TabHide, TabPinned, TabUnpinned and possibly more.
						aWindow.gBrowser.tabContainer.addEventListener('TabOpen', this, true);
						aWindow.gBrowser.tabContainer.addEventListener('TabClose', this, true);
					}

					if(aWindow.SidebarUI) {
						// Also listen for the sidebars being loaded
						aWindow.addEventListener('SidebarFocused', this, true);

						// any already loaded sidebars must have the unload listener setup as well
						for(let sidebar of this.getSidebars(aWindow)) {
							if(sidebar && sidebar.docShell && sidebar.contentWindow && sidebar.contentDocument.documentURI != 'about:blank') {
								this.watchSidebarUnload(sidebar.contentWindow);
							}
						}
					}
				});
				break;

			case 'domwindowclosed':
				if(aWindow.document.readyState == 'complete') {
					if(aWindow.gBrowser) {
						for(let tab of aWindow.gBrowser.mTabs) {
							tab.removeEventListener('TabRemotenessChange', this);
							if(!tab.linkedBrowser.isRemoteBrowser) {
								this.tabRemote(tab); // this removes the listeners, which is what we want to do
							}
						}
						aWindow.gBrowser.tabContainer.removeEventListener('TabOpen', this, true);
						aWindow.gBrowser.tabContainer.removeEventListener('TabClose', this, true);
					}

					if(aWindow.SidebarUI) {
						aWindow.removeEventListener('SidebarFocused', this, true);
						for(let sidebar of this.getSidebars(aWindow)) {
							if(sidebar && sidebar.docShell && sidebar.contentWindow && sidebar.contentDocument.documentURI != 'about:blank') {
								sidebar.contentWindow.removeEventListener('unload', this);
							}
						}
					}
				}
				break;
		}
	},

	handleEvent: function(e) {
		switch(e.type) {
			case 'TabOpen':
				e.target.addEventListener('TabRemotenessChange', this);
				// no break; let it run TabRemotenessChange

			case 'TabRemotenessChange':
				if(e.target.linkedBrowser.isRemoteBrowser) {
					this.tabRemote(e.target);
				} else {
					this.tabNonRemote(e.target);
				}
				break;

			case 'TabClose':
				e.target.removeEventListener('TabRemotenessChange', this);

				// e10s fix, we don't check remote tabs, we only check about: and chrome:// tabs
				if(e.target.linkedBrowser.isRemoteBrowser) { break; }

				this.tabRemote(e.target); // this removes the listeners, which is what we want to do
				this.callWatchers(e.target.linkedBrowser.contentDocument, 'pagehide');
				break;

			case 'SidebarFocused':
				// we need to know when this sidebar will be unloaded as well
				this.watchSidebarUnload(e.target);
				this.callWatchers(e.target.document, e.type);
				break;

			case 'unload': // sidebar unloaded/closed
				// pass a different event type to watchers, as "unload" is too generalized and could conflict with other listeners that want actual unload events
				this.callWatchers(e.target, 'SidebarUnloaded');
				break;

			default:
				this.callWatchers(e.originalTarget, e.type);
				break;
		}
	},

	getSidebars: function*(aWindow) {
		if(aWindow.SidebarUI) {
			// compatibility with OmniSidebar
			if(aWindow.SidebarUI.browsers) {
				for(let browser of aWindow.SidebarUI.browsers()) {
					if(!browser) { continue; }
					yield browser;
				}
			}
			else if(aWindow.SidebarUI.browser) {
				yield aWindow.SidebarUI.browser;
			}
		}
	},

	callWatchers: function(aDoc, aTopic) {
		if(aDoc.nodeName != '#document') { return; }

		var aSubject = aDoc.defaultView;
		for(let watcher of this.watchers) {
			if(watcher.topic == aTopic
			&& (!watcher.uri || aSubject.document.documentURI.startsWith(watcher.uri))) {
				if(watcher.handler.observe) {
					// we need to make sure that we're calling the right watcher (and thus actually call all watchers),
					// otherwise the for loop can continue and watcher changes inside the function itself after it's been sent to callOnLoad
					(function() {
						var actualWatcher = watcher;
						callOnLoad(aSubject, () => {
							actualWatcher.handler.observe(aSubject, aTopic);
						}, actualWatcher.beforeComplete);
					})();
				} else {
					callOnLoad(aSubject, watcher.handler, watcher.beforeComplete);
				}
			}
		}
	},

	tabNonRemote: function(tab) {
		// The event can be DOMContentLoaded, pageshow, pagehide, load or unload. Don't use these in remote browsers as they use CPOWs to work there.
		// These seem to be enough
		tab.linkedBrowser.addEventListener('pageshow', this, true);
		tab.linkedBrowser.addEventListener('pagehide', this, true);
	},

	tabRemote: function(tab) {
		tab.linkedBrowser.removeEventListener('pageshow', this, true);
		tab.linkedBrowser.removeEventListener('pagehide', this, true);
	},

	watchSidebarUnload: function(aWindow) {
		callOnLoad(aWindow, () => {
			aWindow.addEventListener('unload', this);
		});
	}
};

Modules.LOADMODULE = function() {
	Windows.callOnAll((aWindow) => {
		Browsers.observe(aWindow, 'domwindowopened');
	}, 'navigator:browser');

	Windows.register(Browsers, 'domwindowopened', 'navigator:browser');
	Windows.register(Browsers, 'domwindowclosed', 'navigator:browser');
};

Modules.UNLOADMODULE = function() {
	Windows.unregister(Browsers, 'domwindowopened', 'navigator:browser');
	Windows.unregister(Browsers, 'domwindowclosed', 'navigator:browser');

	Windows.callOnAll((aWindow) => {
		Browsers.observe(aWindow, 'domwindowclosed');
	}, 'navigator:browser', null, true);
};
