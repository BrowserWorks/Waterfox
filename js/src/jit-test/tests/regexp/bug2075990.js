setJitCompilerOption('offthread-compilation.enable', 0);
setJitCompilerOption('inlining.bytecode-max-length', 2000);

const matchAllMethod = RegExp.prototype[Symbol.matchAll];
const nextMethod = Object.getPrototypeOf(matchAllMethod.call(/a/g, '')).next;
const fakeMatcher = {lastIndex: 0, source: 'a', flags: 0, exec() { return null; }};
function CustomSpecies() { return fakeMatcher; }
const slowRegexp = {constructor: {[Symbol.species]: CustomSpecies}, flags: 'g', lastIndex: 0};
const fastRegexp = /a/g;
fastRegexp.lastIndex = 100000;

try { nextMethod.call({}); } catch (error) {}
nextMethod.call(matchAllMethod.call(/()/gu, ''));
nextMethod.call(matchAllMethod.call(slowRegexp, ''));
gc();

function candidate(regexp, count) {
  const iterator = matchAllMethod.call(regexp, '');
  let result = true;
  for (let iteration = 0; iteration < count; iteration++) {
    result = nextMethod.call(iterator).done;
  }
  return result;
}

for (let warmup = 0; warmup < 1400; warmup++) {
  assertEq(candidate(fastRegexp, 2), true);
  assertEq(candidate(slowRegexp, 0), true);
}
fakeMatcher.source = 13.37;
assertEq(candidate(slowRegexp, 0), true);
