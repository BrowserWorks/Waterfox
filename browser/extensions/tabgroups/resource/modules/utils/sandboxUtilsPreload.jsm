// VERSION 1.0.7

// Prefs - Object to contain and manage all preferences related to the add-on (and others if necessary)
this.__defineGetter__('Prefs', function() { delete this.Prefs; Modules.load('utils/Prefs'); return Prefs; });

// Strings - use for getting strings out of bundles from .properties locale files
this.__defineGetter__('Strings', function() { delete this.Strings; Modules.load('utils/Strings'); return Strings; });

// Watchers - This acts as a replacement for the event DOM Attribute Modified, works for both attributes and object properties
this.__defineGetter__('Watchers', function() { delete this.Watchers; Modules.load('utils/Watchers'); return Watchers; });

// xmlHttpRequest() - aid for quickly using the nsIXMLHttpRequest interface
this.xmlHttpRequest = function(url, callback, method) { loadSandboxTools(); return xmlHttpRequest(url, callback, method); };

// aSync() - lets me run aFunc asynchronously
this.aSync = function(aFunc, aDelay) { loadSandboxTools(); return aSync(aFunc, aDelay); };

// dispatch() - creates and dispatches an event and returns (bool) whether preventDefault was called on it
this.dispatch = function(obj, properties) { loadSandboxTools(); return dispatch(obj, properties); };

// isAncestor() - Checks if aNode decends from aParent
this.isAncestor = function(aNode, aParent) { loadSandboxTools(); return isAncestor(aNode, aParent); };

// trim() - trims whitespaces from a string
this.trim = function(str) { loadSandboxTools(); return trim(str); };

// getComputedStyle() - returns the resulting object from calling the equivalent window.getComputedStyle() on it
this.getComputedStyle = function(aNode, pseudo) { loadSandboxTools(); return getComputedStyle(aNode, pseudo); };

// replaceObjStrings() - replace all objName and objPathString references in the node attributes and its children with the proper names
this.replaceObjStrings = function(node) { loadSandboxTools(); return replaceObjStrings(node); };

// setAttribute() - helper me that saves me the trouble of checking if the obj exists first everywhere in my scripts; yes I'm that lazy
this.setAttribute = function(obj, attr, val) { loadAttributesTools(); return setAttribute(obj, attr, val); };

// removeAttribute() - helper me that saves me the trouble of checking if the obj exists first everywhere in my scripts; yes I'm that lazy
this.removeAttribute = function(obj, attr) { loadAttributesTools(); return removeAttribute(obj, attr); };

// toggleAttribute() - sets attr on obj if condition is true; I'm uber lazy
this.toggleAttribute = function(obj, attr, condition, trueval, falseval) { loadAttributesTools(); return toggleAttribute(obj, attr, condition, trueval, falseval); };

// trueAttribute() - checks if attr on obj has value 'true'; once again, I'm uber lazy
this.trueAttribute = function(obj, attr) { loadAttributesTools(); return trueAttribute(obj, attr); };

// innerText() - returns the equivalent of IE's .innerText property of node; essentially returns .textContent without the script tags
this.innerText = function(node) { loadHTMLElementsTools(); return innerText(node); };

// Piggyback - This module allows me to Piggyback methods of any object. It also gives me access to the CustomizableUI module backstage pass, so I can do the same to it.
if(this.isChrome) {
	this.__defineGetter__('Piggyback', function() { delete this.Piggyback; delete this.CustomizableUI; delete this.CUIBackstage; Modules.load('utils/Piggyback'); return Piggyback; });
	this.__defineGetter__('CustomizableUI', function() { delete this.Piggyback; delete this.CustomizableUI; delete this.CUIBackstage; Modules.load('utils/Piggyback'); return CustomizableUI; });
	this.__defineGetter__('CUIBackstage', function() { delete this.Piggyback; delete this.CustomizableUI; delete this.CUIBackstage; Modules.load('utils/Piggyback'); return CUIBackstage; });
}
if(this.isContent) {
	this.__defineGetter__('Piggyback', function() { delete this.Piggyback; Modules.load('utils/Piggyback'); return Piggyback; });
}

this.loadSandboxTools = function() {
	delete this.xmlHttpRequest;
	delete this.aSync;
	delete this.dispatch;
	delete this.isAncestor;
	delete this.trim;
	delete this.replaceObjStrings;
	delete this.getComputedStyle;
	delete this.loadSandboxTools;
	Modules.load('utils/sandboxTools');
};

this.loadAttributesTools = function() {
	delete this.setAttribute;
	delete this.removeAttribute;
	delete this.toggleAttribute;
	delete this.trueAttribute;
	delete this.loadAttributesTools;
	Modules.load('utils/attributes');
};

this.loadHTMLElementsTools = function() {
	delete this.innerText;
	delete this.loadHTMLElementsTools;
	Modules.load('utils/HTMLElements');
};
