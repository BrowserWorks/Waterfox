/* vim: set ts=2 et sw=2 tw=80: */
/* Any copyright is dedicated to the Public Domain.
 http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

// Check that animations displayed in the timeline can be selected by clicking
// them, and that this emits the right events and adds the right classes.

add_task(function* () {
  yield addTab(URL_ROOT + "doc_simple_animation.html");
  let {panel} = yield openAnimationInspector();
  let timeline = panel.animationsTimelineComponent;

  let selected = timeline.rootWrapperEl.querySelectorAll(".animation.selected");
  ok(!selected.length, "There are no animations selected by default");

  info("Click on the first animation, expect the right event and right class");
  let animation0 = yield clickOnAnimation(panel, 0);
  is(animation0, timeline.animations[0],
     "The selected event was emitted with the right animation");
  ok(isTimeBlockSelected(timeline, 0),
     "The time block has the right selected class");

  info("Click on the second animation, expect it to be selected too");
  let animation1 = yield clickOnAnimation(panel, 1);
  is(animation1, timeline.animations[1],
     "The selected event was emitted with the right animation");
  ok(isTimeBlockSelected(timeline, 1),
     "The second time block has the right selected class");

  info("Click again on the first animation and check if it unselects");
  yield clickOnAnimation(panel, 0, true);
  ok(!isTimeBlockSelected(timeline, 0),
     "The first time block has been unselected");
});

function isTimeBlockSelected(timeline, index) {
  let animation = timeline.rootWrapperEl.querySelectorAll(".animation")[index];
  let animatedProperties = timeline.rootWrapperEl.querySelectorAll(
    ".animated-properties")[index];
  return animation.classList.contains("selected") &&
         animatedProperties.classList.contains("selected");
}
