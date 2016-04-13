// VERSION 1.0.20

this.__defineGetter__('gBrowser', function() { return window.gBrowser; });
this.__defineGetter__('gTabViewDeck', function() { return $('tab-view-deck'); });
this.__defineGetter__('gTaskbarTabGroup', function() { return window.gTaskbarTabGroup; });
this.__defineGetter__('TabContextMenu', function() { return window.TabContextMenu; });

XPCOMUtils.defineLazyGetter(this, "AeroPeek", () => { return Cu.import("resource:///modules/WindowsPreviewPerTab.jsm", {}).AeroPeek; });
XPCOMUtils.defineLazyModuleGetter(this, "gPageThumbnails", "resource://gre/modules/PageThumbs.jsm", "PageThumbs");

this.TabView = {
	_deck: null,
	_iframe: null,
	_window: null,
	_initialized: false,
	_closedLastVisibleTabBeforeFrameInitialized: false,
	_isFrameLoading: false,

	_initFrameCallbacks: [],

	kTooltipId: objName+'-tab-view-tooltip',
	kTabMenuPopupId: objName+'-context_tabViewMenuPopup',
	get tooltip() { return $(this.kTooltipId); },
	get tabMenuPopup() { return $(this.kTabMenuPopupId); },

	// compatibility shims, for other add-ons to interact with this object more closely to the original if needed
	PREF_BRANCH: "extensions."+objPathString,
	PREF_RESTORE_ENABLED_ONCE: "extensions."+objPathString+".pageAutoChanged",
	PREF_STARTUP_PAGE: "browser.startup.page",
	get GROUPS_IDENTIFIER() { return Storage.kGroupsIdentifier; },
	get VISIBILITY_IDENTIFIER() { return ""; },
	get firstUseExperienced() { return true; },
	set firstUseExperienced(v) { return true; },
	get sessionRestoreEnabledOnce() { return Prefs.pageAutoChanged; },
	set sessionRestoreEnabledOnce(v) { return Prefs.pageAutoChanged = v; },
	get _browserKeyHandlerInitialized() { return true; },
	getContentWindow: function() { return this._window; },

	get windowTitle() {
		delete this.windowTitle;
		let brandBundle = $("bundle_brand");
		let brandShortName = brandBundle.getString("brandShortName");
		let title = Strings.get("TabView", "windowTitle", [ [ '$app', brandShortName ] ]);
		return this.windowTitle = title;
	},

	handleEvent: function(e) {
		switch(e.type) {
			case 'DOMContentLoaded':
				Listeners.remove(this._iframe, 'DOMContentLoaded', this);
				Listeners.add(this._iframe.contentWindow, "tabviewframeinitialized", this);

				prepareObject(this._iframe.contentWindow);
				this._iframe.contentWindow[objName].Modules.load('TabView-frame');
				break;

			case 'tabviewframeinitialized':
				Listeners.remove(this._iframe.contentWindow, 'tabviewframeinitialized', this);

				this._isFrameLoading = false;
				this._window = this._iframe.contentWindow;

				Listeners.remove(gBrowser.tabContainer, "TabShow", this);
				Listeners.remove(gBrowser.tabContainer, "TabClose", this);

				this._initFrameCallbacks.forEach(cb => cb());
				this._initFrameCallbacks = [];

				break;

			case 'TabShow':
				// if a tab is changed from hidden to unhidden and the iframe is not initialized, load the iframe and setup the tab.
				if(!this._window) {
					this._initFrame(() => {
						this._window[objName].UI.onTabSelect(gBrowser.selectedTab);
						if(this._closedLastVisibleTabBeforeFrameInitialized) {
							this._closedLastVisibleTabBeforeFrameInitialized = false;
							this._window[objName].UI.showTabView(false);
						}
					});
				}

				break;

			case 'TabClose':
				if(!this._window && !gBrowser.visibleTabs.length) {
					this._closedLastVisibleTabBeforeFrameInitialized = true;
				}
				break;

			case 'popupshowing':
				switch(e.target.id) {
					// for the tooltip
					case this.kTooltipId:
						if(!this.fillInTooltip(document.tooltipNode)) {
							e.preventDefault();
							e.stopPropagation();
						}
						break;

					// On "move to group" popup showing.
					case this.kTabMenuPopupId:
						// Update the context menu only if Panorama was already initialized or if there are hidden tabs.
						let numHiddenTabs = gBrowser.tabs.length - gBrowser.visibleTabs.length;
						if(this._window || numHiddenTabs) {
							this.updateContextMenu(TabContextMenu.contextTab, e.target);
						}

					// Hide "Move to Group" in tabs context menu if it's a pinned tab.
					case 'tabContextMenu':
						$(objName+"-context_tabViewMenu").hidden = TabContextMenu.contextTab.pinned;
						break;
				}
				break;

			case 'tabviewshown':
				gTaskbarTabGroup.enabled = false;
				break;

			case 'tabviewhidden':
				if(AeroPeek._prefenabled) {
					gTaskbarTabGroup.enabled = true;
				}
				break;
		}
	},

	init: function(loaded) {
		// ignore everything if this was called by the native initializer, we need to wait for our overlay to finish loading
		if(!loaded) { return; }

		if(!window.toolbar.visible || this._initialized) { return; }

		try {
			data = SessionStore.getWindowValue(window, Storage.kGroupsIdentifier);
			if(data) {
				data = JSON.parse(data);
				this.updateGroupNumberBroadcaster(data.totalNumber || 1);
			}
		}
		catch(ex) {}

		Listeners.add(this.tooltip, "popupshowing", this, true);
		Listeners.add(this.tabMenuPopup, "popupshowing", this);
		Listeners.add($('tabContextMenu'), "popupshowing", this);
		Listeners.add(gBrowser.tabContainer, "TabShow", this);
		Listeners.add(gBrowser.tabContainer, "TabClose", this);

		// prevent thumbnail service from expiring thumbnails
		// we can't wait for the panel view here since expiration may run before it is initialized
		gPageThumbnails.addExpirationFilter(this);

		Piggyback.add('TabView', window, 'WindowIsClosing', () => {
			if(this.hide()) {
				return false;
			}
			return window._WindowIsClosing();
		});

		Piggyback.add('TabView', window, 'undoCloseTab', (aIndex) => {
			let tab = null;
			if(SessionStore.getClosedTabCount(window) > (aIndex || 0)) {
				// wallpaper patch to prevent an unnecessary blank tab (bug 343895)
				let blankTabToRemove = null;
				if(gBrowser.tabs.length == 1 && window.isTabEmpty(gBrowser.selectedTab)) {
					blankTabToRemove = gBrowser.selectedTab;
				}

				this.prepareUndoCloseTab(blankTabToRemove);
				tab = SessionStore.undoCloseTab(window, aIndex || 0);
				this.afterUndoCloseTab();

				if(blankTabToRemove) {
					gBrowser.removeTab(blankTabToRemove);
				}
			}

			return tab;
		});

		Piggyback.add('TabView', gBrowser, 'updateTitlebar', () => {
			if(this.isVisible()) {
				document.title = this.windowTitle;
				return false;
			}
			return true;
		}, Piggyback.MODE_BEFORE);

		if(gTaskbarTabGroup) {
			Listeners.add(window, 'tabviewshown', this);
			Listeners.add(window, 'tabviewhidden', this);
		}

		this._initialized = true;
	},

	uninit: function() {
		if(!this._initialized) { return; }

		if(gTaskbarTabGroup) {
			Listeners.remove(window, 'tabviewshown', this);
			Listeners.remove(window, 'tabviewhidden', this);
		}

		gPageThumbnails.removeExpirationFilter(this);

		Piggyback.revert('TabView', window, 'WindowIsClosing');
		Piggyback.revert('TabView', window, 'undoCloseTab');
		Piggyback.revert('TabView', gBrowser, 'updateTitlebar');

		Listeners.remove(this.tooltip, "popupshowing", this, true);
		Listeners.remove(this.tabMenuPopup, "popupshowing", this);
		Listeners.remove($('tabContextMenu'), "popupshowing", this);

		this._initialized = false;
		this._deinitFrame();
	},

	filterForThumbnailExpiration() {
		return AllTabs.tabs.map(t => t.linkedBrowser.currentURI.spec);
	},

	// Creates the frame and calls the callback once it's loaded. If the frame already exists, calls the callback immediately.
	_initFrame: function(callback) {
		// prevent frame to be initialized for popup windows
		if(!window.toolbar.visible) { return; }

		if(this._window) {
			if(callback) {
				callback();
			}
			return;
		}

		if(callback) {
			this._initFrameCallbacks.push(callback);
		}

		if(this._isFrameLoading) { return; }
		this._isFrameLoading = true;

		// find the deck
		this._deck = gTabViewDeck;

		// create the frame
		this._iframe = document.createElement("iframe");
		this._iframe.id = objName+"-tab-view";
		this._iframe.setAttribute("transparent", "true");
		this._iframe.setAttribute("tooltip", this.kTooltipId);
		this._iframe.flex = 1;

		Listeners.add(this._iframe, "DOMContentLoaded", this);

		this._iframe.setAttribute("src", "chrome://"+objPathString+"/content/tabview.xhtml");
		this._deck.appendChild(this._iframe);
	},

	_deinitFrame: function() {
		// nothing to do
		if(!this._window && !this._iframe && !this._deck) { return; }

		Listeners.remove(this._window, "tabviewframeinitialized", this);
		Listeners.remove(this._iframe, "DOMContentLoaded", this);

		if(this._initialized) {
			Listeners.add(gBrowser.tabContainer, "TabShow", this);
			Listeners.add(gBrowser.tabContainer, "TabClose", this);
		} else {
			Listeners.remove(gBrowser.tabContainer, "TabShow", this);
			Listeners.remove(gBrowser.tabContainer, "TabClose", this);
		}

		this._deck = null;

		if(this._window) {
			removeObject(this._window);
			this._window = null;
		}

		if(this._iframe) {
			this._iframe.remove();
			this._iframe = null;
		}
	},

	isVisible: function() {
		return (this._deck ? this._deck.selectedPanel == this._iframe : false);
	},

	show: function() {
		if(this.isVisible()) { return; }

		this._initFrame(() => {
			this._window[objName].UI.showTabView(true);
		});
	},

	hide: function() {
		if(this.isVisible() && this._window) {
			this._window[objName].UI.exit();
			return true;
		}
		return false;
	},

	toggle: function() {
		if(!window.toolbar.visible) { return; }

		if(this.isVisible()) {
			this.hide();
		} else {
			this.show();
		}
	},

	switchGroup: function(aPrevious) {
		if(!this._tabBrowserHasHiddenTabs()) { return; }

		this._initFrame(() => {
			let groupItems = this._window[objName].GroupItems;
			let tabItem = groupItems.getNextGroupItemTab(aPrevious);
			if(!tabItem) { return; }

			let isVisible = this.isVisible();
			if(gBrowser.selectedTab.pinned || isVisible) {
				groupItems.updateActiveGroupItemAndTabBar(tabItem, { dontSetActiveTabInGroup: !isVisible });
			} else {
				gBrowser.selectedTab = tabItem.tab;
			}
		});
	},

	_tabBrowserHasHiddenTabs: function() {
		return (gBrowser.tabs.length - gBrowser.visibleTabs.length);
	},

	updateContextMenu: function(tab, popup) {
		let separator = $(objName+"-context_tabViewNamedGroups");
		separator.hidden = true;

		// empty the menu immediately so old and invalid entries aren't shown
		this.emptyContextMenu(popup, separator);

		this._initFrame(() => {
			// empty the menu again because sometimes this is called twice (on first open, don't know why though), leading to double entries
			this.emptyContextMenu(popup, separator);

			let activeGroup = tab._tabViewTabItem.parent;
			let groupItems = this._window[objName].GroupItems.groupItems;
			let menuItems = [];

			for(let groupItem of groupItems) {
				// if group has title, it's not hidden and there is no active group or the active group id doesn't match the group id,
				// a group menu item will be added.
				if(!groupItem.hidden
				&& (groupItem.getTitle().trim() || groupItem.getChildren().length)
				&& (!activeGroup || activeGroup.id != groupItem.id)) {
					menuItems.push(this._createGroupMenuItem(groupItem));
				}
			}

			if(menuItems.length) {
				menuItems.sort(function(a, b) {
					if(a.groupTitle < b.groupTitle) { return -1; }
					if(a.groupTitle > b.groupTitle) { return 1; }
					return 0;
				});
				for(let menuItem of menuItems) {
					popup.insertBefore(menuItem, separator);
				}
				separator.hidden = false;
			}
		});
	},

	emptyContextMenu: function(popup, separator) {
		while(popup.firstChild && popup.firstChild != separator) {
			popup.firstChild.remove();
		}
	},

	getGroupTitle: function(groupItem) {
		let title = groupItem.getTitle();
		if(title.trim()) {
			return title;
		}

		let topChildLabel = groupItem.getTopChild().tab.label;
		let childNum = groupItem.getChildren().length;
		if(childNum > 1) {
			let num = childNum -1;
			return Strings.get('TabView', 'moveToUnnamedGroup', [
				[ "$title", topChildLabel ],
				[ "$tabs", num ]
			], num);
		}

		return topChildLabel;
	},

	_createGroupMenuItem: function(groupItem) {
		let menuItem = document.createElement("menuitem");
		let title = this.getGroupTitle(groupItem);

		menuItem.groupId = groupItem.id;
		menuItem.groupTitle = title;
		menuItem.setAttribute("label", title);
		menuItem.setAttribute("tooltiptext", title);
		menuItem.setAttribute("crop", "center");
		menuItem.setAttribute("class", "tabview-menuitem");

		menuItem.handleEvent = (e) => {
			this.moveTabTo(TabContextMenu.contextTab, menuItem.groupId);
		};
		menuItem.addEventListener("command", menuItem);

		return menuItem;
	},

	moveTabTo: function(tab, groupItemId) {
		this._initFrame(() => {
			this._window[objName].GroupItems.moveTabToGroupItem(tab, groupItemId);
		});
	},

	// Prepares the tab view for undo close tab.
	prepareUndoCloseTab: function(blankTabToRemove) {
		if(this._window) {
			this._window[objName].UI.restoredClosedTab = true;

			if(blankTabToRemove && blankTabToRemove._tabViewTabItem) {
				blankTabToRemove._tabViewTabItem.isRemovedAfterRestore = true;
			}
		}
	},

	// Cleans up the tab view after undo close tab.
	afterUndoCloseTab: function() {
		if(this._window) {
			this._window[objName].UI.restoredClosedTab = false;
		}
	},

	// Updates the group number broadcaster.
	updateGroupNumberBroadcaster: function(number) {
		let groupsNumber = $(objName+"-tabviewGroupsNumber");
		setAttribute(groupsNumber, "groups", number);
	},

	// Fills in the tooltip text.
	fillInTooltip: function(tipElement) {
		let retVal = false;
		let titleText = null;
		let direction = tipElement.ownerDocument.dir;

		while(!titleText && tipElement) {
			if(tipElement.nodeType == window.Node.ELEMENT_NODE) {
				titleText = tipElement.getAttribute("title");
			}
			tipElement = tipElement.parentNode;
		}

		this.tooltip.style.direction = direction;

		if(titleText) {
			setAttribute(this.tooltip, "label", titleText);
			retVal = true;
		}

		return retVal;
	},

	onLoad: function() {
		migrate.migrateWidget();

		window.SessionStore.promiseInitialized.then(() => {
			if(UNLOADED) { return; }

			this.init(true);
		});
	},

	onUnload: function() {
		this.uninit();
	}
};

Modules.LOADMODULE = function() {
	if(Services.vc.compare(Services.appinfo.version, "45.0a1") >= 0) {
		// compatibility shim, for other add-ons to interact with this object more closely to the original if needed
		window.TabView = TabView;
	}

	Modules.load('AllTabs');
	Overlays.overlayWindow(window, 'TabView', TabView);
};

Modules.UNLOADMODULE = function() {
	Overlays.removeOverlayWindow(window, 'TabView');
	Modules.unload('AllTabs');

	if(Services.vc.compare(Services.appinfo.version, "45.0a1") >= 0) {
		delete window.TabView;
	}
};
