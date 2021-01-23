/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

const DevToolsUtils = require("devtools/shared/DevToolsUtils");

const {
  evalWithDebugger,
} = require("devtools/server/actors/webconsole/eval-with-debugger");

if (!isWorker) {
  loader.lazyRequireGetter(
    this,
    "getSyntaxTrees",
    "devtools/shared/webconsole/parser-helper",
    true
  );
}
loader.lazyRequireGetter(
  this,
  "Reflect",
  "resource://gre/modules/reflect.jsm",
  true
);

// Provide an easy way to bail out of even attempting an autocompletion
// if an object has way too many properties. Protects against large objects
// with numeric values that wouldn't be tallied towards MAX_AUTOCOMPLETIONS.
const MAX_AUTOCOMPLETE_ATTEMPTS = (exports.MAX_AUTOCOMPLETE_ATTEMPTS = 100000);
// Prevent iterating over too many properties during autocomplete suggestions.
const MAX_AUTOCOMPLETIONS = (exports.MAX_AUTOCOMPLETIONS = 1500);

/**
 * Provides a list of properties, that are possible matches based on the passed
 * Debugger.Environment/Debugger.Object and inputValue.
 *
 * @param {Object} An object of the following shape:
 * - {Object} dbgObject
 *        When the debugger is not paused this Debugger.Object wraps
 *        the scope for autocompletion.
 *        It is null if the debugger is paused.
 * - {Object} environment
 *        When the debugger is paused this Debugger.Environment is the
 *        scope for autocompletion.
 *        It is null if the debugger is not paused.
 * - {String} inputValue
 *        Value that should be completed.
 * - {Number} cursor (defaults to inputValue.length).
 *        Optional offset in the input where the cursor is located. If this is
 *        omitted then the cursor is assumed to be at the end of the input
 *        value.
 * - {Array} authorizedEvaluations (defaults to []).
 *        Optional array containing all the different properties access that the engine
 *        can execute in order to retrieve its result's properties.
 *        ⚠️ This should be set to true *ONLY* on user action as it may cause side-effects
 *        in the content page ⚠️
 * - {WebconsoleActor} webconsoleActor
 *        A reference to a webconsole actor which we can use to retrieve the last
 *        evaluation result or create a debuggee value.
 * - {String}: selectedNodeActor
 *        The actor id of the selected node in the inspector.
 * - {Array<string>}: expressionVars
 *        Optional array containing variable defined in the expression. Those variables
 *        are extracted from CodeMirror state.
 * @returns null or object
 *          If the inputValue is an unsafe getter and invokeUnsafeGetter is false, the
 *          following form is returned:
 *
 *          {
 *            isUnsafeGetter: true,
 *            getterPath: {Array<String>} An array of the property chain leading to the
 *                        getter. Example: ["x", "myGetter"]
 *          }
 *
 *          If no completion valued could be computed, and the input is not an unsafe
 *          getter, null is returned.
 *
 *          Otherwise an object with the following form is returned:
 *            {
 *              matches: Set<string>
 *              matchProp: Last part of the inputValue that was used to find
 *                         the matches-strings.
 *              isElementAccess: Boolean set to true if the evaluation is an element
 *                               access (e.g. `window["addEvent`).
 *            }
 */
