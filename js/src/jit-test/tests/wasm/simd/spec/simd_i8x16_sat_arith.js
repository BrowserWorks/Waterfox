var ins = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`
( module ( func ( export "i8x16.add_saturate_s" ) ( param v128 v128 ) ( result v128 ) ( i8x16.add_saturate_s ( local.get 0 ) ( local.get 1 ) ) ) ( func ( export "i8x16.add_saturate_u" ) ( param v128 v128 ) ( result v128 ) ( i8x16.add_saturate_u ( local.get 0 ) ( local.get 1 ) ) ) ( func ( export "i8x16.sub_saturate_s" ) ( param v128 v128 ) ( result v128 ) ( i8x16.sub_saturate_s ( local.get 0 ) ( local.get 1 ) ) ) ( func ( export "i8x16.sub_saturate_u" ) ( param v128 v128 ) ( result v128 ) ( i8x16.sub_saturate_u ( local.get 0 ) ( local.get 1 ) ) ) )
`)));
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ) ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 )))
(local.set $expected ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ) ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 )))
(local.set $expected ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ) ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 )))
(local.set $expected ( v128.const i8x16 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ) ( v128.const i8x16 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 )))
(local.set $expected ( v128.const i8x16 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ) ( v128.const i8x16 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 )))
(local.set $expected ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 ) ( v128.const i8x16 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 )))
(local.set $expected ( v128.const i8x16 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 63 63 63 63 63 63 63 63 63 63 63 63 63 63 63 63 ) ( v128.const i8x16 64 64 64 64 64 64 64 64 64 64 64 64 64 64 64 64 )))
(local.set $expected ( v128.const i8x16 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 64 64 64 64 64 64 64 64 64 64 64 64 64 64 64 64 ) ( v128.const i8x16 64 64 64 64 64 64 64 64 64 64 64 64 64 64 64 64 )))
(local.set $expected ( v128.const i8x16 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 -63 -63 -63 -63 -63 -63 -63 -63 -63 -63 -63 -63 -63 -63 -63 -63 ) ( v128.const i8x16 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 )))
(local.set $expected ( v128.const i8x16 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 ) ( v128.const i8x16 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 )))
(local.set $expected ( v128.const i8x16 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 -65 -65 -65 -65 -65 -65 -65 -65 -65 -65 -65 -65 -65 -65 -65 -65 ) ( v128.const i8x16 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 )))
(local.set $expected ( v128.const i8x16 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 125 125 125 125 125 125 125 125 125 125 125 125 125 125 125 125 ) ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 )))
(local.set $expected ( v128.const i8x16 126 126 126 126 126 126 126 126 126 126 126 126 126 126 126 126 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 126 126 126 126 126 126 126 126 126 126 126 126 126 126 126 126 ) ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 )))
(local.set $expected ( v128.const i8x16 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 128 128 128 128 128 128 128 128 128 128 128 128 128 128 128 128 ) ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 )))
(local.set $expected ( v128.const i8x16 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 -126 -126 -126 -126 -126 -126 -126 -126 -126 -126 -126 -126 -126 -126 -126 -126 ) ( v128.const i8x16 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 )))
(local.set $expected ( v128.const i8x16 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 ) ( v128.const i8x16 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 )))
(local.set $expected ( v128.const i8x16 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 ) ( v128.const i8x16 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 )))
(local.set $expected ( v128.const i8x16 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 ) ( v128.const i8x16 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 )))
(local.set $expected ( v128.const i8x16 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 ) ( v128.const i8x16 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 )))
(local.set $expected ( v128.const i8x16 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 ) ( v128.const i8x16 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 )))
(local.set $expected ( v128.const i8x16 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ) ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 )))
(local.set $expected ( v128.const i8x16 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ) ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 )))
(local.set $expected ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ) ( v128.const i8x16 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 )))
(local.set $expected ( v128.const i8x16 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ) ( v128.const i8x16 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 )))
(local.set $expected ( v128.const i8x16 126 126 126 126 126 126 126 126 126 126 126 126 126 126 126 126 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ) ( v128.const i8x16 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 )))
(local.set $expected ( v128.const i8x16 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ) ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 )))
(local.set $expected ( v128.const i8x16 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0x3f 0x3f 0x3f 0x3f 0x3f 0x3f 0x3f 0x3f 0x3f 0x3f 0x3f 0x3f 0x3f 0x3f 0x3f 0x3f ) ( v128.const i8x16 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 )))
(local.set $expected ( v128.const i8x16 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 ) ( v128.const i8x16 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 )))
(local.set $expected ( v128.const i8x16 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 -0x3f -0x3f -0x3f -0x3f -0x3f -0x3f -0x3f -0x3f -0x3f -0x3f -0x3f -0x3f -0x3f -0x3f -0x3f -0x3f ) ( v128.const i8x16 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 )))
(local.set $expected ( v128.const i8x16 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 ) ( v128.const i8x16 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 )))
(local.set $expected ( v128.const i8x16 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 ) ( v128.const i8x16 -0x41 -0x41 -0x41 -0x41 -0x41 -0x41 -0x41 -0x41 -0x41 -0x41 -0x41 -0x41 -0x41 -0x41 -0x41 -0x41 )))
(local.set $expected ( v128.const i8x16 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f ) ( v128.const i8x16 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f )))
(local.set $expected ( v128.const i8x16 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f ) ( v128.const i8x16 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 )))
(local.set $expected ( v128.const i8x16 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 ) ( v128.const i8x16 -0x01 -0x01 -0x01 -0x01 -0x01 -0x01 -0x01 -0x01 -0x01 -0x01 -0x01 -0x01 -0x01 -0x01 -0x01 -0x01 )))
(local.set $expected ( v128.const i8x16 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f ) ( v128.const i8x16 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 )))
(local.set $expected ( v128.const i8x16 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 ) ( v128.const i8x16 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 )))
(local.set $expected ( v128.const i8x16 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff ) ( v128.const i8x16 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 )))
(local.set $expected ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff ) ( v128.const i8x16 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff )))
(local.set $expected ( v128.const i8x16 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 ) ( v128.const f32x4 -0.0 -0.0 -0.0 -0.0 )))
(local.set $expected ( v128.const i8x16 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ) ( v128.const f32x4 +inf +inf +inf +inf )))
(local.set $expected ( v128.const i8x16 0x01 0x01 0x81 0x7f 0x01 0x01 0x81 0x7f 0x01 0x01 0x81 0x7f 0x01 0x01 0x81 0x7f ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ) ( v128.const f32x4 -inf -inf -inf -inf )))
(local.set $expected ( v128.const i8x16 0x01 0x01 0x81 0 0x01 0x01 0x81 0 0x01 0x01 0x81 0 0x01 0x01 0x81 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ) ( v128.const f32x4 nan nan nan nan )))
(local.set $expected ( v128.const i8x16 0x01 0x01 0xc1 0x7f 0x01 0x01 0xc1 0x7f 0x01 0x01 0xc1 0x7f 0x01 0x01 0xc1 0x7f ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ) ( v128.const f32x4 -nan -nan -nan -nan )))
(local.set $expected ( v128.const i8x16 0x01 0x01 0xc1 0 0x01 0x01 0xc1 0 0x01 0x01 0xc1 0 0x01 0x01 0xc1 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 ) ( v128.const i8x16 0 0xff 0xfe 0xfd 0xfc 0xfb 0xfa 0xf9 0xf8 0xf7 0xf6 0xf5 0xf4 0xf3 0xf2 0xf1 )))
(local.set $expected ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 ) ( v128.const i8x16 0 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 )))
(local.set $expected ( v128.const i8x16 0 3 6 9 12 15 18 21 24 27 30 33 36 39 42 45 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ) ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 )))
(local.set $expected ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ) ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 )))
(local.set $expected ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ) ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 )))
(local.set $expected ( v128.const i8x16 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ) ( v128.const i8x16 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 )))
(local.set $expected ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ) ( v128.const i8x16 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 )))
(local.set $expected ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 ) ( v128.const i8x16 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 )))
(local.set $expected ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 63 63 63 63 63 63 63 63 63 63 63 63 63 63 63 63 ) ( v128.const i8x16 64 64 64 64 64 64 64 64 64 64 64 64 64 64 64 64 )))
(local.set $expected ( v128.const i8x16 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 64 64 64 64 64 64 64 64 64 64 64 64 64 64 64 64 ) ( v128.const i8x16 64 64 64 64 64 64 64 64 64 64 64 64 64 64 64 64 )))
(local.set $expected ( v128.const i8x16 128 128 128 128 128 128 128 128 128 128 128 128 128 128 128 128 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 -63 -63 -63 -63 -63 -63 -63 -63 -63 -63 -63 -63 -63 -63 -63 -63 ) ( v128.const i8x16 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 )))
(local.set $expected ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 ) ( v128.const i8x16 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 )))
(local.set $expected ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 -65 -65 -65 -65 -65 -65 -65 -65 -65 -65 -65 -65 -65 -65 -65 -65 ) ( v128.const i8x16 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 )))
(local.set $expected ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 125 125 125 125 125 125 125 125 125 125 125 125 125 125 125 125 ) ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 )))
(local.set $expected ( v128.const i8x16 126 126 126 126 126 126 126 126 126 126 126 126 126 126 126 126 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 126 126 126 126 126 126 126 126 126 126 126 126 126 126 126 126 ) ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 )))
(local.set $expected ( v128.const i8x16 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 128 128 128 128 128 128 128 128 128 128 128 128 128 128 128 128 ) ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 )))
(local.set $expected ( v128.const i8x16 129 129 129 129 129 129 129 129 129 129 129 129 129 129 129 129 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 -126 -126 -126 -126 -126 -126 -126 -126 -126 -126 -126 -126 -126 -126 -126 -126 ) ( v128.const i8x16 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 )))
(local.set $expected ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 ) ( v128.const i8x16 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 )))
(local.set $expected ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 ) ( v128.const i8x16 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 )))
(local.set $expected ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 ) ( v128.const i8x16 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 )))
(local.set $expected ( v128.const i8x16 254 254 254 254 254 254 254 254 254 254 254 254 254 254 254 254 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 ) ( v128.const i8x16 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 )))
(local.set $expected ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 ) ( v128.const i8x16 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 )))
(local.set $expected ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ) ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 )))
(local.set $expected ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ) ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 )))
(local.set $expected ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ) ( v128.const i8x16 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 )))
(local.set $expected ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ) ( v128.const i8x16 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 )))
(local.set $expected ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ) ( v128.const i8x16 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 )))
(local.set $expected ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ) ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 )))
(local.set $expected ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0x3f 0x3f 0x3f 0x3f 0x3f 0x3f 0x3f 0x3f 0x3f 0x3f 0x3f 0x3f 0x3f 0x3f 0x3f 0x3f ) ( v128.const i8x16 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 )))
(local.set $expected ( v128.const i8x16 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 ) ( v128.const i8x16 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 )))
(local.set $expected ( v128.const i8x16 128 128 128 128 128 128 128 128 128 128 128 128 128 128 128 128 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 -0x3f -0x3f -0x3f -0x3f -0x3f -0x3f -0x3f -0x3f -0x3f -0x3f -0x3f -0x3f -0x3f -0x3f -0x3f -0x3f ) ( v128.const i8x16 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 )))
(local.set $expected ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 ) ( v128.const i8x16 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 )))
(local.set $expected ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 ) ( v128.const i8x16 -0x41 -0x41 -0x41 -0x41 -0x41 -0x41 -0x41 -0x41 -0x41 -0x41 -0x41 -0x41 -0x41 -0x41 -0x41 -0x41 )))
(local.set $expected ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f ) ( v128.const i8x16 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f )))
(local.set $expected ( v128.const i8x16 254 254 254 254 254 254 254 254 254 254 254 254 254 254 254 254 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f ) ( v128.const i8x16 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 )))
(local.set $expected ( v128.const i8x16 128 128 128 128 128 128 128 128 128 128 128 128 128 128 128 128 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 ) ( v128.const i8x16 -0x01 -0x01 -0x01 -0x01 -0x01 -0x01 -0x01 -0x01 -0x01 -0x01 -0x01 -0x01 -0x01 -0x01 -0x01 -0x01 )))
(local.set $expected ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f ) ( v128.const i8x16 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 )))
(local.set $expected ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 ) ( v128.const i8x16 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 )))
(local.set $expected ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff ) ( v128.const i8x16 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 )))
(local.set $expected ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff ) ( v128.const i8x16 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff )))
(local.set $expected ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 ) ( v128.const f32x4 -0.0 -0.0 -0.0 -0.0 )))
(local.set $expected ( v128.const i8x16 0x80 0x80 0x80 0xff 0x80 0x80 0x80 0xff 0x80 0x80 0x80 0xff 0x80 0x80 0x80 0xff ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ) ( v128.const f32x4 +inf +inf +inf +inf )))
(local.set $expected ( v128.const i8x16 0x01 0x01 0x81 0x80 0x01 0x01 0x81 0x80 0x01 0x01 0x81 0x80 0x01 0x01 0x81 0x80 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ) ( v128.const f32x4 -inf -inf -inf -inf )))
(local.set $expected ( v128.const i8x16 0x01 0x01 0x81 0xff 0x01 0x01 0x81 0xff 0x01 0x01 0x81 0xff 0x01 0x01 0x81 0xff ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ) ( v128.const f32x4 nan nan nan nan )))
(local.set $expected ( v128.const i8x16 0x01 0x01 0xc1 0x80 0x01 0x01 0xc1 0x80 0x01 0x01 0xc1 0x80 0x01 0x01 0xc1 0x80 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ) ( v128.const f32x4 -nan -nan -nan -nan )))
(local.set $expected ( v128.const i8x16 0x01 0x01 0xc1 0xff 0x01 0x01 0xc1 0xff 0x01 0x01 0xc1 0xff 0x01 0x01 0xc1 0xff ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 ) ( v128.const i8x16 0 0xff 0xfe 0xfd 0xfc 0xfb 0xfa 0xf9 0xf8 0xf7 0xf6 0xf5 0xf4 0xf3 0xf2 0xf1 )))
(local.set $expected ( v128.const i8x16 0 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.add_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 ) ( v128.const i8x16 0 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 )))
(local.set $expected ( v128.const i8x16 0 3 6 9 12 15 18 21 24 27 30 33 36 39 42 45 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ) ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 )))
(local.set $expected ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ) ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 )))
(local.set $expected ( v128.const i8x16 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ) ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 )))
(local.set $expected ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ) ( v128.const i8x16 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 )))
(local.set $expected ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ) ( v128.const i8x16 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 )))
(local.set $expected ( v128.const i8x16 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 ) ( v128.const i8x16 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 )))
(local.set $expected ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 63 63 63 63 63 63 63 63 63 63 63 63 63 63 63 63 ) ( v128.const i8x16 64 64 64 64 64 64 64 64 64 64 64 64 64 64 64 64 )))
(local.set $expected ( v128.const i8x16 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 64 64 64 64 64 64 64 64 64 64 64 64 64 64 64 64 ) ( v128.const i8x16 64 64 64 64 64 64 64 64 64 64 64 64 64 64 64 64 )))
(local.set $expected ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 -63 -63 -63 -63 -63 -63 -63 -63 -63 -63 -63 -63 -63 -63 -63 -63 ) ( v128.const i8x16 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 )))
(local.set $expected ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 ) ( v128.const i8x16 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 )))
(local.set $expected ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 -65 -65 -65 -65 -65 -65 -65 -65 -65 -65 -65 -65 -65 -65 -65 -65 ) ( v128.const i8x16 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 )))
(local.set $expected ( v128.const i8x16 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 125 125 125 125 125 125 125 125 125 125 125 125 125 125 125 125 ) ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 )))
(local.set $expected ( v128.const i8x16 124 124 124 124 124 124 124 124 124 124 124 124 124 124 124 124 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 126 126 126 126 126 126 126 126 126 126 126 126 126 126 126 126 ) ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 )))
(local.set $expected ( v128.const i8x16 125 125 125 125 125 125 125 125 125 125 125 125 125 125 125 125 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 128 128 128 128 128 128 128 128 128 128 128 128 128 128 128 128 ) ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 )))
(local.set $expected ( v128.const i8x16 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 -126 -126 -126 -126 -126 -126 -126 -126 -126 -126 -126 -126 -126 -126 -126 -126 ) ( v128.const i8x16 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 )))
(local.set $expected ( v128.const i8x16 -125 -125 -125 -125 -125 -125 -125 -125 -125 -125 -125 -125 -125 -125 -125 -125 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 ) ( v128.const i8x16 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 )))
(local.set $expected ( v128.const i8x16 -126 -126 -126 -126 -126 -126 -126 -126 -126 -126 -126 -126 -126 -126 -126 -126 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 ) ( v128.const i8x16 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 )))
(local.set $expected ( v128.const i8x16 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 ) ( v128.const i8x16 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 )))
(local.set $expected ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 ) ( v128.const i8x16 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 )))
(local.set $expected ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 ) ( v128.const i8x16 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 )))
(local.set $expected ( v128.const i8x16 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ) ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 )))
(local.set $expected ( v128.const i8x16 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ) ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 )))
(local.set $expected ( v128.const i8x16 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ) ( v128.const i8x16 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 )))
(local.set $expected ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ) ( v128.const i8x16 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 )))
(local.set $expected ( v128.const i8x16 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ) ( v128.const i8x16 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 )))
(local.set $expected ( v128.const i8x16 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ) ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 )))
(local.set $expected ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0x3f 0x3f 0x3f 0x3f 0x3f 0x3f 0x3f 0x3f 0x3f 0x3f 0x3f 0x3f 0x3f 0x3f 0x3f 0x3f ) ( v128.const i8x16 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 )))
(local.set $expected ( v128.const i8x16 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 ) ( v128.const i8x16 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 )))
(local.set $expected ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 -0x3f -0x3f -0x3f -0x3f -0x3f -0x3f -0x3f -0x3f -0x3f -0x3f -0x3f -0x3f -0x3f -0x3f -0x3f -0x3f ) ( v128.const i8x16 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 )))
(local.set $expected ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 ) ( v128.const i8x16 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 )))
(local.set $expected ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 ) ( v128.const i8x16 -0x41 -0x41 -0x41 -0x41 -0x41 -0x41 -0x41 -0x41 -0x41 -0x41 -0x41 -0x41 -0x41 -0x41 -0x41 -0x41 )))
(local.set $expected ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f ) ( v128.const i8x16 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f )))
(local.set $expected ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f ) ( v128.const i8x16 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 )))
(local.set $expected ( v128.const i8x16 126 126 126 126 126 126 126 126 126 126 126 126 126 126 126 126 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 ) ( v128.const i8x16 -0x01 -0x01 -0x01 -0x01 -0x01 -0x01 -0x01 -0x01 -0x01 -0x01 -0x01 -0x01 -0x01 -0x01 -0x01 -0x01 )))
(local.set $expected ( v128.const i8x16 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f ) ( v128.const i8x16 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 )))
(local.set $expected ( v128.const i8x16 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 ) ( v128.const i8x16 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 )))
(local.set $expected ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff ) ( v128.const i8x16 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 )))
(local.set $expected ( v128.const i8x16 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff ) ( v128.const i8x16 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff )))
(local.set $expected ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 ) ( v128.const f32x4 -0.0 -0.0 -0.0 -0.0 )))
(local.set $expected ( v128.const i8x16 0x80 0x80 0x80 0 0x80 0x80 0x80 0 0x80 0x80 0x80 0 0x80 0x80 0x80 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ) ( v128.const f32x4 +inf +inf +inf +inf )))
(local.set $expected ( v128.const i8x16 0x01 0x01 0x7f 0x82 0x01 0x01 0x7f 0x82 0x01 0x01 0x7f 0x82 0x01 0x01 0x7f 0x82 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ) ( v128.const f32x4 -inf -inf -inf -inf )))
(local.set $expected ( v128.const i8x16 0x01 0x01 0x7f 0x02 0x01 0x01 0x7f 0x02 0x01 0x01 0x7f 0x02 0x01 0x01 0x7f 0x02 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ) ( v128.const f32x4 nan nan nan nan )))
(local.set $expected ( v128.const i8x16 0x01 0x01 0x41 0x82 0x01 0x01 0x41 0x82 0x01 0x01 0x41 0x82 0x01 0x01 0x41 0x82 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ) ( v128.const f32x4 -nan -nan -nan -nan )))
(local.set $expected ( v128.const i8x16 0x01 0x01 0x41 0x02 0x01 0x01 0x41 0x02 0x01 0x01 0x41 0x02 0x01 0x01 0x41 0x02 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 ) ( v128.const i8x16 0 0xff 0xfe 0xfd 0xfc 0xfb 0xfa 0xf9 0xf8 0xf7 0xf6 0xf5 0xf4 0xf3 0xf2 0xf1 )))
(local.set $expected ( v128.const i8x16 0 0x02 0x04 0x06 0x08 0x0a 0x0c 0x0e 0x10 0x12 0x14 0x16 0x18 0x1a 0x1c 0x1e ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_s" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 ) ( v128.const i8x16 0 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 )))
(local.set $expected ( v128.const i8x16 0 -1 -2 -3 -4 -5 -6 -7 -8 -9 -10 -11 -12 -13 -14 -15 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ) ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 )))
(local.set $expected ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ) ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 )))
(local.set $expected ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ) ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 )))
(local.set $expected ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ) ( v128.const i8x16 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 )))
(local.set $expected ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ) ( v128.const i8x16 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 )))
(local.set $expected ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 ) ( v128.const i8x16 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 )))
(local.set $expected ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 63 63 63 63 63 63 63 63 63 63 63 63 63 63 63 63 ) ( v128.const i8x16 64 64 64 64 64 64 64 64 64 64 64 64 64 64 64 64 )))
(local.set $expected ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 64 64 64 64 64 64 64 64 64 64 64 64 64 64 64 64 ) ( v128.const i8x16 64 64 64 64 64 64 64 64 64 64 64 64 64 64 64 64 )))
(local.set $expected ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 -63 -63 -63 -63 -63 -63 -63 -63 -63 -63 -63 -63 -63 -63 -63 -63 ) ( v128.const i8x16 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 )))
(local.set $expected ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 ) ( v128.const i8x16 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 )))
(local.set $expected ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 -65 -65 -65 -65 -65 -65 -65 -65 -65 -65 -65 -65 -65 -65 -65 -65 ) ( v128.const i8x16 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 -64 )))
(local.set $expected ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 125 125 125 125 125 125 125 125 125 125 125 125 125 125 125 125 ) ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 )))
(local.set $expected ( v128.const i8x16 124 124 124 124 124 124 124 124 124 124 124 124 124 124 124 124 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 126 126 126 126 126 126 126 126 126 126 126 126 126 126 126 126 ) ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 )))
(local.set $expected ( v128.const i8x16 125 125 125 125 125 125 125 125 125 125 125 125 125 125 125 125 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 128 128 128 128 128 128 128 128 128 128 128 128 128 128 128 128 ) ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 )))
(local.set $expected ( v128.const i8x16 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 -126 -126 -126 -126 -126 -126 -126 -126 -126 -126 -126 -126 -126 -126 -126 -126 ) ( v128.const i8x16 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 )))
(local.set $expected ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 ) ( v128.const i8x16 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 )))
(local.set $expected ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 ) ( v128.const i8x16 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 )))
(local.set $expected ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 ) ( v128.const i8x16 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 )))
(local.set $expected ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 ) ( v128.const i8x16 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 )))
(local.set $expected ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 ) ( v128.const i8x16 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 -127 )))
(local.set $expected ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ) ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 )))
(local.set $expected ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ) ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 )))
(local.set $expected ( v128.const i8x16 254 254 254 254 254 254 254 254 254 254 254 254 254 254 254 254 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ) ( v128.const i8x16 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 )))
(local.set $expected ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ) ( v128.const i8x16 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 )))
(local.set $expected ( v128.const i8x16 128 128 128 128 128 128 128 128 128 128 128 128 128 128 128 128 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ) ( v128.const i8x16 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 )))
(local.set $expected ( v128.const i8x16 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ) ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 )))
(local.set $expected ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0x3f 0x3f 0x3f 0x3f 0x3f 0x3f 0x3f 0x3f 0x3f 0x3f 0x3f 0x3f 0x3f 0x3f 0x3f 0x3f ) ( v128.const i8x16 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 )))
(local.set $expected ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 ) ( v128.const i8x16 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 0x40 )))
(local.set $expected ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 -0x3f -0x3f -0x3f -0x3f -0x3f -0x3f -0x3f -0x3f -0x3f -0x3f -0x3f -0x3f -0x3f -0x3f -0x3f -0x3f ) ( v128.const i8x16 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 )))
(local.set $expected ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 ) ( v128.const i8x16 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 )))
(local.set $expected ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 -0x40 ) ( v128.const i8x16 -0x41 -0x41 -0x41 -0x41 -0x41 -0x41 -0x41 -0x41 -0x41 -0x41 -0x41 -0x41 -0x41 -0x41 -0x41 -0x41 )))
(local.set $expected ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f ) ( v128.const i8x16 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f )))
(local.set $expected ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f ) ( v128.const i8x16 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 )))
(local.set $expected ( v128.const i8x16 126 126 126 126 126 126 126 126 126 126 126 126 126 126 126 126 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 ) ( v128.const i8x16 -0x01 -0x01 -0x01 -0x01 -0x01 -0x01 -0x01 -0x01 -0x01 -0x01 -0x01 -0x01 -0x01 -0x01 -0x01 -0x01 )))
(local.set $expected ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f 0x7f ) ( v128.const i8x16 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 )))
(local.set $expected ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 ) ( v128.const i8x16 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 )))
(local.set $expected ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff ) ( v128.const i8x16 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 )))
(local.set $expected ( v128.const i8x16 254 254 254 254 254 254 254 254 254 254 254 254 254 254 254 254 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff ) ( v128.const i8x16 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff )))
(local.set $expected ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 0x80 ) ( v128.const f32x4 -0.0 -0.0 -0.0 -0.0 )))
(local.set $expected ( v128.const i8x16 0x80 0x80 0x80 0 0x80 0x80 0x80 0 0x80 0x80 0x80 0 0x80 0x80 0x80 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ) ( v128.const f32x4 +inf +inf +inf +inf )))
(local.set $expected ( v128.const i8x16 0x01 0x01 0 0 0x01 0x01 0 0 0x01 0x01 0 0 0x01 0x01 0 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ) ( v128.const f32x4 -inf -inf -inf -inf )))
(local.set $expected ( v128.const i8x16 0x01 0x01 0 0 0x01 0x01 0 0 0x01 0x01 0 0 0x01 0x01 0 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ) ( v128.const f32x4 nan nan nan nan )))
(local.set $expected ( v128.const i8x16 0x01 0x01 0 0 0x01 0x01 0 0 0x01 0x01 0 0 0x01 0x01 0 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ) ( v128.const f32x4 -nan -nan -nan -nan )))
(local.set $expected ( v128.const i8x16 0x01 0x01 0 0 0x01 0x01 0 0 0x01 0x01 0 0 0x01 0x01 0 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 ) ( v128.const i8x16 0 0xff 0xfe 0xfd 0xfc 0xfb 0xfa 0xf9 0xf8 0xf7 0xf6 0xf5 0xf4 0xf3 0xf2 0xf1 )))
(local.set $expected ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "i8x16.sub_saturate_u" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 ) ( v128.const i8x16 0 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 )))
(local.set $expected ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var thrown = false;
var saved;
try { wasmTextToBinary(`
(module 
(func (result v128) (i8x16.add_saturate (v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1) (v128.const i8x16 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2))))
`) } catch (e) { thrown = true; saved = e; }
assertEq(thrown, true)
assertEq(saved instanceof SyntaxError, true)
var thrown = false;
var saved;
try { wasmTextToBinary(`
(module 
(func (result v128) (i8x16.sub_saturate (v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1) (v128.const i8x16 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2))))
`) } catch (e) { thrown = true; saved = e; }
assertEq(thrown, true)
assertEq(saved instanceof SyntaxError, true)
var thrown = false;
var saved;
try { wasmTextToBinary(`
(module 
(func (result v128) (i8x16.mul_saturate (v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1) (v128.const i8x16 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2))))
`) } catch (e) { thrown = true; saved = e; }
assertEq(thrown, true)
assertEq(saved instanceof SyntaxError, true)
var thrown = false;
var saved;
try { wasmTextToBinary(`
(module 
(func (result v128) (i8x16.div_saturate (v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1) (v128.const i8x16 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2))))
`) } catch (e) { thrown = true; saved = e; }
assertEq(thrown, true)
assertEq(saved instanceof SyntaxError, true)
var thrown = false;
var saved;
try { wasmTextToBinary(`
(module 
(func (result v128) (i32x4.add_saturate_s (v128.const i32x4 0 0 0 0) (v128.const i32x4 0 0 0 0))))
`) } catch (e) { thrown = true; saved = e; }
assertEq(thrown, true)
assertEq(saved instanceof SyntaxError, true)
var thrown = false;
var saved;
try { wasmTextToBinary(`
(module 
(func (result v128) (i32x4.add_saturate_u (v128.const i32x4 0 0 0 0) (v128.const i32x4 0 0 0 0))))
`) } catch (e) { thrown = true; saved = e; }
assertEq(thrown, true)
assertEq(saved instanceof SyntaxError, true)
var thrown = false;
var saved;
try { wasmTextToBinary(`
(module 
(func (result v128) (i32x4.sub_saturate_s (v128.const i32x4 0 0 0 0) (v128.const i32x4 0 0 0 0))))
`) } catch (e) { thrown = true; saved = e; }
assertEq(thrown, true)
assertEq(saved instanceof SyntaxError, true)
var thrown = false;
var saved;
try { wasmTextToBinary(`
(module 
(func (result v128) (i32x4.sub_saturate_u (v128.const i32x4 0 0 0 0) (v128.const i32x4 0 0 0 0))))
`) } catch (e) { thrown = true; saved = e; }
assertEq(thrown, true)
assertEq(saved instanceof SyntaxError, true)
var thrown = false;
var saved;
try { wasmTextToBinary(`
(module 
(func (result v128) (f32x4.add_saturate_s (v128.const f32x4 0 0 0 0) (v128.const f32x4 0 0 0 0))))
`) } catch (e) { thrown = true; saved = e; }
assertEq(thrown, true)
assertEq(saved instanceof SyntaxError, true)
var thrown = false;
var saved;
try { wasmTextToBinary(`
(module 
(func (result v128) (f32x4.add_saturate_u (v128.const f32x4 0 0 0 0) (v128.const f32x4 0 0 0 0))))
`) } catch (e) { thrown = true; saved = e; }
assertEq(thrown, true)
assertEq(saved instanceof SyntaxError, true)
var thrown = false;
var saved;
try { wasmTextToBinary(`
(module 
(func (result v128) (f32x4.sub_saturate_s (v128.const f32x4 0 0 0 0) (v128.const f32x4 0 0 0 0))))
`) } catch (e) { thrown = true; saved = e; }
assertEq(thrown, true)
assertEq(saved instanceof SyntaxError, true)
var thrown = false;
var saved;
try { wasmTextToBinary(`
(module 
(func (result v128) (f32x4.sub_saturate_u (v128.const f32x4 0 0 0 0) (v128.const f32x4 0 0 0 0))))
`) } catch (e) { thrown = true; saved = e; }
assertEq(thrown, true)
assertEq(saved instanceof SyntaxError, true)
var thrown = false;
var saved;
var bin = wasmTextToBinary(`
( module ( func ( result v128 ) ( i8x16.add_saturate_s ( i32.const 0 ) ( f32.const 0.0 ) ) ) )
`);
assertEq(WebAssembly.validate(bin), false);
try { new WebAssembly.Module(bin) } catch (e) { thrown = true; saved = e; }
assertEq(thrown, true)
assertEq(saved instanceof WebAssembly.CompileError, true)
var thrown = false;
var saved;
var bin = wasmTextToBinary(`
( module ( func ( result v128 ) ( i8x16.add_saturate_u ( i32.const 0 ) ( f32.const 0.0 ) ) ) )
`);
assertEq(WebAssembly.validate(bin), false);
try { new WebAssembly.Module(bin) } catch (e) { thrown = true; saved = e; }
assertEq(thrown, true)
assertEq(saved instanceof WebAssembly.CompileError, true)
var thrown = false;
var saved;
var bin = wasmTextToBinary(`
( module ( func ( result v128 ) ( i8x16.sub_saturate_s ( i32.const 0 ) ( f32.const 0.0 ) ) ) )
`);
assertEq(WebAssembly.validate(bin), false);
try { new WebAssembly.Module(bin) } catch (e) { thrown = true; saved = e; }
assertEq(thrown, true)
assertEq(saved instanceof WebAssembly.CompileError, true)
var thrown = false;
var saved;
var bin = wasmTextToBinary(`
( module ( func ( result v128 ) ( i8x16.sub_saturate_u ( i32.const 0 ) ( f32.const 0.0 ) ) ) )
`);
assertEq(WebAssembly.validate(bin), false);
try { new WebAssembly.Module(bin) } catch (e) { thrown = true; saved = e; }
assertEq(thrown, true)
assertEq(saved instanceof WebAssembly.CompileError, true)
var thrown = false;
var saved;
var bin = wasmTextToBinary(`
( module ( func $i8x16.add_saturate_s-1st-arg-empty ( result v128 ) ( i8x16.add_saturate_s ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ) ) ) )
`);
assertEq(WebAssembly.validate(bin), false);
try { new WebAssembly.Module(bin) } catch (e) { thrown = true; saved = e; }
assertEq(thrown, true)
assertEq(saved instanceof WebAssembly.CompileError, true)
var thrown = false;
var saved;
var bin = wasmTextToBinary(`
( module ( func $i8x16.add_saturate_s-arg-empty ( result v128 ) ( i8x16.add_saturate_s ) ) )
`);
assertEq(WebAssembly.validate(bin), false);
try { new WebAssembly.Module(bin) } catch (e) { thrown = true; saved = e; }
assertEq(thrown, true)
assertEq(saved instanceof WebAssembly.CompileError, true)
var thrown = false;
var saved;
var bin = wasmTextToBinary(`
( module ( func $i8x16.add_saturate_u-1st-arg-empty ( result v128 ) ( i8x16.add_saturate_u ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ) ) ) )
`);
assertEq(WebAssembly.validate(bin), false);
try { new WebAssembly.Module(bin) } catch (e) { thrown = true; saved = e; }
assertEq(thrown, true)
assertEq(saved instanceof WebAssembly.CompileError, true)
var thrown = false;
var saved;
var bin = wasmTextToBinary(`
( module ( func $i8x16.add_saturate_u-arg-empty ( result v128 ) ( i8x16.add_saturate_u ) ) )
`);
assertEq(WebAssembly.validate(bin), false);
try { new WebAssembly.Module(bin) } catch (e) { thrown = true; saved = e; }
assertEq(thrown, true)
assertEq(saved instanceof WebAssembly.CompileError, true)
var thrown = false;
var saved;
var bin = wasmTextToBinary(`
( module ( func $i8x16.sub_saturate_s-1st-arg-empty ( result v128 ) ( i8x16.sub_saturate_s ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ) ) ) )
`);
assertEq(WebAssembly.validate(bin), false);
try { new WebAssembly.Module(bin) } catch (e) { thrown = true; saved = e; }
assertEq(thrown, true)
assertEq(saved instanceof WebAssembly.CompileError, true)
var thrown = false;
var saved;
var bin = wasmTextToBinary(`
( module ( func $i8x16.sub_saturate_s-arg-empty ( result v128 ) ( i8x16.sub_saturate_s ) ) )
`);
assertEq(WebAssembly.validate(bin), false);
try { new WebAssembly.Module(bin) } catch (e) { thrown = true; saved = e; }
assertEq(thrown, true)
assertEq(saved instanceof WebAssembly.CompileError, true)
var thrown = false;
var saved;
var bin = wasmTextToBinary(`
( module ( func $i8x16.sub_saturate_u-1st-arg-empty ( result v128 ) ( i8x16.sub_saturate_u ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ) ) ) )
`);
assertEq(WebAssembly.validate(bin), false);
try { new WebAssembly.Module(bin) } catch (e) { thrown = true; saved = e; }
assertEq(thrown, true)
assertEq(saved instanceof WebAssembly.CompileError, true)
var thrown = false;
var saved;
var bin = wasmTextToBinary(`
( module ( func $i8x16.sub_saturate_u-arg-empty ( result v128 ) ( i8x16.sub_saturate_u ) ) )
`);
assertEq(WebAssembly.validate(bin), false);
try { new WebAssembly.Module(bin) } catch (e) { thrown = true; saved = e; }
assertEq(thrown, true)
assertEq(saved instanceof WebAssembly.CompileError, true)
var ins = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`
( module ( func ( export "sat-add_s-sub_s" ) ( param v128 v128 v128 ) ( result v128 ) ( i8x16.add_saturate_s ( i8x16.sub_saturate_s ( local.get 0 ) ( local.get 1 ) ) ( local.get 2 ) ) ) ( func ( export "sat-add_s-sub_u" ) ( param v128 v128 v128 ) ( result v128 ) ( i8x16.add_saturate_s ( i8x16.sub_saturate_u ( local.get 0 ) ( local.get 1 ) ) ( local.get 2 ) ) ) ( func ( export "sat-add_u-sub_s" ) ( param v128 v128 v128 ) ( result v128 ) ( i8x16.add_saturate_u ( i8x16.sub_saturate_s ( local.get 0 ) ( local.get 1 ) ) ( local.get 2 ) ) ) ( func ( export "sat-add_u-sub_u" ) ( param v128 v128 v128 ) ( result v128 ) ( i8x16.add_saturate_u ( i8x16.sub_saturate_u ( local.get 0 ) ( local.get 1 ) ) ( local.get 2 ) ) ) ( func ( export "sat-add_s-neg" ) ( param v128 v128 ) ( result v128 ) ( i8x16.add_saturate_s ( i8x16.neg ( local.get 0 ) ) ( local.get 1 ) ) ) ( func ( export "sat-add_u-neg" ) ( param v128 v128 ) ( result v128 ) ( i8x16.add_saturate_u ( i8x16.neg ( local.get 0 ) ) ( local.get 1 ) ) ) ( func ( export "sat-sub_s-neg" ) ( param v128 v128 ) ( result v128 ) ( i8x16.sub_saturate_s ( i8x16.neg ( local.get 0 ) ) ( local.get 1 ) ) ) ( func ( export "sat-sub_u-neg" ) ( param v128 v128 ) ( result v128 ) ( i8x16.sub_saturate_u ( i8x16.neg ( local.get 0 ) ) ( local.get 1 ) ) ) )
`)));
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "sat-add_s-sub_s" (func $f (param v128 v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 64 64 64 64 64 64 64 64 64 64 64 64 64 64 64 64 ) ( v128.const i8x16 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 ) ( v128.const i8x16 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 )))
(local.set $expected ( v128.const i8x16 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "sat-add_s-sub_u" (func $f (param v128 v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ) ( v128.const i8x16 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 ) ( v128.const i8x16 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 )))
(local.set $expected ( v128.const i8x16 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "sat-add_u-sub_s" (func $f (param v128 v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 ) ( v128.const i8x16 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 ) ( v128.const i8x16 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 )))
(local.set $expected ( v128.const i8x16 254 254 254 254 254 254 254 254 254 254 254 254 254 254 254 254 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "sat-add_u-sub_u" (func $f (param v128 v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ) ( v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ) ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 )))
(local.set $expected ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "sat-add_s-neg" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 ) ( v128.const i8x16 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 )))
(local.set $expected ( v128.const i8x16 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "sat-add_u-neg" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 ) ( v128.const i8x16 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 )))
(local.set $expected ( v128.const i8x16 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "sat-sub_s-neg" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 ) ( v128.const i8x16 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 )))
(local.set $expected ( v128.const i8x16 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)
var run = new WebAssembly.Instance(new WebAssembly.Module(wasmTextToBinary(`

(module
  (import "" "sat-sub_u-neg" (func $f (param v128 v128) (result v128)))
  (func (export "run") (result i32) 
(local $result v128)
(local $expected v128)
(local $cmpresult v128)

(local.set $result (call $f ( v128.const i8x16 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 ) ( v128.const i8x16 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 )))
(local.set $expected ( v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ))

(local.set $cmpresult (i8x16.eq (local.get $result) (local.get $expected)))
(i8x16.all_true (local.get $cmpresult))))

`)), {'':ins.exports});
assertEq(run.exports.run(), 1)

