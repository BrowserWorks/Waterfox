// VERSION 1.0.8

XPCOMUtils.defineLazyModuleGetter(this, "gPageThumbnails", "resource://gre/modules/PageThumbs.jsm", "PageThumbs");

// Class: TabItem - An <Item> that represents a tab. Also implements the <Subscribable> interface.
// Parameters:
//   tab - a xul:tab
this.TabItem = function(tab, options) {
	this.tab = tab;
	// register this as the tab's tabItem
	this.tab._tabViewTabItem = this;

	if(!options) {
		options = {};
	}

	// ___ set up div
	document.body.appendChild(TabItems.fragment().cloneNode(true));

	// The document fragment contains just one Node. As per DOM3 appendChild: it will then be the last child
	let div = document.body.lastChild;
	let $div = iQ(div);

	this._showsCachedData = false;
	this.canvasSizeForced = false;
	this.$thumb = iQ('.thumb', $div);
	this.$fav = iQ('.favicon', $div);
	this.$tabTitle = iQ('.tab-title', $div);
	this.$canvas = iQ('.thumb canvas', $div);
	this.$cachedThumb = iQ('img.cached-thumb', $div);
	this.$favImage = iQ('.favicon>img', $div);
	this.$close = iQ('.close', $div);

	this.tabCanvas = new TabCanvas(this.tab, this.$canvas[0]);

	this._hidden = false;
	this.isATabItem = true;
	this.keepProportional = true;
	this._hasBeenDrawn = false;
	this._reconnected = false;
	this.isDragging = false;
	this.isStacked = false;

	// Read off the total vertical and horizontal padding on the tab container and cache this value, as it must be the same for every TabItem.
	if(Utils.isEmptyObject(TabItems.tabItemPadding)) {
		TabItems.tabItemPadding.x = parseInt($div.css('padding-left')) + parseInt($div.css('padding-right'));
		TabItems.tabItemPadding.y = parseInt($div.css('padding-top')) + parseInt($div.css('padding-bottom'));
	}

	this.bounds = new Rect(0,0,1,1);

	this._lastTabUpdateTime = Date.now();

	// ___ superclass setup
	this._init(div);

	// ___ drag/drop
	// override dropOptions with custom tabitem methods
	this.dropOptions.drop = function(e) {
		let groupItem = drag.info.item.parent;
		groupItem.add(drag.info.$el);
	};

	this.draggable();

	// ___ more div setup
	$div.mousedown((e) => {
		if(e.button != 2) {
			this.lastMouseDownTarget = e.target;
		}
	});

	$div.mouseup((e) => {
		let same = (e.target == this.lastMouseDownTarget);
		this.lastMouseDownTarget = null;
		if(!same) { return; }

		// press close button or middle mouse click
		if(iQ(e.target).hasClass("close") || e.button == 1) {
			this.closedManually = true;
			this.close();
		} else {
			if(!Items.item($div).isDragging) {
				this.zoomIn();
			}
		}
	});

	this.droppable(true);

	this.$close.attr("title", Strings.get("TabView", "closeTab"));

	TabItems.register(this);

	// ___ reconnect to data from Storage
	if(!TabItems.reconnectingPaused()) {
		this._reconnect(options);
	}
};

