// |jit-test| --no-threads; --fast-warmup
var fns = [];
for (var i = 0; i < 5; i++) {
  fns.push(newGlobal({sameCompartmentAs: this}).callAfterSettingRval);
}
for (var i = 0; i < 50; i++) {
  fns.push(Math.abs, Math.sin, Math.cos, Math.tan,
            Math.exp, Math.log, Math.sqrt, Math.atan);
}
function test() {
  while (fns.length > 0) {
    fns.pop()(gc);
  }
}
test();
