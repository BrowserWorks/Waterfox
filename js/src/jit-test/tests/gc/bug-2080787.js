// |jit-test| --gc-param=semispaceNurseryEnabled=1; skip-if: !wasmIsSupported()

const retained = new Array(256);
const prefix = "a".repeat(701);
const suffix = "b".repeat(733);
const extension = "c".repeat(769);
let serial = 0;
let checksum = 0;
function pressure(count) {
  for (let index = 0; index < count; index++) {
    retained[index & 255] = {serial: serial++};
  }
}
for (let round = 0; round < 100; round++) {
  const table = new WebAssembly.Table({element: "externref", initial: 1});
  const older = prefix + round + suffix;
  table.set(0, older);
  const spacing = 2500 + round % 5 * 500;
  pressure(spacing);
  checksum ^= (older + extension).toLowerCase().charCodeAt(0);
  pressure(spacing);
  table.grow(257);
  pressure(6000);
  checksum ^= table.get(0).charCodeAt(0);
}
