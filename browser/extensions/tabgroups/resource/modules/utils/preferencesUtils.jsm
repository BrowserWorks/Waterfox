// VERSION 2.4.11
Modules.UTILS = true;

// dependsOn - object that adds a dependson attribute functionality to xul preference elements.
// Just add the attribute to the desired xul element and let the script do its thing. dependson accepts comma-separated or semicolon-separated strings in the following format:
//	[!]element[:value] where:
//		element - id of the preference element
//		(optional) ! - before element, checks for the opposite condition
//		(optional) :value - value is some specific value that element must have in order for the condition to return true
//	To condition for several dependencies: ',' is equivalent to AND and ';' to OR
//	examples:
//		element1 - checks if element1 is true
//		element2:someValue - checks if element2 has value of 'someValue'
//		element3:5 - checks if element3 has value 5
//		!element4 - checks if element4 is false
//		!element5:someOtherValue - checks if element5 has any value other than 'someOtherValue'
//		element6,element7:someValue - check if element6 is true and element7 has value of 'someValue'
//		element8:someValue;element9:someOtherValue - checks if element8 has value of 'someValue' or element9 has value of 'someOtherValue'
this.dependsOn = {
	getAll: function() {
		return $$("[dependson]");
	},

	handleEvent: function(e) {
		if(e.target.localName != 'preference' || !e.target.id) { return; }

		var fields = $$("[delayPreference='"+e.target.id+"'],[preference='"+e.target.id+"']");
		var elements = this.getAll();
		var alreadyChanged = new Set();

		for(let field of fields) {
			if(!field.id) { continue; }

			for(let node of elements) {
				if(alreadyChanged.has(node)) { continue; }

				if(node.getAttribute('dependson').includes(field.id)) {
					this.updateElement(node);
					alreadyChanged.add(node);
				}
			}
		}

		for(let node of elements) {
			if(alreadyChanged.has(node)) { continue; }

			if(node.getAttribute('dependson').includes(e.target.id)) {
				this.updateElement(node);
				alreadyChanged.add(node);
			}
		}
	},

	init: function() {
		this.updateAll();

		Listeners.add(window, "change", this);
	},

	uninit: function() {
		Listeners.remove(window, "change", this);
	},

	updateAll: function(override) {
		let elements = this.getAll();
		for(let node of elements) {
			this.updateElement(node, override);
		}
	},

	updateElement: function(el, override) {
		let attr = el.getAttribute('dependson');
		if(!attr) { return; }

		let dependencies = attr.split(',');
		for(let d of dependencies) {
			let alternates = d.split(';');
			let a = 0;
			while(a < alternates.length) {
				let inverse = false;
				let dependency = alternates[a].split(':');
				if(dependency[0].includes('!')) {
					inverse = true;
					dependency[0] = dependency[0].replace('!', '');
				}

				dependency[0] = trim(dependency[0]);
				if(dependency[0] == '') { continue; }

				if(dependency.length == 2) {
					dependency[1] = trim(dependency[1]);
				}

				let pref = $(dependency[0]);
				if(!pref) {
					Cu.reportError("Element of ID '"+dependency[0]+"' could not be found!");
					return;
				}

				switch(pref.type) {
					case 'int':
						var value = (dependency.length == 2) ? parseInt(dependency[1]) : 0;
						break;
					case 'bool':
						var value = (dependency.length == 1) ? true : (dependency[1] == 'true') ? true : false;
						break;
					case 'string':
					default:
						var value = (dependency.length == 2) ? dependency[1] : '';
						break;
				}

				let prefValue = (override && override.id == pref.id) ? override.value : pref.value;

				a++;
				if( (!inverse && prefValue !== value) || (inverse && prefValue === value) ) {
					if(a < alternates.length) { continue; }

					el.setAttribute('disabled', 'true');
					return;
				}
				else if(a < alternates.length) {
					el.removeAttribute('disabled');
					return;
				}
			}
		}
		el.removeAttribute('disabled');
	}
};


