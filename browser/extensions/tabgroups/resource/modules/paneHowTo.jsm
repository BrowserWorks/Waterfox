// VERSION 1.0.0

Modules.LOADMODULE = function() {
	let fulltext = $('paneHowTo-credits-body');
	let exploded = fulltext.textContent.split('support.mozilla.org');
	if(exploded.length == 2) {
		let first = document.createTextNode(exploded[0]);
		let second = document.createTextNode(exploded[1]);
		let link = document.createElementNS('http://www.w3.org/1999/xhtml', 'a');
		setAttribute(link, 'target', '_blank');
		setAttribute(link, 'href', 'https://support.mozilla.org/kb/tab-groups-organize-tabs');
		link.textContent = 'support.mozilla.org';

		fulltext.firstChild.remove();
		fulltext.appendChild(first);
		fulltext.appendChild(link);
		fulltext.appendChild(second);
	}
};
