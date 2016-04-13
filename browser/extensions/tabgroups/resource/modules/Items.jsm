// VERSION 1.0.1

// Class: Item - Superclass for all visible objects (<TabItem>s and <GroupItem>s).
// If you subclass, in addition to the things Item provides, you need to also provide these methods:
//   setBounds - function(rect, immediately, options)
//   setZ - function(value)
//   close - function()
//   save - function()
// Subclasses of Item must also provide the <Subscribable> interface.
// Make sure to call _init() from your subclass's constructor.
this.Item = function() {
	// Always true for Items
	this.isAnItem = true;

	// The position and size of this Item, represented as a <Rect>.
	// This should never be modified without using setBounds()
	this.bounds = null;

	// The z-index for this item.
	this.zIndex = 0;

	// The outermost DOM element that describes this item on screen.
	this.container = null;

	// The groupItem that this item is a child of
	this.parent = null;

	// A <Point> that describes the last size specifically chosen by the user.
	this.userSize = null;

	// Possible properties:
	//   cancelClass - A space-delimited list of classes that should cancel a drag
	//   start - A function to be called when a drag starts
	//   drag - A function to be called each time the mouse moves during drag
	//   stop - A function to be called when the drag is done
	this.dragOptions = null;

	// Used by <draggable> if the item is set to droppable.
	// Possible properties:
	//   accept - A function to determine if a particular item should be accepted for dropping
	//   over - A function to be called when an item is over this item
	//   out - A function to be called when an item leaves this item
	//   drop - A function to be called when an item is dropped in this item
	this.dropOptions = null;

	// Possible properties:
	//   minWidth - Minimum width allowable during resize
	//   minHeight - Minimum height allowable during resize
	//   aspectRatio - true if we should respect aspect ratio; default false
	//   start - A function to be called when resizing starts
	//   resize - A function to be called each time the mouse moves during resize
	//   stop - A function to be called when the resize is done
	this.resizeOptions = null;

	// Boolean for whether the item is currently being dragged or not.
	this.isDragging = false;
};