// delayPreferences -	every node pointing to a preference should be properly initialized with a "delayPreference" attribute instead of a "preference" attribute.
//			The native handler is very jumpy, for example a scale is very sluggish to move. Instead, we use a more aSynchronous process, so the UI doesn't stutter.
//			This is similar to the delayprefsave attribute in the native handler, except the delay is different;
//			see http://mxr.mozilla.org/mozilla-central/source/toolkit/content/widgets/preferences.xml or https://bugzilla.mozilla.org/show_bug.cgi?id=1008169
this.delayPreferences = {
	handleEvent: function(e) {
		switch(e.type) {
			case 'command':
				if(e.sourceEvent) {
					e = e.sourceEvent;
				}
				this.updateElement(e.target);
				break;

			case 'select':
				if(e.target.localName != 'colorpicker') { break; }
				// no break;

			case 'change':
				if(e.target.localName == 'preference') {
					if(e.target._updateItems) {
						for(let item of e.target._updateItems) {
							item._updateFromPref();
						}
					}
					break;
				}
				// no break;

			case 'input':
				this.updateElement(e.target);
				break;
		}
	},

	updateElement: function(aElement) {
		var element = aElement;
		while(element && element.nodeType == window.Node.ELEMENT_NODE && !element.hasAttribute("delayPreference")) {
			element = element.parentNode;
		}
		if(element.nodeType != window.Node.ELEMENT_NODE) {
			element = aElement;
		}

		if(element._persistToPref) {
			element._persistToPref();
		}
	},

	init: function() {
		// listen to changes made in the window
		Listeners.add(window, 'change', this);
		Listeners.add(window, 'input', this);
		Listeners.add(window, 'select', this);
		Listeners.add(window, 'command', this);

		var nodes = $$('[delayPreference]');
		for(let node of nodes) {
			node._pref = $(node.getAttribute('delayPreference'));
			node._pref.setElementValue(node);

			// add this item (node) to the list of nodes to be updated when the preference changes, so it doesn't have to look up through the DOM every time
			if(!node._pref._updateItems) {
				node._pref._updateItems = [];

				Listeners.add(node._pref, 'change', this);
			}
			node._pref._updateItems.push(node);

			node._checkHandling = function() {
				if(this._timer) {
					this._timer.cancel();
					delete this._timer;
				}
				return !this._handling;
			};

			// will be called when a user changes any preference in the pane
			node._persistToPref = function() {
				if(!this._checkHandling()) { return; }

				// our delayed system of persisting prefs shouldn't interfere with the changes in the UI being immediate
				dependsOn.updateAll({
					id: this._pref.id,
					value: this._pref.getElementValue(this)
				});

				this._timer = aSync(() => {
					this._handling = true;
					this._pref.value = this._pref.getElementValue(this);
					this._handling = false;
					delete this._timer;
				}, 250);
			};

			// this updates the value on the item node from the preference
			node._updateFromPref = function() {
				if(!this._checkHandling()) { return; }

				this._handling = true;
				this._pref.setElementValue(this);
				this._handling = false;
			};
		}
	},

	uninit: function() {
		Listeners.remove(window, 'change', this);
		Listeners.remove(window, 'input', this);
		Listeners.remove(window, 'select', this);
		Listeners.remove(window, 'command', this);

		var nodes = $$('[delayPreference]');
		for(let node of nodes) {
			Listeners.remove(node._pref, 'change', this);

			// make sure we don't lose any changes, for those fast as lightning users out there
			if(node._timer) {
				node._timer.cancel();
				node._timer.handler();
				delete node._timer;
			}

			delete node._pref._updateItems;
			delete node._pref;
			delete node._checkHandling;
			delete node._persistToPref;
			delete node._updateFromPref;
		}
	}
};

