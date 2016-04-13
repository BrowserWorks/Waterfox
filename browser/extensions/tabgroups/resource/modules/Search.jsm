// VERSION 1.0.3

// Implementation for the search functionality of Firefox Panorama.
// Class: TabUtils - A collection of helper functions for dealing with both <TabItem>s and <xul:tab>s without having to worry which one is which.
this.TabUtils = {
	// Given a <TabItem> or a <xul:tab> returns the tab's name.
	nameOf: function(tab) {
		// We can have two types of tabs: A <TabItem> or a <xul:tab> because we have to deal with both tabs represented inside
		// of active Panoramas as well as for windows in which Panorama has yet to be activated. We uses object sniffing to
		// determine the type of tab and then returns its name.
		return tab.label != undefined ? tab.label : tab.$tabTitle[0].textContent;
	},

	// Given a <TabItem> or a <xul:tab> returns the URL of tab.
	URLOf: function(tab) {
		// Convert a <TabItem> to <xul:tab>
		if("tab" in tab) {
			tab = tab.tab;
		}
		return tab.linkedBrowser.currentURI.spec;
	},

	// Given a <TabItem> or a <xul:tab> returns the URL of tab's favicon.
	faviconURLOf: function(tab) {
		return tab.image != undefined ? tab.image : tab.$favImage[0].src;
	},

	// Given a <TabItem> or a <xul:tab>, focuses it and it's window.
	focus: function(tab) {
		// Convert a <TabItem> to a <xul:tab>
		if("tab" in tab) {
			tab = tab.tab;
		}
		tab.ownerDocument.defaultView.gBrowser.selectedTab = tab;
		tab.ownerDocument.defaultView.focus();
	}
};

// Class: TabMatcher - A class that allows you to iterate over matching and not-matching tabs, given a case-insensitive search term.
this.TabMatcher = function(term) {
	this.term = term;
};

