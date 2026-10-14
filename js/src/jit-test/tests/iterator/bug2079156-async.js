// |jit-test| --enable-async-iterator-helpers

var getterCalled = false;

var AGFP = Object.getPrototypeOf(async function* () {});
Object.defineProperty(AGFP, "prototype", {
  get() {
    getterCalled = true;
  },
});
(async function* () {})().take(1);
assertEq(getterCalled, false);
