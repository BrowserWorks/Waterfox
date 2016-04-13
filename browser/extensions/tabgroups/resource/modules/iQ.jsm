// VERSION 1.0.3

// Returns an iQClass object which represents an individual element or a group of elements. It works pretty much like jQuery(), with a few exceptions,
// most notably that you can't use strings with complex html, just simple tags like '<div>'.
this.iQ = function(selector, context) {
	// The iQ object is actually just the init constructor 'enhanced'
	return new iQClass(selector, context);
};

// A simple way to check for HTML strings or ID strings (both of which we optimize for)
this.quickExpr = /^[^<]*(<[\w\W]+>)[^>]*$|^#([\w-]+)$/;

// Match a standalone tag
this.rsingleTag = /^<(\w+)\s*\/?>(?:<\/\1>)?$/;

// The actual class of iQ result objects, representing an individual element or a group of elements.
// You don't call this directly; this is what's called by iQ().
this.iQClass = function(selector, context) {
	// Handle iQ(""), iQ(null), or iQ(undefined)
	if(!selector) { return this; }

	// Handle iQ(DOMElement)
	if(selector.nodeType) {
		this.context = selector;
		this[0] = selector;
		this.length = 1;
		return this;
	}

	// The body element only exists once, optimize finding it
	if(selector === "body" && !context) {
		this.context = document;
		this[0] = document.body;
		this.selector = "body";
		this.length = 1;
		return this;
	}

	// Handle HTML strings
	if(typeof selector === "string") {
		// Are we dealing with HTML string or an ID?
		let match = quickExpr.exec(selector);

		// Verify a match, and that no context was specified for #id
		if(match && (match[1] || !context)) {
			// HANDLE iQ(html). single tags only!
			if(match[1]) {
				let doc = (context ? context.ownerDocument || context : document);

				// If a single string is passed in and it's a single tag just do a createElement and skip the rest
				let ret = rsingleTag.exec(selector);
				selector = [ doc.createElement(ret[1]) ];
				return Utils.merge(this, selector);
			}
			// HANDLE iQ("#id")
			else {
				let elem = $(match[2]);

				if(elem) {
					this.length = 1;
					this[0] = elem;
				}

				this.context = document;
				this.selector = selector;
				return this;
			}
		}

		// HANDLE iQ("TAG")
		else if(!context && /^\w+$/.test(selector)) {
			this.selector = selector;
			this.context = document;
			selector = document.getElementsByTagName(selector);
			return Utils.merge(this, selector);
		}

		// HANDLE iQ(expr, iQ(...))
		else if(!context || context.iq) {
			return (context || iQ(document)).find(selector);
		}

		// HANDLE iQ(expr, context)
		// (which is just equivalent to: $(context).find(expr)
		else {
			return iQ(context).find(selector);
		}
	}

	if("selector" in selector) {
		this.selector = selector.selector;
		this.context = selector.context;
	}

	let ret = this || [];
	if(selector != null) {
		// The window, strings (and functions) also have 'length'
		if(selector.length == null || typeof selector == "string" || selector.setInterval) {
			Array.push(ret, selector);
		} else {
			Utils.merge(ret, selector);
		}
	}
	return ret;
};

