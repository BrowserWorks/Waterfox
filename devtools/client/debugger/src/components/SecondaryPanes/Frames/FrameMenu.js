/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at <http://mozilla.org/MPL/2.0/>. */

// @flow
import { showMenu } from "devtools-contextmenu";
import { copyToTheClipboard } from "../../../utils/clipboard";
import type { ContextMenuItem, Frame, ThreadContext } from "../../../types";
import { kebabCase } from "lodash";

const blackboxString = "blackboxContextItem.blackbox";
const unblackboxString = "blackboxContextItem.unblackbox";

function formatMenuElement(
  labelString: string,
  click: Function,
  disabled: boolean = false
): ContextMenuItem {
  const label = L10N.getStr(labelString);
  const accesskey = L10N.getStr(`${labelString}.accesskey`);
  const id = `node-menu-${kebabCase(label)}`;
  return {
    id,
    label,
    accesskey,
    disabled,
    click,
  };
}

function copySourceElement(url) {
  return formatMenuElement("copySourceUri2", () => copyToTheClipboard(url));
}

function copyStackTraceElement(copyStackTrace) {
  return formatMenuElement("copyStackTrace", () => copyStackTrace());
}

function toggleFrameworkGroupingElement(
  toggleFrameworkGrouping,
  frameworkGroupingOn
) {
  const actionType = frameworkGroupingOn
    ? "framework.disableGrouping"
    : "framework.enableGrouping";

  return formatMenuElement(actionType, () => toggleFrameworkGrouping());
}

function blackBoxSource(cx, source, toggleBlackBox) {
  const toggleBlackBoxString = source.isBlackBoxed
    ? unblackboxString
    : blackboxString;

  return formatMenuElement(toggleBlackBoxString, () =>
    toggleBlackBox(cx, source)
  );
}

export default function FrameMenu(
  frame: Frame,
  frameworkGroupingOn: boolean,
  callbacks: Object,
  event: SyntheticMouseEvent<HTMLElement>,
  cx: ThreadContext
) {
  event.stopPropagation();
  event.preventDefault();

  const menuOptions = [];

  const toggleFrameworkElement = toggleFrameworkGroupingElement(
    callbacks.toggleFrameworkGrouping,
    frameworkGroupingOn
  );
  menuOptions.push(toggleFrameworkElement);

  const { source } = frame;
  if (source) {
    const copySourceUri2 = copySourceElement(source.url);
    menuOptions.push(copySourceUri2);
    menuOptions.push(blackBoxSource(cx, source, callbacks.toggleBlackBox));
  }

  const copyStackTraceItem = copyStackTraceElement(callbacks.copyStackTrace);

  menuOptions.push(copyStackTraceItem);

  showMenu(event, menuOptions);
}