// keys - should automatically take care of all the labels, entries and actions of any keysets to be registered through the Keysets object.
// It looks for and expects each keyset to be layouted (is this even a word?) in the XUL options page as such:
// 	<checkbox keysetAccel="keyName" delayPreference="pref-to-accel"/>
//	<checkbox keysetAlt="keyName" delayPreference="pref-to-alt"/>
//	<checkbox keysetShift="keyName" delayPreference="pref-to-shift"/>
//	<checkbox keysetCtrl="keyName" delayPreference="pref-to-ctrl"/> <-- will be shown on OSX only
//	<menulist keyset="keyName" delayPreference="pref-to-keycode"/>
this.keys = {
	all: [],

	handleEvent: function(e) {
		this.fillKeycodes();
	},

	init: function() {
		let done = new Set();
		let all = $$('[keyset]');
		for(let node of all) {
			let id = node.getAttribute('keyset');
			if(done.has(id)) { continue; }
			done.add(id);

			if(!node.firstChild) {
				node.appendChild(document.createElement('menupopup'));
			}

			let key = {
				id: id,
				node: node,
				accelBox: $$('[keysetAccel="'+id+'"]')[0],
				shiftBox: $$('[keysetShift="'+id+'"]')[0],
				altBox: $$('[keysetAlt="'+id+'"]')[0],
				ctrlBox: $$('[keysetCtrl="'+id+'"]')[0],
				get disabled () { return trueAttribute(this.node, 'disabled'); },
				get keycode () { return this.node.value; },
				set keycode (v) { return this.node.value = v; },
				get accel () { return this.accelBox.checked; },
				get shift () { return this.shiftBox.checked; },
				get alt () { return this.altBox.checked; },
				get ctrl () { return DARWIN && this.ctrlBox.checked; },
				get menu () { return this.node.firstChild; }
			};

			this.all.push(key);
			Keysets.fillKeyStrings(key);

			Listeners.add(key.node, 'command', this);
			Listeners.add(key.accelBox, 'command', this);
			Listeners.add(key.shiftBox, 'command', this);
			Listeners.add(key.altBox, 'command', this);
			Listeners.add(key.ctrlBox, 'command', this);
		}

		this.fillKeycodes();
	},

	uninit: function() {
		for(let key of this.all) {
			Listeners.remove(key.node, 'command', this);
			Listeners.remove(key.accelBox, 'command', this);
			Listeners.remove(key.shiftBox, 'command', this);
			Listeners.remove(key.altBox, 'command', this);
			Listeners.remove(key.ctrlBox, 'command', this);
		}
	},

	fillKeycodes: function() {
		for(let key of this.all) {
			let available = Keysets.getAvailable(key, this.all);
			if(!available[key.keycode]) {
				key.keycode = 'none';
			}

			var item = key.menu.firstChild.nextSibling;
			while(item) {
				item.setAttribute('hidden', 'true');
				item.setAttribute('disabled', 'true');
				item = item.nextSibling;
			}
			if(key.keycode == 'none') {
				key.menu.parentNode.selectedItem = key.menu.firstChild;
				$(key.menu.parentNode.getAttribute('delayPreference')).value = 'none';
			}

			for(let item of key.menu.childNodes) {
				let keycode = item.getAttribute('value');
				if(!available[keycode]) { continue; }

				item.removeAttribute('hidden');
				item.removeAttribute('disabled');
				if(keycode == key.keycode) {
					key.menu.parentNode.selectedItem = item;
					// It has the annoying habit of re-selecting the first (none) entry when selecting a menuitem with '*' as value
					if(keycode == '*') {
						var itemIndex = key.menu.parentNode.selectedIndex;
						aSync(function() { key.menu.parentNode.selectedIndex = itemIndex; });
					}
				}
			}
		}
	}
};

// In case I need subdialogs:
//   http://mxr.mozilla.org/mozilla-central/source/browser/components/preferences/in-content/subdialogs.js
//   http://mxr.mozilla.org/mozilla-central/source/browser/components/preferences/in-content/preferences.xul#197

