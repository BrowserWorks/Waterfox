// |jit-test| --fast-warmup; --no-threads; allow-unhandlable-oom; skip-if: !hasFunction.oomAtAllocation

with ({}) {}
gczeal(0);

// Avoid allocating exception stacks before reaching the bailout.
for (var i = 0; i < 100; i++) {
  try { throw 0; } catch (e) {}
}

var active = false;

function receive() {
  if (!active) return 7;
  oomAtAllocation(4);
  throw 12345;
}

// Reading helper's arguments needs the recovery results again. The failure is
// remembered, so this read crashes with [unhandlable oom] instead of
// re-running ArrayState.
function close() {
  if (active) helper.arguments;
  return {};
}

var iterator = {
  next() { return {value: undefined, done: false}; },
  return: close,
  [Symbol.iterator]() { return this; }
};
var other = newGlobal({newCompartment: true});
other.parent = this;
var cross = other.Function('return parent.receive()');

// ArrayState can succeed before recovery of the plain object's allocation fails.
// Reading the snapshot again must not initialize the array twice.
var helper = Function('a', 'b',
  'try { return cross() + a[0] + b.p; } catch (e) { return -1; }');
var outer = Function(`
  var b = {p: 3};
  var a = [11, 22];
  var eq = (a === a);
  var [v = helper(a, b)] = iterator;
  return v + (eq ? 1 : 0);
`);
for (var i = 0; i < 1000; i++) outer();

active = true;
try {
  outer();
} catch (e) {
} finally {
  resetOOMFailure();
  active = false;
}
