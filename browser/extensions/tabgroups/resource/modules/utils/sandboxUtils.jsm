// VERSION 2.4.3
Modules.UTILS = true;
Modules.CLEAN = false;

// window - Similarly to Windows.callOnMostRecent, the window property returns the most recent navigator:browser window object
this.__defineGetter__('window', function() { return Services.wm.getMostRecentWindow('navigator:browser'); });

// document - Returns the document object associated with the most recent window object
this.__defineGetter__('document', function() { return window.document; });

// Styles - handle loading and unloading of stylesheets in a quick and easy way
this.__defineGetter__('Styles', function() { delete this.Styles; Modules.load('utils/Styles'); return Styles; });

// Windows - Aid object to help with window tasks involving window-mediator and window-watcher
this.__defineGetter__('Windows', function() { delete this.Windows; Modules.load('utils/Windows'); return Windows; });

// Browsers - Aid object to track and perform tasks on all document browsers across the windows
this.__defineGetter__('Browsers', function() { Windows; delete this.Browsers; Modules.load('utils/Browsers'); return Browsers; });

// Messenger - Aid object to communicate with browser content scripts (e10s).
this.__defineGetter__('Messenger', function() { delete this.Messenger; Modules.load('utils/Messenger'); return Messenger; });

// Observers - Helper for adding and removing observers
this.__defineGetter__('Observers', function() { delete this.Observers; Modules.load('utils/Observers'); return Observers; });

// Overlays - to use overlays in my bootstraped add-ons
this.__defineGetter__('Overlays', function() { Browsers; Observers; Piggyback; delete this.Overlays; Modules.load('utils/Overlays'); return Overlays; });

// Keysets - handles editable keysets for the add-on
this.__defineGetter__('Keysets', function() { Windows; delete this.Keysets; Modules.load('utils/Keysets'); return Keysets; });

// Keysets - handles editable keysets for the add-on
this.__defineGetter__('PrefPanes', function() { Browsers; delete this.PrefPanes; Modules.load('utils/PrefPanes'); return PrefPanes; });

// DnDprefs - handles customizable areas with draggable elements in the preferences
this.__defineGetter__('DnDprefs', function() { delete this.DnDprefs; Modules.load('utils/DnDprefs'); return DnDprefs; });

// closeCustomize() - useful for when you want to close the customize tabs for whatever reason
this.closeCustomize = function() {
	Windows.callOnAll(function(aWindow) {
		if(aWindow.gCustomizeMode) {
			aWindow.gCustomizeMode.exit();
		}
	}, 'navigator:browser');
};

Modules.UNLOADMODULE = function() {
	Modules.clean();
};
