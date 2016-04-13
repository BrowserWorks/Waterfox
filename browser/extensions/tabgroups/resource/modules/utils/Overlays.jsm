// VERSION 2.15.10
Modules.UTILS = true;

// Overlays - to use overlays in my bootstraped add-ons. The behavior is as similar to what is described in https://developer.mozilla.org/en/XUL_Tutorial/Overlays as I could manage.
// When a window with an overlay is opened, the elements in both the window and the overlay with the same ids are combined together.
// The children of matching elements are added to the end of the set of children in the window's element.
// Attributes that are present on the overlay's elements will be applied to the window's elements.
//
// Overlays can also have their own:
//	stylesheets by placing at the top of the overlay: <?xml-stylesheet href="chrome://addon/skin/sheet.css" type="text/css"?>
//	DTD's by the usual method: <!DOCTYPE window [ <!ENTITY % nameDTD SYSTEM "chrome://addon/locale/file.dtd"> %nameDTD; ]>
//	scripts using the script tag when as a direct child of the overlay element (effects of these won't be automatically undone when unloading the overlay.
//		Any script that changes the DOM structure might produce unpredictable results! To avoid using eval unnecessarily, only scripts with src will be imported for now.
//
// The overlay element surrounds the overlay content. It uses the same namespace as XUL window files. The id of these items should exist in the window's content.
// Its content will be added to the window where a similar element exists with the same id value. If such an element does not exist, that part of the overlay is ignored.
// If there is content inside both the XUL window and in the overlay, the window's content will be used as is and the overlay's content will be appended to the end.
// The children of the overlay's element are inserted as children of the base window's element. The following attributes are processed in the order they are declared in the overlay:
//	If the overlay's element contains an insertbefore attribute, the element is added just before the element in the base window with the id that matches this attribute.
//	If the overlay's element contains an insertafter attribute, the element is added just after the element in the base window with the id that matches this attribute.
//	If the overlay's element contains an position attribute, the element is added at the one-based index specified in this attribute.
//	Otherwise, the element is added as the last child.
// If you would like to remove an element that is already in the XUL file, create elements with removeelement attribute.
// Attention: this won't work in customizable elements, such as toolbars or palette items!
// To move an already existant node to another place, add a newparent attribute with the id of the new parent element. If it exists, it will be moved there. This can be used
//	together with insertafter, insertbefore and position attributes, which will be relative to the new parent and consequently new siblings.
// To remove an attribute from an overlayed element, simply set its value to "__remove".
//
// For overlaying preferences dialogs, you can add new preferences in an unnamed <preferences> element. They will be added to an already existing <preferences> element if present,
// or the whole element will be overlayed if not.
// Elements with a getchildrenof attribute will inherit all the children from the elements specified by the comma-separated list of element ids.
//
// Every occurence of (string) objName and (string) objPathString in every attribute in the overlay will be properly replaced with this object's objName and objPathString.
// I can also overlay other overlays provided they are loaded through the Overlays object (either from this add-on or another implementing it).
//
// Calling document.persist() for nodes added through here will not work by itself, it will only work if the node has the "persist" attribute explicitely set in the overlay, with a
// comma-separated list of the attributes to persist. Normal XUL persistence through the "persist" attribute should work as expected.
//
// If the toolbar element in the overlays has the following attributes, the system will add the corresponding customize context menu items:
//	menuAdd : "Add to X" context menu entries
//	menuMove : "Move to X" context menu entries
//	menuRemove : "Remove from X" context menu entries
//	menuMain : "Move to Toolbar" context menu entries, that will move widgets to the nav-bar
// All of these attributes above can be complemented with the corresponding menuXXXAccesskey attribute.
// If a toolbar element has a ignoreCUI=true attribute, it won't be registered in the CustomizableUI module.
//
// In case an element shouldn't be visible until a certain stylesheet is loaded (referenced in an xml-stylesheet element in any overlay; to prevent visual glitches and jumping around
// in the window during startup/load), you can set attribute "waitForSS" with space-separated list of stylesheet URIs for which the element should wait. The element will be collapsed
// until all the stylesheets in the attribute are loaded.
//
// overlayURI(aURI, aWith, aListener) - overlays aWith in all windows with aURI
//	aURI - (string) uri to be overlayed
//	aWith - (string) uri to overlay aURI, can be fileName found as chrome://objPathString/content/fileName.xul or already the full uri path
//	(optional) aListener - (object) with any of the following methods:
//		beforeLoad - ( function(window) ) is called before the window is overlayed, expects a (object) window argument
//		onLoad - ( function(window) ) to be called when aURI is overlayed with aWith, expects a (object) window argument
//		onUnload - ( function(window) ) to be called when aWith is unloaded from aURI, expects a (object) window argument
// removeOverlayURI(aURI, aWith) - removes aWith overlay from all windows with aURI
//	see overlayURI()
// overlayWindow(aWindow, aWith, aListener) - overlays aWindow with aWith
//	aWindow - (object) window object to be overlayed
//	see overlayURI()
// removeOverlayWindow(aWindow, aWith) - removes aWith overlay from aWindow
//	see overlayWindow()
// loadedURI(aURI, aWith) - returns (int) with corresponding overlay index in overlays[] if overlay aWith has been loaded for aURI, returns (bool) false otherwise
//	see overlayURI()
// loadedWindow(aWindow, aWith, loaded) -	returns (int) with corresponding overlay index in aWindow['_OVERLAYS_'+objName][] if overlay aWith has been loaded for aWindow,
//						returns (bool) false otherwise
//	(optional) loaded - if true it will only return true if the overlay has been actually loaded into the window, rather than just added to the array. Defaults to false.
//	see overlayWindow()
// runWhenSheetsLoaded(aMethod) -	will wait until any stylesheets referenced in overlays are actually loaded before calling aMethod;
//					will call imediatelly if all stylesheets are already loaded
//	aMethod - (function) to be called
this.Overlays = {
	_obj: '_OVERLAYS_'+objName,
	overlays: [],

	overlayURI: function(aURI, aWith, aListener) {
		var path = this.getPath(aWith);
		if(!path || this.loadedURI(aURI, path) !== false) { return; }

		var newOverlay = {
			uri: aURI,
			overlay: path,
			listener: aListener || {},
			document: null,
			ready: false,
			persist: {}

		};
		this.overlays.push(newOverlay);

		xmlHttpRequest(path, (xmlhttp) => {
			if(xmlhttp.readyState === 4) {
				// We can't get i from the push before because we can be adding and removing overlays at the same time,
				// which since this is mostly an asynchronous process, would screw up the counter.
				var overlay = null;
				for(let x of this.overlays) {
					if(x.uri == aURI && x.overlay == path) {
						overlay = x;
						break;
					}
				}
				if(!overlay) { return; } // this can happen if switch on and off an overlay too quickly I guess..

				overlay.document = xmlhttp.responseXML;

				if(overlay.document.querySelector('parsererror')) {
					Cu.reportError(overlay.document.querySelector('parsererror').textContent);
					return;
				}

				replaceObjStrings(overlay.document);
				this.cleanXUL(overlay.document, overlay);
				overlay.ready = true;

				Windows.callOnAll((aWindow) => {
					this.scheduleAll(aWindow);
				});
				Browsers.callOnAll((aWindow) => {
					this.observe(aWindow, 'pageshow');
				});
			}
		});
	},

	removeOverlayURI: function(aURI, aWith) {
		var path = this.getPath(aWith);
		if(!path) { return; }

		var i = this.loadedURI(aURI, path);
		if(i === false) { return; }

		// I sometimes call removeOverlayURI() when unloading modules, but these functions are also called when shutting down the add-on,
		// preventing me from unloading the overlays.
		// This makes it so it keeps the reference to the overlay when shutting down so it's properly removed in unloadAll() if it hasn't been done so already.
		if(!UNLOADED) {
			this.overlays.splice(i, 1);
		}

		Windows.callOnAll((aWindow) => {
			this.scheduleUnOverlay(aWindow, path);
		});
		Browsers.callOnAll((aWindow) => {
			// at least for now I'm only overlaying xul documents
			if((aWindow.document instanceof aWindow.XULDocument)) {
				this.scheduleUnOverlay(aWindow, path);
			}
		});
	},

	overlayWindow: function(aWindow, aWith, aListener) {
		var path = this.getPath(aWith);
		if(!path || this.loadedWindow(aWindow, path) !== false) { return; }

		var newOverlay = {
			uri: path,
			traceBack: [],
			removeMe: function() { Overlays.removeOverlay(aWindow, this); },
			time: 0,
			listener: aListener || {},
			document: null,
			ready: false,
			loaded: false,
			remove: false,
			persist: {}
		};

		if(!aWindow[this._obj]) {
			aWindow[this._obj] = [];
			this.addToAttr(aWindow);
		}
		aWindow[this._obj].push(newOverlay);

		xmlHttpRequest(path, (xmlhttp) => {
			if(xmlhttp.readyState === 4) {
				// just a failsafe, this shouldn't happen if everything is properly built
				if(!aWindow[this._obj]) { return; }

				// We can't get i from the push before because we can be adding and removing overlays at the same time,
				// which since this is mostly an asynchronous process, would screw up the counter.
				var overlay = null;
				for(let x of aWindow[this._obj]) {
					if(x.uri == path) {
						overlay = x;
						break;
					}
				}
				if(!overlay) { return; } // this can happen if switch on and off an overlay too quickly I guess..

				overlay.document = xmlhttp.responseXML;

				if(overlay.document.querySelector('parsererror')) {
					Cu.reportError(overlay.document.querySelector('parsererror').textContent);
					return;
				}

				replaceObjStrings(overlay.document);
				this.cleanXUL(overlay.document, overlay);
				overlay.ready = true;
				this.scheduleAll(aWindow);
			}
		});
	},

	removeOverlayWindow: function(aWindow, aWith) {
		var path = this.getPath(aWith);
		if(!path) { return; }

		var i = this.loadedWindow(aWindow, path);
		if(i === false) { return; }

		var overlay = aWindow[this._obj][i];
		overlay.remove = true;

		// could have already been unloaded by another add-on's overlay
		if(!overlay.loaded) {
			aWindow[this._obj].splice(i, 1);
			if(aWindow[this._obj].length == 0) {
				delete aWindow[this._obj];
			}
			return;
		}

		this.scheduleUnOverlay(aWindow, path);
	},

	loadedURI: function(aURI, aWith) {
		var path = this.getPath(aWith);
		for(var i = 0; i < this.overlays.length; i++) {
			if(this.overlays[i].uri == aURI && this.overlays[i].overlay == path) {
				return i;
			}
		}
		return false;
	},

	loadedWindow: function(aWindow, aWith, loaded) {
		// We have to look not only for this object's array but also for other possible ones from other add-ons
		var allAttr = this.getAllInAttr(aWindow);
		for(let attr of allAttr) {
			var x = '_OVERLAYS_'+attr;
			if(!aWindow[x]) { continue; }

			for(var i = 0; i < aWindow[x].length; i++) {
				if(aWindow[x][i].uri == aWith) {
					return (!loaded || aWindow[x][i].loaded) ? i : false;
				}
			}
		}
		return false;
	},

	getPath: function(aPath) {
		// Only load overlays that belong to this add-on
		if(aPath.startsWith("chrome://") && !aPath.startsWith("chrome://"+objPathString+"/")) { return null; }

		return aPath.startsWith("chrome://") ? aPath : "chrome://"+objPathString+"/content/"+aPath+".xul";
	},

	observe: function(aSubject, aTopic) {
		switch(aTopic) {
			case 'pageshow':
			case 'SidebarFocused':
				if(!(aSubject.document instanceof aSubject.XULDocument)) { break; } // at least for now I'm only overlaying xul documents
				// no break; continue to 'domwindowopened'

			case 'domwindowopened':
			case 'window-overlayed':
				if(!UNLOADED) {
					this.scheduleAll(aSubject);
				}
				break;

			case 'pagehide':
			case 'SidebarUnloaded':
				if(!(aSubject.document instanceof aSubject.XULDocument)) { break; } // at least for now I'm only overlaying xul documents
				aSubject.willClose = true;
				this.unloadAll(aSubject);
				break;
		}
	},

	cleanXUL: function(node, overlay) {
		if(node.attributes && node.getAttribute('persist') && node.id) {
			var persists = node.getAttribute('persist').split(' ');
			overlay.persist[node.id] = {};
			for(let attr of persists) {
				overlay.persist[node.id][attr] = true;
			}
		}

		if(node.nodeName == 'xml-stylesheet') {
			replaceObjStrings(node, 'textContent');
		}

		var curChild = node.firstChild;
		while(curChild) {
			if((curChild.nodeName == '#text' && !curChild.id && trim(curChild.nodeValue) === '') // remove useless #text elements
			|| (curChild.nodeName == 'script' && node.nodeName != 'overlay') // remove script tags that won't be inserted into the overlayed document
			) {
				var nextChild = curChild.nextSibling;
				curChild.remove();
				curChild = nextChild;
				continue;
			}

			this.cleanXUL(curChild, overlay);
			curChild = curChild.nextSibling;
		}
	},

	persistOverlay: function(aWindow, overlay) {
		for(var id in overlay.persist) {
			for(var attr in overlay.persist[id]) {
				var stored = Services.xulStore.getValue(aWindow.document.baseURI, id, attr);
				if(stored) {
					var node = aWindow.document.getElementById(id);
					setAttribute(node, attr, stored);
				}
			}
		}
	},

	scheduleAll: function(aWindow) {
		callOnLoad(aWindow, () => {
			aSync(() => {
				this.overlayAll(aWindow);
			});
		});
	},

	scheduleUnOverlay: function(aWindow, aWith) {
		// On shutdown, this could cause errors since we do aSync's here and it wouldn't find the object after it's been removed.
		if(UNLOADED) {
			this.unloadSome(aWindow, aWith);
			return;
		}

		if(!aWindow._UNLOAD_OVERLAYS) {
			aWindow._UNLOAD_OVERLAYS = [];
		}
		aWindow._UNLOAD_OVERLAYS.push(aWith);

		this.overlayAll(aWindow);
	},

	unloadSome: function(aWindow, aWith) {
		var i = this.loadedWindow(aWindow, aWith);
		if(i !== false) {
			this.removeInOrder(aWindow, aWindow[this._obj][i]);
			if(!aWindow.closed && !aWindow.willClose) {
				aWindow._RESCHEDULE_OVERLAY = true;
			}
		}
	},

	unloadAll: function(aWindow) {
		if(typeof(aWindow[this._obj]) != 'undefined') {
			if(aWindow[this._obj].length > 0) {
				// only need to check for the first entry from this array, all subsequent will be unloaded before this one and reloaded afterwards if needed
				this.removeInOrder(aWindow, aWindow[this._obj][0], true);
			}

			delete aWindow[this._obj];
			delete aWindow._BEING_OVERLAYED;
			this.removeFromAttr(aWindow);
			aWindow._RESCHEDULE_OVERLAY = true;
		}

		if(aWindow._RESCHEDULE_OVERLAY && !aWindow.closed && !aWindow.willClose) {
			delete aWindow._RESCHEDULE_OVERLAY;
			Observers.notify('window-overlayed', aWindow);
		}
	},

	traceBack: function(aWindow, traceback, unshift) {
		if(traceback.node) { traceback.nodeID = traceback.node.id; }
		if(traceback.palette) { traceback.paletteID = traceback.palette.id; }
		if(traceback.original && traceback.original.parent) {
			traceback.original.parentID = traceback.original.parent.id;
			traceback.originalParent = traceback.original.parent; // so the rest of the script can use regular loops when checking for it
		}

		if(!unshift) {
			aWindow._BEING_OVERLAYED.traceBack.push(traceback);
		} else {
			aWindow._BEING_OVERLAYED.traceBack.unshift(traceback);
		}
	},

	getNewOrder: function(aWindow) {
		var time = new Date().getTime();
		var allAttr = this.getAllInAttr(aWindow);
		for(let y of allAttr) {
			let x = '_OVERLAYS_'+y;
			if(!aWindow[x]) { continue; }

			for(let o of aWindow[x]) {
				if(o.time > time) {
					time = o.time +1;
				}
			}
		}
		return time;
	},

	removeInOrder: function(aWindow, toUnload, allFromHere) {
		if(!toUnload.loaded) { return; } // already unloaded

		// I need to check, in the off-chance another add-on started overlaying at roughly the same time, setting this var first
		if(aWindow._BEING_OVERLAYED === undefined) {
			aWindow._BEING_OVERLAYED = 'removing_'+objName;
		}

		var overlayList = [];
		this.removeMoreRecent(aWindow, toUnload, overlayList, allFromHere);

		// sort the list so we unload the most recent overlays first, going back to the one we want to unload
		overlayList.sort(function(a,b) { return b.time-a.time; });

		for(let l of overlayList) {
			l.overlay.removeMe();
		}

		// I need to check, in the off-chance another add-on started overlaying at roughly the same time, setting this var first
		if(aWindow._BEING_OVERLAYED && aWindow._BEING_OVERLAYED == 'removing_'+objName) {
			delete aWindow._BEING_OVERLAYED;
		}
	},

	removeMoreRecent: function(aWindow, toUnload, overlayList, allFromHere) {
		var allAttr = this.getAllInAttr(aWindow);
		for(let y of allAttr) {
			let x = '_OVERLAYS_'+y;
			if(!aWindow[x]) { continue; }

			main_overlayLoop: for(let overlay of aWindow[x]) {
				// we already checked this overlay
				for(let l of overlayList) {
					if(l.overlay == overlay) { continue main_overlayLoop; }
				}

				// obviously, if the overlay we're checking is the overlay we want to remove, it should be removed
				if(overlay.uri == toUnload.uri) {
					overlayList.push({ overlay: overlay, time: overlay.time });
					continue;
				}

				// we only need to unload overlays that were loaded after the one we're unloading
				if(overlay.time >= toUnload.time) {
					// we add this overlay to the list in case:
					//   a) it's from the same add-on and we want to unload all of its overlays
					//   b) it's from another add-on and it will conflict with our target overlay to unload
					if((allFromHere && x == this._obj)
					|| this.unloadConflicts(aWindow, toUnload, overlay)) {
						overlayList.push({ overlay: overlay, time: overlay.time });

						this.removeMoreRecent(aWindow, overlay, overlayList);
					}
				}
			}
		}
	},

	unloadConflicts: function(aWindow, aOverlay, bOverlay) {
		// if bOverlay is overlaying aOverlay directly, then of course it needs to be removed as well
		if(bOverlay.overlayingUri && bOverlay.overlayingUri == aOverlay.uri) {
			return true;
		}

		// skip these as they never conflict (I hope)
		var skipActions = ['appendXMLSS', 'sizeToContent', 'addPreferencesElement', 'addPreference', 'appendButton', 'addToolbar'];
		var conflictingFields = ['node', 'originalParent'];

		var toIgnore = [
			// ignore menu items added or modified somewhere in a navigator-toolbox's child menu
			{
				type: 1,
				actions: new Set([ 'appendChild', 'insertBefore', 'addAttribute', 'modifyAttribute' ]),
				nodes: new Set([ 'menuitem', 'menupopup' ]),
				parentIds: new Set([ 'navigator-toolbox' ])
			}
		];

		// we need to go through their traceBack's to see if any of them might conflict with each other
		for(var traceA of aOverlay.traceBack) {
			if(skipActions.indexOf(traceA.action) > -1) { continue; }
			var aAction = this.fixTraceBackNodes(aWindow, traceA);

			for(var traceB of bOverlay.traceBack) {
				if(skipActions.indexOf(traceB.action) > -1) { continue; }
				var bAction = this.fixTraceBackNodes(aWindow, traceB);

				// if any of the nodes overlap, we consider them conflicting
				for(let aa of conflictingFields) {
					if(!aAction[aa]) { continue; }

					b_loop: for(let bb of conflictingFields) {
						if(!bAction[bb]) { continue; }

						if(isAncestor(aAction[aa], bAction[bb])
						|| isAncestor(bAction[bb], aAction[aa])) {
							for(let ignore of toIgnore) {
								switch(ignore.type) {
									case 1:
										if(	(ignore.nodes.has(aAction[aa].nodeName)
											&& ignore.parentIds.has(bAction[bb].id)
											&& ignore.actions.has(aAction.action))
										||	(ignore.nodes.has(bAction[bb].nodeName)
											&& ignore.parentIds.has(aAction[aa].id)
											&& ignore.actions.has(bAction.action))
										) {
											continue b_loop;
										}
										break;
								}
							}
							return true;
						}
					}
				}
			}
		}

		return false;
	},

	fixTraceBackNodes: function(aWindow, action) {
		if(action.nodeID) { action.node = action.node || aWindow.document.getElementById(action.nodeID); }
		if(action.original && action.original.parentID) {
			action.original.parent = action.original.parent || aWindow.document.getElementById(action.original.parentID);
			action.originalParent = action.original.parent;
		}
		if(action.paletteID && !action.palette) {
			var toolboxes = aWindow.document.querySelectorAll('toolbox');
			for(let toolbox of toolboxes) {
				if(toolbox.palette) {
					if(toolbox.palette.id == action.paletteID) {
						action.palette = toolbox.palette;
					}
					else if(toolbox.palette == aWindow.gCustomizeMode.visiblePalette
					&& aWindow.gCustomizeMode._stowedPalette.id == action.paletteID) {
						action.palette = aWindow.gCustomizeMode._stowedPalette;
					}

					if(!action.node && action.nodeID) {
						for(let child of action.palette.childNodes) {
							if(child.id == action.nodeID) {
								action.node = child;
								break;
							}
						}
					}

					break;
				}
			}
		}

		return action;
	},

	removeOverlay: function(aWindow, overlay) {
		// failsafe, shouldn't be triggered
		var i = -1;
		var x = '';
		var allAttr = this.getAllInAttr(aWindow);
		for(let y of allAttr) {
			x = '_OVERLAYS_'+y;
			if(!aWindow[x]) { continue; }

			i = aWindow[x].indexOf(overlay);
			if(i > -1) { break; }
		}
		if(i == -1) { return; }

		if(overlay.loaded && overlay.listener.onUnload) {
			try { overlay.listener.onUnload(aWindow); }
			catch(ex) { Cu.reportError(ex); }
		}

		// If the window has been closed, there's no point in regressing all of the DOM changes, only the actual unload scripts may be necessary
		if(aWindow.closed || aWindow.willClose) {
			if(!overlay.document || overlay.remove) {
				aWindow[x].splice(i, 1);
			} else {
				overlay.loaded = false;
				overlay.traceBack = [];
				overlay.time = 0;
			}
			return;
		}

		for(var j = overlay.traceBack.length -1; j >= 0; j--) {
			var action = this.fixTraceBackNodes(aWindow, overlay.traceBack[j]);

			try {
				switch(action.action) {
					case 'appendChild':
					case 'insertBefore':
						if(action.node) {
							if(action.original && action.original.parent) {
								if(action.original.pos !== undefined) {
									var sibling = action.original.parent.childNodes[action.original.pos];
								} else {
									var sibling = action.original.parent.firstChild;
									if(sibling && sibling.nodeName == 'preferences') {
										sibling = sibling.nextSibling;
									}
								}

								var browserList = this.swapBrowsers(aWindow, action.node);
								action.original.parent.insertBefore(action.node, sibling);
								this.swapBrowsers(aWindow, action.node, browserList);
							}
							else {
								action.node.remove();
							}
						}
						break;

					case 'removeChild':
						if(action.node && action.original && action.original.parent) {
							this.registerAreas(aWindow, node);

							if(action.original.pos !== undefined && action.original.pos < action.original.parent.childNodes.length) {
								action.original.parent.insertBefore(action.node, action.original.parent.childNodes[action.original.pos]);
							} else {
								action.original.parent.appendChild(action.node);
							}
						}
						break;

					case 'modifyAttribute':
						setAttribute(action.node, action.name, action.value);
						break;

					case 'addAttribute':
						removeAttribute(action.node, action.name);
						break;

					case 'appendXMLSS':
						if(action.node) {
							action.node.remove();
						}
						break;

					case 'addPreferencesElement':
						if(action.prefs) {
							action.prefs.remove();
						}
						break;

					case 'addPreference':
						if(action.pref) {
							// There's an error logged when removing prefs, saying this failed, probably because after performing the removeChild,
							// the pref.preferences property becomes null.
							// I can't get rid of the log message but at least this way nothing should be affected by it failing
							action.pref.preferences.rootBranchInternal.removeObserver(action.pref.name, action.pref.preferences);
							action.pref.remove();
						}
						break;

					case 'sizeToContent':
						aWindow.sizeToContent();
						break;

					case 'appendButton':
						if(action.node) {
							if(action.node.parentNode && action.node.parentNode.nodeName == 'toolbarpalette') {
								action.node.remove();
							}

							var widget = CustomizableUI.getWidget(action.node.id);
							if(widget && widget.provider == CustomizableUI.PROVIDER_API) {
								// see note below (on createWidget)
								var placement = CustomizableUI.getPlacementOfWidget(action.node.id, aWindow);
								var areaType = (placement) ? CustomizableUI.getAreaType(placement.area) : null;
								if(areaType == CustomizableUI.TYPE_TOOLBAR) {
									this.tempAppendAllToolbars(aWindow, placement.area);
								}

								try { CustomizableUI.destroyWidget(action.node.id); }
								catch(ex) { Cu.reportError(ex); }

								if(areaType == CustomizableUI.TYPE_TOOLBAR) {
									this.tempRestoreAllToolbars(aWindow, placement.area);
								}
							}
						}
						break;

					case 'addToolbar':
						if(action.node) {
							// the browser adds this automatically but doesn't remove it
							if(action.toolboxid) {
								var toolbox = aWindow.document.getElementById(action.toolboxid);
								if(toolbox) {
									var et = toolbox.externalToolbars.indexOf(action.node);
									if(et > -1) {
										toolbox.externalToolbars.splice(et, 1);
									}
								}
							}

							aWindow.removeEventListener('unload', action.node._menuEntries);

							// remove the context menu entries associated with this toolbar
							var contextMenu = aWindow.document.getElementById('toolbar-context-menu');
							var panelMenu = aWindow.document.getElementById('customizationPanelItemContextMenu');
							var paletteMenu = aWindow.document.getElementById('customizationPaletteItemContextMenu');

							if(action.node._menuEntries.add.str) {
								action.node._menuEntries.add.palette.remove();
							}

							if(action.node._menuEntries.move.str) {
								contextMenu.removeEventListener('popupshowing', action.node._menuEntries.move.context);
								panelMenu.removeEventListener('popupshowing', action.node._menuEntries.move.panel);
								action.node._menuEntries.move.context.remove();
								action.node._menuEntries.move.panel.remove();
							}
							if(action.node._menuEntries.remove.str) {
								contextMenu.removeEventListener('popupshowing', action.node._menuEntries.remove);
								if(action.node._menuEntries.remove.context.getAttribute('label') == action.node._menuEntries.remove.str) {
									setAttribute(action.node._menuEntries.remove.context, 'label',
										action.node._menuEntries.remove.context.getAttribute('originalLabel'));
									toggleAttribute(action.node._menuEntries.remove.context, 'accesskey',
										action.node._menuEntries.remove.context.hasAttribute('originalAccesskey'),
										action.node._menuEntries.remove.context.getAttribute('originalAccesskey'));
									removeAttribute(action.node._menuEntries.remove.context, 'originalLabel');
									removeAttribute(action.node._menuEntries.remove.context, 'originalAccesskey');
								}
							}
							if(action.node._menuEntries.main.str) {
								action.node._menuEntries.main.context.remove();
							}

							delete action.node._menuEntries;

							if(CustomizableUI.getAreaType(action.node.id)) {
								// see note in runRegisterToolbar(), we need this in all toolbars as well
								this.tempAppendAllToolbars(aWindow, action.node.id);

								try { CustomizableUI.unregisterArea(action.node.id); }
								catch(ex) { Cu.reportError(ex); }

								this.tempRestoreAllToolbars(aWindow, action.node.id);
							}
						}
						break;

					default: break;
				}
			} catch(ex) {
				Cu.reportError(ex);
			}
		}

		this.startPreferences(aWindow);

		if(!overlay.document || overlay.remove) {
			aWindow[x].splice(i, 1);
		} else {
			overlay.loaded = false;
			overlay.traceBack = [];
			overlay.time = 0;
		}
	},

	getWidgetData: function(aWindow, node, palette) {
		var data = {
			removable: true // let's default this one
		};

		if(node.attributes) {
			for(let attr of node.attributes) {
				if(attr.value == 'true') {
					data[attr.name] = true;
				} else if(attr.value == 'false') {
					data[attr.name] = false;
				} else {
					data[attr.name] = attr.value;
				}
			}
		}

		// createWidget() defaults the removable state to true as of bug 947987
		if(!data.removable && !data.defaultArea) {
			data.defaultArea = (node.parentNode) ? node.parentNode.id : palette.id;
		}

		if(data.type == 'custom') {
			data.palette = palette;

			data.onBuild = function(aDocument, aDestroy) {
				// Find the node in the DOM tree
				var node = aDocument.getElementById(this.id);

				// If it doesn't exist, find it in a palette.
				// We make sure the button is in either place at all times.
				if(!node) {
					var toolboxes = aDocument.querySelectorAll('toolbox');
					toolbox_loop: for(let toolbox of toolboxes) {
						var palette = toolbox.palette;
						if(!palette) { continue; }

						if(palette == aDocument.defaultView.gCustomizeMode.visiblePalette) {
							palette = aDocument.defaultView.gCustomizeMode._stowedPalette;
						}
						for(let child of palette.childNodes) {
							if(child.id == this.id) {
								node = child;
								break toolbox_loop;
							}
						}
					}
				}

				// If it doesn't exist there either, CustomizableUI is using the widget information before it has been overlayed (i.e. opening a new window).
				// We get a placeholder for it, then we'll replace it later when the window overlays.
				if(!node && !aDestroy) {
					var node = aDocument.importNode(Globals.widgets[this.id], true);
					setAttribute(node, 'CUI_placeholder', 'true');
					node.collapsed = true;
				}

				return node;
			};

			// unregisterArea()'ing the toolbar can nuke the nodes, we need to make sure ours are moved to the palette
			data.onWidgetAfterDOMChange = function(aNode) {
				if(aNode.id == this.id
				&& !aNode.parentNode
				&& !trueAttribute(aNode.ownerDocument.documentElement, 'customizing') // it always ends up in the palette in this case
				&& this.palette) {
					this.palette.appendChild(aNode);
				}
			};

			data.onWidgetDestroyed = function(aId) {
				if(aId == this.id) {
					Windows.callOnAll((aWindow) => {
						var node = data.onBuild(aWindow.document, true);
						if(node) { node.remove(); }
					}, 'navigator:browser');
					CustomizableUI.removeListener(this);
				}
			};

			CustomizableUI.addListener(data);
		}

		return data;
	},

	overlayAll: function(aWindow) {
		if(aWindow._BEING_OVERLAYED !== undefined) {
			for(let overlay of this.overlays) {
				if(overlay.ready
				&& this.loadedWindow(aWindow, overlay.overlay) === false
				&& (aWindow.document.baseURI.startsWith(overlay.uri) || this.loadedWindow(aWindow, overlay.uri, true) !== false)) {
					// Ensure the window is rescheduled if needed
					if(aWindow._BEING_OVERLAYED === undefined) {
						Observers.notify('window-overlayed', aWindow);
					} else {
						aWindow._RESCHEDULE_OVERLAY = true;
					}
					break;
				}
			}
			return;
		}
		aWindow._BEING_OVERLAYED = true;
		var rescheduleOverlay = false;

		if(typeof(aWindow[this._obj]) == 'undefined') {
			aWindow[this._obj] = [];
			this.addToAttr(aWindow);
		}

		if(aWindow._UNLOAD_OVERLAYS) {
			while(aWindow._UNLOAD_OVERLAYS.length > 0) {
				var uri = aWindow._UNLOAD_OVERLAYS.shift();
				var i = this.loadedWindow(aWindow, uri);
				if(i !== false) {
					var allAttr = this.getAllInAttr(aWindow);
					// the i returned can refer to an array of another add-on, we need to make sure we get the right one
					for(let y of allAttr) {
						var x = '_OVERLAYS_'+y;
						if(!aWindow[x]) { continue; }
						if(i < aWindow[x].length && aWindow[x][i].uri == uri) { break; }
					}
					this.removeInOrder(aWindow, aWindow[x][i]);
					rescheduleOverlay = true;
				}
			}
			delete aWindow._UNLOAD_OVERLAYS;
		}

		if(aWindow.closed || aWindow.willClose) {
			if(aWindow[this._obj].length == 0) {
				delete aWindow[this._obj];
				this.removeFromAttr(aWindow);
			}
			delete aWindow._BEING_OVERLAYED;
			return;
		}

		for(let overlay of aWindow[this._obj]) {
			if(overlay.ready && !overlay.loaded) {
				aWindow._BEING_OVERLAYED = overlay;
				this.overlayDocument(aWindow, overlay);
				overlay.loaded = true;
				overlay.time = this.getNewOrder(aWindow);
				rescheduleOverlay = true;
			}
		}

		for(let x of this.overlays) {
			if(x.ready
			&& this.loadedWindow(aWindow, x.overlay) === false
			&& (aWindow.document.baseURI.startsWith(x.uri) || this.loadedWindow(aWindow, x.uri, true) !== false)) {
				aWindow._BEING_OVERLAYED = {
					uri: x.overlay,
					overlayingUri: x.uri,
					traceBack: [],
					removeMe: function() { Overlays.removeOverlay(aWindow, this); },
					time: 0,
					loaded: false,
					listener: x.listener
				};
				aWindow[this._obj].push(aWindow._BEING_OVERLAYED);

				this.overlayDocument(aWindow, x);
				aWindow._BEING_OVERLAYED.loaded = true;
				aWindow._BEING_OVERLAYED.time = this.getNewOrder(aWindow);
				rescheduleOverlay = true;
			}
		}

		if(aWindow[this._obj].length == 0) {
			delete aWindow[this._obj];
			this.removeFromAttr(aWindow);
		}
		delete aWindow._BEING_OVERLAYED;

		// Re-schedule overlaying the window to load overlays over newly loaded overlays if necessary
		if(rescheduleOverlay || aWindow._UNLOAD_OVERLAYS || aWindow._RESCHEDULE_OVERLAY) {
			delete aWindow._RESCHEDULE_OVERLAY;
			Observers.notify('window-overlayed', aWindow);
		}
		return;
	},

	overlayDocument: function(aWindow, overlay) {
		if(overlay.listener.beforeLoad) {
			try { overlay.listener.beforeLoad(aWindow); }
			catch(ex) { Cu.reportError(ex); }
		}

		for(let child of overlay.document.childNodes) {
			if(child.nodeName == 'window') {
				continue;
			}

			if(child.nodeName == 'overlay') {
				this.loadInto(aWindow, child);
			}

			else if(child.nodeName == 'xml-stylesheet') {
				this.appendXMLSS(aWindow, child);
			}
		}

		// Have to set the correct values into modified preferences
		this.startPreferences(aWindow);

		// Resize the preferences dialogs to fit the content
		this.sizeToContent(aWindow);

		this.persistOverlay(aWindow, overlay);

		if(overlay.listener.onLoad) {
			try { overlay.listener.onLoad(aWindow); }
			catch(ex) { Cu.reportError(ex); }
		}
	},

	loadInto: function(aWindow, overlay) {
		for(let overlayNode of overlay.childNodes) {
			// Special case for overlaying preferences to options dialogs
			if(overlayNode.nodeName == 'preferences') {
				this.addPreferences(aWindow, overlayNode);
				continue;
			}

			// Overlaying script elements when direct children of the overlay element
			// With src attribute we import it as a subscript of aWindow, otherwise we eval the inline content of the script tag
			// (to avoid using eval unnecessarily, only scripts with src will be imported for now)
			if(overlayNode.nodeName == 'script' && overlay.nodeName == 'overlay') {
				if(overlayNode.hasAttribute('src')) {
					Services.scriptloader.loadSubScript(overlayNode.getAttribute('src'), aWindow);
				}/* else {
					aWindow.eval(overlayNode.textContent);
				}*/
				continue;
			}

			// No id means the node won't be processed
			if(!overlayNode.id) { continue; }

			// Correctly add or remove toolbar buttons to the toolbox palette
			if(overlayNode.nodeName == 'toolbarpalette') {
				var toolboxes = aWindow.document.querySelectorAll('toolbox');
				for(let toolbox of toolboxes) {
					var palette = toolbox.palette;
					if(palette
					&& aWindow.gCustomizeMode._stowedPalette
					&& aWindow.gCustomizeMode._stowedPalette.id == overlayNode.id
					&& palette == aWindow.gCustomizeMode.visiblePalette) {
						palette = aWindow.gCustomizeMode._stowedPalette;
					}

					if(palette && palette.id == overlayNode.id) {
						buttons_loop: for(let button of overlayNode.childNodes) {
							if(button.id) {
								var existButton = aWindow.document.getElementById(button.id);

								// If it's a placeholder created by us to deal with CustomizableUI, just use it.
								if(trueAttribute(existButton, 'CUI_placeholder')) {
									removeAttribute(existButton, 'CUI_placeholder');
									existButton.collapsed = false;
									this.appendButton(aWindow, palette, existButton);
									continue buttons_loop;
								}

								// we shouldn't be changing widgets, or adding with same id as other nodes
								if(existButton) {
									continue buttons_loop;
								}

								// Save a copy of the widget node in the sandbox,
								// so CUI can use it when opening a new window without having to wait for the overlay.
								if(!Globals.widgets[button.id]) {
									Globals.widgets[button.id] = button;
								}

								// add the button if not found either in a toolbar or the palette
								button = aWindow.document.importNode(button, true);
								this.appendButton(aWindow, palette, button);
							}
						}
						break;
					}
				}
				continue;
			}

			var node = aWindow.document.getElementById(overlayNode.id);

			// Handle if node with same id was found
			if(node) {
				// Don't process if id mismatches nodename or if parents mismatch; I should just make sure this doesn't happen in my overlays
				if(node.nodeName != overlayNode.nodeName) { continue; }
				if(overlayNode.parentNode.nodeName != 'overlay' && node.parentNode.id != overlayNode.parentNode.id) { continue; }

				// If removeelement attribute is true, remove the element and do nothing else
				if(trueAttribute(overlayNode, 'removeelement')) {
					// Check if we are removing any toolbars, we can't do this
					if(!this.removingToolbars(aWindow, node)) {
						this.removeChild(aWindow, node);
					}

					continue;
				}

				// Copy attributes to node
				for(let attr of overlayNode.attributes) {
					// Why bother, id is the same already
					if(attr.name == 'id') { continue; }

					this.setAttribute(aWindow, node, attr);
				}

				// Move the node around if necessary
				this.moveAround(aWindow, node, overlayNode, node.parentNode);

				// Get Children of an Element's ID into this node
				this.getChildrenOf(aWindow, node);

				// Load children of the overlayed node
				this.loadInto(aWindow, overlayNode);
			}
			else if(overlayNode.parentNode.nodeName != 'overlay') {
				var node = aWindow.document.importNode(overlayNode, true);

				// We need to register the customization area before we append the node
				this.registerAreas(aWindow, node);

				// Add the node to the correct place
				this.moveAround(aWindow, node, overlayNode, aWindow.document.getElementById(overlayNode.parentNode.id));

				// Check if we are adding any toolbars so we remove it later from the toolbox
				this.addToolbars(aWindow, node);

				// Get Children of an Element's ID into this node
				this.getChildrenOf(aWindow, node);

				// Surf through all the children of node for the getchildrenof attribute
				if(node.getElementsByAttribute) {
					var allGetChildrenOf = node.getElementsByAttribute('getchildrenof', '*');
					for(let attrNode of allGetChildrenOf) {
						this.getChildrenOf(aWindow, attrNode);
					}
				}
			}
		}
	},

	registerAreas: function(aWindow, node) {
		if(node.nodeName == 'toolbar' && node.id && !trueAttribute(node, 'ignoreCUI') && !CustomizableUI.getAreaType(node.id)) {
			try {
				var barArgs = {
					type: CustomizableUI.TYPE_TOOLBAR,
					legacy: true,
					defaultCollapsed: null
				};
				if(trueAttribute(node, 'overflowable')) {
					barArgs.overflowable = true;
				}
				CustomizableUI.registerArea(node.id, barArgs);
			} catch(ex) { Cu.reportError(ex); }
		}

		for(let child of node.childNodes) {
			this.registerAreas(aWindow, child);
		}
	},

	// The binding containing the _init() method doesn't hold until the toolbar is visible either, apparently...
	// This tricks it into applying the binding, by temporarily moving the toolbar to a "visible" node in the document
	runRegisterToolbar: function(aWindow, node) {
		if(!node._init) {
			this.tempAppendToolbar(aWindow, node);
			this.tempRestoreToolbar(node);
		}
	},

	tempAppendToolbar: function(aWindow, node) {
		if(node.tempAppend) {
			Cu.reportError('tempAppend already exists!');
			return;
		}

		node.tempAppend = {
			parent: node.parentNode,
			sibling: node.nextSibling,
			container: aWindow.document.createElement('box')
		};

		setAttribute(node.tempAppend.container, 'style', 'position: fixed; top: 4000px; left: 4000px; opacity: 0.001;');
		aWindow.document.documentElement.appendChild(node.tempAppend.container);

		try { node.tempAppend.container.appendChild(node); }
		catch(ex) { Cu.reportError(ex); }
	},

	tempRestoreToolbar: function(node) {
		if(node.tempAppend) {
			try { node.tempAppend.parent.insertBefore(node.tempAppend.container.firstChild, node.tempAppend.sibling); }
			catch(ex) { Cu.reportError(ex); }

			node.tempAppend.container.parentNode.removeChild(node.tempAppend.container);
			delete node.tempAppend;
		}
	},

	tempAppendAllToolbars: function(aWindow, aToolbarId) {
		Windows.callOnAll((bWindow) => {
			var wToolbar = bWindow.document.getElementById(aToolbarId);
			if(wToolbar && !wToolbar._init) {
				this.tempAppendToolbar(bWindow, wToolbar);
			}
		}, aWindow.document.documentElement.getAttribute('windowtype'));
	},

	tempRestoreAllToolbars: function(aWindow, aToolbarId) {
		Windows.callOnAll((bWindow) => {
			var wToolbar = bWindow.document.getElementById(aToolbarId);
			if(wToolbar) {
				this.tempRestoreToolbar(wToolbar);
			}
		}, aWindow.document.documentElement.getAttribute('windowtype'));
	},

	// moves a toolbar without triggering its _init() method
	safeMoveToolbar: function(aToolbar, aParent, aSibling) {
		var backupInit = aToolbar._init;
		aToolbar._init = function() { return; }
		if(aSibling) {
			aParent.insertBefore(aToolbar, aSibling);
		} else {
			aParent.appendChild(aToolbar);
		}
		aToolbar._init = backupInit;
	},

	addToolbars: function(aWindow, node) {
		if(node.nodeName == 'toolbar' && node.id) {
			var toolbox = null;
			if(node.getAttribute('toolboxid')) {
				toolbox = aWindow.document.getElementById(node.getAttribute('toolboxid'));
			} else if(node.parentNode && node.parentNode.nodeName == 'toolbox') {
				toolbox = node.parentNode;
			}

			if(toolbox) {
				toggleAttribute(node, 'mode', toolbox.getAttribute('mode'), toolbox.getAttribute('mode'));
			}

			// The toolbar doesn't run the constructor until it is visible. And we want it to run regardless if it is visible or not.
			// This will just do nothing if it has been run already.
			this.runRegisterToolbar(aWindow, node);

			// CUI doesn't add these entries automatically to the menus, they're a nice addition to the UX
			node._menuEntries = {
				toolbarID: node.id,
				add: { str: node.getAttribute('menuAdd'), key: node.getAttribute('menuAddAccesskey') },
				move: { str: node.getAttribute('menuMove'), key: node.getAttribute('menuMoveAccesskey') },
				remove: { str: node.getAttribute('menuRemove'), key: node.getAttribute('menuRemoveAccesskey') },
				main: { str: node.getAttribute('menuMain'), key: node.getAttribute('menuMainAccesskey') },

				getNode: function(aNode) {
					aNode = aWindow.gCustomizeMode._getCustomizableChildForNode(aNode);
					if(aNode && aNode.localName == "toolbarpaletteitem" && aNode.firstChild) {
						aNode = aNode.firstChild;
					}
					return aNode;
				},

				getInToolbar: function(aNode, toolbar) {
					var walk = aNode;
					while(walk) {
						if(walk.tagName == 'toolbar') {
							return (walk == toolbar);
						}
						walk = walk.parentNode;
					}
					return false;
				},

				disableEntry: function(aNode, entry) {
					// if we're customizing and the node is already wrapped, we can quickly check for the wrapper's removable tag
					if(aNode.nodeName == 'toolbarpaletteitem' && aNode.id.startsWith('wrapper-')) {
						entry.disabled = !trueAttribute(aNode, 'removable');
						return;
					}

					aNode = this.getNode(aNode);

					if(!aNode) {
						entry.disabled = true;
						return;
					}

					// special case for the PanelUI-button, until https://bugzilla.mozilla.org/show_bug.cgi?id=996571 is resolved
					if(aNode.id == 'PanelUI-button' || aNode.id == 'nav-bar-overflow-button') {
						entry.disabled = !trueAttribute(aNode, 'removable');
						return;
					}

					entry.disabled = !CustomizableUI.isWidgetRemovable(aNode.id);
				},

				hideOnSelf: function(aNode, entry) {
					aNode = this.getNode(aNode);
					entry.hidden = !aNode || this.getInToolbar(aNode, node);
				},

				// because if there's multiple toolbars added through this time, there will also be multiple of these entries,
				// we only need to show one of these
				showOnlyFirstMain: function(menu, aNode) {
					var hide = !aNode || this.getInToolbar(aNode, aWindow.document.getElementById('nav-bar'));

					var mains = menu.getElementsByClassName('customize-context-moveToToolbar');
					for(let el of mains) {
						el.hidden = hide;
						if(!hide) {
							this.disableEntry(aNode, el);
						}
						hide = true;
					}
				},

				addCommand: function(aNode) {
					aNode = this.getNode(aNode);
					CustomizableUI.addWidgetToArea(aNode.id, this.toolbarID);
					if(!aWindow.gCustomizeMode._customizing) {
						CustomizableUI.dispatchToolboxEvent("customizationchange");
					}
				},

				handleEvent: function() {
					aWindow.removeEventListener('unload', this);

					var contextMenu = aWindow.document.getElementById('toolbar-context-menu');
					var panelMenu = aWindow.document.getElementById('customizationPanelItemContextMenu');

					if(this.move.str) {
						contextMenu.removeEventListener('popupshowing', this.move.context);
						panelMenu.removeEventListener('popupshowing', this.move.panel);
					}

					if(this.remove.str) {
						contextMenu.removeEventListener('popupshowing', this.remove);
					}
				}
			};

			// all of these menu entries listeners would cause a ZC if we closed a window without removing them
			aWindow.addEventListener('unload', node._menuEntries);

			var contextMenu = aWindow.document.getElementById('toolbar-context-menu');
			var panelMenu = aWindow.document.getElementById('customizationPanelItemContextMenu');
			var paletteMenu = aWindow.document.getElementById('customizationPaletteItemContextMenu');

			if(node._menuEntries.add.str) {
				node._menuEntries.add.palette = aWindow.document.createElement('menuitem');
				node._menuEntries.add.palette._toolbar = node;
				setAttribute(node._menuEntries.add.palette, 'class', 'customize-context-addTo-'+node.id);
				setAttribute(node._menuEntries.add.palette, 'oncommand', 'this._toolbar._menuEntries.addCommand(document.popupNode);');
				setAttribute(node._menuEntries.add.palette, 'label', node._menuEntries.add.str);
				toggleAttribute(node._menuEntries.add.palette, 'accesskey', node._menuEntries.add.key, node._menuEntries.add.key);
				paletteMenu.appendChild(node._menuEntries.add.palette);
			}

			if(node._menuEntries.move.str) {
				node._menuEntries.move.context = aWindow.document.createElement('menuitem');
				node._menuEntries.move.context._toolbar = node;
				setAttribute(node._menuEntries.move.context, 'class', 'customize-context-moveTo-'+node.id);
				setAttribute(node._menuEntries.move.context, 'oncommand', 'this._toolbar._menuEntries.addCommand(document.popupNode);');
				setAttribute(node._menuEntries.move.context, 'label', node._menuEntries.move.str);
				toggleAttribute(node._menuEntries.move.context, 'accesskey', node._menuEntries.move.key, node._menuEntries.move.key);

				node._menuEntries.move.context.handleEvent = function(e) {
					if(e.target.id != 'toolbar-context-menu') { return; }
					node._menuEntries.hideOnSelf(aWindow.document.popupNode, this);
					node._menuEntries.disableEntry(aWindow.document.popupNode, this);
					node._menuEntries.showOnlyFirstMain(e.target, aWindow.document.popupNode);
				};

				contextMenu.insertBefore(node._menuEntries.move.context, contextMenu.getElementsByClassName('customize-context-removeFromToolbar')[0]);
				contextMenu.addEventListener('popupshowing', node._menuEntries.move.context);

				node._menuEntries.move.panel = aWindow.document.createElement('menuitem');
				node._menuEntries.move.panel._toolbar = node;
				setAttribute(node._menuEntries.move.panel, 'class', 'customize-context-moveTo-'+node.id);
				setAttribute(node._menuEntries.move.panel, 'oncommand', 'this._toolbar._menuEntries.addCommand(document.popupNode);');
				setAttribute(node._menuEntries.move.panel, 'label', node._menuEntries.move.str);
				toggleAttribute(node._menuEntries.move.panel, 'accesskey', node._menuEntries.move.key, node._menuEntries.move.key);

				node._menuEntries.move.panel.handleEvent = function(e) {
					if(e.target.id != 'customizationPanelItemContextMenu') { return; }
					node._menuEntries.disableEntry(aWindow.document.popupNode, this);
				};

				panelMenu.insertBefore(node._menuEntries.move.panel, panelMenu.getElementsByClassName('customize-context-removeFromPanel')[0]);
				panelMenu.addEventListener('popupshowing', node._menuEntries.move.panel);
			}

			if(node._menuEntries.remove.str) {
				node._menuEntries.remove.context = contextMenu.getElementsByClassName('customize-context-removeFromToolbar')[0];
				node._menuEntries.remove.handleEvent = function(e) {
					if(e.target.id != 'toolbar-context-menu') { return; }
					var entry = this.context;
					var aNode = node._menuEntries.getNode(aWindow.document.popupNode);

					if(isAncestor(aNode, node)) {
						if(!entry.getAttribute('originalLabel')) {
							setAttribute(entry, 'originalLabel', entry.getAttribute('label'));
							toggleAttribute(entry, 'originalAccesskey', entry.hasAttribute('accesskey'), entry.getAttribute('accesskey'));
						}
						setAttribute(entry, 'label', this.str);
						toggleAttribute(entry, 'accesskey', this.key, this.key);
					}
					else if(entry.getAttribute('label') == this.str) {
						setAttribute(entry, 'label', entry.getAttribute('originalLabel'));
						toggleAttribute(entry, 'accesskey', entry.hasAttribute('originalAccesskey'), entry.getAttribute('originalAccesskey'));
						removeAttribute(entry, 'originalLabel');
						removeAttribute(entry, 'originalAccesskey');
					}
				};

				contextMenu.addEventListener('popupshowing', node._menuEntries.remove);
			}

			if(node._menuEntries.main.str) {
				node._menuEntries.main.context = aWindow.document.createElement('menuitem');
				setAttribute(node._menuEntries.main.context, 'class', 'customize-context-moveToToolbar');
				setAttribute(node._menuEntries.main.context, 'oncommand', 'gCustomizeMode.addToToolbar(document.popupNode)');
				setAttribute(node._menuEntries.main.context, 'label', node._menuEntries.main.str);
				toggleAttribute(node._menuEntries.main.context, 'accesskey', node._menuEntries.main.key, node._menuEntries.main.key);

				contextMenu.insertBefore(node._menuEntries.main.context, contextMenu.firstChild);
			}

			this.traceBack(aWindow, {
				action: 'addToolbar',
				node: node,
				toolboxid: (toolbox) ? toolbox.id : null,
				palette: (toolbox) ? toolbox.palette : null
			});
		}

		for(let child of node.childNodes) {
			this.addToolbars(aWindow, child);
		}
	},

	removingToolbars: function(aWindow, node) {
		if(node.nodeName == 'toolbar' && node.id && node.getAttribute('toolboxid')) {
			return true;
		}

		for(let child of node.childNodes) {
			if(this.removingToolbars(aWindow, child)) {
				return true;
			}
		}

		return false;
	},

	moveAround: function(aWindow, node, overlayNode, parent) {
		var newParent = null;
		if(overlayNode.getAttribute('newparent')) {
			newParent = aWindow.document.getElementById(overlayNode.getAttribute('newparent'));
			if(newParent) { parent = newParent; }
		}

		for(let attr of overlayNode.attributes) {
			switch(attr.name) {
				case 'insertbefore':
					var idList = attr.value.split(',');
					for(let i of idList) {
						var id = trim(i);
						if(id == '') { continue; }
						if(id == node.id) { continue; } // this is just stupid of course...

						for(let c of parent.childNodes) {
							if(c.id == id) {
								return this.insertBefore(aWindow, node, parent, c);
							}
						}
					}
					break;

				case 'insertafter':
					var idList = attr.value.split(',');
					for(let i of idList) {
						var id = trim(i);
						if(id == '') { continue; }
						if(id == node.id) { continue; } // this is just stupid of course...

						for(let c of parent.childNodes) {
							if(c.id == id) {
								return this.insertBefore(aWindow, node, parent, c.nextSibling);
							}
						}
					}
					break;

				case 'position':
					var position = parseInt(attr.value) -1; // one-based children list
					var sibling = (position < parent.childNodes.length) ? parent.childNodes[position] : null;
					return this.insertBefore(aWindow, node, parent, sibling);
					break;

				default: break;
			}
		}

		if(!node.parentNode || newParent) {
			return this.appendChild(aWindow, node, parent);
		}
		return node;
	},

	getChildrenOf: function(aWindow, node) {
		var getID = node.getAttribute('getchildrenof');
		if(!getID) { return; }

		getID = getID.split(',');
		for(let id of getID) {
			var getNode = aWindow.document.getElementById(trim(id));
			if(!getNode) { continue; }

			var child = getNode.firstChild
			while(child) {
				let move = child;
				child = child.nextSibling;
				if(move.nodeName == 'preferences' || isAncestor(node, move)) { continue; }

				this.appendChild(aWindow, move, node);
			}
		}
	},

	appendChild: function(aWindow, node, parent) {
		var original = this.getOriginalParent(node);
		var browserList = this.swapBrowsers(aWindow, node);

		try { parent.appendChild(node); }
		catch(ex) { Cu.reportError(ex); }

		this.swapBrowsers(aWindow, node, browserList);
		this.traceBack(aWindow, {
			action: 'appendChild',
			node: node,
			original: original
		});
		return node;
	},

	insertBefore: function(aWindow, node, parent, sibling) {
		var original = this.getOriginalParent(node);
		var browserList = this.swapBrowsers(aWindow, node);

		try { parent.insertBefore(node, sibling); }
		catch(ex) { Cu.reportError(ex); }

		this.swapBrowsers(aWindow, node, browserList);
		this.traceBack(aWindow, {
			action: 'insertBefore',
			node: node,
			original: original
		});

		return node;
	},

	getOriginalParent: function(aNode) {
		var originalParent = aNode.parentNode;

		if(originalParent) {
			for(var o = 0; o < originalParent.childNodes.length; o++) {
				if(originalParent.childNodes[o] == aNode) {
					return { parent: originalParent, pos: o };
				}
			}

			return { parent: originalParent };
		}

		return { parent: originalParent };
	},

	// this ensures we don't need to reload any browser elements when they are moved within the DOM;
	// all the temporary browser elements are promptly removed once they're not needed.
	// so far, this is only used for OmniSidebar, so I can move the browser#sidebar element at will through the dom without it reloading every time
	swapBrowsers: function(aWindow, node, temps) {
		if(temps !== undefined) {
			this.cleanTempBrowsers(temps);
			return null;
		}

		// none of this is needed if the node doesn't exist yet in the DOM
		if(!node.parentNode) { return null; }

		// find all browser child nodes of node if it isn't a browser itself
		var bNodes = [];
		if(node.tagName == 'browser') { bNodes.push(node); }
		else {
			var els = node.getElementsByTagName('browser');
			for(let ee of els) {
				bNodes.push(ee);
			}
		}

		if(bNodes.length > 0) {
			temps = [];
			tempBrowsersLoop: for(let browser of bNodes) {
				if(!browser.swapDocShells) { continue; } // happens when it isn't loaded yet, so it's unnecessary
				var browserType = browser.getAttribute('type') || 'chrome';

				// we also need to blur() and then focus() the focusedElement if it belongs in this browser element,
				// otherwise we can't type in it if it's an input box and we swap its docShell;
				// note that just blur()'ing the focusedElement doesn't actually work, we have to shift the focus between browser elements for this to work
				if(aWindow.document.commandDispatcher.focusedElement && isAncestor(aWindow.document.commandDispatcher.focusedElement, browser)) {
					temps.unshift({ // unshift instead of push so we undo in the reverse order
						focusedElement: aWindow.document.commandDispatcher.focusedElement
					});
					aWindow.document.documentElement.focus();
				}

				// We need to move content inner-browsers first, otherwise it will throw an NS_ERROR_NOT_IMPLEMENTED
				var innerDone = [];
				var inners = [];

				if(browser.contentDocument) {
					var els = browser.contentDocument.getElementsByTagName('browser');
					for(let ee of els) {
						inners.push(ee);
					}
				}

				if(inners.length > 0) {
					for(let inner of inners) {
						if(!inner.swapDocShells) { continue; } // happens when it isn't loaded yet, so it's unnecessary

						// if the browsers are of the same time, the swap can proceed as normal
						var innerType = inner.getAttribute('type');
						if(!innerType || innerType == browserType) { continue; }

						var newTemp = this.createBlankTempBrowser(aWindow, innerType);

						try {
							this.setTempBrowsersListeners(inner);
							inner.swapDocShells(newTemp);
						}
						catch(ex) { // undo everything and just let the browser element reload
							//Cu.reportError('Failed to swap inner browser in '+browser.tagName+' '+browser.id);
							//Cu.reportError(ex);
							this.cleanTempBrowsers(innerDone);
							newTemp.remove();
							continue tempBrowsersLoop;
						}

						innerDone.unshift({ // unshift instead of push so we undo in the reverse order
							sibling: inner.nextSibling,
							parent: inner.parentNode,
							browser: inner,
							temp: newTemp
						});
						inner.remove();
					}
				}

				// iframes don't have swapDocShells(), but they will throw an error if not ripped off too
				var iframesDone = [];
				var iframes = [];

				if(browser.contentDocument) {
					var els = browser.contentDocument.getElementsByTagName('iframe');
					for(let ee of els) {
						iframes.push(ee);
					}
				}

				if(iframes.length > 0) {
					for(let iframe of iframes) {
						var frameType = iframe.getAttribute('type');
						if(!frameType || frameType == browserType) { continue; }

						var newTemp = this.createBlankTempBrowser(aWindow, frameType, 'iframe');

						try { iframe.QueryInterface(Ci.nsIFrameLoaderOwner).swapFrameLoaders(newTemp); }
						catch(ex) { // undo everything and just let the browser element reload
							//Cu.reportError('Failed to swap iframe in '+browser.tagName+' '+browser.id);
							//Cu.reportError(ex);
							this.cleanTempBrowsers(iframesDone);
							newTemp.remove();
							continue tempBrowsersLoop;
						}

						iframesDone.unshift({ // unshift instead of push so we undo in the reverse order
							sibling: iframe.nextSibling,
							parent: iframe.parentNode,
							browser: iframe,
							iframe: true,
							temp: newTemp
						});
						iframe.remove();
					}
				}

				var newTemp = this.createBlankTempBrowser(aWindow, browserType);

				try {
					this.setTempBrowsersListeners(browser);
					browser.swapDocShells(newTemp);
				}
				catch(ex) { // undo everything and just let the browser element reload
					//Cu.reportError('Failed to swap '+browser.tagName+' '+browser.id);
					//Cu.reportError(ex);
					this.cleanTempBrowsers(innerDone);
					newTemp.remove();
					continue;
				}

				temps = iframesDone.concat(innerDone).concat(temps);
				temps.unshift({ // unshift instead of push so we undo in the reverse order
					browser: browser,
					temp: newTemp
				});
			}

			return (temps.length > 0) ? temps : null;
		}

		return null;
	},

	// this creates a temporary browser element in the main window; element defaults to 'browser' and type to 'chrome'
	createBlankTempBrowser: function(aWindow, type, element) {
		var newTemp = aWindow.document.createElement(element || 'browser');
		newTemp.collapsed = true;
		setAttribute(newTemp, 'type', type || 'chrome');
		setAttribute(newTemp, 'src', 'about:blank');
		aWindow.document.documentElement.appendChild(newTemp);
		newTemp.docShell.createAboutBlankContentViewer(null);
		return newTemp;
	},

	// remove all traces of all of these swaps
	cleanTempBrowsers: function(list) {
		if(!list) { return; }
		for(let l of list) {
			if(l.focusedElement) {
				l.focusedElement.focus();
				continue;
			}

			if(l.parent) {
				l.parent.insertBefore(l.browser, l.sibling);
			}

			try {
				if(!l.iframe) {
					this.setTempBrowsersListeners(l.temp);
					l.browser.swapDocShells(l.temp);
				}
				else { l.browser.QueryInterface(Ci.nsIFrameLoaderOwner).swapFrameLoaders(l.temp); }
			}
			catch(ex) { /* nothing we can do at this point */  }

			l.temp.remove();
		}
	},

	// some sidebars (i.e. DOM Inspector) have listeners for their browser elements, we need to make sure (as best as we can) that they're not triggered when swapping
	tempBrowserListenEvents: ['pageshow'],
	setTempBrowsersListeners: function(browser) {
		for(let type of this.tempBrowserListenEvents) {
			this.createTempBrowserListener(browser, type);
		}
	},
	createTempBrowserListener: function(browser, type) {
		// we wrap all this in its own object, so it can still remove itself even after disabling the add-on
		var listener = function(e) {
			if(e.target == browser.contentDocument) {
				e.preventDefault();
				e.stopPropagation();
				browser.ownerDocument.defaultView.removeEventListener(type, listener, true);
			}
		};
		browser.ownerDocument.defaultView.addEventListener(type, listener, true);
	},

	removeChild: function(aWindow, node) {
		var original = this.getOriginalParent(node);

		try { node.remove(); }
		catch(ex) { Cu.reportError(ex); }

		this.traceBack(aWindow, {
			action: 'removeChild',
			node: node,
			original: original
		});
		return node;
	},

	setAttribute: function(aWindow, node, attr) {
		if(node.hasAttribute(attr.name)) {
			this.traceBack(aWindow, {
				action: 'modifyAttribute',
				node: node,
				name: attr.name,
				value: node.getAttribute(attr.name)
			});
		}
		else if(attr.value != '__remove') {
			this.traceBack(aWindow, {
				action: 'addAttribute',
				node: node,
				name: attr.name
			});
		}

		try {
			if(attr.value == '__remove') {
				node.removeAttribute(attr.name);
			} else {
				node.setAttribute(attr.name, attr.value);
			}
		}
		catch(ex) {}
	},

	appendXMLSS: function(aWindow, node) {
		try {
			node = aWindow.document.importNode(node, true);
			// these have to come before the actual window element
			aWindow.document.insertBefore(node, aWindow.document.documentElement);
			this.waitForSSLoaded(aWindow, node);
		} catch(ex) {}
		this.traceBack(aWindow, {
			action: 'appendXMLSS',
			node: node
		});
		return node;
	},

	addPreferences: function(aWindow, node) {
		var prefPane = aWindow.document.getElementById(node.parentNode.id);
		if(!prefPane) { return; }

		var preferences = prefPane.getElementsByTagName('preferences')[0];
		if(!preferences) {
			try {
				// don't clone, it bugs out saying this.preferences (on each preference) doesn't exist
				preferences = aWindow.document.createElement('preferences');
				prefPane.appendChild(preferences);

				this.traceBack(aWindow, {
					action: 'addPreferencesElement',
					prefs: preferences
				});
			}
			catch(ex) { Cu.reportError(ex); }
		}

		for(let child of node.childNodes) {
			if(!child.id) { continue; }

			try {
				// don't clone, same as above
				var pref = aWindow.document.createElement('preference');
				for(let attr of child.attributes) {
					pref.setAttribute(attr.name, attr.value);
				}
				preferences.appendChild(pref);

				this.traceBack(aWindow, {
					action: 'addPreference',
					pref: pref
				});
			}
			catch(ex) { Cu.reportError(ex); }
		}
	},

	startPreferences: function(aWindow) {
		var preferences = aWindow.document.getElementsByTagName('preference');
		for(let pref of preferences) {
			// Overlayed preferences have a null value, like they haven't been initialized for some reason, this takes care of that
			if(pref.value === null) {
				pref.value = pref.valueFromPreferences;
			}
			try { pref.updateElements(); } catch(ex) {}
		}
	},

	sizeToContent: function(aWindow) {
		var isPrefDialog = aWindow.document.getElementsByTagName('prefwindow');
		if(isPrefDialog.length > 0 && isPrefDialog[0].parentNode == aWindow.document) {
			try { aWindow.sizeToContent(); } catch(ex) {}
			this.traceBack(aWindow, { action: 'sizeToContent' }, true);
		}
	},

	appendButton: function(aWindow, palette, node) {
		if(!node.parentNode) {
			palette.appendChild(node);
		}
		var id = node.id;

		var widget = CustomizableUI.getWidget(id);
		if(!widget || widget.provider != CustomizableUI.PROVIDER_API) {
			// this needs the binding applied on the toolbar in order for the widget to be immediatelly placed there,
			// and since its placements won't be restored until it's created, we have to search for it in all existing areas
			var areaId = null;
			var areas = CustomizableUI.areas;
			for(let area of areas) {
				// this will throw if called too early for an area whose placements have not been fetched yet,
				// it's ok because once they are, the widget will be placed in it anyway
				try { var inArea = CustomizableUI.getWidgetIdsInArea(area); }
				catch(ex) { continue; }

				if(inArea.indexOf(id) > -1) {
					if(CustomizableUI.getAreaType(area) != CustomizableUI.TYPE_TOOLBAR) { break; }

					areaId = area;
					this.tempAppendAllToolbars(aWindow, area);
					break;
				}
			}

			try { CustomizableUI.createWidget(this.getWidgetData(aWindow, node, palette)); }
			catch(ex) { Cu.reportError(ex); }

			if(areaId) {
				this.tempRestoreAllToolbars(aWindow, areaId);
			}
		}

		else {
			var placement = CustomizableUI.getPlacementOfWidget(id, aWindow);
			var areaNode = (placement) ? aWindow.document.getElementById(placement.area) : null;
			if(areaNode && areaNode.nodeName == 'toolbar' && !areaNode._init) {
				this.tempAppendToolbar(aWindow, areaNode);
			}

			try { CustomizableUI.ensureWidgetPlacedInWindow(id, aWindow); }
			catch(ex) { Cu.reportError(ex); }

			if(areaNode) {
				this.tempRestoreToolbar(areaNode);
			}
		}

		this.traceBack(aWindow, {
			action: 'appendButton',
			node: node
		});
		return node;
	},

	addToAttr: function(aWindow) {
		var attr = this.getAllInAttr(aWindow);
		if(attr.indexOf(objName) > -1) { return; }

		attr.push(objName);
		setAttribute(aWindow.document.documentElement, 'Bootstrapped_Overlays', attr.join(' '));
	},

	getAllInAttr: function(aWindow) {
		var attr = aWindow.document.documentElement.getAttribute('Bootstrapped_Overlays');
		if(!attr) { return []; }
		else { return attr.split(' '); }
	},

	removeFromAttr: function(aWindow) {
		var attr = this.getAllInAttr(aWindow);
		var i = attr.indexOf(objName);
		if(i == -1) { return; }

		attr.splice(i, 1);
		toggleAttribute(aWindow.document.documentElement, 'Bootstrapped_Overlays', attr.length > 0, attr.join(' '));
	},

	// some nodes shouldn't be made visible until the appended stylesheets have loaded, to prevent lots of jumping around and distorted elements by being unstyled for a moment
	waitForSSLoaded: function(aWindow, aNode) {
		let sheet = aNode.sheet.href;

		let obj = aWindow[this._obj+'_wait'];
		if(!obj) {
			obj = aWindow[this._obj+'_wait'] = {
				sheets: new Set(),
				queued: new Set()
			};
		}

		obj.sheets.add(sheet);

		let sscode = '\
			@namespace url(http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul);\n\
			[waitForSS~="'+sheet+'"] { visibility: collapse !important; transition: none !important; }';

		Styles.load('waitfor:'+sheet, sscode, true);

		let waitSSLoaded = () => {
			aNode.removeEventListener('load', waitSSLoaded);
			Styles.unload('waitfor:'+sheet);
			obj.sheets.delete(sheet);

			if(obj.sheets.size == 0) {
				// run the queued methods that were waiting for the SS's to laod
				for(let method of obj.queued) {
					try {
						method();
						obj.queued.delete(method);
					}
					catch(ex) { Cu.reportError(ex); }
				}

				delete aWindow[this._obj+'_wait'];
			}
		};
		aNode.addEventListener('load', waitSSLoaded);
	},

	// if all the appended stylesheets aren't loaded yet, these methods will be postponed until they are, otherwise they will run immediatelly
	runWhenSheetsLoaded: function(aMethod) {
		if(!aWindow[this._obj+'_wait']) {
			aMethod();
			return;
		}
		aWindow[this._obj+'_wait'].queued.add(aMethod);
	},

	// toolbar nodes can't be registered before they're appended to the DOM, otherwise all hell breaks loose
	registerToolbarNode: function(aToolbar, aExistingChildren) {
		if(!aToolbar || !aToolbar.id) { return; } // is this even possible?

		// attempt at improving multi-window support, as sometimes the toolbars would force a re-register of a second window with CUI when it's closed, no clue why though...
		if(aToolbar.ownerDocument.defaultView.closed || aToolbar.ownerDocument.defaultView.willClose) { return; }

		if(!aToolbar.ownerDocument.getElementById(aToolbar.id)) {
			aSync(function() { CustomizableUI.registerToolbarNode(aToolbar, aExistingChildren); }, 250);
			return;
		}
		this._registerToolbarNode(aToolbar, aExistingChildren);

		// the nodes insertion seems to fall somewhere between oveflow being initialized already but not listening to onOverflow events apparently
		if(aToolbar.overflowable && aToolbar.overflowable.initialized && aToolbar.customizationTarget.scrollLeftMax > 0 && !trueAttribute(aToolbar, 'overflowing')) {
			aToolbar.overflowable.onOverflow();
		}
	}
};

