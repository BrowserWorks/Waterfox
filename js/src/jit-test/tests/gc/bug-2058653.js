gczeal(0);
var gh = newGlobal({newCompartment: true});
var g1 = newGlobal({newCompartment: true});
g1.eval(`
  var wm = new WeakMap();
  var S = Symbol("hidden");
  wm.set(S, {});
`);
gh.eval(`
  var wm1 = new WeakMap();
  var wm2 = new WeakMap();
  var K1 = {};
  var h1 = {};
  var h2 = { s: null };
  wm1.set(K1, h1);
  wm2.set(h1, h2);
  grayRoot().push(K1);
  grayRoot().push(wm1);
  grayRoot().push(wm2);
`);
gh.h2.s = g1.S;
g1.eval(`S = null;`);
gh.eval(`wm1 = null; wm2 = null; K1 = null; h1 = null; h2 = null;`);

startgc(1);
while (gcstate() != "NotActive") {
  gcslice(10000000);
}