this.Item.prototype = {
	// Initializes the object. To be called from the subclass's intialization function.
	// Parameters:
	//   container - the outermost DOM element that describes this item onscreen.
	_init: function(container) {
		this.container = container;
		this.$container = iQ(container);

		this.$container.data('item', this);

		// ___ drag
		this.dragOptions = {
			cancelClass: 'close stackExpander',

			start: function(e, ui) {
				UI.setActive(this);
				if(this.isAGroupItem) {
					this._unfreezeItemSize();
				}
				// if we start dragging a tab within a group, start with dropSpace on.
				else if(this.parent != null) {
					this.parent._dropSpaceActive = true;
				}
				drag.info = new Drag(this, e);
			},

			drag: function(e) {
				drag.info.drag(e);
			},

			stop: function() {
				drag.info.stop();

				if(!this.isAGroupItem && !this.parent) {
					new GroupItem([ drag.info.$el ], { focusTitle: true });
				}

				drag.info = null;
			},

			// The minimum the mouse must move after mouseDown in order to move an item
			minDragDistance: 3
		};

		// ___ drop
		this.dropOptions = {
			over: function() {},

			out: function() {
				let groupItem = drag.info.item.parent;
				if(groupItem) {
					groupItem.remove(drag.info.$el, { dontClose: true });
				}
				iQ(this.container).removeClass("acceptsDrop");
			},

			drop: function(event) {
				iQ(this.container).removeClass("acceptsDrop");
			},

			// Given a DOM element, returns true if it should accept tabs being dropped on it.
			accept: function(item) {
				return (item && item.isATabItem && (!item.parent || !item.parent.expanded));
			}
		};

		// ___ resize
		this.resizeOptions = {
			aspectRatio: this.keepProportional,
			minWidth: 90,
			minHeight: 90,

			start: (e) => {
				UI.setActive(this);
				resize.info = new Drag(this, e);
			},

			resize: () => {
				resize.info.snap(UI.rtl ? 'topright' : 'topleft', false, this.keepProportional);
			},

			stop: () => {
				this.setUserSize();
				this.pushAway();
				resize.info.stop();
				resize.info = null;
			}
		};
	},

	// Returns a copy of the Item's bounds as a <Rect>.
	getBounds: function() {
		return new Rect(this.bounds);
	},

	// Returns true if this Item overlaps with any other Item on the screen.
	overlapsWithOtherItems: function() {
		let items = Items.getTopLevelItems();
		let bounds = this.getBounds();
		return items.some((item) => {
			// can't overlap with yourself.
			if(item == this) { return false; }

			let myBounds = item.getBounds();
			return myBounds.intersects(bounds);
		});
	},

	// Moves the Item to the specified location.
	// Parameters:
	//   left - the new left coordinate relative to the window
	//   top - the new top coordinate relative to the window
	//   immediately - if false or omitted, animates to the new position; otherwise goes there immediately
	setPosition: function(left, top, immediately) {
		this.setBounds(new Rect(left, top, this.bounds.width, this.bounds.height), immediately);
	},

	// Resizes the Item to the specified size.
	// Parameters:
	//   width - the new width in pixels
	//   height - the new height in pixels
	//   immediately - if false or omitted, animates to the new size; otherwise resizes immediately
	setSize: function(width, height, immediately) {
		this.setBounds(new Rect(this.bounds.left, this.bounds.top, width, height), immediately);
	},

	// Remembers the current size as one the user has chosen.
	setUserSize: function() {
		this.userSize = new Point(this.bounds.width, this.bounds.height);
		this.save();
	},

	// Returns the zIndex of the Item.
	getZ: function() {
		return this.zIndex;
	},

	// Rotates the object to the given number of degrees.
	setRotation: function(degrees) {
		let value = degrees ? "rotate(%deg)".replace(/%/, degrees) : null;
		iQ(this.container).css({ "transform": value });
	},

	// Sets the receiver's parent to the given <Item>.
	setParent: function(parent) {
		this.parent = parent;
		this.removeTrenches();
		this.save();
	},

	// Pushes all other items away so none overlap this Item.
	// Parameters:
	//  immediately - boolean for doing the pushAway without animation
	pushAway: function(immediately) {
		let items = Items.getTopLevelItems();

		// we need at least two top-level items to push something away
		if(items.length < 2) { return; }

		let buffer = Math.floor(Items.defaultGutter / 2);

		// setup each Item's pushAwayData attribute:
		items.forEach(function(item) {
			let data = {};
			data.bounds = item.getBounds();
			data.startBounds = new Rect(data.bounds);
			// Infinity = (as yet) unaffected
			data.generation = Infinity;
			item.pushAwayData = data;
		});

		// The first item is a 0-generation pushed item. It all starts here.
		let itemsToPush = [this];
		this.pushAwayData.generation = 0;

		let pushOne = function(baseItem) {
			// the baseItem is an n-generation pushed item. (n could be 0)
			let baseData = baseItem.pushAwayData;
			let bb = new Rect(baseData.bounds);

			// make the bounds larger, adding a +buffer margin to each side.
			bb.inset(-buffer, -buffer);
			// bbc = center of the base's bounds
			let bbc = bb.center();

			items.forEach(function(item) {
				if(item == baseItem) { return; }

				let data = item.pushAwayData;

				// if the item under consideration has already been pushed, or has a lower
				// "generation" (and thus an implictly greater placement priority) then don't move it.
				if(data.generation <= baseData.generation) { return; }

				// box = this item's current bounds, with a +buffer margin.
				let bounds = data.bounds;
				let box = new Rect(bounds);
				box.inset(-buffer, -buffer);

				// if the item under consideration overlaps with the base item let's push it a little.
				if(box.intersects(bb)) {
					// First, decide in which direction and how far to push. This is the offset.
					let offset = new Point();
					// center = the current item's center.
					let center = box.center();

					// Consider the relationship between the current item (box) + the base item.
					// If it's more vertically stacked than "side by side" push vertically.
					if(Math.abs(center.x - bbc.x) < Math.abs(center.y - bbc.y)) {
						if(center.y > bbc.y) {
							offset.y = bb.bottom - box.top;
						} else {
							offset.y = bb.top - box.bottom;
						}
					}

					// if they're more "side by side" than stacked vertically push horizontally.
					else {
						if(center.x > bbc.x) {
							offset.x = bb.right - box.left;
						} else {
							offset.x = bb.left - box.right;
						}
					}

					// Actually push the Item.
					bounds.offset(offset);

					// This item now becomes an (n+1)-generation pushed item.
					data.generation = baseData.generation +1;

					// keep track of who pushed this item.
					data.pusher = baseItem;

					// add this item to the queue, so that it, in turn, can push some other things.
					itemsToPush.push(item);
				}
			});
		};

		// push each of the itemsToPush, one at a time.
		// itemsToPush starts with just [this], but pushOne can add more items to the stack.
		// Maximally, this could run through all Items on the screen.
		while(itemsToPush.length) {
			pushOne(itemsToPush.shift());
		}

		// ___ Squish!
		let pageBounds = Items.getSafeWindowBounds();
		items.forEach(function(item) {
			let data = item.pushAwayData;
			if(data.generation == 0) { return; }

			let apply = function(item, posStep, posStep2, sizeStep) {
				let data = item.pushAwayData;
				if(data.generation == 0) { return; }

				let bounds = data.bounds;
				bounds.width -= sizeStep.x;
				bounds.height -= sizeStep.y;
				bounds.left += posStep.x;
				bounds.top += posStep.y;

				let validSize;
				if(item.isAGroupItem) {
					validSize = GroupItems.calcValidSize(new Point(bounds.width, bounds.height));
					bounds.width = validSize.x;
					bounds.height = validSize.y;
				} else {
					if(sizeStep.y > sizeStep.x) {
						validSize = TabItems.calcValidSize(new Point(-1, bounds.height));
						bounds.left += (bounds.width - validSize.x) / 2;
						bounds.width = validSize.x;
					} else {
						validSize = TabItems.calcValidSize(new Point(bounds.width, -1));
						bounds.top += (bounds.height - validSize.y) / 2;
						bounds.height = validSize.y;
					}
				}

				let pusher = data.pusher;
				if(pusher) {
					var newPosStep = new Point(posStep.x + posStep2.x, posStep.y + posStep2.y);
					apply(pusher, newPosStep, posStep2, sizeStep);
				}
			};

			let bounds = data.bounds;
			let posStep = new Point();
			let posStep2 = new Point();
			let sizeStep = new Point();

			if(bounds.left < pageBounds.left) {
				posStep.x = pageBounds.left - bounds.left;
				sizeStep.x = posStep.x / data.generation;
				posStep2.x = -sizeStep.x;
			} else if (bounds.right > pageBounds.right) { // this may be less of a problem post-601534
				posStep.x = pageBounds.right - bounds.right;
				sizeStep.x = -posStep.x / data.generation;
				posStep.x += sizeStep.x;
				posStep2.x = sizeStep.x;
			}

			if(bounds.top < pageBounds.top) {
				posStep.y = pageBounds.top - bounds.top;
				sizeStep.y = posStep.y / data.generation;
				posStep2.y = -sizeStep.y;
			} else if (bounds.bottom > pageBounds.bottom) { // this may be less of a problem post-601534
				posStep.y = pageBounds.bottom - bounds.bottom;
				sizeStep.y = -posStep.y / data.generation;
				posStep.y += sizeStep.y;
				posStep2.y = sizeStep.y;
			}

			if(posStep.x || posStep.y || sizeStep.x || sizeStep.y) {
				apply(item, posStep, posStep2, sizeStep);
			}
		});

		// ___ Unsquish
		let pairs = [];
		items.forEach(function(item) {
			let data = item.pushAwayData;
			pairs.push({
				item: item,
				bounds: data.bounds
			});
		});

		Items.unsquish(pairs);

		// ___ Apply changes
		items.forEach(function(item) {
			let data = item.pushAwayData;
			let bounds = data.bounds;
			if(!bounds.equals(data.startBounds)) {
				item.setBounds(bounds, immediately);
			}
		});
	},

	// Sets up/moves the trenches for snapping to this item.
	setTrenches: function(rect) {
		if(this.parent !== null) { return; }

		if(!this.borderTrenches) {
			this.borderTrenches = Trenches.registerWithItem(this,"border");
		}

		let bT = this.borderTrenches;
		Trenches.getById(bT.left).setWithRect(rect);
		Trenches.getById(bT.right).setWithRect(rect);
		Trenches.getById(bT.top).setWithRect(rect);
		Trenches.getById(bT.bottom).setWithRect(rect);

		if(!this.guideTrenches) {
			this.guideTrenches = Trenches.registerWithItem(this,"guide");
		}

		let gT = this.guideTrenches;
		Trenches.getById(gT.left).setWithRect(rect);
		Trenches.getById(gT.right).setWithRect(rect);
		Trenches.getById(gT.top).setWithRect(rect);
		Trenches.getById(gT.bottom).setWithRect(rect);
	},

	// Removes the trenches for snapping to this item.
	removeTrenches: function() {
		for(let edge in this.borderTrenches) {
			Trenches.unregister(this.borderTrenches[edge]); // unregister can take an array
		}
		this.borderTrenches = null;
		for(let edge in this.guideTrenches) {
			Trenches.unregister(this.guideTrenches[edge]); // unregister can take an array
		}
		this.guideTrenches = null;
	},

	// The snap function used during groupItem creation via drag-out
	// Parameters:
	//  immediately - bool for having the drag do the final positioning without animation
	snap: function(immediately) {
		// make the snapping work with a wider range!
		let defaultRadius = Trenches.defaultRadius;
		Trenches.defaultRadius = 2 * defaultRadius; // bump up from 10 to 20!

		let FauxDragInfo = new Drag(this, {});
		FauxDragInfo.snap('none', false);
		FauxDragInfo.stop(immediately);

		Trenches.defaultRadius = defaultRadius;
	},

	// Enables dragging on this item. Note: not to be called multiple times on the same item!
	draggable: function() {
		try {
			let cancelClasses = [];
			if(typeof this.dragOptions.cancelClass == 'string') {
				cancelClasses = this.dragOptions.cancelClass.split(' ');
			}

			let $container = iQ(this.container);
			let startMouse;
			let startPos;
			let startSent;
			let startEvent;
			let droppables;
			let dropTarget;

			// determine the best drop target based on the current mouse coordinates
			let determineBestDropTarget = (e, box) => {
				// drop events
				let best = {
					dropTarget: null,
					score: 0
				};

				droppables.forEach((droppable) => {
					let intersection = box.intersection(droppable.bounds);
					if(intersection && intersection.area() > best.score) {
						let possibleDropTarget = droppable.item;
						let accept = true;
						if(possibleDropTarget != dropTarget) {
							let dropOptions = possibleDropTarget.dropOptions;
							if(dropOptions && typeof dropOptions.accept == "function") {
								accept = dropOptions.accept.apply(possibleDropTarget, [this]);
							}
						}

						if(accept) {
							best.dropTarget = possibleDropTarget;
							best.score = intersection.area();
						}
					}
				});

				return best.dropTarget;
			}

			// ___ mousemove
			let handleMouseMove = (e) => {
				// global drag tracking
				drag.lastMoveTime = Date.now();

				// positioning
				let mouse = new Point(e.pageX, e.pageY);
				if(!startSent) {
					if(Math.abs(mouse.x - startMouse.x) > this.dragOptions.minDragDistance
					|| Math.abs(mouse.y - startMouse.y) > this.dragOptions.minDragDistance) {
						if(typeof this.dragOptions.start == "function") {
							this.dragOptions.start.apply(this, [ startEvent, { position: { left: startPos.x, top: startPos.y } } ]);
						}
						startSent = true;
					}
				}
				if(startSent) {
					// drag events
					let box = this.getBounds();
					box.left = startPos.x + (mouse.x - startMouse.x);
					box.top = startPos.y + (mouse.y - startMouse.y);
					this.setBounds(box, true);

					if(typeof this.dragOptions.drag == "function") {
						this.dragOptions.drag.apply(this, [e]);
					}

					let bestDropTarget = determineBestDropTarget(e, box);

					if(bestDropTarget != dropTarget) {
						let dropOptions;
						if(dropTarget) {
							dropOptions = dropTarget.dropOptions;
							if(dropOptions && typeof dropOptions.out == "function") {
								dropOptions.out.apply(dropTarget, [e]);
							}
						}

						dropTarget = bestDropTarget;

						if(dropTarget) {
							dropOptions = dropTarget.dropOptions;
							if(dropOptions && typeof dropOptions.over == "function") {
								dropOptions.over.apply(dropTarget, [e]);
							}
						}
					}
					if(dropTarget) {
						dropOptions = dropTarget.dropOptions;
						if(dropOptions && typeof dropOptions.move == "function") {
							dropOptions.move.apply(dropTarget, [e]);
						}
					}
				}

				e.preventDefault();
			};

			// ___ mouseup
			let handleMouseUp = (e) => {
				iQ(gWindow).unbind('mousemove', handleMouseMove).unbind('mouseup', handleMouseUp);

				if(startSent && dropTarget) {
					let dropOptions = dropTarget.dropOptions;
					if(dropOptions && typeof dropOptions.drop == "function") {
						dropOptions.drop.apply(dropTarget, [e]);
					}
				}

				if(startSent && typeof this.dragOptions.stop == "function") {
					this.dragOptions.stop.apply(this, [e]);
				}

				e.preventDefault();
			};

			// ___ mousedown
			$container.mousedown((e) => {
				if(e.button != 0) { return; }

				let cancel = false;
				let $target = iQ(e.target);
				cancelClasses.forEach(function(className) {
					if($target.hasClass(className)) {
						cancel = true;
					}
				});

				if(cancel) {
					e.preventDefault();
					return;
				}

				startMouse = new Point(e.pageX, e.pageY);
				let bounds = this.getBounds();
				startPos = bounds.position();
				startEvent = e;
				startSent = false;

				droppables = [];
				iQ('.iq-droppable').each(function(elem) {
					if(elem != this.container) {
						let item = Items.item(elem);
						droppables.push({
							item: item,
							bounds: item.getBounds()
						});
					}
				});

				dropTarget = determineBestDropTarget(e, bounds);

				iQ(gWindow).mousemove(handleMouseMove).mouseup(handleMouseUp);

				e.preventDefault();
			});
		}
		catch(ex) {
			Cu.reportError(ex);
		}
	},

	// Enables or disables dropping on this item.
	droppable: function(value) {
		try {
			let $container = iQ(this.container);
			if(value) {
				$container.addClass('iq-droppable');
			} else {
				$container.removeClass('iq-droppable');
			}
		}
		catch(ex) {
			Cu.reportError(ex);
		}
	},

	// Enables or disables resizing of this item.
	resizable: function(value) {
		try {
			let $container = iQ(this.container);
			iQ('.iq-resizable-handle', $container).remove();

			if(!value) {
				$container.removeClass('iq-resizable');
			} else {
				$container.addClass('iq-resizable');

				let startMouse;
				let startSize;
				let startAspect;

				// ___ mousemove
				let handleMouseMove = (e) => {
					// global resize tracking
					resize.lastMoveTime = Date.now();

					let mouse = new Point(e.pageX, e.pageY);
					let box = this.getBounds();
					if(UI.rtl) {
						let minWidth = (this.resizeOptions.minWidth || 0);
						let oldWidth = box.width;
						if(minWidth != oldWidth || mouse.x < startMouse.x) {
							box.width = Math.max(minWidth, startSize.x - (mouse.x - startMouse.x));
							box.left -= box.width - oldWidth;
						}
					} else {
						box.width = Math.max(this.resizeOptions.minWidth || 0, startSize.x + (mouse.x - startMouse.x));
					}
					box.height = Math.max(this.resizeOptions.minHeight || 0, startSize.y + (mouse.y - startMouse.y));

					if(this.resizeOptions.aspectRatio) {
						if(startAspect < 1) {
							box.height = box.width * startAspect;
						} else {
							box.width = box.height / startAspect;
						}
					}

					this.setBounds(box, true);

					if(typeof this.resizeOptions.resize == "function") {
						this.resizeOptions.resize(e);
					}

					e.preventDefault();
					e.stopPropagation();
				};

				// ___ mouseup
				let handleMouseUp = (e) => {
					iQ(gWindow).unbind('mousemove', handleMouseMove).unbind('mouseup', handleMouseUp);

					if(typeof this.resizeOptions.stop == "function") {
						this.resizeOptions.stop(e);
					}

					e.preventDefault();
					e.stopPropagation();
				};

				// ___ handle + mousedown
				iQ('<div>')
					.addClass('iq-resizable-handle iq-resizable-se')
					.appendTo($container)
					.mousedown((e) => {
						if(e.button != 0) { return; }

						startMouse = new Point(e.pageX, e.pageY);
						startSize = this.getBounds().size();
						startAspect = startSize.y / startSize.x;

						if(typeof this.resizeOptions.start == "function") {
							this.resizeOptions.start(e);
						}

						iQ(gWindow).mousemove(handleMouseMove).mouseup(handleMouseUp);

						e.preventDefault();
						e.stopPropagation();
					});
			}
		}
		catch(ex) {
			Cu.reportError(ex);
		}
	}
};

