// |jit-test| --fast-warmup; --no-threads

var proxy = new Proxy(function() { return arguments.length; }, {
  get apply() {
    receiver.m = Math.abs;
    gc();
    return undefined;
  }
});
var receiver = proxy;

function hot0() { return receiver.m(); }
function hot2() { return receiver.m(null, 1, 2); }

var natives = [Math.abs, Math.acos, Math.atan, Math.ceil, Math.cos, Math.exp,
               Math.floor, Math.log, Math.max, Math.min, Math.pow, Math.round,
               Math.sin, Math.sqrt, Math.tan, parseInt, parseFloat, isNaN,
               isFinite, Number, Boolean, String];

function warm() {
  with ({}) {}
  for (var i = 0; i < 2000; i++) {
    receiver.m = natives[i % natives.length];
    hot0();
    hot2();
  }
}

function install() {
  receiver.m = newGlobal({sameCompartmentAs: proxy}).evaluate(
      "Function.prototype.call");
}

with ({}) {}

warm();
install();
assertEq(hot0(), 0);

warm();
install();
assertEq(hot2(), 2);

receiver = proxy.bind(null, 1);
warm();
install();
assertEq(hot0(), 1);

warm();
install();
assertEq(hot2(), 3);

// A proxy's arguments array must still be allocated in fun_call's realm.
receiver = new Proxy(function() {}, {
  apply(target, thisArg, args) { return args; }
});
var realm = newGlobal({sameCompartmentAs: proxy});
warm();
receiver.m = realm.Function.prototype.call;
var args = hot2();
assertEq(Object.getPrototypeOf(args), realm.Array.prototype);