this.TabItem.prototype = (!this.Item) ? null : Utils.extend(new Item(), new Subscribable(), {
	// Repaints the thumbnail with the given resolution, and forces it to stay that resolution until unforceCanvasSize is called.
	forceCanvasSize: function(w, h) {
		this.canvasSizeForced = true;
		this.$canvas[0].width = w;
		this.$canvas[0].height = h;
		this.tabCanvas.paint();
	},

	// Stops holding the thumbnail resolution; allows it to shift to the size of thumbnail on screen.
	// Note that this call does not nest, unlike <TabItems.resumePainting>; if you call forceCanvasSize multiple times, you just need a single unforce to clear them all.
	unforceCanvasSize: function() {
		this.canvasSizeForced = false;
	},

	// Returns a boolean indicates whether the cached data is being displayed or not.
	isShowingCachedData: function() {
		return this._showsCachedData;
	},

	// Shows the cached data i.e. image and title.  Note: this method should only be called at browser startup with the cached data avaliable.
	showCachedData: function() {
		let { title, url } = this.getTabState();
		let thumbnailURL = gPageThumbnails.getThumbnailURL(url);

		this.$cachedThumb.attr("src", thumbnailURL).show();
		this.$canvas.css({ opacity: 0 });

		let tooltip = (title && title != url ? title + "\n" + url : url);
		this.$tabTitle.text(title).attr("title", tooltip);
		this._showsCachedData = true;
	},

	// Hides the cached data i.e. image and title and show the canvas.
	hideCachedData: function() {
		this.$cachedThumb.attr("src", "").hide();
		this.$canvas.css({ opacity: 1.0 });
		this._showsCachedData = false;
	},

	// Get data to be used for persistent storage of this object.
	getStorageData: function() {
		let data = {
			groupID: (this.parent ? this.parent.id : 0)
		};
		if(this.parent && this.parent.getActiveTab() == this) {
			data.active = true;
		}

		return data;
	},

	// Checks the specified data (as returned by TabItem.getStorageData) and returns true if it looks valid.
	storageSanity: function(data) {
		return typeof(data) == 'object' && typeof(data.groupID) == 'number';
	},

	// Store persistent for this object.
	save: function() {
		try {
			// too soon/late to save
			if(!this.tab || !Utils.isValidXULTab(this.tab) || !this._reconnected) { return; }

			let data = this.getStorageData();
			Storage.saveTab(this.tab, data);
		}
		catch(ex) {
			Cu.reportError(ex);
		}
	},

	// Returns the current tab state's active history entry.
	_getCurrentTabStateEntry: function() {
		let tabState = Storage.getTabState(this.tab);

		if(tabState) {
			let index = (tabState.index || tabState.entries.length) - 1;
			if(index in tabState.entries) {
				return tabState.entries[index];
			}
		}

		return null;
	},

	// Returns the current tab state, i.e. the title and URL of the active history entry.
	getTabState: function() {
		let entry = this._getCurrentTabStateEntry();
		let title = "";
		let url = "";

		if(entry) {
			if(entry.title) {
				title = entry.title;
			}

			url = entry.url;
		} else {
			url = this.tab.linkedBrowser.currentURI.spec;
		}

		return { title: title, url: url };
	},

	// Load the reciever's persistent data from storage. If there is none, treats it as a new tab.
	// Parameters:
	//   options - an object with additional parameters, see below
	// Possible options:
	//   groupItemId - if the tab doesn't have any data associated with it and groupItemId is available, add the tab to that group.
	_reconnect: function(options) {
		let tabData = Storage.getTabData(this.tab);
		let groupItem;

		if(tabData && this.storageSanity(tabData)) {
			// Show the cached data while we're waiting for the tabItem to be updated.
			// If the tab isn't restored yet this acts as a placeholder until it is.
			this.showCachedData();

			if(this.parent) {
				this.parent.remove(this, { immediately: true });
			}

			if(tabData.groupID) {
				groupItem = GroupItems.groupItem(tabData.groupID);
			} else {
				groupItem = new GroupItem([], { immediately: true, bounds: tabData.bounds });
			}

			if(groupItem) {
				groupItem.add(this, { immediately: true });

				// restore the active tab for each group between browser sessions
				if(tabData.active) {
					groupItem.setActiveTab(this);
				}

				// if it matches the selected tab or no active tab and the browser tab is hidden, the active group item would be set.
				if(this.tab.selected || (!GroupItems.getActiveGroupItem() && !this.tab.hidden)) {
					UI.setActive(this.parent);
				}
			}
		}
		else {
			if(options && options.groupItemId) {
				groupItem = GroupItems.groupItem(options.groupItemId);
			}

			if(groupItem) {
				groupItem.add(this, { immediately: true });
			} else {
				// create tab group by double click is handled in UI_init().
				GroupItems.newTab(this, { immediately: true });
			}
		}

		this._reconnected = true;
		this.save();
		this._sendToSubscribers("reconnected");
	},

	// Hide/unhide this item
	setHidden: function(val) {
		if(val) {
			this.addClass("tabHidden");
		} else {
			this.removeClass("tabHidden");
		}
		this._hidden = val;
	},

	// Return hide state of item
	getHidden: function() {
		return this._hidden;
	},

	// Moves this item to the specified location and size.
	// Parameters:
	//   rect - a <Rect> giving the new bounds
	//   immediately - true if it should not animate; default false
	//   options - an object with additional parameters, see below
	// Possible options:
	//   force - true to always update the DOM even if the bounds haven't changed; default false
	setBounds: function(inRect, immediately, options) {
		if(!options) {
			options = {};
		}

		// force the input size to be valid
		let validSize = TabItems.calcValidSize(new Point(inRect.width, inRect.height), { hideTitle: (this.isStacked || options.hideTitle === true) });
		let rect = new Rect(inRect.left, inRect.top, validSize.x, validSize.y);

		let css = {};

		if(rect.left != this.bounds.left || options.force) {
			css.left = rect.left;
		}

		if(rect.top != this.bounds.top || options.force) {
			css.top = rect.top;
		}

		if(rect.width != this.bounds.width || options.force) {
			css.width = rect.width - TabItems.tabItemPadding.x;
			css.fontSize = TabItems.getFontSizeFromWidth(rect.width);
			css.fontSize += 'px';
		}

		if(rect.height != this.bounds.height || options.force) {
			css.height = rect.height - TabItems.tabItemPadding.y;
			if(!this.isStacked) {
				css.height -= TabItems.fontSizeRange.max;
			}
		}

		if(Utils.isEmptyObject(css)) { return; }

		this.bounds.copy(rect);

		// If this is a brand new tab don't animate it in from a random location (i.e., from [0,0]). Instead, just have it appear where it should be.
		if(immediately || (!this._hasBeenDrawn)) {
			this.$container.css(css);
		} else {
			TabItems.pausePainting();
			this.$container.animate(css, {
				duration: 200,
				easing: "tabviewBounce",
				complete: function() {
					TabItems.resumePainting();
				}
			});
		}

		if(css.fontSize && !(this.parent && this.parent.isStacked())) {
			if(css.fontSize < TabItems.fontSizeRange.min) {
				immediately ? this.$tabTitle.hide() : this.$tabTitle.fadeOut();
			} else {
				immediately ? this.$tabTitle.show() : this.$tabTitle.fadeIn();
			}
		}

		if(css.width) {
			TabItems.update(this.tab);

			let widthRange, proportion;

			if(this.parent && this.parent.isStacked()) {
				if(UI.rtl) {
					this.$fav.css({ top:0, right:0 });
				} else {
					this.$fav.css({ top:0, left:0 });
				}
				widthRange = new Range(70, 90);
				proportion = widthRange.proportion(css.width); // between 0 and 1
			} else {
				if(UI.rtl) {
					this.$fav.css({ top:4, right:2 });
				} else {
					this.$fav.css({ top:4, left:4 });
				}
				widthRange = new Range(40, 45);
				proportion = widthRange.proportion(css.width); // between 0 and 1
			}

			if(proportion <= .1) {
				this.$close.hide();
			} else {
				this.$close.show().css({ opacity: proportion });
			}

			let pad = 1 + 5 * proportion;
			let alphaRange = new Range(0.1,0.2);
			this.$fav.css({
				"-moz-padding-start": pad + "px",
				"-moz-padding-end": pad + 2 + "px",
				"padding-top": pad + "px",
				"padding-bottom": pad + "px",
				"border-color": "rgba(0,0,0,"+ alphaRange.scale(proportion) +")",
			});
		}

		this._hasBeenDrawn = true;

		UI.clearShouldResizeItems();

		rect = this.getBounds(); // ensure that it's a <Rect>

		if(!this.parent && Utils.isValidXULTab(this.tab)) {
			this.setTrenches(rect);
		}

		this.save();
	},

	// Sets the z-index for this item.
	setZ: function(value) {
		this.zIndex = value;
		this.$container.css({ zIndex: value });
	},

	// Closes this item (actually closes the tab associated with it, which automatically closes the item).
	// Parameters:
	//   groupClose - true if this method is called by group close action.
	// Returns true if this tab is removed.
	close: function(groupClose) {
		// When the last tab is closed, put a new tab into closing tab's group.
		// If closing tab doesn't belong to a group and no empty group, create a new one for the new tab.
		if(!groupClose && gBrowser.tabs.length == 1) {
			let group = this.tab._tabViewTabItem.parent;
			group.newTab(null, { closedLastTab: true });
		}

		gBrowser.removeTab(this.tab);
		let tabClosed = !this.tab;

		// No need to explicitly delete the tab data, becasue sessionstore data associated with the tab will automatically go away
		return tabClosed;
	},

	// Adds the specified CSS class to this item's container DOM element.
	addClass: function(className) {
		this.$container.addClass(className);
	},

	// Removes the specified CSS class from this item's container DOM element.
	removeClass: function(className) {
		this.$container.removeClass(className);
	},

	// Updates this item to visually indicate that it's active.
	makeActive: function() {
		this.$container.addClass("focus");

		if(this.parent) {
			this.parent.setActiveTab(this);
		}
	},

	// Updates this item to visually indicate that it's not active.
	makeDeactive: function() {
		this.$container.removeClass("focus");
	},

	// Allows you to select the tab and zoom in on it, thereby bringing you to the tab in Firefox to interact with.
	// Parameters:
	//   isNewBlankTab - boolean indicates whether it is a newly opened blank tab.
	zoomIn: function(isNewBlankTab) {
		// don't allow zoom in if its group is hidden
		if(this.parent && this.parent.hidden) { return; }

		let $tabEl = this.$container;
		let $canvas = this.$canvas;

		Search.hide();

		UI.setActive(this);
		TabItems._update(this.tab, { force: true });

		// Zoom in!
		let tab = this.tab;

		let onZoomDone = () => {
			$canvas.css({ 'transform': null });
			$tabEl.removeClass("front");

			UI.goToTab(tab);

			// tab might not be selected because hideTabView() is invoked after
			// UI.goToTab() so we need to setup everything for the gBrowser.selectedTab
			if (!tab.selected) {
				UI.onTabSelect(gBrowser.selectedTab);
			} else {
				if(isNewBlankTab) {
					gWindow.gURLBar.focus();
				}
			}
			if(this.parent && this.parent.expanded) {
				this.parent.collapse();
			}

			this._sendToSubscribers("zoomedIn");
		};

		if(Prefs.animateZoom) {
			let transform = this.getZoomTransform();
			TabItems.pausePainting();

			if(this.parent && this.parent.expanded) {
				$tabEl.removeClass("stack-trayed");
			}
			$tabEl.addClass("front");
			$canvas
				.css({ 'transform-origin': transform.transformOrigin })
				.animate({ 'transform': transform.transform }, {
					duration: 230,
					easing: 'fast',
					complete: function() {
						onZoomDone();

						aSync(function() {
							TabItems.resumePainting();
						}, 0);
					}
				});
		} else {
			aSync(onZoomDone, 0);
		}
	},

	// Handles the zoom down animation after returning to TabView. It is expected that this routine will be called from the chrome thread
	// Parameters:
	//   complete - a function to call after the zoom down animation
	zoomOut: function(complete) {
		let $tab = this.$container;
		let $canvas = this.$canvas;

		let onZoomDone = function() {
			$tab.removeClass("front");
			$canvas.css("transform", null);

			if(typeof complete == "function") {
				complete();
			}
		};

		UI.setActive(this);
		TabItems._update(this.tab, { force: true });

		$tab.addClass("front");

		if(Prefs.animateZoom) {
			// The scaleCheat of 2 here is a clever way to speed up the zoom-out code. See getZoomTransform() below.
			let transform = this.getZoomTransform(2);
			TabItems.pausePainting();

			$canvas.css({
				'transform': transform.transform,
				'transform-origin': transform.transformOrigin
			});

			$canvas.animate({ "transform": "scale(1.0)" }, {
				duration: 300,
				easing: 'cubic-bezier', // note that this is legal easing, even without parameters
				complete: function() {
					TabItems.resumePainting();
					onZoomDone();
				}
			});
		} else {
			onZoomDone();
		}
	},

	// Returns the transform function which represents the maximum bounds of the tab thumbnail in the zoom animation.
	getZoomTransform: function(scaleCheat) {
		// Taking the bounds of the container (as opposed to the canvas) makes us immune to any transformations applied to the canvas.
		let { left, top, width, height, right, bottom } = this.$container.bounds();

		let { innerWidth: windowWidth, innerHeight: windowHeight } = window;

		// The scaleCheat is a clever way to speed up the zoom-in code.
		// Because image scaling is slowest on big images, we cheat and stop the image at scaled-down size and placed accordingly.
		// Because the animation is fast, you can't see the difference but it feels a lot zippier.
		// The only trick is choosing the right animation function so that you don't see a change in percieved animation speed from frame #1
		// (the tab) to frame #2 (the half-size image) to frame #3 (the first frame of real animation). Choosing an animation that starts fast is key.

		if(!scaleCheat) {
			scaleCheat = 1.7;
		}

		let zoomWidth = width + (window.innerWidth - width) / scaleCheat;
		let zoomScaleFactor = zoomWidth / width;

		let zoomHeight = height * zoomScaleFactor;
		let zoomTop = top * (1 - 1/scaleCheat);
		let zoomLeft = left * (1 - 1/scaleCheat);

		let xOrigin = (left - zoomLeft) / ((left - zoomLeft) + (zoomLeft + zoomWidth - right)) * 100;
		let yOrigin = (top - zoomTop) / ((top - zoomTop) + (zoomTop + zoomHeight - bottom)) * 100;

		return {
			transformOrigin: xOrigin + "% " + yOrigin + "%",
			transform: "scale(" + zoomScaleFactor + ")"
		};
	},

	// Updates the tabitem's canvas.
	updateCanvas: function() {
		// ___ thumbnail
		let $canvas = this.$canvas;
		let w = $canvas.width();
		let h = $canvas.height();
		let dimsChanged = !this.canvasSizeForced && (w != $canvas[0].width || h != $canvas[0].height);

		TabItems._lastUpdateTime = Date.now();
		this._lastTabUpdateTime = TabItems._lastUpdateTime;

		if(this.tabCanvas) {
			if(dimsChanged) {
				// more tasking as it involves the creation of a temp canvas.
				this.tabCanvas.update(w, h);
			} else {
				this.tabCanvas.paint();
			}
		}

		// ___ cache
		if(this.isShowingCachedData()) {
			this.hideCachedData();
		}
	}
});

