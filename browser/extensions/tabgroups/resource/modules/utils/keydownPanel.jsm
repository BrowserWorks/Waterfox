// VERSION 1.4.2
Modules.UTILS = true;
Modules.BASEUTILS = true;

// keydownPanel - 	Panel elements don't support keyboard navigation by default; this object fixes that.
// 			This aid does NOT self-clean, so make sure to remove every call and set object on it.
//			However, the methods are kept in the panel object, and Listeners self-cleans, so it should be ok though, as long as that doesn't fail and the objects
//			are fully removed.
//			Don't forget this aid needs to use the panel's .handleEvent() method to work properly (as in it can't be set beforehand)!
//			To also enable a keyset that toggles (closes) the panel, supply it to the panel object as its ._toggleKeyset property, in the form of:
//				key - (obj):
//					keycode - (string) either a key to press (e.g. 'A') or a keycode to watch for (e.g. 'VK_F8')
//					accel: (bool) true if control key (command key on OSX) should be pressed
//					ctrl: (bool) (OSX only) true if ctrl key should be pressed
//					shift: (bool) true if shift key should be pressed
//					alt: (bool) true if alt key (option key on OSX) should be pressed
//	setupPanel(panel) - sets up a panel element to be able to use keyboard navigation
//		panel - (xul element): panel element to be set
//	unsetPanel(panel) - removes keyboard navigation from a panel
//		see setupPanel()
//	menuItemAccesskeyCode(str, e) - this returns the keycode of str; will return null for non-letters
//		str - (str) string value of a letter to get the keycode
//		e - (event obj) from which to return the keycodes
this.keydownPanel = {
	setupPanel: function(panel) {
		// already set
		if(!panel || panel.handleEvent) { return; }

		panel.handleEvent = function(e) {
			switch(e.type) {
				case 'keydown':
					// Let's make sure
					if(this.state != 'open' && !trueAttribute(this, 'current')) {
						Listeners.remove(window, 'keydown', this, true);
						return;
					}

					// if this var exists, it means this keyset should be used to toggle the panel as well
					if(this._toggleKeyset && Keysets.compareWithEvent(this._toggleKeyset, e)) {
						e.preventDefault();
						e.stopPropagation();

						if(this.hidePopup) {
							this.hidePopup();
						} else {
							keydownPanel.closeSubView();
						}
						return;
					}

					switch(e.which) {
						case e.DOM_VK_A: case e.DOM_VK_B: case e.DOM_VK_C: case e.DOM_VK_D: case e.DOM_VK_E: case e.DOM_VK_F: case e.DOM_VK_G: case e.DOM_VK_H: case e.DOM_VK_I: case e.DOM_VK_J: case e.DOM_VK_K: case e.DOM_VK_L: case e.DOM_VK_M: case e.DOM_VK_N: case e.DOM_VK_O: case e.DOM_VK_P: case e.DOM_VK_Q: case e.DOM_VK_R: case e.DOM_VK_S: case e.DOM_VK_T: case e.DOM_VK_U: case e.DOM_VK_V: case e.DOM_VK_W: case e.DOM_VK_X: case e.DOM_VK_Y: case e.DOM_VK_Z:
							var items = this.querySelectorAll('menuitem,toolbarbutton.subviewbutton');
							for(let item of items) {
								if(keydownPanel.menuItemAccesskeyCode(item.getAttribute('accesskey'), e) == e.which) {
									e.preventDefault();
									e.stopPropagation();
									item.doCommand();
									keydownPanel.closeSubView();
									break;
								}
							}
							break;

						case e.DOM_VK_UP:
						case e.DOM_VK_DOWN:
						case e.DOM_VK_HOME:
						case e.DOM_VK_END:
							e.preventDefault();
							e.stopPropagation();
							Listeners.add(this, 'mouseover', this);
							Listeners.add(this, 'mousemove', this);

							var items = this.querySelectorAll('menuitem,toolbarbutton.subviewbutton');
							let active = -1;
							for(var i=0; i<items.length; i++) {
								var attr = (items[i].localName == 'menuitem') ? '_moz-menuactive' : 'focused';
								if(trueAttribute(items[i], attr)) {
									active = i;
									break;
								}
							}

							if(items[active]) {
								var attr = (items[active].localName == 'menuitem') ? '_moz-menuactive' : 'focused';
								if(attr == 'focused') {
									items[active].blur();
									items[active].style.MozUserFocus = '';
								}
								removeAttribute(items[active], attr);
							}

							switch(e.which) {
								case e.DOM_VK_UP:
									active--;
									if(active < 0) { active = items.length -1; }
									break;
								case e.DOM_VK_DOWN:
									active++;
									if(active >= items.length) { active = 0; }
									break;
								case e.DOM_VK_HOME:
									active = 0;
									break;
								case e.DOM_VK_END:
									active = items.length -1;
									break;
							}

							var attr = (items[active].localName == 'menuitem') ? '_moz-menuactive' : 'focused';
							setAttribute(items[active], attr, 'true');
							if(attr == 'focused') {
								items[active].style.MozUserFocus = 'normal';
								items[active].focus();
							}

							break;

						case e.DOM_VK_RETURN:
							var items = this.querySelectorAll('menuitem,toolbarbutton.subviewbutton');
							for(let item of items) {
								var attr = (item.localName == 'menuitem') ? '_moz-menuactive' : 'focused';
								if(trueAttribute(item, attr)) {
									e.preventDefault();
									e.stopPropagation();
									if(attr == 'focused') {
										item.blur();
										item.style.MozUserFocus = '';
									}

									item.doCommand();
									keydownPanel.closeSubView();
									break;
								}
							}
							break;

						default: break;
					}
					break;

				case 'mouseover':
				case 'mousemove':
					Listeners.remove(this, 'mouseover', this);
					Listeners.remove(this, 'mousemove', this);
					var items = this.querySelectorAll('menuitem,toolbarbutton.subviewbutton');
					for(let item of items) {
						var attr = (item.localName == 'menuitem') ? '_moz-menuactive' : 'focused';
						if(attr == 'focused') {
							item.blur();
							item.style.MozUserFocus = '';
						}
						removeAttribute(item, attr);
					}
					break;

				case 'ViewShowing':
				case 'popupshown':
					if(e.target == this) {
						Listeners.add(window, 'keydown', this, true);
					}
					break;

				case 'ViewHiding':
				case 'popuphidden':
					if(e.target == this) {
						Listeners.remove(this, 'mouseover', this);
						Listeners.remove(this, 'mousemove', this);
						Listeners.remove(window, 'keydown', this, true);
					}
					break;
			}
		};

		if(panel.nodeName == 'panelview' && isAncestor(panel, window.PanelUI.multiView)) {
			Listeners.add(panel, 'ViewShowing', panel);
			Listeners.add(panel, 'ViewHiding', panel);
		} else {
			Listeners.add(panel, 'popupshown', panel);
			Listeners.add(panel, 'popuphidden', panel);
		}
	},

	unsetPanel: function(panel) {
		// not set
		if(!panel || !panel.handleEvent) { return; }

		Listeners.remove(panel, 'mouseover', panel);
		Listeners.remove(panel, 'mousemove', panel);
		Listeners.remove(window, 'keydown', panel, true);

		if(panel.nodeName == 'panelview' && isAncestor(panel, window.PanelUI.multiView)) {
			Listeners.remove(panel, 'ViewShowing', panel);
			Listeners.remove(panel, 'ViewHiding', panel);
		} else {
			Listeners.remove(panel, 'popupshown', panel);
			Listeners.remove(panel, 'popuphidden', panel);
		}

		delete panel.handleEvent;
	},

	closeSubView: function() {
		window.PanelUI.multiView.showMainView();
	},

	menuItemAccesskeyCode: function(str, e) {
		if(!str) return null;
		str = str.toLowerCase();
		if(str == 'a') return e.DOM_VK_A; if(str == 'b') return e.DOM_VK_B; if(str == 'c') return e.DOM_VK_C; if(str == 'd') return e.DOM_VK_D; if(str == 'e') return e.DOM_VK_E; if(str == 'f') return e.DOM_VK_F; if(str == 'g') return e.DOM_VK_G; if(str == 'h') return e.DOM_VK_H; if(str == 'i') return e.DOM_VK_I; if(str == 'j') return e.DOM_VK_J; if(str == 'k') return e.DOM_VK_K; if(str == 'l') return e.DOM_VK_L; if(str == 'm') return e.DOM_VK_M; if(str == 'n') return e.DOM_VK_N; if(str == 'o') return e.DOM_VK_O; if(str == 'p') return e.DOM_VK_P; if(str == 'q') return e.DOM_VK_Q; if(str == 'r') return e.DOM_VK_R; if(str == 's') return e.DOM_VK_S; if(str == 't') return e.DOM_VK_T; if(str == 'u') return e.DOM_VK_U; if(str == 'v') return e.DOM_VK_V; if(str == 'w') return e.DOM_VK_W; if(str == 'x') return e.DOM_VK_X; if(str == 'y') return e.DOM_VK_Y; if(str == 'z') return e.DOM_VK_Z;
		return null;
	}
};
