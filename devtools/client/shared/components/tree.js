/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */
/* eslint-env browser */
"use strict";

const React = require("devtools/client/shared/vendor/react");
const { DOM: dom, createClass, createFactory, PropTypes } = React;

const AUTO_EXPAND_DEPTH = 0;
const NUMBER_OF_OFFSCREEN_ITEMS = 1;

/**
 * A fast, generic, expandable and collapsible tree component.
 *
 * This tree component is fast: it can handle trees with *many* items. It only
 * renders the subset of those items which are visible in the viewport. It's
 * been battle tested on huge trees in the memory panel. We've optimized tree
 * traversal and rendering, even in the presence of cross-compartment wrappers.
 *
 * This tree component doesn't make any assumptions about the structure of your
 * tree data. Whether children are computed on demand, or stored in an array in
 * the parent's `_children` property, it doesn't matter. We only require the
 * implementation of `getChildren`, `getRoots`, `getParent`, and `isExpanded`
 * functions.
 *
 * This tree component is well tested and reliable. See
 * devtools/client/shared/components/test/mochitest/test_tree_* and its usage in
 * the performance and memory panels.
 *
 * This tree component doesn't make any assumptions about how to render items in
 * the tree. You provide a `renderItem` function, and this component will ensure
 * that only those items whose parents are expanded and which are visible in the
 * viewport are rendered. The `renderItem` function could render the items as a
 * "traditional" tree or as rows in a table or anything else. It doesn't
 * restrict you to only one certain kind of tree.
 *
 * The only requirement is that every item in the tree render as the same
 * height. This is required in order to compute which items are visible in the
 * viewport in constant time.
 *
 * ### Example Usage
 *
 * Suppose we have some tree data where each item has this form:
 *
 *     {
 *       id: Number,
 *       label: String,
 *       parent: Item or null,
 *       children: Array of child items,
 *       expanded: bool,
 *     }
 *
 * Here is how we could render that data with this component:
 *
 *     const MyTree = createClass({
 *       displayName: "MyTree",
 *
 *       propTypes: {
 *         // The root item of the tree, with the form described above.
 *         root: PropTypes.object.isRequired
 *       },
 *
 *       render() {
 *         return Tree({
 *           itemHeight: 20, // px
 *
 *           getRoots: () => [this.props.root],
 *
 *           getParent: item => item.parent,
 *           getChildren: item => item.children,
 *           getKey: item => item.id,
 *           isExpanded: item => item.expanded,
 *
 *           renderItem: (item, depth, isFocused, arrow, isExpanded) => {
 *             let className = "my-tree-item";
 *             if (isFocused) {
 *               className += " focused";
 *             }
 *             return dom.div(
 *               {
 *                 className,
 *                 // Apply 10px nesting per expansion depth.
 *                 style: { marginLeft: depth * 10 + "px" }
 *               },
 *               // Here is the expando arrow so users can toggle expansion and
 *               // collapse state.
 *               arrow,
 *               // And here is the label for this item.
 *               dom.span({ className: "my-tree-item-label" }, item.label)
 *             );
 *           },
 *
 *           onExpand: item => dispatchExpandActionToRedux(item),
 *           onCollapse: item => dispatchCollapseActionToRedux(item),
 *         });
 *       }
 *     });
 */