// categories - aid to properly display preferences in a tab, just like the current native options tab
// adapted from http://mxr.mozilla.org/mozilla-central/source/browser/components/preferences/in-content/preferences.js
// unlike in the original, we don't use hidden, instead we use collapsed to switch between panels, so that all the bindings remain applied throughout the page.
this.categories = {
	lastHash: "",

	get categories () { return $('categories'); },
	get prefPane () { return $('mainPrefPane'); },

	modules: new Map(),

	handleEvent: function(e) {
		switch(e.type) {
			case 'select':
				this.gotoPref(e.target.value)
				break;

			case 'keydown':
				if(e.keyCode == e.DOM_VK_TAB) {
					setAttribute(this.categories, "keyboard-navigation", "true");
				}
				break;

			case 'mousedown':
				removeAttribute(this.categories, "keyboard-navigation");
				break;

			case 'hashchange':
				this.gotoPref();
				break;
		}
	},

	init: function() {
		document.documentElement.instantApply = true;

		// sometimes it may happen that the overlays aren't loaded in the correct order, which means the categories might not be ordered correctly,
		// it's definitely better UX if the categories are always in the same order, so we try to ensure this
		let categories = $('categories');
		let node = categories.firstChild;
		while(node) {
			let position = node.getAttribute('position');
			if(position) {
				position = parseInt(position);
				let sibling = null;
				let previous = node.previousSibling;
				while(previous) {
					let related = previous.getAttribute('position');
					if(related) {
						related = parseInt(related);
						if(position < related) {
							sibling = previous;
						} else {
							break;
						}
					}
					previous = previous.previousSibling;
				}

				if(sibling) {
					categories.insertBefore(node, sibling);
				}
			}

			node = node.nextSibling;
		}

		Listeners.add(this.categories, "select", this);
		Listeners.add(document.documentElement, "keydown", this);
		Listeners.add(this.categories, "mousedown", this);
		Listeners.add(window, "hashchange", this);

		if(window.__gotoPane) {
			this.gotoPref(window.__gotoPane);
			delete window.__gotoPane;
		} else {
			this.gotoPref();
		}
		this.dynamicPadding();
	},

	uninit: function() {
		Listeners.remove(this.categories, "select", this);
		Listeners.remove(document.documentElement, "keydown", this);
		Listeners.remove(this.categories, "mousedown", this);
		Listeners.remove(window, "hashchange", this);

		for(let module of this.modules.values()) {
			Modules.unload(module);
		}
	},

	addModule: function(category, module) {
		if(!this.modules.has(category)) {
			this.modules.set(category, module);
		}

		if(this.lastHash == category) {
			Modules.load(module);
		}
	},

	// Make the space above the categories list shrink on low window heights
	dynamicPadding: function() {
		let catPadding = parseInt(getComputedStyle(this.categories).paddingTop);
		let fullHeight = this.categories.lastElementChild.getBoundingClientRect().bottom;
		let mediaRule = `
			@media (max-height: ${fullHeight}px) {
				#categories {
					padding-top: calc(100vh - ${fullHeight - catPadding}px);
				}
			}
		`;
		let mediaStyle = document.createElementNS('http://www.w3.org/1999/xhtml', 'html:style');
		mediaStyle.setAttribute('type', 'text/css');
		mediaStyle.appendChild(document.createCDATASection(mediaRule));
		document.documentElement.appendChild(mediaStyle);
	},

	gotoPref: function(aCategory) {
		const kDefaultCategoryInternalName = this.categories.firstElementChild.value;
		let hash = document.location.hash;
		let category = aCategory || hash.substr(1) || Prefs.lastPrefPane || kDefaultCategoryInternalName;
		category = this.friendlyPrefCategoryNameToInternalName(category);

		// Updating the hash (below) or changing the selected category will re-enter gotoPref.
		if(this.lastHash == category) { return; }

		let activeElement = document.activeElement;

		let item = this.categories.querySelector(".category[value="+category+"]");
		if(!item) {
			category = kDefaultCategoryInternalName;
			item = this.categories.querySelector(".category[value="+category+"]");
		}

		let newHash = this.internalPrefCategoryNameToFriendlyName(category);
		if(this.lastHash || category != kDefaultCategoryInternalName) {
			document.location.hash = newHash;
		}

		// Need to set the lastHash before setting categories.selectedItem since the categories 'select' event will re-enter the gotoPref codepath.
		this.lastHash = category;
		this.categories.selectedItem = item;
		setAttribute(document.documentElement, 'currentcategory', category);

		// I can't save the last category in a persisted attribute because it persists to the hashed url;
		// don't remember the About pane, there's no need to and it would hardly be useful
		if(category != 'paneAbout') {
			Prefs.lastPrefPane = category;
		}

		window.history.replaceState(category, document.title);
		this.search(category, "data-category");
		document.querySelector(".main-content").scrollTop = 0;

		// if the current pane requires its own module, load it now that the pane is visible;
		// this speeds up showing the preferences, by only loading what's needed when it's needed,
		// which for instance prevents fetching remote data (latest add-on version, development status) when it's not needed
		if(this.modules.has(category)) {
			Modules.load(this.modules.get(category));
		}

		// changing the location hash will cause the focus to shift to the page, and we want it to stay in the jumpto box if it was there before
		if(category != 'paneAbout'
		&& activeElement && controllers.nodes.jumpto
		&& activeElement == controllers.nodes.jumpto.inputField
		&& activeElement != document.activeElement) {
			activeElement.focus();
		}
	},

	search: function(aQuery, aAttribute) {
		let elements = this.prefPane.children;
		for(let element of elements) {
			if(element.nodeName == 'preferences') { continue; }

			let attributeValue = element.getAttribute(aAttribute);
			element.collapsed = (attributeValue != aQuery);
		}
	},

	friendlyPrefCategoryNameToInternalName: function(aName) {
		if(aName.startsWith("pane")) {
			return aName;
		}

		return "pane" + aName.substring(0,1).toUpperCase() + aName.substr(1);
	},

	// This function is duplicated inside of utilityOverlay.js's openPreferences.
	internalPrefCategoryNameToFriendlyName: function(aName) {
		return (aName || "").replace(/^pane./, function(toReplace) { return toReplace[4].toLowerCase(); });
	}
};

