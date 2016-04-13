// VERSION 1.0.0

this.bug566510 = {
	onLoad: function(aWindow) {
		let tabMenuPopup = aWindow.TabView.tabMenuPopup;
		tabMenuPopup._bug566510onPopupShown = function(e) {
			if(e.target == tabMenuPopup) {
				// the native Tab Groups uses an oncommand attribute, we use JS listeners,
				// the bug566510 add-on doesn't know this, so we're adapting its routine here
				for(let item of tabMenuPopup.childNodes) {
					if(item.id == objName+"-context_tabViewNamedGroups") { break; }

					item.handleEvent = function(e) {
						aWindow.bug566510_TabView.moveTabsTo(aWindow.TabContextMenu.contextTab, this.groupId);
					};
				}
			}
		}
		tabMenuPopup.addEventListener('popupshown', tabMenuPopup._bug566510onPopupShown);
	},

	onUnload: function(aWindow) {
		let tabMenuPopup = aWindow.TabView.tabMenuPopup;
		tabMenuPopup.removeEventListener('popupshown', tabMenuPopup._bug566510onPopupShown);
		delete tabMenuPopup._bug566510onPopupShown;
	}
};

Modules.LOADMODULE = function() {
	Overlays.overlayURI('chrome://'+objPathString+'/content/TabView.xul', 'bug566510', bug566510);
};

Modules.UNLOADMODULE = function() {
	Overlays.removeOverlayURI('chrome://'+objPathString+'/content/TabView.xul', 'bug566510');
};
