// VERSION 1.0.9

// Class: GroupItem - A single groupItem in the TabView window. Descended from <Item>.
// Note that it implements the <Subscribable> interface.
// Parameters:
//   listOfEls - an array of DOM elements for tabs to be added to this groupItem
//   options - various options for this groupItem (see below). In addition, gets passed to <add> along with the elements provided.
// Possible options:
//   id - specifies the groupItem's id; otherwise automatically generated
//   userSize - see <Item.userSize>; default is null
//   bounds - a <Rect>; otherwise based on the locations of the provided elements
//   container - a DOM element to use as the container for this groupItem; otherwise will create
//   title - the title for the groupItem; otherwise blank
//   focusTitle - focus the title's input field after creation
//   dontPush - true if this groupItem shouldn't push away or snap on creation; default is false
//   immediately - true if we want all placement immediately, not with animation
this.GroupItem = function(listOfEls, options) {
	if(!options) {
		options = {};
	}

	this._inited = false;
	this._uninited = false;
	this._children = []; // an array of Items
	this.isAGroupItem = true;
	this.id = options.id || GroupItems.getNextID();
	this._isStacked = false;
	this.expanded = null;
	this.hidden = false;
	this.fadeAwayUndoButtonDelay = 15000;
	this.fadeAwayUndoButtonDuration = 300;

	this.keepProportional = false;
	this._frozenItemSizeData = {};

	this._onChildClose = this._onChildClose.bind(this);

	// The <TabItem> for the groupItem's active tab.
	this._activeTab = null;

	if(Utils.isPoint(options.userSize)) {
		this.userSize = new Point(options.userSize);
	}

	let rectToBe;
	if(options.bounds) {
		rectToBe = new Rect(options.bounds);
	}

	if(!rectToBe) {
		rectToBe = GroupItems.getBoundingBox(listOfEls);
		rectToBe.inset(-42, -42);
	}

	let immediately = !!options.immediately;
	let $container = iQ('<div>')
		.addClass('groupItem')
		.css({ position: 'absolute' })
		.css(rectToBe);

	this.bounds = $container.bounds();

	this.isDragging = false;
	$container
		.css({ zIndex: -100 })
		.attr("data-id", this.id)
		.appendTo("body");

	// ___ Resizer
	this.$resizer = iQ("<div>")
		.addClass('resizer')
		.appendTo($container)
		.hide();

	// ___ Titlebar
	this.$titlebar = iQ('<div>')
		.addClass('titlebar')
		.appendTo($container);

	let tbContainer = iQ('<div>')
		.addClass('title-container')
		.appendTo(this.$titlebar);

	let tbInput = iQ('<input>')
		.addClass('name')
		.appendTo(tbContainer);

	let tbShield = iQ('<div>')
		.addClass('title-shield')
		.appendTo(tbContainer);

	this.$closeButton = iQ('<div>')
		.addClass('close')
		.click(() => {
			this.closeAll();
		})
		.attr("title", Strings.get("TabView", "groupItemCloseGroup"))
		.appendTo($container);

	// ___ Title
	this.$titleContainer = iQ('.title-container', this.$titlebar);
	this.$title = iQ('.name', this.$titlebar).attr('placeholder', this.defaultName);
	this.$titleShield = iQ('.title-shield', this.$titlebar);
	this.setTitle(options.title);

	let handleKeyPress = (e) => {
		if(e.keyCode == e.DOM_VK_ESCAPE || e.keyCode == e.DOM_VK_RETURN) {
			this.$title[0].blur();
			this.$title
				.addClass("transparentBorder")
				.one("mouseout", () => {
					this.$title.removeClass("transparentBorder");
				});
			e.stopPropagation();
			e.preventDefault();
		}
	};

	let handleKeyUp = (e) => {
		// NOTE: When user commits or cancels IME composition, the last key event fires only a keyup event.
		// Then, we shouldn't take any reactions but we should update our status.
		this.save();
	};

	this.$title
		.blur(() => {
			this._titleFocused = false;
			this.$title[0].setSelectionRange(0, 0);
			this.$titleShield.show();
			this.save();
		})
		.focus(() => {
			this._unfreezeItemSize();
			if(!this._titleFocused) {
				this.$title[0].select();
				this._titleFocused = true;
			}
		})
		.mousedown(function(e) {
			e.stopPropagation();
		})
		.keypress(handleKeyPress)
		.keyup(handleKeyUp)
		.attr("title", Strings.get("TabView", "groupItemDefaultName"));

	this.$titleShield
		.mousedown((e) => {
			this.lastMouseDownTarget = (e.button == 0 ? e.target : null);
		})
		.mouseup((e) => {
			let same = (e.target == this.lastMouseDownTarget);
			this.lastMouseDownTarget = null;
			if(!same) { return; }

			if(!this.isDragging) {
				this.focusTitle();
			}
		})
		.attr("title", Strings.get("TabView", "groupItemDefaultName"));

	if(options.focusTitle) {
		this.focusTitle();
	}

	// ___ Stack Expander
	this.$expander = iQ("<div/>")
		.addClass("stackExpander")
		.appendTo($container)
		.hide();

	// ___ app tabs: create app tab tray and populate it
	let appTabTrayContainer = iQ("<div/>")
		.addClass("appTabTrayContainer")
		.appendTo($container);
	this.$appTabTray = iQ("<div/>")
		.addClass("appTabTray")
		.appendTo(appTabTrayContainer);

	let pinnedTabCount = gBrowser._numPinnedTabs;
	AllTabs.tabs.forEach((xulTab, index) => {
		// only adjust tray when it's the last app tab.
		if(xulTab.pinned) {
			this.addAppTab(xulTab, { dontAdjustTray: index + 1 < pinnedTabCount });
		}
	}, this);

	// ___ Undo Close
	this.$undoContainer = null;

	// ___ Superclass initialization
	this._init($container[0]);

	// ___ Children
	// We explicitly set dontArrange=true to prevent the groupItem from re-arranging its children after a tabItem has been added.
	// This saves us a group.arrange() call per child and therefore some tab.setBounds() calls.
	options.dontArrange = true;
	listOfEls.forEach((el) => {
		this.add(el, options);
	});

	// ___ Finish Up
	this._addHandlers($container);

	this.setResizable(true, immediately);

	GroupItems.register(this);

	// ___ Position
	this.setBounds(rectToBe, immediately);
	if(options.dontPush) {
		this.setZ(drag.zIndex);
		drag.zIndex++;
	} else {
		// Calling snap will also trigger pushAway
		this.snap(immediately);
	}

	if(!options.immediately && listOfEls.length) {
		$container.hide().fadeIn();
	}

	this._inited = true;
	this.save();

	GroupItems.updateGroupCloseButtons();
};

