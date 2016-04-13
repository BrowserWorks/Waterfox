// VERSION 1.0.7

this.__defineGetter__('gWindow', function() { return window.parent; });
this.__defineGetter__('gBrowser', function() { return gWindow.gBrowser; });
this.__defineGetter__('gTabView', function() { return gWindow[objName].TabView; });
this.__defineGetter__('gTabViewDeck', function() { return gWindow[objName].gTabViewDeck; });
this.__defineGetter__('gBrowserPanel', function() { return gWindow[objName].$("browser-panel"); });
this.__defineGetter__('gTabViewFrame', function() { return gTabView._iframe; });

this.TabView = {
	_browserBundle: null,

	get browserBundle() {
		if(!this._browserBundle) {
			this._browserBundle = Services.strings.createBundle("chrome://browser/locale/tabbrowser.properties");
		}
		return this._browserBundle;
	},

	// compatibility shims, for other add-ons to interact with this window more closely to the original if needed
	shims: [
		'Point', 'Rect', 'Range', 'Subscribable', 'Utils', 'MRUList',
		'iQ',
		'Item', 'Items',
		'GroupItem', 'GroupItems',
		'TabItem', 'TabItems', 'TabPriorityQueue', 'TabCanvas',
		'FavIcons',
		'drag', 'resize', 'Drag',
		'Trench', 'Trenches',
		'TabUtils', 'TabMatcher', 'TabHandlers', 'Search',
		'Keys', 'UI'
	]
};

Modules.LOADMODULE = function() {
	// compatibility shims, for other add-ons to interact with this window more closely to the original if needed
	for(let shim of TabView.shims) {
		let prop = shim;
		window.__defineGetter__(prop, function() { return self[prop]; });
	}

	// these objects are in the sandbox scope object, so the above loop won't fetch their shims properly
	window.__defineGetter__('Point', function() { return Point; });
	window.__defineGetter__('Rect', function() { return Rect; });
	window.__defineGetter__('Range', function() { return Range; });
	window.__defineGetter__('Subscribable', function() { return Subscribable; });
	window.__defineGetter__('Utils', function() { return Utils; });
	window.__defineGetter__('MRUList', function() { return MRUList; });

	Modules.load('AllTabs');
	Modules.load('iQ');
	Modules.load('Items');
	Modules.load('GroupItems');
	Modules.load('TabItems');
	Modules.load('FavIcons');
	Modules.load('Drag');
	Modules.load('Trench');
	Modules.load('Search');
	Modules.load('UI');
};

Modules.UNLOADMODULE = function() {
	Modules.unload('AllTabs');
	Modules.unload('UI');
	Modules.unload('Search');
	Modules.unload('Trench');
	Modules.unload('Drag');
	Modules.unload('FacIcons');
	Modules.unload('TabItems');
	Modules.unload('GroupItems');
	Modules.unload('Items');
	Modules.unload('iQ');

	for(let shim of TabView.shims) {
		delete window[shim];
	}
};