this.TabMatcher.prototype = {
	// Given an array of <TabItem>s and <xul:tab>s returns a new array of tabs whose name matched the search term, sorted by lexical closeness.
	_filterAndSortForMatches: function(tabs) {
		tabs = tabs.filter((tab) => {
			let name = TabUtils.nameOf(tab);
			let url = TabUtils.URLOf(tab);
			return name.match(new RegExp(this.term, "i")) || url.match(new RegExp(this.term, "i"));
		});

		tabs.sort((x, y) => {
			let yScore = this._scorePatternMatch(this.term, TabUtils.nameOf(y));
			let xScore = this._scorePatternMatch(this.term, TabUtils.nameOf(x));
			return yScore - xScore;
		});

		return tabs;
	},

	// Given an array of <TabItem>s returns an unsorted array of tabs whose name does not match the the search term.
	_filterForUnmatches: function(tabs) {
		return tabs.filter((tab) => {
			let name = tab.$tabTitle[0].textContent;
			let url = TabUtils.URLOf(tab);
			return !name.match(new RegExp(this.term, "i")) && !url.match(new RegExp(this.term, "i"));
		});
	},

	// Returns an array of <TabItem>s and <xul:tabs>s representing tabs from all windows but the current window. <TabItem>s will be returned
	// for windows in which Panorama has been activated at least once, while <xul:tab>s will be returned for windows in which Panorama has never been activated.
	_getTabsForOtherWindows: function() {
		let enumerator = Services.wm.getEnumerator("navigator:browser");
		let allTabs = [];

		while(enumerator.hasMoreElements()) {
			let win = enumerator.getNext();
			// This function gets tabs from other windows, not from the current window
			if(win != gWindow) {
				allTabs.push.apply(allTabs, win.gBrowser.tabs);
			}
		}
		return allTabs;
	},

	// Returns an array of <TabItem>s and <xul:tab>s that match the search term from all windows but the current window.
	// <TabItem>s will be returned for windows in which Panorama has been activated at least once, while <xul:tab>s will be returned for windows in which Panorama has never
	// been activated. // (new TabMatcher("app")).matchedTabsFromOtherWindows();
	matchedTabsFromOtherWindows: function() {
		if(this.term.length < 2) {
			return [];
		}

		let tabs = this._getTabsForOtherWindows();
		return this._filterAndSortForMatches(tabs);
	},

	// Returns an array of <TabItem>s which match the current search term.
	// If the term is less than 2 characters in length, it returns nothing.
	matched: function() {
		if(this.term.length < 2) {
			return [];
		}

		let tabs = TabItems.getItems();
		return this._filterAndSortForMatches(tabs);
	},

	// Returns all of <TabItem>s that .matched() doesn't return.
	unmatched: function() {
		let tabs = TabItems.getItems();
		if(this.term.length < 2) {
			return tabs;
		}

		return this._filterForUnmatches(tabs);
	},

	// Performs the search. Lets you provide three functions.
	// The first is on all matched tabs in the window, the second on all unmatched tabs in the window, and the third on all matched tabs in other windows.
	// The first two functions take two parameters: A <TabItem> and its integer index indicating the absolute rank of the <TabItem> in terms of match to the search term.
	// The last function also takes two paramaters, but can be passed both <TabItem>s and <xul:tab>s and the index is offset by the number of matched tabs inside the window.
	doSearch: function(matchFunc, unmatchFunc, otherFunc) {
		let matches = this.matched();
		let unmatched = this.unmatched();
		let otherMatches = this.matchedTabsFromOtherWindows();

		matches.forEach(function(tab, i) {
			matchFunc(tab, i);
		});

		otherMatches.forEach(function(tab,i) {
			otherFunc(tab, i+matches.length);
		});

		unmatched.forEach(function(tab, i) {
			unmatchFunc(tab, i);
		});
	},

	// Given a pattern string, returns a score between 0 and 1 of how well that pattern matches the original string.
	// It mimics the heuristics of the Mac application launcher Quicksilver.
	_scorePatternMatch: function(pattern, matched, offset) {
		offset = offset || 0;
		pattern = pattern.toLowerCase();
		matched = matched.toLowerCase();

		if(pattern.length == 0) {
			return 0.9;
		}
		if(pattern.length > matched.length) {
			return 0.0;
		}

		for(let i = pattern.length; i > 0; i--) {
			let sub_pattern = pattern.substring(0,i);
			let index = matched.indexOf(sub_pattern);

			if(index < 0) { continue; }
			if(index + pattern.length > matched.length + offset) { continue; }

			let next_string = matched.substring(index+sub_pattern.length);
			let next_pattern = null;

			if(i >= pattern.length) {
				next_pattern = '';
			} else {
				next_pattern = pattern.substring(i);
			}

			let remaining_score = this._scorePatternMatch(next_pattern, next_string, offset + index);

			if(remaining_score > 0) {
				let score = matched.length-next_string.length;

				if(index != 0) {
					let c = matched.charCodeAt(index-1);
					if(c == 32 || c == 9) {
						for(let j = (index - 2); j >= 0; j--) {
							c = matched.charCodeAt(j);
							score -= ((c == 32 || c == 9) ? 1 : 0.15);
						}
					} else {
						score -= index;
					}
				}

				score += remaining_score * next_string.length;
				score /= matched.length;
				return score;
			}
		}
		return 0.0;
	}
};

