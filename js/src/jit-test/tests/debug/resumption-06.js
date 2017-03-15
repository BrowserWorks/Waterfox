// |jit-test| error: already executing generator
// Forced return from a star generator frame.

load(libdir + 'asserts.js')
load(libdir + 'iteration.js')

var g = newGlobal();
g.debuggeeGlobal = this;
g.eval("var dbg = new Debugger(debuggeeGlobal);" +
       "dbg.onDebuggerStatement = function (frame) { return { return: frame.eval(\"({ done: true, value: '!' })\").return }; };");

function* gen() {
    yield '1';
    debugger;  // Force return here. The value is ignored.
    yield '2';
}
var iter = gen();
assertIteratorNext(iter, '1');
assertIteratorDone(iter, '!');
iter.next();
assertEq(0, 1);