// Singleton for managing <TabItem>s
this.TabItems = {
	minTabWidth: 40,
	tabWidth: 160,
	tabHeight: 120,
	tabAspect: 0, // set in init
	invTabAspect: 0, // set in init
	fontSize: 9,
	fontSizeRange: new Range(8,15),
	_fragment: null,
	items: [],
	paintingPaused: 0,
	_tabsWaitingForUpdate: null,
	_heartbeatTiming: 200, // milliseconds between calls
	_maxTimeForUpdating: 200, // milliseconds that consecutive updates can take
	_lastUpdateTime: Date.now(),
	_eventListeners: [],
	_reconnectingPaused: false,
	tabItemPadding: {},

	// Called when a web page is painted.
	receiveMessage: function(m) {
		let tab = gBrowser.getTabForBrowser(m.target);
		if(!tab) { return; }

		if(!tab.pinned) {
			this.update(tab);
		}
	},

	// Set up the necessary tracking to maintain the <TabItems>s.
	init: function() {
		// Set up tab priority queue
		this._tabsWaitingForUpdate = new TabPriorityQueue();
		this.minTabHeight = this.minTabWidth * this.tabHeight / this.tabWidth;
		this.tabAspect = this.tabHeight / this.tabWidth;
		this.invTabAspect = 1 / this.tabAspect;

		let $canvas = iQ("<canvas>").attr('moz-opaque', '');
		$canvas.appendTo(iQ("body"));
		$canvas.hide();

		Messenger.listenWindow(gWindow, "MozAfterPaint", this);

		// When a tab is opened, create the TabItem
		this._eventListeners.open = (event) => {
			let tab = event.target;

			if(!tab.pinned) {
				this.link(tab);
			}
		};
		// When a tab's content is loaded, show the canvas and hide the cached data if necessary.
		this._eventListeners.attrModified = (event) => {
			let tab = event.target;

			if(!tab.pinned) {
				this.update(tab);
			}
		};
		// When a tab is closed, unlink.
		this._eventListeners.close = (event) => {
			let tab = event.target;

			// XXX bug #635975 - don't unlink the tab if the dom window is closing.
			if(!tab.pinned && !UI.isDOMWindowClosing) {
				this.unlink(tab);
			}
		};
		for(let name in this._eventListeners) {
			AllTabs.register(name, this._eventListeners[name]);
		}

		let activeGroupItem = GroupItems.getActiveGroupItem();
		let activeGroupItemId = activeGroupItem ? activeGroupItem.id : null;
		// For each tab, create the link.
		AllTabs.tabs.forEach((tab) => {
			if(tab.pinned) { return; }

			let options = { immediately: true };
			// if tab is visible in the tabstrip and doesn't have any data stored in the session store (see TabItem__reconnect),
			// it implies that it is a new tab which is created before Panorama is initialized.
			// Therefore, passing the active group id to the link() method for setting it up.
			if(!tab.hidden && activeGroupItemId) {
				options.groupItemId = activeGroupItemId;
			}
			this.link(tab, options);
			this.update(tab);
		});
	},

	uninit: function() {
		Messenger.unlistenWindow(gWindow, "MozAfterPaint", this);

		for(let name in this._eventListeners) {
			AllTabs.unregister(name, this._eventListeners[name]);
		}
		for(let tabItem of this.items) {
			delete tabItem.tab._tabViewTabItem;

			for(let x in tabItem) {
				if(typeof tabItem[x] == "object") {
					tabItem[x] = null;
				}
			}
		}

		this.items = [];
		this._eventListeners = [];
		this._lastUpdateTime = Date.now();
		this._tabsWaitingForUpdate.clear();
	},

	// Return a DocumentFragment which has a single <div> child. This child node will act as a template for all TabItem containers.
	// The first call of this function caches the DocumentFragment in _fragment.
	fragment: function() {
		if(this._fragment) {
			return this._fragment;
		}

		let div = document.createElement("div");
		div.classList.add("tab");

		let thumb = document.createElement("div");
		thumb.classList.add('thumb');
		div.appendChild(thumb);

		let img = document.createElement('img');
		img.classList.add('cached-thumb');
		img.style.display = 'none';
		thumb.appendChild(img);

		let canvas = document.createElement('canvas');
		canvas.setAttribute('moz-opaque', '');
		thumb.appendChild(canvas);

		let favicon = document.createElement('div');
		favicon.classList.add('favicon');
		favicon.appendChild(document.createElement('img'));
		div.appendChild(favicon);

		let span = document.createElement('span');
		span.classList.add('tab-title');
		span.textContent = ' ';
		div.appendChild(span);

		let close = document.createElement('div');
		close.classList.add('close');
		div.appendChild(close);

		this._fragment = document.createDocumentFragment();
		this._fragment.appendChild(div);

		return this._fragment;
	},

	// Checks whether the xul:tab has fully loaded and calls a callback with a boolean indicates whether the tab is loaded or not.
	_isComplete: function(tab, callback) {
		return new Promise(function(resolve, reject) {
			// A pending tab can't be complete, yet.
			if(tab.hasAttribute("pending")) {
				aSync(() => resolve(false));
				return;
			}

			let receiver = function(m) {
				Messenger.unlistenBrowser(tab.linkedBrowser, "isDocumentLoaded", receiver);
				resolve(m.data);
			};

			Messenger.listenBrowser(tab.linkedBrowser, "isDocumentLoaded", receiver);
			Messenger.messageBrowser(tab.linkedBrowser, "isDocumentLoaded");
		});
	},

	// Takes in a xul:tab.
	update: function(tab) {
		try {
			let shouldDefer =	this.isPaintingPaused()
						|| this._tabsWaitingForUpdate.hasItems()
						|| Date.now() - this._lastUpdateTime < this._heartbeatTiming;

			if(shouldDefer) {
				this._tabsWaitingForUpdate.push(tab);
				this.startHeartbeat();
			} else {
				this._update(tab);
			}
		}
		catch(ex) {
			Cu.reportError(ex);
		}
	},

	// Takes in a xul:tab.
	// Parameters:
	//   tab - a xul tab to update
	//   options - an object with additional parameters, see below
	// Possible options:
	//   force - true to always update the tab item even if it's incomplete
	_update: function(tab, options) {
		try {
			// ___ get the TabItem
			let tabItem = tab._tabViewTabItem;

			// Even if the page hasn't loaded, display the favicon and title
			FavIcons.getFavIconUrlForTab(tab, function(iconUrl) {
				let favImage = tabItem.$favImage[0];
				let fav = tabItem.$fav;
				if(iconUrl) {
					if(favImage.src != iconUrl) {
						favImage.src = iconUrl;
					}
					fav.show();
				} else {
					if(favImage.hasAttribute("src")) {
						favImage.removeAttribute("src");
					}
					fav.hide();
				}
				tabItem._sendToSubscribers("iconUpdated");
			});

			// ___ label
			let label = tab.label;
			let $name = tabItem.$tabTitle;
			if($name.text() != label) {
				$name.text(label);
			}

			// ___ remove from waiting list now that we have no other early returns
			this._tabsWaitingForUpdate.remove(tab);

			// ___ URL
			let tabUrl = tab.linkedBrowser.currentURI.spec;
			let tooltip = (label == tabUrl ? label : label + "\n" + tabUrl);
			tabItem.$container.attr("title", tooltip);

			// ___ Make sure the tab is complete and ready for updating.
			if(options && options.force) {
				tabItem.updateCanvas();
				tabItem._sendToSubscribers("updated");
			} else {
				this._isComplete(tab).then((isComplete) => {
					if(!Utils.isValidXULTab(tab) || tab.pinned) { return; }

					if(isComplete) {
						tabItem.updateCanvas();
						tabItem._sendToSubscribers("updated");
					} else {
						this._tabsWaitingForUpdate.push(tab);
					}
				});
			}
		}
		catch(ex) {
			Cu.reportError(ex);
		}
	},

	// Takes in a xul:tab, creates a TabItem for it and adds it to the scene.
	link: function(tab, options) {
		try {
			new TabItem(tab, options); // sets tab._tabViewTabItem to itself
		}
		catch(ex) {
			Cu.reportError(ex);
		}
	},

	// Takes in a xul:tab and destroys the TabItem associated with it.
	// note that it's ok to unlink an app tab; see .handleTabUnpin
	unlink: function(tab) {
		try {
			this.unregister(tab._tabViewTabItem);
			tab._tabViewTabItem._sendToSubscribers("close", tab._tabViewTabItem);
			tab._tabViewTabItem.$container.remove();
			tab._tabViewTabItem.removeTrenches();
			Items.unsquish(null, tab._tabViewTabItem);

			tab._tabViewTabItem.tab = null;
			tab._tabViewTabItem.tabCanvas.tab = null;
			tab._tabViewTabItem.tabCanvas = null;
			tab._tabViewTabItem = null;
			Storage.saveTab(tab, null);

			this._tabsWaitingForUpdate.remove(tab);
		}
		catch(ex) {
			Cu.reportError(ex);
		}
	},

	// when a tab becomes pinned, destroy its TabItem
	handleTabPin: function(xulTab) {
		this.unlink(xulTab);
	},

	// when a tab becomes unpinned, create a TabItem for it
	handleTabUnpin: function(xulTab) {
		this.link(xulTab);
		this.update(xulTab);
	},

	// Start a new heartbeat if there isn't one already started. The heartbeat is a chain of aSync calls that allows us to spread
	// out update calls over a period of time. We make sure not to add multiple aSync chains.
	startHeartbeat: function() {
		if(!Timers.heartbeat) {
			Timers.init('heartbeat', () => {
				this._checkHeartbeat();
			}, this._heartbeatTiming);
		}
	},

	// This periodically checks for tabs waiting to be updated, and calls _update on them.
	// Should only be called by startHeartbeat and resumePainting.
	_checkHeartbeat: function() {
		if(this.isPaintingPaused()) { return; }

		// restart the heartbeat to update all waiting tabs once the UI becomes idle
		if(!UI.isIdle()) {
			this.startHeartbeat();
			return;
		}

		let accumTime = 0;
		let items = this._tabsWaitingForUpdate.getItems();
		// Do as many updates as we can fit into a "perceived" amount of time, which is tunable.
		while(accumTime < this._maxTimeForUpdating && items.length) {
			let updateBegin = Date.now();
			this._update(items.pop());
			let updateEnd = Date.now();

			// Maintain a simple average of time for each tabitem update
			// We can use this as a base by which to delay things like tab zooming, so there aren't any hitches.
			let deltaTime = updateEnd - updateBegin;
			accumTime += deltaTime;
		}

		if(this._tabsWaitingForUpdate.hasItems()) {
			this.startHeartbeat();
		}
	},

	// Tells TabItems to stop updating thumbnails (so you can do animations without thumbnail paints causing stutters).
	// pausePainting can be called multiple times, but every call to pausePainting needs to be mirrored with a call to <resumePainting>.
	pausePainting: function() {
		this.paintingPaused++;
		if(Timers.heartbeat) {
			Timers.cancel('heartbeat');
		}
	},

	// Undoes a call to <pausePainting>. For instance, if you called pausePainting three times in a row, you'll need to call resumePainting
	// three times before TabItems will start updating thumbnails again.
	resumePainting: function() {
		this.paintingPaused--;
		if(!this.isPaintingPaused()) {
			this.startHeartbeat();
		}
	},

	// Returns a boolean indicating whether painting is paused or not.
	isPaintingPaused: function() {
		return this.paintingPaused > 0;
	},

	// Don't reconnect any new tabs until resume is called.
	pauseReconnecting: function() {
		this._reconnectingPaused = true;
	},

	// Reconnect all of the tabs that were created since we paused.
	resumeReconnecting: function() {
		this._reconnectingPaused = false;
		for(let item of this.items) {
			if(!item._reconnected) {
				item._reconnect();
			}
		}
	},

	// Returns true if reconnecting is paused.
	reconnectingPaused: function() {
		return this._reconnectingPaused;
	},

	// Adds the given <TabItem> to the master list.
	register: function(item) {
		if(this.items.indexOf(item) == -1) {
			this.items.push(item);
		}
	},

	// Removes the given <TabItem> from the master list.
	unregister: function(item) {
		let index = this.items.indexOf(item);
		if(index != -1) {
			this.items.splice(index, 1);
		}
	},

	// Returns a copy of the master array of <TabItem>s.
	getItems: function() {
		return Utils.copy(this.items);
	},

	// Saves all open <TabItem>s.
	saveAll: function() {
		let tabItems = this.getItems();

		tabItems.forEach(function(tabItem) {
			tabItem.save();
		});
	},

	// Private method that returns the fontsize to use given the tab's width
	getFontSizeFromWidth: function(width) {
		let widthRange = new Range(0, TabItems.tabWidth);
		let proportion = widthRange.proportion(width - TabItems.tabItemPadding.x, true);
		// proportion is in [0,1]
		return TabItems.fontSizeRange.scale(proportion);
	},

	// Private method that returns the tabitem width given a height.
	_getWidthForHeight: function(height) {
		return height * TabItems.invTabAspect;
	},

	// Private method that returns the tabitem height given a width.
	_getHeightForWidth: function(width) {
		return width * TabItems.tabAspect;
	},

	// Pass in a desired size, and receive a size based on proper title size and aspect ratio.
	calcValidSize: function(size, options) {
		let width = Math.max(TabItems.minTabWidth, size.x);
		let showTitle = !options || !options.hideTitle;
		let titleSize = showTitle ? TabItems.fontSizeRange.max : 0;
		let height = Math.max(TabItems.minTabHeight, size.y - titleSize);
		let retSize = new Point(width, height);

		if(size.x > -1) {
			retSize.y = this._getHeightForWidth(width);
		}
		if(size.y > -1) {
			retSize.x = this._getWidthForHeight(height);
		}

		if(size.x > -1 && size.y > -1) {
			if(retSize.x < size.x) {
				retSize.y = this._getHeightForWidth(retSize.x);
			} else {
				retSize.x = this._getWidthForHeight(retSize.y);
			}
		}

		if(showTitle) {
			retSize.y += titleSize;
		}

		return retSize;
	}
};

