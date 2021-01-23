// Any copyright is dedicated to the Public Domain.
// http://creativecommons.org/publicdomain/zero/1.0/

"use strict";
const { require } = ChromeUtils.import("resource://devtools/shared/Loader.jsm");
const {
  analyzeInputString,
} = require("devtools/shared/webconsole/js-property-provider");

add_task(() => {
  const tests = [
    {
      desc: "simple property access",
      input: `var a = {b: 1};a.b`,
      expected: {
        isElementAccess: false,
        isPropertyAccess: true,
        expressionBeforePropertyAccess: `var a = {b: 1};a`,
        lastStatement: "a.b",
        mainExpression: `a`,
        matchProp: `b`,
      },
    },
    {
      desc: "deep property access",
      input: `a.b.c`,
      expected: {
        isElementAccess: false,
        isPropertyAccess: true,
        expressionBeforePropertyAccess: `a.b`,
        lastStatement: "a.b.c",
        mainExpression: `a.b`,
        matchProp: `c`,
      },
    },
    {
      desc: "element access",
      input: `a["b`,
      expected: {
        isElementAccess: true,
        isPropertyAccess: true,
        expressionBeforePropertyAccess: `a`,
        lastStatement: `a["b`,
        mainExpression: `a`,
        matchProp: `"b`,
      },
    },
    {
      desc: "element access without quotes",
      input: `a[b`,
      expected: {
        isElementAccess: true,
        isPropertyAccess: true,
        expressionBeforePropertyAccess: `a`,
        lastStatement: `a[b`,
        mainExpression: `a`,
        matchProp: `b`,
      },
    },
    {
      desc: "simple optional chaining access",
      input: `a?.b`,
      expected: {
        isElementAccess: false,
        isPropertyAccess: true,
        expressionBeforePropertyAccess: `a`,
        lastStatement: `a?.b`,
        mainExpression: `a`,
        matchProp: `b`,
      },
    },
    {
      desc: "deep optional chaining access",
      input: `a?.b?.c`,
      expected: {
        isElementAccess: false,
        isPropertyAccess: true,
        expressionBeforePropertyAccess: `a?.b`,
        lastStatement: `a?.b?.c`,
        mainExpression: `a?.b`,
        matchProp: `c`,
      },
    },
    {
      desc: "optional chaining element access",
      input: `a?.["b`,
      expected: {
        isElementAccess: true,
        isPropertyAccess: true,
        expressionBeforePropertyAccess: `a`,
        lastStatement: `a?.["b`,
        mainExpression: `a`,
        matchProp: `"b`,
      },
    },
    {
      desc: "optional chaining element access without quotes",
      input: `a?.[b`,
      expected: {
        isElementAccess: true,
        isPropertyAccess: true,
        expressionBeforePropertyAccess: `a`,
        lastStatement: `a?.[b`,
        mainExpression: `a`,
        matchProp: `b`,
      },
    },
    {
      desc: "deep optional chaining element access with quotes",
      input: `var a = {b: 1, c: ["."]};     a?.["b"]?.c?.["d[.`,
      expected: {
        isElementAccess: true,
        isPropertyAccess: true,
        expressionBeforePropertyAccess: `var a = {b: 1, c: ["."]};     a?.["b"]?.c`,
        lastStatement: `a?.["b"]?.c?.["d[.`,
        mainExpression: `a?.["b"]?.c`,
        matchProp: `"d[.`,
      },
    },
    {
      desc: "literal arrays with newline",
      input: `[1,2,3,\n4\n].`,
      expected: {
        isElementAccess: false,
        isPropertyAccess: true,
        expressionBeforePropertyAccess: `[1,2,3,\n4\n]`,
        lastStatement: `[1,2,3,4].`,
        mainExpression: `[1,2,3,4]`,
        matchProp: ``,
      },
    },
    {
      desc: "number literal with newline",
      input: `1\n.`,
      expected: {
        isElementAccess: false,
        isPropertyAccess: true,
        expressionBeforePropertyAccess: `1\n`,
        lastStatement: `1\n.`,
        mainExpression: `1`,
        matchProp: ``,
      },
    },
    {
      desc: "optional chaining operator with spaces",
      input: `test  ?.    ["propA"]  ?.   [0]  ?.   ["propB"]  ?.  ['to`,
      expected: {
        isElementAccess: true,
        isPropertyAccess: true,
        expressionBeforePropertyAccess: `test  ?.    ["propA"]  ?.   [0]  ?.   ["propB"]  `,
        lastStatement: `test  ?.    ["propA"]  ?.   [0]  ?.   ["propB"]  ?.  ['to`,
        mainExpression: `test  ?.    ["propA"]  ?.   [0]  ?.   ["propB"]`,
        matchProp: `'to`,
      },
    },
  ];

  for (const { input, desc, expected } of tests) {
    const result = analyzeInputString(input);
    for (const [key, value] of Object.entries(expected)) {
      Assert.equal(value, result[key], `${desc} | ${key} has expected value`);
    }
  }
});
