// |jit-test| --no-threads; --ion-limit-script-size=off; --ion-warmup-threshold=50

var deep = false;
var hits = 0;
var wrong = null;

// Called by the Ion exception handler after the bailout to inner's catch block
// failed its stack check.
function close() {
  var args = targets.inner.arguments;
  if (deep && args) {
    hits++;
    if (args[1] !== 0xffffff) {
      wrong = args[1];
    }
  }
  return {};
}

var iter = {
  [Symbol.iterator]() { return this; },
  next() { return {done: false, value: undefined}; },
  return: close
};

function leaf() {
  if (deep) {
    throw 1;
  }
  return 1;
}

// Cross-realm, so it isn't inlined into inner.
var g = newGlobal({sameCompartmentAs: this});
g.parent = this;
var foreign = g.Function("return parent.leaf();");

function vars(n) {
  return "var " + Array.from({length: n}, (_, i) => "v" + i).join(",") + ";";
}

// The Baseline frames for outer and inner are much larger than outer's Ion
// frame, so near the recursion limit the bailout to inner's catch block fails
// its stack check.
var targets = new Function("foreign", "iter", `
  function inner(x, saved) {
    ${vars(9000)}
    try { return foreign(); } catch (e) { return 0; }
  }
  function outer(a, b) {
    ${vars(9000)}
    var saved = a;
    a = b;
    var [r = inner(0, saved)] = iter;
    return r + a;
  }
  return {inner, outer};
`)(foreign, iter);

for (var i = 0; i < 3000; i++) {
  targets.outer(0xffffff, 4096);
}

var calls = 0;
var rec = new Function("targets", "state", `
  return function rec() {
    ${vars(200)}
    try { rec(); } catch (e) {}
    if (state.calls++ < 100) targets.outer(0xffffff, 4096);
  };
`)(targets, this);

deep = true;
try { rec(); } catch (e) {}
deep = false;

assertEq(wrong, null);
