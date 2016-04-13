// VERSION 2.6.6
Modules.UTILS = true;
Modules.BASEUTILS = true;

// Watchers - This acts as a replacement for the event DOM Attribute Modified, works for both attributes and object properties
//	addPropertyWatcher(obj, prop, handler, capture) - registers handler as a watcher for obj property prop changes
//		obj - (xul element or object) to watch for changes
//		prop - (string) property name in obj to watch
//		handler - (function) method or (obj) with propWatcher() method to fire when prop is set or changed
//		(optional) capture - when (bool) true it cancels setting the property if handler returns (bool) false, defaults to (bool) false
//	removePropertyWatcher(obj, prop, handler, capture) - unregisters handler as a watcher for prop changes
//		see addPropertyWatcher()
//	addAttributeWatcher(obj, attr, handler, capture, iterateAll) - registers handler as a watcher for object attribute attr changes
//		obj - (xul element or object) to watch for changes
//		attr - (string) attribute name in obj to watch
//		handler - (function) method or (obj) with attrWatcher() method to fire when attr is set, removed or changed
//		(optional) capture - when (bool) true it cancels setting the attribute if handler returns (bool) false, defaults to (bool) false
//		(optional) iterateAll -	when (bool) false only triggers handler for the last change in the attribute, merging all the changes queued in between.
//					when (bool) true triggers handler for every attribute change in the queue. Defaults to (bool) true.
//					will always act as (bool) true if capture is (bool) true.
//	removeAttributeWatcher(obj, attr, handler, capture, iterateAll) - unregisters handler as a watcher for object attribute attr changes
//		see addAttributeWatcher()
// All handlers expect function(obj, prop, oldVal, newVal), where:
//	obj - (xul element or object) where the change occured
//	prop - (string) name of the property or attribute being set or changed
//	oldVal - the current value of prop
//	newVal - the new value of prop
//	lastCapture - for attribute watchers only, this will be (bool) true on the last attribute mutation in the list, during the capture phase
// Note: deleting a watched property does not trigger the watchers, so don't do it! Set it to undefined instead if you wish to delete it after removing the watchers.
this.Watchers = {
	_obj: '_WATCHERS_'+this.objName,

	// Properties part, works by replacing the get and set accessor methods of a property with custom ones
	addPropertyWatcher: function(obj, prop, handler, capture) {
		if(!this.setWatchers(obj)) { return false; }
		capture = (capture) ? true : false;

		if(!obj[this._obj].properties[prop]) {
			var propHandler = {
				value: obj[prop],
				handlers: new Set(),
				handling: false
			};

			// can't watch constants
			if(!(delete obj[prop])) {
				this.unsetWatchers(obj);
				return false;
			}

			obj[this._obj].properties[prop] = propHandler;

			obj.__defineGetter__(prop, function () { return propHandler.value; });
			obj.__defineSetter__(prop, function (newVal) {
				if(propHandler.handling) {
					propHandler.value = newVal;
					return propHandler.value;
				}
				propHandler.handling = true;

				let oldVal = propHandler.value;
				for(let h of propHandler.handlers) {
					if(!h.capture) { continue; }

					if(Watchers.safeCallHandler(h.handler, 'prop', this, prop, oldVal, newVal) === false) {
						propHandler.handling = false;
						return propHandler.value;
					}
				}
				propHandler.value = newVal;
				for(let h of propHandler.handlers) {
					if(h.capture) { continue; }

					Watchers.safeCallHandler(h.handler, 'prop', this, prop, oldVal, newVal);
				}

				propHandler.handling = false;
				return propHandler.value;
			});
		}
		else {
			for(let h of obj[this._obj].properties[prop].handlers) {
				if(h.handler == handler && capture == h.capture) { return true; }
			}
		}

		obj[this._obj].properties[prop].handlers.add({ handler: handler, capture: capture });
		obj[this._obj].setters++;
		return true;
	},

	removePropertyWatcher: function(obj, prop, handler, capture) {
		if(!obj[this._obj] || !obj[this._obj].properties[prop]) { return false; }
		capture = (capture) ? true : false;

		for(let stored of obj[this._obj].properties[prop].handlers) {
			if(stored.handler == handler && stored.capture == capture) {
				obj[this._obj].properties[prop].handlers.delete(stored);
				if(obj[this._obj].properties[prop].handlers.size == 0) {
					delete obj[prop]; // remove accessors
					if(obj[this._obj].properties[prop].value !== undefined) {
						obj[prop] = obj[this._obj].properties[prop].value;
					}
					delete obj[this._obj].properties[prop];
				}

				obj[this._obj].setters--;
				this.unsetWatchers(obj);
				return true;
			}
		}

		return false;
	},

	// Attributes part, works through delayed DOM Mutation Observers
	addAttributeWatcher: function(obj, attr, handler, capture, iterateAll) {
		if(!this.setWatchers(obj)) { return false; }
		capture = (capture) ? true : false;
		iterateAll = (capture || iterateAll) ? true : false;

		let handlers = obj[this._obj].attributes.get(attr);
		if(!handlers) {
			handlers = new Set();

			obj[this._obj].disconnect();
			obj[this._obj].attributes.set(attr, handlers);
			obj[this._obj].reconnect();
		}
		else {
			for(let a of handlers) {
				if(a.handler == handler && a.capture == capture && a.iterateAll == iterateAll) { return true; }
			}
		}

		handlers.add({ handler: handler, capture: capture, iterateAll: iterateAll });
		obj[this._obj].setters++;
		return true;
	},

	removeAttributeWatcher: function(obj, attr, handler, capture, iterateAll) {
		if(!obj || !obj[this._obj] || !obj[this._obj].attributes.has(attr)) { return false; }
		capture = (capture) ? true : false;
		iterateAll = (capture || iterateAll) ? true : false;

		let handlers = obj[this._obj].attributes.get(attr);
		for(let stored of handlers) {
			if(stored.handler == handler && stored.capture == capture && stored.iterateAll == iterateAll) {
				handlers.delete(stored);
				if(!handlers.size) {
					obj[this._obj].disconnect();
					obj[this._obj].attributes.delete(attr);
					obj[this._obj].reconnect();
				}

				obj[this._obj].setters--;
				this.unsetWatchers(obj);
				return true;
			}
		}

		return false;
	},

	setWatchers: function(obj) {
		if(!obj || typeof(obj) != 'object') { return false; }
		if(obj[this._obj]) { return true; }

		let handler = {
			setters: 0,
			properties: {}
		};
		obj[this._obj] = handler;

		if(!obj.ownerDocument) { return true; }

		handler.attributes = new Map();
		handler.mutations = [];
		handler.scheduler = null;
		handler.reconnect = function() {
			let attrList = [];
			for(let a of this.attributes.keys()) {
				attrList.push(a);
			}
			if(attrList.length > 0) {
				this.mutationObserver.observe(obj, {
					attributes: true,
					attributeOldValue: true,
					attributeFilter: attrList
				});
			}
		};
		handler.disconnect = function() {
			this.mutationObserver.disconnect();
		};
		handler.scheduleWatchers = function(mutations, observer) {
			if(this.schedule) {
				this.schedule.cancel();
				this.schedule = null;
			}

			for(let m of mutations) {
				this.mutations.push(m);
			}

			// the script could become really heavy if it called the main function everytime (width attribute on sidebar and dragging it for instance)
			// I'm simply following the changes asynchronously; any delays for heavily changed attributes should be handled properly by the actual handlers.
			this.schedule = aSync(() => { this.callAttrWatchers(); });
		};
		handler.callAttrWatchers = function() {
			this.disconnect();
			let muts = this.mutations;
			this.mutations = [];

			for(let [ attr, handlers ] of this.attributes) {
				let changes = 0;
				let oldValue = false;
				let newValue = obj.hasAttribute(attr) ? obj.getAttribute(attr) : null;
				captureMutations_loop: for(let m = 0; m < muts.length; m++) {
					if(muts[m].attributeName != attr) { continue; }

					oldValue = typeof(muts[m].realOldValue) != 'undefined' ? muts[m].realOldValue : muts[m].oldValue;
					newValue = false;
					for(let n = m+1; n < muts.length; n++) {
						if(muts[n].attributeName == attr) {
							newValue = typeof(muts[n].realOldValue) != 'undefined' ? muts[n].realOldValue : muts[n].oldValue;
							break;
						}
					}
					if(newValue === false) {
						newValue = obj.hasAttribute(attr) ? obj.getAttribute(attr) : null;
					}

					if(oldValue === newValue) {
						muts.splice(m, 1);
						m--;
						continue captureMutations_loop;
					}

					for(let a of handlers) {
						if(!a.capture) { continue; }

						if(Watchers.safeCallHandler(a.handler, 'attr', obj, attr, oldValue, newValue, m == muts.length -1) === false) {
							for(let n = m+1; n < muts.length; n++) {
								if(muts[n].attributeName == attr) {
									muts[n].realOldValue = oldValue;
									break;
								}
							}
							newValue = oldValue;
							muts.splice(m, 1);
							m--;
							continue captureMutations_loop;
						}
					}

					changes++;
				}

				toggleAttribute(obj, attr, newValue !== null, newValue);

				if(changes > 0) {
					let firstOldValue = typeof(muts[0].realOldValue) != 'undefined' ? muts[0].realOldValue : muts[0].oldValue;
					for(let m = 0; m < muts.length; m++) {
						if(muts[m].attributeName != attr) { continue; }

						oldValue = typeof(muts[m].realOldValue) != 'undefined' ? muts[m].realOldValue : muts[m].oldValue;
						newValue = false;
						for(let n = m+1; n < muts.length; n++) {
							if(muts[n].attributeName == attr) {
								newValue = typeof(muts[n].realOldValue) != 'undefined' ? muts[n].realOldValue : muts[n].oldValue;
								break;
							}
						}
						if(newValue === false) {
							newValue = obj.hasAttribute(attr) ? obj.getAttribute(attr) : null;
						}

						for(let a of handlers) {
							if(a.capture) { continue; }

							let lastM = m == muts.length -1;
							if(a.iterateAll) {
								Watchers.safeCallHandler(a.handler, 'attr', obj, attr, oldValue, newValue);
							}
							else if(m == muts.length -1) {
								Watchers.safeCallHandler(a.handler, 'attr', obj, attr, firstOldValue, newValue);
							}
						}
					}
				}
			}

			this.reconnect();
		};
		handler.mutationObserver = new obj.ownerDocument.defaultView.MutationObserver((mutations, observer) => { handler.scheduleWatchers(mutations, observer); });

		return true;
	},

	unsetWatchers: function(obj) {
		if(typeof(obj) != 'object' || !obj || !obj[this._obj] || obj[this._obj].setters > 0) { return false; }

		obj[this._obj].disconnect();
		delete obj[this._obj];
		return true;
	},

	safeCallHandler: function(handler, method, obj, prop, oldValue, newValue, lastCapture) {
		try {
			if(handler[method+'Watcher']) {
				return handler[method+'Watcher'](obj, prop, oldValue, newValue, lastCapture);
			} else {
				return handler(obj, prop, oldValue, newValue, lastCapture);
			}
		}
		catch(ex) {
			Cu.reportError(ex);
			return true;
		}
	}
};