module.exports = createClass({
  displayName: "Tree",

  propTypes: {
    // Required props

    // A function to get an item's parent, or null if it is a root.
    //
    // Type: getParent(item: Item) -> Maybe<Item>
    //
    // Example:
    //
    //     // The parent of this item is stored in its `parent` property.
    //     getParent: item => item.parent
    getParent: PropTypes.func.isRequired,

    // A function to get an item's children.
    //
    // Type: getChildren(item: Item) -> [Item]
    //
    // Example:
    //
    //     // This item's children are stored in its `children` property.
    //     getChildren: item => item.children
    getChildren: PropTypes.func.isRequired,

    // A function which takes an item and ArrowExpander component instance and
    // returns a component, or text, or anything else that React considers
    // renderable.
    //
    // Type: renderItem(item: Item,
    //                  depth: Number,
    //                  isFocused: Boolean,
    //                  arrow: ReactComponent,
    //                  isExpanded: Boolean) -> ReactRenderable
    //
    // Example:
    //
    //     renderItem: (item, depth, isFocused, arrow, isExpanded) => {
    //       let className = "my-tree-item";
    //       if (isFocused) {
    //         className += " focused";
    //       }
    //       return dom.div(
    //         {
    //           className,
    //           style: { marginLeft: depth * 10 + "px" }
    //         },
    //         arrow,
    //         dom.span({ className: "my-tree-item-label" }, item.label)
    //       );
    //     },
    renderItem: PropTypes.func.isRequired,

    // A function which returns the roots of the tree (forest).
    //
    // Type: getRoots() -> [Item]
    //
    // Example:
    //
    //     // In this case, we only have one top level, root item. You could
    //     // return multiple items if you have many top level items in your
    //     // tree.
    //     getRoots: () => [this.props.rootOfMyTree]
    getRoots: PropTypes.func.isRequired,

    // A function to get a unique key for the given item. This helps speed up
    // React's rendering a *TON*.
    //
    // Type: getKey(item: Item) -> String
    //
    // Example:
    //
    //     getKey: item => `my-tree-item-${item.uniqueId}`
    getKey: PropTypes.func.isRequired,

    // A function to get whether an item is expanded or not. If an item is not
    // expanded, then it must be collapsed.
    //
    // Type: isExpanded(item: Item) -> Boolean
    //
    // Example:
    //
    //     isExpanded: item => item.expanded,
    isExpanded: PropTypes.func.isRequired,

    // The height of an item in the tree including margin and padding, in
    // pixels.
    itemHeight: PropTypes.number.isRequired,

    // Optional props

    // The currently focused item, if any such item exists.
    focused: PropTypes.any,

    // Handle when a new item is focused.
    onFocus: PropTypes.func,

    // The depth to which we should automatically expand new items.
    autoExpandDepth: PropTypes.number,

    // Note: the two properties below are mutually exclusive. Only one of the
    // label properties is necessary.
    // ID of an element whose textual content serves as an accessible label for
    // a tree.
    labelledby: PropTypes.string,
    // Accessibility label for a tree widget.
    label: PropTypes.string,

    // Optional event handlers for when items are expanded or collapsed. Useful
    // for dispatching redux events and updating application state, maybe lazily
    // loading subtrees from a worker, etc.
    //
    // Type:
    //     onExpand(item: Item)
    //     onCollapse(item: Item)
    //
    // Example:
    //
    //     onExpand: item => dispatchExpandActionToRedux(item)
    onExpand: PropTypes.func,
    onCollapse: PropTypes.func,
  },

  getDefaultProps() {
    return {
      autoExpandDepth: AUTO_EXPAND_DEPTH,
    };
  },

  getInitialState() {
    return {
      scroll: 0,
      height: window.innerHeight,
      seen: new Set(),
    };
  },

  componentDidMount() {
    window.addEventListener("resize", this._updateHeight);
    this._autoExpand();
    this._updateHeight();
  },

  componentWillReceiveProps(nextProps) {
    this._autoExpand();
    this._updateHeight();
  },

  componentWillUnmount() {
    window.removeEventListener("resize", this._updateHeight);
  },

  _autoExpand() {
    if (!this.props.autoExpandDepth) {
      return;
    }

    // Automatically expand the first autoExpandDepth levels for new items. Do
    // not use the usual DFS infrastructure because we don't want to ignore
    // collapsed nodes.
    const autoExpand = (item, currentDepth) => {
      if (currentDepth >= this.props.autoExpandDepth ||
          this.state.seen.has(item)) {
        return;
      }

      this.props.onExpand(item);
      this.state.seen.add(item);

      const children = this.props.getChildren(item);
      const length = children.length;
      for (let i = 0; i < length; i++) {
        autoExpand(children[i], currentDepth + 1);
      }
    };

    const roots = this.props.getRoots();
    const length = roots.length;
    for (let i = 0; i < length; i++) {
      autoExpand(roots[i], 0);
    }
  },

  _preventArrowKeyScrolling(e) {
    switch (e.key) {
      case "ArrowUp":
      case "ArrowDown":
      case "ArrowLeft":
      case "ArrowRight":
        e.preventDefault();
        e.stopPropagation();
        if (e.nativeEvent) {
          if (e.nativeEvent.preventDefault) {
            e.nativeEvent.preventDefault();
          }
          if (e.nativeEvent.stopPropagation) {
            e.nativeEvent.stopPropagation();
          }
        }
    }
  },

  /**
   * Updates the state's height based on clientHeight.
   */
  _updateHeight() {
    this.setState({
      height: this.refs.tree.clientHeight
    });
  },

  /**
   * Perform a pre-order depth-first search from item.
   */
  _dfs(item, maxDepth = Infinity, traversal = [], _depth = 0) {
    traversal.push({ item, depth: _depth });

    if (!this.props.isExpanded(item)) {
      return traversal;
    }

    const nextDepth = _depth + 1;

    if (nextDepth > maxDepth) {
      return traversal;
    }

    const children = this.props.getChildren(item);
    const length = children.length;
    for (let i = 0; i < length; i++) {
      this._dfs(children[i], maxDepth, traversal, nextDepth);
    }

    return traversal;
  },

  /**
   * Perform a pre-order depth-first search over the whole forest.
   */
  _dfsFromRoots(maxDepth = Infinity) {
    const traversal = [];

    const roots = this.props.getRoots();
    const length = roots.length;
    for (let i = 0; i < length; i++) {
      this._dfs(roots[i], maxDepth, traversal);
    }

    return traversal;
  },

  /**
   * Expands current row.
   *
   * @param {Object} item
   * @param {Boolean} expandAllChildren
   */
  _onExpand: oncePerAnimationFrame(function (item, expandAllChildren) {
    if (this.props.onExpand) {
      this.props.onExpand(item);

      if (expandAllChildren) {
        const children = this._dfs(item);
        const length = children.length;
        for (let i = 0; i < length; i++) {
          this.props.onExpand(children[i].item);
        }
      }
    }
  }),

  /**
   * Collapses current row.
   *
   * @param {Object} item
   */
  _onCollapse: oncePerAnimationFrame(function (item) {
    if (this.props.onCollapse) {
      this.props.onCollapse(item);
    }
  }),

  /**
   * Sets the passed in item to be the focused item.
   *
   * @param {Number} index
   *        The index of the item in a full DFS traversal (ignoring collapsed
   *        nodes). Ignored if `item` is undefined.
   *
   * @param {Object|undefined} item
   *        The item to be focused, or undefined to focus no item.
   */
  _focus(index, item) {
    if (item !== undefined) {
      const itemStartPosition = index * this.props.itemHeight;
      const itemEndPosition = (index + 1) * this.props.itemHeight;

      // Note that if the height of the viewport (this.state.height) is less
      // than `this.props.itemHeight`, we could accidentally try and scroll both
      // up and down in a futile attempt to make both the item's start and end
      // positions visible. Instead, give priority to the start of the item by
      // checking its position first, and then using an "else if", rather than
      // a separate "if", for the end position.
      if (this.state.scroll > itemStartPosition) {
        this.refs.tree.scrollTo(0, itemStartPosition);
      } else if ((this.state.scroll + this.state.height) < itemEndPosition) {
        this.refs.tree.scrollTo(0, itemEndPosition - this.state.height);
      }
    }

    if (this.props.onFocus) {
      this.props.onFocus(item);
    }
  },

  /**
   * Sets the state to have no focused item.
   */
  _onBlur() {
    this._focus(0, undefined);
  },

  /**
   * Fired on a scroll within the tree's container, updates
   * the stored position of the view port to handle virtual view rendering.
   *
   * @param {Event} e
   */
  _onScroll: oncePerAnimationFrame(function (e) {
    this.setState({
      scroll: Math.max(this.refs.tree.scrollTop, 0),
      height: this.refs.tree.clientHeight
    });
  }),

  /**
   * Handles key down events in the tree's container.
   *
   * @param {Event} e
   */
  _onKeyDown(e) {
    if (this.props.focused == null) {
      return;
    }

    // Allow parent nodes to use navigation arrows with modifiers.
    if (e.altKey || e.ctrlKey || e.shiftKey || e.metaKey) {
      return;
    }

    this._preventArrowKeyScrolling(e);

    switch (e.key) {
      case "ArrowUp":
        this._focusPrevNode();
        break;

      case "ArrowDown":
        this._focusNextNode();
        break;

      case "ArrowLeft":
        if (this.props.isExpanded(this.props.focused)
            && this.props.getChildren(this.props.focused).length) {
          this._onCollapse(this.props.focused);
        } else {
          this._focusParentNode();
        }
        break;

      case "ArrowRight":
        if (!this.props.isExpanded(this.props.focused)) {
          this._onExpand(this.props.focused);
        } else {
          this._focusNextNode();
        }
        break;
    }
  },

  /**
   * Sets the previous node relative to the currently focused item, to focused.
   */
  _focusPrevNode: oncePerAnimationFrame(function () {
    // Start a depth first search and keep going until we reach the currently
    // focused node. Focus the previous node in the DFS, if it exists. If it
    // doesn't exist, we're at the first node already.

    let prev;
    let prevIndex;

    const traversal = this._dfsFromRoots();
    const length = traversal.length;
    for (let i = 0; i < length; i++) {
      const item = traversal[i].item;
      if (item === this.props.focused) {
        break;
      }
      prev = item;
      prevIndex = i;
    }

    if (prev === undefined) {
      return;
    }

    this._focus(prevIndex, prev);
  }),

  /**
   * Handles the down arrow key which will focus either the next child
   * or sibling row.
   */
  _focusNextNode: oncePerAnimationFrame(function () {
    // Start a depth first search and keep going until we reach the currently
    // focused node. Focus the next node in the DFS, if it exists. If it
    // doesn't exist, we're at the last node already.

    const traversal = this._dfsFromRoots();
    const length = traversal.length;
    let i = 0;

    while (i < length) {
      if (traversal[i].item === this.props.focused) {
        break;
      }
      i++;
    }

    if (i + 1 < traversal.length) {
      this._focus(i + 1, traversal[i + 1].item);
    }
  }),

  /**
   * Handles the left arrow key, going back up to the current rows'
   * parent row.
   */
  _focusParentNode: oncePerAnimationFrame(function () {
    const parent = this.props.getParent(this.props.focused);
    if (!parent) {
      return;
    }

    const traversal = this._dfsFromRoots();
    const length = traversal.length;
    let parentIndex = 0;
    for (; parentIndex < length; parentIndex++) {
      if (traversal[parentIndex].item === parent) {
        break;
      }
    }

    this._focus(parentIndex, parent);
  }),

  render() {
    const traversal = this._dfsFromRoots();

    // 'begin' and 'end' are the index of the first (at least partially) visible item
    // and the index after the last (at least partially) visible item, respectively.
    // `NUMBER_OF_OFFSCREEN_ITEMS` is removed from `begin` and added to `end` so that
    // the top and bottom of the page are filled with the `NUMBER_OF_OFFSCREEN_ITEMS`
    // previous and next items respectively, which helps the user to see fewer empty
    // gaps when scrolling quickly.
    const { itemHeight, focused } = this.props;
    const { scroll, height } = this.state;
    const begin = Math.max(((scroll / itemHeight) | 0) - NUMBER_OF_OFFSCREEN_ITEMS, 0);
    const end = Math.ceil((scroll + height) / itemHeight) + NUMBER_OF_OFFSCREEN_ITEMS;
    const toRender = traversal.slice(begin, end);
    const topSpacerHeight = begin * itemHeight;
    const bottomSpacerHeight = Math.max(traversal.length - end, 0) * itemHeight;

    const nodes = [
      dom.div({
        key: "top-spacer",
        role: "presentation",
        style: {
          padding: 0,
          margin: 0,
          height: topSpacerHeight + "px"
        }
      })
    ];

    for (let i = 0; i < toRender.length; i++) {
      const index = begin + i;
      const first = index == 0;
      const last = index == traversal.length - 1;
      const { item, depth } = toRender[i];
      const key = this.props.getKey(item);
      nodes.push(TreeNode({
        key,
        index,
        first,
        last,
        item,
        depth,
        id: key,
        renderItem: this.props.renderItem,
        focused: focused === item,
        expanded: this.props.isExpanded(item),
        hasChildren: !!this.props.getChildren(item).length,
        onExpand: this._onExpand,
        onCollapse: this._onCollapse,
        onClick: () => this._focus(begin + i, item),
      }));
    }

    nodes.push(dom.div({
      key: "bottom-spacer",
      role: "presentation",
      style: {
        padding: 0,
        margin: 0,
        height: bottomSpacerHeight + "px"
      }
    }));

    return dom.div(
      {
        className: "tree",
        ref: "tree",
        role: "tree",
        tabIndex: "0",
        onKeyDown: this._onKeyDown,
        onKeyPress: this._preventArrowKeyScrolling,
        onKeyUp: this._preventArrowKeyScrolling,
        onScroll: this._onScroll,
        onFocus: ({nativeEvent}) => {
          if (focused || !nativeEvent || !this.refs.tree) {
            return;
          }

          let { explicitOriginalTarget } = nativeEvent;
          // Only set default focus to the first tree node if the focus came
          // from outside the tree (e.g. by tabbing to the tree from other
          // external elements).
          if (explicitOriginalTarget !== this.refs.tree &&
              !this.refs.tree.contains(explicitOriginalTarget)) {
            this._focus(begin, toRender[0].item);
          }
        },
        onClick: () => {
          // Focus should always remain on the tree container itself.
          this.refs.tree.focus();
        },
        "aria-label": this.props.label,
        "aria-labelledby": this.props.labelledby,
        "aria-activedescendant": focused && this.props.getKey(focused),
        style: {
          padding: 0,
          margin: 0
        }
      },
      nodes
    );
  }
});