// helptext -	mostly a fancy tooltip system for the in-content preferences, the help text is shown on the right at the edge of the prefPane node,
//		or right next to the hovered item when there is not enough space at the edge.
// Simply add any of the following attributes to any nodes that are meant to show the helptext when they are hovered or selected:
//	helptext - text value to be used directly as the helptext content, the simplest form of this feature and the one most closely resembling a native tooltip
//	helpbox - id pointing to a node that will be shown in the helptext panel, useful for more complex instances and takes precedence over helptext
//	helpactive - set in nodes that will be selectable using the keyboard (i.e. scales, radiogroups), the script will look for the other attributes in any related node
this.helptext = {
	kPanelWidth: 311, // roughly the maximum size of the panel node
	kContentsWidth: 275, // the actual maximum size of the helptext contents

	root: null,
	panel: null,
	contents: null,
	main: null,
	prefPane: null,

	handleEvent: function(e) {
		switch(e.type) {
			case 'focus':
			case 'mouseover':
				this.show(e.target);
				break;

			case 'blur':
				// don't hide the popup when clicking a preference to toggle it (which in turn blurs it)
				if(this.panel._activeItem) {
					let checkers = [];
					if(this.panel._activeItem.hasAttribute('helptext')) {
						checkers.push('[helptext="'+this.panel._activeItem.getAttribute('helptext')+'"]:hover');
					}
					if(this.panel._activeItem.hasAttribute('helpbox')) {
						checkers.push('[helpbox="'+this.panel._activeItem.getAttribute('helpbox')+'"]:hover');
					}

					let hovered = checkers.length > 0 && $$(checkers.join(','))[0];
					if(hovered) { return; }
				}
				// no break;

			case 'mouseout':
				this.hide();
				break;

			case 'popuphidden':
				while(this.contents.firstChild) {
					this.contents.firstChild.remove();
				}
				break;
		}
	},

	show: function(target) {
		// duh
		Timers.cancel('closeHelpText');

		// immediately hide the panel if the mouse touches it, the user might be trying to reach something behind
		if(target == this.panel) {
			this.panel.hidePopup();
			return;
		}
		else {
			// special case for radiogroup
			if(target._helpactive && target.selectedItem) {
				target = target.selectedItem;
			}

			if(!target || target.disabled) {
				this.hide();
				return;
			}

			while(!target._helptext && !target._helpbox) {
				target = target.parentNode;
				if(!target || target.disabled) {
					this.hide();
					return;
				}
			}
		}

		// no point in reshowing if the box is already showing what it's supposed to
		if(this.panel.state == 'open' && this.panel._activeItem == target) { return; }

		// append the current helptext relative to the hovered item
		var text = target._helpbox;
		if(text) {
			text = $(text);
			if(text) {
				text = this.panel.ownerDocument.importNode(text, true);
				text.collapsed = false;
			}
		}
		if(!text) {
			text = target._helptext;
			if(!text) {
				this.hide();
				return;
			}

			let description = this.panel.ownerDocument.createElement('description');
			description.textContent = text;
			text = description;
		}

		// remove any previous helptext
		while(this.contents.firstChild) {
			this.contents.firstChild.remove();
		}

		this.contents.appendChild(text);
		this.panel._activeItem = target;

		let position = 'rightcenter bottomleft';
		let x = 0;
		let free = 0;

		if(LTR) {
			// try to open the helptext at the end of the prefPane element (about where the header underline ends)
			x = (this.prefPane.boxObject.x +this.prefPane.boxObject.width) - (target.boxObject.x +target.boxObject.width);

			// but whenever possible don't show the helptext outside of the tab's boundaries, in case the window isn't wide enough
			free = (this.main.boxObject.x +this.main.boxObject.width) - (this.prefPane.boxObject.x +this.prefPane.boxObject.width);
		}
		else {
			// same thing except reversed on the left for RTL layouts
			x = target.boxObject.x -this.prefPane.boxObject.x;

			free = this.prefPane.boxObject.x -this.main.boxObject.x;
		}

		if(free < this.kPanelWidth) {
			x -= this.kPanelWidth -free;
		}

		// negative values for this would be silly, the helptext would appear over the item it's supposed to help with,
		// so show it right next to the item if this happens for some reason
		x = Math.max(x, 0);

		if(this.panel.state == 'open') {
			this.panel.moveToAnchor(target, position, x);
		} else {
			this.panel.openPopup(target, position, x);
		}
	},

	hide: function() {
		Timers.init('closeHelpText', () => {
			if(this.panel.state == 'closed') { return; }

			this.panel.hidePopup();
		}, 250);
	},

	onLoad: function() {
		this.panel = this.root.document.getElementById(objName+'-helptext');
		this.contents = this.root.document.getElementById(objName+'-helptext-contents');
		this.main = $$('.main-content')[0];
		this.prefPane = this.main.firstChild;

		// avoid using a stylesheet for this, it's just simpler this way because of this being used by multiple add-ons
		// (hence avoid using multiple stylesheets with the same declarations)
		this.contents.style.maxWidth = this.kContentsWidth+'px';

		// ensure the direction of the panel is the same as the preferences tab direction (main window could be different if add-on doesn't include the RTL locale used)
		this.panel.style.direction = getComputedStyle(document.documentElement).direction;

		Listeners.add(this.panel, 'mouseover', this);
		Listeners.add(this.panel, 'popuphidden', this);

		let nodes = $$('[helptext],[helpbox],[helpactive]');
		for(let node of nodes) {
			if(node._helptext || node._helpbox || node._helpactive) { continue; }
			node._helptext = node.getAttribute('helptext');
			node._helpbox = node.getAttribute('helpbox');
			node._helpactive = node.getAttribute('helpactive');

			// there's this weird bug where the style attributes don't take effect until they're re-added, go figure...
			if(node._helpbox) {
				let box = $(node._helpbox);
				if(box) {
					let styled = $$('[style]', box);
					for(let inner of styled) {
						setAttribute(inner, 'style', inner.getAttribute('style')+' ');
					}
				}
			}

			Listeners.add(node, 'mouseover', this);
			Listeners.add(node, 'mouseout', this);
			Listeners.add(node, 'focus', this);
			Listeners.add(node, 'blur', this);
		}
	},

	uninit: function() {
		Timers.cancel('closeHelpText');
		Listeners.remove(this.panel, 'mouseover', this);
		Listeners.remove(this.panel, 'popuphidden', this);

		let nodes = $$('[helptext],[helpbox],[helpactive]');
		for(let node of nodes) {
			if(!node._helptext && !node._helpbox && !node._helpactive) { continue; }

			delete node._helptext;
			delete node._helpbox;
			delete node._helpactive;
			Listeners.remove(node, 'mouseover', this);
			Listeners.remove(node, 'mouseout', this);
			Listeners.remove(node, 'focus', this);
			Listeners.remove(node, 'blur', this);
		}
	}
};

