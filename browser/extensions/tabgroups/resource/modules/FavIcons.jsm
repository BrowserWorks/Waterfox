// VERSION 1.0.1

this.FavIcons = {
	get defaultFavicon() {
		return this._favIconService.defaultFavicon.spec;
	},

	init: function() {
		XPCOMUtils.defineLazyServiceGetter(this, "_favIconService", "@mozilla.org/browser/favicon-service;1", "nsIFaviconService");
	},

	// Gets the "favicon link URI" for the given xul:tab, or null if unavailable.
	getFavIconUrlForTab: function(tab, callback) {
		this._isImageDocument(tab).then((isImageDoc) => {
			if(isImageDoc) {
				callback(tab.pinned ? tab.image : null);
			} else {
				this._getFavIconForNonImageDocument(tab, callback);
			}
		});
	},

	// Retrieves the favicon for a tab containing a non-image document.
	_getFavIconForNonImageDocument: function(tab, callback) {
		if(tab.image) {
			this._getFavIconFromTabImage(tab, callback);
		} else if(this._shouldLoadFavIcon(tab)) {
			this._getFavIconForHttpDocument(tab, callback);
		} else {
			callback(null);
		}
	},

	// Retrieves the favicon for tab with a tab image.
	_getFavIconFromTabImage: function(tab, callback) {
		let tabImage = gBrowser.getIcon(tab);

		// If the tab image's url starts with http(s), fetch icon from favicon service via the moz-anno protocol.
		if(/^https?:/.test(tabImage)) {
			let tabImageURI = gWindow.makeURI(tabImage);
			tabImage = this._favIconService.getFaviconLinkForIcon(tabImageURI).spec;
		}

		callback(tabImage);
	},

	// Retrieves the favicon for tab containg a http(s) document.
	_getFavIconForHttpDocument: function(tab, callback) {
		let {currentURI} = tab.linkedBrowser;
		this._favIconService.getFaviconURLForPage(currentURI, (uri) => {
			if(uri) {
				let icon = this._favIconService.getFaviconLinkForIcon(uri).spec;
				callback(icon);
			} else {
				callback(this.defaultFavicon);
			}
		});
	},

	// Checks whether an image is loaded into the given tab.
	_isImageDocument: function(tab, callback) {
		return new Promise(function(resolve, reject) {
			let repeat;

			let receiver = function(m) {
				if(repeat) {
					repeat.cancel();
				}
				Messenger.unlistenBrowser(tab.linkedBrowser, "isImageDocument", receiver);
				resolve(m.data);
			};
			Messenger.listenBrowser(tab.linkedBrowser, "isImageDocument", receiver);

			// sometimes on first open, we don't get a response right away because the message isn't actually sent, although I have no clue why...
			let ask = function() {
				Messenger.messageBrowser(tab.linkedBrowser, "isImageDocument");
				repeat = aSync(ask, 1000);
			};
			ask();
		});
	},

	// Checks whether fav icon should be loaded for a given tab.
	_shouldLoadFavIcon: function(tab) {
		// No need to load a favicon if the user doesn't want site or favicons.
		if(!Prefs.site_icons || !Prefs.favicons) {
			return false;
		}

		let uri = tab.linkedBrowser.currentURI;

		// Stop here if we don't have a valid nsIURI.
		if(!uri || !(uri instanceof Ci.nsIURI)) {
			return false;
		}

		// Load favicons for http(s) pages only.
		return uri.schemeIs("http") || uri.schemeIs("https");
	}
};

Modules.LOADMODULE = function() {
	Prefs.setDefaults({
		site_icons: true,
		favicons: true
	}, 'chrome', 'browser');
};
