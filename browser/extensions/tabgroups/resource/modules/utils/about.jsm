// VERSION 1.1.4

this.about = {
	kNS: 'http://www.w3.org/1999/xhtml',

	_gNotifyOnUpdates: null,
	get gNotifyOnUpdates() {
		if(!this._gNotifyOnUpdates) {
			this._gNotifyOnUpdates = $('notifyOnUpdates');
		}
		return this._gNotifyOnUpdates;
	},

	_gShowTabOnUpdates: null,
	get gShowTabOnUpdates() {
		if(!this._gShowTabOnUpdates) {
			this._gShowTabOnUpdates = $('showTabOnUpdates');
		}
		return this._gShowTabOnUpdates;
	},

	changelog: null,

	handleEvent: function(e) {
		// are we mousing over the Show On Updates checkbox? That requires a specific action
		if(e.target == this.gShowTabOnUpdates) {
			this.disableNoticeShowOnUpdates();
		}

		// only do this for links and checkboxes
		if(e.target.nodeName != 'a' && e.target.nodeName != 'html:a' && e.target.nodeName != 'checkbox') { return; }

		if(e.target == document.activeElement) {
			document.activeElement.blur();
		}
	},

	observe: function(aSubject, aTopic, aData) {
		// we only listen for changes to the showTabOnUpdates preference here
		this.disableNoticeShowOnUpdates();
	},

	init: function() {
		// place the current version in the page
		$('currentVersion').textContent = $('currentVersion').textContent.replace('{v}', AddonData.version);
		removeAttribute($('version'), 'invisible');

		// fill in the links with data from the add-on; these come directly from defaults.js (overriden from the declared vars in bootstrap.js)
		setAttribute($('paneAbout-homepage'), 'href', addonUris.homepage);
		setAttribute($('paneAbout-support'), 'href', addonUris.support);
		setAttribute($('paneAbout-fullchangelog'), 'href', addonUris.fullchangelog);
		setAttribute($('paneAbout-email'), 'href', addonUris.email);
		setAttribute($('paneAbout-profile'), 'href', addonUris.profile);
		setAttribute($('paneAbout-development'), 'href', addonUris.development);

		// blink the "Show on updates" checkbox if necessary, so the user can easily notice it and disable them if he doesn't want them
		this.noticeShowOnUpdates();

		// check to see if there is a more recent version available
		this.checkUpdates();

		// need to get the changelog in order to populate the list of changes
		xmlHttpRequest('resource://'+objPathString+'/changelog.json', (xmlhttp) => {
			if(xmlhttp.readyState == 4 && xmlhttp.response) {
				this.changelog = xmlhttp.response;

				this.fillChangeLog(PrefPanes.previousVersion);
				PrefPanes.previousVersion = null;
			}
		}, 'JSON');

		// init AddToAny stuff (share buttons)
		this.shareLinks();

		// fetch the development hours data and show it
		this.api();

		// these are so we can click html links in a xul window without their outline becoming permanent (until clicking another link)
		Listeners.add(window, 'mouseup', this);
		Listeners.add(window, 'mouseover', this, true);
	},

	uninit: function() {
		Listeners.remove(window, 'mouseup', this);
		Listeners.remove(window, 'mouseover', this, true);
	},

	checkUpdates: function() {
		Addon.findUpdates({
			onUpdateAvailable: function() {
				$('needsupdate').hidden = false;
			},
			onNoUpdateAvailable: function() {
				$('uptodate').hidden = false;
			}
		}, AddonManager.UPDATE_WHEN_PERIODIC_UPDATE);
	},

	// this fills the notes section of the page
	fillChangeLog: function(version) {
		if(!this.changelog.current) { return; }

		// show the all versions link by default
		$('allVersions').hidden = false;

		if(!version) {
			version = this.changelog.current;
		}

		var notes = $('notes');

		// clean up that section before we add everything to it
		while(notes.firstChild) {
			notes.firstChild.remove();
		}

		for(let release in this.changelog.releases) {
			if(Services.vc.compare(release, version) > 0 || (!PrefPanes.previousVersion && Services.vc.compare(release, version) == 0)) {
				let section = document.createElementNS(this.kNS, 'section');
				section.id = release;
				section.classList.add('notes');

				let h3 = document.createElementNS(this.kNS, 'h3');
				h3.textContent = 'Version '+release+' - Release Notes';
				section.appendChild(h3);

				let h4 = document.createElementNS(this.kNS, 'h4');
				h4.textContent = 'Released '+this.changelog.releases[release].date;
				section.appendChild(h4);

				let ul = document.createElementNS(this.kNS, 'ul');
				ul.classList.add('notes-items');
				section.appendChild(ul);

				for(let note of this.changelog.releases[release].notes) {
					this.appendLogEntry(ul, note[1], note[0]);
				}

				let sibling = notes.firstChild;
				while(sibling && (sibling.id == 'knownissues' || Services.vc.compare(release, sibling.id) < 0)) {
					sibling = sibling.nextSibling;
				}
				notes.insertBefore(section, sibling);

				// if we're printing the current release, also print the known issues if there are any
				if(release == this.changelog.current && this.changelog.knownissues) {
					let section = document.createElementNS(this.kNS, 'section');
					section.id = 'knownissues';
					section.classList.add('notes');

					let h3 = document.createElementNS(this.kNS, 'h3');
					h3.textContent = 'Known Issues';
					section.appendChild(h3);

					let ul = document.createElementNS(this.kNS, 'ul');
					ul.classList.add('notes-items');
					section.appendChild(ul);

					for(let issue of this.changelog.knownissues) {
						this.appendLogEntry(ul, issue[0], 'unresolved');
					}

					notes.insertBefore(section, sibling);
				}
			}
		}

		// if we're printing all the releases, hide the button to show them as it won't be needed anymore
		if(Services.vc.compare(version, '0') == 0) {
			$('allVersions').hidden = true;
		}
	},

	appendLogEntry: function(ul, string, category) {
		let li = document.createElementNS(this.kNS, 'li');

		if(category) {
			let b = document.createElementNS(this.kNS, 'b');
			b.classList.add(category);
			b.textContent = category;
			li.appendChild(b);
			li.classList.add('tagged');
		}

		let p = document.createElementNS(this.kNS, 'p');
		p.textContent = string;
		this.parseTextMarkup(p.firstChild);

		li.appendChild(p);
		ul.appendChild(li);
	},

	// there's no need to keep assigning these on each parseTextMarkup call
	markupExp: /<(b|a=([^<]*)?)?>/,
	markupAExp: /<\/a>/,
	markupBExp: /<\/b>/,

	parseTextMarkup: function(textNode) {
		// textNode should always be a #text element
		while(textNode) {
			// if there's no valid beginning markup tag, bail out already
			if(!this.markupExp.test(textNode.textContent)) { break; }

			let matchBegin = this.markupExp.exec(textNode.textContent);
			let markup = matchBegin[1][0]; // first character == tag name

			// we always split the #text nodes here, even if we end up not actually creating any sub nodes (i.e. no valid closing tag),
			// it's just easier to continue processing the rest this way
			let tempTextNode = textNode.splitText(matchBegin.index);

			// unless our regexps fail, we should always have a valid expression for finding the closing node
			let endExp;
			switch(markup) {
				case 'a':
					endExp = this.markupAExp;
					break;

				case 'b':
					endExp = this.markupBExp;
					break;
			}

			// there's no valid closing tag, so continue processing the rest of the text for any other opening tags
			if(!endExp.test(tempTextNode.textContent)) {
				textNode = tempTextNode;
				continue;
			}

			let matchEnd = endExp.exec(tempTextNode.textContent);
			let endTextNode = tempTextNode.splitText(matchEnd.index +matchEnd[0].length);

			let addNode;
			switch(markup) {
				case 'a':
					addNode = document.createElementNS(this.kNS, 'a');
					setAttribute(addNode, 'target', '_blank');
					setAttribute(addNode, 'href', matchBegin[2]);
					break;

				case 'b':
					addNode = document.createElementNS(this.kNS, 'span');
					addNode.style.fontWeight = 'bold';
					break;
			}

			addNode.textContent = tempTextNode.textContent.substring(matchBegin[0].length, matchEnd.index);
			tempTextNode.parentNode.replaceChild(addNode, tempTextNode);

			// process the just added node for any nested tags
			this.parseTextMarkup(addNode.firstChild);

			// continue processing the rest of the text for more markup tags
			textNode = endTextNode;
		}
	},

	// Since I can't use a local iframe to load remote content, I have to include and build the buttons myself.
	// Build the buttons href's with the link to the add-on and the phrase to be used as default when sharing.
	// These values are defined in defaults.js (overriding the empty originals in bootstrap.js)
	shareLinks: function() {
		if(!addonUris.homepage) { return; }
		$('share').hidden = false;

		let linkurl = encodeURIComponent(addonUris.homepage);
		let linkname = encodeURIComponent($('share-links').getAttribute('linkname'));

		let as = $$('.share-link');
		for(let a of as) {
			let href = a.getAttribute('href');
			switch(a.title) {
				case 'Facebook':
					href += '?u='+linkurl;
					break;

				case 'Twitter':
					href += '?text='+linkname+'%20'+linkurl;
					break;

				case 'Google+':
					href += '?url='+linkurl;
					break;
			}
			setAttribute(a, 'href', href);
		}
	},

	api: function() {
		if(!addonUris.api) { return; }

		xmlHttpRequest(addonUris.api, function(xmlhttp) {
			if(xmlhttp.readyState != 4 || xmlhttp.status != 200 || !xmlhttp.response || !xmlhttp.response.id) { return; }

			var bank = $('bank');
			removeAttribute(bank, 'invisible');

			var hours = xmlhttp.response.hours;
			if(hours < 0) {
				bank.classList.add('negative');
				bank.classList.add('owed');
				bank.classList.remove('positive');
				bank.classList.remove('banked');
				hours = Math.abs(hours);
			}
			else {
				bank.classList.add('banked');
				bank.classList.remove('owed');

				if(hours > 0) {
					bank.classList.add('positive');
					bank.classList.remove('negative');
				} else {
					bank.classList.add('negative');
					bank.classList.remove('positive');
				}
			}

			$('balance').textContent = hours;

			if(xmlhttp.response.working) {
				bank.classList.add('working');
			} else {
				bank.classList.remove('working');
			}

			if(xmlhttp.response.owed > 0) {
				if(xmlhttp.response.owed == 1) {
					$('owed').style.backgroundColor = 'rgb(227,12,12)';
				} else {
					$('owed').style.backgroundImage = 'linear-gradient(to top, rgb(227,12,12) 0, rgb(227,12,12) '+(xmlhttp.response.owed *100)+'%, transparent calc('+(xmlhttp.response.owed *100)+'% + 4px))';
				}
			}

			if(xmlhttp.response.banked > 0) {
				if(xmlhttp.response.banked == 1) {
					$('banked').style.backgroundColor = 'rgb(11,216,11)';
				} else {
					$('banked').style.backgroundImage = 'linear-gradient(to top, rgb(11,216,11) 0, rgb(11,216,11) '+(xmlhttp.response.banked *100)+'%, transparent calc('+(xmlhttp.response.banked *100)+'% + 4px))';
				}
			}
		}, 'JSON');
	},

	noticeShowOnUpdates: function() {
		// don't blink the checkbox if the user has noticed it previously
		if(Prefs.userNoticedTabOnUpdates) { return; }

		// or if the user has disabled show on updates already (which is a sign he noticed it of course)
		if(!Prefs.showTabOnUpdates) {
			Prefs.userNoticedTabOnUpdates = false;
			return;
		}

		// or if the user manually opened the About tab
		if(!PrefPanes.previousVersion) { return; }

		// so this is apparently the first time the About pane has been shown automatically on an update,
		// let's make sure the user knows this can easily be disabled
		setAttribute(this.gNotifyOnUpdates, 'blink', 'true');

		// if the mouse goes over the checkbox, or if the user toggles it, it's a good sign it has been noticed, so we can disable this from now on
		Listeners.add(this.gShowTabOnUpdates, 'mouseover', this);
		Prefs.listen('showTabOnUpdates', this);
	},

	disableNoticeShowOnUpdates: function() {
		if(Prefs.userNoticedTabOnUpdates) { return; }
		Prefs.userNoticedTabOnUpdates = true;

		removeAttribute(this.gNotifyOnUpdates, 'blink');

		Listeners.remove(this.gShowTabOnUpdates, 'mouseover', this);
		Prefs.unlisten('showTabOnUpdates', this);
	},

	openAddonsMgr: function() {
		this._getChrome().BrowserOpenAddonsMgr();
	},

	_getChrome: function() {
		return window
			.QueryInterface(Ci.nsIInterfaceRequestor)
			.getInterface(Ci.nsIWebNavigation)
			.QueryInterface(Ci.nsIDocShellTreeItem)
			.rootTreeItem
			.QueryInterface(Ci.nsIInterfaceRequestor)
			.getInterface(Ci.nsIDOMWindow);
	}
};

Modules.LOADMODULE = function() {
	about.init();
};

Modules.UNLOADMODULE = function() {
	about.uninit();
};
