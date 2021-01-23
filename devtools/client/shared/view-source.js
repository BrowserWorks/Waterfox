/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

/**
 * Tries to open a Stylesheet file in the Style Editor. If the file is not
 * found, it is opened in source view instead.
 * Returns a promise resolving to a boolean indicating whether or not
 * the source was able to be displayed in the StyleEditor, as the built-in
 * Firefox View Source is the fallback.
 *
 * @param {Toolbox} toolbox
 * @param {string} sourceURL
 * @param {number} sourceLine
 *
 * @return {Promise<boolean>}
 */
exports.viewSourceInStyleEditor = async function(
  toolbox,
  sourceURL,
  sourceLine,
  sourceColumn
) {
  const panel = await toolbox.loadTool("styleeditor");

  try {
    await panel.selectStyleSheet(sourceURL, sourceLine, sourceColumn);
    await toolbox.selectTool("styleeditor");
    return true;
  } catch (e) {
    exports.viewSource(toolbox, sourceURL, sourceLine);
    return false;
  }
};

/**
 * Tries to open a JavaScript file in the Debugger. If the file is not found,
 * it is opened in source view instead. Either the source URL or source actor ID
 * can be specified. If both are specified, the source actor ID is used.
 *
 * Returns a promise resolving to a boolean indicating whether or not
 * the source was able to be displayed in the Debugger, as the built-in Firefox
 * View Source is the fallback.
 *
 * @param {Toolbox} toolbox
 * @param {string} sourceURL
 * @param {number} sourceLine
 * @param {number} sourceColumn
 * @param {string} sourceID
 * @param {(string|object)} [reason=unknown]
 *
 * @return {Promise<boolean>}
 */
exports.viewSourceInDebugger = async function(
  toolbox,
  sourceURL,
  sourceLine,
  sourceColumn,
  sourceId,
  reason = "unknown"
) {
  const dbg = await toolbox.loadTool("jsdebugger");
  const source = sourceId
    ? dbg.getSourceByActorId(sourceId)
    : dbg.getSourceByURL(sourceURL);
  if (source && dbg.canLoadSource(source.id)) {
    await toolbox.selectTool("jsdebugger", reason);
    try {
      await dbg.selectSource(source.id, sourceLine, sourceColumn);
    } catch (err) {
      console.error("Failed to view source in debugger", err);
      return false;
    }
    return true;
  } else if (await toolbox.sourceMapService.hasOriginalURL(sourceURL)) {
    // We have seen a source map for the URL but no source. The debugger will
    // still be able to load the source.
    await toolbox.selectTool("jsdebugger", reason);
    try {
      await dbg.selectSourceURL(sourceURL, sourceLine, sourceColumn);
    } catch (err) {
      console.error("Failed to view source in debugger", err);
      return false;
    }
    return true;
  }

  exports.viewSource(toolbox, sourceURL, sourceLine, sourceColumn);
  return false;
};

/**
 * Open a link in Firefox's View Source.
 *
 * @param {Toolbox} toolbox
 * @param {string} sourceURL
 * @param {number} sourceLine
 *
 * @return {Promise}
 */
exports.viewSource = async function(toolbox, sourceURL, sourceLine) {
  const utils = toolbox.gViewSourceUtils;
  utils.viewSource({
    URL: sourceURL,
    lineNumber: sourceLine || 0,
  });
};