// Class: TabHandlers - A object that handles all of the event handlers.
this.TabHandlers = {
	_mouseDownLocation: null,

	// Adds styles and event listeners to the matched tab items.
	onMatch: function(tab, index) {
		tab.addClass("onTop");
		index != 0 ? tab.addClass("notMainMatch") : tab.removeClass("notMainMatch");

		// Remove any existing handlers before adding the new ones. If we don't do this, then we may add more handlers than we remove.
		tab.$canvas
			.unbind("mousedown", TabHandlers._hideHandler)
			.unbind("mouseup", TabHandlers._showHandler);

		tab.$canvas
			.mousedown(TabHandlers._hideHandler)
			.mouseup(TabHandlers._showHandler);
	},

	// Removes styles and event listeners from the unmatched tab items.
	onUnmatch: function(tab, index) {
		tab.$container.removeClass("onTop");
		tab.removeClass("notMainMatch");

		tab.$canvas
			.unbind("mousedown", TabHandlers._hideHandler)
			.unbind("mouseup", TabHandlers._showHandler);
	},

	// Removes styles and event listeners from the unmatched tabs.
	onOther: function(tab, index) {
		// Unlike the other on* functions, in this function tab can either be a <TabItem> or a <xul:tab>. In other functions it is always a <TabItem>.
		// Also note that index is offset by the number of matches within the window.
		let item = iQ("<div/>")
			.addClass("inlineMatch")
			.click(function(event) {
				Search.hide(event);
				TabUtils.focus(tab);
			});

		iQ("<img/>")
			.attr("src", TabUtils.faviconURLOf(tab))
			.appendTo(item);

		iQ("<span/>")
			.text(TabUtils.nameOf(tab))
			.appendTo(item);

		index != 0 ? item.addClass("notMainMatch") : item.removeClass("notMainMatch");
		item.appendTo("#results");
		iQ("#otherresults").show();
	},

	// Performs when mouse down on a canvas of tab item.
	_hideHandler: function(event) {
		iQ("#search").fadeOut();
		iQ("#searchshade").fadeOut();
		TabHandlers._mouseDownLocation = { x:event.clientX, y:event.clientY };
	},

	// Performs when mouse up on a canvas of tab item.
	_showHandler: function(event) {
		// If the user clicks on a tab without moving the mouse then they are zooming into the tab and we need to exit search mode.
		if(TabHandlers._mouseDownLocation.x == event.clientX && TabHandlers._mouseDownLocation.y == event.clientY) {
			Search.hide();
			return;
		}

		iQ("#searchshade").show();
		iQ("#search").show();
		iQ("#searchbox")[0].focus();

		// Marshal the search.
		aSync(Search.perform, 0);
	}
};

