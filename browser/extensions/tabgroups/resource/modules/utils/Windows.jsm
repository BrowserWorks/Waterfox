// VERSION 2.4.1
Modules.UTILS = true;
Modules.BASEUTILS = true;

// Windows - Aid object to help with window tasks involving window-mediator and window-watcher
// getEnumerator(aType) - returns an nsISimpleEnumerator object with all windows of aType
//	(optional) aType - (string) window type to get, defaults to null (all)
// callOnMostRecent(aCallback, aType, aURI) - calls aCallback passing it the most recent window of aType as an argument. If successful it returns the return value of aCallback.
//	aCallback - (function(window)) to be called on window
//	(optional) aType - type of windows to execute aCallback on, defaults to null (all)
//	(optional) aURI - (string) when defined, checks the documentURI property against the aURI value and only executes aCallback when true, defaults to null
// callOnAll(aCallback, aType, aURI, beforeComplete) - goes through every opened browser window of aType and executes aCallback on it
//	(optional) beforeComplete - true calls aCallback immediatelly regardless of readyState, false fires aCallback when window loads if readyState != complete, defaults to false.
//	see callOnMostRecent()
// register(aHandler, aTopic, aType, aURI, beforeComplete) - registers aHandler to be notified of every aTopic
//	aHandler - (function(aWindow)) handler to be fired. Or (nsiObserver object) with observe() method which will be passed aWindow and aTopic as its only two arguments.
//	aTopic - (string) "domwindowopened" or (string) "domwindowclosed"
//	(optional) beforeComplete -	See callOnAll()
//					Note that regardless of this value, if you set aType, no callback will be performed before the window is loaded because the windowtype attribute
//					won't be loaded yet! In some cases even the URI might not be loaded either so there's no point in setting this at all.
//	see callOnMostRecent() and callOnAll()
// unregister(aHandler, aTopic, aType, aURI, beforeComplete) - unregisters aHandler from being notified of every aTopic
//	see register()
// watching(aHandler, aTopic, aType, aURI, beforeComplete) - 	returns (int) with corresponding watcher index in watchers[] if aHandler has been registered for aTopic
//								returns (bool) false otherwise
//	see register()
this.Windows = {
	watchers: [],

	getEnumerator: function(aType) {
		return Services.wm.getEnumerator(aType || null);
	},

	callOnMostRecent: function(aCallback, aType, aURI) {
		var type = aType || null;
		if(aURI) {
			var browserEnumerator = this.getEnumerator(type);
			while(browserEnumerator.hasMoreElements()) {
				var window = browserEnumerator.getNext();
				if(window.document.documentURI.startsWith(aURI) && window.document.readyState == 'complete') {
					return aCallback(window);
				}
			}
			return null;
		}

		var window = Services.wm.getMostRecentWindow(type);
		if(window) {
			return aCallback(window);
		}
		return null;
	},

	// expects aCallback() and sets its this as the window
	callOnAll: function(aCallback, aType, aURI, beforeComplete) {
		var browserEnumerator = this.getEnumerator(aType);
		while(browserEnumerator.hasMoreElements()) {
			var window = browserEnumerator.getNext();
			if(!aURI || window.document.documentURI.startsWith(aURI)) {
				callOnLoad(window, aCallback, beforeComplete);
			}
		}
	},

	register: function(aHandler, aTopic, aType, aURI, beforeComplete) {
		if(this.watching(aHandler, aTopic, aType, aURI, beforeComplete) === false) {
			this.watchers.push({
				handler: aHandler,
				topic: aTopic,
				type: aType || null,
				uri: aURI || null,
				beforeComplete: beforeComplete || false
			});
		}
	},

	unregister: function(aHandler, aTopic, aType, aURI, beforeComplete) {
		var i = this.watching(aHandler, aTopic, aType, aURI, beforeComplete);
		if(i !== false) {
			this.watchers.splice(i, 1);
		}
	},

	watching: function(aHandler, aTopic, aType, aURI, beforeComplete) {
		var type = aType || null;
		var uri = aURI || null;
		var before = beforeComplete || false;

		for(var i = 0; i < this.watchers.length; i++) {
			if(this.watchers[i].handler == aHandler
			&& this.watchers[i].topic == aTopic
			&& this.watchers[i].type == type
			&& this.watchers[i].uri == uri
			&& this.watchers[i].beforeComplete == before) {
				return i;
			}
		}
		return false;
	},

	observe: function(aSubject, aTopic, noBefore) {
		var scheduleOnLoad = false;

		for(let watcher of this.watchers) {
			// 'windowtype' attr is undefined until the window loads
			if(!noBefore && aSubject.document.readyState != 'complete' && watcher.type) {
				scheduleOnLoad = true;
			}

			if(watcher.topic == aTopic
			&& (!watcher.type || aSubject.document.documentElement.getAttribute('windowtype') == watcher.type)
			&& (!watcher.uri || aSubject.document.documentURI.startsWith(watcher.uri))) {
				if(noBefore) {
					// don't run this handler if it's been run before
					if(!watcher.beforeComplete) {
						if(watcher.handler.observe) {
							watcher.handler.observe(aSubject, aTopic);
						} else {
							watcher.handler(aSubject);
						}
					}
					continue;
				}

				if(aSubject.document.readyState == 'complete' || watcher.beforeComplete) {
					if(watcher.handler.observe) {
						watcher.handler.observe(aSubject, aTopic);
					} else {
						watcher.handler(aSubject);
					}
				}
			}
		}

		if(scheduleOnLoad) {
			callOnLoad(aSubject, (aWindow) => {
				this.observe(aWindow, aTopic, true);
			});
		}
	}
};

Modules.LOADMODULE = function() {
	Services.ww.registerNotification(Windows);
};

Modules.UNLOADMODULE = function() {
	Services.ww.unregisterNotification(Windows);
};
