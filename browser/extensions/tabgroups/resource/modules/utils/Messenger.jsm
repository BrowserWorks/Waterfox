// VERSION 1.5.4
Modules.UTILS = true;

// Messenger - 	Aid object to communicate with browser content scripts (e10s).
//		Important: this loads the defaults.js file into every browser window, so make sure that everything in it is wrapped in their own methods,
//		or that at least it won't fail when loaded like this.
// messageName(aMessage) - to ensure that all receivers respond to messages that come only from this add-on
//	aMessage - (message object) will return the message name stripped off the add-on's identifier; or (string) returns with the add-on identifier appended
// messageBrowser(aBrowser, aMessage, aData, aCPOW) - sends a message to content scripts of a browser
//	aBrowser - (xul element) the browser element to send the message to
//	aMessage - (string) message to send, will be sent as objName-aMessage
//	aData - (string) data to be passed along with the message; can be a JSON-serializable object
//	aCPOW - (object) an object, typically a xul element, that will be proxied to the content script
// messageWindow(aWindow, aMessage, aData, aCPOW) - sends a message to content scripts of all browsers in the provided window
//	aWindow - (obj) window of which all browsers should receive this message
//	see messageBrowser()
// messageAll(aMessage, aData, aCPOW) - sends a message to content scripts of all browsers in all windows
//	see messageBrowser()
// listenBrowser(aBrowser, aMessage, aListener) - registers a listener for messages sent from content scripts through this backbone's methods
//	aBrowser - (xul element) the browser element from which to listen to messages
//	aMessage - (string) message to listen for
//	aListener - (function) the listener that will respond to the message. Expects (message) as its only argument; see https://developer.mozilla.org/en-US/docs/The_message_manager
// unlistenBrowser(aBrowser, aMessage, aListener) - unregisters a listener for messages sent from content scripts
//	see listenBrowser()
// listenWindow(aWindow, aMessage, aListener) - registers a listener for messages sent from all browsers in the provided window
//	aWindow - (obj) window of which all browsers should be listened to
//	see listenBrowser()
// unlistenWindow(aWindow, aMessage, aListener) - unregisters a listener for messages sent from all browsers in the provided window
//	see listenWindow()
// listenAll(aMessage, aListener) - registers a listener for messages sent from all browsers open in all windows
//	see listenBrowser()
// unlistenAll(aMessage, aListener) - unregisters a listener for messages sent from all browsers open in all windows
//	see listenBrowser()
// loadInBrowser(aBrowser, aModule) - loads a module into the content script of the specified browser
//	aBrowser - (xul element) the browser element corresponding to the content script into which to load the module
//	aModule - (string) name of the module to load
// unloadFromBrowser(aBrowser, aModule) - unloads a module from a content script [undoes loadInBrowser()]
//	see loadInBrowser()
// loadInWindow(aWindow, aModule) - loads a module into all the content scripts of a specified window
//	aWindow - (xul element) navigator window of which all content scripts will have the module loaded into
//	see loadInBrowser()
// unloadFromWindow(aWindow, aModule) - unloads a module from all the content scripts of a window [undoes loadInWindow()]
//	see loadInWindow()
// loadInAll(aModule) - loads a module into all content scripts
//	see loadInBrowser()
// unloadFromAll(aModule) - unloads a module from all content scripts [undoes loadInAll()]
//	see loadInBrowser()
this.Messenger = {
	loadedInAll: new Set(),

	globalMM: Cc["@mozilla.org/globalmessagemanager;1"].getService(Ci.nsIMessageListenerManager),

	messageName: function(aMessage) {
		// when supplying a message object, we want to strip it of this add-on's unique identifier to get only the actual message
		if(aMessage.name) {
			if(aMessage.name.startsWith(objName+':')) {
				// +1 is for the ':' after objName
				return aMessage.name.substr(objName.length +1);
			}

			return aMessage.name;
		}

		// if supplying a string, we make sure it is appended with this add-on's unique identifier
		if(!aMessage.startsWith(objName+':')) {
			return objName+':'+aMessage;
		}

		// nothing to do, return as is
		return aMessage;
	},

	messageBrowser: function(aBrowser, aMessage, aData, aCPOW) {
		if(!aBrowser || !aBrowser.messageManager) { return; }

		aBrowser.messageManager.sendAsyncMessage(this.messageName(aMessage), aData, aCPOW);
	},

	messageWindow: function(aWindow, aMessage, aData, aCPOW) {
		if(!aWindow || !aWindow.messageManager) { return; }

		aWindow.messageManager.broadcastAsyncMessage(this.messageName(aMessage), aData, aCPOW);
	},

	messageAll: function(aMessage, aData, aCPOW) {
		this.globalMM.broadcastAsyncMessage(this.messageName(aMessage), aData, aCPOW);
	},

	listenBrowser: function(aBrowser, aMessage, aListener) {
		if(!aBrowser || !aBrowser.messageManager) { return; }

		aBrowser.messageManager.addMessageListener(this.messageName(aMessage), aListener);
	},

	unlistenBrowser: function(aBrowser, aMessage, aListener) {
		if(!aBrowser || !aBrowser.messageManager) { return; }

		aBrowser.messageManager.removeMessageListener(this.messageName(aMessage), aListener);
	},

	listenWindow: function(aWindow, aMessage, aListener) {
		if(!aWindow || !aWindow.messageManager) { return; }

		aWindow.messageManager.addMessageListener(this.messageName(aMessage), aListener);
	},

	unlistenWindow: function(aWindow, aMessage, aListener) {
		if(!aWindow || !aWindow.messageManager) { return; }

		aWindow.messageManager.removeMessageListener(this.messageName(aMessage), aListener);
	},

	listenAll: function(aMessage, aListener) {
		this.globalMM.addMessageListener(this.messageName(aMessage), aListener);
	},

	unlistenAll: function(aMessage, aListener) {
		this.globalMM.removeMessageListener(this.messageName(aMessage), aListener);
	},

	loadInBrowser: function(aBrowser, aModule) {
		this.messageBrowser(aBrowser, 'load', aModule);
	},

	unloadFromBrowser: function(aBrowser, aModule) {
		this.messageBrowser(aBrowser, 'unload', aModule);
	},

	loadInWindow: function(aWindow, aModule) {
		if(aWindow.gBrowser && aWindow.gBrowser.tabContainer) {
			if(!aWindow.gBrowser.tabContainer[objName+'Content']) {
				aWindow.gBrowser.tabContainer[objName+'Content'] = {
					modules: new Set([aModule]),
					handleEvent: function(e) {
						Messenger.messageBrowser(e.target.linkedBrowser, 'reinit');
					}
				};
				aWindow.gBrowser.tabContainer.addEventListener('TabOpen', aWindow.gBrowser.tabContainer[objName+'Content'], true);
			}
			else if(!aWindow.gBrowser.tabContainer[objName+'Content'].modules.has(aModule)) {
				aWindow.gBrowser.tabContainer[objName+'Content'].modules.add(aModule);
			}
		}

		this.messageWindow(aWindow, 'load', aModule);
	},

	unloadFromWindow: function(aWindow, aModule) {
		if(aWindow.gBrowser && aWindow.gBrowser.tabContainer) {
			if(aWindow.gBrowser.tabContainer[objName+'Content'] && aWindow.gBrowser.tabContainer[objName+'Content'].modules.has(aModule)) {
				aWindow.gBrowser.tabContainer[objName+'Content'].modules.delete(aModule);
				if(aWindow.gBrowser.tabContainer[objName+'Content'].modules.size == 0) {
					aWindow.gBrowser.tabContainer.removeEventListener('TabOpen', aWindow.gBrowser.tabContainer[objName+'Content'], true);
					delete aWindow.gBrowser.tabContainer[objName+'Content'];
				}
			}
		}

		this.messageWindow(aWindow, 'unload', aModule);
	},

	loadInAll: function(aModule) {
		if(this.loadedInAll.has(aModule)) { return; }

		this.loadedInAll.add(aModule);
		this.messageAll('load', aModule);
	},

	unloadFromAll: function(aModule) {
		if(!this.loadedInAll.has(aModule)) { return; }

		this.loadedInAll.delete(aModule);
		this.messageAll('unload', aModule);
	},

	receiveMessage: function(m) {
		// if this is a preloaded browser, we don't need to load in it, the content script will still be loaded in the actual tab's browser
		if(m.target.parentNode.localName == 'window' && m.target.parentNode.id == 'win') { return; }

		// can't stringify AddonData directly, because it contains an nsIFile instance (installPath) and an nsIURI instance (resourceURI)
		var carryData = {
			AddonData: {
				id: AddonData.id,
				initTime: AddonData.initTime,
				version: AddonData.version,
				oldVersion: AddonData.oldVersion,
				newVersion: AddonData.newVersion
			},
			addonUris: addonUris,
			prefList: prefList
		};
		this.messageBrowser(m.target, 'init', carryData);

		// load into this browser all the content modules that should be loaded in all content scripts
		for(let module of this.loadedInAll) {
			this.messageBrowser(m.target, 'load', module);
		}

		// load into this browser all the content modules that should be loaded into content scripts of this window
		if(m.target.ownerGlobal.gBrowser && m.target.ownerGlobal.gBrowser.tabContainer && m.target.ownerGlobal.gBrowser.tabContainer[objName+'Content']) {
			for(let module of m.target.ownerGlobal.gBrowser.tabContainer[objName+'Content'].modules) {
				this.messageBrowser(m.target, 'load', module);
			}
		}

		// now we can load other individual modules that have been queued in the meantime (between window opening and content process finishing to initialize)
		this.messageBrowser(m.target, 'loadQueued');
	},

	cleanWindow: function(aWindow) {
		if(aWindow.gBrowser && aWindow.gBrowser.tabContainer && aWindow.gBrowser.tabContainer[objName+'Content']) {
			aWindow.gBrowser.tabContainer.removeEventListener('TabOpen', aWindow.gBrowser.tabContainer[objName+'Content'], true);
			delete aWindow.gBrowser.tabContainer[objName+'Content'];
		}
	}
};

Modules.LOADMODULE = function() {
	MessengerLoaded = true;

	Messenger.listenAll('init', Messenger);
	Messenger.globalMM.loadFrameScript('resource://'+objPathString+'/defaultsContent.js?'+AddonData.initTime, true);
};

Modules.UNLOADMODULE = function() {
	Messenger.unlistenAll('init', Messenger);

	Windows.callOnAll(Messenger.cleanWindow, 'navigator:browser');

	Messenger.globalMM.removeDelayedFrameScript('resource://'+objPathString+'/defaultsContent.js?'+AddonData.initTime);
	Messenger.messageAll('shutdown');
};
