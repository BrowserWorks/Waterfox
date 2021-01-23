/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

const {
  createFactory,
  PureComponent,
} = require("devtools/client/shared/vendor/react");
const dom = require("devtools/client/shared/vendor/react-dom-factories");
const PropTypes = require("devtools/client/shared/vendor/react-prop-types");

const IndicationBar = createFactory(
  require("devtools/client/inspector/animation/components/IndicationBar")
);

class KeyframesProgressBar extends PureComponent {
  static get propTypes() {
    return {
      addAnimationsCurrentTimeListener: PropTypes.func.isRequired,
      animation: PropTypes.object.isRequired,
      getAnimationsCurrentTime: PropTypes.func.isRequired,
      removeAnimationsCurrentTimeListener: PropTypes.func.isRequired,
      simulateAnimationForKeyframesProgressBar: PropTypes.func.isRequired,
      timeScale: PropTypes.object.isRequired,
    };
  }

  constructor(props) {
    super(props);

    this.onCurrentTimeUpdated = this.onCurrentTimeUpdated.bind(this);

    this.state = {
      // position for the progress bar
      position: 0,
    };
  }

  componentDidMount() {
    const { addAnimationsCurrentTimeListener } = this.props;

    this.setupAnimation(this.props);
    addAnimationsCurrentTimeListener(this.onCurrentTimeUpdated);
  }

  componentWillReceiveProps(nextProps) {
    const { animation, getAnimationsCurrentTime, timeScale } = nextProps;

    this.setupAnimation(nextProps);
    this.updateOffset(getAnimationsCurrentTime(), animation, timeScale);
  }

  componentWillUnmount() {
    const { removeAnimationsCurrentTimeListener } = this.props;

    removeAnimationsCurrentTimeListener(this.onCurrentTimeUpdated);
    this.simulatedAnimation = null;
  }

  onCurrentTimeUpdated(currentTime) {
    const { animation, timeScale } = this.props;
    this.updateOffset(currentTime, animation, timeScale);
  }

  updateOffset(currentTime, animation, timeScale) {
    const { createdTime, playbackRate } = animation.state;

    const time =
      (timeScale.minStartTime + currentTime - createdTime) * playbackRate;

    if (isNaN(time)) {
      // Setting an invalid currentTime will throw so bail out if time is not a number for
      // any reason.
      return;
    }

    this.simulatedAnimation.currentTime = time;
    const position = this.simulatedAnimation.effect.getComputedTiming()
      .progress;

    this.setState({ position });
  }

  setupAnimation(props) {
    const { animation, simulateAnimationForKeyframesProgressBar } = props;

    if (this.simulatedAnimation) {
      this.simulatedAnimation.cancel();
    }

    const timing = Object.assign({}, animation.state, {
      iterations: animation.state.iterationCount || Infinity,
    });

    this.simulatedAnimation = simulateAnimationForKeyframesProgressBar(timing);
  }

  render() {
    const { position } = this.state;

    return dom.div(
      {
        className: "keyframes-progress-bar-area",
      },
      IndicationBar({
        className: "keyframes-progress-bar",
        position,
      })
    );
  }
}

module.exports = KeyframesProgressBar;