// controllers - object that manages the buttons and jump to field at the footer of the preferences tab
//	undo() - undoes the last action, self-explanatory
//	redo() - undoes the undo(), self-explanatory
//	reset() - resets all preferences in the prefList object
//	export() - presents a dialog to the user, to choose a file location to export the add-on's current preferences values (exported as JSON data)
//	import() - presents a dialog to the user, to choose a JSON file from which to import preferences; any preferences are missing from the file will be reset
//	jumpto() -	brings the user to the first node containing the word searched for; only nodes containing a "jump" attribute are considered in the following order:
//				1) match the word with a partial of the "jump" attribute value; good for keywords or preference names
//				2) match the word with the collective text value of all descendents of the node
this.controllers = {
	initialized: false,

	nodes: {
		undo: null,
		redo: null,
		import: null,
		export: null,
		reset: null,
		jumpto: null
	},

	current: {},
	past: [],
	future: [],

	jumpNodes: [],
	highlighted: null,

	handleEvent: function(e) {
		switch(e.type) {
			case 'command':
				switch(e.target) {
					case this.nodes.undo:
						this.undo();
						break;

					case this.nodes.redo:
						this.redo();
						break;

					case this.nodes.import:
						this.import();
						break;

					case this.nodes.export:
						this.export();
						break;

					case this.nodes.reset:
						this.reset();
						break;
				}
				break;

			case 'input':
				this.jumpto();
				break;

			case 'keypress':
				if(e.keyCode == e.DOM_VK_RETURN) {
					this.jumpto();
				}
				break;

			case 'dragover':
				if(e.dataTransfer.types.contains("text/plain")) {
					e.preventDefault();
				}
				break;

			case 'drop':
				let value = e.dataTransfer.getData("text/plain");
				this.nodes.jumpto.value = value;
				this.jumpto();
				e.stopPropagation();
				e.preventDefault();
				break;
		}
	},

	observe: function(aSubject, aTopic, aData) {
		Timers.init('delaySaveState', () => {
			// 'current' now refers to the previous preferences state, so we add it to the list of past states for the undo button to cycle through
			this.past.push(this.current);

			// any change to the preferences should null any redo function that might have been enabled by hitting undo
			this.future = [];

			// get a new 'current' state from the actual current preferences values
			this.init(true);
		}, 50);
	},

	init: function(prefsOnly) {
		if(!prefsOnly) {
			this.nodes.undo = $('undoButton');
			this.nodes.redo = $('redoButton');
			this.nodes.import = $('importButton');
			this.nodes.export = $('exportButton');
			this.nodes.reset = $('resetButton');
			this.nodes.jumpto = $('jumpto');

			Listeners.add(this.nodes.undo, 'command', this);
			Listeners.add(this.nodes.redo, 'command', this);
			Listeners.add(this.nodes.import, 'command', this);
			Listeners.add(this.nodes.export, 'command', this);
			Listeners.add(this.nodes.reset, 'command', this);

			Listeners.add(this.nodes.jumpto, 'input', this);
			Listeners.add(this.nodes.jumpto, 'keypress', this);
			Listeners.add(this.nodes.jumpto, 'dragover', this);
			Listeners.add(this.nodes.jumpto, 'drop', this);

			this.getJumpNodes();
			this.nodes.jumpto.value = '';
			this.jumpto(); // set an initial state

			// when first opening the preferences tab, set the cursor in there, so the user can start typing right away
			this.focusJumpto();
		}

		this.current = {};
		for(let pref in prefList) {
			if(pref.startsWith('NoSync_')) { continue; }

			this.current[pref] = Prefs[pref];
			if(!this.initialized) {
				Prefs.listen(pref, this);
			}
		}

		this.checkButtons();
		this.initialized = true;

		// check if we're supposed to jump to a specific preference right away
		if(window.__jumpTo) {
			this.jumpto(window.__jumpTo);
			delete window.__jumpTo;
		}
	},

	uninit: function(prefsOnly) {
		Timers.cancel('delaySaveState'); // this shouldn't be needed to be called but better make sure

		if(!prefsOnly) {
			Timers.cancel('showHelptextOnHighlight');

			Listeners.remove(this.nodes.undo, 'command', this);
			Listeners.remove(this.nodes.redo, 'command', this);
			Listeners.remove(this.nodes.import, 'command', this);
			Listeners.remove(this.nodes.export, 'command', this);
			Listeners.remove(this.nodes.reset, 'command', this);

			Listeners.remove(this.nodes.jumpto, 'input', this);
			Listeners.remove(this.nodes.jumpto, 'keypress', this);
			Listeners.remove(this.nodes.jumpto, 'dragover', this);
			Listeners.remove(this.nodes.jumpto, 'drop', this);
		}

		if(this.initialized) {
			for(let pref in prefList) {
				if(pref.startsWith('NoSync_')) { continue; }
				Prefs.unlisten(pref, this);
			}

			this.initialized = false;
		}
	},

	checkButtons: function() {
		$('undoButton').disabled = this.past.length == 0;
		$('redoButton').disabled = this.future.length == 0;
	},

	undo: function() {
		this.undoRedo('past', 'future');
	},

	redo: function() {
		this.undoRedo('future', 'past');
	},

	undoRedo: function(from, to) {
		if(this[from].length == 0) { return; }

		// remove the listeners
		this.uninit(true);

		this[to].push(this.current);

		let state = this[from].pop();
		for(let pref in state) {
			// I don't think this would trigger any change events when assigning the same value, but didn't feel like testing...
			if(state[pref] != Prefs[pref]) {
				Prefs[pref] = state[pref];
			}
		}

		// reimplement the listeners and get a new 'current' state
		this.init(true);
	},

	reset: function() {
		for(let pref in prefList) {
			if(pref.startsWith('NoSync_')) { continue; }
			Prefs.reset(pref);
		}
	},

	export: function() {
		this.showFilePicker(Ci.nsIFilePicker.modeSave, objPathString+'-prefs', function(aFile) {
			let { TextEncoder, OS } = Cu.import("resource://gre/modules/osfile.jsm", {});

			let list = { [objName]: AddonData.version };
			for(let pref in prefList) {
				list[pref] = Prefs[pref];
			}
			let save = (new TextEncoder()).encode(JSON.stringify(list));

			OS.File.open(aFile.path, { truncate: true }).then(function(ref) {
				ref.write(save).then(function() {
					ref.close();
				});
			});
		});
	},

	import: function() {
		this.showFilePicker(Ci.nsIFilePicker.modeOpen, null, function(aFile) {
			let { TextDecoder, OS } = Cu.import("resource://gre/modules/osfile.jsm", {});

			OS.File.open(aFile.path, { read: true }).then(function(ref) {
				ref.read().then(function(saved) {
					ref.close();

					try {
						let list = JSON.parse((new TextDecoder()).decode(saved));
						if(!list[objName]) { return; }

						for(let pref in prefList) {
							if(pref in list) {
								Prefs[pref] = list[pref];
							} else {
								Prefs.reset(pref);
							}
						}
					}
					// this doesn't really matter, for the user an invalid file will seem like it no-ops
					catch(ex) { Cu.reportError(ex); }
				});
			});
		});
	},

	showFilePicker: function(mode, prefix, aCallback) {
		let fp = Cc["@mozilla.org/filepicker;1"].createInstance(Ci.nsIFilePicker);
		fp.defaultExtension = 'json';
		fp.appendFilter('JSON data', '*.json');

		if(mode == Ci.nsIFilePicker.modeSave) {
			let date = new Date();
			let dateStr = date.getFullYear()+'-'+date.getMonth()+'-'+date.getDate()+'-'+date.getHours()+'-'+date.getMinutes()+'-'+date.getSeconds();
			fp.defaultString = prefix+'-'+dateStr;
		}

		fp.init(window, null, mode);
		fp.open(function(aResult) {
			if(aResult != Ci.nsIFilePicker.returnCancel) {
				aCallback(fp.file);
			}
		});
	},

	getJumpNodes: function() {
		this.jumpNodes = $$('[jump]');
		for(let node of this.jumpNodes) {
			node._jumpPref = node.getAttribute('jump').toLowerCase();
			node._jumpText = this.getJumpText(node).toLowerCase();
		}
	},

	getJumpText: function(node) {
		switch(node.nodeName) {
			case 'checkbox':
			case 'radio':
			case 'button':
				return node.getAttribute('label');

			case 'label':
			case 'description':
				return node.textContent || node.value;

			default:
				if(!node.childNodes || node.childNodes.length == 0) { return ''; }

				let ret = '';
				for(let child of node.childNodes) {
					ret += this.getJumpText(child);
				}
				return ret;
		}
	},

	jumpto: function(override) {
		if(typeof(override) == 'string') {
			this.nodes.jumpto.value = override;
		}

		let val = this.nodes.jumpto.value;
		if(!val) {
			this.clearHighlighted(false);
			helptext.hide();
			return;
		}
		val = val.toLowerCase();

		// first find the exact word in the jump attributes
		for(let node of this.jumpNodes) {
			if(node._jumpPref.includes(val)) {
				this.highlight(node);
				return;
			}
		}

		// try to find the word in the collective text of the nodes childNodes
		for(let node of this.jumpNodes) {
			if(node._jumpText.includes(val)) {
				this.highlight(node);
				return;
			}
		}

		// couldn't find the word, so tell that to the user
		this.clearHighlighted(true);
		helptext.hide();
	},

	clearHighlighted: function(notfound) {
		Timers.cancel('showHelptextOnHighlight');

		if(this.highlighted) {
			this.highlighted.classList.remove('highlight');
			this.highlighted = null;
		}

		toggleAttribute(this.nodes.jumpto, 'notfound', notfound);
	},

	highlight: function(node) {
		this.clearHighlighted(false);

		// in case the node is in another pane, we need to show it first, otherwise we can't scroll to it
		let pane = node;
		while(!pane.hasAttribute('data-category')) {
			pane = pane.parentNode;

			// we went too far, something went wrong
			if(!pane.parentNode) { return; }
		}

		pane = pane.getAttribute('data-category');
		categories.gotoPref(pane);

		node.scrollIntoView();
		node.classList.add('highlight');
		this.highlighted = node;

		// show the helptext in the found item if it can; aSync works best, with all the possible scrolling and all
		Timers.init('showHelptextOnHighlight', function() {
			helptext.show(node);
		}, 100);
	},

	focusJumpto: function() {
		if(categories.lasthash != 'paneAbout') {
			this.nodes.jumpto.select();
			this.nodes.jumpto.focus();
		}
	}
};

