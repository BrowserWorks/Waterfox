// VERSION 1.2.3
Modules.UTILS = true;
Modules.BASEUTILS = true;

// There are a few things in CUI that need to be overriden, e.g. the toolbars would register before they were appended to the DOM tree, which is really bad...
// Piggyback -	This module allows me to Piggyback methods of any object. It also gives me access to the CustomizableUI module backstage pass, so I can do the same to it.
// 		Don't use this in method.prototype, it apparently doesn't work, although I can't figure out the exact reason why.
//		See https://github.com/Quicksaver/The-Fox--Only-Better/issues/83
// add(aName, aObj, aMethod, aWith, aMode) - Modify aMethod within aObj with another aWith. The original aObj.aMethod will be available as aObj._aMethod.
//	aName - (string) just a name for this operation, usually the name of the module will suffice
//	aObj - (obj) which we want to alter
//	aMethod - (string) name of the method that we want to Piggyback
//	aWith - (function) the function to modify with
//	(optional) aMode - (const) one of the following;
//			MODE_REPLACE:	will completely replace aMethod in aObj. This will only be done once globally, so take care that this is done in all occasions with this mode!
//					If you want to alter the arguments before they reach the original method, this is the only way to do it.
//					Also needs to be used if the method is to return a specific value.
//					Default mode.
//			MODE_BEFORE: aMethod will run before the original, and if it returns non-true, it will not follow through to the original
//			MODE_AFTER: aMethod will run after the original
//	(dont set) aKeep - for internal use only for the CustomizableUIInternal special case, don't set this
// revert(aName, aObj, aMethod) - reverts a Piggyback done previously
//	see add()

this.Piggyback = {
	_obj: '_Piggyback_',
	MODE_REPLACE: 0,
	MODE_BEFORE: 1,
	MODE_AFTER: 2,

	add: function(aName, aObj, aMethod, aWith, aMode, aKeep) {
		if(!aMode) { aMode = this.MODE_REPLACE; }
		var aMaster = objName;

		if(aKeep) {
			aMaster = aKeep.master;

			// carrying over from a CUIInternal destruction, this will never be active even if it was before
			aKeep.active = false;
		}

		var aId = '_Piggyback_'+aMaster;
		var ids = aObj.__PiggybackIds ? aObj.__PiggybackIds.split(' ') : [];

		// the same method can't be replaced more than once by the same aName (module)
		if(aObj[aId] && aObj[aId][aName] && aObj[aId][aName][aMethod]) { return; }

		var commander = aKeep || {
			master: aMaster,
			method: aWith,
			mode: aMode,
			active: false
		};

		if(!aObj[aId]) {
			if(ids.indexOf(aMaster) == -1) {
				ids.push(aMaster);
				aObj.__PiggybackIds = ids.join(' ');
			}
			aObj[aId] = new Map();
		}
		if(!aObj[aId].has(aName)) {
			aObj[aId].set(aName, new Map());
		}

		aObj[aId].get(aName).set(aMethod, commander)

		// if we're not replacing the method, we create our Piggybacker that will call the method before/after the original method
		if(aMode != this.MODE_REPLACE && !aKeep) {
			commander.Piggybacker = function() {
				// it's not like I can use a not-live reference to this, and I also can't use an array directly or it'll leave a ZC
				var ex = aObj.__PiggybackIds.split(' ');

				for(let id of ex) {
					for(let bName of aObj['_Piggyback_'+id].values()) {
						let bMethod = bName.get(aMethod);
						if(bMethod && bMethod.mode == Piggyback.MODE_BEFORE) {
							if(!bMethod.method.apply(aObj, arguments)) { return; }
						}
					}
				}

				aObj['_'+aMethod].apply(aObj, arguments);

				for(let id of ex) {
					for(let bName of aObj['_Piggyback_'+id].values()) {
						let bMethod = bName.get(aMethod);
						if(bMethod && bMethod.mode == Piggyback.MODE_AFTER) {
							bMethod.method.apply(aObj, arguments);
						}
					}
				}
			};
		}

		// if another add-on already piggybacked this method, we don't re-piggyback it; the custom method is already added to the maps above,
		// so it will still be called by that add-on's commander method (if MODE_BEFORE or MODE_AFTER is used)
		for(let id of ids) {
			for(let bName of aObj['_Piggyback_'+id].values()) {
				if(bName.has(aMethod) && bName.get(aMethod).active) { return false; }
			}
		}

		aObj['_'+aMethod] = aObj[aMethod];
		aObj[aMethod] = (aMode == this.MODE_REPLACE) ? commander.method : commander.Piggybacker;
		commander.active = true;
		return true;
	},

	revert: function(aName, aObj, aMethod) {
		var aId = this._obj;
		var ids = aObj.__PiggybackIds ? aObj.__PiggybackIds.split(' ') : [];

		if(!aObj[aId] || !aObj[aId].has(aName) || !aObj[aId].get(aName).has(aMethod)) { return false; }

		// is this method the one that had the active commander?
		// If it is, we'll need to remember this to remove the commander and re-apply another commander later if necessary
		var active = aObj[aId].get(aName).get(aMethod).active;

		aObj[aId].get(aName).delete(aMethod);

		if(aObj[aId].get(aName).size == 0) {
			aObj[aId].delete(aName);

			if(aObj[aId].size == 0) {
				delete aObj[aId];
				ids.splice(ids.indexOf(objName), 1);

				if(ids.length > 0) {
					aObj.__PiggybackIds = ids.join(' ');
				} else {
					delete aObj.__PiggybackIds;
				}
			}
		}

		if(active) {
			aObj[aMethod] = aObj['_'+aMethod];
			delete aObj['_'+aMethod];

			// if another add-on or module wants to modify the same method, let it now
			id_loop: for(let id of ids) {
				for(let bName of aObj['_Piggyback_'+id].values()) {
					let bMethod = bName.get(aMethod);
					if(bMethod && !bMethod.active) {
						aObj['_'+aMethod] = aObj[aMethod];
						aObj[aMethod] = (bMethod.mode == this.MODE_REPLACE) ? bMethod.method : bMethod.Piggybacker;
						bMethod.active = true;
						break id_loop;
					}
				}
			}
		}
	}
};