this.GroupItem.prototype = (!this.Item) ? null : Utils.extend(new Item(), new Subscribable(), {
	// The prompt text for the title field.
	defaultName: Strings.get("TabView", "groupItemDefaultName"),

	// Sets the active <TabItem> for this groupItem; can be null, but only if there are no children.
	setActiveTab: function(tab) {
		this._activeTab = tab;

		if(this.isStacked()) {
			this.arrange({ immediately: true });
		}
	},

	// Gets the active <TabItem> for this groupItem; can be null, but only if there are no children.
	getActiveTab: function() {
		return this._activeTab;
	},

	// Returns all of the info worth storing about this groupItem.
	getStorageData: function() {
		let data = {
			bounds: this.getBounds(),
			userSize: null,
			title: this.getTitle(),
			id: this.id
		};

		if(Utils.isPoint(this.userSize)) {
			data.userSize = new Point(this.userSize);
		}

		return data;
	},

	// Returns true if the tab groupItem is empty and unnamed.
	isEmpty: function() {
		return !this._children.length && !this.getTitle();
	},

	// Returns true if this item is in a stacked groupItem.
	isStacked: function() {
		return this._isStacked;
	},

	// Returns true if the item is showing on top of this group's stack, determined by whether the tab is this group's topChild,
	// or if it doesn't have one, its first child.
	isTopOfStack: function(item) {
		return this.isStacked() && item == this.getTopChild();
	},

	// Saves this groupItem to persistent storage.
	save: function() {
		// too soon/late to save
		if(!this._inited || this._uninited) { return; }

		let data = this.getStorageData();
		if(GroupItems.storageSanityGroupItem(data)) {
			Storage.saveGroupItem(gWindow, data);
		}
	},

	// Deletes the groupItem in the persistent storage.
	deleteData: function() {
		this._uninited = true;
		Storage.deleteGroupItem(gWindow, this.id);
	},

	// Returns the title of this groupItem as a string.
	getTitle: function() {
		return this.$title ? this.$title.val() : '';
	},

	// Sets the title of this groupItem with the given string
	setTitle: function(value) {
		this.$title.val(value);
		this.save();
	},

	// Hide the title's shield and focus the underlying input field.
	focusTitle: function() {
		this.$titleShield.hide();
		this.$title[0].focus();
	},

	// Used to adjust the appTabTray size, to split the appTabIcons across multiple columns when needed - if the groupItem size is too small.
	// Parameters:
	//   arrangeGroup - rearrange the groupItem if the number of appTab columns changes. If true, then this.arrange() is called, otherwise not.
	adjustAppTabTray: function(arrangeGroup) {
		let icons = iQ(".appTabIcon", this.$appTabTray);
		let container = iQ(this.$appTabTray[0].parentNode);
		if(!icons.length) {
			// There are no icons, so hide the appTabTray if needed.
			if(parseInt(container.css("width")) != 0) {
				this.$appTabTray.css("-moz-column-count", "auto");
				this.$appTabTray.css("height", 0);
				container.css("width", 0);
				container.css("height", 0);

				if(container.hasClass("appTabTrayContainerTruncated")) {
					container.removeClass("appTabTrayContainerTruncated");
				}

				if(arrangeGroup) {
					this.arrange();
				}
			}
			return;
		}

		let iconBounds = iQ(icons[0]).bounds();
		let boxBounds = this.getBounds();
		let contentHeight = boxBounds.height -parseInt(container.css("top")) -this.$resizer.height();
		let rows = Math.floor(contentHeight /iconBounds.height);
		let columns = Math.ceil(icons.length /rows);
		let columnsGap = parseInt(this.$appTabTray.css("-moz-column-gap"));
		let iconWidth = iconBounds.width +columnsGap;
		let maxColumns = Math.floor((boxBounds.width * 0.20) / iconWidth);

		if(columns > maxColumns) {
			container.addClass("appTabTrayContainerTruncated");
		} else if(container.hasClass("appTabTrayContainerTruncated")) {
			container.removeClass("appTabTrayContainerTruncated");
		}

		// Need to drop the -moz- prefix when Gecko makes it obsolete.
		// See bug 629452.
		if(parseInt(this.$appTabTray.css("-moz-column-count")) != columns) {
			this.$appTabTray.css("-moz-column-count", columns);
		}

		if(parseInt(this.$appTabTray.css("height")) != contentHeight) {
			this.$appTabTray.css("height", contentHeight + "px");
			container.css("height", contentHeight + "px");
		}

		let fullTrayWidth = iconWidth * columns - columnsGap;
		if(parseInt(this.$appTabTray.css("width")) != fullTrayWidth) {
			this.$appTabTray.css("width", fullTrayWidth + "px");
		}

		let trayWidth = iconWidth * Math.min(columns, maxColumns) - columnsGap;
		if(parseInt(container.css("width")) != trayWidth) {
			container.css("width", trayWidth + "px");

			// Rearrange the groupItem if the width changed.
			if(arrangeGroup) {
				this.arrange();
			}
		}
	},

	// Returns a <Rect> for the groupItem's content area (which doesn't include the title, etc).
	// Parameters:
	//   options - an object with additional parameters, see below
	// Possible options:
	//   stacked - true to get content bounds for stacked mode
	getContentBounds: function(options) {
		let box = this.getBounds();
		let titleHeight = this.$titlebar.height();
		box.top += titleHeight;
		box.height -= titleHeight;

		let appTabTrayContainer = iQ(this.$appTabTray[0].parentNode);
		let appTabTrayWidth = appTabTrayContainer.width();
		if(appTabTrayWidth) {
			appTabTrayWidth += parseInt(appTabTrayContainer.css(UI.rtl ? "left" : "right"));
		}

		box.width -= appTabTrayWidth;
		if(UI.rtl) {
			box.left += appTabTrayWidth;
		}

		// Make the computed bounds' "padding" and expand button margin actually be themeable --OR-- compute this from actual bounds. Bug 586546
		box.inset(6, 6);

		// make some room for the expand button in stacked mode
		if(options && options.stacked) {
			box.height -= this.$expander.height() + 9; // the button height plus padding
		}

		return box;
	},

	// Sets the bounds with the given <Rect>, animating unless "immediately" is false.
	// Parameters:
	//   inRect - a <Rect> giving the new bounds
	//   immediately - true if it should not animate; default false
	//   options - an object with additional parameters, see below
	// Possible options:
	//   force - true to always update the DOM even if the bounds haven't changed; default false
	setBounds: function(inRect, immediately, options) {
		// Validate and conform passed in size
		let validSize = GroupItems.calcValidSize(new Point(inRect.width, inRect.height));
		let rect = new Rect(inRect.left, inRect.top, validSize.x, validSize.y);

		if(!options) {
			options = {};
		}

		let titleHeight = this.$titlebar.height();

		// ___ Determine what has changed
		let css = {};
		let titlebarCSS = {};
		let contentCSS = {};

		if(rect.left != this.bounds.left || options.force) {
			css.left = rect.left;
		}

		if(rect.top != this.bounds.top || options.force) {
			css.top = rect.top;
		}

		if(rect.width != this.bounds.width || options.force) {
			css.width = rect.width;
			titlebarCSS.width = rect.width;
			contentCSS.width = rect.width;
		}

		if(rect.height != this.bounds.height || options.force) {
			css.height = rect.height;
			contentCSS.height = rect.height - titleHeight;
		}

		if(Utils.isEmptyObject(css)) { return; }

		let offset = new Point(rect.left - this.bounds.left, rect.top - this.bounds.top);
		this.bounds = new Rect(rect);

		// Make sure the AppTab icons fit the new groupItem size.
		if(css.width || css.height) {
			this.adjustAppTabTray();
		}

		// ___ Deal with children
		if(css.width || css.height) {
			this.arrange({ animate: !immediately });
		} else if(css.left || css.top) {
			for(let child of this._children) {
				if(!child.getHidden()) {
					let box = child.getBounds();
					child.setPosition(box.left + offset.x, box.top + offset.y, immediately);
				}
			}
		}

		// ___ Update our representation
		if(immediately) {
			iQ(this.container).css(css);
			this.$titlebar.css(titlebarCSS);
		} else {
			TabItems.pausePainting();
			iQ(this.container).animate(css, {
				duration: 350,
				easing: "tabviewBounce",
				complete: function() {
					TabItems.resumePainting();
				}
			});

			this.$titlebar.animate(titlebarCSS, {
				duration: 350
			});
		}

		UI.clearShouldResizeItems();
		this.setTrenches(rect);
		this.save();
	},

	// Set the Z order for the groupItem's container, as well as its children.
	setZ: function(value) {
		this.zIndex = value;

		iQ(this.container).css({ zIndex: value });

		let count = this._children.length;
		if(count) {
			let topZIndex = value +count +1;
			let zIndex = topZIndex;
			for(let child of this._children) {
				if(child == this.getTopChild()) {
					child.setZ(topZIndex + 1);
				} else {
					child.setZ(zIndex);
					zIndex--;
				}
			}
		}
	},

	// Closes the groupItem, removing (but not closing) all of its children.
	// Parameters:
	//   options - An object with optional settings for this call.
	// Options:
	//   immediately - (bool) if true, no animation will be used
	close: function(options) {
		this.removeAll({ dontClose: true });
		GroupItems.unregister(this);

		// remove unfreeze event handlers, if item size is frozen
		this._unfreezeItemSize({dontArrange: true });

		let destroyGroup = () => {
			iQ(this.container).remove();
			if(this.$undoContainer) {
				this.$undoContainer.remove();
				this.$undoContainer = null;
			}
			this.removeTrenches();
			Items.unsquish();
			this._sendToSubscribers("close");
			GroupItems.updateGroupCloseButtons();
		};

		if(this.hidden || (options && options.immediately)) {
			destroyGroup();
		} else {
			iQ(this.container).animate({
				opacity: 0,
				"transform": "scale(.3)",
			}, {
				duration: 170,
				complete: destroyGroup
			});
		}

		this.deleteData();
	},

	// Closes the groupItem and all of its children.
	closeAll: function() {
		if(this._children.length) {
			this._unfreezeItemSize();
			for(let child of this._children) {
				iQ(child.container).hide();
			}

			let container = iQ(this.container);
			container.animate({
				opacity: 0,
				"transform": "scale(.3)",
			}, {
				duration: 170,
				complete: function() {
					container.hide();
				}
			});

			this.droppable(false);
			this.removeTrenches();
			this._createUndoButton();
		}
		else {
			this.close();
		}

		this._makeLastActiveGroupItemActive();
	},

	// Make the closest tab external to this group active. Used when closing the group.
	_makeClosestTabActive: function() {
		let closeCenter = this.getBounds().center();

		// Find closest tab to make active
		let closestTabItem = UI.getClosestTab(closeCenter);
		if(closestTabItem) {
			UI.setActive(closestTabItem);
		}
	},

	// Makes the last active group item active.
	_makeLastActiveGroupItemActive: function() {
		let groupItem = GroupItems.getLastActiveGroupItem();
		if(groupItem) {
			UI.setActive(groupItem);
		} else {
			this._makeClosestTabActive();
		}
	},

	// Closes the group if it's empty, is closable, and autoclose is enabled (see pauseAutoclose()).
	// Returns true if the close occurred and false otherwise.
	closeIfEmpty: function() {
		if(this.isEmpty()
		&& !UI._closedLastVisibleTab
		&& !GroupItems.getUnclosableGroupItemId()
		&& !GroupItems._autoclosePaused) {
			this.close();
			return true;
		}
		return false;
	},

	// Shows the hidden group.
	// Parameters:
	//   options - various options (see below)
	// Possible options:
	//   immediately - true when no animations should be used
	_unhide: function(options) {
		this._cancelFadeAwayUndoButtonTimer();
		this.hidden = false;
		this.$undoContainer.remove();
		this.$undoContainer = null;
		this.droppable(true);
		this.setTrenches(this.bounds);

		let finalize = () => {
			for(let child of this._children) {
				iQ(child.container).show();
			}

			UI.setActive(this);
			this._sendToSubscribers("groupShown");
		};

		let $container = iQ(this.container).show();

		if(!options || !options.immediately) {
			$container.animate({
				"transform": "scale(1)",
				"opacity": 1
			}, {
				duration: 170,
				complete: finalize
			});
		} else {
			$container.css({ "transform": "none", opacity: 1 });
			finalize();
		}

		GroupItems.updateGroupCloseButtons();
	},

	// Function: closeHidden
	// Removes the group item, its children and its container.
	closeHidden: function() {
		this._cancelFadeAwayUndoButtonTimer();

		// When the last non-empty groupItem is closed and there are no pinned tabs then create a new group with a blank tab.
		let remainingGroups = GroupItems.groupItems.filter((groupItem) => {
			return (groupItem != this && groupItem.getChildren().length);
		});

		let tab = null;

		if(!gBrowser._numPinnedTabs && !remainingGroups.length) {
			let emptyGroups = GroupItems.groupItems.filter((groupItem) => {
				return (groupItem != this && !groupItem.getChildren().length);
			});
			let group = (emptyGroups.length ? emptyGroups[0] : GroupItems.newGroup());
			tab = group.newTab(null, { dontZoomIn: true });
		}

		let closed = this.destroy();

		if(!tab) { return; }

		if(closed) {
			// Let's make the new tab the selected tab.
			UI.goToTab(tab);
		} else {
			// Remove the new tab and group, if this group is no longer closed.
			tab._tabViewTabItem.parent.destroy({ immediately: true });
		}
	},

	// Close all tabs linked to children (tabItems), removes all children and close the groupItem.
	// Parameters:
	//   options - An object with optional settings for this call.
	// Options:
	//   immediately - (bool) if true, no animation will be used
	// Returns true if the groupItem has been closed, or false otherwise.
	// A group could not have been closed due to a tab with an onUnload handler (that waits for user interaction).
	destroy: function(options) {
		// when "TabClose" event is fired, the browser tab is about to close and our item "close" event is fired. And then, the browser tab gets closed.
		// In other words, the group "close" event is fired before all browser tabs in the group are closed.
		// The below code would fire the group "close" event only after all browser tabs in that group are closed.
		for(let child of this._children.concat()) {
			child.removeSubscriber("close", this._onChildClose);

			if(child.close(true)) {
				this.remove(child, { dontArrange: true });
			} else {
				// child.removeSubscriber() must be called before child.close(),
				// therefore we call child.addSubscriber() if the tab is not removed.
				child.addSubscriber("close", this._onChildClose);
			}
		}

		if(this._children.length) {
			if(this.hidden) {
				this.$undoContainer.fadeOut(() => { this._unhide() });
			}

			return false;
		} else {
			this.close(options);
			return true;
		}
	},

	// Fades away the undo button
	_fadeAwayUndoButton: function() {
		if(this.$undoContainer) {
			// if there is more than one group and other groups are not empty, fade away the undo button.
			let shouldFadeAway = false;

			if(GroupItems.groupItems.length > 1) {
				shouldFadeAway = GroupItems.groupItems.some((groupItem) => {
					return (groupItem != this && groupItem.getChildren().length > 0);
				});
			}

			if(shouldFadeAway) {
				this.$undoContainer.animate({
					color: "transparent",
					opacity: 0
				}, {
					duration: this._fadeAwayUndoButtonDuration,
					complete: () => { this.closeHidden(); }
				});
			}
		}
	},

	// Makes the affordance for undo a close group action
	_createUndoButton: function() {
		this.$undoContainer = iQ("<div/>")
			.addClass("undo")
			.attr("type", "button")
			.attr("data-group-id", this.id)
			.appendTo("body");
		iQ("<span/>")
			.text(Strings.get("TabView", "groupItemUndoCloseGroup"))
			.appendTo(this.$undoContainer);
		let undoClose = iQ("<span/>")
			.addClass("close")
			.attr("title", Strings.get("TabView", "groupItemDiscardClosedGroup"))
			.appendTo(this.$undoContainer);

		this.$undoContainer.css({
			left: this.bounds.left + this.bounds.width /2 - iQ(this.$undoContainer).width() /2,
			top:  this.bounds.top + this.bounds.height /2 - iQ(this.$undoContainer).height() /2,
			"transform": "scale(.1)",
			opacity: 0
		});
		this.hidden = true;

		// hide group item and show undo container.
		aSync(() => {
			this.$undoContainer.animate({
				"transform": "scale(1)",
				"opacity": 1
			}, {
				easing: "tabviewBounce",
				duration: 170,
				complete: () => {
					this._sendToSubscribers("groupHidden");
				}
			});
		}, 50);

		// add click handlers
		this.$undoContainer.click((e) => {
			// don't do anything if the close button is clicked.
			if(e.target == undoClose[0]) {
				return;
			}

			this.$undoContainer.fadeOut(() => { this._unhide(); });
		});

		undoClose.click(() => {
			this.$undoContainer.fadeOut(() => { this.closeHidden(); });
		});

		this.setupFadeAwayUndoButtonTimer();

		// Cancel the fadeaway if you move the mouse over the undo button, and restart the countdown once you move out of it.
		this.$undoContainer.mouseover(() => {
			this._cancelFadeAwayUndoButtonTimer();
		});
		this.$undoContainer.mouseout(() => {
			this.setupFadeAwayUndoButtonTimer();
		});

		GroupItems.updateGroupCloseButtons();
	},

	// Sets up fade away undo button timeout.
	setupFadeAwayUndoButtonTimer: function() {
		if(!Timers.undoButton) {
			Timers.init("undoButton", () => {
				this._fadeAwayUndoButton();
			}, this.fadeAwayUndoButtonDelay);
		}
	},

	// Cancels the fade away undo button timeout.
	_cancelFadeAwayUndoButtonTimer: function() {
		Timers.cancel("undoButton");
	},

	// Adds an item to the groupItem.
	// Parameters:
	//   a - The item to add. Can be an <Item>, a DOM element or an iQ object. The latter two must refer to the container of an <Item>.
	//   options - An object with optional settings for this call.
	// Options:
	//   index - (int) if set, add this tab at this index
	//   immediately - (bool) if true, no animation will be used
	//   dontArrange - (bool) if true, will not trigger an arrange on the group
	add: function(a, options) {
		try {
			let item;
			let $el;
			if(a.isAnItem) {
				item = a;
				$el = iQ(a.container);
			} else {
				$el = iQ(a);
				item = Items.item($el);
			}

			// safeguard to remove the item from its previous group
			if(item.parent && item.parent !== this) {
				item.parent.remove(item);
			}

			item.removeTrenches();

			if(!options) {
				options = {};
			}

			let wasAlreadyInThisGroupItem = false;
			let oldIndex = this._children.indexOf(item);
			if(oldIndex != -1) {
				this._children.splice(oldIndex, 1);
				wasAlreadyInThisGroupItem = true;
			}

			// Insert the tab into the right position.
			let index = ("index" in options) ? options.index : this._children.length;
			this._children.splice(index, 0, item);

			item.setZ(this.getZ() + 1);

			if(!wasAlreadyInThisGroupItem) {
				item.droppable(false);
				item.groupItemData = {};

				item.addSubscriber("close", this._onChildClose);
				item.setParent(this);
				$el.attr("data-group-id", this.id);

				if(typeof item.setResizable == 'function') {
					item.setResizable(false, options.immediately);
				}

				if(item == UI.getActiveTab() || !this._activeTab) {
					this.setActiveTab(item);
				}

				// if it matches the selected tab or no active tab and the browser tab is hidden, the active group item would be set.
				if(item.tab.selected || (!GroupItems.getActiveGroupItem() && !item.tab.hidden)) {
					UI.setActive(this);
				}
			}

			if(!options.dontArrange) {
				this.arrange({ animate: !options.immediately });
			}

			this._unfreezeItemSize({ dontArrange: true });
			this._sendToSubscribers("childAdded", { item: item });

			UI.setReorderTabsOnHide(this);
		}
		catch(ex) {
			Cu.reportError(ex);
		}
	},

	// Handles "close" events from the group's children.
	// Parameters:
	//   tabItem - The tabItem that is closed.
	_onChildClose: function(tabItem) {
		let count = this._children.length;
		let dontArrange = tabItem.closedManually && (this.expanded || !this.shouldStack(count));
		let dontClose = !tabItem.closedManually && gBrowser._numPinnedTabs;
		this.remove(tabItem, { dontArrange: dontArrange, dontClose: dontClose });

		if(dontArrange) {
			this._freezeItemSize(count);
		}

		if(this._children.length && this._activeTab && tabItem.closedManually) {
			UI.setActive(this);
		}
	},

	// Removes an item from the groupItem.
	// Parameters:
	//   a - The item to remove. Can be an <Item>, a DOM element or an iQ object. The latter two must refer to the container of an <Item>.
	//   options - An optional object with settings for this call. See below.
	// Possible options:
	//   dontArrange - don't rearrange the remaining items
	//   dontClose - don't close the group even if it normally would
	//   immediately - don't animate
	remove: function(a, options) {
		try {
			let $el;
			let item;

			if(a.isAnItem) {
				item = a;
				$el = iQ(item.container);
			} else {
				$el = iQ(a);
				item = Items.item($el);
			}

			if(!options) {
				options = {};
			}

			let index = this._children.indexOf(item);
			let prevIndex = 0;
			if(index != -1) {
				this._children.splice(index, 1);
				prevIndex = Math.max(0, index -1);
			}

			if(item == this._activeTab || !this._activeTab) {
				if(this._children.length) {
					this._activeTab = this._children[prevIndex];
				} else {
					this._activeTab = null;
				}
			}

			$el[0].removeAttribute("data-group-id");
			item.setParent(null);
			item.removeClass("stacked");
			item.isStacked = false;
			item.setHidden(false);
			item.removeClass("stack-trayed");
			item.setRotation(0);

			// Force tabItem resize if it's dragged out of a stacked groupItem.
			// The tabItems's title will be visible and that's why we need to recalculate its height.
			if(item.isDragging && this.isStacked()) {
				item.setBounds(item.getBounds(), true, { force: true });
			}

			item.droppable(true);
			item.removeSubscriber("close", this._onChildClose);

			if(typeof item.setResizable == 'function') {
				item.setResizable(true, options.immediately);
			}

			// if a blank tab is selected while restoring a tab the blank tab gets removed. we need to keep the group alive for the restored tab.
			if(item.isRemovedAfterRestore) {
				options.dontClose = true;
			}

			let closed = options.dontClose ? false : this.closeIfEmpty();
			if(closed || (!this._children.length && !gBrowser._numPinnedTabs && !item.isDragging)) {
				this._makeLastActiveGroupItemActive();
			} else if(!options.dontArrange) {
				this.arrange({ animate: !options.immediately });
				this._unfreezeItemSize({ dontArrange: true });
			}
		}
		catch(ex) {
			Cu.reportError(ex);
		}
	},

	// Removes all of the groupItem's children. The optional "options" param is passed to each remove call.
	removeAll: function(options) {
		let newOptions = { dontArrange: true };
		if(options) {
			Utils.extend(newOptions, options);
		}

		for(let child of this._children.concat()) {
			this.remove(child, newOptions);
		}
	},

	// Adds the given xul:tab as an app tab in this group's apptab tray
	// Parameters:
	//   xulTab - the xul:tab.
	//   options - change how the app tab is added.
	// Options:
	//   position - the position of the app tab should be added to.
	//   dontAdjustTray - (boolean) if true, do not adjust the tray.
	addAppTab: function(xulTab, options) {
		GroupItems.getAppTabFavIconUrl(xulTab, (iconUrl) => {
			// The tab might have been removed or unpinned while waiting.
			if(!Utils.isValidXULTab(xulTab) || !xulTab.pinned) { return; }

			let $appTab = iQ("<img>")
				.addClass("appTabIcon")
				.attr("src", iconUrl)
				.data("xulTab", xulTab)
				.mousedown(function(event) {
					// stop mousedown propagation to disable group dragging on app tabs
					event.stopPropagation();
				})
				.click((e) => {
					if(e.button != 0) { return; }

					UI.setActive(this, { dontSetActiveTabInGroup: true });
					UI.goToTab($appTab.data("xulTab"));
				});

			if(options && "position" in options) {
				let children = this.$appTabTray[0].childNodes;

				if(options.position >= children.length) {
					$appTab.appendTo(this.$appTabTray);
				} else {
					this.$appTabTray[0].insertBefore($appTab[0], children[options.position]);
				}
			} else {
				$appTab.appendTo(this.$appTabTray);
			}
			if(!options || !options.dontAdjustTray) {
				this.adjustAppTabTray(true);
			}

			this._sendToSubscribers("appTabIconAdded", { item: $appTab });
		});
	},

	// Removes the given xul:tab as an app tab in this group's apptab tray
	removeAppTab: function(xulTab) {
		// remove the icon
		iQ(".appTabIcon", this.$appTabTray).each(function(icon) {
			let $icon = iQ(icon);
			if($icon.data("xulTab") != xulTab) {
				return true;
			}

			$icon.remove();
			return false;
		});

		// adjust the tray
		this.adjustAppTabTray(true);
	},

	// Arranges the given xul:tab as an app tab in the group's apptab tray
	arrangeAppTab: function(xulTab) {
		let elements = iQ(".appTabIcon", this.$appTabTray);
		let length = elements.length;

		elements.each((icon) => {
			let $icon = iQ(icon);
			if($icon.data("xulTab") != xulTab) {
				return true;
			}

			let targetIndex = xulTab._tPos;

			$icon.remove({ preserveEventHandlers: true });
			if(targetIndex < (length - 1)) {
				this.$appTabTray[0].insertBefore(icon, iQ(".appTabIcon:nth-child(" + (targetIndex + 1) + ")", this.$appTabTray)[0]);
			} else {
				$icon.appendTo(this.$appTabTray);
			}
			return false;
		});
	},

	// Hide the control which expands a stacked groupItem into a quick-look view.
	hideExpandControl: function() {
		this.$expander.hide();
	},

	// Show the control which expands a stacked groupItem into a quick-look view.
	showExpandControl: function() {
		let parentBB = this.getBounds();
		let childBB = this.getChild(0).getBounds();
		this.$expander
			.show()
			.css({
				left: parentBB.width /2 - this.$expander.width() /2
			});
	},

	// Returns true if the groupItem, given "count", should stack (instead of grid).
	shouldStack: function(count) {
		let bb = this.getContentBounds();
		let options = {
			return: 'widthAndColumns',
			count: count || this._children.length,
			hideTitle: false
		};
		let arrObj = Items.arrange(this._children, bb, options);

		let shouldStack = arrObj.childWidth < TabItems.minTabWidth * 1.35;
		this._columns = shouldStack ? null : arrObj.columns;

		return shouldStack;
	},

	// Freezes current item size (when removing a child).
	// Parameters:
	//   itemCount - the number of children before the last one was removed
	_freezeItemSize: function(itemCount) {
		let data = this._frozenItemSizeData;

		if(!data.lastItemCount) {
			data.lastItemCount = itemCount;

			// unfreeze item size when tabview is hidden
			data.onTabViewHidden = () => this._unfreezeItemSize();
			window.addEventListener('tabviewhidden', data.onTabViewHidden, false);

			// we don't need to observe mouse movement when expanded because the tray is closed when we leave it and collapse causes unfreezing
			if(!this.expanded) {
				// unfreeze item size when cursor is moved out of group bounds
				data.onMouseMove = (e) => {
					let cursor = new Point(e.pageX, e.pageY);
					if(!this.bounds.contains(cursor)) {
						this._unfreezeItemSize();
					}
				}
				iQ(window).mousemove(data.onMouseMove);
			}
		}

		this.arrange({ animate: true, count: data.lastItemCount });
	},

	// Unfreezes and updates item size.
	// Parameters:
	//   options - various options (see below)
	// Possible options:
	//   dontArrange - do not arrange items when unfreezing
	_unfreezeItemSize: function(options) {
		let data = this._frozenItemSizeData;
		if(!data.lastItemCount) { return; }

		if(!options || !options.dontArrange) {
			this.arrange({ animate: true });
		}

		// unbind event listeners
		window.removeEventListener('tabviewhidden', data.onTabViewHidden, false);
		if(data.onMouseMove) {
			iQ(window).unbind('mousemove', data.onMouseMove);
		}

		// reset freeze status
		this._frozenItemSizeData = {};
	},

	// Lays out all of the children.
	// Parameters:
	//   options - passed to <Items.arrange> or <_stackArrange>, except those below
	// Options:
	//   addTab - (boolean) if true, we add one to the child count
	//   oldDropIndex - if set, we will only set any bounds if the dropIndex has changed
	//   dropPos - (<Point>) a position where a tab is currently positioned, above this group.
	//   animate - (boolean) if true, movement of children will be animated.
	// Returns:
	//   dropIndex - an index value for where an item would be dropped, if options.dropPos is given.
	arrange: function(options) {
		if(!options) {
			options = {};
		}

		let childrenToArrange = [];
		for(let child of this._children) {
			if(child.isDragging) {
				options.addTab = true;
			} else {
				childrenToArrange.push(child);
			}
		}

		if(GroupItems._arrangePaused) {
			GroupItems.pushArrange(this, options);
			return false;
		}

		let shouldStack = this.shouldStack(childrenToArrange.length + (options.addTab ? 1 : 0));
		let shouldStackArrange = (shouldStack && !this.expanded);
		let box;

		// if we should stack and we're not expanded
		if(shouldStackArrange) {
			this.showExpandControl();
			box = this.getContentBounds({ stacked: true });
			this._stackArrange(childrenToArrange, box, options);
			return false;
		} else {
			this.hideExpandControl();
			box = this.getContentBounds();
			// a dropIndex is returned
			return this._gridArrange(childrenToArrange, box, options);
		}
	},

	// Arranges the children in a stack.
	// Parameters:
	//   childrenToArrange - array of <TabItem> children
	//   bb - <Rect> to arrange within
	//   options - see below
	// Possible "options" properties:
	//   animate - whether to animate; default: true.
	_stackArrange: function(childrenToArrange, bb, options) {
		if(!options) {
			options = {};
		}
		let animate = "animate" in options ? options.animate : true;

		let count = childrenToArrange.length;
		if(!count) { return; }

		let itemAspect = TabItems.tabHeight / TabItems.tabWidth;
		let zIndex = this.getZ() + count + 1;
		let maxRotation = 35; // degress
		let scale = 0.7;
		let newTabsPad = 10;
		let bbAspect = bb.height / bb.width;
		let numInPile = 6;
		let angleDelta = 3.5; // degrees

		// compute size of the entire stack, modulo rotation.
		let size;
		if(bbAspect > itemAspect) {
			// Tall, thin groupItem
			size = TabItems.calcValidSize(new Point(bb.width * scale, -1), { hideTitle:true });
		} else {
			// Short, wide groupItem
			size = TabItems.calcValidSize(new Point(-1, bb.height * scale), { hideTitle:true });
		}

		// x is the left margin that the stack will have, within the content area (bb)
		// y is the vertical margin
		let x = (bb.width - size.x) / 2;
		let y = Math.min(size.x, (bb.height - size.y) / 2);
		let box = new Rect(bb.left + x, bb.top + y, size.x, size.y);

		let children = [];

		// ensure topChild is the first item in childrenToArrange
		let topChild = this.getTopChild();
		let topChildPos = childrenToArrange.indexOf(topChild);
		if(topChildPos > 0) {
			childrenToArrange.splice(topChildPos, 1);
			childrenToArrange.unshift(topChild);
		}

		childrenToArrange.forEach(function(child) {
			// Children are still considered stacked even if they're hidden later.
			child.addClass("stacked");
			child.isStacked = true;
			if(numInPile-- > 0) {
				children.push(child);
			} else {
				child.setHidden(true);
			}
		});

		this._isStacked = true;

		let angleAccum = 0;
		children.forEach(function(child, index) {
			child.setZ(zIndex);
			zIndex--;

			// Force a recalculation of height because we've changed how the title is shown.
			child.setBounds(box, !animate || child.getHidden(), { force:true });
			child.setRotation((UI.rtl ? -1 : 1) * angleAccum);
			child.setHidden(false);
			angleAccum += angleDelta;
		});
	},

	// Arranges the children into a grid.
	// Parameters:
	//   childrenToArrange - array of <TabItem> children
	//   box - <Rect> to arrange within
	//   options - see below
	// Possible "options" properties:
	//   animate - whether to animate; default: true.
	//   z - (int) a z-index to assign the children
	//   columns - the number of columns to use in the layout, if known in advance
	// Returns:
	//   dropIndex - (int) the index at which a dragged item (if there is one) should be added if it is dropped. Otherwise (boolean) false.
	_gridArrange: function(childrenToArrange, box, options) {
		let arrangeOptions;
		if(this.expanded) {
			// if we're expanded, we actually want to use the expanded tray's bounds.
			box = new Rect(this.expanded.bounds);
			box.inset(8, 8);
			arrangeOptions = Utils.extend({}, options, { z: 99999 });
		} else {
			this._isStacked = false;
			arrangeOptions = Utils.extend({}, options, {
				columns: this._columns
			});

			childrenToArrange.forEach(function(child) {
				child.removeClass("stacked");
				child.isStacked = false;
				child.setHidden(false);
			});
		}

		if(!childrenToArrange.length) { return false; }

		// Items.arrange will determine where/how the child items should be placed, but will *not* actually move them for us. This is our job.
		let result = Items.arrange(childrenToArrange, box, arrangeOptions);
		let { dropIndex, rects, columns } = result;
		if("oldDropIndex" in options && options.oldDropIndex === dropIndex) {
			return dropIndex;
		}

		this._columns = columns;
		let index = 0;
		childrenToArrange.forEach((child, i) => {
			// If dropIndex spacing is active and this is a child after index, bump it up one so we actually use the correct rect (and skip one for the dropPos)
			if(this._dropSpaceActive && index === dropIndex) {
				index++;
			}
			child.setBounds(rects[index], !options.animate);
			child.setRotation(0);
			if(arrangeOptions.z) {
				child.setZ(arrangeOptions.z);
			}
			index++;
		});

		return dropIndex;
	},

	expand: function() {
		// ___ we're stacked, and command is held down so expand
		UI.setActive(this.getTopChild());

		let startBounds = this.getChild(0).getBounds();
		let $tray = iQ("<div>").css({
			top: startBounds.top,
			left: startBounds.left,
			width: startBounds.width,
			height: startBounds.height,
			position: "absolute",
			zIndex: 99998
		}).appendTo("body");
		$tray[0].id = "expandedTray";

		let w = 180;
		let h = w * (TabItems.tabHeight / TabItems.tabWidth) * 1.1;
		let padding = 20;
		let col = Math.ceil(Math.sqrt(this._children.length));
		let row = Math.ceil(this._children.length/col);

		let overlayWidth = Math.min(window.innerWidth - (padding * 2), w*col + padding*(col+1));
		let overlayHeight = Math.min(window.innerHeight - (padding * 2), h*row + padding*(row+1));

		let pos = {left: startBounds.left, top: startBounds.top};
		pos.left -= overlayWidth / 3;
		pos.top  -= overlayHeight / 3;

		if(pos.top < 0) {
			pos.top = 20;
		}
		if(pos.left < 0) {
			pos.left = 20;
		}
		if(pos.top + overlayHeight > window.innerHeight) {
			pos.top = window.innerHeight - overlayHeight - 20;
		}
		if(pos.left + overlayWidth > window.innerWidth) {
			pos.left = window.innerWidth - overlayWidth - 20;
		}

		$tray
			.animate({
				width:  overlayWidth,
				height: overlayHeight,
				top: pos.top,
				left: pos.left
			}, {
				duration: 200,
				easing: "tabviewBounce",
				complete: () => {
					this._sendToSubscribers("expanded");
				}
			})
			.addClass("overlay");

		for(let child of this._children) {
			child.addClass("stack-trayed");
			child.setHidden(false);
		}

		let $shield = iQ('<div>')
			.addClass('shield')
			.css({
				zIndex: 99997
			})
			.appendTo('body')
			.click(() => { // just in case
				this.collapse();
			});

		// There is a race-condition here. If there is a mouse-move while the shield is coming up it will collapse, which we don't want.
		// Thus, we wait a little bit before adding this event handler.
		aSync(() => {
			$shield.mouseover(() => {
				this.collapse();
			});
		}, 200);

		this.expanded = {
			$tray: $tray,
			$shield: $shield,
			bounds: new Rect(pos.left, pos.top, overlayWidth, overlayHeight)
		};

		this.arrange();
	},

	// Collapses the groupItem from the expanded "tray" mode.
	collapse: function() {
		if(!this.expanded) { return }

		let z = this.getZ();
		let box = this.getBounds();
		let tray = this.expanded.$tray;
		tray
			.css({
				zIndex: z + 1
			})
			.animate({
				width:  box.width,
				height: box.height,
				top: box.top,
				left: box.left,
				opacity: 0
			}, {
				duration: 350,
				easing: "tabviewBounce",
				complete: () => {
					iQ(tray).remove();
					this._sendToSubscribers("collapsed");
				}
			});

		this.expanded.$shield.remove();
		this.expanded = null;

		for(let child of this._children) {
			child.removeClass("stack-trayed");
		}

		this.arrange({ z: z + 2 });
		this._unfreezeItemSize({ dontArrange: true });
	},

	// Helper routine for the constructor; adds various event handlers to the container.
	_addHandlers: function(container) {
		let lastMouseDownTarget;

		container.mousedown((e) => {
			let target = e.target;
			// only set the last mouse down target if it is a left click, not on the close button, not on the expand button, not on the title bar and its elements
			if(e.button == 0
			&& this.$closeButton[0] != target
			&& this.$titlebar[0] != target
			&& this.$expander[0] != target
			&& !this.$titlebar.contains(target)
			&& !this.$appTabTray.contains(target)) {
				lastMouseDownTarget = target;
			} else {
				lastMouseDownTarget = null;
			}
		});
		container.mouseup((e) => {
			let same = (e.target == lastMouseDownTarget);
			lastMouseDownTarget = null;

			if(same && !this.isDragging) {
				if(gBrowser.selectedTab.pinned
				&& UI.getActiveTab() != this.getActiveTab()
				&& this.getChildren().length) {
					UI.setActive(this, { dontSetActiveTabInGroup: true });
					UI.goToTab(gBrowser.selectedTab);
				} else {
					let tabItem = this.getTopChild();
					if(tabItem) {
						tabItem.zoomIn();
					} else {
						this.newTab();
					}
				}
			}
		});

		let dropIndex = false;
		let dropSpaceTimer = null;

		// When the _dropSpaceActive flag is turned on on a group, and a tab is dragged on top, a space will open up.
		this._dropSpaceActive = false;

		this.dropOptions.over = (event) => {
			iQ(this.container).addClass("acceptsDrop");
		};
		this.dropOptions.move = (event) => {
			let oldDropIndex = dropIndex;
			let dropPos = drag.info.item.getBounds().center();
			let options = {
				dropPos: dropPos,
				addTab: this._dropSpaceActive && drag.info.item.parent != this,
				oldDropIndex: oldDropIndex
			};
			let newDropIndex = this.arrange(options);
			// If this is a new drop index, start a timer!
			if(newDropIndex !== oldDropIndex) {
				dropIndex = newDropIndex;
				if(this._dropSpaceActive) { return; }

				if(dropSpaceTimer) {
					dropSpaceTimer.cancel();
					dropSpaceTimer = null;
				}

				dropSpaceTimer = aSync(() => {
					// Note that dropIndex's scope is GroupItem__addHandlers, but newDropIndex's scope is GroupItem_dropOptions_move.
					// Thus, dropIndex may change with other movement events before we come back and check this.
					// If it's still the same dropIndex, activate drop space display!
					if(dropIndex === newDropIndex) {
						this._dropSpaceActive = true;
						dropIndex = this.arrange({
							dropPos: dropPos,
							addTab: drag.info.item.parent != this,
							animate: true
						});
					}
					dropSpaceTimer = null;
				}, 250);
			}
		};
		this.dropOptions.drop = (event) => {
			iQ(this.container).removeClass("acceptsDrop");
			let options = {};
			if(this._dropSpaceActive) {
				this._dropSpaceActive = false;
			}

			if(dropSpaceTimer) {
				dropSpaceTimer.cancel();
				dropSpaceTimer = null;

				// If we drop this item before the timed rearrange was executed, we won't have an accurate dropIndex value. Get that now.
				let dropPos = drag.info.item.getBounds().center();
				dropIndex = this.arrange({
					dropPos: dropPos,
					addTab: drag.info.item.parent != this,
					animate: true
				});
			}

			if(dropIndex !== false) {
				options = { index: dropIndex };
			}
			this.add(drag.info.$el, options);
			UI.setActive(this);
			dropIndex = false;
		};
		this.dropOptions.out = (event) => {
			dropIndex = false;
			if(this._dropSpaceActive) {
				this._dropSpaceActive = false;
			}

			if(dropSpaceTimer) {
				dropSpaceTimer.cancel();
				dropSpaceTimer = null;
			}
			this.arrange();
			let groupItem = drag.info.item.parent;
			if(groupItem) {
				groupItem.remove(drag.info.$el, { dontClose: true });
			}
			iQ(this.container).removeClass("acceptsDrop");
		}

		this.draggable();
		this.droppable(true);

		this.$expander.click(() => {
			this.expand();
		});
	},

	// Sets whether the groupItem is resizable and updates the UI accordingly.
	setResizable: function(value, immediately) {
		this.resizeOptions.minWidth = GroupItems.minGroupWidth;
		this.resizeOptions.minHeight = GroupItems.minGroupHeight;

		let start = this.resizeOptions.start;
		this.resizeOptions.start = (e) => {
			start(e);
			this._unfreezeItemSize();
		}

		if(value) {
			immediately ? this.$resizer.show() : this.$resizer.fadeIn();
			this.resizable(true);
		} else {
			immediately ? this.$resizer.hide() : this.$resizer.fadeOut();
			this.resizable(false);
		}
	},

	// Creates a new tab within this groupItem.
	// Parameters:
	//  url - the new tab should open this url as well
	//  options - the options object
	//    dontZoomIn - set to true to not zoom into the newly created tab
	//    closedLastTab - boolean indicates the last tab has just been closed
	newTab: function(url, options) {
		if(options && options.closedLastTab) {
			UI.closedLastTabInTabView = true;
		}

		UI.setActive(this, { dontSetActiveTabInGroup: true });

		let dontZoomIn = !!(options && options.dontZoomIn);
		return gBrowser.loadOneTab(url || gWindow.BROWSER_NEW_TAB_URL, { inBackground: dontZoomIn });
	},

	// Reorders the tabs in a groupItem based on the arrangement of the tabs shown in the tab bar.
	// It does it by sorting the children of the groupItem by the positions of their respective tabs in the tab bar.
	reorderTabItemsBasedOnTabOrder: function() {
		this._children.sort((a,b) => a.tab._tPos - b.tab._tPos);

		this.arrange({ animate: false });
		// this.arrange calls this.save for us
	},

	// Reorders the tabs in the tab bar based on the arrangment of the tabs shown in the groupItem.
	reorderTabsBasedOnTabItemOrder: function() {
		let indices;
		let tabs = this._children.map(tabItem => tabItem.tab);

		tabs.forEach(function(tab, index) {
			if(!indices) {
				indices = tabs.map(tab => tab._tPos);
			}

			let start = index ? indices[index - 1] + 1 : 0;
			let end = index + 1 < indices.length ? indices[index + 1] - 1 : Infinity;
			let targetRange = new Range(start, end);

			if(!targetRange.contains(tab._tPos)) {
				gBrowser.moveTabTo(tab, start);
				indices = null;
			}
		});
	},

	// Gets the <Item> that should be displayed on top when in stack mode.
	getTopChild: function() {
		if(!this.getChildren().length) {
			return null;
		}

		return this.getActiveTab() || this.getChild(0);
	},

	// Returns the nth child tab or null if index is out of range.
	// Parameters:
	//  index - the index of the child tab to return, use negative numbers to index from the end (-1 is the last child)
	getChild: function(index) {
		if(index < 0) {
			index = this._children.length + index;
		}
		if(index >= this._children.length || index < 0) {
			return null;
		}
		return this._children[index];
	},

	// Returns all children.
	getChildren: function() {
		return this._children;
	}
});

