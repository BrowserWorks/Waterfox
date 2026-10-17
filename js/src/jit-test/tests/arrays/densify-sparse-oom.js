// |jit-test| skip-if: !hasFunction.oomAtAllocation

gczeal(0);

// Arrange for adding index 10 to use the last property slot and make the slot
// span a power of two, so the sparse elements can be densified.
function makeSparse() {
  let a = [];
  Object.defineProperty(a, 0, {
    value: 0, writable: true, configurable: true, enumerable: false
  });
  a.x = 0;
  a.y = 0;
  delete a.x;
  a.x = 0;
  for (let i = 6; i < 10; i++) {
    a[i] = i;
  }
  a.z = 0;
  delete a.x;
  a.w = 0;
  delete a.z;
  Object.defineProperty(a, 0, {enumerable: true});
  return a;
}

const desc = {
  value: {}, writable: true, configurable: true, enumerable: true
};
function add(a) {
  Object.defineProperty(a, 10, desc);
}

add(makeSparse());
for (let n = 1; ; n++) {
  let a = makeSparse();
  oomAtAllocation(n);
  try {
    add(a);
  } catch (e) {
  }
  let hadOOM = resetOOMFailure();

  assertEq(a.length, Object.hasOwn(a, 10) ? 11 : 10);

  Object.defineProperty(a, 10, {
    value: {}, writable: true, configurable: true, enumerable: true
  });
  assertEq(a.length, 11);

  verifyprebarriers();
  a.length = a.length;
  a.length = 10;
  verifyprebarriers();
  assertEq(Object.hasOwn(a, 10), false);

  if (!hadOOM) {
    break;
  }
}