Modules.LOADMODULE = function() {
	Globals.widgets = {};

	Windows.register(Overlays, 'domwindowopened');
	Browsers.register(Overlays, 'pageshow');
	Browsers.register(Overlays, 'SidebarFocused');
	Browsers.register(Overlays, 'pagehide');
	Browsers.register(Overlays, 'SidebarUnloaded');
	Observers.add(Overlays, 'window-overlayed');

	Piggyback.add('Overlays', CUIBackstage.CustomizableUIInternal, 'registerToolbarNode', Overlays.registerToolbarNode);
};

Modules.UNLOADMODULE = function() {
	Observers.remove(Overlays, 'window-overlayed');
	Windows.unregister(Overlays, 'domwindowopened');
	Browsers.unregister(Overlays, 'pageshow');
	Browsers.unregister(Overlays, 'SidebarFocused');
	Browsers.unregister(Overlays, 'pagehide');
	Browsers.unregister(Overlays, 'SidebarUnloaded');

	Windows.callOnAll((aWindow) => {
		Overlays.unloadAll(aWindow);
	});
	Browsers.callOnAll((aWindow) => {
		if(!(aWindow.document instanceof aWindow.XULDocument)) { return; } // at least for now I'm only overlaying xul documents
		Overlays.unloadAll(aWindow);
	});

	Piggyback.revert('Overlays', CUIBackstage.CustomizableUIInternal, 'registerToolbarNode');

	delete Globals.widgets;
};
