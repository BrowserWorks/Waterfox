/**
 * @fileoverview functions for scanning an AST for globals including
 *               traversing referenced scripts.
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

"use strict";

const path = require("path");
const fs = require("fs");
const helpers = require("./helpers");
const escope = require("escope");

/**
 * Parses a list of "name:boolean_value" or/and "name" options divided by comma
 * or whitespace.
 *
 * This function was copied from eslint.js
 *
 * @param {string} string The string to parse.
 * @param {Comment} comment The comment node which has the string.
 * @returns {Object} Result map object of names and boolean values
 */
function parseBooleanConfig(string, comment) {
  let items = {};

  // Collapse whitespace around : to make parsing easier
  string = string.replace(/\s*:\s*/g, ":");
  // Collapse whitespace around ,
  string = string.replace(/\s*,\s*/g, ",");

  string.split(/\s|,+/).forEach(function(name) {
    if (!name) {
      return;
    }

    let pos = name.indexOf(":");
    let value;
    if (pos !== -1) {
      value = name.substring(pos + 1, name.length);
      name = name.substring(0, pos);
    }

    items[name] = {
      value: (value === "true"),
      comment
    };
  });

  return items;
}

/**
 * Global discovery can require parsing many files. This map of
 * {String} => {Object} caches what globals were discovered for a file path.
 */
const globalCache = new Map();

/**
 * Global discovery can occasionally meet circular dependencies due to the way
 * js files are included via xul files etc. This set is used to avoid getting
 * into loops whilst the discovery is in progress.
 */
var globalDiscoveryInProgressForFiles = new Set();

/**
 * An object that returns found globals for given AST node types. Each prototype
 * property should be named for a node type and accepts a node parameter and a
 * parents parameter which is a list of the parent nodes of the current node.
 * Each returns an array of globals found.
 *
 * @param  {String} filePath
 *         The absolute path of the file being parsed.
 */
function GlobalsForNode(filePath) {
  this.path = filePath;
  this.dirname = path.dirname(this.path);
}

GlobalsForNode.prototype = {
  Program(node) {
    let globals = [];
    for (let comment of node.comments) {
      if (comment.type !== "Block") {
        continue;
      }
      let value = comment.value.trim();
      value = value.replace(/\n/g, "");

      // We have to discover any globals that ESLint would have defined through
      // comment directives.
      let match = /^globals?\s+(.+)/.exec(value);
      if (match) {
        let values = parseBooleanConfig(match[1].trim(), node);
        for (let name of Object.keys(values)) {
          globals.push({
            name,
            writable: values[name].value
          });
        }
        // We matched globals, so we won't match import-globals-from.
        continue;
      }

      match = /^import-globals-from\s+(.+)$/.exec(value);
      if (!match) {
        continue;
      }

      let filePath = match[1].trim();

      if (!path.isAbsolute(filePath)) {
        filePath = path.resolve(this.dirname, filePath);
      }
      globals = globals.concat(module.exports.getGlobalsForFile(filePath));
    }

    return globals;
  },

  ExpressionStatement(node, parents, globalScope) {
    let isGlobal = helpers.getIsGlobalScope(parents);
    let globals = [];

    // Note: We check the expression types here and only call the necessary
    // functions to aid performance.
    if (node.expression.type === "AssignmentExpression") {
      globals = helpers.convertThisAssignmentExpressionToGlobals(node, isGlobal);
    } else if (node.expression.type === "CallExpression") {
      globals = helpers.convertCallExpressionToGlobals(node, isGlobal);
    }

    // Here we assume that if importScripts is set in the global scope, then
    // this is a worker. It would be nice if eslint gave us a way of getting
    // the environment directly.
    if (globalScope && globalScope.set.get("importScripts")) {
      let workerDetails = helpers.convertWorkerExpressionToGlobals(node,
        isGlobal, this.dirname);
      globals = globals.concat(workerDetails);
    }

    return globals;
  }
};

module.exports = {
  /**
   * Returns all globals for a given file. Recursively searches through
   * import-globals-from directives and also includes globals defined by
   * standard eslint directives.
   *
   * @param  {String} filePath
   *         The absolute path of the file to be parsed.
   * @return {Array}
   *         An array of objects that contain details about the globals:
   *         - {String} name
   *                    The name of the global.
   *         - {Boolean} writable
   *                     If the global is writeable or not.
   */
  getGlobalsForFile(filePath) {
    if (globalCache.has(filePath)) {
      return globalCache.get(filePath);
    }

    if (globalDiscoveryInProgressForFiles.has(filePath)) {
      // We're already processing this file, so return an empty set for now -
      // the initial processing will pick up on the globals for this file.
      return [];
    }
    globalDiscoveryInProgressForFiles.add(filePath);

    let content = fs.readFileSync(filePath, "utf8");

    // Parse the content into an AST
    let ast = helpers.getAST(content);

    // Discover global declarations
    // The second parameter works around https://github.com/babel/babel-eslint/issues/470
    let scopeManager = escope.analyze(ast, {});
    let globalScope = scopeManager.acquire(ast);

    let globals = Object.keys(globalScope.variables).map(v => ({
      name: globalScope.variables[v].name,
      writable: true
    }));

    // Walk over the AST to find any of our custom globals
    let handler = new GlobalsForNode(filePath);

    helpers.walkAST(ast, (type, node, parents) => {
      if (type in handler) {
        let newGlobals = handler[type](node, parents, globalScope);
        globals.push.apply(globals, newGlobals);
      }
    });

    globalCache.set(filePath, globals);

    globalDiscoveryInProgressForFiles.delete(filePath);
    return globals;
  },

  /**
   * Intended to be used as-is for an ESLint rule that parses for globals in
   * the current file and recurses through import-globals-from directives.
   *
   * @param  {Object} context
   *         The ESLint parsing context.
   */
  getESLintGlobalParser(context) {
    let globalScope;

    let parser = {
      Program(node) {
        globalScope = context.getScope();
      }
    };

    // Install thin wrappers around GlobalsForNode
    let handler = new GlobalsForNode(helpers.getAbsoluteFilePath(context));

    for (let type of Object.keys(GlobalsForNode.prototype)) {
      parser[type] = function(node) {
        if (type === "Program") {
          globalScope = context.getScope();
        }
        let globals = handler[type](node, context.getAncestors(), globalScope);
        helpers.addGlobals(globals, globalScope);
      };
    }

    return parser;
  }
};
