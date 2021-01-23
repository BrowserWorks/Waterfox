/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at <http://mozilla.org/MPL/2.0/>. */

// @flow
import { Component } from "react";
import { range, isEmpty } from "lodash";
import { connect } from "../../utils/connect";
import { getHighlightedLineRange } from "../../selectors";

type OwnProps = {|
  editor: Object,
|};
type Props = {
  highlightedLineRange: Object,
  editor: Object,
};

class HighlightLines extends Component<Props> {
  highlightLineRange: Function;

  componentDidMount() {
    this.highlightLineRange();
  }

  componentWillUpdate() {
    this.clearHighlightRange();
  }

  componentDidUpdate() {
    this.highlightLineRange();
  }

  componentWillUnmount() {
    this.clearHighlightRange();
  }

  clearHighlightRange() {
    const { highlightedLineRange, editor } = this.props;

    const { codeMirror } = editor;

    if (isEmpty(highlightedLineRange) || !codeMirror) {
      return;
    }

    const { start, end } = highlightedLineRange;
    codeMirror.operation(() => {
      range(start - 1, end).forEach(line => {
        codeMirror.removeLineClass(line, "wrapClass", "highlight-lines");
      });
    });
  }

  highlightLineRange = () => {
    const { highlightedLineRange, editor } = this.props;

    const { codeMirror } = editor;

    if (isEmpty(highlightedLineRange) || !codeMirror) {
      return;
    }

    const { start, end } = highlightedLineRange;

    codeMirror.operation(() => {
      editor.alignLine(start);

      range(start - 1, end).forEach(line => {
        codeMirror.addLineClass(line, "wrapClass", "highlight-lines");
      });
    });
  };

  render() {
    return null;
  }
}

export default connect<Props, OwnProps, _, _, _, _>(state => ({
  highlightedLineRange: getHighlightedLineRange(state),
}))(HighlightLines);
