// VERSION 2.7.1

// Many times I can't use 'this' to refer to the owning var's context, so I'm setting 'this' as 'self',
// I can use 'self' from within functions, timers and listeners easily and to bind those functions to it as well
this.self = this;

// Modules - Helper to load subscripts into the context of "this"
// load(aModule, delayed) - loads aModule onto the context of self
//	aModule - (string) can be either module name which loads resource://objPathString/modules/aModule.jsm or full module path
//	(optional) delayed -	true loads module 250ms later in an asychronous process, false loads immediatelly synchronously, defaults to false
//				if instead, a gBrowserInit object is provided, the module load will wait until the window's delayed load notification, or load immediately if that's
//				already happened.
// unload(aModule) - unloads aModule from the context of self
//	see load()
// loadIf(aModule, anIf, delayed) - conditionally load or unload aModule
//	anIf - true calls load(aModule, delayed), false calls unload(aModule)
//	see load()
// loaded(aModule) - returns (int) with corresponding module index in modules[] if aModule has been loaded, returns (bool) false otherwise
//	see load()
// subscript modules are run in the context of self, all objects should be set using this.whateverObject so they can be deleted on unload, Modules optionally expects these:
//	Modules.LOADMODULE - (function) to be executed on module loading
//	Modules.UNLOADMODULE - (function) to be executed on module unloading
//	Modules.UTILS - (bool) vital modules that should be the last ones to be unloaded (like the utils) should have this set to true; should only be used in backbone modules
//	Modules.BASEUTILS - 	(bool) some modules may depend on others even on unload, this should be set on modules that don't depend on any others,
//				so that they only unload on the very end; like above, should only be used in backbone modules
//	Modules.CLEAN - (bool) if false, this module won't be removed by clean(); defaults to true
this.Modules = {
	modules: new Set(),
	moduleVars: {},

	loadIf: function(aModule, anIf, delayed) {
		if(anIf) {
			return this.load(aModule, delayed);
		}
		return !this.unload(aModule);
	},

	load: function(aModule, delayed) {
		// Because of process separation in e10s, the resource:// path can be removed before modules are fully unloaded from the child process,
		// if their unload methods call for modules that had't been loaded, they won't be able to be loaded now.
		// Just enclosing problematic routines in a try-catch block isn't enough, as apparently the IO thread somehow throws aSync,
		// causing the messages to appear in the console anyway. They may be harmless but they're also confusing when debugging, so let's avoid them.
		if(self.isContent && self.disabled) { return false; }

		let path = this.preparePath(aModule);
		if(!path) { return false; }

		if(this.loaded(path)) { return true; }

		try { Services.scriptloader.loadSubScript(path, self); }
		catch(ex) {
			Cu.reportError(ex);
			return false;
		}

		let module = {
			name: aModule,
			path: path,
			load: this.LOADMODULE || null,
			unload: this.UNLOADMODULE || null,
			utils: this.UTILS || false,
			baseutils: this.BASEUTILS || false,
			clean: (this.CLEAN !== undefined) ? this.CLEAN : true,
			loaded: false,
			failed: false
		};
		this.modules.add(module);

		delete this.VARSLIST;
		delete this.LOADMODULE;
		delete this.UNLOADMODULE;
		delete this.UTILS;
		delete this.BASEUTILS;
		delete this.CLEAN;

		if(!Globals.moduleCache[aModule]) {
			let tempScope = {
				Modules: {},
				$: function() { return null; },
				$$: function() { return null; },
				$ª: function() { return null; }
			};
			try { Services.scriptloader.loadSubScript(path, tempScope); }
			catch(ex) {
				Cu.reportError(ex);
				return false;
			}
			delete tempScope.Modules;
			delete tempScope.$;
			delete tempScope.$$;
			delete tempScope.$ª;

			Globals.moduleCache[aModule] = [];
			for(let v in tempScope) {
				Globals.moduleCache[aModule].push(v);
			}
		}
		module.vars = Globals.moduleCache[aModule];

		try { this.createVars(module.vars); }
		catch(ex) {
			Cu.reportError(ex);
			this.unload(aModule, true, true);
			return false;
		}

		if(module.load) {
			if(!delayed || delayed.delayedStartupFinished) {
				try { module.load(); }
				catch(ex) {
					Cu.reportError(ex);
					this.unload(aModule, true);
					return false;
				}
				module.loaded = true;
			}
			else {
				module.aSync = () => {
					// when disabling the add-on before it's had time to perform the load call
					if(typeof(Modules) == 'undefined') { return; }

					try { module.load(); }
					catch(ex) {
						Cu.reportError(ex);
						this.unload(aModule, true);
						return;
					}
					module.loaded = true;
				};

				// if we're delaying a load in a browser window, we should wait for it to finish the initial painting
				if(typeof(delayed) == 'object' && "delayedStartupFinished" in delayed) {
					module.observe = function(aSubject, aTopic) {
						if(aSubject.gBrowserInit == delayed) {
							Observers.remove(this, 'browser-delayed-startup-finished');
							this.aSync();
						}
					};

					Observers.add(module, 'browser-delayed-startup-finished');
				} else {
					module._aSync = aSync(module.aSync, 250);
				}
			}
		}
		else {
			module.loaded = true;
		}

		return true;
	},

	unload: function(aModule, force, justVars) {
		let path = this.preparePath(aModule);
		if(!path) { return true; }

		let module = this.loaded(aModule);
		if(!module) { return true; }

		if(!justVars && module.unload && (module.loaded || force)) {
			try { module.unload(); }
			catch(ex) {
				if(!force) {
					Cu.reportError(ex);
				} else {
					Cu.reportError('Failed to load module '+aModule);
				}
				module.failed = true;
				return false;
			}
		}

		try { this.deleteVars(module.vars); }
		catch(ex) {
			if(!force) {
				Cu.reportError(ex);
			} else {
				Cu.reportError('Failed to load module '+aModule);
			}
			module.failed = true;
			return false;
		}

		this.modules.delete(module);
		return true;
	},

	clean: function() {
		// We can't unload modules in i++ mode for two reasons:
		// One: dependencies, some modules require others to run, so by unloading in the inverse order they were loaded we are assuring dependencies are maintained
		// Two: creates endless loops when unloading a module failed, it would just keep trying to unload that module
		// We also need to unload main modules before utils modules. Other dependencies should resolve themselves in the order the modules are (un)loaded.
		var utils = false;
		var baseutils = false;
		var done = false;

		while(!done) {
			var toUnload = [];
			for(let module of this.modules) {
				if(module.clean
				&& module.utils == utils
				&& module.baseutils == baseutils) {
					toUnload.push(module);
				}
			}

			for(var i = toUnload.length -1; i >= 0; i--) {
				this.unload(toUnload[i].name);
			}

			if(!utils) { utils = true; }
			else if(!baseutils) { baseutils = true; }
			else { done = true; }
		}
	},

	loaded: function(aModule) {
		for(let module of this.modules) {
			if(module.path == aModule || module.name == aModule) {
				return module;
			}
		}
		return null;
	},

	createVars: function(aList) {
		if(!Array.isArray(aList)) { return; }

		for(let x of aList) {
			if(this.moduleVars[x]) {
				this.moduleVars[x]++;
			} else {
				this.moduleVars[x] = 1;
			}
		}
	},

	deleteVars: function(aList) {
		if(!Array.isArray(aList)) { return; }

		for(let x of aList) {
			if(this.moduleVars[x]) {
				this.moduleVars[x]--;
				if(!this.moduleVars[x]) {
					delete self[x];
					delete this.moduleVars[x];
				}
			}
		}
	},

	preparePath: function(aModule) {
		if(typeof(aModule) != 'string') { return null; }
		if(aModule.startsWith("resource://")) { return aModule; }
		return "resource://"+objPathString+"/modules/"+aModule+".jsm";
	}
};

Globals.moduleCache = {};
