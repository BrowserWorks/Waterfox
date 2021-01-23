// |jit-test| skip-if: !Function.prototype.toSource

// Source string has balanced parentheses even when the source code was discarded.

setDiscardSource(true);
eval("var f = function() { return 0; };");
assertEq(f.toSource(), "(function() {\n    [native code]\n})");
