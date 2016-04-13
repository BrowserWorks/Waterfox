// VERSION 1.0.2
Modules.UTILS = true;

// DnDprefs -	this is an adaptation of the browser's gCustomizeMode - http://mxr.mozilla.org/mozilla-central/source/browser/components/customizableui/CustomizeMode.jsm
//		it allows me to easily create customizable areas in the preferences, carrying over used and unused portions of whatever preferences, and their relative order.
//		The customizable items will be draggable in the same fashion as the browser's customize mode; DnD comes from Drag and Drop.
//		Just add any box node to the preferences pane with a DnDpref attr with the name of the (string) preference to be used as its value, it will be init'ed automatically:
//			<vbox id="someId" DnDpref="aPref" helpbox="helpboxId" />
//		If the helpbox attribute is present, any descriptions provided to this object for each widget will be appended there.
// getPref(aPref) -	returns the constructed object values for aPref, in the form:
//			(object) {
//				order - (array) list of (str) widget ids in the specific order they were customized
//				settings - (Map()) with (str) widget ids mapped to (object) {
//					active - (bool) whether the widget is currently active, as in are there any instances of it initialized
//					enable - (bool) whether the widget has not been hidden/disabled by the user
//				}
//			}
// addHandler(aPref, aHandler) -	use to register a listener for when changes are made to the DnD preference; preferred so that instead of listening to the value directly,
//					the handler will receive all the related settings directly in object form.
//	aPref - (string) preference to listen to
//	aHandler -	(object) or (function) preference listener (see Prefs.jsm for implementation) where aData will already take the constructed object form defined above.
// removeHandler(aPref, aHandler) - unregister a listener for changes to a DnD preference
//	see addHandler()
// addWidget(aPref, aId, aInstance, aLabel, aDescription, aDependsOn) - initializes a widget instance to be recorded and handled as part of a DnD preference
//	aPref - (string) which preference should handle this widget
//	aId -	(string) widget/feature id to be initialized. The draggable node in the preferences area region will take the id "objName-DnDpref-aId".
//		Ideally, a CSS stylesheet should accompany this, to style its image node (class selector: ".DnDpref-icon") to give it an icon.
//	aInstance - widget instance that has been initialized, preferably a DOM node or an object, but can be anything really
//	aLabel - (string) will be displayed in the draggable node in the preference areas, below the corresponding image (class selector ".DnDpref-label").
//	aDescription - (string) short description to be shown in the helptext of the area node
//	(optional) aDependsOn - (string) conditional to disable the widget's checkbox in the preference, following the rules of the dependsOn object (preferencesUtils.jsm)
// removeWidget(aPref, aId, aInstance) - deinitialies a widget instance.
//	see addWidget()
this.DnDprefs = {
	kDragDataTypePrefix: "text/DnDpref-container-id/",
	kWidgetPrefix: objName+'-DnDpref-',

	_dragOffset: {},
	_dragOverItem: null,
	_dragWindow: null,

	prefs: new Map(),

	getPref: function(aPref) {
		let pref = this.prefs.get(aPref)
		return pref && pref.placements;
	},

	addHandler: function(aPref, aHandler) {
		let pref = this.initPref(aPref);
		pref.handlers.add(aHandler);
	},

	removeHandler: function(aPref, aHandler) {
		let pref = this.prefs.get(aPref);
		if(!pref) { return; }

		pref.handlers.delete(aHandler);
		this.deinitPref(aPref);
	},

	addWidget: function(aPref, aId, aInstance, aLabel, aDescription, aDependsOn) {
		let pref = this.initPref(aPref);
		let widget = pref.active.get(aId);

		if(!widget) {
			widget = {
				id: aId,
				label: aLabel || aId,
				description: aDescription || '',
				dependson: aDependsOn || '',
				instances: new Set()
			};
			pref.active.set(aId, widget);

			// if this is a new widget, we place it last
			if(!pref.placements.settings.has(aId)) {
				pref.placements.order.push(aId);
				pref.placements.settings.set(aId, this._newSetting(pref, aId));
			}
			this._savePlacements(pref);

			// add the widget to any initialized areas
			for(let area of pref.areas) {
				this.addWidgetItem(pref, widget, area);
				this._updateArea(area);
			}
		}

		widget.instances.add(aInstance);
	},

	removeWidget: function(aPref, aId, aInstance) {
		let pref = this.prefs.get(aPref);
		if(!pref || !pref.active.has(aId)) { return; }

		let widget = pref.active.get(aId);
		let instances = widget.instances;
		instances.delete(aInstance);

		if(!instances.size) {
			for(let area of pref.areas) {
				this.removeWidgetItem(widget, area);
			}
			pref.active.delete(aId);
		}

		this.deinitPref(aPref);
	},

	addArea: function(aPref, aArea) {
		let pref = this.initPref(aPref);
		if(pref.areas.has(aArea)) { return; }

		pref.areas.add(aArea);
		aArea._pref = aPref;

		// get the helpbox node, so that any widget descriptions can be easily appended there
		let descriptions = aArea.getAttribute('helpbox');
		if(descriptions) {
			aArea._descriptions = aArea.ownerDocument.getElementById(descriptions);
		}

		// placeholder that will be placed at the end of this area, so that widgets can be more easily moved to the last position
		let end = this.createWidgetItem(aArea.ownerDocument, ' ');
		end.classList.add('DnDpref-area-placeholder');
		aArea._endPlaceholder = end;

		// add all initialized widgets to the area
		for(let widget of pref.active.values()) {
			this.addWidgetItem(pref, widget, aArea);
		}
		this._updateArea(aArea);

		this._addDragHandlers(aArea);
	},

	removeArea: function(aPref, aArea) {
		let pref = this.prefs.get(aPref);
		if(!pref) { return; }

		DragPositionManager.stop();

		pref.areas.delete(aArea);
		this.deinitPref(aPref);
	},

	handleEvent: function(e) {
		switch(e.type) {
			case "dragstart":
				this._onDragStart(e);
				break;

			case "dragover":
				this._onDragOver(e);
				break;

			case "drop":
				this._onDragDrop(e);
				break;

			case "dragexit":
				this._onDragExit(e);
				break;

			case "dragend":
				this._onDragEnd(e);
				break;

			case "mousedown":
				this._onMouseDown(e);
				break;

			case "mouseup":
				this._onMouseUp(e);
				break;
		}
	},

	observe: function(aSubject, aTopic, aData) {
		switch(aTopic) {
			case "nsPref:changed":
				if(this.prefs.has(aSubject)) {
					let pref = this.prefs.get(aSubject);
					this._updatePlacements(pref);

					for(let handler of pref.handlers) {
						// don't block executing of other possible listeners if one fails
						try {
							if(handler.observe) {
								handler.observe(pref.name, aTopic, pref.placements);
							} else {
								handler(pref.name, pref.placements);
							}
						}
						catch(ex) { Cu.reportError(ex); }
					}
				}
				break;
		}
	},

	uninit: function() {
		DragPositionManager.stop();

		for(let [ pref, placements ] of this.prefs) {
			this.deinitPref(pref, true);
		}
	},

	initPref: function(aPref) {
		let pref = this.prefs.get(aPref);
		if(!pref) {
			pref = {
				name: aPref,
				get value () { return Prefs[this.name]; },
				set value (v) { return Prefs[this.name] = v; },
				handlers: new Set(), // to be notified of when a change to the pref is made
				areas: new Set(), // nodes in the options tab where this preference will be reflected
				active: new Map(), // widgets that are initialized with this session (those not initialized aren't usually forgotten, but won't be visible)
			};

			this._updatePlacements(pref);
			this.prefs.set(aPref, pref);

			Prefs.listen(aPref, this);
		}

		return pref;
	},

	deinitPref: function(aPref, aForce) {
		let pref = this.prefs.get(aPref);
		if(pref) {
			if((!pref.handlers.size && !pref.areas.size && !pref.active.size) || aForce === true) {
				Prefs.unlisten(aPref, this);
				this.prefs.delete(aPref);
			}
		}
	},

	addWidgetItem: function(pref, widget, area) {
		let id = this.kWidgetPrefix+widget.id;
		let doc = area.ownerDocument;

		// don't add an item if it already exists
		if(doc.getElementById(id)) { return; }

		let item = this.createWidgetItem(doc, widget.label, widget.dependson);
		item.id = id;
		item._widgetId = widget.id;

		item._enable.handleEvent = (e) => {
			aSync(() => {
				let settings = pref.placements.settings.get(widget.id);
				settings.enable = item._enable.checked;
			});
		};
		item._enable.addEventListener('command', item._enable);

		area.appendChild(item);
		this.updateWidgetItem(pref, item);

		item.addEventListener("mousedown", this);
		item.addEventListener("mouseup", this);

		if(widget.dependson) {
			// I don't see a reason for why this should ever fail, but in case it does it's a minimal side-effect,
			// so it shouldn't block the rest of the code
			try {
				let win = doc.defaultView;
				win[objName].dependsOn.updateElement(item._enable);
			}
			catch(ex) { Cu.reportError(ex); }
		}

		// append the widget description to the helpbox if one was provided
		if(widget.description && area._descriptions) {
			let help1 = doc.createElement('description');
			help1.style.fontWeight = 'bold';
			help1.style.marginTop = '1em';
			help1.textContent = widget.label;

			let help2 = doc.createElement('description');
			help2.textContent = widget.description;

			area._descriptions.appendChild(help1);
			area._descriptions.appendChild(help2);

			item._helps = {
				help1: help1,
				help2: help2
			};
		}
	},

	removeWidgetItem: function(widget, area) {
		let id = this.kWidgetPrefix+widget.id;
		let doc = area.ownerDocument;
		let item = doc.getElementById(id);
		if(item) {
			if(item._helps) {
				item._helps.help1.remove();
				item._helps.help2.remove();
			}

			item.removeEventListener("mousedown", this);
			item.removeEventListener("mouseup", this);

			item.remove();
		}
	},

	createWidgetItem: function(doc, aLabel, aDependsOn) {
		let item = doc.createElement('box');
		item.classList.add('DnDpref-item-container');

		let icon = doc.createElement('image');
		icon.classList.add('DnDpref-icon');

		let label = doc.createElement('label');
		label.classList.add('DnDpref-label');
		let text = doc.createTextNode(aLabel);
		label.appendChild(text);

		let enable = doc.createElement('checkbox');
		enable.classList.add('DnDpref-enable');
		toggleAttribute(enable, 'dependson', aDependsOn, aDependsOn);

		let box = doc.createElement('box');
		box.classList.add('DnDpref-enable-container');
		box.appendChild(enable);

		let vbox = doc.createElement('vbox');
		vbox.classList.add('DnDpref-icon-container');
		vbox.appendChild(icon);
		vbox.appendChild(label);

		item.appendChild(box);
		item.appendChild(vbox);

		item._enable = enable;
		item._icon = icon;
		item._label = label;
		return item;
	},

	updateWidgetItem: function(pref, item) {
		let settings = pref.placements.settings.get(item._widgetId);

		toggleAttribute(item._enable, 'checked', settings.enable);
		toggleAttribute(item._icon, 'disabled', !settings.enable);
		toggleAttribute(item._label, 'disabled', !settings.enable);
		toggleAttribute(item, 'itemDisabled', !settings.enable);
	},

	_updatePlacements: function(pref) {
		pref.placements = {
			order: [],
			settings: new Map()
		};

		try {
			let obj = JSON.parse(pref.value) || {};
			for(let id in obj) {
				pref.placements.order.push(id);

				let setting = this._newSetting(pref, id);
				setting._enable = !!obj[id]; // don't trigger _savePlacements()
				pref.placements.settings.set(id, setting);
			}
		}
		catch(ex) {
			Cu.reportError(ex);

			// something went wrong, so we're resetting the placements
			this._savePlacements(pref);
		}

		// any existing areas should be updated if necessary
		for(let area of pref.areas) {
			this._updateArea(area);
		}
	},

	_savePlacements: function(pref) {
		if(!pref.placements.order.length) {
			for(let [id, widget] of pref.active) {
				pref.placements.settings.set(id, this._newSetting(pref, id));
				pref.placements.order.push(id);
			}
		}

		let obj = {};
		for(let id of pref.placements.order) {
			let setting = pref.placements.settings.get(id);
			obj[id] = setting.enable ? 1 : 0;
		}
		let str = JSON.stringify(obj);

		// no need to save the preference if it hasn't changed
		if(pref.value != str) {
			pref.value = str;
		}
	},

	_newSetting: function(pref, id) {
		return {
			_enable: true,
			get enable() { return this._enable; },
			set enable(v) {
				if(this._enable != v) {
					this._enable = v;
					DnDprefs._savePlacements(pref);
				}
				return v;
			},
			get active() { return pref.active.get(id); }
		};
	},

	_updateArea: function(area) {
		let pref = this.prefs.get(area._pref);
		let node = area.firstChild;

		for(let id of pref.placements.order) {
			// if this widget isn't active, skip it as there's no need to show it in the customization areas
			if(!pref.active.has(id)) { continue; }

			// we need the physical node of each area's owner document, this is not the same as elements in pref.active.get(someId).instances which can be anything
			let item = area.ownerDocument.getElementById(this.kWidgetPrefix+id);

			// this shouldn't happen, but still better make sure
			if(!item) { continue; }

			// update its enabled/disabled status
			this.updateWidgetItem(pref, item);

			// if the current node is already the correct position, we can skip ahead
			if(node && node == item) {
				node = node.nextSibling;
				continue;
			}

			// we're going through the order in the array, so we can just append to the end since we'll eventually go through all widgets in order
			area.appendChild(item);
			node = null;
		}

		// the placeholder should always be the last item in the area
		if(area._endPlaceholder != area.lastChild) {
			area.appendChild(area._endPlaceholder);
		}
	},

	_addDragHandlers: function(node) {
		node.addEventListener("dragstart", this, true);
		node.addEventListener("dragover", this, true);
		node.addEventListener("dragexit", this, true);
		node.addEventListener("drop", this, true);
		node.addEventListener("dragend", this, true);
	},

	_onDragStart: function(e) {
		let item = e.target;
		while(item && !item.classList.contains('DnDpref-item-container')) {
			if(item.getAttribute('DnDpref') || item.classList.contains('DnDpref-enable')) {
				return;
			}
			item = item.parentNode;
		}

		if(trueAttribute(item._icon, 'disabled')) { return; }

		this._dragWindow = item.ownerDocument.defaultView;

		let area = item.parentNode;
		let dt = e.dataTransfer;
		let documentId = e.target.ownerDocument.documentElement.id;

		dt.mozSetDataAt(this.kDragDataTypePrefix + documentId, item.id, 0);
		dt.effectAllowed = "move";

		let itemRect = item.getBoundingClientRect();
		let itemCenter = {
			x: itemRect.left + itemRect.width / 2,
			y: itemRect.top + itemRect.height / 2
		};
		this._dragOffset = {
			x: e.clientX - itemCenter.x,
			y: e.clientY - itemCenter.y
		};

		// Hack needed so that the dragimage will still show the item as it appeared before it was hidden.
		this._initializeDragAfterMove = () => {
			item.hidden = true;
			DragPositionManager.start(area);
			if(item.nextSibling) {
				this._setDragActive(item.nextSibling, "before", item);
				this._dragOverItem = item.nextSibling;
			}

			this._initializeDragAfterMove = null;
			if(this._dragInitializeTimeout) {
				this._dragInitializeTimeout.cancel();
				this._dragInitializeTimeout = null;
			}
		};
		this._dragInitializeTimeout = aSync(this._initializeDragAfterMove, 0);
	},

	_onDragOver: function(e) {
		if(!this._dragWindow || this._isUnwantedDragDrop(e)) { return; }

		if(this._initializeDragAfterMove) {
			this._initializeDragAfterMove();
		}

		if(!e.dataTransfer.mozTypesAt(0)) { return; }

		let doc = e.target.ownerDocument;
		let documentId = doc.documentElement.id;
		let draggedItemId = e.dataTransfer.mozGetDataAt(this.kDragDataTypePrefix + documentId, 0);
		let draggedWrapper = doc.getElementById(draggedItemId);
		let targetArea = this._getCustomizableParent(e.currentTarget);
		let originArea = this._getCustomizableParent(draggedWrapper);

		// Do nothing if the target or origin are not customizable or if we're not dragging inside the same area.
		if(!targetArea || targetArea != originArea) { return; }

		let targetNode = this._getDragOverNode(e, targetArea);

		// We need to determine the place that the widget is being dropped in the target.
		let dragOverItem, dragValue;
		if(targetNode == targetArea) {
			// We'll assume if the user is dragging directly over the target, that they're attempting to append a child to that target.
			dragOverItem = targetNode.lastChild || targetNode;
			dragValue = "after";
		} else {
			let targetParent = targetNode.parentNode;
			let position = Array.indexOf(targetParent.children, targetNode);
			if(position == -1) {
				dragOverItem = targetParent.lastChild;
				dragValue = "after";
			} else {
				dragOverItem = targetParent.children[position];
				dragValue = "before";
			}
		}

		if(this._dragOverItem && dragOverItem != this._dragOverItem) {
			this._cancelDragActive(this._dragOverItem, dragOverItem);
		}

		if(dragOverItem != this._dragOverItem || dragValue != dragOverItem.getAttribute("dragover")) {
			if(dragOverItem != targetArea) {
				this._setDragActive(dragOverItem, dragValue, draggedWrapper);
			}
			this._dragOverItem = dragOverItem;
		}

		e.preventDefault();
		e.stopPropagation();
	},

	_onDragDrop: function(e) {
		if(this._isUnwantedDragDrop(e)) { return; }

		this._initializeDragAfterMove = null;
		if(this._dragInitializeTimeout) {
			this._dragInitializeTimeout.cancel();
			this._dragInitializeTimeout = null;
		}

		let targetArea = this._getCustomizableParent(e.currentTarget);
		let doc = e.target.ownerDocument;
		let documentId = doc.documentElement.id;
		let draggedItemId = e.dataTransfer.mozGetDataAt(this.kDragDataTypePrefix + documentId, 0);
		let draggedItem = doc.getElementById(draggedItemId);
		let originArea = this._getCustomizableParent(draggedItem);
		if(this._dragSizeMap) {
			this._dragSizeMap.clear();
		}

		// Do nothing if the target area or origin area are not customizable or if we're not dragging inside the same area.
		if(!targetArea || targetArea != originArea) { return; }

		let targetNode = this._dragOverItem;
		let dropDir = targetNode.getAttribute("dragover");

		// Need to insert *after* this node if we promised the user that:
		if(targetNode != targetArea && dropDir == "after") {
			if(targetNode.nextSibling) {
				targetNode = targetNode.nextSibling;
			} else {
				targetNode = targetArea;
			}
		}

		this._cancelDragActive(this._dragOverItem, null, true);

		draggedItem.hidden = false;
		draggedItem.removeAttribute("mousedown");

		// Do nothing if the target was dropped onto itself (ie, no change in area or position).
		if(draggedItem == targetNode) { return; }

		// Is the target the customization area itself? If so, we skip passing it to _moveWidget, so that it appends the draggedItem to the end of the area.
		if(targetNode == targetArea) {
			targetNode = null;
		}

		this._moveWidget(targetArea, draggedItem, targetNode);
		this._onDragEnd(e);
	},

	_moveWidget: function(aArea, aItem, aBefore) {
		let pref = this.prefs.get(aArea._pref);
		let id = aItem.id.substr(this.kWidgetPrefix.length);

		// first we remove the widget from the array altogether
		let current = pref.placements.order.indexOf(id);
		pref.placements.order.splice(current, 1);

		// now we find the widget that will be after the one we're moving
		if(aBefore) {
			let sibling = pref.placements.order.indexOf(aBefore.id.substr(this.kWidgetPrefix.length));
			if(sibling != -1) {
				// ...and append the widget to take the sibling's original place, pushing the following ones forward
				pref.placements.order.splice(sibling, 0, id);
				this._savePlacements(pref);
				return;
			}
		}

		// if we couldn't find a sibling or none is provided, we append it to the end of the array
		pref.placements.order.push(id);
		this._savePlacements(pref);
	},

	_onDragExit: function(e) {
		if(this._isUnwantedDragDrop(e)) { return; }

		// When leaving customization areas, cancel the drag on the last dragover item. We've attached the listener to areas, so e.currentTarget will be the area.
		// We don't care about dragexit events fired on descendants of the area, so we check that the event's target is the same as the area to which the listener was attached.
		if(this._dragOverItem && e.target == e.currentTarget) {
			this._cancelDragActive(this._dragOverItem);
			this._dragOverItem = null;
		}
	},

	// To workaround bug 460801 we manually forward the drop event here when dragend wouldn't be fired.
	_onDragEnd: function(e) {
		if(this._isUnwantedDragDrop(e)) { return; }
		this._initializeDragAfterMove = null;
		if(this._dragInitializeTimeout) {
			this._dragInitializeTimeout.cancel();
			this._dragInitializeTimeout = null;
		}

		if(!e.dataTransfer.mozTypesAt(0)) { return; }

		let doc = e.target.ownerDocument;
		let documentId = doc.documentElement.id;
		let draggedItemId = e.dataTransfer.mozGetDataAt(this.kDragDataTypePrefix + documentId, 0);
		let draggedWrapper = doc.getElementById(draggedItemId);

		// DraggedWrapper might no longer available if a widget node is destroyed after starting (but before stopping) a drag.
		if(draggedWrapper) {
			draggedWrapper.hidden = false;
			draggedWrapper.removeAttribute("mousedown");
		}

		if(this._dragOverItem) {
			this._cancelDragActive(this._dragOverItem);
			this._dragOverItem = null;
		}
		DragPositionManager.stop();
		this._dragWindow = null;
	},

	_isUnwantedDragDrop: function(e) {
		// Discard drag events that originated from a separate window to prevent content->chrome privilege escalations.
		let mozSourceNode = e.dataTransfer.mozSourceNode;
		// mozSourceNode is null in the dragStart event handler or if the drag event originated in an external application.
		return !mozSourceNode || mozSourceNode.ownerDocument.defaultView != this._dragWindow;
	},

	_setDragActive: function(aItem, aValue, aDraggedItem) {
		if(!aItem) { return; }

		if(aItem.getAttribute("dragover") != aValue) {
			setAttribute(aItem, "dragover", aValue);
			this._setGridDragActive(aItem, aDraggedItem, aValue);

			// Calculate width of the item when it'd be dropped in this position
			let width = this._getDragItemSize(aItem, aDraggedItem).width;
			let direction = getComputedStyle(aItem).direction;
			let prop, otherProp;

			// If we're inserting before in ltr, or after in rtl:
			if((aValue == "before") == (direction == "ltr")) {
				prop = "borderLeftWidth";
				otherProp = "border-right-width";
			} else {
				// otherwise:
				prop = "borderRightWidth";
				otherProp = "border-left-width";
			}

			aItem.style[prop] = width + 'px';
			aItem.style.removeProperty(otherProp);
		}
	},

	_cancelDragActive: function(aItem, aNextItem, aNoTransition) {
		let currentArea = this._getCustomizableParent(aItem);
		if(!currentArea) { return; }

		removeAttribute(aItem, "dragover");
		if(aNextItem) {
			let nextArea = this._getCustomizableParent(aNextItem);

			// No need to do anything if we're still dragging in this area:
			if(nextArea == currentArea) { return; }
		}

		// Otherwise, clear everything out:
		let positionManager = DragPositionManager.getManagerForArea(currentArea);
		positionManager.clearPlaceholders(aNoTransition);
	},

	_setGridDragActive: function(aDragOverNode, aDraggedItem, aValue) {
		let targetArea = this._getCustomizableParent(aDragOverNode);
		let positionManager = DragPositionManager.getManagerForArea(targetArea);
		let draggedSize = this._getDragItemSize(aDragOverNode, aDraggedItem);
		positionManager.insertPlaceholder(aDragOverNode, draggedSize);
	},

	_getDragItemSize: function(aDragOverNode, aDraggedItem) {
		// Cache it good, cache it real good.
		if(!this._dragSizeMap) {
			this._dragSizeMap = new WeakMap();
		}
		if(!this._dragSizeMap.has(aDraggedItem)) {
			this._dragSizeMap.set(aDraggedItem, new WeakMap());
		}

		let itemMap = this._dragSizeMap.get(aDraggedItem);

		// targetArea and currentArea are always the same if we get here
		let targetArea = this._getCustomizableParent(aDragOverNode);

		// Return the size for this target from cache, if it exists.
		let size = itemMap.get(targetArea);
		if(size) { return size; }

		// Calculate size of the item when it'd be dropped in this position.
		let currentParent = aDraggedItem.parentNode;
		let currentSibling = aDraggedItem.nextSibling;
		const kAreaType = "cui-areatype";
		let areaType, currentType;

		// targetArea and currentArea are always the same, so we can use the dragged item's dimensinos directly
		aDraggedItem.hidden = false;

		// Fetch the new size.
		let rect = aDraggedItem.getBoundingClientRect();
		size = {
			width: rect.width,
			height: rect.height
		};
		// Cache the found value of size for this target.
		itemMap.set(targetArea, size);

		aDraggedItem.hidden = true;
		return size;
	},

	_getCustomizableParent: function(aElement) {
		while(aElement) {
			if(aElement.getAttribute('DnDpref')) {
				return aElement;
			}
			aElement = aElement.parentNode;
		}
		return null;
	},

	_getDragOverNode: function(e, aAreaElement) {
		// Offset the drag event's position with the offset to the center of the thing we're dragging
		let dragX = e.clientX - this._dragOffset.x;
		let dragY = e.clientY - this._dragOffset.y;

		// Ensure this is within the container
		let bounds = aAreaElement.getBoundingClientRect();
		dragX = Math.min(bounds.right, Math.max(dragX, bounds.left));
		dragY = Math.min(bounds.bottom, Math.max(dragY, bounds.top));

		let positionManager = DragPositionManager.getManagerForArea(aAreaElement);

		// Make it relative to the container:
		dragX -= bounds.left;
		dragY -= bounds.top;

		// Find the closest node:
		let targetNode = positionManager.find(dragX, dragY);
		return targetNode || e.target;
	},

	_onMouseDown: function(e) {
		if(e.button != 0) { return; }

		let item = this._getWrapper(e.target);
		setAttribute(item, "mousedown", "true");
	},

	_onMouseUp: function(e) {
		if(e.button != 0) { return; }

		let item = this._getWrapper(e.target);
		removeAttribute(item, "mousedown");
	},

	_getWrapper: function(aElement) {
		while(aElement && !aElement.classList.contains('DnDpref-item-container')) {
			if(aElement.getAttribute('DnDpref') || aElement.classList.contains('DnDpref-enable')) {
				return null;
			}
			aElement = aElement.parentNode;
		}

		if(trueAttribute(aElement._icon, 'disabled')) { return null; }

		return aElement;
	}
};

