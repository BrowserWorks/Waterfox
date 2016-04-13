// VERSION 1.2.2
Modules.UTILS = true;
Modules.BASEUTILS = true;

// toCode - object that allows me to modify a function quickly from within my scripts, being able to revert afterwards and control for any errors in the process.
// USE WITH CAUTION! It's not 100% failsafe.
// Warning: At least for now it doesn't clean up after itself, I have to do this manually in each script unload.
// Warning: Don't modify twice the same method within the same add-on using more than one declaration to toCode.modify(), it doesn't check for repeated changed functions.
//	modify(aObj, aName, aArray) - modify the method with the changes included in aArray
//		aObj - (obj) object that contains the method to be changed
//		aName - (str) name of the method to be changed, including the objects name, in the form of "aObj.aMethod"
//		params - (array) [ [original, new] x n ], where new replaces original in the modified function
//	revert(aObj, aName) - reverts any changes made to aName in aObj by restoring a saved original. Controls for unforeseen errors and further changes to the method by other add-ons.
//		see modify()
// Note to self, by using the Function() method to create functions I'm priving them from their original context,
// that is, while inside a function created by that method in a module loaded by Modules I can't call 'subObj' (as in 'mainObj.subObj') by itself as I normally do,
// I have to either use 'mainObj.subObj' or 'this.subObj'; I try to avoid this as that is how I'm building my modularized add-ons, so I'm using eval, at least for now until I find a
// better way to implement this functionality.
// Note: try to hardcode everything in the strings to replace, as it's difficult to backtrace variables in them to ensure they are safe to use. This is a big issue for AMO reviewers
// who are not familiar with the code, so not even objName or objPathString!
// Don't forget that in bootstraped add-ons, these modified functions take the context of the modifier (sandboxed).
this.toCode = {
	_records: new Map(),

	modify: function(aObj, aName, params) {
		var fnName = aName.split(".").pop();
		if(!aObj || typeof(aObj[fnName]) != 'function') { return; }

		var methodCode = aObj[fnName].toString();
		var newRecord = {
			name: aName,
			original: aObj[fnName],
			oldCode: methodCode
		};

		for(let param of params) {
			if(!methodCode.includes(param[0])) {
				Cu.reportError('Could not find occurence of string '+param[0]+' in '+aName+'! Interrupting modification.');
				return;
			}
			methodCode = methodCode.replace(param[0], param[1].replace("{([objName])}", objName));
		}

		try {
			aObj[fnName] = eval("("+methodCode+")");
			newRecord.newCode = aObj[fnName].toString();
			this._records.set(aName, newRecord);
		}
		catch(ex) {
			Cu.reportError('Error modifying '+aName/*+' :: '+methodCode*/);
			Cu.reportError(ex);
		}
	},

	revert: function(aObj, aName) {
		var fnName = aName.split(".").pop();
		if(!aObj || typeof(aObj[fnName]) != 'function') { return; }

		if(!this._records.has(aName)) { return; }
		var record = this._records.get(aName);

		// Let's ensure no other add-on further changed this function in the meantime.
		// If it doesn't match we'll report to the error console, but for lack of a better alternative we'll still replace with our original.
		var newCode = aObj[fnName].toString();
		if(newCode != record.newCode) {
			Cu.reportError('Warning! Method '+aName+' has been further changed! Reverting to saved original.');
		}

		aObj[fnName] = record.original;
		this._records.delete(aName);
	}
};
