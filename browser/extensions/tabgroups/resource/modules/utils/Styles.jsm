// VERSION 2.3.3
Modules.UTILS = true;
Modules.BASEUTILS = true;

// Styles - handle loading and unloading of stylesheets in a quick and easy way
// load(aName, aPath, isData, aType) - loads aPath css stylesheet with type AGENT_SHEET; if re-loading a stylesheet with the same name, it will only be re-loaded if aPath has changed
//	aName - (string) to name the stylesheet object in sheets[]
//	aPath -
//		(string) absolute chrome:// path to the stylesheet to be loaded
//		(string) name of the .css file to be loaded from chrome://objPathString/skin/aPath.css
//		(string) css declarations
//	(optional) isData -
//		true treats aPath as css declarations and appends "data:text/css," if necessary
//		defaults to false
//	(optional) aType -
//		(string) one of 'agent', 'user', or 'author'; or (int) one of Services.stylesheet.***_SHEET constants;
//		for details see https://developer.mozilla.org/en-US/docs/Mozilla/Tech/XPCOM/Reference/Interface/nsIStyleSheetService
//		defaults to Services.stylesheet.AUTHOR_SHEET, which is takes effect after the others in the CSS cascade
// unload(aName, aPath, isData) - unloads aPath css stylesheet
//	(optional) aPath
//	see load()
// loadIf(aName, aPath, isData, anIf, aType) - conditionally load or unload a stylesheet
//	anIf - true calls load(), false calls unload()
//	see load()
// loaded(aName, aPath) - returns (int) with corresponding sheet index in sheets[] if aName or aPath has been loaded, returns (bool) false otherwise
//	see unload()
this.Styles = {
	sheets: new Set(),

	load: function(aName, aPath, isData, aType) {
		var path = this.convert(aPath, isData);
		var type = this._switchType(aType);

		var sheet = this.loaded(aName, path);
		if(sheet) {
			if(sheet.name == aName) {
				if(sheet.path == path && sheet.type == type) {
					return false;
				}
				this.unload(aName);
			}
		}

		sheet = {
			name: aName,
			path: path,
			type: type,
			uri: Services.io.newURI(path, null, null)
		};
		this.sheets.add(sheet);

		if(!Services.stylesheet.sheetRegistered(sheet.uri, type)) {
			try { Services.stylesheet.loadAndRegisterSheet(sheet.uri, type); }
			catch(ex) { Cu.reportError(ex); }
		}
		return true;
	},

	unload: function(aName, aPath, isData) {
		if(typeof(aName) != 'string') {
			for(let x of aName) {
				this.unload(x);
			}
			return true;
		};

		var path = this.convert(aPath, isData);
		var sheet = this.loaded(aName, path);
		if(sheet) {
			this.sheets.delete(sheet);
			for(let other of this.sheets) {
				if(other.path == path && other.type == sheet.type) {
					return true;
				}
			}
			if(Services.stylesheet.sheetRegistered(sheet.uri, sheet.type)) {
				try { Services.stylesheet.unregisterSheet(sheet.uri, sheet.type); }
				catch(ex) { Cu.reportError(ex); }
			}
			return true;
		}
		return false;
	},

	loadIf: function(aName, aPath, isData, anIf, aType) {
		if(anIf) {
			this.load(aName, aPath, isData, aType);
		} else {
			this.unload(aName, aPath, isData);
		}
	},

	loaded: function(aName, aPath) {
		for(let sheet of this.sheets) {
			if(sheet.name == aName || (aPath && sheet.path == aPath)) {
				return sheet;
			}
		}
		return null;
	},

	convert: function(aPath, isData) {
		if(!aPath) {
			return aPath;
		}

		if(!isData && !aPath.startsWith("chrome://")) {
			return "chrome://"+objPathString+"/skin/"+aPath+".css";
		}

		if(isData && !aPath.startsWith("data:text/css,")) {
			let code = '/* CSS code appended by '+objPathString+':Styles.jsm */\n' + aPath;
			return 'data:text/css,' + encodeURIComponent(code);
		}

		return aPath;
	},

	_switchType: function(type) {
		switch(type) {
			case 'agent':
			case Services.stylesheet.AGENT_SHEET:
				return Services.stylesheet.AGENT_SHEET;
				break;
			case 'user':
			case Services.stylesheet.USER_SHEET:
				return Services.stylesheet.USER_SHEET;
				break;
			case 'author':
			case Services.stylesheet.AUTHOR_SHEET:
			default:
				return Services.stylesheet.AUTHOR_SHEET;
				break;
		}

		return false;
	}
};