// Class: Search - A object that handles the search feature.
this.Search = {
	_initiatedBy: "",
	_blockClick: false,
	_currentHandler: null,

	// Initializes the searchbox to be focused, and everything else to be hidden, and to have everything have the appropriate event handlers.
	init: function() {
		iQ("#search").hide();
		iQ("#searchshade").hide().mousedown((event) => {
			if(event.target.id != "searchbox" && !this._blockClick)
			this.hide();
		});

		iQ("#searchbox").keyup(() => {
			this.perform();
		});

		iQ("#searchbutton").mousedown(() => {
			this._initiatedBy = "buttonclick";
			this.ensureShown();
			this.switchToInMode();
		});

		window.addEventListener("focus", () => {
			if(this.isEnabled()) {
				this._blockClick = true;
				aSync(() => {
					this._blockClick = false;
				}, 0);
			}
		}, false);

		this.switchToBeforeMode();
	},

	// Handles all keydown before the search interface is brought up.
	_beforeSearchKeyHandler: function(e) {
		// Only match reasonable text-like characters for quick search.
		if(e.altKey || e.ctrlKey || e.metaKey) { return; }

		if((e.keyCode > 0 && e.keyCode <= e.DOM_VK_DELETE)
		|| e.keyCode == e.DOM_VK_CONTEXT_MENU
		|| e.keyCode == e.DOM_VK_SLEEP
		|| (e.keyCode >= e.DOM_VK_F1 && e.keyCode <= e.DOM_VK_SCROLL_LOCK)
		|| e.keyCode == e.DOM_VK_META
		// 91 = left windows key
		|| e.keyCode == 91
		// 92 = right windows key
		|| e.keyCode == 92
		|| (!e.keyCode && !e.charCode)) {
			return;
		}

		// If we are already in an input field, allow typing as normal.
		if(e.target.nodeName == "input") { return; }

		// / is used to activate the search feature so the key shouldn't be entered into the search box.
		if(e.keyCode == e.DOM_VK_SLASH) {
			e.stopPropagation();
			e.preventDefault();
		}

		this.switchToInMode();
		this._initiatedBy = "keydown";
		this.ensureShown(true);
	},

	// Handles all keydown while search mode.
	_inSearchKeyHandler: function(e) {
		let term = iQ("#searchbox").val();
		if((e.keyCode == e.DOM_VK_ESCAPE)
		|| (e.keyCode == e.DOM_VK_BACK_SPACE && term.length <= 1 && this._initiatedBy == "keydown")) {
			this.hide(e);
			return;
		}

		let matcher = this.createSearchTabMatcher();
		let matches = matcher.matched();
		let others =  matcher.matchedTabsFromOtherWindows();
		if(e.keyCode == e.DOM_VK_RETURN && (matches.length > 0 || others.length > 0)) {
			this.hide(e);
			if(matches.length > 0) {
				matches[0].zoomIn();
			} else {
				TabUtils.focus(others[0]);
			}
		}
	},

	// Make sure the event handlers are appropriate for the before-search mode.
	switchToBeforeMode: function() {
		if(this._currentHandler) {
			iQ(window).unbind("keydown", this._currentHandler);
		}
		this._currentHandler = (e) => {
			this._beforeSearchKeyHandler(e);
		}
		iQ(window).keydown(this._currentHandler);
	},

	// Make sure the event handlers are appropriate for the in-search mode.
	switchToInMode: function() {
		if(this._currentHandler) {
			iQ(window).unbind("keydown", this._currentHandler);
		}
		this._currentHandler = (e) => {
			this._inSearchKeyHandler(e);
		}
		iQ(window).keydown(this._currentHandler);
	},

	createSearchTabMatcher: function() {
		return new TabMatcher(iQ("#searchbox").val());
	},

	// Checks whether search mode is enabled or not.
	isEnabled: function() {
		return iQ("#search").css("display") != "none";
	},

	// Hides search mode.
	hide: function(e) {
		if(!this.isEnabled()) { return; }

		iQ("#searchbox").val("");
		iQ("#searchshade").hide();
		iQ("#search").hide();

		iQ("#searchbutton").css({ opacity:.8 });

		if(DARWIN) {
			UI.setTitlebarColors(true);
		}

		this.perform();
		this.switchToBeforeMode();

		if(e) {
			// when hiding the search mode, we need to prevent the keypress handler in UI__setTabViewFrameKeyHandlers to handle the key press again.
			// e.g. Esc which is already handled by the key down in this class.
			if(e.type == "keydown") {
				UI.ignoreKeypressForSearch = true;
			}
			e.preventDefault();
			e.stopPropagation();
		}

		// Return focus to the tab window
		UI.blurAll();
		gTabViewFrame.contentWindow.focus();

		dispatch(window, { type: "tabviewsearchdisabled", cancelable: false, bubbles: false });
	},

	// Performs a search.
	perform: function() {
		let matcher =  this.createSearchTabMatcher();

		// Remove any previous other-window search results and hide the display area.
		iQ("#results").empty();
		iQ("#otherresults").hide();
		iQ("#otherresults>.label").text(Strings.get("TabView", "searchOtherWindowTabs"));

		matcher.doSearch(TabHandlers.onMatch, TabHandlers.onUnmatch, TabHandlers.onOther);
	},

	// Ensures the search feature is displayed.  If not, display it.
	// Parameters:
	//  - a boolean indicates whether this is triggered by a keypress or not
	ensureShown: function(activatedByKeypress) {
		let $search = iQ("#search");
		let $searchShade = iQ("#searchshade");
		let $searchbox = iQ("#searchbox");
		iQ("#searchbutton").css({ opacity: 1 });

		if(!this.isEnabled()) {
			$searchShade.show();
			$search.show();

			if(DARWIN) {
				UI.setTitlebarColors({active: "#717171", inactive: "#EDEDED"});
			}

			if(activatedByKeypress) {
				// set the focus so key strokes are entered into the textbox.
				$searchbox[0].focus();
				dispatch(window, { type: "tabviewsearchenabled", cancelable: false, bubbles: false });
			} else {
				// marshal the focusing, otherwise it ends up with searchbox[0].focus gets called before the search button gets the focus after being pressed.
				aSync(function() {
					$searchbox[0].focus();
					dispatch(window, { type: "tabviewsearchenabled", cancelable: false, bubbles: false });
				}, 0);
			}
		}
	}
};

