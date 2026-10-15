// |jit-test| skip-if: helperThreadCount() === 0

evalInWorker(`
with ({}) {}
var call = Function.prototype.call;
var levels = [call.bind(call, call)];
var cost = [2];
for (var k = 1; k < 24; k++) {
  levels.push(call.bind(levels[k - 1], 0, call, levels[k - 1], 0));
  cost.push(4 + 2 * cost[k - 1]);
}
function build(slots, target, thisv) {
  var pieces = [];
  var budget = slots - 200;
  for (var k = levels.length - 1; k >= 1; k--) {
    while (budget >= cost[k]) {
      pieces.push(levels[k]);
      budget -= cost[k];
      slots -= cost[k];
    }
  }
  var n = 3 * (pieces.length + 2) - 2;
  slots -= n + (n & 1);
  var pad = [];
  for (var i = 0; i < slots - 1; i++) {
    pad.push(call);
  }
  pieces.push(call.bind(call, ...pad));
  var bound = [0];
  for (var i = 1; i < pieces.length; i++) {
    bound.push(call, pieces[i], 0);
  }
  bound.push(call, target, thisv);
  return call.bind(pieces[0], ...bound);
}
function leaf() { return 1; }
function other() { return 2; }
var callees = [leaf, other, call.bind(leaf, 0), call.bind(other, 0)];
function f(g) { return g(); }
var probe = build(50000, leaf, 0);
for (var tries = 0; tries < 100; tries++) {
  for (var i = 0; i < 100000; i++) {
    f(callees[i & 3]);
  }
  try {
    if (f(probe) === 1) {
      break;
    }
  } catch (e) {}
}
var body = "'use strict'; var x = this; var ion = +inIon();";
for (var i = 0; i < 1034; i++) {
  body += "var a" + i + "=x*" + (i + 2) + ";";
}
body += "Date.now(); return (0";
for (var i = 0; i < 1034; i++) {
  body += "+a" + i;
}
body += ") * ion;";
var big = Function(body);
for (var i = 0; i < 3000000 && big.call(1.5) === 0; i++) {}
print("warm " + tries + " " + i);
var shot = build(1046486, big, 1.5);
try {
  print("returned " + f(shot));
} catch (e) {
  print("caught " + e);
}
`);
