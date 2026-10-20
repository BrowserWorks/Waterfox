// |jit-test| --fast-warmup; --no-threads; skip-if: !hasFunction.oomAtAllocation

with ({}) {}
gczeal(0);

// Stop capturing stacks for throws, so the simulated OOM below happens while
// bailing out to the catch block instead of while throwing the exception.
for (var i = 0; i < 100; i++) {
  try { throw 0; } catch (e) {}
}

var active = false;
var first = null;
var second = null;

function receive() {
  if (!active) return 7;

  first = helper.arguments[0];
  first.a = 99;
  delete first.b;

  oomAtAllocation(1);
  throw 12345;
}

function close() {
  if (active) {
    var args = helper.arguments;
    if (args) second = args[0];
  }
  return {};
}

var iterator = {
  next() { return {value: undefined, done: false}; },
  return: close,
  [Symbol.iterator]() { return this; }
};

// Prevent the callback itself from being inlined into the tested Ion frame.
var other = newGlobal({newCompartment: true});
other.parent = this;
var cross = other.Function('return parent.receive()');

function helper(o) {
  try { return cross() + o.a; } catch (e) { return -1; }
}

function outer() {
  var o = {a: 1, b: 2, c: 2};
  var eq = (o === o);
  var [v = helper(o)] = iterator;
  return v + (eq ? 1 : 0);
}

for (var i = 0; i < 1000; i++) {
  outer();
}

active = true;
try {
  outer();
} catch (e) {
} finally {
  resetOOMFailure();
  active = false;
}

if (second !== null) {
  assertEq(second, first);
}
assertEq(first.a, 99);
assertEq(Object.hasOwn(first, 'b'), false);
first.d = 17;
first.e = 42;
assertEq(first.c, 2);
