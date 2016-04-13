// VERSION 2.7.5
Modules.UTILS = true;
Modules.BASEUTILS = true;

// xmlHttpRequest(url, callback, method) - aid for quickly using the nsIXMLHttpRequest interface
//	url - (string) to send the request
//	callback - (function) to be called after request is completed; expects callback(xmlhttp, e) where xmlhttp = xmlhttprequest return object and e = event object
//	(optional) method -	either (string) "POST" or (string) "GET"; defaults to "GET";
//				can also be (string) "JSON", for XHR operations that fetch a JSON object, so the result should be parsed accordingly,
//				in which case the method used is "GET" as well.
this.xmlHttpRequest = function(url, callback, method = "GET") {
	var json = false;
	if(method == "JSON") {
		json = true;
		method = "GET";
	}

	var xmlhttp = Cc["@mozilla.org/xmlextras/xmlhttprequest;1"].createInstance(Ci.nsIXMLHttpRequest);
	xmlhttp.open(method, url);
	if(json) {
		xmlhttp.overrideMimeType("application/json");
		xmlhttp.responseType = 'json';
	}
	xmlhttp.onreadystatechange = function(e) { callback(xmlhttp, e); };
	xmlhttp.send();
	return xmlhttp;
};

// aSync(aFunc, aDelay) - lets me run aFunc asynchronously, basically it's a one shot timer with a delay of aDelay msec
//	aFunc - (function) to be called asynchronously
//	(optional) aDelay - (int) msec to set the timer, defaults to 0msec
this.aSync = function(aFunc, aDelay) {
	var newTimer = {
		timer: Cc["@mozilla.org/timer;1"].createInstance(Ci.nsITimer),
		handler: aFunc,
		cancel: function() {
			this.timer.cancel();
		}
	};
	newTimer.timer.init(newTimer.handler, (!aDelay) ? 0 : aDelay, Ci.nsITimer.TYPE_ONE_SHOT);
	return newTimer;
};

// dispatch(obj, properties) - creates and dispatches an event and returns (bool) whether preventDefault was not called on it
//	aNode - (xul element) object to dispatch the event from, it will be e.target
//	props - (obj) expecting the following sub properties defining the following event characteristics:
//		type - (str) the event type
//		(optional) bubbles - (bool) defaults to true
//		(optional) cancelable - (bool) defaults to true
//		(optional) detail - to be passed to the event
//		(optional) asking - (bool) if true, will return the .detail property of the event, which can be modified by listeners; defaults to false, .detail defaults to undefined
this.dispatch = function(aNode, props) {
	if(!aNode || !aNode.dispatchEvent
	|| (!aNode.ownerDocument && !aNode.document && (!aNode.content || !aNode.content.document))
	|| !props || !props.type) { return false; }

	var bubbles = props.bubbles || true;
	var cancelable = props.cancelable || !props.asking;
	var detail = props.detail || undefined;

	var doc = (aNode.ownerDocument) ? aNode.ownerDocument : (aNode.document) ? aNode.document : aNode.content.document; // last one's for content processes
	var event = doc.createEvent('CustomEvent');

	if(props.asking) {
		event.__defineGetter__('detail', function() { return detail; });
		event.__defineSetter__('detail', function(v) { return detail = v; });
	}

	event.initCustomEvent(props.type, bubbles, cancelable, detail);
	var ret = aNode.dispatchEvent(event);
	return (props.asking) ? detail : ret;
};

// isAncestor(aNode, aParent) - Checks if aNode decends from aParent
//	aNode - (xul element) node to check for ancestry
//	aParent - (xul element) node to check if ancestor of aNode
//	(dont set) aWindow - to be used internally by isAncestor()
this.isAncestor = function(aNode, aParent, aWindow) {
	if(!aNode || !aParent) { return false; };

	if(aNode == aParent) { return true; }

	let ownDocument = aNode.ownerDocument || aNode.document;
	if(ownDocument && ownDocument == aParent) { return true; }
	if(aNode.compareDocumentPosition && (aNode.compareDocumentPosition(aParent) & aNode.DOCUMENT_POSITION_CONTAINS)) { return true; }

	if(aParent.nodeType == aParent.ELEMENT_NODE) {
		let browserNodes = (aParent.tagName == 'browser') ? [aParent] : aParent.getElementsByTagName('browser');
		for(let browser of browserNodes) {
			try { if(!browser.isRemoteBrowser && isAncestor(aNode, browser.contentDocument, browser.contentWindow)) { return true; } }
			catch(ex) { /* this will fail in e10s if comparing a node from a non-remote document to a remote parent, which means we don't care either way */ }
		}
	}

	if(!aWindow) { return false; }
	for(var frame of aWindow.frames) {
		if(isAncestor(aNode, frame.document, frame)) { return true; }
	}
	return false;
};

// trim(str) - trims whitespaces from a string (found in http://blog.stevenlevithan.com/archives/faster-trim-javascript -> trim3())
//	str - (string) to trim
this.trim = function(str) {
	if(typeof(str) != 'string') {
		return '';
	}

	return str.substring(Math.max(str.search(/\S/), 0), str.search(/\S\s*$/) + 1);
};

// replaceObjStrings(node, prop) - replace all objName and objPathString references in the node attributes and its children with the proper names
//	node - (xul element) to replace the strings in
//	(optional) prop -	(string) if specified, instead of checking attributes, it will check for node.prop for occurences of what needs to be replaced.
//				When specified, this method is not recursive, it will not check child nodes!
this.replaceObjStrings = function(node, prop) {
	if(!node) { return; }

	if(prop) {
		if(!node[prop]) { return; }

		while(node[prop].includes('objName')) {
			node[prop] = node[prop].replace('objName', objName);
		}
		while(node[prop].includes('objPathString')) {
			node[prop] = node[prop].replace('objPathString', objPathString);
		}

		return;
	}

	if(node.attributes) {
		for(let attr of node.attributes) {
			while(attr.value.includes('objName')) {
				attr.value = attr.value.replace('objName', objName);
			}
			while(attr.value.includes('objPathString')) {
				attr.value = attr.value.replace('objPathString', objPathString);
			}
		}
	}

	var curChild = node.firstChild;
	while(curChild) {
		replaceObjStrings(curChild);
		curChild = curChild.nextSibling;
	}
};

// getComputedStyle(aNode, pseudo) - returns the resulting object from calling the equivalent window.getComputedStyle() on it
//	aNode - (element) of which to return the computed style object
//	(optional) pseudo -(string) specifying the pseudo-element to match, see https://developer.mozilla.org/en-US/docs/Web/API/Window.getComputedStyle
this.getComputedStyle = function(aNode, pseudo) {
	return aNode.ownerDocument.defaultView.getComputedStyle(aNode, pseudo);
};