this.iQClass.prototype = {
	// Start with an empty selector
	selector: "",

	// The default length of a iQ object is 0
	length: 0,

	// Execute a callback for every element in the matched set.
	each: function(callback) {
		for(let i = 0; i < this.length; i++) {
			if(callback(this[i]) === false) { break; }
		}
		return this;
	},

	// Adds the given class(es) to the receiver.
	addClass: function(value) {
		for(let i = 0; i < this.length; i++) {
			if(this[i].nodeType !== 1) { continue; }

			value.split(/\s+/).forEach((className) => {
				this[i].classList.add(className);
			});
		}

		return this;
	},

	// Removes the given class(es) from the receiver.
	removeClass: function(value) {
		for(let i = 0; i < this.length; i++) {
			if(this[i].nodeType !== 1) { continue; }

			value.split(/\s+/).forEach((className) => {
				this[i].classList.remove(className);
			});
		}

		return this;
	},

	// Returns true is the receiver has the given css class.
	hasClass: function(singleClassName) {
		for(let i = 0; i < this.length; i++) {
			if(this[i].nodeType !== 1) { continue; }

			if(this[i].classList.contains(singleClassName)) {
				return true;
			}
		}
		return false;
	},

	// Searches the receiver and its children, returning a new iQ object with elements that match the given selector.
	find: function(selector) {
		let ret = [];
		let length = 0;

		for(let i = 0; i < this.length; i++) {
			let found = $$(selector, this[i]);
			for(let node of found) {
				if(ret.indexOf(node) == -1) {
					ret.push(node);
				}
			}
		}

		return iQ(ret);
	},

	// Check to see if a given DOM node descends from the receiver.
	contains: function(selector) {
		let object = iQ(selector);
		return isAncestor(object[0], this[0]);
	},

	// Removes the receiver from the DOM.
	remove: function(options) {
		if(!options || !options.preserveEventHandlers) {
			this.unbindAll();
		}

		for(let i = 0; this[i] != null; i++) {
			this[i].remove();
		}
		return this;
	},

	// Removes all of the reciever's children and HTML content from the DOM.
	empty: function() {
		for(let i = 0; this[i] != null; i++) {
			let elem = this[i];
			while(elem.firstChild) {
				iQ(elem.firstChild).unbindAll();
				elem.firstChild.remove();
			}
		}
		return this;
	},

	// Returns the width of the receiver, including padding and border.
	width: function() {
		return Math.floor(this[0].offsetWidth);
	},

	// Returns the height of the receiver, including padding and border.
	height: function() {
		return Math.floor(this[0].offsetHeight);
	},

	// Returns an object with the receiver's position in left and top properties.
	position: function() {
		let bounds = this.bounds();
		return new Point(bounds.left, bounds.top);
	},

	// Returns a <Rect> with the receiver's bounds.
	bounds: function() {
		let rect = this[0].getBoundingClientRect();
		return new Rect(Math.floor(rect.left), Math.floor(rect.top), Math.floor(rect.width), Math.floor(rect.height));
	},

	// Pass in both key and value to attach some data to the receiver;
	// pass in just key to retrieve it.
	data: function(key, value) {
		let data = null;
		if(value === undefined) {
			data = this[0].iQData;
			return (data) ? data[key] : null;
		}

		for(let i = 0; this[i] != null; i++) {
			let elem = this[i];
			data = elem.iQData;

			if(!data) {
				data = elem.iQData = {};
			}

			data[key] = value;
		}

		return this;
	},

	// Given a value, sets the receiver's textContent to it; otherwise returns what's already there.
	text: function(value) {
		if(value === undefined) {
			return this[0].textContent;
		}

		return this.empty().append((this[0] && this[0].ownerDocument || document).createTextNode(value));
	},

	// Given a value, sets the receiver's value to it; otherwise returns what's already there.
	val: function(value) {
		if(value === undefined) {
			return this[0].value;
		}

		this[0].value = value;
		return this;
	},

	// Appends the receiver to the result of iQ(selector).
	appendTo: function(selector) {
		iQ(selector).append(this);
		return this;
	},

	// Appends the result of iQ(selector) to the receiver.
	append: function(selector) {
		let object = iQ(selector);
		this[0].appendChild(object[0]);
		return this;
	},

	// Sets or gets an attribute on the element(s).
	attr: function(key, value) {
		if(value === undefined) {
			return this[0].getAttribute(key);
		}

		for(let i = 0; this[i] != null; i++) {
			this[i].setAttribute(key, value);
		}

		return this;
	},

	// Sets or gets CSS properties on the receiver. When setting certain numerical properties,
	// will automatically add "px". A property can be removed by setting it to null.
	// Possible call patterns:
	//   a: object, b: undefined - sets with properties from a
	//   a: string, b: undefined - gets property specified by a
	//   a: string, b: string/number - sets property specified by a to b
	css: function(a, b) {
		let properties = null;

		if(typeof a === 'string') {
			let key = a;
			if(b === undefined) {
				return getComputedStyle(this[0]).getPropertyValue(key);
			}
			properties = {};
			properties[key] = b;
		}
		else if(a instanceof Rect) {
			properties = {
				left: a.left,
				top: a.top,
				width: a.width,
				height: a.height
			};
		} else {
			properties = a;
		}

		let pixels = {
			'left': true,
			'top': true,
			'right': true,
			'bottom': true,
			'width': true,
			'height': true
		};

		for(let i = 0; this[i] != null; i++) {
			let elem = this[i];
			for (let key in properties) {
				let value = properties[key];

				if(pixels[key] && typeof value != 'string') {
					value += 'px';
				}

				if(value == null) {
					elem.style.removeProperty(key);
				} else if(key.indexOf('-') != -1) {
					elem.style.setProperty(key, value, '');
				} else {
					elem.style[key] = value;
				}
			}
		}

		return this;
	},

	// Uses CSS transitions to animate the element.
	// Parameters:
	//   css - an object map of the CSS properties to change
	//   options - an object with various properites (see below)
	// Possible "options" properties:
	//   duration - how long to animate, in milliseconds
	//   easing - easing function to use. Possibilities include
	//     "tabviewBounce", "easeInQuad". Default is "ease".
	//   complete - function to call once the animation is done, takes nothing
	//     in, but "this" is set to the element that was animated.
	animate: function(css, options) {
		if(!options) {
			options = {};
		}

		let easings = {
			tabviewBounce: "cubic-bezier(0.0, 0.63, .6, 1.29)",
			easeInQuad: 'ease-in', // TODO: make it a real easeInQuad, or decide we don't care
			fast: 'cubic-bezier(0.7,0,1,1)'
		};

		let duration = (options.duration || 400);
		let easing = (easings[options.easing] || 'ease');

		if(css instanceof Rect) {
			css = {
				left: css.left,
				top: css.top,
				width: css.width,
				height: css.height
			};
		}


		// The latest versions of Firefox do not animate from a non-explicitly set css properties.
		// So for each element to be animated, go through and explicitly define 'em.
		let rupper = /([A-Z])/g;
		this.each(function(elem) {
			let cStyle = getComputedStyle(elem);
			for(let prop in css) {
				prop = prop.replace(rupper, "-$1").toLowerCase();
				iQ(elem).css(prop, cStyle.getPropertyValue(prop));
			}
		});

		this.css({
			'transition-property': Object.keys(css).join(", "),
			'transition-duration': (duration / 1000) + 's',
			'transition-timing-function': easing
		});

		this.css(css);

		aSync(() => {
			this.css({
				'transition-property': 'none',
				'transition-duration': '',
				'transition-timing-function': ''
			});

			if(typeof options.complete == "function") {
				options.complete();
			}
		}, duration);

		return this;
	},

	// Animates the receiver to full transparency. Calls callback on completion.
	fadeOut: function(callback) {
		this.animate({
			opacity: 0
		}, {
			duration: 400,
			complete: () => {
				iQ(this).css({ display: 'none' });
				if(typeof callback == "function") {
					callback.apply(this);
				}
			}
		});

		return this;
	},

	// Animates the receiver to full opacity.
	fadeIn: function() {
		this.css({ display: '' });
		this.animate({
			opacity: 1
		}, {
			duration: 400
		});

		return this;
	},

	// Hides the receiver.
	hide: function() {
		this.css({ display: 'none', opacity: 0 });
		return this;
	},

	// Shows the receiver.
	show: function() {
		this.css({ display: '', opacity: 1 });
		return this;
	},

	// Binds the given function to the given event type. Also wraps the function in a try/catch so it doesn't block on any errors.
	bind: function(type, func) {
		let handler = function(event) {
			return func.apply(this, [event]);
		};

		for(let i = 0; this[i] != null; i++) {
			let elem = this[i];
			if(!elem.iQEventData) {
				elem.iQEventData = {};
			}

			if(!elem.iQEventData[type]) {
				elem.iQEventData[type] = [];
			}

			elem.iQEventData[type].push({
				original: func,
				modified: handler
			});

			elem.addEventListener(type, handler, false);
		}

		return this;
	},

	// Binds the given function to the given event type, but only for one call;
	// automatically unbinds after the event fires once.
	one: function(type, func) {
		let handler = function(e) {
			iQ(this).unbind(type, handler);
			return func.apply(this, [e]);
		};

		return this.bind(type, handler);
	},

	// Unbinds the given function from the given event type.
	unbind: function(type, func) {
		for(let i = 0; this[i] != null; i++) {
			let elem = this[i];
			let handler = func;
			if(elem.iQEventData && elem.iQEventData[type]) {
				let count = elem.iQEventData[type].length;
				for(let a = 0; a < count; a++) {
					let pair = elem.iQEventData[type][a];
					if(pair.original == func) {
						handler = pair.modified;
						elem.iQEventData[type].splice(a, 1);
						if(!elem.iQEventData[type].length) {
							delete elem.iQEventData[type];
							if(!Object.keys(elem.iQEventData).length) {
								delete elem.iQEventData;
							}
						}
						break;
					}
				}
			}

			elem.removeEventListener(type, handler, false);
		}

		return this;
	},

	// Unbinds all event handlers.
	unbindAll: function() {
		for(let i = 0; this[i] != null; i++) {
			let elem = this[i];

			for(let j = 0; j < elem.childElementCount; j++) {
				iQ(elem.children[j]).unbindAll();
			}

			if(!elem.iQEventData) {
				continue;
			}

			Object.keys(elem.iQEventData).forEach(function(type) {
				while(elem.iQEventData && elem.iQEventData[type]) {
					this.unbind(type, elem.iQEventData[type][0].original);
				}
			}, this);
		}

		return this;
	}
};

Modules.LOADMODULE = function() {
	// Create various event aliases
	[
		'keyup',
		'keydown',
		'keypress',
		'mouseup',
		'mousedown',
		'mouseover',
		'mouseout',
		'mousemove',
		'click',
		'dblclick',
		'resize',
		'change',
		'blur',
		'focus'
	].forEach(function(event) {
		iQClass.prototype[event] = function(func) {
			return this.bind(event, func);
		};
	});
};
