// |jit-test| skip-if: !hasFunction.oomAtAllocation

gczeal(0);

function put(a, i, v) {
  a[i] = v;
}
function make() {
  let a = new Array(32).fill(1);
  // Make the custom length property non-last in the shape.
  a.extra = 0;
  return a;
}
const desc = {value: 16, writable: false};
function truncate(a) {
  // Keep an iterator active to use the generic element-deletion path.
  for (let key in a) {
    Object.defineProperty(a, "length", desc);
    break;
  }
}

// Attach an in-bounds dense-hole store IC for arrays with this shape.
let donor = make();
for (let i = 0; i < 100; i++) {
  delete donor[0];
  put(donor, 0, 1);
}
truncate(make());

let arrays = [];
for (let n = 1; ; n++) {
  let a = make();
  oomAtAllocation(n);
  try {
    truncate(a);
  } catch (e) {
  }
  let hadOOM = resetOOMFailure();

  if (Object.getOwnPropertyDescriptor(a, "length").writable) {
    put(a, 31, {});
    assertEq(a.length, 32);
    arrays.push(a);
  } else {
    assertEq(a.length, 16);
    assertEq(31 in a, false);
  }

  if (!hadOOM) {
    break;
  }
}

verifyprebarriers();
for (let a of arrays) {
  a.length = a.length;
  a.length = 16;
}
verifyprebarriers();
for (let a of arrays) {
  assertEq(31 in a, false);
}
