// VERSION 2.4.0
Modules.UTILS = true;
Modules.BASEUTILS = true;

// Listeners - Object to aid in setting and removing all kinds of event listeners to an object;
// add(obj, type, listener, capture, maxTriggers) - attaches listener to obj
//	obj - (object) to attach the listener to
//	type - (string) event type to listen for
//	listener - (function) method to be called when event is dispatched, by default this will be bound to self
//	(optional) capture - (bool) true or false, defaults to false
//	(optional) maxTriggers -
//		(int) maximum number of times to fire listener,
//		(bool) true is equivalent to (int) 1,
//		defaults to undefined
// remove(obj, type, listener, capture, maxTriggers) - removes listener from obj
//	see add()
this.Listeners = {
	handlers: new Set(),
	inContent: typeof(Scope) != 'undefined',

	// Used to be if maxTriggers is set to the boolean false, it acted as a switch to not bind the function to our object,
	// However this is no longer true, not only did I not use it, due to recent modifications to the method, it would be a very complex system to achieve.
	add: function(obj, type, listener, capture, maxTriggers) {
		if(!obj || !obj.addEventListener) { return false; }

		if(this.listening(obj, type, capture, listener)) { return true; }

		if(maxTriggers === true) { maxTriggers = 1; }

		var handler = {
			_obj: obj,
			_objID: obj.id,
			get obj () {
				// failsafe, never happened before but can't hurt
				if(!this._obj && this._objID) {
					this._obj = $(this._objID);
				}
				return this._obj;
			},
			type: type,
			listener: listener,
			capture: capture,
			maxTriggers: (maxTriggers) ? maxTriggers : null,
			triggerCount: 0,

			handleEvent: function(e) {
				if(this.maxTriggers) {
					this.triggerCount++;
					if(this.triggerCount == this.maxTriggers) {
						Listeners.remove(this.obj, this.type, this.listener, this.capture);
					}
				}

				if(this.listener.handleEvent) {
					this.listener.handleEvent(e);
				} else {
					this.listener(e);
				}
			}
		};

		this.handlers.add(handler);

		handler.obj.addEventListener(handler.type, handler, handler.capture);
		return true;
	},

	remove: function(obj, type, listener, capture, maxTriggers) {
		try {
			if(!obj || !obj.removeEventListener) { return false; }
		}
		catch(ex) {
			handleDeadObject(ex); /* prevents some can't access dead objects */
			return false;
		}

		let handler = this.listening(obj, type, capture, listener);
		if(handler) {
			handler.obj.removeEventListener(handler.type, handler, handler.capture);
			this.handlers.delete(handler);
			return true;
		}
		return false;
	},

	listening: function(obj, type, capture, listener) {
		for(let handler of this.handlers) {
			if(handler.obj == obj
			&& handler.type == type
			&& handler.capture == capture
			&& handler.listener == listener) {
				return handler;
			}
		}
		return null;
	},

	/* I'm not sure if clean is currently working...
	OmniSidebar - Started browser and opened new window then closed it, it would not remove the switchers listeners, I don't know in which window,
	or it would but it would still leave a ZC somehow. Removing them manually in UNLOADMODULE fixed the ZC but they should have been taken care of here */
	clean: function() {
		for(let handler of this.handlers) {
			try {
				if(handler.obj && handler.obj.removeEventListener) {
					handler.obj.removeEventListener(handler.type, handler, handler.capture);
				}
			}
			catch(ex) { handleDeadObject(ex); /* Prevents can't access dead object sometimes */ }
			this.handlers.delete(handler);
		}
	}
};

Modules.UNLOADMODULE = function() {
	Listeners.clean();
};