// Class: Items - Keeps track of all Items.
this.Items = {
	// How far apart Items should be from each other and from bounds
	defaultGutter: 15,

	// Given a DOM element representing an Item, returns the Item.
	item: function(el) {
		return iQ(el).data('item');
	},

	// Returns an array of all Items not grouped into groupItems.
	getTopLevelItems: function() {
		let items = [];

		iQ('.tab, .groupItem').each(function(elem) {
			let $this = iQ(elem);
			let item = $this.data('item');
			if(item && !item.parent && !$this.hasClass('phantom')) {
				items.push(item);
			}
		});

		return items;
	},

	// Returns a <Rect> defining the area of the page <Item>s should stay within.
	getPageBounds: function() {
		let width = Math.max(100, window.innerWidth);
		let height = Math.max(100, window.innerHeight);
		return new Rect(0, 0, width, height);
	},

	// Returns the bounds within which it is safe to place all non-stationary <Item>s.
	getSafeWindowBounds: function() {
		// the safe bounds that would keep it "in the window"
		let gutter = Items.defaultGutter;

		// Here, I've set the top gutter separately, as the top of the window has its own extra chrome which makes a large top gutter unnecessary.
		// TODO: set top gutter separately, elsewhere.
		let topGutter = 5;
		return new Rect(gutter, topGutter, window.innerWidth - 2 * gutter, window.innerHeight - gutter - topGutter);
	},

	// Arranges the given items in a grid within the given bounds, maximizing item size but maintaining standard tab aspect ratio for each
	// Parameters:
	//   items - an array of <Item>s. Can be null, in which case we won't actually move anything.
	//   bounds - a <Rect> defining the space to arrange within
	//   options - an object with various properites (see below)
	// Possible "options" properties:
	//   animate - whether to animate; default: true.
	//   z - the z index to set all the items; default: don't change z.
	//   return - if set to 'widthAndColumns', it'll return an object with the width of children and the columns.
	//   count - overrides the item count for layout purposes; default: the actual item count
	//   columns - (int) a preset number of columns to use
	//   dropPos - a <Point> which should have a one-tab space left open, used when a tab is dragged over.
	// Returns:
	//   By default, an object with three properties: `rects`, the list of <Rect>s, `dropIndex`, the index which a dragged tab should have if dropped
	//   (null if no `dropPos` was specified), and the number of columns (`columns`). If the `return` option is set to 'widthAndColumns', an object with the
	//   width value of the child items (`childWidth`) and the number of columns (`columns`) is returned.
	arrange: function(items, bounds, options) {
		if(!options) {
			options = {};
		}
		let animate = "animate" in options ? options.animate : true;
		let immediately = !animate;

		let rects = [];

		let count = options.count || (items ? items.length : 0);
		if(options.addTab) {
			count++;
		}
		if(!count) {
			let dropIndex = (Utils.isPoint(options.dropPos)) ? 0 : null;
			return { rects: rects, dropIndex: dropIndex };
		}

		let columns = options.columns || 1;
		// We'll assume for the time being that all the items have the same styling and that the margin is the same width around.
		let itemMargin = items && items.length ? parseInt(iQ(items[0].container).css('margin-left')) : 0;
		let padding = itemMargin * 2;
		let rows;
		let tabWidth;
		let tabHeight;
		let totalHeight;

		let figure = function() {
			rows = Math.ceil(count / columns);
			let validSize = TabItems.calcValidSize(new Point((bounds.width - (padding * columns)) / columns, -1), options);
			tabWidth = validSize.x;
			tabHeight = validSize.y;

			totalHeight = (tabHeight * rows) + (padding * rows);
		}

		figure();
		while(rows > 1 && totalHeight > bounds.height) {
			columns++;
			figure();
		}

		if(rows == 1) {
			let validSize = TabItems.calcValidSize(new Point(tabWidth, bounds.height - 2 * itemMargin), options);
			tabWidth = validSize.x;
			tabHeight = validSize.y;
		}

		if(options.return == 'widthAndColumns') {
			return { childWidth: tabWidth, columns: columns };
		}

		let initialOffset = 0;
		if(UI.rtl) {
			initialOffset = bounds.width - tabWidth - padding;
		}
		let box = new Rect(bounds.left + initialOffset, bounds.top, tabWidth, tabHeight);

		let column = 0;

		let dropIndex = false;
		let dropRect = false;
		if(Utils.isPoint(options.dropPos)) {
			dropRect = new Rect(options.dropPos.x, options.dropPos.y, 1, 1);
		}

		for(let a = 0; a < count; a++) {
			// If we had a dropPos, see if this is where we should place it
			if(dropRect) {
				let activeBox = new Rect(box);
				activeBox.inset(-itemMargin - 1, -itemMargin - 1);
				// if the designated position (dropRect) is within the active box, this is where, if we drop the tab being dragged, it should land!
				if(activeBox.contains(dropRect)) {
					dropIndex = a;
				}
			}

			// record the box.
			rects.push(new Rect(box));

			box.left += (UI.rtl ? -1 : 1) * (box.width + padding);
			column++;
			if(column == columns) {
				box.left = bounds.left + initialOffset;
				box.top += box.height + padding;
				column = 0;
			}
		}

		return { rects: rects, dropIndex: dropIndex, columns: columns };
	},

	// Checks to see which items can now be unsquished.
	// Parameters:
	//   pairs - an array of objects, each with two properties: item and bounds. The bounds are modified as appropriate, but the items are not changed.
	//     If pairs is null, the operation is performed directly on all of the top level items.
	//   ignore - an <Item> to not include in calculations (because it's about to be closed, for instance)
	unsquish: function(pairs, ignore) {
		let pairsProvided = (pairs ? true : false);
		if(!pairsProvided) {
			let items = Items.getTopLevelItems();
			pairs = [];
			items.forEach(function(item) {
				pairs.push({
					item: item,
					bounds: item.getBounds()
				});
			});
		}

		let pageBounds = Items.getSafeWindowBounds();
		pairs.forEach(function(pair) {
			let item = pair.item;
			if(item == ignore) { return; }

			let bounds = pair.bounds;
			let newBounds = new Rect(bounds);

			let newSize;
			if(Utils.isPoint(item.userSize)) {
				newSize = new Point(item.userSize);
			} else if(item.isAGroupItem) {
				newSize = GroupItems.calcValidSize(new Point(GroupItems.minGroupWidth, -1));
			} else {
				newSize = TabItems.calcValidSize( new Point(TabItems.tabWidth, -1));
			}

			if(item.isAGroupItem) {
				newBounds.width = Math.max(newBounds.width, newSize.x);
				newBounds.height = Math.max(newBounds.height, newSize.y);
			}
			else if(bounds.width < newSize.x) {
				newBounds.width = newSize.x;
				newBounds.height = newSize.y;
			}

			newBounds.left -= (newBounds.width - bounds.width) / 2;
			newBounds.top -= (newBounds.height - bounds.height) / 2;

			let offset = new Point();
			if(newBounds.left < pageBounds.left) {
				offset.x = pageBounds.left - newBounds.left;
			} else if(newBounds.right > pageBounds.right) {
				offset.x = pageBounds.right - newBounds.right;
			}

			if(newBounds.top < pageBounds.top) {
				offset.y = pageBounds.top - newBounds.top;
			} else if(newBounds.bottom > pageBounds.bottom) {
				offset.y = pageBounds.bottom - newBounds.bottom;
			}

			newBounds.offset(offset);

			if(!bounds.equals(newBounds)) {
				let blocked = false;
				pairs.forEach(function(pair2) {
					if(pair2 == pair || pair2.item == ignore) { return; }

					let bounds2 = pair2.bounds;
					if(bounds2.intersects(newBounds)) {
						blocked = true;
					}
				});

				if(!blocked) {
					pair.bounds.copy(newBounds);
				}
			}
		});

		if(!pairsProvided) {
			pairs.forEach(function(pair) {
				pair.item.setBounds(pair.bounds);
			});
		}
	}
};