// Class: TabPriorityQueue - Container that returns tab items in a priority order
// Current implementation assigns tab to either a high priority or low priority queue, and toggles which queue items are popped from.
// This guarantees that high priority items which are constantly being added will not eclipse changes for lower priority items.
this.TabPriorityQueue = function() {};

this.TabPriorityQueue.prototype = {
	_low: [], // low priority queue
	_high: [], // high priority queue

	// Empty the update queue
	clear: function() {
		this._low = [];
		this._high = [];
	},

	// Return whether pending items exist
	hasItems: function() {
		return (this._low.length > 0) || (this._high.length > 0);
	},

	// Returns all queued items, ordered from low to high priority
	getItems: function() {
		return this._low.concat(this._high);
	},

	// Add an item to be prioritized
	push: function(tab) {
		// Push onto correct priority queue.
		// It's only low priority if it's in a stack, and isn't the top, and the stack isn't expanded.
		// If it already exists in the destination queue, leave it.
		// If it exists in a different queue, remove it first and push onto new queue.
		let item = tab._tabViewTabItem;
		if(item.parent && (item.parent.isStacked() && !item.parent.isTopOfStack(item) && !item.parent.expanded)) {
			let idx = this._high.indexOf(tab);
			if(idx != -1) {
				this._high.splice(idx, 1);
				this._low.unshift(tab);
			} else if(this._low.indexOf(tab) == -1) {
				this._low.unshift(tab);
			}
		}
		else {
			let idx = this._low.indexOf(tab);
			if(idx != -1) {
				this._low.splice(idx, 1);
				this._high.unshift(tab);
			} else if(this._high.indexOf(tab) == -1) {
				this._high.unshift(tab);
			}
		}
	},

	// Remove and return the next item in priority order
	pop: function() {
		if(this._high.length) {
			return this._high.pop();
		}
		if(this._low.length) {
			return this._low.pop();
		}
		return null;
	},

	// Return the next item in priority order, without removing it
	peek: function() {
		if(this._high.length) {
			return this._high[this._high.length-1];
		}
		if(this._low.length) {
			return this._low[this._low.length-1];
		}
		return null;
	},

	// Remove the passed item
	remove: function(tab) {
		let index = this._high.indexOf(tab);
		if(index != -1) {
			this._high.splice(index, 1);
		} else {
			index = this._low.indexOf(tab);
			if(index != -1) {
				this._low.splice(index, 1);
			}
		}
	}
};