/**
 * An arrow that displays whether its node is expanded (▼) or collapsed
 * (▶). When its node has no children, it is hidden.
 */
const ArrowExpander = createFactory(createClass({
  displayName: "ArrowExpander",

  propTypes: {
    item: PropTypes.any.isRequired,
    visible: PropTypes.bool.isRequired,
    expanded: PropTypes.bool.isRequired,
    onCollapse: PropTypes.func.isRequired,
    onExpand: PropTypes.func.isRequired,
  },

  shouldComponentUpdate(nextProps, nextState) {
    return this.props.item !== nextProps.item
      || this.props.visible !== nextProps.visible
      || this.props.expanded !== nextProps.expanded;
  },

  render() {
    const attrs = {
      className: "arrow theme-twisty",
      onClick: this.props.expanded
        ? () => this.props.onCollapse(this.props.item)
        : e => this.props.onExpand(this.props.item, e.altKey)
    };

    if (this.props.expanded) {
      attrs.className += " open";
    }

    if (!this.props.visible) {
      attrs.style = {
        visibility: "hidden"
      };
    }

    return dom.div(attrs);
  }
}));

const TreeNode = createFactory(createClass({
  propTypes: {
    id: PropTypes.any.isRequired,
    focused: PropTypes.bool.isRequired,
    item: PropTypes.any.isRequired,
    expanded: PropTypes.bool.isRequired,
    hasChildren: PropTypes.bool.isRequired,
    onExpand: PropTypes.func.isRequired,
    index: PropTypes.number.isRequired,
    first: PropTypes.bool,
    last: PropTypes.bool,
    onClick: PropTypes.func,
    onCollapse: PropTypes.func.isRequired,
    depth: PropTypes.number.isRequired,
    renderItem: PropTypes.func.isRequired,
  },

  render() {
    const arrow = ArrowExpander({
      item: this.props.item,
      expanded: this.props.expanded,
      visible: this.props.hasChildren,
      onExpand: this.props.onExpand,
      onCollapse: this.props.onCollapse,
    });

    let classList = [ "tree-node", "div" ];
    if (this.props.index % 2) {
      classList.push("tree-node-odd");
    }
    if (this.props.first) {
      classList.push("tree-node-first");
    }
    if (this.props.last) {
      classList.push("tree-node-last");
    }

    let ariaExpanded;
    if (this.props.hasChildren) {
      ariaExpanded = false;
    }
    if (this.props.expanded) {
      ariaExpanded = true;
    }

    return dom.div(
      {
        id: this.props.id,
        className: classList.join(" "),
        role: "treeitem",
        "aria-level": this.props.depth,
        onClick: this.props.onClick,
        "aria-expanded": ariaExpanded,
        "data-expanded": this.props.expanded ? "" : undefined,
        "data-depth": this.props.depth,
        style: {
          padding: 0,
          margin: 0
        }
      },

      this.props.renderItem(this.props.item,
                            this.props.depth,
                            this.props.focused,
                            arrow,
                            this.props.expanded),
    );
  }
}));

/**
 * Create a function that calls the given function `fn` only once per animation
 * frame.
 *
 * @param {Function} fn
 * @returns {Function}
 */
function oncePerAnimationFrame(fn) {
  let animationId = null;
  let argsToPass = null;
  return function (...args) {
    argsToPass = args;
    if (animationId !== null) {
      return;
    }

    animationId = requestAnimationFrame(() => {
      fn.call(this, ...argsToPass);
      animationId = null;
      argsToPass = null;
    });
  };
}