Modules.LOADMODULE = function() {
	// needs to be defined here, because in content processes it wouldn't find objName (inside the same object, loaded directly, would need "this")
	Piggyback._obj += objName;

	if(self.isContent) { return; }

	// CustomizableUI is a special case, as CustomizableUIInternal is frozen and not exported
	self.CUIBackstage = Cu.import("resource:///modules/CustomizableUI.jsm", self);
	CUIBackstage[Piggyback._obj] = {
		replaceInternal: function(objs) {
			if(!CUIBackstage.__CustomizableUIInternal) {
				CUIBackstage.__CustomizableUIInternal = CUIBackstage.CustomizableUIInternal;

				var CUIInternalNew = {};
				for(var p in CUIBackstage.CustomizableUIInternal) {
					if(CUIBackstage.CustomizableUIInternal.hasOwnProperty(p)) {
						var propGetter = CUIBackstage.CustomizableUIInternal.__lookupGetter__(p);
						if(propGetter) {
							CUIInternalNew.__defineGetter__(p, propGetter.bind(CUIBackstage.__CustomizableUIInternal));
						} else {
							CUIInternalNew[p] = CUIBackstage.CustomizableUIInternal[p].bind(CUIBackstage.__CustomizableUIInternal);
						}
					}
				}
				CUIBackstage.CustomizableUIInternal = CUIInternalNew;
				CUIBackstage[Piggyback._obj].active = true;

				// we have to make sure any other modifications from other add-ons stay in place if we're re-replacing CUIInternal
				if(objs) {
					for(var id in objs) {
						for(var [aName, bName] of objs[id]) {
							for(var [aMethod, bMethod] of bName) {
								Piggyback.add(aName, CUIBackstage.CustomizableUIInternal, aMethod, bMethod.method, bMethod.mode, bMethod);
							}
						}
					}
				}
			}
		},
		active: false
	};

	CUIBackstage[Piggyback._obj].replaceInternal();

	if(!CUIBackstage.__PiggybackIds) {
		CUIBackstage.__PiggybackIds = objName;
	} else if(CUIBackstage.__PiggybackIds.indexOf(objName) == -1) { // should always be the case if it doesn't exist
		var ex = CUIBackstage.__PiggybackIds.split(' ');
		ex.push(objName);
		CUIBackstage.__PiggybackIds = ex.join(' ');
	}
};

Modules.UNLOADMODULE = function() {
	if(self.isContent) { return; }

	var ids = CUIBackstage.__PiggybackIds ? CUIBackstage.__PiggybackIds.split(' ') : [];

	// we really need to put everything back as it was!
	if(ids.indexOf(objName) > -1) {
		var active = CUIBackstage[Piggyback._obj].active;

		delete CUIBackstage[Piggyback._obj];
		ids.splice(ids.indexOf(objName), 1);
		if(ids.length > 0) {
			CUIBackstage.__PiggybackIds = ids.join(' ');
		} else {
			delete CUIBackstage.__PiggybackIds;
		}

		var internalObjs = null;
		if(active) {
			// we have to make sure any other modifications from other add-ons stay in place
			if(CUIBackstage.CustomizableUIInternal.__PiggybackIds) {
				var internalIds = CUIBackstage.CustomizableUIInternal.__PiggybackIds.split(' ');
				internalObjs = {};
				for(var id of internalIds) {
					internalObjs[id] = CUIBackstage.CustomizableUIInternal['_Piggyback_'+id];
				}
			}

			CUIBackstage.CustomizableUIInternal = CUIBackstage.__CustomizableUIInternal;
			delete CUIBackstage.__CustomizableUIInternal;

			// if another add-on is still initialized, make sure it redoes this
			for(var id of ids) {
				CUIBackstage['_Piggyback_'+id].replaceInternal(internalObjs);
			}
		}
	}
};