// eslint-disable-next-line complexity
function JSPropertyProvider({
  dbgObject,
  environment,
  inputValue,
  cursor,
  authorizedEvaluations = [],
  webconsoleActor,
  selectedNodeActor,
  expressionVars = [],
}) {
  if (cursor === undefined) {
    cursor = inputValue.length;
  }

  inputValue = inputValue.substring(0, cursor);

  // Analyse the inputValue and find the beginning of the last part that
  // should be completed.
  const inputAnalysis = analyzeInputString(inputValue);

  if (!shouldInputBeAutocompleted(inputAnalysis)) {
    return null;
  }

  let {
    lastStatement,
    isElementAccess,
    mainExpression,
    matchProp,
    isPropertyAccess,
  } = inputAnalysis;

  // Eagerly evaluate the main expression and return the results properties.
  // e.g. `obj.func().a` will evaluate `obj.func()` and return properties matching `a`.
  // NOTE: this is only useful when the input has a property access.
  if (webconsoleActor && shouldInputBeEagerlyEvaluated(inputAnalysis)) {
    const eagerResponse = evalWithDebugger(
      mainExpression,
      { eager: true, selectedNodeActor },
      webconsoleActor
    );

    const ret = eagerResponse?.result?.return;

    // Only send matches if eager evaluation returned something meaningful
    if (ret && ret !== undefined) {
      const matches =
        typeof ret != "object"
          ? getMatchedProps(ret, matchProp)
          : getMatchedPropsInDbgObject(ret, matchProp);

      return prepareReturnedObject({
        matches,
        search: matchProp,
        isElementAccess,
      });
    }
  }

  // AST representation of the expression before the last access char (`.` or `[`).
  let astExpression;
  const startQuoteRegex = /^('|"|`)/;
  const env = environment || dbgObject.asEnvironment();

  // Catch literals like [1,2,3] or "foo" and return the matches from
  // their prototypes.
  // Don't run this is a worker, migrating to acorn should allow this
  // to run in a worker - Bug 1217198.
  if (!isWorker && isPropertyAccess) {
    const syntaxTrees = getSyntaxTrees(mainExpression);
    const lastTree = syntaxTrees[syntaxTrees.length - 1];
    const lastBody = lastTree?.body[lastTree.body.length - 1];

    // Finding the last expression since we've sliced up until the dot.
    // If there were parse errors this won't exist.
    if (lastBody) {
      if (!lastBody.expression) {
        return null;
      }

      astExpression = lastBody.expression;
      let matchingObject;

      if (astExpression.type === "ArrayExpression") {
        matchingObject = getContentPrototypeObject(env, "Array");
      } else if (
        astExpression.type === "Literal" &&
        typeof astExpression.value === "string"
      ) {
        matchingObject = getContentPrototypeObject(env, "String");
      } else if (
        astExpression.type === "Literal" &&
        Number.isFinite(astExpression.value)
      ) {
        // The parser rightfuly indicates that we have a number in some cases (e.g. `1.`),
        // but we don't want to return Number proto properties in that case since
        // the result would be invalid (i.e. `1.toFixed()` throws).
        // So if the expression value is an integer, it should not end with `{Number}.`
        // (but the following are fine: `1..`, `(1.).`).
        if (
          !Number.isInteger(astExpression.value) ||
          /\d[^\.]{0}\.$/.test(lastStatement) === false
        ) {
          matchingObject = getContentPrototypeObject(env, "Number");
        } else {
          return null;
        }
      }

      if (matchingObject) {
        let search = matchProp;

        let elementAccessQuote;
        if (isElementAccess && startQuoteRegex.test(matchProp)) {
          elementAccessQuote = matchProp[0];
          search = matchProp.replace(startQuoteRegex, "");
        }

        let props = getMatchedPropsInDbgObject(matchingObject, search);

        if (isElementAccess) {
          props = wrapMatchesInQuotes(props, elementAccessQuote);
        }

        return {
          isElementAccess,
          matchProp,
          matches: props,
        };
      }
    }
  }

  // We are completing a variable / a property lookup.
  let properties = [];

  if (astExpression) {
    if (isPropertyAccess) {
      properties = getPropertiesFromAstExpression(astExpression);

      if (properties === null) {
        return null;
      }
    }
  } else {
    properties = lastStatement.split(".");
    if (isElementAccess) {
      const lastPart = properties[properties.length - 1];
      const openBracketIndex = lastPart.lastIndexOf("[");
      matchProp = lastPart.substr(openBracketIndex + 1);
      properties[properties.length - 1] = lastPart.substring(
        0,
        openBracketIndex
      );
    } else {
      matchProp = properties.pop().trimLeft();
    }
  }

  let search = matchProp;
  let elementAccessQuote;
  if (isElementAccess && startQuoteRegex.test(search)) {
    elementAccessQuote = search[0];
    search = search.replace(startQuoteRegex, "");
  }

  let obj = dbgObject;
  if (properties.length === 0) {
    const environmentProperties = getMatchedPropsInEnvironment(env, search);
    const expressionVariables = new Set(
      expressionVars.filter(variableName => variableName.startsWith(matchProp))
    );

    for (const prop of environmentProperties) {
      expressionVariables.add(prop);
    }

    return {
      isElementAccess,
      matchProp,
      matches: expressionVariables,
    };
  }

  const firstProp = properties.shift().trim();
  if (firstProp === "this") {
    // Special case for 'this' - try to get the Object from the Environment.
    // No problem if it throws, we will just not autocomplete.
    try {
      obj = env.object;
    } catch (e) {
      // Ignore.
    }
  } else if (firstProp === "$_" && webconsoleActor) {
    obj = webconsoleActor.getLastConsoleInputEvaluation();
  } else if (firstProp === "$0" && selectedNodeActor && webconsoleActor) {
    const actor = webconsoleActor.conn.getActor(selectedNodeActor);
    if (actor) {
      try {
        obj = webconsoleActor.makeDebuggeeValue(actor.rawNode);
      } catch (e) {
        // Ignore.
      }
    }
  } else if (hasArrayIndex(firstProp)) {
    obj = getArrayMemberProperty(null, env, firstProp);
  } else {
    obj = getVariableInEnvironment(env, firstProp);
  }

  if (!isObjectUsable(obj)) {
    return null;
  }

  // We get the rest of the properties recursively starting from the
  // Debugger.Object that wraps the first property
  for (let [index, prop] of properties.entries()) {
    if (typeof prop === "string") {
      prop = prop.trim();
    }

    if (prop === undefined || prop === null || prop === "") {
      return null;
    }

    const propPath = [firstProp].concat(properties.slice(0, index + 1));
    const authorized = authorizedEvaluations.some(
      x => JSON.stringify(x) === JSON.stringify(propPath)
    );

    if (!authorized && DevToolsUtils.isUnsafeGetter(obj, prop)) {
      // If we try to access an unsafe getter, return its name so we can consume that
      // on the frontend.
      return {
        isUnsafeGetter: true,
        getterPath: propPath,
      };
    }

    if (hasArrayIndex(prop)) {
      // The property to autocomplete is a member of array. For example
      // list[i][j]..[n]. Traverse the array to get the actual element.
      obj = getArrayMemberProperty(obj, null, prop);
    } else {
      obj = DevToolsUtils.getProperty(obj, prop, authorized);
    }

    if (!isObjectUsable(obj)) {
      return null;
    }
  }

  const matches =
    typeof obj != "object"
      ? getMatchedProps(obj, search)
      : getMatchedPropsInDbgObject(obj, search);
  return prepareReturnedObject({
    matches,
    search,
    isElementAccess,
    elementAccessQuote,
  });
}

function shouldInputBeEagerlyEvaluated({ lastStatement }) {
  const inComputedProperty =
    lastStatement.lastIndexOf("[") !== -1 &&
    lastStatement.lastIndexOf("[") > lastStatement.lastIndexOf("]");

  const hasPropertyAccess =
    lastStatement.includes(".") || lastStatement.includes("[");

  return hasPropertyAccess && !inComputedProperty;
}

function shouldInputBeAutocompleted(inputAnalysisState) {
  const { err, state, lastStatement } = inputAnalysisState;

  // There was an error analysing the string.
  if (err) {
    console.error("Failed to analyze input string", err);
    return false;
  }

  // If the current state is not STATE_NORMAL, then we are inside of an string
  // which means that no completion is possible.
  if (state != STATE_NORMAL) {
    return false;
  }

  // Don't complete on just an empty string.
  if (lastStatement.trim() == "") {
    return false;
  }

  if (
    NO_AUTOCOMPLETE_PREFIXES.some(prefix =>
      lastStatement.startsWith(prefix + " ")
    )
  ) {
    return false;
  }

  return true;
}

function hasArrayIndex(str) {
  return /\[\d+\]$/.test(str);
}

const STATE_NORMAL = Symbol("STATE_NORMAL");
const STATE_QUOTE = Symbol("STATE_QUOTE");
const STATE_DQUOTE = Symbol("STATE_DQUOTE");
const STATE_TEMPLATE_LITERAL = Symbol("STATE_TEMPLATE_LITERAL");
const STATE_ESCAPE = Symbol("STATE_ESCAPE");
const STATE_SLASH = Symbol("STATE_SLASH");
const STATE_INLINE_COMMENT = Symbol("STATE_INLINE_COMMENT");
const STATE_MULTILINE_COMMENT = Symbol("STATE_MULTILINE_COMMENT");
const STATE_MULTILINE_COMMENT_CLOSE = Symbol("STATE_MULTILINE_COMMENT_CLOSE");
const STATE_QUESTION_MARK = Symbol("STATE_QUESTION_MARK");

const OPEN_BODY = "{[(".split("");
const CLOSE_BODY = "}])".split("");
const OPEN_CLOSE_BODY = {
  "{": "}",
  "[": "]",
  "(": ")",
};

const NO_AUTOCOMPLETE_PREFIXES = ["var", "const", "let", "function", "class"];
const OPERATOR_CHARS_SET = new Set(";,:=<>+-*%|&^~!".split(""));

/**
 * Analyses a given string to find the last statement that is interesting for
 * later completion.
 *
 * @param   string str
 *          A string to analyse.
 *
 * @returns object
 *          If there was an error in the string detected, then a object like
 *
 *            { err: "ErrorMesssage" }
 *
 *          is returned, otherwise a object like
 *
 *            {
 *              state: STATE_NORMAL|STATE_QUOTE|STATE_DQUOTE,
 *              lastStatement: the last statement in the string,
 *              isElementAccess: boolean that indicates if the lastStatement has an open
 *                               element access (e.g. `x["match`).
 *              isPropertyAccess: boolean indicating if we are accessing property
 *                                (e.g `true` in `var a = {b: 1};a.b`)
 *              matchProp: The part of the expression that should match the properties
 *                         on the mainExpression (e.g. `que` when expression is `document.body.que`)
 *              mainExpression: The part of the expression before any property access,
 *                              (e.g. `a.b` if expression is `a.b.`)
 *              expressionBeforePropertyAccess: The part of the expression before property access
 *                                              (e.g `var a = {b: 1};a` if expression is `var a = {b: 1};a.b`)
 *            }
 */
// eslint-disable-next-line complexity
function analyzeInputString(str) {
  // work variables.
  const bodyStack = [];
  let state = STATE_NORMAL;
  let previousNonWhitespaceChar;
  let lastStatement = "";
  let currentIndex = -1;
  let dotIndex;
  let pendingWhitespaceChars = "";
  const TIMEOUT = 2500;
  const startingTime = Date.now();

  // Use a string iterator in order to handle character with a length >= 2 (e.g. 😎).
  for (const c of str) {
    // We are possibly dealing with a very large string that would take a long time to
    // analyze (and freeze the process). If the function has been running for more than
    // a given time, we stop the analysis (this isn't too bad because the only
    // consequence is that we won't provide autocompletion items).
    if (Date.now() - startingTime > TIMEOUT) {
      return {
        err: "timeout",
      };
    }

    currentIndex += 1;
    let resetLastStatement = false;
    const isWhitespaceChar = c.trim() === "";
    switch (state) {
      // Normal JS state.
      case STATE_NORMAL:
        if (lastStatement.endsWith("?.") && /\d/.test(c)) {
          // If the current char is a number, the engine will consider we're not
          // performing an optional chaining, but a ternary (e.g. x ?.4 : 2).
          lastStatement = "";
        }

        // Storing the index of dot of the input string
        if (c === ".") {
          dotIndex = currentIndex;
        }

        // If the last characters were spaces, and the current one is not.
        if (pendingWhitespaceChars && !isWhitespaceChar) {
          // If we have a legitimate property/element access, or potential optional
          // chaining call, we append the spaces.
          if (c === "[" || c === "." || c === "?") {
            lastStatement = lastStatement + pendingWhitespaceChars;
          } else {
            // if not, we can be sure the statement was over, and we can start a new one.
            lastStatement = "";
          }
          pendingWhitespaceChars = "";
        }

        if (c == '"') {
          state = STATE_DQUOTE;
        } else if (c == "'") {
          state = STATE_QUOTE;
        } else if (c == "`") {
          state = STATE_TEMPLATE_LITERAL;
        } else if (c == "/") {
          state = STATE_SLASH;
        } else if (c == "?") {
          state = STATE_QUESTION_MARK;
        } else if (OPERATOR_CHARS_SET.has(c)) {
          // If the character is an operator, we can update the current statement.
          resetLastStatement = true;
        } else if (isWhitespaceChar) {
          // If the previous char isn't a dot or opening bracket, and the current computed
          // statement is not a variable/function/class declaration, we track the number
          // of consecutive spaces, so we can re-use them at some point (or drop them).
          if (
            previousNonWhitespaceChar !== "." &&
            previousNonWhitespaceChar !== "[" &&
            !NO_AUTOCOMPLETE_PREFIXES.includes(lastStatement)
          ) {
            pendingWhitespaceChars += c;
            continue;
          }
        } else if (OPEN_BODY.includes(c)) {
          // When opening a bracket or a parens, we store the current statement, in order
          // to be able to retrieve it later.
          bodyStack.push({
            token: c,
            lastStatement,
            index: currentIndex,
          });
          // And we compute a new statement.
          resetLastStatement = true;
        } else if (CLOSE_BODY.includes(c)) {
          const last = bodyStack.pop();
          if (!last || OPEN_CLOSE_BODY[last.token] != c) {
            return {
              err: "syntax error",
            };
          }
          if (c == "}") {
            resetLastStatement = true;
          } else {
            lastStatement = last.lastStatement;
          }
        }
        break;

      // Escaped quote
      case STATE_ESCAPE:
        state = STATE_NORMAL;
        break;

      // Double quote state > " <
      case STATE_DQUOTE:
        if (c == "\\") {
          state = STATE_ESCAPE;
        } else if (c == "\n") {
          return {
            err: "unterminated string literal",
          };
        } else if (c == '"') {
          state = STATE_NORMAL;
        }
        break;

      // Template literal state > ` <
      case STATE_TEMPLATE_LITERAL:
        if (c == "\\") {
          state = STATE_ESCAPE;
        } else if (c == "`") {
          state = STATE_NORMAL;
        }
        break;

      // Single quote state > ' <
      case STATE_QUOTE:
        if (c == "\\") {
          state = STATE_ESCAPE;
        } else if (c == "\n") {
          return {
            err: "unterminated string literal",
          };
        } else if (c == "'") {
          state = STATE_NORMAL;
        }
        break;
      case STATE_SLASH:
        if (c == "/") {
          state = STATE_INLINE_COMMENT;
        } else if (c == "*") {
          state = STATE_MULTILINE_COMMENT;
        } else {
          lastStatement = "";
          state = STATE_NORMAL;
        }
        break;

      case STATE_INLINE_COMMENT:
        if (c === "\n") {
          state = STATE_NORMAL;
          resetLastStatement = true;
        }
        break;

      case STATE_MULTILINE_COMMENT:
        if (c === "*") {
          state = STATE_MULTILINE_COMMENT_CLOSE;
        }
        break;

      case STATE_MULTILINE_COMMENT_CLOSE:
        if (c === "/") {
          state = STATE_NORMAL;
          resetLastStatement = true;
        } else {
          state = STATE_MULTILINE_COMMENT;
        }
        break;

      case STATE_QUESTION_MARK:
        state = STATE_NORMAL;
        if (c === "?") {
          // If we have a nullish coalescing operator, we start a new statement
          resetLastStatement = true;
        } else if (c !== ".") {
          // If we're not dealing with optional chaining (?.), it means we have a ternary,
          // so we are starting a new statement that includes the current character.
          lastStatement = "";
        } else {
          dotIndex = currentIndex;
        }
        break;
    }

    if (!isWhitespaceChar) {
      previousNonWhitespaceChar = c;
    }
    if (resetLastStatement) {
      lastStatement = "";
    } else {
      lastStatement = lastStatement + c;
    }

    // We update all the open stacks lastStatement so they are up-to-date.
    bodyStack.forEach(stack => {
      if (stack.token !== "}") {
        stack.lastStatement = stack.lastStatement + c;
      }
    });
  }

  let isElementAccess = false;
  let lastOpeningBracketIndex = -1;
  if (bodyStack.length === 1 && bodyStack[0].token === "[") {
    lastStatement = bodyStack[0].lastStatement;
    lastOpeningBracketIndex = bodyStack[0].index;
    isElementAccess = true;

    if (
      state === STATE_DQUOTE ||
      state === STATE_QUOTE ||
      state === STATE_TEMPLATE_LITERAL ||
      state === STATE_ESCAPE
    ) {
      state = STATE_NORMAL;
    }
  } else if (pendingWhitespaceChars) {
    lastStatement = "";
  }

  const lastCompletionCharIndex = isElementAccess
    ? lastOpeningBracketIndex
    : dotIndex;

  const stringBeforeLastCompletionChar = str.slice(0, lastCompletionCharIndex);

  const isPropertyAccess =
    lastCompletionCharIndex && lastCompletionCharIndex > 0;

  // Compute `isOptionalAccess`, so that we can use it
  // later for computing `expressionBeforePropertyAccess`.
  //Check `?.` before `[` for element access ( e.g `a?.["b` or `a  ?. ["b` )
  // and `?` before `.` for regular property access ( e.g `a?.b` or `a ?. b` )
  const optionalElementAccessRegex = /\?\.\s*$/;
  const isOptionalAccess = isElementAccess
    ? optionalElementAccessRegex.test(stringBeforeLastCompletionChar)
    : isPropertyAccess &&
      str.slice(lastCompletionCharIndex - 1, lastCompletionCharIndex + 1) ===
        "?.";

  // Get the filtered string for the properties (e.g if `document.qu` then `qu`)
  const matchProp = isPropertyAccess
    ? str.slice(lastCompletionCharIndex + 1).trimLeft()
    : null;

  const expressionBeforePropertyAccess = isPropertyAccess
    ? str.slice(
        0,
        // For optional access, we can take all the chars before the last "?" char.
        isOptionalAccess
          ? stringBeforeLastCompletionChar.lastIndexOf("?")
          : lastCompletionCharIndex
      )
    : str;

  let mainExpression = lastStatement;
  if (isPropertyAccess) {
    if (isOptionalAccess) {
      // Strip anything before the last `?`.
      mainExpression = mainExpression.slice(0, mainExpression.lastIndexOf("?"));
    } else {
      mainExpression = mainExpression.slice(
        0,
        -1 * (str.length - lastCompletionCharIndex)
      );
    }
  }

  mainExpression = mainExpression.trim();

  return {
    state,
    isElementAccess,
    isPropertyAccess,
    expressionBeforePropertyAccess,
    lastStatement,
    mainExpression,
    matchProp,
  };
}

/**
 * For a given environment and constructor name, returns its Debugger.Object wrapped
 * prototype.
 *
 * @param {Environment} env
 * @param {String} name: Name of the constructor object we want the prototype of.
 * @returns {Debugger.Object|null} the prototype, or null if it not found.
 */
function getContentPrototypeObject(env, name) {
  // Retrieve the outermost environment to get the global object.
  let outermostEnv = env;
  while (outermostEnv?.parent) {
    outermostEnv = outermostEnv.parent;
  }

  const constructorObj = DevToolsUtils.getProperty(outermostEnv.object, name);
  if (!constructorObj) {
    return null;
  }

  return DevToolsUtils.getProperty(constructorObj, "prototype");
}

/**
 * @param {Object} ast: An AST representing a property access (e.g. `foo.bar["baz"].x`)
 * @returns {Array|null} An array representing the property access
 *                       (e.g. ["foo", "bar", "baz", "x"]).
 */
function getPropertiesFromAstExpression(ast) {
  let result = [];
  if (!ast) {
    return result;
  }
  const { type, property, object, name, expression } = ast;
  if (type === "ThisExpression") {
    result.unshift("this");
  } else if (type === "Identifier" && name) {
    result.unshift(name);
  } else if (type === "OptionalExpression" && expression) {
    result = (getPropertiesFromAstExpression(expression) || []).concat(result);
  } else if (
    type === "MemberExpression" ||
    type === "OptionalMemberExpression"
  ) {
    if (property) {
      if (property.type === "Identifier" && property.name) {
        result.unshift(property.name);
      } else if (property.type === "Literal") {
        result.unshift(property.value);
      }
    }
    if (object) {
      result = (getPropertiesFromAstExpression(object) || []).concat(result);
    }
  } else {
    return null;
  }
  return result;
}

function wrapMatchesInQuotes(matches, quote = `"`) {
  return new Set(
    [...matches].map(p => {
      // Escape as a double-quoted string literal
      p = JSON.stringify(p);

      // We don't have to do anything more when using double quotes
      if (quote == `"`) {
        return p;
      }

      // Remove surrounding double quotes
      p = p.slice(1, -1);

      // Unescape inner double quotes (all must be escaped, so no need to count backslashes)
      p = p.replace(/\\(?=")/g, "");

      // Escape the specified quote (assuming ' or `, which are treated literally in regex)
      p = p.replace(new RegExp(quote, "g"), "\\$&");

      // Template literals treat ${ specially, escape it
      if (quote == "`") {
        p = p.replace(/\${/g, "\\$&");
      }

      // Surround the result with quotes
      return `${quote}${p}${quote}`;
    })
  );
}

/**
 * Get the array member of obj for the given prop. For example, given
 * prop='list[0][1]' the element at [0][1] of obj.list is returned.
 *
 * @param object obj
 *        The object to operate on. Should be null if env is passed.
 * @param object env
 *        The Environment to operate in. Should be null if obj is passed.
 * @param string prop
 *        The property to return.
 * @return null or Object
 *         Returns null if the property couldn't be located. Otherwise the array
 *         member identified by prop.
 */
function getArrayMemberProperty(obj, env, prop) {
  // First get the array.
  const propWithoutIndices = prop.substr(0, prop.indexOf("["));

  if (env) {
    obj = getVariableInEnvironment(env, propWithoutIndices);
  } else {
    obj = DevToolsUtils.getProperty(obj, propWithoutIndices);
  }

  if (!isObjectUsable(obj)) {
    return null;
  }

  // Then traverse the list of indices to get the actual element.
  let result;
  const arrayIndicesRegex = /\[[^\]]*\]/g;
  while ((result = arrayIndicesRegex.exec(prop)) !== null) {
    const indexWithBrackets = result[0];
    const indexAsText = indexWithBrackets.substr(
      1,
      indexWithBrackets.length - 2
    );
    const index = parseInt(indexAsText, 10);

    if (isNaN(index)) {
      return null;
    }

    obj = DevToolsUtils.getProperty(obj, index);

    if (!isObjectUsable(obj)) {
      return null;
    }
  }

  return obj;
}

/**
 * Check if the given Debugger.Object can be used for autocomplete.
 *
 * @param Debugger.Object object
 *        The Debugger.Object to check.
 * @return boolean
 *         True if further inspection into the object is possible, or false
 *         otherwise.
 */
function isObjectUsable(object) {
  if (object == null) {
    return false;
  }

  if (typeof object == "object" && object.class == "DeadObject") {
    return false;
  }

  return true;
}

/**
 * @see getExactMatchImpl()
 */
function getVariableInEnvironment(environment, name) {
  return getExactMatchImpl(environment, name, DebuggerEnvironmentSupport);
}

function prepareReturnedObject({
  matches,
  search,
  isElementAccess,
  elementAccessQuote,
}) {
  if (isElementAccess) {
    // If it's an element access, we need to wrap properties in quotes (either the one
    // the user already typed, or `"`).

    matches = wrapMatchesInQuotes(matches, elementAccessQuote);
  } else if (!isWorker) {
    // If we're not performing an element access, we need to check that the property
    // are suited for a dot access. (Reflect.jsm is not available in worker context yet,
    // see Bug 1507181).
    for (const match of matches) {
      try {
        // In order to know if the property is suited for dot notation, we use Reflect
        // to parse an expression where we try to access the property with a dot. If it
        // throws, this means that we need to do an element access instead.
        Reflect.parse(`({${match}: true})`);
      } catch (e) {
        matches.delete(match);
      }
    }
  }

  return { isElementAccess, matchProp: search, matches };
}

/**
 * @see getMatchedPropsImpl()
 */
function getMatchedPropsInEnvironment(environment, match) {
  return getMatchedPropsImpl(environment, match, DebuggerEnvironmentSupport);
}

/**
 * @see getMatchedPropsImpl()
 */
function getMatchedPropsInDbgObject(dbgObject, match) {
  return getMatchedPropsImpl(dbgObject, match, DebuggerObjectSupport);
}

/**
 * @see getMatchedPropsImpl()
 */
function getMatchedProps(obj, match) {
  if (typeof obj != "object") {
    obj = obj.constructor.prototype;
  }
  return getMatchedPropsImpl(obj, match, JSObjectSupport);
}

/**
 * Get all properties in the given object (and its parent prototype chain) that
 * match a given prefix.
 *
 * @param {Mixed} obj
 *        Object whose properties we want to filter.
 * @param {string} match
 *        Filter for properties that match this string.
 * @returns {Set} List of matched properties.
 */
function getMatchedPropsImpl(obj, match, { chainIterator, getProperties }) {
  const matches = new Set();
  let numProps = 0;

  const insensitiveMatching = match && match[0].toUpperCase() !== match[0];
  const propertyMatches = prop => {
    return insensitiveMatching
      ? prop.toLocaleLowerCase().startsWith(match.toLocaleLowerCase())
      : prop.startsWith(match);
  };

  // We need to go up the prototype chain.
  const iter = chainIterator(obj);
  for (obj of iter) {
    const props = getProperties(obj);
    if (!props) {
      continue;
    }
    numProps += props.length;

    // If there are too many properties to event attempt autocompletion,
    // or if we have already added the max number, then stop looping
    // and return the partial set that has already been discovered.
    if (
      numProps >= MAX_AUTOCOMPLETE_ATTEMPTS ||
      matches.size >= MAX_AUTOCOMPLETIONS
    ) {
      break;
    }

    for (let i = 0; i < props.length; i++) {
      const prop = props[i];
      if (!propertyMatches(prop)) {
        continue;
      }

      // If it is an array index, we can't take it.
      // This uses a trick: converting a string to a number yields NaN if
      // the operation failed, and NaN is not equal to itself.
      // eslint-disable-next-line no-self-compare
      if (+prop != +prop) {
        matches.add(prop);
      }

      if (matches.size >= MAX_AUTOCOMPLETIONS) {
        break;
      }
    }
  }

  return matches;
}

/**
 * Returns a property value based on its name from the given object, by
 * recursively checking the object's prototype.
 *
 * @param object obj
 *        An object to look the property into.
 * @param string name
 *        The property that is looked up.
 * @returns object|undefined
 *        A Debugger.Object if the property exists in the object's prototype
 *        chain, undefined otherwise.
 */
function getExactMatchImpl(obj, name, { chainIterator, getProperty }) {
  // We need to go up the prototype chain.
  const iter = chainIterator(obj);
  for (obj of iter) {
    const prop = getProperty(obj, name, obj);
    if (prop) {
      return prop.value;
    }
  }
  return undefined;
}

var JSObjectSupport = {
  chainIterator: function*(obj) {
    while (obj) {
      yield obj;
      try {
        obj = Object.getPrototypeOf(obj);
      } catch (error) {
        // The above can throw e.g. for some proxy objects.
        return;
      }
    }
  },

  getProperties: function(obj) {
    try {
      return Object.getOwnPropertyNames(obj);
    } catch (error) {
      // The above can throw e.g. for some proxy objects.
      return null;
    }
  },

  getProperty: function() {
    // getProperty is unsafe with raw JS objects.
    throw new Error("Unimplemented!");
  },
};

var DebuggerObjectSupport = {
  chainIterator: function*(obj) {
    while (obj) {
      yield obj;
      try {
        obj = obj.proto;
      } catch (error) {
        // The above can throw e.g. for some proxy objects.
        return;
      }
    }
  },

  getProperties: function(obj) {
    try {
      return obj.getOwnPropertyNames();
    } catch (error) {
      // The above can throw e.g. for some proxy objects.
      return null;
    }
  },

  getProperty: function(obj, name, rootObj) {
    // This is left unimplemented in favor to DevToolsUtils.getProperty().
    throw new Error("Unimplemented!");
  },
};

var DebuggerEnvironmentSupport = {
  chainIterator: function*(obj) {
    while (obj) {
      yield obj;
      obj = obj.parent;
    }
  },

  getProperties: function(obj) {
    const names = obj.names();

    // Include 'this' in results (in sorted order)
    for (let i = 0; i < names.length; i++) {
      if (i === names.length - 1 || names[i + 1] > "this") {
        names.splice(i + 1, 0, "this");
        break;
      }
    }

    return names;
  },

  getProperty: function(obj, name) {
    let result;
    // Try/catch since name can be anything, and getVariable throws if
    // it's not a valid ECMAScript identifier name
    try {
      // TODO: we should use getVariableDescriptor() here - bug 725815.
      result = obj.getVariable(name);
    } catch (e) {
      // Ignore.
    }

    // FIXME: Need actual UI, bug 941287.
    if (
      result == null ||
      (typeof result == "object" &&
        (result.optimizedOut || result.missingArguments))
    ) {
      return null;
    }
    return { value: result };
  },
};

exports.JSPropertyProvider = DevToolsUtils.makeInfallible(JSPropertyProvider);

// Export a version that will throw (for tests)
exports.FallibleJSPropertyProvider = JSPropertyProvider;

// Export analyzeInputString (for tests)
exports.analyzeInputString = analyzeInputString;
