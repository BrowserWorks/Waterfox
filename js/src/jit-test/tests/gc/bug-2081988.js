// SpiderMonkey shell: queued cleanup must blacken its held value before GC ends.
gczeal(0);
let target = {};
let called = false;
(function () {
  const held = Object.create(null);
  const registry = new FinalizationRegistry(() => { called = true; });
  registry.register(target, held);
  addMarkObservers([registry, held]);
  grayRoot()[0] = registry;
})();
gc();
assertEq(getMarks().join('/'), 'gray/gray');
target = null;
gc();
assertEq(called, false);
assertEq(getMarks().join('/'), 'gray/black');
drainJobQueue();
assertEq(called, true);
