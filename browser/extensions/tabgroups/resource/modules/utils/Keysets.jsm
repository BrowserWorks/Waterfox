// VERSION 1.7.1
Modules.UTILS = true;

// Keysets - handles editable keysets for the add-on
//	register(key) - registers a keyset from object key
//		key - (obj):
//			id - (string) id for the key element
//			(either this or oncommand) command - (string) id of command element to trigger
//			(either this or command) oncommand - (string) action to perform
//			keycode - (string) a key to press (e.g. 'A', 'F8', etc.); some keys don't work, see below notes.
//			accel: (bool) true if control key (command key on OSX) should be pressed
//			ctrl: (bool) (OSX only) true if control key should be pressed
//			shift: (bool) true if shift key should be pressed
//			alt: (bool) true if alt key (option key on OSX) should be pressed
//	unregister(key) - unregisters a keyset
//		see register()
//	compareKeys(a, b, justModifiers) - compares two keysets, returns true if they have the same specs (keycode and modifiers), returns false otherwise
//		a - (obj) keyset to compare, see register()
//		b - (obj) keyset to compare, see register()
//		(optional) justModifiers - if true only the modifiers will be compared and the keycode will be ignored, defaults to false
//	exists(key) -	returns (obj) of existing key if provided keycode and modifiers already exists,
//				returns (bool) false otherwise. Returns null if no browser window is opened.
//		see register()
//	translateToConstantCode(key) - returns the VK_INPUT string to be used in a key element for a given non-input key value
//	translateFromConstantCode(keycode) - returns equivalent key value from a possible DOM_VK_INPUT string name
//	compareWithEvent(k, e) - returns whether a given key event corresponds to a registered keyset
this.Keysets = {
	registered: [],
	queued: [],

	// Numbers don't work, only managed to customize Ctrl+Alt+1 and Ctrl+Alt+6, probably because Ctrl+Alt -> AltGr and Shift+Number inserts an alternate char in most keyboards
	unusable: [
		// Ctrl+Page Up/Down toggles tabs.
		{
			id: 'native_togglesTabs',
			accel: true,
			shift: false,
			alt: false,
			ctrl: false,
			keycode: 'PageUp'
		},
		{
			id: 'native_togglesTabs',
			accel: true,
			shift: false,
			alt: false,
			ctrl: false,
			keycode: 'PageDown'
		},
		// Ctrl+F4 closes current tab
		// Alt+F4 closes current window
		{
			id: 'close_current_tab',
			accel: true,
			shift: false,
			alt: false,
			ctrl: false,
			keycode: 'F4'
		},
		{
			id: 'close_current_window',
			accel: false,
			shift: false,
			alt: true,
			ctrl: false,
			keycode: 'F4'
		},
		// F10 Toggles menu bar
		{
			id: 'toggle_menubar',
			accel: false,
			shift: false,
			alt: false,
			ctrl: false,
			keycode: 'F10'
		},
		{
			id: 'toggle_menubar',
			accel: true,
			shift: false,
			alt: false,
			ctrl: false,
			keycode: 'F10'
		},
		// Shift+F10 Toggles context menu
		{
			id: 'toggle_contextmenu',
			accel: false,
			shift: true,
			alt: false,
			ctrl: false,
			keycode: 'F10'
		},
		{
			id: 'toggle_contextmenu',
			accel: true,
			shift: true,
			alt: false,
			ctrl: false,
			keycode: 'F10'
		},
		// F7 toggle caret browsing
		{
			id: 'toggle_caret_browsing',
			accel: false,
			shift: false,
			alt: false,
			ctrl: false,
			keycode: 'F7'
		}

	],

	// Restricts available key combos, I'm setting all displaying keys and other common ones to at least need the Ctrl key
	allCodesAccel: ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', ' ', 'PageUp', 'PageDown', 'Home', 'End', 'ArrowUp', 'ArrowDown', 'ArrowLeft', 'ArrowRight', '.', ',', ';', '/', '\\', '=', '+', '-', '*', '<', '>', String.fromCharCode(180)/*'´'*/, '`', '~', '^' ],

	// Function keys should work by themselves without any modifiers
	allCodes: ['F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8', 'F9', 'F10', 'F11', 'F12', 'F13', 'F14', 'F15', 'F16', 'F17', 'F18', 'F19', 'F20', 'F21', 'F22', 'F23', 'F24'],

	// all the codes to be filled into selection menus, in the order they should be shown
	fillCodes: [
		['none', Strings.get('utils/keys', 'none')],
		['A'],['B'],['C'],['D'],['E'],['F'],['G'],['H'],['I'],['J'],['K'],['L'],['M'],['N'],['O'],['P'],['Q'],['R'],['S'],['T'],['U'],['V'],['W'],['X'],['Y'],['Z'],
		[' ', Strings.get('utils/keys', 'spacebar')],
		['PageUp', Strings.get('utils/keys', 'pageup')],
		['PageDown', Strings.get('utils/keys', 'pagedown')],
		['Home', Strings.get('utils/keys', 'home')],
		['End', Strings.get('utils/keys', 'end')],
		['ArrowUp', Strings.get('utils/keys', 'up')],
		['ArrowDown', Strings.get('utils/keys', 'down')],
		['ArrowLeft', Strings.get('utils/keys', 'left')],
		['ArrowRight', Strings.get('utils/keys', 'right')],
		['.'],[','],[';'],['/'],['\\'],['='],['+'],['-'],['*'],['<'],['>'],
		[String.fromCharCode(180)/*'´'*/],['`'],['~'],['^'],
		['F1'],['F2'],['F3'],['F4'],['F5'],['F6'],['F7'],['F8'],['F9'],['F10'],['F11'],['F12'],
		['F13'],['F14'],['F15'],['F16'],['F17'],['F18'],['F19'],['F20'],['F21'],['F22'],['F23'],['F24']
	],

	// for the preferences tab, to auto-fill all the key options and labels
	fillKeyStrings: function(key) {
		setAttribute(key.accelBox, 'label', Strings.get('utils/keys', DARWIN ? 'command' : 'control'));
		setAttribute(key.shiftBox, 'label', Strings.get('utils/keys', 'shift'));
		setAttribute(key.altBox, 'label', Strings.get('utils/keys', DARWIN ? 'option' : 'alt'));
		setAttribute(key.ctrlBox, 'label', Strings.get('utils/keys', 'control'));

		// A separate checkbox for Control is shown in OSX, because "accel" == "ctrl" only on Windows and Linux, and it's == "command" in OSX.
		key.ctrlBox.hidden = !DARWIN;

		for(let entry of this.fillCodes) {
			let item = key.menu.ownerDocument.createElement('menuitem');
			item.setAttribute('value', entry[0]);
			item.setAttribute('label', entry[1] || entry[0]);
			key.menu.appendChild(item);
		}

		// make sure the box label is updated to the current item's label
		key.node.value = key.node.value;
	},

	// we only translate the ones we actually use in here
	translateToConstantCode: function(key) {
		switch(key) {
			case 'PageUp': return 'VK_PAGE_UP';
			case 'PageDown': return 'VK_PAGE_DOWN';
			case 'Home': return 'VK_HOME';
			case 'End': return 'VK_END';
			case 'ArrowUp': return 'VK_UP';
			case 'ArrowDown': return 'VK_DOWN';
			case 'ArrowLeft': return 'VK_LEFT';
			case 'ArrowRight': return 'VK_RIGHT';

			case 'F1': case 'F2': case 'F3': case 'F4': case 'F5': case 'F6': case 'F7': case 'F8': case 'F9': case 'F10': case 'F11': case 'F12':
			case 'F13': case 'F14': case 'F15': case 'F16': case 'F17': case 'F18': case 'F19': case 'F20': case 'F21': case 'F22': case 'F23': case 'F24':
				return 'VK_'+key;

		}
		return key;
	},

	// we only translate the ones we actually use in here
	translateFromConstantCode: function(keycode) {
		let key = keycode;
		if(key.startsWith('DOM_')) { key = key.substr(4); }
		if(key.startsWith('VK_')) { key = key.substr(3); }
		switch(key) {
			case 'SPACE': key = ' '; break;
			case 'PERIOD': key = '.'; break;
			case 'COMMA': key = ','; break;
			case 'SEMICOLON': key = ';'; break;
			case 'SLASH': key = '/'; break;
			case 'BACK_SLASH': key = '\\'; break;
			case 'EQUALS': key = '='; break;
			case 'PLUS': key = '+'; break;
			case 'HYPHEN_MINUS': key = '-'; break;
			case 'ASTERISK': key = '*'; break;
			case 'BACK_QUOTE': key = '`'; break;
			case 'TILDE': key = '~'; break;
			case 'CIRCUMFLEX': key = '^'; break;
			case 'PAGE_UP': key = 'PageUp'; break;
			case 'PAGE_DOWN': key = 'PageDown'; break;
			case 'HOME': key = 'Home'; break;
			case 'END': key = 'End'; break;
			case 'UP': key = 'ArrowUp'; break;
			case 'DOWN': key = 'ArrowDown'; break;
			case 'LEFT': key = 'ArrowLeft'; break;
			case 'RIGHT': key = 'ArrowRight'; break;
			default: break;
		}
		// we like single chars to always be uppercased (no distinction between 'a' and 'A')
		if(key.length == 1) {
			key = key.toUpperCase();
		}
		return key;
	},

	register: function(key, noSchedule) {
		if(!key.id) { return false; }
		key = this.prepareKey(key);
		if(this.isRegistered(key)) { return true; }

		this.unregister(key, true);

		if(!key.keycode || (!key.command && !key.oncommand)) {
			if(!noSchedule) {
				this.setAllWindows();
			}
			return false;
		}

		if(!Windows.callOnMostRecent(function(aWindow) { return true; }, 'navigator:browser')) {
			this.queued.push(key);
			return true;
		}

		if(this.isValid(key)) {
			let exists = this.exists(key);
			if(!exists) {
				this.registered.push(key);
			} else {
				for(let other of this.delayedOtherKeys) {
					if(other(exists)) {
						aSync(() => {
							this.register(key);
						}, 500);
						return;
					}
				}
			}
		}

		if(!noSchedule) {
			this.setAllWindows();
		}

		return true;
	},

	unregister: function(key, noSchedule) {
		if(!key.id) { return; }

		for(var r=0; r<this.registered.length; r++) {
			if(this.registered[r].id == key.id) {
				this.registered.splice(r, 1);

				if(!noSchedule) {
					this.setAllWindows();
				}
				return;
			}
		}
	},

	compareKeys: function(a, b, justModifiers) {
		if((a.keycode == b.keycode || justModifiers)
		&& a.accel == b.accel
		&& a.shift == b.shift
		&& a.alt == b.alt
		&& (!DARWIN || a.ctrl == b.ctrl)) {
			return true;
		}
		return false;
	},

	compareWithEvent: function(k, e) {
		return	k.keycode == this.translateFromConstantCode(e.key)
			&& k.shift == e.shiftKey
			&& k.alt == e.altKey
			&& k.accel == (DARWIN ? e.metaKey : e.ctrlKey)
			&& (!DARWIN || k.ctrl == e.ctrlKey);
	},

	// array of methods/occasions where a key could be reported as in/valid by mistake because it belongs to an add-on that hasn't been initialized yet
	delayedOtherKeys: [
		// Tile Tabs Function keys
		function(aKey) { return aKey.id.startsWith('tiletabs-fkey-') && !aKey.hasModifiers; }
	],

	prepareKey: function(key) {
		let newKey = {
			id: key.id || null,
			command: key.command || null,
			oncommand: key.oncommand || null,
			keycode: key.keycode || null,
			accel: key.accel || false,
			shift: key.shift || false,
			alt: key.alt || false,
			ctrl: (DARWIN && key.ctrl) || false
		};
		return newKey;
	},

	getAllSets: function(aWindow) {
		if(!aWindow) {
			Windows.callOnMostRecent((bWindow) => { aWindow = bWindow; }, 'navigator:browser');
		}

		let allSets = [];

		// Grab all key elements in the document
		let keys = aWindow.document.querySelectorAll('key');
		for(let k of keys) {
			if(!k.id || k.parentNode.nodeName != 'keyset' || trueAttribute(k, 'disabled')) { continue; }

			// we don't want our own keyset here
			if(k.parentNode.id == objName+'-keyset') { continue; }

			let key = {
				id: k.id,
				hasModifiers: k.hasAttribute('modifiers'),
				self: k.getAttribute('Keysets') == objName
			};

			let modifiers = k.getAttribute('modifiers').toLowerCase();
			key.accel = modifiers.includes('accel') || modifiers.includes(!DARWIN ? 'control' : 'meta'); // control key in windows and linux, command key on osx
			key.alt = modifiers.includes('alt'); // option key on mac
			key.shift = modifiers.includes('shift');
			key.ctrl = DARWIN && modifiers.includes('control');

			key.keycode = this.translateFromConstantCode(k.getAttribute('keycode') || k.getAttribute('key'));
			allSets.push(key);
		}

		// Alt + % will open certain menus, we need to account for these as well, twice with shift as it also works
		let mainmenu = aWindow.document.getElementById('main-menubar');
		if(mainmenu) {
			for(let menu of mainmenu.childNodes) {
				let key = {
					id: menu.id,
					accel: false,
					alt: true,
					shift: false,
					ctrl: false,
					keycode: menu.getAttribute('accesskey').toUpperCase()
				};
				allSets.push(key);

				key = {
					id: menu.id,
					accel: false,
					alt: true,
					shift: true,
					ctrl: false,
					keycode: menu.getAttribute('accesskey').toUpperCase()
				};
				allSets.push(key);
			}
		}

		for(let x of Keysets.unusable) {
			allSets.push(x);
		}

		return allSets;
	},

	getAvailable: function(key, moreKeys) {
		let allSets = this.getAllSets();
		let available = {};

		if(key.accel || (DARWIN && key.ctrl)) {
			codesLoop:
			for(let code of this.allCodesAccel) {
				let check = this.isCodeAvailable(code, key, allSets, moreKeys);
				if(check) {
					available[code] = check;
				}
			}
		}

		for(let code of this.allCodes) {
			let check = this.isCodeAvailable(code, key, allSets, moreKeys);
			if(check) {
				available[code] = check;
			}
		}

		return available;
	},

	isCodeAvailable: function(code, key, allSets, moreKeys) {
		let check = {
			id: null,
			keycode: code,
			accel: key.accel,
			shift: key.shift,
			alt: key.alt,
			ctrl: key.ctrl
		};

		if(this.exists(check, allSets)) {
			return null;
		}

		if(moreKeys) {
			for(let more of moreKeys) {
				if(more.disabled) { continue; }

				if(this.compareKeys(more, check)) {
					if(more.id == key.id) {
						return check;
					}
					return null;
				}
			}
		}

		return check;
	},

	exists: function(key, allSets) {
		if(!allSets) {
			allSets = this.getAllSets();
			if(!allSets) {
				return null;
			}
		}

		for(let k of allSets) {
			if(this.compareKeys(k, key)) {
				return k;
			}
		}

		return false;
	},

	isValid: function(key) {
		for(let code of this.allCodes) {
			if(code == key.keycode) {
				return true;
			}
		}

		if(key.accel || (DARWIN && key.ctrl)) {
			for(let code of this.allCodesAccel) {
				if(code == key.keycode) {
					return true;
				}
			}
		}

		return false;
	},

	isRegistered: function(key) {
		for(let k of this.registered) {
			if(key.id == k.id
			&& key.command == k.command
			&& key.oncommand == k.oncommand
			&& this.compareKeys(k, key)) {
				return true;
			}
		}
		return false;
	},

	setAllWindows: function() {
		Windows.callOnAll((aWindow) => { this.setWindow(aWindow); }, 'navigator:browser');
	},

	unsetAllWindows: function() {
		Windows.callOnAll((aWindow) => { this.unsetWindow(aWindow); }, 'navigator:browser');
	},

	unsetWindow: function(aWindow) {
		let keyset = aWindow.document.getElementById(objName+'-keyset');
		if(keyset) {
			keyset.remove();
		}
	},

	setWindow: function(aWindow) {
		if(this.queued.length > 0) {
			while(this.queued.length > 0) {
				var key = this.queued.shift();
				this.register(key, true);
			}
			this.setAllWindows();
			return;
		}

		this.unsetWindow(aWindow);

		if(this.registered.length > 0) {
			let keyset = aWindow.document.createElement('keyset');
			keyset.id = objName+'-keyset';

			for(let r of this.registered) {
				let key = aWindow.document.createElement('key');
				key.id = r.id;
				key.setAttribute('Keysets', objName);
				toggleAttribute(key, 'command', r.command, r.command);
				toggleAttribute(key, 'oncommand', r.oncommand, r.oncommand);

				let code = this.translateToConstantCode(r.keycode);
				key.setAttribute(code.startsWith('VK_') ? 'keycode' : 'key', code);

				if(r.accel || r.shift || r.alt || r.ctrl) {
					let modifiers = [];
					if(r.accel) { modifiers.push('accel'); }
					if(r.shift) { modifiers.push('shift'); }
					if(r.alt) { modifiers.push('alt'); }
					if(r.ctrl) { modifiers.push('control'); }
					key.setAttribute('modifiers', modifiers.join(','));
				}

				keyset.appendChild(key);
			}

			aWindow.document.getElementById('main-window').appendChild(keyset);
		}
	},

	observe: function(aSubject, aTopic) {
		this.setWindow(aSubject);
	}
};

Modules.LOADMODULE = function() {
	Windows.register(Keysets, 'domwindowopened', 'navigator:browser');
};

Modules.UNLOADMODULE = function() {
	Windows.unregister(Keysets, 'domwindowopened', 'navigator:browser');
	Keysets.unsetAllWindows(); // removes the keyset object if the add-on has been unloaded
};