// Singleton for managing all <GroupItem>s.
this.GroupItems = {
	groupItems: [],
	nextID: 1,
	_inited: false,
	_activeGroupItem: null,
	_arrangePaused: false,
	_arrangesPending: [],
	_removingHiddenGroups: false,
	_delayedModUpdates: new Set(),
	_autoclosePaused: false,
	minGroupHeight: 110,
	minGroupWidth: 125,
	_lastActiveList: null,

	handleEvent: function(e) {
		switch(e.type) {
			// setup attr modified handler, and prepare for its uninit
			case 'attrModified':
				this._handleAttrModified(e.target);
				break;

			// make sure any closed tabs are removed from the delay update list
			case 'close':
				let idx = this._delayedModUpdates.delete(e.target);
				break;
		}
	},

	// Function: init
	init: function() {
		this._lastActiveList = new MRUList();

		AllTabs.register("attrModified", this);
		AllTabs.register("close", this);
	},

	// Function: uninit
	uninit: function() {
		AllTabs.unregister("attrModified", this);
		AllTabs.unregister("close", this);

		// additional clean up
		this.groupItems = [];
	},

	// Creates a new empty group.
	newGroup: function() {
		let bounds = new Rect(20, 20, 250, 200);
		return new GroupItem([], { bounds: bounds, immediately: true });
	},

	// Bypass arrange() calls and collect for resolution in	resumeArrange()
	pauseArrange: function() {
		this._arrangePaused = true;
	},

	// Push an arrange() call and its arguments onto an arrayto be resolved in resumeArrange()
	pushArrange: function(groupItem, options) {
		let i;
		for(i = 0; i < this._arrangesPending.length; i++) {
			if(this._arrangesPending[i].groupItem === groupItem) {
				break;
			}
		}
		let arrangeInfo = {
			groupItem: groupItem,
			options: options
		};
		if(i < this._arrangesPending.length) {
			this._arrangesPending[i] = arrangeInfo;
		} else {
			this._arrangesPending.push(arrangeInfo);
		}
	},

	// Resolve bypassed and collected arrange() calls
	resumeArrange: function() {
		this._arrangePaused = false;
		for(let i = 0; i < this._arrangesPending.length; i++) {
			let g = this._arrangesPending[i];
			g.groupItem.arrange(g.options);
		}
		this._arrangesPending = [];
	},

	// watch for icon changes on app tabs
	_handleAttrModified: function(xulTab) {
		if(!UI.isTabViewVisible()) {
			this._delayedModUpdates.add(xulTab);
		} else {
			this._updateAppTabIcons(xulTab);
		}
	},

	// Update apptab icons based on xulTabs which have been updated while the TabView hasn't been visible
	flushAppTabUpdates: function() {
		for(let xulTab of this._delayedModUpdates) {
			this._updateAppTabIcons(xulTab);
		}
		this._delayedModUpdates.clear();
	},

	// Update images of any apptab icons that point to passed in xultab
	_updateAppTabIcons: function(xulTab) {
		if(!xulTab.pinned) { return; }

		this.getAppTabFavIconUrl(xulTab, function(iconUrl) {
			iQ(".appTabIcon").each(function(icon) {
				let $icon = iQ(icon);
				if($icon.data("xulTab") == xulTab && iconUrl != $icon.attr("src")) {
					$icon.attr("src", iconUrl);
				}
			});
		});
	},

	// Gets the fav icon url for app tab.
	getAppTabFavIconUrl: function(xulTab, callback) {
		FavIcons.getFavIconUrlForTab(xulTab, function(iconUrl) {
			callback(iconUrl || FavIcons.defaultFavicon);
		});
	},

	// Adds the given xul:tab to the app tab tray in all groups
	addAppTab: function(xulTab) {
		this.groupItems.forEach(function(groupItem) {
			groupItem.addAppTab(xulTab);
		});
		this.updateGroupCloseButtons();
	},

	// Removes the given xul:tab from the app tab tray in all groups
	removeAppTab: function(xulTab) {
		this.groupItems.forEach(function(groupItem) {
			groupItem.removeAppTab(xulTab);
		});
		this.updateGroupCloseButtons();
	},

	// Arranges the given xul:tab as an app tab from app tab tray in all groups
	arrangeAppTab: function(xulTab) {
		this.groupItems.forEach(function(groupItem) {
			groupItem.arrangeAppTab(xulTab);
		});
	},

	// Returns the next unused groupItem ID.
	getNextID: function() {
		let result = this.nextID;
		this.nextID++;
		this._save();
		return result;
	},

	// Saves GroupItems state, as well as the state of all of the groupItems.
	saveAll: function() {
		this._save();
		this.groupItems.forEach(function(groupItem) {
			groupItem.save();
		});
	},

	// Saves GroupItems state.
	_save: function() {
		// too soon to save now
		if(!this._inited) { return; }

		let activeGroupId = this._activeGroupItem ? this._activeGroupItem.id : null;
		Storage.saveGroupItemsData(gWindow, {
			nextID: this.nextID,
			activeGroupId: activeGroupId,
			totalNumber: this.groupItems.length
		});
	},

	// Given an array of DOM elements, returns a <Rect> with (roughly) the union of their locations.
	getBoundingBox: function(els) {
		let bounds = els.map(el => iQ(el).bounds());
		let left   = Math.min.apply({}, bounds.map(b => b.left));
		let top    = Math.min.apply({}, bounds.map(b => b.top));
		let right  = Math.max.apply({}, bounds.map(b => b.right));
		let bottom = Math.max.apply({}, bounds.map(b => b.bottom));

		return new Rect(left, top, right-left, bottom-top);
	},

	// Restores to stored state, creating groupItems as needed.
	reconstitute: function(groupItemsData, groupItemData) {
		try {
			let activeGroupId;

			if(groupItemsData) {
				if(groupItemsData.nextID) {
					this.nextID = Math.max(this.nextID, groupItemsData.nextID);
				}
				if(groupItemsData.activeGroupId) {
					activeGroupId = groupItemsData.activeGroupId;
				}
			}

			if(groupItemData) {
				let toClose = this.groupItems.concat();
				for(let id in groupItemData) {
					let data = groupItemData[id];
					if(this.storageSanityGroupItem(data)) {
						let groupItem = this.groupItem(data.id);
						if(groupItem && !groupItem.hidden) {
							// (TMP) In case this group is re-used by session restore, make sure all of its children still belong to this group.
							// Do it before setBounds trigger data save that will overwrite session restore data.
							// TabView will use TabItems.resumeReconnecting or UI.reset to reconnect the tabItem.
							groupItem.getChildren().forEach(tabItem => {
								let tabData = Storage.getTabData(tabItem.tab);
								if(!tabData || tabData.groupID != data.id) {
									tabItem._reconnected = false;
								}
							});

							groupItem.userSize = data.userSize;
							groupItem.setTitle(data.title);
							groupItem.setBounds(data.bounds, true);

							let index = toClose.indexOf(groupItem);
							if(index != -1) {
								toClose.splice(index, 1);
							}
						} else {
							let options = {
								// we always push when first appending the group, in case new groups (from other add-ons, or imported in prefs)
								// overlap existing groups
								dontPush: false,
								immediately: true
							};
							new GroupItem([], Utils.extend({}, data, options));
						}
					}
				}

				toClose.forEach(function(groupItem) {
					// all tabs still existing in closed groups will be moved to new groups. prepare them to be reconnected later.
					groupItem.getChildren().forEach(function(tabItem) {
						if(tabItem.parent.hidden) {
							iQ(tabItem.container).show();
						}

						tabItem._reconnected = false;

						// sanity check the tab's groupID
						let tabData = Storage.getTabData(tabItem.tab);

						if(tabData) {
							let parentGroup = GroupItems.groupItem(tabData.groupID);

							// the tab's group id could be invalid or point to a non-existing group.
							// correct it by assigning the active group id or the first group of the just restored session.
							if(!parentGroup || -1 < toClose.indexOf(parentGroup)) {
								tabData.groupID = activeGroupId || Object.keys(groupItemData)[0];
								Storage.saveTab(tabItem.tab, tabData);
							}
						}
					});

					// this closes the group but not its children
					groupItem.close({ immediately: true });
				});
			}

			// set active group item
			if(activeGroupId) {
				let activeGroupItem = this.groupItem(activeGroupId);
				if(activeGroupItem) {
					UI.setActive(activeGroupItem);
				}
			}

			this._inited = true;
			this._save(); // for nextID
		}
		catch(ex) {
			Cu.reportError(ex);
		}
	},

	// Loads the storage data for groups. Returns true if there was global group data.
	load: function() {
		let groupItemsData = Storage.readGroupItemsData(gWindow);
		let groupItemData = Storage.readGroupItemData(gWindow);
		this.reconstitute(groupItemsData, groupItemData);

		return (groupItemsData && !Utils.isEmptyObject(groupItemsData));
	},

	// Given persistent storage data for a groupItem, returns true if it appears to not be damaged.
	storageSanityGroupItem: function(groupItemData) {
		if(!groupItemData.id
		|| (groupItemData.userSize && !Utils.isPoint(groupItemData.userSize))) {
			return false;
		}

		// For compatibility with other add-ons that might modify (read: create) groups, instead of discarting invalid groups we "fix" them.
		if(!groupItemData.bounds || !Utils.isRect(groupItemData.bounds)) {
			let pageBounds = Items.getPageBounds();
			pageBounds.inset(20, 20);

			let box = new Rect(pageBounds);
			box.width = 250;
			box.height = 200;

			groupItemData.bounds = box;
			Storage.saveGroupItem(gWindow, groupItemData);
		}

		return true;
	},

	// Adds the given <GroupItem> to the list of groupItems we're tracking.
	register: function(groupItem) {
		this.groupItems.push(groupItem);
		UI.updateTabButton();
	},

	// Removes the given <GroupItem> from the list of groupItems we're tracking.
	unregister: function(groupItem) {
		let index = this.groupItems.indexOf(groupItem);
		if(index != -1) {
			this.groupItems.splice(index, 1);
		}

		if(groupItem == this._activeGroupItem) {
			this._activeGroupItem = null;
		}

		this._arrangesPending = this._arrangesPending.filter(function(pending) {
			return groupItem != pending.groupItem;
		});

		this._lastActiveList.remove(groupItem);
		UI.updateTabButton();
	},

	// Given some sort of identifier, returns the appropriate groupItem. Currently only supports groupItem ids.
	groupItem: function(a) {
		if(!this.groupItems) {
			// uninit has been called
			return null;
		}
		let result = null;
		this.groupItems.forEach(function(candidate) {
			if(candidate.id == a) {
				result = candidate;
			}
		});

		return result;
	},

	// Removes all tabs from all groupItems (which automatically closes all unnamed groupItems).
	removeAll: function() {
		let toRemove = this.groupItems.concat();
		toRemove.forEach(function(groupItem) {
			groupItem.removeAll();
		});
	},

	// Given a <TabItem>, files it in the appropriate groupItem.
	newTab: function(tabItem, options) {
		let activeGroupItem = this.getActiveGroupItem();

		// 1. Active group
		// 2. First visible non-app tab (that's not the tab in question)
		// 3. First group
		// 4. At this point there should be no groups or tabs (except for app tabs and the tab in question): make a new group

		if(activeGroupItem && !activeGroupItem.hidden) {
			activeGroupItem.add(tabItem, options);
			return;
		}

		let targetGroupItem;
		// find first non-app visible tab belongs a group, and add the new tabItem to that group
		gBrowser.visibleTabs.some(function(tab) {
			if(!tab.pinned && tab != tabItem.tab) {
				if(tab._tabViewTabItem && tab._tabViewTabItem.parent && !tab._tabViewTabItem.parent.hidden) {
					targetGroupItem = tab._tabViewTabItem.parent;
				}
				return true;
			}
			return false;
		});

		if(targetGroupItem) {
			// add the new tabItem to the first group item
			targetGroupItem.add(tabItem);
			UI.setActive(targetGroupItem);
			return;
		}

		// find the first visible group item
		let visibleGroupItems = this.groupItems.filter(function(groupItem) {
			return (!groupItem.hidden);
		});
		if(visibleGroupItems.length) {
			visibleGroupItems[0].add(tabItem);
			UI.setActive(visibleGroupItems[0]);
			return;
		}

		// create new group for the new tabItem
		tabItem.setPosition(60, 60, true);
		let newGroupItemBounds = tabItem.getBounds();

		newGroupItemBounds.inset(-40,-40);
		let newGroupItem = new GroupItem([tabItem], { bounds: newGroupItemBounds });
		newGroupItem.snap();
		UI.setActive(newGroupItem);
	},

	// Returns the active groupItem. Active means its tabs are shown in the tab bar when not in the TabView interface.
	getActiveGroupItem: function() {
		return this._activeGroupItem;
	},

	// Sets the active groupItem, thereby showing only the relevant tabs and setting the groupItem which will receive new tabs.
	// Paramaters:
	//  groupItem - the active <GroupItem>
	setActiveGroupItem: function(groupItem) {
		if(this._activeGroupItem) {
			iQ(this._activeGroupItem.container).removeClass('activeGroupItem');
		}

		iQ(groupItem.container).addClass('activeGroupItem');

		this._lastActiveList.update(groupItem);
		this._activeGroupItem = groupItem;
		this._save();
	},

	// Gets last active group item. Returns the <groupItem>. If nothing is found, return null.
	getLastActiveGroupItem: function() {
		return this._lastActiveList.peek(function(groupItem) {
			return (groupItem && !groupItem.hidden && groupItem.getChildren().length)
		});
	},

	// Hides and shows tabs in the tab bar based on the active groupItem
	_updateTabBar: function() {
		// called too soon
		if(!window[objName] || !window[objName].UI) { return; }

		let tabItems = this._activeGroupItem._children;
		gBrowser.showOnlyTheseTabs(tabItems.map(item => item.tab));
	},

	// Sets active TabItem and GroupItem, and updates tab bar appropriately.
	// Parameters:
	// tabItem - the tab item
	// options - is passed to UI.setActive() directly
	updateActiveGroupItemAndTabBar: function(tabItem, options) {
		UI.setActive(tabItem, options);
		this._updateTabBar();
	},

	// Paramaters:
	//  reverse - the boolean indicates the direction to look for the next groupItem.
	// Returns the <tabItem>. If nothing is found, return null.
	getNextGroupItemTab: function(reverse) {
		let groupItems = Utils.copy(GroupItems.groupItems);
		let activeGroupItem = GroupItems.getActiveGroupItem();
		let tabItem = null;

		// When cycling through groups, order them by their titles, otherwise it's far too arbitrary.
		for(let groupItem of groupItems) {
			groupItem.groupTitle = gWindow[objName].TabView.getGroupTitle(groupItem);
		}
		groupItems.sort(function(a, b) {
			if(a.groupTitle < b.groupTitle) { return -1; }
			if(a.groupTitle > b.groupTitle) { return 1; }
			return 0;
		});

		if(reverse) {
			groupItems.reverse();
		}

		let some = function(groupItem) {
			if(!groupItem.hidden) {
				// restore the last active tab in the group
				let activeTab = groupItem.getActiveTab();
				if(activeTab) {
					tabItem = activeTab;
					return true;
				}
				// if no tab is active, use the first one
				let child = groupItem.getChild(0);
				if(child) {
					tabItem = child;
					return true;
				}
			}
			return false;
		};

		if(!activeGroupItem) {
			if(groupItems.length) {
				groupItems.some(some);
			}
		}
		else {
			let currentIndex;
			groupItems.some(function(groupItem, index) {
				if(!groupItem.hidden && groupItem == activeGroupItem) {
					currentIndex = index;
					return true;
				}
				return false;
			});
			let firstGroupItems = groupItems.slice(currentIndex + 1);
			firstGroupItems.some(some);
			if(!tabItem) {
				let secondGroupItems = groupItems.slice(0, currentIndex);
				secondGroupItems.some(some);
			}
		}

		return tabItem;
	},

	// Used for the right click menu in the tab strip; moves the given tab into the given group. Does nothing if the tab is an app tab.
	// Paramaters:
	//  tab - the <xul:tab>.
	//  groupItemId - the <groupItem>'s id.  If nothing, create a new <groupItem>.
	moveTabToGroupItem: function(tab, groupItemId) {
		if(tab.pinned) { return; }

		// given tab is already contained in target group
		if(tab._tabViewTabItem.parent && tab._tabViewTabItem.parent.id == groupItemId) { return; }

		let shouldUpdateTabBar = false;
		let shouldShowTabView = false;
		let groupItem;

		// switch to the appropriate tab first.
		if(tab.selected) {
			if(gBrowser.visibleTabs.length > 1) {
				gBrowser._blurTab(tab);
				shouldUpdateTabBar = true;
			} else {
				shouldShowTabView = true;
			}
		} else {
			shouldUpdateTabBar = true
		}

		// remove tab item from a groupItem
		if(tab._tabViewTabItem.parent) {
			tab._tabViewTabItem.parent.remove(tab._tabViewTabItem);
		}

		// add tab item to a groupItem
		if(groupItemId) {
			groupItem = GroupItems.groupItem(groupItemId);
			groupItem.add(tab._tabViewTabItem);
			groupItem.reorderTabsBasedOnTabItemOrder()
		} else {
			let pageBounds = Items.getPageBounds();
			pageBounds.inset(20, 20);

			let box = new Rect(pageBounds);
			box.width = 250;
			box.height = 200;

			new GroupItem([ tab._tabViewTabItem ], { bounds: box, immediately: true });
		}

		if(shouldUpdateTabBar) {
			this._updateTabBar();
		} else if(shouldShowTabView) {
			UI.showTabView();
		}
	},

	// Removes all hidden groups' data and its browser tabs.
	removeHiddenGroups: function() {
		if(this._removingHiddenGroups) { return; }
		this._removingHiddenGroups = true;

		let groupItems = this.groupItems.concat();
		groupItems.forEach(function(groupItem) {
			if(groupItem.hidden) {
				groupItem.closeHidden();
			}
		});

		this._removingHiddenGroups = false;
	},

	// If there's only one (non-hidden) group, and there are app tabs present, returns that group.
	// Return the <GroupItem>'s Id
	getUnclosableGroupItemId: function() {
		let unclosableGroupItemId = null;

		if(gBrowser._numPinnedTabs) {
			let hiddenGroupItems = this.groupItems.concat().filter(function(groupItem) {
				return !groupItem.hidden;
			});
			if(hiddenGroupItems.length == 1) {
				unclosableGroupItemId = hiddenGroupItems[0].id;
			}
		}

		return unclosableGroupItemId;
	},

	// Updates group close buttons.
	updateGroupCloseButtons: function() {
		let unclosableGroupItemId = this.getUnclosableGroupItemId();

		if(unclosableGroupItemId) {
			let groupItem = this.groupItem(unclosableGroupItemId);

			if(groupItem) {
				groupItem.$closeButton.hide();
			}
		} else {
			this.groupItems.forEach(function(groupItem) {
				groupItem.$closeButton.show();
			});
		}
	},

	// Basic measure rules. Assures that item is a minimum size.
	calcValidSize: function(size, options) {
		return new Point(Math.max(size.x, GroupItems.minGroupWidth), Math.max(size.y, GroupItems.minGroupHeight));
	},

	// Temporarily disable the behavior that closes groups when they become empty.
	// This is used when entering private browsing, to avoid trashing the user's groups while private browsing is shuffling things around.
	pauseAutoclose: function() {
		this._autoclosePaused = true;
	},

	// Re-enables the auto-close behavior.
	resumeAutoclose: function() {
		this._autoclosePaused = false;
	}
};
