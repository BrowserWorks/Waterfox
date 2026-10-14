var getterCalled = false;

var GFP = Object.getPrototypeOf(function* () {});
Object.defineProperty(GFP, "prototype", {
  get() {
    getterCalled = true;
  },
});
[].values().take(1);
assertEq(getterCalled, false);
