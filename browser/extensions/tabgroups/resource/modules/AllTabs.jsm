// VERSION 1.0.0

this.AllTabs = {
	_events: {
		attrModified: "TabAttrModified",
		close: "TabClose",
		move: "TabMove",
		open: "TabOpen",
		select: "TabSelect",
		pinned: "TabPinned",
		unpinned: "TabUnpinned"
	},

	get tabs() {
		return Array.filter(gBrowser.tabs, tab => Utils.isValidXULTab(tab));
	},

	register: function(eventName, callback) {
		Listeners.add(gBrowser.tabContainer, this._events[eventName], callback);
	},

	unregister: function(eventName, callback) {
		Listeners.remove(gBrowser.tabContainer, this._events[eventName], callback);
	}
};
