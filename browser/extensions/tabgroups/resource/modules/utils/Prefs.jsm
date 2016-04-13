// VERSION 2.5.4
Modules.UTILS = true;
Modules.BASEUTILS = true;

// Prefs -	Object to contain and manage all preferences related to the add-on (and others if necessary)
// 		All default preferences of the add-on ('extensions.objPathString.*') are sync'ed by Firefox Sync by default,
//		to prevent a specific preference "pref" from sync'ing, add in prefList a property "NoSync_pref" set to (bool) true.
// setDefaults(prefList, branch, trunk) - sets the add-on's preferences default values
//	prefList - (object) { prefName: defaultValue }, looks for 'trunk.branch.prefName'
//	(optional) branch - (string) defaults to objPathString
//	(optional) trunk - (string) defaults to 'extensions'
// listen(pref, handler) - add handler as a change event listener to pref
//	pref - (string) name of preference to append handler to
//	handler -	(function) to be fired on change event, expects (aSubject, aData) arguments,
//			or (nsiObserver) with observe(aSubject, aTopic, aData), where:
//				aSubject - (string) name of preference that was changed
//				aTopic - (string) "nsPref:changed"
//				aData - new preference value
// unlisten(pref, handler) - remove handler as a change event listener of pref
//	see listen()
// listening(pref, handler) - returns (bool) if handler is registered as pref listener, returns (bool) false otherwise
//	see listen()
// reset(pref) - resets pref to default value
//	see listen()
this.Prefs = {
	_prefObjects: {},
	length: 0,

	setDefaults: function(prefList, branch, trunk) {
		if(!branch) {
			branch = objPathString;
		}
		if(!trunk && trunk !== '') {
			trunk = 'extensions';
		}

		// we assume that a Prefs module has been initiated in the main process at least once, so none of this is actually necessary
		if(self.isChrome) {
			var branchString = ((trunk) ? trunk+'.' : '') +branch+'.';
			var defaultBranch = Services.prefs.getDefaultBranch(branchString);
			var syncBranch = Services.prefs.getDefaultBranch('services.sync.prefs.sync.');

			for(let pref in prefList) {
				if(pref.startsWith('NoSync_')) { continue; }

				// When updating from a version with prefs of same name but different type would throw an error and stop.
				// In this case, we need to clear it before we can set its default value again.
				var savedPrefType = defaultBranch.getPrefType(pref);
				var prefType = typeof(prefList[pref]);
				var compareType = '';
				switch(savedPrefType) {
					case defaultBranch.PREF_STRING:
						compareType = 'string';
						break;
					case defaultBranch.PREF_INT:
						compareType = 'number';
						break;
					case defaultBranch.PREF_BOOL:
						compareType = 'boolean';
						break;
					default: break;
				}
				if(compareType && prefType != compareType) {
					defaultBranch.clearUserPref(pref);
				}

				switch(prefType) {
					case 'string':
						defaultBranch.setCharPref(pref, prefList[pref]);
						break;
					case 'boolean':
						defaultBranch.setBoolPref(pref, prefList[pref]);
						break;
					case 'number':
						defaultBranch.setIntPref(pref, prefList[pref]);
						break;
					default:
						Cu.reportError('Preferece '+pref+' is of unrecognizeable type!');
						break;
				}

				if(trunk == 'extensions' && branch == objPathString && !prefList['NoSync_'+pref]) {
					syncBranch.setBoolPref(trunk+'.'+branch+'.'+pref, true);
				}
			}
		}

		// We do this separate from the process above because we would get errors sometimes:
		// setting a pref that has the same string name initially (e.g. "something" and "somethingElse"), it would trigger a change event for "something"
		// when set*Pref()'ing "somethingElse"
		for(let pref in prefList) {
			if(pref.startsWith('NoSync_')) { continue; }

			if(!this._prefObjects[pref]) {
				this._setPref(pref, branch, trunk);
			}
		}
	},

	_setPref: function(pref, branch, trunk) {
		this._prefObjects[pref] = {};
		this.length++;

		this._prefObjects[pref].listeners = new Set();
		this._prefObjects[pref].branch = Services.prefs.getBranch(((trunk) ? trunk+'.' : '') +branch+'.');
		this._prefObjects[pref].type = this._prefObjects[pref].branch.getPrefType(pref);

		switch(this._prefObjects[pref].type) {
			case Services.prefs.PREF_STRING:
				this._prefObjects[pref].__defineGetter__('value', function() { return this.branch.getCharPref(pref); });
				this._prefObjects[pref].__defineSetter__('value', function(v) { this.branch.setCharPref(pref, v); return this.value; });
				break;
			case Services.prefs.PREF_INT:
				this._prefObjects[pref].__defineGetter__('value', function() { return this.branch.getIntPref(pref); });
				this._prefObjects[pref].__defineSetter__('value', function(v) { this.branch.setIntPref(pref, v); return this.value; });
				break;
			case Services.prefs.PREF_BOOL:
				this._prefObjects[pref].__defineGetter__('value', function() { return this.branch.getBoolPref(pref); });
				this._prefObjects[pref].__defineSetter__('value', function(v) { this.branch.setBoolPref(pref, v); return this.value; });
				break;
		}

		this.__defineGetter__(pref, function() { return this._prefObjects[pref].value; });
		this.__defineSetter__(pref, function(v) { return this._prefObjects[pref].value = v; });

		this._prefObjects[pref].branch.addObserver(pref, this, false);
	},

	listen: function(pref, handler) {
		// failsafe
		if(typeof(this._prefObjects[pref]) == 'undefined') {
			Cu.reportError('Setting listener on unset preference: '+pref);
			return false;
		}

		if(!this.listening(pref, handler)) {
			this._prefObjects[pref].listeners.add(handler);
			return true;
		}
		return false;
	},

	unlisten: function(pref, handler) {
		// failsafe
		if(typeof(this._prefObjects[pref]) == 'undefined') {
			Cu.reportError('Setting listener on unset preference: '+pref);
			return false;
		}

		if(this.listening(pref, handler)) {
			this._prefObjects[pref].listeners.delete(handler);
			return true;
		}
		return false;
	},

	listening: function(pref, handler) {
		return this._prefObjects[pref].listeners.has(handler);
	},

	reset: function(pref) {
		this._prefObjects[pref].branch.clearUserPref(pref);
	},

	observe: function(aSubject, aTopic, aData) {
		let pref = aData;
		while(!this._prefObjects[pref]) {
			if(!pref.includes('.')) {
				Cu.reportError("Couldn't find listener handlers for preference "+aData);
				return;
			}
			pref = pref.substr(pref.indexOf('.')+1);
		}

		// in case we remove a listener and re-add it inside that same listener, it would be part of the iterable object as a new listener, creating an endless loop,
		// so we call only the listeners that were set at the time the change occurred
		var handlers = new Set();
		for(let handler of this._prefObjects[pref].listeners) {
			handlers.add(handler);
		}

		for(let handler of handlers) {
			// don't block executing of other possible listeners if one fails
			try {
				if(handler.observe) {
					handler.observe(pref, aTopic, this[pref]);
				} else {
					handler(pref, this[pref]);
				}
			}
			catch(ex) { Cu.reportError(ex); }
		}
	},

	clean: function() {
		for(let pref in this._prefObjects) {
			this._prefObjects[pref].branch.removeObserver(pref, this);
		}
	}
};

Modules.LOADMODULE = function() {
	if(prefList) {
		Prefs.setDefaults(prefList);
	}
};

Modules.UNLOADMODULE = function() {
	Prefs.clean();
};