this.AreaPositionManager = function(aContainer) {
	this._container = aContainer;

	// Caching the direction and bounds of the container for quick access later:
	this._dir = getComputedStyle(this._container).direction;
	let containerRect = this._container.getBoundingClientRect();
	this._containerInfo = {
		left: containerRect.left,
		right: containerRect.right,
		top: containerRect.top,
		width: containerRect.width
	};

	this.update();
};

// the following is adapted from http://mxr.mozilla.org/mozilla-central/source/browser/components/customizableui/DragPositionManager.jsm

this.AreaPositionManager.prototype = {
	_horizontalDistance: null,
	_nodePositionStore: null,

	update: function() {
		let window = this._container.ownerDocument.defaultView;
		this._nodePositionStore = new WeakMap();

		let last = null;
		let singleItemHeight;
		for(let child of this._container.children) {
			if(child.hidden) { continue; }

			let coordinates = this._lazyStoreGet(child);
			// We keep a baseline horizontal distance between nodes around for use when we can't compare with previous/next nodes
			if(!this._horizontalDistance && last) {
				this._horizontalDistance = coordinates.left - last.left;
			}
			// We also keep the basic height of items for use below:
			if(!singleItemHeight) {
				singleItemHeight = coordinates.height;
			}
			last = coordinates;
		}

		this._heightToWidthFactor = this._containerInfo.width / singleItemHeight;
	},

	// Find the closest node in the container given the coordinates.
	// "Closest" is defined in a somewhat strange manner: we prefer nodes which are in the same row over nodes that are in a different row. In order to implement this,
	// we use a weighted cartesian distance where dy is more heavily weighted by a factor corresponding to the ratio between the container's width and the height of its elements.
	find: function(aX, aY) {
		let closest = null;
		let minCartesian = Number.MAX_VALUE;
		let containerX = this._containerInfo.left;
		let containerY = this._containerInfo.top;
		for(let node of this._container.children) {
			let coordinates = this._lazyStoreGet(node);
			let offsetX = coordinates.x - containerX;
			let offsetY = coordinates.y - containerY;
			let hDiff = offsetX - aX;
			let vDiff = offsetY - aY;

			// Then compensate for the height/width ratio so that we prefer items which are in the same row:
			hDiff /= this._heightToWidthFactor;

			let cartesianDiff = hDiff * hDiff + vDiff * vDiff;
			if(cartesianDiff < minCartesian) {
				minCartesian = cartesianDiff;
				closest = node;
			}
		}

		// Now correct this node based on what we're dragging
		if(closest) {
			let targetBounds = this._lazyStoreGet(closest);
			let farSide = this._dir == "ltr" ? "right" : "left";
			let outsideX = targetBounds[farSide];

			// Check if we're closer to the next target than to this one: Only move if we're not targeting a node in a different row:
			if(aY > targetBounds.top && aY < targetBounds.bottom) {
				if((this._dir == "ltr" && aX > outsideX) || (this._dir == "rtl" && aX < outsideX)) {
					return closest.nextSibling || this._container;
				}
			}
		}

		return closest;
	},

	// "Insert" a "placeholder" by shifting the subsequent children out of the way. We go through all the children, and shift them based on the position
	// they would have if we had inserted something before aBefore. We use CSS transforms for this, which are CSS transitioned.
	insertPlaceholder: function(aBefore, aSize) {
		for(let child of this._container.children) {
			// Don't need to shift hidden nodes:
			if(child.hidden) { continue; }

			// If this is the node before which we're inserting, start shifting everything that comes after. One exception is inserting at the end
			if(child == aBefore) {
				if(!this._lastPlaceholderInsertion) {
					setAttribute(child, "notransition", "true");
				}

				// Determine the CSS transform based on the next node:
				child.style.transform = this._diffWithNext(child, aSize);
			}
			else {
				// If we're not shifting this node, reset the transform
				child.style.transform = "";
			}
		}
		if(this._container.lastChild && !this._lastPlaceholderInsertion) {
			// Flush layout:
			this._container.lastChild.getBoundingClientRect();

			// then remove all the [notransition]
			for(let child of this._container.children) {
				removeAttribute(child, "notransition");
			}
		}
		this._lastPlaceholderInsertion = aBefore;
	},

	// Reset all the transforms in this container, optionally without transitioning them.
	clearPlaceholders: function(aNoTransition) {
		for(let child of this._container.children) {
			if(aNoTransition) {
				setAttribute(child, "notransition", "true");
			}
			child.style.transform = "";

			if(aNoTransition) {
				// Need to force a reflow otherwise this won't work.
				child.getBoundingClientRect();
				removeAttribute(child, "notransition");
			}
		}

		// We snapped back, so we can assume there's no more "last" placeholder insertion point to keep track of.
		if(aNoTransition) {
			this._lastPlaceholderInsertion = null;
		}
	},

	_diffWithNext: function(aNode, aSize) {
		let xDiff;
		let yDiff = null;
		let nodeBounds = this._lazyStoreGet(aNode);
		let side = this._dir == "ltr" ? "left" : "right";
		let next = this._getVisibleSiblingForDirection(aNode, "next");

		// First we determine the transform along the x axis. Usually, there will be a next node to base this on:
		if(next) {
			let otherBounds = this._lazyStoreGet(next);
			xDiff = otherBounds[side] - nodeBounds[side];

			// We set this explicitly because otherwise some strange difference between the height and the actual difference between line creeps in
			// and messes with alignments
			yDiff = otherBounds.top - nodeBounds.top;
		}
		else {
			// We don't have a sibling whose position we can use. First, let's see if we're also the first item (which complicates things):
			let firstNode = this._firstInRow(aNode);
			if(aNode == firstNode) {
				// Maybe we stored the horizontal distance between non-wide nodes, if not, we'll use the width of the incoming node as a proxy:
				xDiff = this._horizontalDistance || aSize.width;
			} else {
				// If not, we should be able to get the distance to the previous node and use the inverse, unless there's no room for another node (ie we
				// are the last node and there's no room for another one)
				xDiff = this._moveNextBasedOnPrevious(aNode, nodeBounds, firstNode);
			}
		}

		// If we've not determined the vertical difference yet, check it here
		if(yDiff === null) {
			// If the next node is behind rather than in front, we must have moved vertically:
			if((xDiff > 0 && this._dir == "rtl") || (xDiff < 0 && this._dir == "ltr")) {
				yDiff = aSize.height;
			} else {
				// Otherwise, we haven't
				yDiff = 0;
			}
		}

		return "translate(" + xDiff + "px, " + yDiff + "px)";
	},

	// Helper function to find the transform a node if there isn't a next node to base that on.
	_moveNextBasedOnPrevious: function(aNode, aNodeBounds, aFirstNodeInRow) {
		let next = this._getVisibleSiblingForDirection(aNode, "previous");
		let otherBounds = this._lazyStoreGet(next);
		let side = this._dir == "ltr" ? "left" : "right";
		let xDiff = aNodeBounds[side] - otherBounds[side];

		// If, however, this means we move outside the container's box (i.e. the row in which this item is placed is full)
		// we should move it to align with the first item in the next row instead
		let bound = this._containerInfo[this._dir == "ltr" ? "right" : "left"];
		if((this._dir == "ltr" && xDiff + aNodeBounds.right > bound) || (this._dir == "rtl" && xDiff + aNodeBounds.left < bound)) {
			xDiff = this._lazyStoreGet(aFirstNodeInRow)[side] - aNodeBounds[side];
		}
		return xDiff;
	},

	// Get position details from our cache. If the node is not yet cached, get its position information and cache it now.
	_lazyStoreGet: function(aNode) {
		let rect = this._nodePositionStore.get(aNode);
		if(!rect) {
			// getBoundingClientRect() returns a DOMRect that is live, meaning that as the element moves around, the rects values change. We don't want
			// that - we want a snapshot of what the rect values are right at this moment, and nothing else. So we have to clone the values.
			let clientRect = aNode.getBoundingClientRect();
			rect = {
				left: clientRect.left,
				right: clientRect.right,
				width: clientRect.width,
				height: clientRect.height,
				top: clientRect.top,
				bottom: clientRect.bottom
			};
			rect.x = rect.left + rect.width / 2;
			rect.y = rect.top + rect.height / 2;
			Object.freeze(rect);
			this._nodePositionStore.set(aNode, rect);
		}
		return rect;
	},

	_firstInRow: function(aNode) {
		// XXXmconley: I'm not entirely sure why we need to take the floor of these values - it looks like, periodically, we're getting fractional pixels back
		// from lazyStoreGet. I've filed bug 994247 to investigate.
		let bound = Math.floor(this._lazyStoreGet(aNode).top);
		let rv = aNode;
		let prev;
		while(rv && (prev = this._getVisibleSiblingForDirection(rv, "previous"))) {
			if(Math.floor(this._lazyStoreGet(prev).bottom) <= bound) {
				return rv;
			}
			rv = prev;
		}
		return rv;
	},

	_getVisibleSiblingForDirection: function(aNode, aDirection) {
		let rv = aNode;
		do {
			rv = rv[aDirection + "Sibling"];
		}
		while(rv && rv.hidden);

		return rv;
	}
};

this.DragPositionManager = {
	managers: new WeakMap(),

	start: function(aArea) {
		let positionManager = this.managers.get(aArea);
		if(positionManager) {
			positionManager.update();
		} else {
			this.managers.set(aArea, new AreaPositionManager(aArea));
		}
	},

	stop: function() {
		this.managers.clear();
	},

	getManagerForArea: function(aArea) {
		return this.managers.get(aArea);
	}
};

Modules.UNLOADMODULE = function() {
	DnDprefs.uninit();
};
