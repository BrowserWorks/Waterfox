// VERSION 1.2.1
Modules.UTILS = true;
Modules.BASEUTILS = true;

// innerText(node) - returns the equivalent of IE's .innerText property of node; essentially returns .textContent stripped of all the script tags
//	node - (xul element) to retrieve text content from
// This process is almost immediate (0-5ms) in normal smaller pages.
// https://bugzilla.mozilla.org/attachment.cgi?id=815787&action=diff, which is already a larger page, takes about 40-50ms.
// Isohunt results, which have a lot of frames, can be a little more than as above.
// Note: an alternative to this would be to crawl through all the childNodes of node and retrive text individually,
// but I found from my tests that this would be almost 50x slower, probably more if taking into account node visibility, which I didn't test for.
// Firefox 45 implements innerText at least, making this obsolete.
this.innerText = function(node) {
	try {
		if(!node || !node.ownerDocument || !(node instanceof node.ownerDocument.defaultView.HTMLElement)) {
			return '';
		}

		// Cloning directly on the same document often triggers new onStateChange events in the browser, which could create endless loops of processing.
		var clone = node.ownerDocument.implementation.createHTMLDocument('').importNode(node, true);
		if(clone.getElementsByTagName) {
			var heads = clone.getElementsByTagName('head');
			while(heads.length > 0) {
				heads[0].remove();
			}
			var scripts = clone.getElementsByTagName('script');
			while(scripts.length > 0) {
				scripts[0].remove();
			}
			var styles = clone.getElementsByTagName('style');
			while(styles.length > 0) {
				styles[0].remove();
			}
		}

		return clone.textContent;
	}
	catch(ex) {
		Cu.reportError(ex);
		return '';
	}
};
