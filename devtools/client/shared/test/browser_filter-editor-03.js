/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

// Tests the Filter Editor Widget add, removeAt, updateAt, getValueAt methods

const {CSSFilterEditorWidget} = require("devtools/client/shared/widgets/FilterWidget");
const {getClientCssProperties} = require("devtools/shared/fronts/css-properties");
const GRAYSCALE_MAX = 100;
const INVERT_MIN = 0;

const TEST_URI = `data:text/html,<div id="filter-container" />`;

add_task(function* () {
  let [,, doc] = yield createHost("bottom", TEST_URI);
  const cssIsValid = getClientCssProperties().getValidityChecker(doc);

  const container = doc.querySelector("#filter-container");
  let widget = new CSSFilterEditorWidget(container, "none", cssIsValid);

  info("Test add method");
  const blur = widget.add("blur", "10.2px");
  is(widget.getCssValue(), "blur(10.2px)",
     "Should add filters");

  const url = widget.add("url", "test.svg");
  is(widget.getCssValue(), "blur(10.2px) url(test.svg)",
     "Should add filters in order");

  info("Test updateValueAt method");
  widget.updateValueAt(url, "test2.svg");
  widget.updateValueAt(blur, 5);
  is(widget.getCssValue(), "blur(5px) url(test2.svg)",
     "Should update values correctly");

  info("Test getValueAt method");
  is(widget.getValueAt(blur), "5px",
     "Should return value + unit");
  is(widget.getValueAt(url), "test2.svg",
     "Should return value for string-type filters");

  info("Test removeAt method");
  widget.removeAt(url);
  is(widget.getCssValue(), "blur(5px)",
     "Should remove the specified filter");

  info("Test add method applying filter range to value");
  const grayscale = widget.add("grayscale", GRAYSCALE_MAX + 1);
  is(widget.getValueAt(grayscale), `${GRAYSCALE_MAX}%`,
     "Shouldn't allow values higher than max");

  const invert = widget.add("invert", INVERT_MIN - 1);
  is(widget.getValueAt(invert), `${INVERT_MIN}%`,
     "Shouldn't allow values less than INVERT_MIN");

  info("Test updateValueAt method applying filter range to value");
  widget.updateValueAt(grayscale, GRAYSCALE_MAX + 1);
  is(widget.getValueAt(grayscale), `${GRAYSCALE_MAX}%`,
     "Shouldn't allow values higher than max");

  widget.updateValueAt(invert, INVERT_MIN - 1);
  is(widget.getValueAt(invert), `${INVERT_MIN}%`,
     "Shouldn't allow values less than INVERT_MIN");
});
