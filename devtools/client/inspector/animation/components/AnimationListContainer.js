/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

const {
  createFactory,
  PureComponent,
} = require("devtools/client/shared/vendor/react");
const { connect } = require("devtools/client/shared/vendor/react-redux");
const dom = require("devtools/client/shared/vendor/react-dom-factories");
const PropTypes = require("devtools/client/shared/vendor/react-prop-types");
const ReactDOM = require("devtools/client/shared/vendor/react-dom");

const AnimationList = createFactory(
  require("devtools/client/inspector/animation/components/AnimationList")
);
const CurrentTimeScrubber = createFactory(
  require("devtools/client/inspector/animation/components/CurrentTimeScrubber")
);
const ProgressInspectionPanel = createFactory(
  require("devtools/client/inspector/animation/components/ProgressInspectionPanel")
);

const {
  findOptimalTimeInterval,
} = require("devtools/client/inspector/animation/utils/utils");
const { getStr } = require("devtools/client/inspector/animation/utils/l10n");

// The minimum spacing between 2 time graduation headers in the timeline (px).
const TIME_GRADUATION_MIN_SPACING = 40;

class AnimationListContainer extends PureComponent {
  static get propTypes() {
    return {
      addAnimationsCurrentTimeListener: PropTypes.func.isRequired,
      animations: PropTypes.arrayOf(PropTypes.object).isRequired,
      direction: PropTypes.string.isRequired,
      emitEventForTest: PropTypes.func.isRequired,
      getAnimatedPropertyMap: PropTypes.func.isRequired,
      getNodeFromActor: PropTypes.func.isRequired,
      onHideBoxModelHighlighter: PropTypes.func.isRequired,
      onShowBoxModelHighlighterForNode: PropTypes.func.isRequired,
      removeAnimationsCurrentTimeListener: PropTypes.func.isRequired,
      selectAnimation: PropTypes.func.isRequired,
      setAnimationsCurrentTime: PropTypes.func.isRequired,
      setHighlightedNode: PropTypes.func.isRequired,
      setSelectedNode: PropTypes.func.isRequired,
      sidebarWidth: PropTypes.number.isRequired,
      simulateAnimation: PropTypes.func.isRequired,
      timeScale: PropTypes.object.isRequired,
    };
  }

  constructor(props) {
    super(props);

    this.state = {
      // tick labels and lines on the progress inspection panel
      ticks: [],
    };
  }

  componentDidMount() {
    this.updateState(this.props);
  }

  componentDidUpdate(prevProps) {
    const { timeScale, sidebarWidth } = this.props;

    if (
      timeScale.getDuration() !== prevProps.timeScale.getDuration() ||
      timeScale.zeroPositionTime !== prevProps.timeScale.zeroPositionTime ||
      sidebarWidth !== prevProps.sidebarWidth
    ) {
      this.updateState(this.props);
    }
  }

  updateState(props) {
    const { animations, timeScale } = props;
    const tickLinesEl = ReactDOM.findDOMNode(this).querySelector(".tick-lines");
    const width = tickLinesEl.offsetWidth;
    const animationDuration = timeScale.getDuration();
    const minTimeInterval =
      (TIME_GRADUATION_MIN_SPACING * animationDuration) / width;
    const intervalLength = findOptimalTimeInterval(minTimeInterval);
    const intervalWidth = (intervalLength * width) / animationDuration;
    const tickCount = parseInt(width / intervalWidth, 10);
    const isAllDurationInfinity = animations.every(
      animation => animation.state.duration === Infinity
    );
    const zeroBasePosition =
      width * (timeScale.zeroPositionTime / animationDuration);
    const shiftWidth = zeroBasePosition % intervalWidth;
    const needToShift = zeroBasePosition !== 0 && shiftWidth !== 0;

    const ticks = [];
    // Need to display first graduation since position will be shifted.
    if (needToShift) {
      const label = timeScale.formatTime(timeScale.distanceToRelativeTime(0));
      ticks.push({ position: 0, label, width: shiftWidth });
    }

    for (let i = 0; i <= tickCount; i++) {
      const position = ((i * intervalWidth + shiftWidth) * 100) / width;
      const distance = timeScale.distanceToRelativeTime(position);
      const label =
        isAllDurationInfinity && i === tickCount
          ? getStr("player.infiniteTimeLabel")
          : timeScale.formatTime(distance);
      ticks.push({ position, label, width: intervalWidth });
    }

    this.setState({ ticks });
  }

  render() {
    const {
      addAnimationsCurrentTimeListener,
      animations,
      direction,
      emitEventForTest,
      getAnimatedPropertyMap,
      getNodeFromActor,
      onHideBoxModelHighlighter,
      onShowBoxModelHighlighterForNode,
      removeAnimationsCurrentTimeListener,
      selectAnimation,
      setAnimationsCurrentTime,
      setHighlightedNode,
      setSelectedNode,
      simulateAnimation,
      timeScale,
    } = this.props;
    const { ticks } = this.state;

    return dom.div(
      {
        className: "animation-list-container",
      },
      ProgressInspectionPanel({
        indicator: CurrentTimeScrubber({
          addAnimationsCurrentTimeListener,
          direction,
          removeAnimationsCurrentTimeListener,
          setAnimationsCurrentTime,
          timeScale,
        }),
        list: AnimationList({
          animations,
          emitEventForTest,
          getAnimatedPropertyMap,
          getNodeFromActor,
          onHideBoxModelHighlighter,
          onShowBoxModelHighlighterForNode,
          selectAnimation,
          setHighlightedNode,
          setSelectedNode,
          simulateAnimation,
          timeScale,
        }),
        ticks,
      })
    );
  }
}

const mapStateToProps = state => {
  return {
    sidebarWidth: state.animations.sidebarSize
      ? state.animations.sidebarSize.width
      : 0,
  };
};

module.exports = connect(mapStateToProps)(AnimationListContainer);