// Class: TabCanvas - Takes care of the actual canvas for the tab thumbnail
this.TabCanvas = function(tab, canvas) {
	this.tab = tab;
	this.canvas = canvas;
};

this.TabCanvas.prototype = Utils.extend(new Subscribable(), {
	paint: function(evt) {
		let w = this.canvas.width;
		let h = this.canvas.height;
		if(!w || !h) { return; }

		let browser = this.tab.linkedBrowser;

		gPageThumbnails.captureToCanvas(browser, this.canvas, () => {
			this._sendToSubscribers("painted");
		});

		this.persist(browser);
	},

	persist(browser) {
		// capture to file, thumbnail service does not persist automatically when rendering to canvas
		gPageThumbnails.shouldStoreThumbnail(browser, (storeAllowed) => {
			if(storeAllowed) {
				// ifStale bails out early if there already is an existing thumbnail less than 2 days old
				// so this shouldn't cause excessive IO when a thumbnail is updated frequently
				gPageThumbnails.captureAndStoreIfStale(browser, () => {})
			}
		})
	},

	// Changing the dims of a canvas will clear it, so we don't want to do do this to a canvas we're currently displaying.
	// This method grabs a new thumbnail at the new dims and then copies it over to the displayed canvas.
	update: function(aWidth, aHeight) {
		let temp = gPageThumbnails.createCanvas(window);
		temp.width = aWidth;
		temp.height = aHeight;

		let browser = this.tab.linkedBrowser;

		gPageThumbnails.captureToCanvas(browser, temp, () => {
			let ctx = this.canvas.getContext('2d');
			this.canvas.width = aWidth;
			this.canvas.height = aHeight;
			try {
				ctx.drawImage(temp, 0, 0);
			}
			catch(ex if ex.name == "InvalidStateError") {
				// Can't draw if the canvas created by page thumbs isn't valid. This can happen during shutdown.
				return;
			}
			this._sendToSubscribers("painted");
		});

		this.persist(browser);
	},

	toImageData: function() {
		return this.canvas.toDataURL("image/png");
	}
});