this.DnDproxy = {
	areas: null,

	init: function() {
		// we initialize the DnDprefs module only if there are any such areas to be initialized
		this.areas = $$('[DnDpref]');
		for(let area of this.areas) {
			let pref = area.getAttribute('DnDpref');
			if(pref) {
				DnDprefs.addArea(pref, area);
			}
		}
	},

	uninit: function() {
		if(this.areas) {
			for(let area of this.areas) {
				let pref = area.getAttribute('DnDpref');
				if(pref) {
					DnDprefs.removeArea(pref, area);
				}
			}
		}
	}
};

Modules.LOADMODULE = function() {
	alwaysRunOnClose.push(function() {
		Overlays.removeOverlayWindow(helptext.root, 'utils/helptext');
	});

	callOnLoad(window, function() {
		DnDproxy.init();
		delayPreferences.init();
		dependsOn.init();
		keys.init();
		categories.init();
		controllers.init();

		// investigate when exactly I can use windowRoot
		helptext.root = window.windowRoot
			? window.windowRoot.ownerGlobal
			: window.QueryInterface(Ci.nsIInterfaceRequestor)
				.getInterface(Ci.nsIWebNavigation)
				.QueryInterface(Ci.nsIDocShellTreeItem)
				.rootTreeItem
				.QueryInterface(Ci.nsIInterfaceRequestor)
				.getInterface(Ci.nsIDOMWindow);

		Overlays.overlayWindow(helptext.root, 'utils/helptext', helptext);
	});
};

Modules.UNLOADMODULE = function() {
	dependsOn.uninit();
	delayPreferences.uninit();
	DnDproxy.uninit();
	keys.uninit();
	categories.uninit();
	controllers.uninit();
	helptext.uninit();

	Overlays.removeOverlayWindow(helptext.root, 'utils/helptext');

	if(UNLOADED) {
		window.close();
	}
};
