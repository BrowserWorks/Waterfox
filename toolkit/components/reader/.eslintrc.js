"use strict";

module.exports = {
  "rules": {
    // Braces only needed for multi-line arrow function blocks
    // "arrow-body-style": ["error", "as-needed"],

    // Require spacing around =>
    // "arrow-spacing": "error",

    // Always require spacing around a single line block
    // "block-spacing": "warn",

    // No newline before open brace for a block
    "brace-style": "error",

    // No space before always a space after a comma
    "comma-spacing": ["error", {"before": false, "after": true}],

    // Commas at the end of the line not the start
    // "comma-style": "error",

    // Don't require spaces around computed properties
    // "computed-property-spacing": ["error", "never"],

    // Functions must always return something or nothing
    "consistent-return": "error",

    // Require braces around blocks that start a new line
    // Note that this rule is likely to be overridden on a per-directory basis
    // very frequently.
    // "curly": ["error", "multi-line"],

    // Always require a trailing EOL
    "eol-last": "error",

    // Require function* name()
    // "generator-star-spacing": ["error", {"before": false, "after": true}],

    // Two space indent
    "indent": ["error", 2, { "SwitchCase": 1 }],

    // Space after colon not before in property declarations
    "key-spacing": ["error", { "beforeColon": false, "afterColon": true, "mode": "minimum" }],

    // Unix linebreaks
    "linebreak-style": ["error", "unix"],

    // Always require parenthesis for new calls
    "new-parens": "error",

    // Use [] instead of Array()
    // "no-array-constructor": "error",

    // No duplicate arguments in function declarations
    "no-dupe-args": "error",

    // No duplicate keys in object declarations
    "no-dupe-keys": "error",

    // No duplicate cases in switch statements
    "no-duplicate-case": "error",

    // No labels
    "no-labels": "error",

    // If an if block ends with a return no need for an else block
    "no-else-return": "error",

    // No empty statements
    "no-empty": "error",

    // No empty character classes in regex
    "no-empty-character-class": "error",

    // Disallow empty destructuring
    "no-empty-pattern": "error",

    // No assiging to exception variable
    // "no-ex-assign": "error",

    // No using !! where casting to boolean is already happening
    // "no-extra-boolean-cast": "error",

    // No double semicolon
    "no-extra-semi": "error",

    // No overwriting defined functions
    "no-func-assign": "error",

    // Declarations in Program or Function Body
    "no-inner-declarations": "error",

    // No invalid regular expresions
    "no-invalid-regexp": "error",

    // No odd whitespace characters
    "no-irregular-whitespace": "error",

    // No single if block inside an else block
    "no-lonely-if": "error",

    // No mixing spaces and tabs in indent
    "no-mixed-spaces-and-tabs": ["error", "smart-tabs"],

    // No unnecessary spacing
    "no-multi-spaces": ["error", { exceptions: { "AssignmentExpression": true, "VariableDeclarator": true, "ArrayExpression": true, "ObjectExpression": true } }],

    // No reassigning native JS objects
    "no-native-reassign": "error",

    // No (!foo in bar)
    "no-negated-in-lhs": "error",

    // Nested ternary statements are confusing
    "no-nested-ternary": "error",

    // Use {} instead of new Object()
    // "no-new-object": "error",

    // No Math() or JSON()
    "no-obj-calls": "error",

    // No octal literals
    "no-octal": "error",

    // No redeclaring variables
    "no-redeclare": "error",

    // No unnecessary comparisons
    "no-self-compare": "error",

    // No declaring variables from an outer scope
    "no-shadow": "error",

    // No declaring variables that hide things like arguments
    "no-shadow-restricted-names": "error",

    // No spaces between function name and parentheses
    "no-spaced-func": "error",

    // No trailing whitespace
    "no-trailing-spaces": "error",

    // No using undeclared variables
    // "no-undef": "error",

    // Error on newline where a semicolon is needed
    "no-unexpected-multiline": "error",

    // No unreachable statements
    "no-unreachable": "error",

    // No expressions where a statement is expected
    // "no-unused-expressions": "error",

    // No declaring variables that are never used
    "no-unused-vars": ["error", {"vars": "all", "args": "none"}],

    // No using variables before defined
    // "no-use-before-define": ["error", "nofunc"],

    // No using with
    "no-with": "error",

    // Always require semicolon at end of statement
    "semi": ["error", "always"],

    // Require space after keywords
    "keyword-spacing": "error",

    // Require space before blocks
    "space-before-blocks": "error",

    // Never use spaces before function parentheses
    // "space-before-function-paren": ["error", { "anonymous": "always", "named": "never" }],

    // Require spaces before finally, catch, etc.
    // "space-before-keywords": ["error", "always"],

    // No space padding in parentheses
    // "space-in-parens": ["error", "never"],

    // Require spaces around operators
    // "space-infix-ops": "error",

    // Require spaces after return, throw and case
    // "space-return-throw-case": "error",

    // ++ and -- should not need spacing
    // "space-unary-ops": ["error", { "words": true, "nonwords": false }],

    // No comparisons to NaN
    "use-isnan": "error",

    // Only check typeof against valid results
    "valid-typeof": "error",
  },
}
